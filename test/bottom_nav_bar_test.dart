import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_task_final/widgets/bottom_nav_bar.dart';

void main() {
  testWidgets('BottomNavBar Widget Test', (WidgetTester tester) async {
    // Define variables for testing
    int currentIndex = 1;
    int tappedIndex = -1; // Initialize tappedIndex to verify onTap callback

    // Create a function to mock onTap callback
    void mockOnTap(int index) {
      tappedIndex = index;
    }

    // Build the BottomNavBar widget within a test environment
    await tester.pumpWidget(MaterialApp(
      home: BottomNavBar(
        currentIndex: currentIndex,
        onTap: mockOnTap,
      ),
    ));

    // Verify the initial state of the BottomNavBar widget
    expect(find.byIcon(Icons.home), findsOneWidget); // Verify 'Home' icon
    expect(find.byIcon(Icons.task), findsOneWidget); // Verify 'Tasks' icon
    expect(find.byIcon(Icons.person), findsOneWidget); // Verify 'Profiles' icon

    // Tap on the 'Home' icon and verify onTap callback
    await tester.tap(find.byIcon(Icons.home));
    await tester.pump(); // Rebuild the widget after the tap
    expect(tappedIndex, 0); // Expect tappedIndex to be 0 (index of 'Home' icon)

    // Tap on the 'Tasks' icon and verify onTap callback
    await tester.tap(find.byIcon(Icons.task));
    await tester.pump(); // Rebuild the widget after the tap
    expect(tappedIndex, 1); // Expect tappedIndex to be 1 (index of 'Tasks' icon)

    // Tap on the 'Profiles' icon and verify onTap callback
    await tester.tap(find.byIcon(Icons.person));
    await tester.pump(); // Rebuild the widget after the tap
    expect(tappedIndex, 2); // Expect tappedIndex to be 2 (index of 'Profiles' icon)
  });
}
