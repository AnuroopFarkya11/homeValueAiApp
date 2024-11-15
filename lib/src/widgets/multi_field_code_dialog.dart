import 'package:flutter/material.dart';

class MultiFieldCodeDialog extends StatefulWidget {
  @override
  _MultiFieldCodeDialogState createState() => _MultiFieldCodeDialogState();
}

class _MultiFieldCodeDialogState extends State<MultiFieldCodeDialog> {
  final List<TextEditingController> _controllers =
      List.generate(9, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(9, (_) => FocusNode());
  final List<int> _fieldLengths = [4, 4, 3, 4, 4, 4, 4, 4, 4];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter Ngrok Code"),
      content: Form(
        key: _formKey,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(_controllers.length, (index) {
            return SizedBox(
              width: 70,
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                maxLength: _fieldLengths[index],
                decoration: InputDecoration(
                  counterText: "", // Hide counter text
                  border: OutlineInputBorder(),
                  hintText: "-" * _fieldLengths[index], // Example: "----"
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  if (value.length == _fieldLengths[index] &&
                      index < _focusNodes.length - 1) {
                    _focusNodes[index].unfocus(); // Unfocus current
                    FocusScope.of(context)
                        .requestFocus(_focusNodes[index + 1]); // Focus next
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  if (!RegExp(r'^[a-fA-F0-9]+$').hasMatch(value)) {
                    return "Invalid";
                  }
                  if (value.length != _fieldLengths[index]) {
                    return "Must be ${_fieldLengths[index]} characters";
                  }
                  return null;
                },
              ),
            );
          }),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final code =
                  _controllers.map((controller) => controller.text).join("-");
              Navigator.pop(context, code);
            }
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
