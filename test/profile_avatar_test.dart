// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:image_input/widget/profile_avatar.dart';

void main() {
  // testWidgets('Profile Avatar allowEdit test', (tester) async {
  //   await tester.pumpWidget(
  //     const MaterialApp(
  //       home: Scaffold(
  //         body: Center(
  //           child: ProfileAvatar(
  //             allowEdit: true,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   final removeIconFinder = find.byIcon(Icons.close);

  //   expect(removeIconFinder, findsNothing);

  //   final addIconFinder = find.byIcon(Icons.add_a_photo_outlined);

  //   expect(addIconFinder, findsOneWidget);
  // });

  // testWidgets("Profile Avatar radius test", (tester) async {
  //   await tester.pumpWidget(
  //     const MaterialApp(
  //       home: Scaffold(
  //         body: Center(
  //           child: ProfileAvatar(
  //             radius: 50,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   final circleAvatarFinder = find.byType(CircleAvatar);

  //   expect(circleAvatarFinder, findsOneWidget);

  //   final circleAvatar = tester.widget<CircleAvatar>(circleAvatarFinder);

  //   expect(circleAvatar.radius, 50);
  // });

  // //backgroundColor test
  // testWidgets("Profile Avatar backgroundColor test", (tester) async {
  //   await tester.pumpWidget(
  //     const MaterialApp(
  //       home: Scaffold(
  //         body: Center(
  //           child: ProfileAvatar(
  //             backgroundColor: Colors.red,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   final circleAvatarFinder = find.byType(CircleAvatar);

  //   expect(circleAvatarFinder, findsOneWidget);

  //   final circleAvatar = tester.widget<CircleAvatar>(circleAvatarFinder);

  //   expect(circleAvatar.backgroundColor, Colors.red);
  // });

  // //add image icon and its alignment test
  // testWidgets("Profile Avatar add image icon and its alignment test",
  //     (tester) async {
  //   await tester.pumpWidget(
  //     const MaterialApp(
  //       home: Scaffold(
  //         body: Center(
  //           child: ProfileAvatar(
  //             allowEdit: true,
  //             addImageIcon: Icon(Icons.add),
  //             addImageIconAlignment: Alignment.topLeft,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   final addIconFinder = find.byIcon(Icons.add);

  //   expect(addIconFinder, findsOneWidget);

  //   final addIcon = tester.widget<Icon>(addIconFinder);

  //   expect(addIcon.icon, Icons.add);

  //   final addIconAlignmentFinder = find.byWidgetPredicate((widget) {
  //     if (widget is Align) {
  //       return widget.alignment == Alignment.topLeft;
  //     }
  //     return false;
  //   });

  //   expect(addIconAlignmentFinder, findsOneWidget);

  //   await tester.pumpWidget(
  //     const MaterialApp(
  //       home: Scaffold(
  //         body: Center(
  //           child: ProfileAvatar(
  //             allowEdit: true,
  //             addImageIcon: Icon(Icons.add),
  //             addImageIconAlignment: Alignment.bottomRight,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   final addIconAlignmentFinder2 = find.byWidgetPredicate((widget) {
  //     if (widget is Align) {
  //       return widget.alignment == Alignment.bottomRight;
  //     }
  //     return false;
  //   });

  //   expect(addIconAlignmentFinder2, findsOneWidget);
  // });
}
