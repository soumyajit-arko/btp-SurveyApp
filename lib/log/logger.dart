import 'package:logging/logging.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

final Logger log = Logger('ExampleLogger');

void setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
    writeLogToFile('${record.level.name}: ${record.time}: ${record.message}');
  });
}

Future<void> writeLogToFile(String log) async {
  final file = await _getLogFile();
  await file.writeAsString('$log\n', mode: FileMode.append);
}

Future<File> _getLogFile() async {
  final directory = await _getLoggingDirectory();
  return File('${directory.path}/log.txt');
}

Future<Directory> _getLoggingDirectory() async {
  final directory = await getApplicationDocumentsDirectory();
  final loggingDirectory = Directory('${directory.path}/logs');
  if (!await loggingDirectory.exists()) {
    await loggingDirectory.create(recursive: true);
  }
  return loggingDirectory;
}
