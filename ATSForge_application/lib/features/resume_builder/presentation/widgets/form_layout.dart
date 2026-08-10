import 'package:flutter/material.dart';

class FormPair extends StatelessWidget {
  const FormPair({required this.children, super.key});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 540) {
          return Column(
              children: children
                  .map((child) => Padding(
                      padding: const EdgeInsets.only(bottom: 13), child: child))
                  .toList());
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (var i = 0; i < children.length; i++) ...[
            Expanded(child: children[i]),
            if (i < children.length - 1) const SizedBox(width: 13)
          ]
        ]);
      });
}

class WritingTip extends StatelessWidget {
  const WritingTip({required this.title, required this.body, super.key});
  final String title, body;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
            color: const Color(0xFFF1F5EB),
            borderRadius: BorderRadius.circular(8),
            border: const Border(
                left: BorderSide(color: Color(0xFF9CBA4F), width: 3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(body)
        ]),
      );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {required this.step, required this.title, super.key, this.action});
  final int step;
  final String title;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 22),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('STEP $step OF 5',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF235F47))),
                const SizedBox(height: 5),
                Text(title, style: Theme.of(context).textTheme.headlineMedium)
              ])),
          if (action != null) action!
        ]),
      );
}
