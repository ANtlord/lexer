module parse;
public import parse.ast;

import lex;

struct Parser {

	this(in Lexem[] lexems) {
		_lexems = lexems;
	}

	auto parse() {
		while (_currentLexemCount < _lexems.length) {
			auto currentLexem = _lexems[_currentLexemCount];
			final switch(currentLexem.kind)
			{
				case Kind.var:
					parseAssignEx();
					break;
				case Kind.dot:
					assert(false);
					break;
				case Kind.print:
					parsePrintEx();
					break;
				case Kind.plus:
					assert(false);
					break;
				case Kind.minus:
					assert(false);
					break;
				case Kind.number:
					assert(false);
					break;
				case Kind.divide:
					assert(false);
					break;
				case Kind.assign:
					assert(false);
					break;
				case Kind.multiply:
					assert(false);
					break;
				case Kind.semicolon:
					assert(false);
					break;
				case Kind.identifier:
					assert(false);
					break;
			}
		}
	}

	/// printEx: print expr
	auto parsePrintEx() {
		auto expr = parseEx;
		return new PrintNode(expr);
	}

	/// assignEx: var identifier assign expr
	auto parseAssignEx() {
		auto lexem = _lexems[_currentLexemCount];
		auto expr = parseEx;
		return new AssignNode(lexem, expr);
	}

	/// expr : binaryEx | token
	ExprNode parseEx() {
		return parseBinaryEx || parseToken;
	}

	/// token : number | identifier
	auto parseToken() {
		auto lexem = _lexems[_currentLexemCount];
		return new TokenNode(lexem);
	}

	/// multiplyEx:
	///		binaryEx multiply binaryEx |
	///		token multiply binaryEx |
	///		binaryEx multiply token |
	///		token multiply token
	auto parseMultiply() {
		auto left = parseEx;
		auto right = parseEx;
		return new MultiplyNode(left, right);
	}

	/// addEx:
	///		binaryEx add binaryEx |
	///		token add binaryEx |
	///		binaryEx add token |
	///		token add token
	AddNode parseAdd() {
		auto left = parseEx;
		auto right = parseEx;
		return new AddNode(left, right);
	}

	/// binaryEx: addEx | multiplyEx
	auto parseBinaryEx() {
		return parseAdd || parseMultiply;
	}

private:
	const Lexem[] _lexems;
	ulong _currentLexemCount = 0;
}
