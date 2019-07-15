import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Options Page', () {
    final continueBtnFinder = find.byValueKey('continue');
    final quitBtnFinder = find.byValueKey('quit');
    var iconFinder = find.byValueKey('face');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if(driver != null) {
        driver.close();
      }
    });

    test('Shows controls', () async {
      await driver.waitFor(continueBtnFinder, timeout: Duration(milliseconds: 1500));
      await driver.waitFor(quitBtnFinder, timeout: Duration(milliseconds: 500));
      await driver.waitFor(iconFinder, timeout: Duration(milliseconds: 500));

      //var renderTree = await driver.getRenderTree();

      //print("renderTree = ${renderTree.tree}");
    });

    test('Shows snackbar after positive input', () async {
      await driver.waitFor(continueBtnFinder, timeout: Duration(milliseconds: 1500));
      await driver.tap(continueBtnFinder);
      await driver.waitFor(find.text('Yay!!'));
    });

    test('Shows snackbar after negative input', () async {
      await driver.waitFor(quitBtnFinder, timeout: Duration(milliseconds: 1500));
      await driver.tap(quitBtnFinder);
      await driver.waitFor(find.text('Awww!!'));
    });
  });
}