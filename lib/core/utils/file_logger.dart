import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileLogger {
  static File? _logFile;

  /// Initialize the log file (call this once, like in main())
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/error_log.txt';
    _logFile = File(filePath);

    // Create the file if it doesn't exist
    if (!await _logFile!.exists()) {
      await _logFile!.create(recursive: true);
    }

    await _write('--- App Started at ${DateTime.now()} ---\n');
  }

  /// Write a log message
  static Future<void> log(String message) async {
    await _write('[${DateTime.now()}] $message\n');
  }

  /// Write errors with stack trace
  static Future<void> logError(Object error, StackTrace? stack) async {
    await _write(
      '[${DateTime.now()}] ERROR: $error\nSTACKTRACE:\n$stack\n\n',
    );
  }

  /// Helper to write to file
  static Future<void> _write(String text) async {
    if (_logFile == null) return;
    await _logFile!.writeAsString(text, mode: FileMode.append);
  }

  /// Optional: read logs
  static Future<String> readLogs() async {
    if (_logFile == null || !await _logFile!.exists()) return '';
    return await _logFile!.readAsString();
  }
}
