import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';

import 'package:arbxcel_with_options/arbxcel.dart';

const _kVersion = '0.0.2';

void main(List<String> args) {
  final ArgParser parse = ArgParser();
  parse.addFlag('new',
      abbr: 'n', defaultsTo: false, help: 'New translation sheet');
  parse.addFlag('arb',
      abbr: 'a', defaultsTo: false, help: 'Export to ARB files - specify original .xlsx and sheet name (default to Sheet1)');
  parse.addFlag('excel',
      abbr: 'e', defaultsTo: false, help: 'Import ARB files to sheet');
  final ArgResults flags = parse.parse(args);

  // Not enough args
  if (args.length < 2) {
    usage(parse);
    exit(1);
  }

  final String filename = flags.rest.first;
  final String sheetname = flags.rest.length > 1 ? flags.rest[1] : 'Sheet1';

  if (flags['new']) {
    stdout.writeln('Create new Excel file for translation: $filename');
    newTemplate(filename);
    exit(0);
  }

  if (flags['arb']) {
    stdout.writeln('Generate ARB from: $filename');
    final data = parseExcel(filename: filename, sheetname: sheetname);
    writeARB('${withoutExtension(filename)}.arb', data);
    exit(0);
  }

  if (flags['excel']) {
    stdout.writeln('Generate Excel from: $filename');
    final data = parseARB(filename);
    writeExcel('${withoutExtension(filename)}.xlsx', data);
    exit(0);
  }
}

void usage(ArgParser parse) {
  stdout.writeln('arb_sheet v$_kVersion\n');
  stdout.writeln('USAGE:');
  stdout.writeln(
    '  arb_sheet [OPTIONS] path/to/file/name [other args]\n',
  );
  stdout.writeln('OPTIONS');
  stdout.writeln(parse.usage);
}
