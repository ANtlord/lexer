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
		auto lexem = _lexems[++_currentLexemCount];
		_currentLexemCount += 2; // skip assign
		auto expr = parseEx;
		auto node = new AssignNode(lexem, expr);
		return node;
	}

	/// expr : token | binaryEx
	ExprNode parseEx() {
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
		return new TokenNode(lexem);
	}
	
	/// multiplyEx:
	///		token multiply multiplyEx |
	///		token multiply addEx |
	///		token multiply token
	auto parseMultiply() {
		auto currentLexemCountBackup = _currentLexemCount;
		auto multiply = _lexems[_currentLexemCount + 1];
		if (multiply.kind != Kind.multiply) {
			_currentLexemCount = currentLexemCountBackup;
			return null;
		}
		auto left = parseToken;
		_currentLexemCount += 2;
		if(auto right = parseMultiply)
			return new MultiplyNode(left, right);
		if(auto right = parseAdd)
			return new MultiplyNode(left, right);
		else if (auto right = parseToken)
			return new MultiplyNode(left, right);
		_currentLexemCount = currentLexemCountBackup;
		return null;
	}

	/// addEx:
	///		token plus addEx |
	///		token plus multiply |
	///		token plus token
	auto parseAdd() {
		auto currentLexemCountBackup = _currentLexemCount;
		auto plus = _lexems[_currentLexemCount + 1];
		if (plus.kind != Kind.plus) {
			_currentLexemCount = currentLexemCountBackup;
			return null;
		}
		auto left = parseToken;
		_currentLexemCount += 2;
		if(auto right = parseAdd)
			return new AddNode(left, right);
		if(auto right = parseMultiply)
			return new AddNode(left, right);
		else if (auto right = parseToken)
			return new AddNode(left, right);
		_currentLexemCount = currentLexemCountBackup;
		return null;
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
