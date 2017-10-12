module lex.lexer;

import std.array;
import std.algorithm;
import std.string;
import lex.lexem;
import std.regex;
import std.stdio;

immutable staticLexemDefs = [
	staticLexemDef(Kind.var, "auto", true),
	staticLexemDef(Kind.print, "print", true),
	staticLexemDef(Kind.assign, "="),
	staticLexemDef(Kind.plus, "+"),
	staticLexemDef(Kind.minus, "minus"),
	staticLexemDef(Kind.multiply, "*"),
	staticLexemDef(Kind.divide, "/"),
	staticLexemDef(Kind.semicolon, ";"),
];

auto dynamicLexemDefs = [
	dynanicLexemDef(Kind.identifier, r"[a-zA-Z_][a-zA-Z0-9_]*".regex),
	dynanicLexemDef(Kind.number, r"(0|[1-9][0-9]*)*".regex),
];

immutable spaces = [' ', '\r', '\n', '\t'];

bool isIn(T)(T hay, string stack)
	if(is(T == char) || is(T == string) || is(T == immutable char))
{
	return stack.indexOf(hay) != -1;
}

struct Lexer {
	string sourceCode;
	ulong offset = 0;

	auto skipSpaces() const {
		ulong counter = 0;
		while(sourceCode[offset + counter].isIn(spaces))
			++counter;
		return offset + counter;
	}

	void parse() {
		while (this.isNotInTheEnd) {
			offset = skipSpaces;
			try {
				auto lexem = parseStaticLexem;
				offset += lexem.len;
			} catch(LexemNotFound e) {
				try {
					auto lexem = parseDynamicLexem;
					offset += lexem.len;
				} catch(LexemNotFound e) {
					writeln("I can't find any lexem definition from position", offset);
					throw new LexemNotFound;
				}
			}
		}
	}

	bool isNotInTheEnd() const {
		return offset < sourceCode.length;
	}

	/// Return lexem if it was found. Kind of the lexem is kind of a static lexem definition.
	Lexem parseStaticLexem() const {
		auto matchedDefinitions = staticLexemDefs.filter!(a => isMatchedLexemDef(a)).array;
		assert(matchedDefinitions.length < 2);
		if (matchedDefinitions.length == 0) {
			throw new LexemNotFound;
		}
		auto matchedDefinition = matchedDefinitions[0];
		return Lexem(matchedDefinition, offset);
	}

	Lexem parseDynamicLexem() const {
		auto matchedDefinitions = dynamicLexemDefs.filter!(a => isMatchedLexemDef(a)).array;
		assert(matchedDefinitions.length < 2);
		if (matchedDefinitions.length == 0) {
			throw new LexemNotFound;
		}
		auto matchedDefinition = matchedDefinitions[0];

		auto lexem_regex = matchedDefinition.repr;
		auto captures = matchFirst(sourceCode[offset .. $], lexem_regex);
		auto lexem_value = captures.hit;
		return Lexem(
			matchedDefinition.kind,
			lexem_value,
			offset,
			lexem_value.length,
		);
	}

	/// Return true if static lexem definition is matched.
	bool isMatchedLexemDef(in StaticLexemDef!string lexemDefinition) const {
		auto end = offset + lexemDefinition.length;
		return sourceCode[offset .. end] == lexemDefinition.repr;
	}

	/// Return true if dynamic lexem definition is matched.
	bool isMatchedLexemDef(DynanicLexemDef!(Regex!char) lexemDefinition) const {
		auto lexem_regex = lexemDefinition.repr;
		writeln("Incoming code for dynamic lexem '", sourceCode[offset .. $], "'");
		auto captures = matchFirst(sourceCode[offset .. $], lexem_regex);
		// writeln("Matched part of source code '%s'".format(captures.hit));
		return !captures.empty;
	}
}

class LexemNotFound : Exception
{
	public this(string msg = "", string file = __FILE__, int line = __LINE__)
	{
		super(msg, file, line);
	}
}
