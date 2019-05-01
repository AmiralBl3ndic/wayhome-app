import 'package:flutter/material.dart';


class LocationInputForm extends StatefulWidget {
  /// Custom callback function that is called when the form is submitted
  final Function onSubmit;

  /// Content that is already typed in the form
  final String fieldContent;

  /// Instantiates a LocationInputForm with a custom callback on submission
  LocationInputForm({Key key, @required this.onSubmit, this.fieldContent});

  @override
  State<StatefulWidget> createState() => _LocationInputFormState();
}


class _LocationInputFormState extends State<LocationInputForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _addressEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.fieldContent.isNotEmpty) {
      _addressEditController.text = widget.fieldContent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          // Address input field
          TextFormField(
            controller: _addressEditController,
            autocorrect: false,
            autofocus: false,
            validator: (String value) {
              if (value.isEmpty) {
                return "Please type in an address";
              }
            },
            decoration: InputDecoration(
              helperText: "Address",
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            
            // Submit button
            child: RaisedButton(
              child: Text("Submit"),

              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget.onSubmit(_addressEditController.text);
                }
              },
            ),
          )
        ],
      ),
    );
  }

}



