module lex.lexer;

import std.array;
import std.algorithm;
import std.string;
import std.regex;
import std.stdio;

import lex.lexem;

immutable spaces = [' ', '\r', '\n', '\t'];

bool isIn(T)(T hay, string stack)
	if(is(T == char) || is(T == string) || is(T == immutable char))
{
	return stack.indexOf(hay) != -1;
}

struct Lexer {
	string sourceCode;
	ulong offset = 0;

	/// Skip spaces. Return true if there is rest of symbols in file.
	auto skipSpaces() {
		while(sourceCode[offset].isIn(spaces)) {
			++offset;
			if (this.isInTheEnd)
				return false;
		}
		return true;
	}

	/// Return lexem list from file.
	auto parse() {
		Lexem[] lexemList;
		while (!this.isInTheEnd) {
			if(!skipSpaces)
				return lexemList;
			try {
				auto lexem = parseStaticLexem;
				offset += lexem.len;
				lexemList ~= lexem;
			} catch(LexemNotFound e) {
				try {
					auto lexem = parseDynamicLexem;
					offset += lexem.len;
					lexemList ~= lexem;
				} catch(LexemNotFound e) {
					writeln("I can't find any lexem definition from position", offset);
					throw new LexemNotFound;
				}
			}
		}
		return lexemList;
	}

	bool isInTheEnd() const {
		return offset >= sourceCode.length;
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

	Lexem parseDynamicLexem() const
	out(lexem) {
		assert(lexem.len > 0, "lexem.value: '%s', lexem.kind: %s".format(lexem.val, lexem.kind));
	} do {
		auto matchedDefinitions = dynamicLexemDefs.filter!(a => isMatchedLexemDef(a)).array;
		assert(matchedDefinitions.length < 2);
		if (matchedDefinitions.length == 0) {
			throw new LexemNotFound;
		}
		auto matchedDefinition = matchedDefinitions[0];

		auto lexem_regex = matchedDefinition.repr;
		auto captures = matchFirst(sourceCode[offset .. $], lexem_regex);
		auto lexem_value = captures.hit;
		return Lexem(matchedDefinition.kind, lexem_value.dup, offset, lexem_value.length);
	}

	/// Return true if static lexem definition is matched.
	bool isMatchedLexemDef(in StaticLexemDef!string lexemDefinition) const {
		auto end = offset + lexemDefinition.length;
		if (end >= sourceCode.length) {
			return false;
		}
		return sourceCode[offset .. end] == lexemDefinition.repr;
	}

	/// Return true if dynamic lexem definition is matched.
	bool isMatchedLexemDef(in DynanicLexemDef!(string) lexemDefinition) const {
		auto lexem_regex = lexemDefinition.repr;
		auto captures = matchFirst(sourceCode[offset .. $], lexem_regex);
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
