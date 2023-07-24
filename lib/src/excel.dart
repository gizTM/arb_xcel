import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arbxcel_with_options/src/assets.dart';
import 'package:arbxcel_with_options/src/excel_template_with_type_column.dart';
import 'package:excel/excel.dart';

import 'arb.dart';

const int _kRowHeader = 0;
const int _kRowValue = 1;

const int _kColName = 0;
const int _kColType = 1;
const int _kColDescription = 2;
const int _kColValue = 3;

/// Create a new Excel template file.
///
/// Embedded data will be packed via `assets.dart`.
void newTemplate(String filename) {
  final Uint8List buf = base64Decode(kTemplate);
  File(filename).writeAsBytesSync(buf);
}

/// Create a new Excel template file with 'type' column.
///
/// Embedded data will be packed via `excel_template_with_type_column.dart`.
void newTemplateWithType(String filename) {
  final Uint8List buf = base64Decode(kNewTemplate);
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
  String normalizeLangColName(String langColName) {
    switch (langColName.toLowerCase()) { 
      case 'en':
      case 'english': 
        return 'en';
      case 'th':
      case 'thai': 
        return 'th';
      default: 
        return langColName;
    }
  }
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

    final String? type = row[_kColType]?.value;
    final String? description = row[_kColDescription]?.value;
    final ARBItem item = ARBItem(
      name: name!,
      type: type,
      description: description,
      translations: {},
    );

    for (int i = _kColValue; i < sheet.maxCols; i++) {
      final langColName = columns[i]?.value ?? i.toString();
      String lang = normalizeLangColName(langColName);
      String valueString = row[i]?.value ?? '';
      item.translations[lang] = valueString.replaceAll('"', '\\"').replaceAll('\n', '\\n');
    }

    items.add(item);
  }

  final List<String> languages = columns
      .where((e) => e != null && e.colIndex >= _kColValue)
      .map<String>((e) => normalizeLangColName(e?.value))
      .toList();
  return Translation(languages: languages, items: items);
}

/// Writes a Excel file, includes all translations.
void writeExcel(String filename, Translation data) {
  throw UnimplementedError();
}
