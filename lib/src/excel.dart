import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arbxcel_with_options/src/assets.dart';
import 'package:excel/excel.dart';

import 'arb.dart';

const int _kRowHeader = 0;
const int _kRowValue = 1;
const int _kColName = 0;
const int _kColDescription = 1;
const int _kColValue = 2;

/// Create a new Excel template file.
///
/// Embedded data will be packed via `template.dart`.
void newTemplate(String filename) {
  final Uint8List buf = base64Decode(kTemplate);
  File(filename).writeAsBytesSync(buf);
}

/// Reads Excel sheet.
///
/// Uses `arb_sheet -n path/to/file` to create a translation file
/// from the template.
Translation parseExcel({
  required String filename,
  String sheetname = 'Sheet1', // default for google sheet export file
  int headerRow = _kRowHeader,
  int valueRow = _kRowValue,
}) {
  final Uint8List buf = File(filename).readAsBytesSync();
  final Excel excel = Excel.decodeBytes(buf);
  final Sheet? sheet = excel.sheets[sheetname];
  if (sheet == null) {
    stdout.writeln('Exit: Excel.decodeBytes(File.readAsBytesSync()).sheets[$sheetname] is null...');
    return const Translation();
  }

  final List<ARBItem> items = <ARBItem>[];
  final List<Data?> columns = sheet.rows[headerRow];
  for (int i = valueRow; i < sheet.rows.length; i++) {
    final List<Data?> row = sheet.rows[i];
    final String? name = row[_kColName]?.value?.trim();
    if (name?.trim().isNotEmpty != true) continue;

    final String? description = row[_kColDescription]?.value;
    final ARBItem item = ARBItem(
      name: name!,
      description: description,
      translations: {},
    );

    for (int i = _kColValue; i < sheet.maxCols; i++) {
      final langColName = columns[i]?.value ?? i.toString();
      String lang = '';
      switch (langColName.toLowerCase()) { 
        case 'en':
        case 'english': lang = 'en'; break;
        case 'th':
        case 'thai': lang = 'th'; break;
        default: lang = langColName; break;
      }
      String valueString = row[i]?.value ?? '';
      item.translations[lang] = valueString.replaceAll('"', '\\"');
    }

    items.add(item);
  }

  final List<String> languages = columns
      .where((e) => e != null && e.colIndex >= _kColValue)
      .map<String>((e) => e?.value)
      .toList();
  return Translation(languages: languages, items: items);
}

/// Writes a Excel file, includes all translations.
void writeExcel(String filename, Translation data) {
  throw UnimplementedError();
}
