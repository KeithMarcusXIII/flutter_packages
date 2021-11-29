library generator;

import 'package:api_generator/src/generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

export 'src/generator.dart';

Builder apiBuilder(BuilderOptions options) => SharedPartBuilder(
    [ApiGenerator(/* ApiGeneratorOptions.fromOptions(options) */)], 'appgen');
