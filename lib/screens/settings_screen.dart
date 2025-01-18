import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:todoo_app/constants.dart';
import 'package:todoo_app/providers/theme_colour_provider.dart';
import 'package:todoo_app/utilities/util.dart';
import 'package:todoo_app/widgets/tasks_alert_dialogue.dart';
import 'package:todoo_app/widgets/tasks_button.dart';

/// Settings screen for the Todoo app.
///
/// `SettingsScreen` allows users to customize the app's appearance and access other settings.
/// It utilizes Riverpod to access the app theme seed color provider.
/// Key functionalities:
///   - `_buildListTile`: Creates a reusable ListTile widget with icon, title, and onTap functionality.
///   - `build`: Builds the Settings screen using a Scaffold with AppBar and a ListView.
///     - The ListView displays various options using `_buildListTile`:
///       - Change App Colour: Opens a dialog to choose a new app theme color.
///       - Rate App: Placeholder for future app rating functionality.
///       - Report Bugs: Placeholder for future bug reporting functionality.
///       - Login (Coming Soon): Disabled option for future login functionality.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Widget _buildListTile(
      {required BuildContext context,
      required String tileIcon,
      required String titleText,
      required Function() onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Iconify(
        tileIcon,
        size: 22,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(titleText),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seedColourHandler = ref.read(appThemeSeedColourProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: kScaffoldBodyPadding,
        child: ListView(
          children: [
            _buildListTile(
              context: context,
              tileIcon: Mdi.palette,
              titleText: 'Change App Colour',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return TodooAlertDialogue(
                        title: 'Choose Colour',
                        contentItems: seedColourMap.keys.map((colour) {
                          return Center(
                            child: TodooButton(
                              onButtonTap: () {
                                seedColourHandler
                                    .changeSeedColour(seedColourMap[colour]!);
                                Navigator.of(context).pop();
                              },
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(4),
                              buttonHeight: 38,
                              buttonWidth: 200,
                              icon: Mdi.square_rounded,
                              iconColour: seedColourMap[colour],
                              buttonColour:
                                  seedColourMap[colour]!.withOpacity(0.15),
                              buttonText: Utils.getColourLabel(colour),
                              textColour: seedColourMap[colour],
                            ),
                          );
                        }).toList(),
                      );
                    });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            _buildListTile(
              context: context,
              tileIcon: Ic.baseline_18_up_rating,
              titleText: 'Rate App',
              onTap: () {},
            ),
            const SizedBox(
              height: 8,
            ),
            _buildListTile(
              context: context,
              tileIcon: Mdi.bug,
              titleText: 'Report Bugs',
              onTap: () {},
            ),
            const SizedBox(
              height: 8,
            ),
            _buildListTile(
              context: context,
              tileIcon: Mdi.login,
              titleText: 'Login (Coming Soon)',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
