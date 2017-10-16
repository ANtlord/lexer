import std.file: readText;
import std.regex;
import std.format;
import std.stdio;
import std.string;

import lex;
import parse;


void main()
{
	auto sourceCode = readText("testfile.txt");
	auto lexer = Lexer(sourceCode);
	auto lexems = lexer.parse;
	foreach(l; lexems)
		writeln(l);
	writeln("");
	auto parser = Parser(lexems);
	auto nodes = parser.parse;
	// foreach(n; nodes)
		// writeln(n);

	// ulong offset = 0;
	// auto sourceCodeLen = sourceCode.length;
	// while(offset < sourceCodeLen) {

	// }
	// auto r = r"(0|[1-9][0-9]*)".regex;
	// auto r = r"\d+".regex;
	// auto r = r"^[a-zA-Z_][a-zA-Z0-9_]*";
	// auto data = "var3dor2 = 1;";
	// // auto space_position = data.indexOf(' ');
	// auto caps = matchFirst(data[0 .. $], r);
	// if(!caps.empty) {
		// auto resText = caps.hit;
		// writeln("hit: '%s'; length: %d".format(resText, resText.length));
	// }
	// auto caps2 = matchFirst(data[0 .. $], r);
	// if(!caps2.empty) {
		// auto resText = caps2.hit;
		// writeln("hit: '%s'; length: %d".format(resText, resText.length));
	// }

	// auto res = matchFirst(sourceCode[offset .. $], r);

	// writeln(def);
}
