import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/main.dart';
import 'package:path_provider/path_provider.dart';

class HiveClass {
  void _initHive() async {
    await Hive.initFlutter();
    var box = await Hive.openBox('myBox');
  }

  void FilePath() async {
    _initHive();
    WidgetsFlutterBinding.ensureInitialized();
    var appDocumentDirectory = await getApplicationDocumentsDirectory();
    print(appDocumentDirectory.path);
    runApp(MyApp());
  }
}

class MatrixElement {
  final int value;

  MatrixElement(this.value);
}

void _readAndPrintMatrixData() async {
  final matrixBox = await Hive.openBox('matrixBox');

  if (matrixBox.isNotEmpty) {
    final element = matrixBox.getAt(0) as MatrixElement;
    print('Value from Hive Box: ${element.value}');
  } else {
    print('Hive Box is empty or not initialized.');
  }
}
