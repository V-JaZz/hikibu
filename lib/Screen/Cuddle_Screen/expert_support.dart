import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../services/storage.dart';

class ContactForm extends StatefulWidget {
  final String courseId;
  const ContactForm({super.key, required this.courseId});

  @override
  ContactFormState createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  String? platformResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EXPERT SUPPORT'.tr()),
      ),
      body: Form(
        key: _formKey,
        child: platformResponse!=null
            ?Center(child: Text(platformResponse!,style: const TextStyle(color: Colors.black,fontSize: 18),))
            :ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                10.heightBox,
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(labelText: 'Name',border: OutlineInputBorder()),
                  validator: (value) {
                    if ((value??'').isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                10.heightBox,
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email',border: OutlineInputBorder()),
                  validator: (value) {
                    if ((value??'').isEmpty || !(value??'').contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                10.heightBox,
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Phone Number',border: OutlineInputBorder()),
                  validator: (value) {
                    if ((value??'').isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                10.heightBox,
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Topic/Title',border: OutlineInputBorder()),
                  validator: (value) {
                    if ((value??'').isEmpty) {
                      return 'Please enter a topic/title';
                    }
                    return null;
                  },
                ),
                10.heightBox,
                TextFormField(
                  controller: questionController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Question',border: OutlineInputBorder()),
                  validator: (value) {
                    if ((value??'').isEmpty) {
                      return 'Please enter your question';
                    }
                    return null;
                  },
                ),
                20.heightBox,
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Send the details via email to bilgi6655@gmail.com
                      sendEmail();
                    }
                  },
                  child: Text('send'.tr()),
                ),
                20.heightBox,
          ],
        ),
      ),
    );
  }

  void sendEmail() async {
    // Implement the email sending logic here
    String name = nameController.text;
    String phoneNumber = phoneNumberController.text;
    String title = titleController.text;
    String question = questionController.text;

    // You can use an email plugin like 'mailer' or 'flutter_email_sender' to send the email.
    // Example code for sending an email using the 'mailer' package:
    // More details on how to use it: https://pub.dev/packages/mailer

    /* final smtpServer = SmtpServer('your_smtp_server.com',
      username: 'your_username',
      password: 'your_password',
    );

    final message = Message()
      ..from = Address('your_email@example.com', 'Your Name')
      ..recipients.add('bilgi6655@gmail.com')
      ..subject = 'Contact Form Submission: $title'
      ..text = 'Name: $name\n'
          'Email: $email\n'
          'Phone Number: $phoneNumber\n'
          'Title: $title\n'
          'Question: $question';

    try {
      send(message, smtpServer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email sent successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email sending failed: $e'),
        ),
      );
    } */

    const GMAIL_SCHEMA = 'com.google.android.gm';

    final bool gmailinstalled =  await FlutterMailer.isAppInstalled(GMAIL_SCHEMA);

    if(gmailinstalled) {

      final MailOptions mailOptions = MailOptions(
          body: 'Name: $name\n'
              'Phone Number: $phoneNumber\n'
              'Title: $title\n'
              'Question: $question',
          subject: 'Contact Form Submission: User(${StorageService.to.getString('userIdKey')}), Course(${widget.courseId})',
          recipients: ['bilgi6655@gmail.com']
      );

      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved: /// ios only
          platformResponse = 'Mail was saved to draft';
          break;
        case MailerResponse.sent: /// ios only
          platformResponse = 'Mail was sent';
          break;
        case MailerResponse.cancelled: /// ios only
          platformResponse = 'Mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'Intent was successful';
          break;
        default:
          platformResponse = 'Unknown';
          break;
      }
      setState(() {
      });
    }
  }
}
