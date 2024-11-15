import 'package:flutter/material.dart';
import 'package:house_prediction/src/screen/detail/property_form_service.dart';

class PropertyForm extends StatefulWidget {
  final String location;

  const PropertyForm(this.location, {super.key});

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  final PropertyFormService service = PropertyFormService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController sqrtFeetController = TextEditingController();
  final TextEditingController bhkController = TextEditingController();
  final TextEditingController bathController = TextEditingController();
  double price = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location : ${widget.location}",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: sqrtFeetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Total Square Feet",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter total square feet";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bhkController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "BHK (e.g., 2, 3)",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter BHK value";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bathController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Bathroom (e.g., 2, 3)",
                      filled: true,
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter number of bathrooms";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Form Submitted")),
                          );
                          double sqrt = double.parse(sqrtFeetController.text);
                          int bhk = int.parse(bhkController.text);
                          int bath = int.parse(bathController.text);

                          await service
                              .predict(sqrt, widget.location, bhk, bath)
                              .then((value) {
                            setState(() {
                              price = value;
                            });
                          });
                        }
                      },
                      child: const Text("Continue"),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Visibility(
                      visible: price != 0.0,
                      child: Text("Property Rate: Rs. $price Lakhs ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
