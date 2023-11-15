import 'package:flutter/material.dart';
import 'package:safesnake/pages/home/widgets/help.dart';
import 'package:safesnake/pages/home/widgets/people.dart';
import 'package:safesnake/pages/home/widgets/settings.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/models/loved_one.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///Loved Ones
  List<LovedOne> lovedOnes = LocalData.boxData(box: "loved_ones")["list"] ?? [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        //Top Spacing
        const SizedBox(height: 140.0),

        //Ask for Help
        AskForHelp(lovedOnes: lovedOnes),

        //Extras
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Settings(),
            People(),
          ],
        ),
      ],
    );
  }
}
