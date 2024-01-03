import 'package:flutter/material.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/models/loved_one.dart';

///Help Handler
class HelpHandler {
  ///Show Help Bottom Sheet
  static Future<void> showHelpSheet({
    required BuildContext context,
  }) async {
    //Loved Ones
    final lovedOnes = await AccountHandler(context).lovedOnes();

    //Parsed Loved Ones
    final parsedLovedOnes = lovedOnes
        .map(
          (lovedOne) => LovedOne.fromJSON(lovedOne),
        )
        .toList();

    //Show Help Menu
    if (context.mounted) {
      await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Top
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //Title
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Ask for Help",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                    //Notify All
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextButton(
                        onPressed: lovedOnes.isNotEmpty ? () {} : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).cardColor,
                        ),
                        child: const Text("Notify All"),
                      ),
                    ),
                  ],
                ),

                //Spacing
                const SizedBox(height: 20.0),

                //Loved Ones
                parsedLovedOnes.isNotEmpty
                    ? ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 240.0,
                        ),
                        child: GridView.count(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(12.0),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 10 / 3,
                          children: parsedLovedOnes.map(
                            (lovedOne) {
                              return GestureDetector(
                                onTap: () {
                                  //Set
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      lovedOne.name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            "You don't have any Loved Ones.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                //Spacing
                const SizedBox(height: 40.0),
              ],
            ),
          );
        },
      );
    }
  }
}
