// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:hukibu/Screen/add_note.dart';
// // import 'package:hukibu/Screen/notes_details.dart';
// // import 'package:velocity_x/velocity_x.dart';
// // class NotesScreen extends StatelessWidget {
// //   const NotesScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         foregroundColor: Colors.black,
// //         elevation: 0,
// //         title: "Notes".text.make(),
// //       ),
// //       body: Column(
// //         children: [
// //           StreamBuilder(
// //               stream: FirebaseFirestore.instance.collection('notes').snapshots(),
// //               builder: (context,AsyncSnapshot<QuerySnapshot>snapshot){
// //             if(!snapshot.hasData){
// //               return Expanded(child: CircularProgressIndicator().centered());
// //             }
// //             else if(snapshot.data!.docs.isEmpty){
// //               return Expanded(child: "No Notes".text.bold.size(25).makeCentered());
// //             }
// //             else{
// //               return Expanded(
// //                 child: ListView.builder(
// //                     itemCount: snapshot.data!.docs.length,
// //                     itemBuilder: (context,index){
// //                   return GestureDetector(
// //                     onTap: (){
// //                       Navigator.push(context, MaterialPageRoute(builder: (context)=>NotesDetails(data: snapshot.data!.docs[index])));
// //                     },
// //                     child: ListTile(
// //                       title: "${snapshot.data!.docs[index]['title']}".text.make(),
// //                       leading: Icon(Icons.note,color: Colors.yellow,size: 20,),
// //                     ),
// //                   );
// //                 }),
// //               );
// //             }
// //           })
// //         ],
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: Colors.yellow,
// //           onPressed: (){
// //           Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNote()));
// //           },
// //         child: const Icon(Icons.add)),
// //     );
// //   }
// // }
//
//
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:file_picker/file_picker.dart';
import '../services/storage.dart';
import 'package:open_file/open_file.dart';
import 'notes_details.dart';

/// The app which hosts the home page which contains the calendar on it.
// class CalendarApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(title: 'Calendar Demo', home: MyHomePage());
//   }
// }

/// The hove page which hosts the calendar
class NotesScreen extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const NotesScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Meeting> meetings = <Meeting>[];
  static const String _storageKey = 'meetings';
  FilePickerResult? result;
  final TextEditingController _noteEditingController = TextEditingController();
  bool _showError = false;

  @override
  void initState() {
    loadMeetings();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SfCalendar(
          todayHighlightColor: Colors.indigo,
          selectionDecoration: BoxDecoration(
            border: Border.all(color: Colors.indigo)
          ),
          view: CalendarView.month,
          dataSource: MeetingDataSource(meetings),
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          ),
          onTap: (calendarTapDetails) {
            _showError = false;
            result = null;
            _showBottomSheet(context,calendarTapDetails.appointments!,calendarTapDetails.date!);
          },
        ),
      ),
    );
  }

  _addEvent({required String name, Color? color, required DateTime day, String? filePath}){
    final DateTime startTime = DateTime(day.year, day.month, day.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
        Meeting(name, startTime, endTime, color??const Color(0xFF0F8644), false, filePath: filePath));
    saveMeetings();
    setState((){ });
  }
  _removeEvent({required Meeting meeting}){
    meetings.remove(meeting);
    saveMeetings();
    setState((){ });
  }

  saveMeetings() async {
    List<Map<String, dynamic>> meetingsJsonList = meetings.map((meeting) => meeting.toJson()).toList();
    String meetingsJsonString = jsonEncode(meetingsJsonList);
    StorageService.to.setString(_storageKey, meetingsJsonString);
  }

  loadMeetings() async {
    String meetingsJsonString = StorageService.to.getString(_storageKey);
    if(meetingsJsonString!=''){
      List<dynamic> meetingsJsonList = jsonDecode(meetingsJsonString);
      meetings.addAll(
          meetingsJsonList.map((json) => Meeting.fromJson(json)).toList());
    }
  }
  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      print('Open file result: ${result.type}');
    } catch (e) {
      print('Error opening file: $e');
    }
  }
  void _showBottomSheet(BuildContext context, List<dynamic> events,DateTime date) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Events List'.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(color: Colors.black),
                Expanded(
                  child: events.isNotEmpty
                      ? ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return (events[index].filePath??'') == ''
                          ? Container(
                        margin: const EdgeInsets.only(bottom: 1),
                        color: const Color(0xFF0F8644),
                        child: ListTile(
                          title: Text(events[index].eventName,style: const TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            onPressed: (){
                              _removeEvent(meeting: events[index]);
                              Navigator.of(context).pop();
                            },
                              icon: const Icon(Icons.delete,color: Colors.white)
                          ),
                        ),
                      )
                          : Column(
                            children: [
                              Container(
                                color: const Color(0xFF0F8644),
                                child: ListTile(
                                  title: Text(events[index].eventName,style: const TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                      onPressed: (){
                                        _removeEvent(meeting: events[index]);
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.delete,color: Colors.white)
                                  ),
                                ),
                              ),
                              Container(
                                color: const Color(0xFF0B6633),
                                child: ListTile(
                                  onTap: (){
                                    if((events[index].filePath??'') != ''){
                                      openFile(events[index].filePath!);
                                    }
                                  },
                                  title: Text(events[index].filePath.split('/').last,style: const TextStyle(color: Colors.white)),
                                  leading:const Icon(Icons.file_open_rounded,color: Colors.white),
                                  subtitle:const Text('Click to open',style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 1)
                            ],
                          );
                    },
                  )
                      : Center(child: Text('No Events'.tr(),style: const TextStyle(color: Colors.grey)),)
                  ,
                ),

                if(result!=null) Container(height: 36,color: Colors.indigo,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 12),
                      Text('${result?.files.first.name}',style: const TextStyle(color: Colors.white)),
                      const Spacer(),
                      InkWell(
                          onTap:() {setState((){result=null;});},
                          child: const Icon(Icons.remove_circle,color: Colors.white)),
                      const SizedBox(width: 12)
                    ],
                  ),
                ),
                const Divider(color: Colors.grey),
                Container(
                  height: 90,
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      18.widthBox,
                      Expanded(
                        child: TextField(
                          controller: _noteEditingController,
                          onChanged: (value) {
                            setState(() {
                              _showError = false;
                            });
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            hintText: 'Enter Note'.tr(),
                            errorText: _showError && _noteEditingController.text.isEmpty
                                ? 'Field cannot be empty'
                                : null,
                          ),
                        ),
                      ),
                      15.widthBox,

                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(onPressed: () async {
                          try {
                            result = await FilePicker.platform.pickFiles();
                            setState((){
                            });
                          } catch (e) {
                            print('Error picking file: $e');
                            return;
                          }
                        }, icon: const Icon(Icons.attach_file)),
                      ),
                      12.widthBox,
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.indigo,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _showError = true;
                              });
                          if(result!=null){
                            _addEvent(name: _noteEditingController.text.trim().isEmpty?'File':_noteEditingController.text, color: const Color(0xFF0B6633), day: date, filePath: result!.files.single.path!);
                            _showError = false;
                            Navigator.of(context).pop();
                          }else if(_noteEditingController.text.trim().isNotEmpty){
                            _addEvent(name: _noteEditingController.text, day: date);
                            Navigator.of(context).pop();
                          }
                          result=null;
                          _noteEditingController.text = '';
                          setState((){});
                          },
                            highlightColor: Colors.indigo,
                            icon: const Icon(Icons.add,color: Colors.white,)
                        ),
                      ),
                      18.widthBox,
                    ],
                  ),
                )
              ],
            ),
          );
          },
        );
      },
    );
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay, {this.filePath});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  String? filePath; // Optional String datatype for filePath

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'background': background.value,
      'isAllDay': isAllDay,
      'filePath': filePath, // Include filePath in the JSON if available
    };
  }

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      json['eventName'],
      DateTime.parse(json['from']),
      DateTime.parse(json['to']),
      Color(json['background']),
      json['isAllDay'],
      filePath: json['filePath'], // Retrieve filePath from JSON if available
    );
  }
}


