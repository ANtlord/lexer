import std.file: readText;
import std.regex;
import std.format;
import std.stdio;

import lex;

void main()
{

	auto text = readText("testfile.txt");
	auto offset = 0;
	auto r = regex("([a-z]|[A-Z])*");
	auto res = matchFirst(text[offset .. $], r);

	auto resText = res.hit;
	writeln("hit: %s; length: %d".format(resText, resText.length));
	writeln(def);
}
