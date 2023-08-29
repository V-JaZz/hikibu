import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/model/course_data.dart';
import 'package:hukibu/model/get_courses.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iyzico/iyzico.dart';

class CuddleDetails extends StatefulWidget {
  final int id;
  const CuddleDetails({required this.id, super.key});

  @override
  State<CuddleDetails> createState() => _CuddleDetailsState();
}

class _CuddleDetailsState extends State<CuddleDetails> {
  List<Map<String, String>> dataList = [
    {
      'imageUrl': 'https://i.postimg.cc/KcP19fg8/avatar.png',
      'name': 'Bharti Goel',
      'designation':
          'CAPPA certified childbirth Educator and Parental Yoga Instruction',
      'description':
          'As a CAPPA Certfied Childbirth Educator and Parental Yoga instruction.Bharti loves helping expecting moms to have a confortable and pain-free pregnancy',
    },
    {
      'imageUrl': 'https://i.postimg.cc/KcP19fg8/avatar.png',
      'name': 'John Doe',
      'designation': 'Certified Doula',
      'description':
          'John is a certified doula with expertise in providing emotional and physical support to expecting parents throughout their birthing journey.',
    },
    // Add more items as needed
  ];
  bool loading = false;
  // late Future<Course> courseFuture;
  // late Course course;
  // @override
  // void initState() {
  //   super.initState();
  //   courseFuture = fetchCourseDetail(widget.id) as Future<Course>;
  //   courseFuture.then((value) {
  //     setState(() {
  //       course = value;
  //     });
  //   });
  // }

  CourseModel? courseModel;

  final iyziConfig = const IyziConfig(
      'aHYVflgQYVBtt6llDZrt30NwFGgBu63a',
      '5vFnPaU7zksagqiZXq8q7xdIjlFFGJaO',
      'https://sandbox-api.iyzipay.com'
  );

  late var iyzico = Iyzico.fromConfig(configuration: iyziConfig);

  @override
  void initState() {
    super.initState();
    iyzico = Iyzico.fromConfig(configuration: iyziConfig);
    fetchData();
  }

  void fetchData() async {
    var url = Uri.parse('http://139.59.68.139:3000/courses/get/${widget.id}');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        courseModel = CourseModel.fromJson(jsonResponse);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return courseModel != null
        ?Scaffold(
      bottomNavigationBar: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '₹${courseModel!.course.price.toString()}',
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    final double price = 1;
                    final double paidPrice = 1.1;

                    final paymentCard = PaymentCard(
                      cardHolderName: 'John Doe',
                      cardNumber: '5528790000000008',
                      expireYear: '2030',
                      expireMonth: '12',
                      cvc: '123',
                    );

                    final shippingAddress = Address(
                        address: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
                        contactName: 'Jane Doe',
                        zipCode: '34742',
                        city: 'Istanbul',
                        country: 'Turkey');
                    final billingAddress = Address(
                        address: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
                        contactName: 'Jane Doe',
                        city: 'Istanbul',
                        country: 'Turkey');

                    final buyer = Buyer(
                        id: 'BY789',
                        name: 'John',
                        surname: 'Doe',
                        identityNumber: '74300864791',
                        email: 'email@email.com',
                        registrationAddress: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
                        city: 'Istanbul',
                        country: 'Turkey',
                        ip: '85.34.78.112');

                    final basketItems = <BasketItem>[
                      BasketItem(
                          id: 'BI101',
                          price: '0.3',
                          name: 'Binocular',
                          category1: 'Collectibles',
                          category2: 'Accessories',
                          itemType: BasketItemType.PHYSICAL),
                      BasketItem(
                          id: 'BI102',
                          price: '0.5',
                          name: 'Game code',
                          category1: 'Game',
                          category2: 'Online Game Items',
                          itemType: BasketItemType.VIRTUAL),
                      BasketItem(
                          id: 'BI103',
                          price: '0.2',
                          name: 'Usb',
                          category1: 'Electronics',
                          category2: 'Usb / Cable',
                          itemType: BasketItemType.PHYSICAL),
                    ];
                    final paymentResult = await iyzico.CreatePaymentRequest(
                      price: 1.0,
                      paidPrice: 1.1,
                      paymentCard: paymentCard,
                      buyer: buyer,
                      shippingAddress: shippingAddress,
                      billingAddress: billingAddress,
                      basketItems: basketItems,
                    );
                    log('$paymentResult');
                    setState(() {
                      loading = false;
                    });
                    Get.snackbar(
                      'Payment gateway',
                      '$paymentResult',
                      snackStyle: SnackStyle.FLOATING,
                      icon: const Icon(
                        Icons.error,
                        color: Color(0xff28282B),
                      ),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.grey[200],
                      borderRadius: 10,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(15),
                      colorText: const Color(0xff28282B),
                      duration: const Duration(seconds: 2),
                      isDismissible: true,
                      forwardAnimationCurve: Curves.easeOutBack,
                    );
                  },
                child: Container(
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 2, 215, 112),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: loading
                      ? Container(
                    alignment: Alignment.center,
                      padding: const EdgeInsets.all(6),
                      child: const AspectRatio(
                        aspectRatio: 1/1,
                          child: CircularProgressIndicator(color: Colors.black)
                      ),
                  )
                      :Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Join Now".tr(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT THE PROGRAM'.tr(),
                  style: const TextStyle(color: Colors.grey),
                ),
                10.heightBox,
                // ),
                // FutureBuilder<Course>(
                //   future: courseFuture,
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     } else if (snapshot.hasError) {
                //       return Center(
                //         child: Text('Failed to fetch course details'),
                //       );
                //     } else if (snapshot.hasData) {
                //       final course = snapshot.data!;

                //       return Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             courseModel!.course.courseName,
                //             style: TextStyle(
                //                 fontSize: 20, fontWeight: FontWeight.bold),
                //           ),
                //           SizedBox(height: 30),
                //           Text(
                //             courseModel!.course.courseDesc,
                //           ),
                //         ],
                //       );
                //     } else {
                //       return Container(); // Empty state
                //     }
                //   },
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courseModel!.course.courseName.toString(),
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      courseModel!.course.courseDesc.toString(),
                    ),
                  ],
                ),
                // const Text(
                //   'Cuddle Postnatal',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                // ),
                // 30.heightBox,
                // const Text(
                //     'Get expert assistance and personal care in the beginning of your journey as a parent .Because,smart parents raise smart kids, happy parent raise happy kids'),
                20.heightBox,
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       Container(
                //         height: MediaQuery.of(context).size.height / 18,
                //         width: MediaQuery.of(context).size.width / 5,
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //               color: const Color.fromARGB(255, 94, 92, 92)),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: const [
                //             Icon(Icons.timer_outlined),
                //             Text(
                //               "5 mins\ndaily",
                //               style: TextStyle(fontSize: 12),
                //             )
                //           ],
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Container(
                //         height: MediaQuery.of(context).size.height / 18,
                //         width: MediaQuery.of(context).size.width / 4.5,
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //               color: const Color.fromARGB(255, 94, 92, 92)),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: const [
                //             Icon(Icons.person_2_rounded),
                //             Text(
                //               "One to One\nSession",
                //               style: TextStyle(fontSize: 10),
                //             )
                //           ],
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Container(
                //         height: MediaQuery.of(context).size.height / 18,
                //         width: MediaQuery.of(context).size.width / 4.5,
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //               color: const Color.fromARGB(255, 94, 92, 92)),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: const [
                //             Icon(Icons.local_activity),
                //             Text(
                //               "Activities",
                //               style: TextStyle(fontSize: 12),
                //             )
                //           ],
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Container(
                //         height: MediaQuery.of(context).size.height / 18,
                //         width: MediaQuery.of(context).size.width / 5,
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //               color: const Color.fromARGB(255, 94, 92, 92)),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: const [
                //             Icon(Icons.add_box_outlined),
                //             Text(
                //               "Bounes",
                //               style: TextStyle(fontSize: 12),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Center(
                  child: courseModel == null
                      ? const CircularProgressIndicator()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: courseModel!.course.whatYouGet
                              !.asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            IconData iconData;

                            // Assign different icons based on index or item value
                            if (index == 0) {
                              iconData = Icons.timer_outlined;
                            } else if (index == 1) {
                              iconData = Icons.person_2_rounded;
                            } else if (index == 2) {
                              iconData = Icons.local_activity;
                            } else if (index == 3) {
                              iconData = Icons.add_box_outlined;
                            } else {
                              iconData = Icons.info;
                            }

                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 18,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 94, 92, 92),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    const SizedBox(width: 3),
                                    Icon(
                                        iconData),
                                    const SizedBox(width: 2),
                                    Text(
                                      item,
                                      style: const TextStyle(fontSize: 12),
                                    ).tr(),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
                // 30.heightBox,
                // const Text(
                //     'Make your first days of parenting awesome!\nAs a parent,you are taking up a responsibility inlike anythings else,\n\nYour are the biggest impact on your Child life!\n\nYour Happenies will be their happines.Your knoeledge Will be their.Your peace of mind will be theirs.\n\nYou need support.You need care.You need Cuddle.'),
                20.heightBox,
                Row(children: <Widget>[
                  const Expanded(
                      child: Divider(
                    color: Colors.black,
                    height: 30,
                    endIndent: 15,
                  )),
                  Text("Meet Your Instruction".tr()),
                  const Expanded(
                      child: Divider(
                    color: Colors.black,
                    height: 30,
                    indent: 15,
                  )),
                ]),
                20.heightBox,

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courseModel!.instructorData.length,
                  itemBuilder: (context, index) {
                    var instructorData = courseModel!.instructorData[index];
                    // return ListTile(
                    //   title: Text(instructorData.name),
                    //   subtitle: Text(instructorData.occupation),
                    //   // Add more properties as needed
                    // );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(116, 195, 192, 183),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                            width: double.infinity,
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                // child: Image.asset(
                                //   'assets/images/teacher.jpeg',
                                //   fit: BoxFit.cover,
                                //   height: double.infinity,
                                //   width: double.infinity,
                                // ),
                                child: Image.network(
                                  'http://139.59.68.139:3000/uploads/${instructorData.image}',
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 95.0, left: 10),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: '${instructorData.name}\n',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  TextSpan(
                                      text: instructorData.occupation,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.white))
                                ])),
                              )
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              instructorData.description,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 100, 99, 99)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Container(
                //   height: MediaQuery.of(context).size.height / 3.5,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(116, 195, 192, 183),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height / 5,
                //         width: double.infinity,
                //         child: Stack(children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(10),
                //             child: Image.asset(
                //               'assets/images/teacher.jpeg',
                //               fit: BoxFit.cover,
                //               height: double.infinity,
                //               width: double.infinity,
                //             ),
                //           ),
                //           const Padding(
                //             padding: EdgeInsets.only(top: 95.0, left: 10),
                //             child: Text.rich(TextSpan(children: [
                //               TextSpan(
                //                   text: 'Nishana AM\n',
                //                   style: TextStyle(
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.white)),
                //               TextSpan(
                //                   text: 'Lactation Consultant',
                //                   style: TextStyle(
                //                       fontSize: 12,
                //                       //fontWeight: FontWeight.bold,
                //                       color: Colors.white))
                //             ])),
                //           )
                //         ]),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Text(
                //           'Nishana is a certified lactation consultant and childbirth educator',
                //           style: TextStyle(
                //               fontSize: 15,
                //               color: Color.fromARGB(255, 100, 99, 99)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // 10.heightBox,
                // Container(
                //   height: MediaQuery.of(context).size.height / 3.5,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(116, 183, 181, 173),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height / 5,
                //         width: double.infinity,
                //         child: Stack(children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(10),
                //             child: Image.asset(
                //               'assets/images/teacher2.jpg',
                //               fit: BoxFit.cover,
                //               height: double.infinity,
                //               width: double.infinity,
                //             ),
                //           ),
                //           const Padding(
                //             padding: EdgeInsets.only(top: 100.0, left: 10),
                //             child: Text.rich(TextSpan(children: [
                //               TextSpan(
                //                   text: 'Nimrata Sharma\n',
                //                   style: TextStyle(
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.white)),
                //               TextSpan(
                //                   text: 'Certified ChildBirth Educator',
                //                   style: TextStyle(
                //                       fontSize: 12,
                //                       //fontWeight: FontWeight.bold,
                //                       color: Colors.white))
                //             ])),
                //           )
                //         ]),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Text(
                //           'Nimrata is a CAPPA certified childbirth Educator',
                //           style: TextStyle(
                //               fontSize: 15,
                //               color: Color.fromARGB(255, 100, 99, 99)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // 10.heightBox,
                // Container(
                //   height: MediaQuery.of(context).size.height / 3.3,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(116, 163, 158, 140),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height / 5,
                //         width: double.infinity,
                //         child: Stack(children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(10),
                //             child: Image.asset(
                //               'assets/images/teacher.jpeg',
                //               fit: BoxFit.cover,
                //               height: double.infinity,
                //               width: double.infinity,
                //             ),
                //           ),
                //           const Padding(
                //             padding: EdgeInsets.only(top: 100.0, left: 10),
                //             child: Text.rich(TextSpan(children: [
                //               TextSpan(
                //                   text: 'Bharti Goel\n',
                //                   style: TextStyle(
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.white)),
                //               TextSpan(
                //                   text:
                //                       'CAPPA certified childbirth Educator and Parental\n Yoga Instruction ',
                //                   style: TextStyle(
                //                       fontSize: 12,
                //                       //fontWeight: FontWeight.bold,
                //                       color: Colors.white))
                //             ])),
                //           )
                //         ]),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Text(
                //           'As a CAPPA Certfied Childbirth Educator and Parental Yoga instruction.Bharti loves helping expecting moms to have a confortable and pain-free pregnancy',
                //           style: TextStyle(
                //               fontSize: 13,
                //               color: Color.fromARGB(255, 100, 99, 99)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // 10.heightBox,
                // Container(
                //   height: MediaQuery.of(context).size.height / 3.3,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(116, 163, 158, 140),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height / 5,
                //         width: double.infinity,
                //         child: Stack(children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(10),
                //             child: Image.asset(
                //               'assets/images/teacher2.jpg',
                //               fit: BoxFit.cover,
                //               height: double.infinity,
                //               width: double.infinity,
                //             ),
                //           ),
                //           const Padding(
                //             padding: EdgeInsets.only(top: 100.0, left: 10),
                //             child: Text.rich(TextSpan(children: [
                //               TextSpan(
                //                   text: 'DR.Divya Jose\n',
                //                   style: TextStyle(
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.white)),
                //               TextSpan(
                //                   text: 'Consultant Obstetician and Gynologist',
                //                   style: TextStyle(
                //                       fontSize: 12,
                //                       //fontWeight: FontWeight.bold,
                //                       color: Colors.white))
                //             ])),
                //           )
                //         ]),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Text(
                //           'Consultant Obstetrician and Gynecologist.Lourdes Hospital MBBS from Calicut Medical Collage and MS(OBG)from St.Jhons Medical Collage Banalore ',
                //           style: TextStyle(
                //               fontSize: 14,
                //               color: Color.fromARGB(255, 100, 99, 99)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // 10.heightBox,
                // Container(
                //   height: MediaQuery.of(context).size.height / 3.3,
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(116, 163, 158, 140),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       SizedBox(
                //         height: MediaQuery.of(context).size.height / 5,
                //         width: double.infinity,
                //         child: Stack(children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.circular(10),
                //             child: Image.asset(
                //               'assets/images/teacher.jpeg',
                //               fit: BoxFit.cover,
                //               height: double.infinity,
                //               width: double.infinity,
                //             ),
                //           ),
                //           const Padding(
                //             padding: EdgeInsets.only(top: 100.0, left: 10),
                //             child: Text.rich(TextSpan(children: [
                //               TextSpan(
                //                   text: 'Dr.Seema Lal\n',
                //                   style: TextStyle(
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.white)),
                //               TextSpan(
                //                   text:
                //                       'Psycolohist spacail Educator Medical Health Reacher',
                //                   style: TextStyle(
                //                       fontSize: 12,
                //                       //fontWeight: FontWeight.bold,
                //                       color: Colors.white))
                //             ])),
                //           )
                //         ]),
                //       ),
                //       const Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child: Text(
                //           'Mental Health professional with over tewnty years of professional experience spannig both non-governmental organization and private sector instuition based out of india and the United Arab Emirates',
                //           style: TextStyle(
                //               fontSize: 12,
                //               color: Color.fromARGB(255, 100, 99, 99)),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // MyListView(dataList: dataList),
              ],
            ),
          ),
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}

// navin 27th june

class MyListView extends StatelessWidget {
  final List<Map<String, String>> dataList;

// In your build method or widget tree

  MyListView({required this.dataList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final item = dataList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 3.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(116, 163, 158, 140),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['imageUrl'] ?? '',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0, left: 10),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: item['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: '\n' + item['designation']! ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 100, 99, 99),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CuddleDetailData {
  final String imageUrl;
  final String name;
  final String designation;
  final String description;

  CuddleDetailData({
    required this.imageUrl,
    required this.name,
    required this.designation,
    required this.description,
  });

  factory CuddleDetailData.fromJson(Map<String, dynamic> json) {
    return CuddleDetailData(
      imageUrl: json['imageUrl'],
      name: json['name'],
      designation: json['designation'],
      description: json['description'],
    );
  }
}

Future<CuddleDetailData> fetchCuddleDetailData() async {
  final response = await http.get(Uri.parse('https://api.example.com'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return CuddleDetailData.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch user data');
  }
}
