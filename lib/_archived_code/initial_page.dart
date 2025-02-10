// import 'package:beseech/initial/user_bloc.dart';
// import 'package:beseech/main.dart';

// import 'package:beseech/splash/splash_bloc.dart';

// class InitialPage extends UI {
//   const InitialPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final isAgeBased = appUser.useAgeBasedPubertyOrExplicitPuberty;
//     return Scaffold(
//       appBar: AppBar(
//         title: 'First Run - Startup'.text(),
//       ),
//       body: ListView(
//         physics: const BouncingScrollPhysics(),
//         children: [
//           TextFormField(
//             initialValue: userBloc.userName,
//             onChanged: userBloc.setUserName,
//           ).pad(),
//           SwitchListTile(
//             title: 'Do you know your puberty date?'.text(),
//             value: userBloc.knowsPubertyDate,
//             onChanged: (value) => userBloc.setKnowsPubertyDate(value),
//           ),
//           FilledButton(
//             onPressed: () {
//               splashBloc.initialize();
//             },
//             child: 'Date Of Birth'.text(),
//           ).pad(),
//           FilledButton(
//             onPressed: () {
//               splashBloc.initialize();
//             },
//             child: 'Date Of Puberty'.text(),
//           ).pad(),
//           FilledButton(
//             onPressed: () {
//               splashBloc.initialize();
//             },
//             child: 'Initialize'.text(),
//           ).pad(),
//         ],
//       ),
//     );
//   }
// }

// // void updateDateOfPuberty({
// //   DateTime? givenDate,
// //   required BuildContext context,
// // }) async {
// //   // ignore: unused_local_variable
// //   final value = await showDatePicker(
// //     context: context,
// //     initialDate: DateTime.now(),
// //     firstDate: DateTime(1950),
// //     lastDate: DateTime.now(),
// //   );
// //   // if (value == null) {
// //   //   appUserRM(AppUserEvent.setDateOfPubertyExplicit(givenDate!));
// //   // } else {
// //   //   appUserRM(AppUserEvent.setDateOfPubertyExplicit(value));
// //   // }
// // }

// // /// name
// // /// date of birth
// // /// date of puberty
// // ///
// // ///
// // ///

