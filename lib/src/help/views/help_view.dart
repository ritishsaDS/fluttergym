import 'package:flutter/material.dart';

import '../../shared/common.dart';
import '../../shared/views/custom_document_view.dart';
import '../../shared/widgets/gym_app_bar.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  static const routeName = '/help';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return const HelpView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        label: 'Help',
        assetImage: Assets.gymIcon,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.of(context).push(
                CustomDocumentView.route(
                  title: 'Privacy Policy',
                  uri: 'https://powerdope.com/privacy-policy',
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Refund Policy'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.of(context).push(
                CustomDocumentView.route(
                  title: 'Refund Policy',
                  uri: 'https://powerdope.com/return-policy',
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.of(context).push(
                CustomDocumentView.route(
                  title: 'Terms & Conditions',
                  uri: 'https://powerdope.com/terms-and-conditions',
                ),
              );
            },
          ),
          ListTile(
            title: const Text('About Us'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.of(context).push(
                CustomDocumentView.route(
                  title: 'About Us',
                  uri: 'https://powerdope.com/about-us',
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            trailing: const Icon(Icons.navigate_next),
            onTap: () {
              Navigator.of(context).push(
                CustomDocumentView.route(
                  title: 'Contact Us',
                  uri: 'https://powerdope.com/contact-us-2',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
