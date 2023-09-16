import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:hukibu/Screen/add_new_child.dart';
import 'package:hukibu/Screen/auth_screen/email_auth/login_screen.dart';
import 'package:hukibu/Screen/auth_screen/set_up_profile/profile_screen.dart';
import 'package:hukibu/model/get_children.dart';
import 'package:hukibu/model/get_user.dart';
import 'package:hukibu/routes/route_paths.dart';
import 'package:hukibu/services/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart' as el;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

import '../services/storage.dart';
import 'edit_child_details.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? username;

  File? _image;
  String? imageURL;
  String? userImage;

  final picker = ImagePicker();
  String? name;
  final fireStore =
      FirebaseFirestore.instance.collection('New Child').snapshots();

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        name = (_image!.path);
      }
    });
    Reference ref = FirebaseStorage.instance.ref().child(name.toString());

    await ref.putFile(File(_image!.path));
    ref.getDownloadURL().then((value) async {
      setState(() {
        imageURL = value;
        FirebaseFirestore.instance
            .collection("UserData")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'image': imageURL});
      });
    });
  }

  List<Map<String, String>> dataList = [
    {
      'imageUrl': 'https://i.postimg.cc/0NdSyfsB/girl.jpg',
      'title': 'child 1',
      'subtitle': '2 years 6 months',
    },
    {
      'imageUrl': 'https://i.postimg.cc/W4jDCkk6/toddler1.jpg',
      'title': 'child 2',
      'subtitle': '6 months',
    },
    {
      'imageUrl': 'https://i.postimg.cc/3N7050VH/toddler-2.webp',
      'title': 'child 3',
      'subtitle': '1.5 years',
    },

    // Add more items as needed
  ];

  int? selectedAvatarId = int.tryParse(StorageService.to.getString('selectedChild'));

  List<String> avatarUrls = [
    'https://i.postimg.cc/W4jDCkk6/toddler1.jpg',
    'https://i.postimg.cc/0NdSyfsB/girl.jpg',
    'https://i.postimg.cc/3N7050VH/toddler-2.webp',
  ];

  Widget buildAvatar(int id,var url,String? name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatarId = id;
          StorageService.to.setString('selectedChild', id.toString());
          StorageService.to.setString('selectedChildName', name??'null');
        });
        Fluttertoast.showToast(
          msg: '${StorageService.to.getString('selectedChildName')} ${'selected'.tr()}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.grey[300],
          textColor: Colors.black,
          fontSize: 16.0,
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    selectedAvatarId == id ? Colors.blue : Colors.transparent,
                width: 4.0,
              ),
            ),
            child: url!=null
                ?CircleAvatar(
              backgroundImage: NetworkImage('http://139.59.68.139:3000/uploads/$url'))
                : const CircleAvatar(
              backgroundImage: AssetImage('assets/images/empty.webp'),
              backgroundColor: Colors.white,
            ),
          ),
          Text('$name')
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 13,
      width: double.infinity,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              getImageFromGallery();
            },
            child: const ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _futureUser = fetchUser();
    _futureDataList = fetchChildren();
  }

  late Future<UserData> _futureUser;
  late Future<List<Children>> _futureDataList;

  Future<UserData> fetchUser() async {
    final response =
        await http.get(Uri.parse('http://139.59.68.139:3000/getUserById/${StorageService.to.getString('userIdKey')}'));
    debugPrint(response.body.toString());
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is List) {
        // Handle case when response is a JSON array
        if (jsonData.isNotEmpty) {
          final userJson = jsonData.first;
          return UserData.fromJson(userJson);
        } else {
          throw Exception('Empty user list');
        }
      } else if (jsonData is Map<String, dynamic>) {
        // Handle case when response is a JSON object
        return UserData.fromJson(jsonData);
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<List<Children>> fetchChildren() async {
    print("object");
    print(StorageService.to.getString('userIdKey'));
    final response = await http.get(Uri.parse(
        'http://139.59.68.139:3000/getChildById/${StorageService.to.getString('userIdKey')}')); // Replace with your API endpoint
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final dataList = jsonData.map((item) => Children.fromJson(item)).toList();
      return dataList;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Center(
          child: const Text(
            "settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ).tr(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              onPressed: showLogoutConfirmationDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "logout",
                    style: TextStyle(
                      color: Color.fromARGB(255, 90, 32, 100),
                    ),
                  ).tr(),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.logout,
                    size: 18,
                    color: Color.fromARGB(255, 90, 32, 100),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              FutureBuilder<UserData>(
                future: _futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: [
                        Row(children: [
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () async {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (builder) => BottomSheet(),
                              // );
                            },
                            child:snapshot.data?.image != null
                                ?CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  'http://139.59.68.139:3000/uploads/${snapshot.data!.image}'),
                            )
                                :const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/images/empty.webp'),
                              backgroundColor: Colors.white,
                            )
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data?.name??'null',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data?.mobile??'null',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => ProfileScreen(user: snapshot));
                              },
                              child: Row(
                                children: [
                                  const Text(
                                    "edit profile",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 90, 32, 100),
                                    ),
                                  ).tr(),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Color.fromARGB(255, 90, 32, 100),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  }
                },
              ),
              // Column(
              //   children: [
              //     Row(children: [
              //       const SizedBox(
              //         width: 15,
              //       ),
              //       InkWell(
              //         onTap: () async {
              //           showModalBottomSheet(
              //             context: context,
              //             builder: (builder) => BottomSheet(),
              //           );
              //         },
              //         child: CircleAvatar(
              //           radius: 50,
              //           backgroundColor:
              //               const Color.fromARGB(255, 239, 238, 235),
              //           child: userImage != null
              //               ? ClipOval(
              //                   child: Image.network(
              //                     userImage!,
              //                     width: double.infinity,
              //                     fit: BoxFit.cover,
              //                   ),
              //                 )
              //               : _image != null
              //                   ? ClipOval(
              //                       child: Image.file(
              //                         _image!,
              //                         width: double.infinity,
              //                         fit: BoxFit.cover,
              //                       ),
              //                     )
              //                   : ClipOval(
              //                       child:
              //                           Image.asset('assets/images/empty.webp'),
              //                     ),
              //         ),
              //       ),
              //       const SizedBox(
              //         width: 15,
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             username.toString(),
              //             style: const TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //           const Text(
              //             '9588876587',
              //             style: TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       )
              //     ])
              //   ],
              // ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "my children",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ).tr(),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctx) => const AddNewChild(),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const AddANewChild(),
                        ),
                      );
                    },
                    child: SizedBox(
                      child: Row(
                        children: [
                          const Text(
                            "add new",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 90, 32, 100),
                            ),
                          ).tr(),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(
                            Icons.person_add,
                            size: 17,
                            color: Color.fromARGB(255, 90, 32, 100),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              FutureBuilder<List<Children>>(
                future: fetchChildren(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final childrenList = snapshot.data!;
                    return
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: childrenList.length,
                            itemBuilder: (context, index) {
                              final child = childrenList[index];
                              final age = child.calculateAge();

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 10,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(99, 136, 163, 181),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: ListTile(
                                      onTap: (){
                                        Get.to(()=>EditChild(child: child));
                                      },
                                      leading: (child.image??'') != ''
                                          ?CircleAvatar(
                                        radius: 26,
                                        backgroundImage: NetworkImage(
                                          // 'http://13.126.205.178:3000/uploads/${child.image}'),
                                            'http://139.59.68.139:3000/uploads/${child.image}'),
                                      )
                                          :const CircleAvatar(
                                        radius: 26,
                                        backgroundImage: AssetImage('assets/images/empty.webp'),
                                        backgroundColor: Colors.white,
                                      )
                                      ,
                                      title: Text(
                                        child.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        // '${item.age.toString()} Months',
                                        '${age['years']} ${'years'.tr()} ${age['months']} ${'months'.tr()} ${age['days']} ${'days old'.tr()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                      trailing:
                                      const Icon(Icons.arrow_forward_outlined),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 18.0),
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: "selected child".tr(),
                                // style: const TextStyle(
                                //     fontSize: 20,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.white),
                              ),
                              TextSpan(
                                text: StorageService.to.getString('selectedChildName'),
                                // style: const TextStyle(
                                //   fontSize: 15,
                                //   fontWeight: FontWeight.bold,
                                //   color: Colors.white,
                                // ),
                              )
                            ]),
                          ),

                          const SizedBox(height: 12.0),

                          Wrap(
                            children: List<Widget>.generate(
                              childrenList.length,
                                  (index) => buildAvatar(childrenList[index].id,childrenList[index].image,childrenList[index].name),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to fetch data'),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              // FutureBuilder<List<Children>>(
              //   future: _futureDataList,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return CircularProgressIndicator();
              //     } else if (snapshot.hasError) {
              //       return Text('Error: ${snapshot.error}');
              //     } else {
              //       final dataList = snapshot.data!;
              //       return ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: dataList.length,
              //         itemBuilder: (context, index) {
              //           final item = dataList[index];
              //           return Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Container(
              //               height: MediaQuery.of(context).size.height / 10,
              //               width: double.infinity,
              //               decoration: BoxDecoration(
              //                 color: const Color.fromARGB(99, 136, 163, 181),
              //                 borderRadius: BorderRadius.circular(15),
              //               ),
              //               child: Center(
              //                 child: ListTile(
              //                   leading: CircleAvatar(
              //                     radius: 26,
              //                     backgroundImage: NetworkImage(item.image),
              //                   ),
              //                   title: Text(
              //                     item.name,
              //                     style: const TextStyle(
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                   subtitle: Text(
              //                     // '${item.age.toString()} Months',
              //                     'Age: ${age['years']} years ${age['months']} months',
              //                     style: const TextStyle(
              //                       fontWeight: FontWeight.normal,
              //                       fontSize: 12,
              //                     ),
              //                   ),
              //                   trailing:
              //                       const Icon(Icons.arrow_forward_outlined),
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     }
              //   },
              // ),
              // ChildrenList(dataList: dataList),
              // StreamBuilder<QuerySnapshot>(
              //     stream: fireStore,
              //     builder: (BuildContext context,
              //         AsyncSnapshot<QuerySnapshot> snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const CircularProgressIndicator();
              //       }
              //       if (snapshot.hasError) {
              //         return const Text('Some Error');
              //       }
              //       return Expanded(
              //           child: ListView.builder(
              //               itemCount: snapshot.data!.docs.length,
              //               itemBuilder: (context, index) {
              //                 return Padding(
              //                   padding: const EdgeInsets.only(right: 20.0),
              //                   child: Card(
              //                     child: InkWell(
              //                       onTap: () {
              //                         Navigator.push(
              //                           context,
              //                           MaterialPageRoute(
              //                             builder: (ctx) => const StepperScreen(),
              //                           ),
              //                         );
              //                       },
              //                       child: Container(
              //                         //height: 50,
              //                         width: 100,
              //                         color: const Color.fromARGB(
              //                             255, 205, 211, 214),
              //                         child: Padding(
              //                           padding:
              //                               const EdgeInsets.only(left: 18.0),
              //                           child: ListTile(
              //                             title: Text(
              //                               snapshot.data!.docs[index]['surname']
              //                                   .toString(),
              //                               style: const TextStyle(
              //                                   fontWeight: FontWeight.bold),
              //                             ),
              //                             subtitle: Row(
              //                               children: [
              //                                 Text(
              //                                   snapshot.data!.docs[index]['area']
              //                                       .toString(),
              //                                   style: const TextStyle(
              //                                       fontWeight: FontWeight.bold),
              //                                 ),
              //                                 TextButton(
              //                                     onPressed: () {
              //                                       // Navigator.push(
              //                                       //   context,
              //                                       //   MaterialPageRoute(
              //                                       //     builder: (context) =>
              //                                       //         PdfViewerScreen(
              //                                       //       url: snapshot.data!
              //                                       //           .docs[index]['pdf']
              //                                       //           .toString(),
              //                                       //     ),
              //                                       //   ),
              //                                       // );
              //                                     },
              //                                     child: const Text('PDF'))
              //                               ],
              //                             ),
              //                             leading: Text(
              //                               snapshot.data!.docs[index]['name']
              //                                   .toString(),
              //                             ),
              //                             trailing: CircleAvatar(
              //                               radius: 30,
              //                               child: ClipRRect(
              //                                 borderRadius:
              //                                     BorderRadius.circular(30),
              //                                 child: snapshot.data!
              //                                             .docs[index]['image']
              //                                             .toString() !=
              //                                         'null'
              //                                     ? Image(
              //                                         fit: BoxFit.cover,
              //                                         width: 80,
              //                                         image: NetworkImage(
              //                                           snapshot.data!
              //                                               .docs[index]['image']
              //                                               .toString(),
              //                                         ),
              //                                         loadingBuilder: (context,
              //                                             child,
              //                                             loadingProgress) {
              //                                           if (loadingProgress ==
              //                                               null) {
              //                                             return child;
              //                                           }
              //                                           return const Center(
              //                                               child:
              //                                                   CircularProgressIndicator(
              //                                             color: Colors.black,
              //                                           ));
              //                                         },
              //                                       )
              //                                     : ClipOval(
              //                                         child: Image.asset(
              //                                             'assets/images/empty.webp'),
              //                                       ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               }));
              //     }),
            ],
          ),
        ),
      ),
    );
  }
  void showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'.tr()),
          content: Text('Are you sure you want to logout?'.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action here
                print('Logging out...');

                Navigator.of(context).pop(); // Close the dialog

                StorageService.to.setString('selectedChild', '');
                StorageService.to.setString('selectedChildName', '');
                FirebaseAuth.instance.signOut();
                UserStore.to.onLogout();
                Get.offAllNamed(RoutePaths.loginScreen);
              },
              child: Text('Logout'.tr()),
            ),
          ],
        );
      },
    );
  }
}

class ChildrenData {
  final String sirName;
  final String area;
  final String pdf;
  final int name;
  final String image;

  ChildrenData({
    required this.sirName,
    required this.area,
    required this.pdf,
    required this.name,
    required this.image,
  });

  factory ChildrenData.fromJson(Map<String, dynamic> json) {
    return ChildrenData(
      sirName: json['sirName'],
      area: json['area'],
      pdf: json['pdf'],
      name: json['name'],
      image: json['image'],
    );
  }
}

Future<ChildrenData> fetchChildrenData() async {
  final response =
      await http.get(Uri.parse('http://139.59.68.139:3000/getChildById/${StorageService.to.getString('userIdKey')}'));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return ChildrenData.fromJson(jsonData);
  } else {
    throw Exception('Failed to fetch user data');
  }
}

class ChildrenList extends StatelessWidget {
  final List<Map<String, String>> dataList;

  ChildrenList({required this.dataList});

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
            height: MediaQuery.of(context).size.height / 10, // 12,
            width: double.infinity,
            decoration: BoxDecoration(
                color: const Color.fromARGB(99, 136, 163, 181),
                //  border: Border.all(color: Colors.grey),
                //   color:  Colors.white,
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(item['imageUrl'] ?? ''),
                ),
                title: Text(
                  item['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  item['subtitle'] ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_outlined),
              ),
            ),
          ),
        );
      },
    );
  }
}
