import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FAQs extends StatelessWidget {
  final Uri _url = Uri.parse('https://www.cookpad.com/faq');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.5, // ekranın tamamını kaplamasın diye
      child: Center(
        child: ElevatedButton(
          onPressed: _launchUrl,
          child: Text('FREQUENTLY ASKED QUESTIONS'),
        ),
      ),
    );
  }
}