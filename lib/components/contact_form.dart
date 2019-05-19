import 'package:flutter/material.dart';

import '../models/contact.dart';

/// Form to add a new contact to the list
class ContactForm extends StatelessWidget {

  final Function onSubmit;

  final TextEditingController inputController = TextEditingController();


  ContactForm({Key key, @required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: inputController,
                autocorrect: true,
                autofocus: false,
                maxLength: 120,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  hintText: "Contact phone number"
                ),
              ),
            )
          ),

          RaisedButton(
            child: Icon(Icons.add, color: Theme.of(context).accentIconTheme.color),
            onPressed: () {
              String phoneNumber = inputController.text;

              onSubmit(Contact(picture: null, name: phoneNumber));
            },
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(90)),
          )
        ],
      ),
    );
  }
}