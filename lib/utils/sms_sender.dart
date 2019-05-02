import 'package:flutter_sms/flutter_sms.dart';

void sendSmsToContacts(String message, List<String> phoneNb) async {
  //send the SMS to the list of contact
  
    String _result = await FlutterSms
          .sendSMS(message: message, recipients: phoneNb)
          .catchError((onError) {
          });
  //print(_result);
}
  
// A l'exterieur de la fonction:
//String message = "This is a test message!";
//List<String> phoneNb = ["0611111111", "0622222222"];
//sendSmsToContact(message, phoneNb);


