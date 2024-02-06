import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/settings/pages/account_info.dart';
import 'package:safesnake/pages/settings/pages/team/team.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/theming/controller.dart';
import 'package:safesnake/util/widgets/main.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    //Current Theme
    final currentTheme = ThemeController.current(context: context);

    //Accept Invites Status
    bool acceptInvites =
        AccountHandler(context).currentUser?.userMetadata?["accept_invites"] ??
            false;

    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        onBack: () async {
          //Save Data
          await LocalData.setData(
            box: "settings",
            data: {
              "invites": acceptInvites,
            },
          );

          //Go Back
          if (mounted) {
            Navigator.pop(context);
          }
        },
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: SettingsList(
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          physics: const BouncingScrollPhysics(),
          sections: [
            //UI
            SettingsSection(
              title: const Text("UI & Visuals"),
              tiles: [
                //Theme
                SettingsTile.switchTile(
                  initialValue: currentTheme,
                  onToggle: (mode) => ThemeController.setAppearance(
                    context: context,
                    mode: mode,
                  ),
                  leading: currentTheme
                      ? const Icon(Ionicons.ios_sunny)
                      : const Icon(Ionicons.ios_moon),
                  title: const Text("Theme"),
                  description: Text(currentTheme ? "Dark Mode" : "Light Mode"),
                ),
              ],
            ),

            //Account
            SettingsSection(
              title: const Text("Your Account"),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_person),
                  title: const Text("Information"),
                  description: const Text(
                    "See and change all your Account Information.",
                  ),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const AccountInfo(),
                      ),
                    );
                  },
                ),
              ],
            ),

            //Team & Licenses
            SettingsSection(
              title: const Text("Team & Licenses"),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_people),
                  title: const Text("Team"),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const Team()),
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_document),
                  title: const Text("Licenses"),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LicensePage(
                          applicationName: "SafeSnake",
                          applicationIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              child: Image.asset(
                                "assets/logo.png",
                                height: 80.0,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
