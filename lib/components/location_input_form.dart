import 'package:flutter/material.dart';

import 'package:geocoder/geocoder.dart';

import '../utils/address.dart';

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
            decoration: InputDecoration(helperText: "Address"),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            
            // Submit button
            child: RaisedButton(
              child: Text("Submit"),

              onPressed: _onSubmit,
            ),
          )
        ],
      ),
    );
  }



  /// Called uppon submission of the form to validate the address
  void _onSubmit() {
    // First, we check if the form is valid
    if (_formKey.currentState.validate()) {
      final String address = _addressEditController.text;  // Gather address from input field

      convertAddressToCoordinates(address)
        .then((Coordinates coords) {  // If address is OK
          widget.onSubmit(coords);  // Callback function from the parent
        })
        .catchError((error) {  // If address is not OK
          _showSnackBar(content: error.toString());
        });
    }
  }


  /// Displays a SnackBar with passed content for passed duration (defaut: 1.5s)
  void _showSnackBar({@required String content, int displayTime = 1500}) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: displayTime),
    ));
  }
}



