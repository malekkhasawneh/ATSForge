import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/resume.dart';
import '../../domain/repositories/resume_repository.dart';

part 'resume_builder_state.dart';

class ResumeBuilderCubit extends Cubit<ResumeBuilderState> {
  ResumeBuilderCubit(this.repository) : super(const ResumeBuilderState());
  final ResumeRepository repository;
  Timer? _analysisTimer;

  Future<void> initialize({String? template}) async {
    final draft = await repository.loadDraft();
    var resume = draft ??
        const Resume(
            experience: [ExperienceEntry()], education: [EducationEntry()]);
    if (template != null) resume = resume.copyWith(template: template);
    emit(state.copyWith(status: ResumeBuilderStatus.ready, resume: resume));
    _scheduleAnalysis();
  }

  void selectTemplate(String template) =>
      _change(state.resume.copyWith(template: template));
  void goToStep(int step) =>
      emit(state.copyWith(step: step.clamp(0, 4), clearMessage: true));
  void next() => goToStep(state.step + 1);
  void previous() => goToStep(state.step - 1);

  void updateBasic(String field, String value) {
    final b = state.resume.basics;
    final updated = switch (field) {
      'name' => b.copyWith(name: value),
      'title' => b.copyWith(title: value),
      'email' => b.copyWith(email: value),
      'phone' => b.copyWith(phone: value),
      'location' => b.copyWith(location: value),
      'linkedin' => b.copyWith(linkedin: value),
      'summary' => b.copyWith(summary: value),
      _ => b,
    };
    _change(state.resume.copyWith(basics: updated));
  }

  void addExperience() => _change(state.resume.copyWith(
      experience: [...state.resume.experience, const ExperienceEntry()]));
  void removeExperience(int index) => _change(state.resume
      .copyWith(experience: [...state.resume.experience]..removeAt(index)));
  void updateExperience(int index, String field, String value) {
    final items = [...state.resume.experience];
    final e = items[index];
    items[index] = switch (field) {
      'title' => e.copyWith(title: value),
      'company' => e.copyWith(company: value),
      'location' => e.copyWith(location: value),
      'start' => e.copyWith(start: value),
      'end' => e.copyWith(end: value),
      'highlights' => e.copyWith(highlights: value),
      _ => e,
    };
    _change(state.resume.copyWith(experience: items));
  }

  void addEducation() => _change(state.resume.copyWith(
      education: [...state.resume.education, const EducationEntry()]));
  void removeEducation(int index) => _change(state.resume
      .copyWith(education: [...state.resume.education]..removeAt(index)));
  void updateEducation(int index, String field, String value) {
    final items = [...state.resume.education];
    final e = items[index];
    items[index] = switch (field) {
      'degree' => e.copyWith(degree: value),
      'school' => e.copyWith(school: value),
      'location' => e.copyWith(location: value),
      'start' => e.copyWith(start: value),
      'end' => e.copyWith(end: value),
      'details' => e.copyWith(details: value),
      _ => e,
    };
    _change(state.resume.copyWith(education: items));
  }

  void addProject() => _change(state.resume
      .copyWith(projects: [...state.resume.projects, const ProjectEntry()]));
  void removeProject(int index) => _change(state.resume
      .copyWith(projects: [...state.resume.projects]..removeAt(index)));
  void updateProject(int index, String field, String value) {
    final items = [...state.resume.projects];
    final e = items[index];
    items[index] = switch (field) {
      'name' => e.copyWith(name: value),
      'link' => e.copyWith(link: value),
      'description' => e.copyWith(description: value),
      _ => e
    };
    _change(state.resume.copyWith(projects: items));
  }

  void updateSkills(String value) =>
      _change(state.resume.copyWith(skills: _csv(value)));
  void updateLanguages(String value) =>
      _change(state.resume.copyWith(languages: _csv(value)));

  Future<void> export(String type) async {
    emit(state.copyWith(
        status: ResumeBuilderStatus.exporting,
        clearMessage: true,
        clearFile: true));
    try {
      final file = await repository.export(state.resume, type);
      emit(state.copyWith(
          status: ResumeBuilderStatus.ready,
          exportedFile: file,
          clearMessage: true));
    } on AppException catch (error) {
      emit(state.copyWith(
          status: ResumeBuilderStatus.failure, message: error.message));
    } catch (_) {
      emit(state.copyWith(
          status: ResumeBuilderStatus.failure,
          message: 'The document could not be created.'));
    }
  }

  Future<void> clearDraft() async {
    await repository.clearDraft();
    emit(const ResumeBuilderState(
        status: ResumeBuilderStatus.ready,
        resume: Resume(
            experience: [ExperienceEntry()], education: [EducationEntry()])));
  }

  void _change(Resume resume) {
    emit(state.copyWith(
        status: ResumeBuilderStatus.ready,
        resume: resume,
        clearMessage: true,
        clearFile: true));
    repository.saveDraft(resume);
    _scheduleAnalysis();
  }

  void _scheduleAnalysis() {
    _analysisTimer?.cancel();
    _analysisTimer = Timer(const Duration(milliseconds: 650), _analyze);
  }

  Future<void> _analyze() async {
    try {
      final result = await repository.analyze(state.resume);
      emit(state.copyWith(status: ResumeBuilderStatus.ready, analysis: result));
    } catch (_) {/* Editing remains available offline. */}
  }

  List<String> _csv(String value) =>
      value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  @override
  Future<void> close() {
    _analysisTimer?.cancel();
    return super.close();
  }
}
