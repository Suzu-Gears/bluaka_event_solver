import 'package:bluaka_event_solver/importer.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final int flex;
  final bool enabled;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  const CustomTextField({
    required this.controller,
    required this.flex,
    required this.enabled,
    required this.decoration,
    required this.keyboardType,
    required this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: decoration,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
