import 'package:flutter/material.dart';

class DataPoint extends StatelessWidget {
  final String label;
  final String value;

  const DataPoint({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color.fromRGBO(0, 0, 0, 0.68),
            fontSize: 14,
            fontWeight: FontWeight.normal),
        children: <TextSpan>[
          TextSpan(text: label),
          TextSpan(
            text: value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF1C2649),
                ),
          ),
        ],
      ),
    );
  }
}
