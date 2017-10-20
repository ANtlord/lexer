module parse.ast;
import lex;

abstract class Node {
	void eval();
}

class ExprNode : Node {
}

class TokenNode : ExprNode {
	this(Lexem lexem) {
		this.lexem = lexem;
	}
	Lexem lexem;
}

class PrintNode : Node {
	this(ExprNode node) {
		this.node = node;
	}
	ExprNode node;
}

class BinaryExNode : ExprNode {
	this(ExprNode left, ExprNode right) {
		this.left = left;
		this.right = right;
	}
	ExprNode left;
	ExprNode right;
}

class MultiplyNode : BinaryExNode {
	this(ExprNode left, ExprNode right) {
		super(left, right);
	}
}

class AddNode : BinaryExNode {
	this(ExprNode left, ExprNode right) {
		super(left, right);
	}
}

class AssignNode : Node {
	this(Lexem identifier, ExprNode value) {
		this.identifier = identifier;
		this.value = value;
	}
	Lexem identifier;
	ExprNode value;
}
