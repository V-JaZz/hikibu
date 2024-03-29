import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OverComeDetails extends StatefulWidget {
  const OverComeDetails({super.key});

  @override
  State<OverComeDetails> createState() => _OverComeDetailsState();
}

class _OverComeDetailsState extends State<OverComeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ABOUT THE PROGRAM',
                  style: TextStyle(color: Colors.grey),
                ),
                10.heightBox,
                const Text(
                  'Overcome Screen Addiction with Lahar Bhatnagar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                30.heightBox,
                const Text(
                    'Help you child detach from screen and enjoye the world outside'),
                20.heightBox,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 94, 92, 92)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.person_2_rounded),
                            Text(
                              "One to One\nSession",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 94, 92, 92)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.add_box_rounded),
                            Text(
                              "Bonus reward",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 94, 92, 92)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Icon(Icons.music_video_outlined),
                            Text(
                              "Recomded\nmicro session",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                30.heightBox,
                const Text(
                    'Most parents these days struggle with screen addition in children.To help you out.we partner with scientific parenting coach Lahar Bhatnagar to bring you the Overcome Screen Addiction micro-course'),
                40.heightBox,
                const Text('This 5-day micro-course cover daily'),
                10.heightBox,
                const Text('- Activity for Children'),
                10.heightBox,
                const Text('- Activity for Parents'),
                10.heightBox,
                const Text('- Mind mapping techniques'),
                10.heightBox,
                const Text('- End-of-day checklists'),
                10.heightBox,
                const Text('- Video recommendation'),
                10.heightBox,
                const Text(
                    'Each Activity is supported by the thought behind it,which helps you understand it better'),
                30.heightBox,
                const Text('What do you get?'),
                10.heightBox,
                const Text('- Develop a healthy attitude toward the screen'),
                10.heightBox,
                const Text('- Learn to self-regulate screen time'),
                10.heightBox,
                const Text('- Learn to monitor content viewed'),
                10.heightBox,
                const Text(
                    '- Reduce addiction signs like tantruns when the \n  screen is take'),
                20.heightBox,
                Row(children: const <Widget>[
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                    height: 30,
                    endIndent: 15,
                  )),
                  Text("Meet Your Instruction"),
                  Expanded(
                      child: Divider(
                    color: Colors.black,
                    height: 30,
                    indent: 15,
                  )),
                ]),
                20.heightBox,
                Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(116, 195, 192, 183),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4.5,
                        width: double.infinity,
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              'assets/images/teacher.jpeg',
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 125.0, left: 10),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: 'Lahar Bhatnagar\n',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              TextSpan(
                                  text: 'Scientific Parenting Coach',
                                  style: TextStyle(
                                      fontSize: 12,
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ])),
                          )
                        ]),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Lahar Bhatnagar is a millennial parenting coach, international author, and biogger.She is a certified parenting coach from the international Assocaite of Childed Coaches.USA She has Studied Developement Neuroscience',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 100, 99, 99)),
                        ),
                      ),
                    ],
                  ),
                ),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OvercomeDetailData {
  final String imageUrl;
  final String name;
  final String designation;
  final String description;

  OvercomeDetailData({
    required this.imageUrl,
    required this.name,
    required this.designation,
    required this.description,
  });

  factory OvercomeDetailData.fromJson(Map<String, dynamic> json) {
    return OvercomeDetailData(
      imageUrl: json['imageUrl'],
      name: json['name'],
      designation: json['designation'],
      description: json['description'],
    );
  }
}

Future<OvercomeDetailData> fetchOvercomeDetailData() async {
  final response = await http.get(Uri.parse('https://api.example.com'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return OvercomeDetailData.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch user data');
  }
}
