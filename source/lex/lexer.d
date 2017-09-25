module lexer;
import lex.lexem;

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

immutable dynamicLexemDefs = [
	dynanicLexemDef(Kind.identifier, r"\G[a-zA-Z_][a-zA-Z0-9_]*".regex),
	dynanicLexemDef(Kind.identifier, r"\G(0|[1-9][0-9]*)*".regex),
];
