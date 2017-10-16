module parse;
import std.stdio;
public import parse.ast;

import lex;

struct Parser {

	this(in Lexem[] lexems) {
		_lexems = lexems;
	}

	auto parse() {
		Node[] nodes;
		while (_currentLexemCount < _lexems.length) {
			auto currentLexem = _lexems[_currentLexemCount];
			final switch(currentLexem.kind)
			{
				case Kind.var:
					nodes ~= parseAssignEx();
					++_currentLexemCount;
					break;
				case Kind.dot:
					assert(false);
				case Kind.print:
					nodes ~= parsePrintEx();
					++_currentLexemCount;
					break;
				case Kind.plus:
					assert(false);
				case Kind.minus:
					assert(false);
				case Kind.number:
					assert(false);
				case Kind.divide:
					assert(false);
				case Kind.assign:
					assert(false);
				case Kind.multiply:
					assert(false);
				case Kind.semicolon:
					++_currentLexemCount;
					break;
				case Kind.identifier:
					assert(false);
			}
		}
		return nodes;
	}

	/// printEx: print expr
	auto parsePrintEx() {
		++_currentLexemCount;
		auto expr = parseEx;
		return new PrintNode(expr);
	}

	/// assignEx: var identifier assign expr
	auto parseAssignEx() {
		writeln("parse assign");
		auto lexem = _lexems[++_currentLexemCount];
		writeln(lexem);
		_currentLexemCount += 2; // skip assign
		auto expr = parseEx;
		auto node = new AssignNode(lexem, expr);
		writeln(expr, _currentLexemCount);
		return node;
	}

	/// expr : binaryEx | token
	ExprNode parseEx() {
		writeln("parseEx");
		if (auto res = parseBinaryEx)
			return res;
		else if(auto res = parseToken)
			return res;
		else
			throw new ParseException;
	}

	/// token : number | identifier
	auto parseToken() {
		auto lexem = _lexems[_currentLexemCount];
		writeln(lexem);
		return new TokenNode(lexem);
	}

	/// multiplyEx:
	///		binaryEx multiply binaryEx |
	///		token multiply binaryEx |
	///		binaryEx multiply token |
	///		token multiply token
	auto parseMultiply() {
		auto currentLexemCountBackup = _currentLexemCount;
		auto multiply = _lexems[_currentLexemCount + 1];
		if (multiply.kind != Kind.multiply) {
			_currentLexemCount = currentLexemCountBackup;
			return null;
		}
		auto left = parseEx;
		_currentLexemCount += 2;
		auto right = parseEx;
		return new MultiplyNode(left, right);
	}

	/// addEx:
	///		binaryEx plus binaryEx |
	///		token plus binaryEx |
	///		binaryEx plus token |
	///		token plus token
	auto parseAdd() {
		writeln("parseAdd");
		auto currentLexemCountBackup = _currentLexemCount;
		auto multiply = _lexems[_currentLexemCount + 1];
		if (multiply.kind != Kind.plus) {
			_currentLexemCount = currentLexemCountBackup;
			return null;
		}
		auto left = parseEx;
		_currentLexemCount += 2;
		auto right = parseEx;
		return new AddNode(left, right);
	}

	/// binaryEx: addEx | multiplyEx
	BinaryExNode parseBinaryEx() {
		if (auto res = parseAdd)
			return res;
		else if(auto res = parseMultiply)
			return res;
		else
			return null;
	}

private:
	const Lexem[] _lexems;
	ulong _currentLexemCount = 0;
}

class ParseException : Exception
{
	public this(string msg = "Parse error", string file = __FILE__, int line = __LINE__)
	{
		super(msg, file, line);
	}
}
