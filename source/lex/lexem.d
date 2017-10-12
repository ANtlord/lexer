/**
 * Provides abstractions represents lexems.
 */
module lex.lexem;
import std.regex;
import std.format;

enum Kind
{
	var,
	dot,
	print,
	plus,
	minus,
	number,
	divide,
	assign,
	multiply,
	semicolon,
	identifier
}

struct Lexem {
	this(StaticLexemDef!string definition, ulong offset) {
		kind = definition.kind;
		val = definition.repr;
		len = definition.length;
		offset = offset;
	}

	this(Kind kind, string val, ulong offset, ulong len) {
		kind = kind;
		val = val;
		offset = offset;
		len = len;
	}

	Kind kind;
	string val;
	ulong offset;
	ulong len;
}

auto dynanicLexemDef(T)(Kind kind, T repr) {
	DynanicLexemDef!T obj = {
		kind: kind,
		repr: repr,
	};
	return obj;
}

auto staticLexemDef(T)(Kind kind, T repr, bool isKeyword = false) {
	StaticLexemDef!T obj = {
		kind: kind,
		repr: repr,
		isKeyword: isKeyword,
	};
	return obj;
}

struct DynanicLexemDef(T)
	if(is(T == Regex!char))
{
	mixin ALexemDef!T;
}

struct StaticLexemDef(T)
	if(is(T == string))
{
	bool isKeyword;
	ulong length() const {
		return repr.length;
	}
	mixin ALexemDef!T;
}

private:

mixin template ALexemDef(T)
{
	Kind kind;
	T repr;
	string toString() const {
		return "[%s: %s]".format(this.kind, this.repr);
	}
	alias toString this;
}
