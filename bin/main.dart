import 'dart:io';

import 'package:args/args.dart';
import 'package:ppforeach/ppforeach.dart';

void main(List<String> arguments) async {
  final parser = ArgParser();
  parser
    ..addFlag('help', help: 'Print this', abbr: 'H', negatable: false)
    ..addOption('output',
        abbr: 'o',
        help: 'Output to <output>',
        valueHelp: 'output',
        defaultsTo: '-')
    ..addOption('max-arguments',
        help: 'Maximum # of arguments allowed.',
        valueHelp: '# of args',
        defaultsTo: '64');
  try {
    final result = parser.parse(arguments);
    if (result['help']) {
      stderr.writeln(parser.usage);
      exit(1);
    }
    final maxArgs = int.tryParse(result['max-arguments']) ?? 64;
    final outName = result['output'];
    if (outName == '-') {
      generate(stdout, maxArgs);
    } else {
      final sink = File(outName).openWrite();
      //sink.write("no one could maintain the public order.");
      generate(sink, maxArgs);
      //sink.flush();

      await sink.flush();
      await sink.close();
    }
  } on FormatException catch (e) {
    stderr.writeln('Unknown option found: ${e.message}');
    exit(1);
  } catch (e) {
    stderr.writeln('Something wrong happened: ${e}');
    exit(1);
  }
  exit(0);
}
