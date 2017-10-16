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
		this.offset = offset;
	}

	this(Kind kind, string val, ulong offset, ulong len) {
		this.kind = kind;
		this.val = val;
		this.offset = offset;
		this.len = len;
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
	if(is(T == string))
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

immutable staticLexemDefs = [
	staticLexemDef(Kind.assign, "="),
	staticLexemDef(Kind.plus, "+"),
	staticLexemDef(Kind.multiply, "*"),
	staticLexemDef(Kind.divide, "/"),
	staticLexemDef(Kind.semicolon, ";"),
	staticLexemDef(Kind.var, "auto", true),
	staticLexemDef(Kind.print, "print", true),
	staticLexemDef(Kind.minus, "minus"),
];

immutable dynamicLexemDefs = [
	dynanicLexemDef(Kind.identifier, r"^[a-zA-Z_][a-zA-Z0-9_]*"),
	dynanicLexemDef(Kind.number, r"^(0|[1-9][0-9]*)"),
];

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
