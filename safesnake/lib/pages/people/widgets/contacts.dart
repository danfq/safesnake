import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:native_dialog/native_dialog.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/animations/handler.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/models/loved_one.dart';
import 'package:safesnake/util/notifications/local.dart';

class DeviceContacts extends StatefulWidget {
  const DeviceContacts({super.key, required this.onInvited});

  ///On Invited
  final VoidCallback onInvited;

  @override
  State<DeviceContacts> createState() => _DeviceContactsState();
}

class _DeviceContactsState extends State<DeviceContacts> {
  ///Search Controller
  final TextEditingController searchController = TextEditingController();

  ///All Contacts
  List<Contact> allContacts = [];

  ///Displayed Contacts - With Filter Applied
  List<Contact> displayedContacts = [];

  ///Current User
  final currentUser = LocalData.boxData(box: "personal")["name"];

  ///Loved Ones
  final lovedOnes = LocalData.boxData(box: "loved_ones")["list"] ?? [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await ContactsService.getContacts();
    setState(() {
      allContacts = contacts;
      displayedContacts = contacts;
    });
  }

  void _filterContacts(String query) {
    setState(() {
      displayedContacts = allContacts
          .where((contact) =>
              contact.displayName
                  ?.toLowerCase()
                  .startsWith(query.toLowerCase()) ==
              true)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CupertinoSearchTextField(
            controller: searchController,
            placeholder: "Search Contact...",
            onChanged: _filterContacts,
          ),
        ),
        //Contacts
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: displayedContacts.length,
              itemBuilder: (context, index) {
                //Contact Data
                final contactData = displayedContacts[index];

                //UI
                if (contactData.displayName != null &&
                    contactData.phones != null) {
                  return ListTile(
                    title: Text(contactData.displayName!),
                    trailing: IconButton(
                      onPressed: () async {
                        //Confirm
                        final confirmed = await NativeDialog.confirm(
                          "Send Invitation to ${contactData.displayName}?",
                        );

                        //Send Invitation if Confirmed
                        if (confirmed) {
                          final sms = await sendSMS(
                            message:
                                "$currentUser needs your help!\n\nGet SafeSnake and join them!",
                            recipients: [contactData.phones!.first.value!],
                          );

                          //Check if Sent
                          if (context.mounted) {
                            if (sms == "sent") {
                              //Notify User
                              LocalNotification(context: context).show(
                                type: NotificationType.success,
                                message: "Invitation Sent!",
                              );

                              //Loved Ones
                              lovedOnes.add(
                                LovedOne(
                                  name: contactData.displayName!,
                                  email: "",
                                  fcmID: "",
                                  status: LovedOneStatus.invited.name,
                                ).toJSON(),
                              );

                              //Add Loved One as "Invited"
                              await LocalData.setData(
                                box: "loved_ones",
                                data: {"list": lovedOnes},
                              );
                            } else {
                              LocalNotification(context: context).show(
                                type: NotificationType.failure,
                                message: "Failed to Send Invitation",
                              );
                            }
                          }
                        }
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                      ),
                      icon: const Icon(
                        Ionicons.ios_add,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
