// import 'package:back_button_interceptor/back_button_interceptor.dart';
// import 'package:feranta/view_model/notification/notification_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../static/color.dart';
// import '../back_to_close/systum_back_close_app.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     // BackButtonInterceptor.add(backTocloseApp(context).myInterceptor);

//     Provider.of<NotificationViewmodel>(context, listen: false)
//         .allNotification();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     // BackButtonInterceptor.remove(backTocloseApp(context).myInterceptor);

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       // onPopInvoked: (bool didpop) async {
//       //   ShowToast(msg: "Are ou sure you want back");
//       //   if (didpop) {
//       //     return;
//       //   } else {
//       //     final shouldExit = await showExitDialog(context) ?? false;
//       //     if (context.mounted && shouldExit) {
//       //       Navigator.pop(context);
//       //     }
//       //   }
//       // ShowToast(msg: "Are ou sure you want back");
//       //  },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Notification"),
//         ),
//         body: Consumer<NotificationViewmodel>(builder: (context, val, _) {
//           return val.notificationModel != null
//               ? val.notificationModel!.response!.allNotification!.length == 0
//                   ? RefreshIndicator(
//                       child: ListView.builder(
//                           itemCount: 1,
//                           shrinkWrap: true,
//                           itemBuilder: (cotext, index) {
//                             return SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.8,
//                               child: Center(
//                                 child: Text("No Notification"),
//                               ),
//                             );
//                           }),
//                       onRefresh: () => Provider.of<NotificationViewmodel>(
//                               context,
//                               listen: false)
//                           .allNotification())
//                   : RefreshIndicator(
//                       onRefresh: () => Provider.of<NotificationViewmodel>(
//                               context,
//                               listen: false)
//                           .allNotification(),
//                       child: ListView.separated(
//                           shrinkWrap: true,
//                           itemCount: val.notificationModel!.response!
//                               .allNotification!.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               // color:
//                               //     ndex != null && ndex == index ? Colors.green : null,
//                               margin: EdgeInsets.only(
//                                   left: 20, right: 20, top: 5, bottom: 5),
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(15),
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black26, blurRadius: 2)
//                                   ]),
//                               child: ListTile(
//                                 leading: Icon(Icons.image),
//                                 hoverColor: Colors.white,
//                                 onTap: () {
//                                   // context.push('/home/bookingsr1',
//                                   //     extra: {'id': "0"});
//                                 },
//                                 title: Text(
//                                   "${val.notificationModel!.response!.allNotification![index].title ?? ""}",
//                                   style: Theme.of(context).textTheme.bodyMedium,
//                                 ),
//                                 subtitle: Text(
//                                   "${val.notificationModel!.response!.allNotification![index].message ?? ""}",
//                                   maxLines: 2,
//                                   style: Theme.of(context).textTheme.labelSmall,
//                                 ),
//                               ),
//                             );
//                           },
//                           separatorBuilder: (context, index) => SizedBox(
//                                 height: 5,
//                               )),
//                     )
//               : SizedBox();
//         }),
//       ),
//     );
//   }
// }
