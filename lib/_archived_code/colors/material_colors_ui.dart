// import 'package:beseech/main.dart';
// import 'package:colornames/colornames.dart';
// import 'package:beseech/settings/settings_bloc.dart';

// class MaterialColorsUI extends UI {
//   const MaterialColorsUI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: ListView(
//         physics: const BouncingScrollPhysics(),
//         shrinkWrap: true,
//         children: [
//           "COLORS"
//               .text(
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontFamily: 'Dank Mono',
//                 ),
//               )
//               .pad(),
//           GridView.count(
//             physics: const BouncingScrollPhysics(),
//             shrinkWrap: true,
//             crossAxisCount: 4,
//             children: [
//               for (final eachColor in Colors.primaries)
//                 Tooltip(
//                   message: eachColor.colorName,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         elevation: 10,
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(settingsBloc.borderRadius),
//                         ),
//                         backgroundColor: eachColor),
//                     onPressed: settingsBloc.color == eachColor
//                         ? null
//                         : () {
//                             settingsBloc.setColor(eachColor);
//                           },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: eachColor[300],
//                         borderRadius: BorderRadius.circular(
//                           settingsBloc.borderRadius,
//                         ),
//                       ),
//                     ).pad(),
//                   ).pad(),
//                 )
//             ],
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(
//                   settingsBloc.borderRadius,
//                 ),
//               ),
//             ),
//             onPressed: null,
//             child: settingsBloc.color.colorName.toUpperCase().text().pad(),
//           ).pad(),
//         ],
//       ),
//     );
//   }
// }


// class PaddingUI extends UI {
//   const PaddingUI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Slider(
//             value: settingsBloc.padding,
//             onChanged: settingsBloc.setPadding,
//             min: 4,
//             max: 10,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BorderRadiusUI extends UI {
//   const BorderRadiusUI({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Slider(
//             value: settingsBloc.borderRadius,
//             onChanged: settingsBloc.setBorderRadius,
//             min: 0,
//             max: 30,
//           ),
//         ],
//       ),
//     );
//   }
// }

  // ElevatedButton(
          //   onPressed: () {
          //     _navigatorBloc.dialog(
          //       BorderRadiusUI(),
          //     );
          //   },
          //   child: Text(
          //     'BORDER RADIUS',
          //     style: Theme.of(context).textTheme.titleLarge,
          //   ),
          // ).pad(),
          // ElevatedButton(
          //   onPressed: () {
          //     _navigatorBloc.dialog(PaddingUI());
          //   },
          //   child: Text(
          //     'PADDING',
          //     style: Theme.of(context).textTheme.titleLarge,
          //   ),
          // ).pad(),
          // ElevatedButton(
          //   onPressed: () {
          //     _navigatorBloc.dialog(MaterialColorsUI());
          //   },
          //   child: Text(
          //     'COLORS',
          //     style: Theme.of(context).textTheme.titleLarge,
          //   ),
          // ).pad(),