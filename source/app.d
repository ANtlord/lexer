import std.file: readText;
import std.regex;
import std.format;
import std.stdio;
import std.string;

import lex;


void main()
{
	auto sourceCode = readText("testfile.txt");
	// auto lexer = Lexer(sourceCode);
	// lexer.parse;

	// ulong offset = 0;
	// auto sourceCodeLen = sourceCode.length;
	// while(offset < sourceCodeLen) {

	// }
	// auto r = r"(0|[1-9][0-9]*)".regex;
	auto r = r"\d+".regex;
	auto data = "var3dor2 = 1;";
	auto space_position = data.indexOf(' ');
	auto caps = matchFirst(data[0 .. space_position], r);
	if(!caps.empty) {
		auto resText = caps.hit;
		writeln("hit: '%s'; length: %d".format(resText, resText.length));
	}

	// auto res = matchFirst(sourceCode[offset .. $], r);

	// writeln(def);
}
