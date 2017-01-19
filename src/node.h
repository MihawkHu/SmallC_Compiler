/*
  File:     node.h
  Author:   Hu Hu
  Function: This file defined the node in the syntax tree of the input program.
            I used enum variable to set the type of each node.
  Output:   none
*/
#ifndef NODE_H
#define NODE_H

#include <string>
#include <vector>
#include <iostream>

using namespace std;

enum NodeType{
    Expression,
    Statement,
    Function,
    Declaration,
    Program
};

enum DeclarationType{
    Dec_Global_Variable_Array,
    Dec_Global_Struct,
    Dec_Local_Variable_Array,
    Dec_Local_Struct
};

enum ExpressionType{
    Exp_Assign,
    Exp_UnaryAssign,
    Exp_Int,
    Exp_BinaryOp,
    Exp_UnaryOp,
    Exp_Variable,
    Exp_Array,
    Exp_FunctionCall,
    Exp_StructMember
};

enum StatementType{
    Stmt_Break,
    Stmt_Continue,
    Stmt_Return,
    Stmt_If,
    Stmt_IfElse,
    Stmt_StatementBlock,
    Stmt_For,
    Stmt_Read,
    Stmt_Write
};

enum OperatorType{
    OP_MUL,
    OP_DIV,
    OP_MOD,
    OP_PLUS,
    OP_MINUS,
    OP_SHL,
    OP_SHR,
    OP_GT,
    OP_GE,
    OP_LT,
    OP_LE,
    OP_ET,
    OP_NET,
    OP_BITAND,
    OP_BITXOR,
    OP_BITOR,
    OP_LOGICALAND,
    OP_LOGICALOR,
    OP_LOGICALNOT,
    OP_BITNOT,
    OP_PREINC,
    OP_PREDEC
};
struct Node;
struct Variable_ArrayDeclarationInfo;
struct Variable_ArrayDeclarationInfo {
    string ms_Name;
    vector<int> tt_ArrayDeclarationSubscriptList;
    vector<Node*>* tt_InitList;
    Variable_ArrayDeclarationInfo(){}
    ~Variable_ArrayDeclarationInfo(){}
};
struct Node {
    Node* parent;
    int tg_LineNum;
    NodeType tem_NodeType;
    string ms_Name;

    ExpressionType tem_ExpressionType;
    bool mb_LValueExpression;
    int tg_IntExpression_Val;
    vector<Node*>* tt_ArraySubscriptList;
    vector<Node*>* tt_ArgumentList;
    
    string ms_MemberName;
    Node* left_Expression;
    Node* right_Expression; 
    OperatorType tem_OP;

    DeclarationType tem_DeclarationType;
    
    vector<Variable_ArrayDeclarationInfo*>* tt_Var_Arr_Dec_Info_Vector;

    string ms_StructName;
    vector<string>* tt_StructMembers;
    vector<string>* tt_StructDeclarations;

    StatementType tem_StatementType;
    
    Node* return_Expression;

    Node* if_Expression;
    Node* then_Statement;
    Node* else_Statement;

    Node* init_Expression;
    Node* cond_Expression;
    Node* update_Expression;
    Node* for_Statement;

    vector<Node*>* declarations_in_block;
    vector<Node*>* statements_in_block;

    Node* io_Expression;

    vector<string>* parameters;
    Node* function_Body;

    vector<Node*>* extern_declarations;

    Node(int line_count, NodeType type){
        tg_LineNum = line_count;
        tem_NodeType = type;
    }
    
    void initial_Expression_Int(int value){
        tem_ExpressionType = Exp_Int;
        tg_IntExpression_Val = value;
        mb_LValueExpression = false;
    }
    
    void initial_Expression_BinaryOp(Node* left, OperatorType OP, Node* right){
        mb_LValueExpression = false;
        if(left->tem_ExpressionType == Exp_Int && right->tem_ExpressionType == Exp_Int){
            tem_ExpressionType = Exp_Int;
            int a = left->tg_IntExpression_Val;
            int b = right->tg_IntExpression_Val;
            int c;
            switch(OP){
                case OP_MUL: c = a * b; break;
                case OP_DIV: c = a / b; break;
                case OP_MOD: c = a % b; break;
                case OP_PLUS: c = a + b; break;
                case OP_MINUS: c = a - b; break;
                case OP_SHL: c = a << b; break;
                case OP_SHR: c = a >> b; break;
                case OP_GT: c = a > b; break;
                case OP_GE: c = a >= b; break;
                case OP_LT: c = a < b; break;
                case OP_LE: c = a <= b; break;
                case OP_ET: c = a == b; break;
                case OP_NET: c = a != b; break;
                case OP_BITAND: c = a & b; break;
                case OP_BITXOR: c = a ^ b; break;
                case OP_BITOR: c = a | b; break;
                case OP_LOGICALAND: c = a && b; break;
                case OP_LOGICALOR: c = a || b; break;
            }
            tg_IntExpression_Val = c;
            delete left;
            delete right;
            return;
        }
        tem_ExpressionType = Exp_BinaryOp;
        left_Expression = left;
         right_Expression = right;
         tem_OP = OP;
    }

    void initial_Expression_UnaryOp(OperatorType OP, Node* right){
        mb_LValueExpression = false;
        if(right->tem_ExpressionType == Exp_Int){
            tem_ExpressionType = Exp_Int;
            int b = right->tg_IntExpression_Val;
            switch(OP){
                case OP_MINUS: b = -b; break;
                case OP_LOGICALNOT: b = !b; break;
                case OP_BITNOT: b = ~b; break;
            }
            tg_IntExpression_Val = b;
            delete right;
            return;
        }
        tem_ExpressionType = Exp_UnaryOp;
        right_Expression = right;
        tem_OP = OP;
    }

    void initial_Expression_Assign(Node* left, Node* right){
        tem_ExpressionType = Exp_Assign;
        mb_LValueExpression = false;
        left_Expression = left;
        right_Expression = right;
    }

    void initial_Expression_UnaryAssign(OperatorType OP, Node* right){
        tem_ExpressionType = Exp_UnaryAssign;
        mb_LValueExpression = false;
        right_Expression = right;
        tem_OP = OP;
    }

    void initial_Expression_Variable_Array(string* name, vector<Node*>* subscriptList){
        ms_Name = *name;
        delete name;
        mb_LValueExpression = true;
        if(subscriptList->size()==0)
            tem_ExpressionType = Exp_Variable;
        else {
            tem_ExpressionType = Exp_Array;
            tt_ArraySubscriptList = subscriptList;
        }
    }

    void initial_Expression_FunctionCall(string* name, vector<Node*>* argumentList){
        if(*name!="main") ms_Name = *name + "_global";
        else ms_Name = *name;
        delete name;
        mb_LValueExpression = false;
        tem_ExpressionType = Exp_FunctionCall;
        tt_ArgumentList = argumentList;
    }

    void initial_Expression_StructMember(string* name, string* memberName){
        ms_Name = *name;
        delete name;
        ms_MemberName = *memberName;
        delete memberName;
        mb_LValueExpression = true;
        tem_ExpressionType = Exp_StructMember;
    }

    // Declaration Utils
    void initial_Declaration_Local_Variable_Array(vector<Variable_ArrayDeclarationInfo*>* mV_Var_Arr_Dec_Info_Vector){
        tt_Var_Arr_Dec_Info_Vector = mV_Var_Arr_Dec_Info_Vector;
        tem_DeclarationType = Dec_Local_Variable_Array;
    }

    void initial_Declaration_Global_Variable_Array(vector<Variable_ArrayDeclarationInfo*>* mV_Var_Arr_Dec_Info_Vector){
        tt_Var_Arr_Dec_Info_Vector = mV_Var_Arr_Dec_Info_Vector;
        for(auto it = tt_Var_Arr_Dec_Info_Vector->begin(); it != tt_Var_Arr_Dec_Info_Vector->end(); ++it){
            (*it)->ms_Name = (*it)->ms_Name + "_global";
        }
        tem_DeclarationType = Dec_Global_Variable_Array;
    }

    void initial_Declaration_Local_Struct(vector<string>* stspec, vector<string>* sdecs){
        tem_DeclarationType = Dec_Local_Struct;
        tt_StructDeclarations = sdecs;
        ms_StructName = (*stspec)[stspec->size()-1];
        stspec->pop_back();
        tt_StructMembers = stspec;
    }

    void initial_Declaration_Global_Struct(vector<string>* stspec, vector<string>* sextvars){
        tem_DeclarationType = Dec_Global_Struct;
        tt_StructDeclarations = sextvars;
        for(auto it=sextvars->begin(); it!=sextvars->end(); ++it){
            *it += "_global";
        }
        ms_StructName = (*stspec)[stspec->size()-1];
        stspec->pop_back();
        tt_StructMembers = stspec;
    }

    // Statement Utils
    void initial_Statement_Return(Node* expression){
        tem_StatementType = Stmt_Return;
        return_Expression = expression;
    }

    void initial_Statement_If(Node* expression, Node* then_statement){
        tem_StatementType = Stmt_If;
        if_Expression = expression;
        then_Statement = then_statement;
    }

    void initial_Statement_IfElse(Node* expression, Node* then_statement, Node* else_statement){
        tem_StatementType = Stmt_IfElse;
        if_Expression = expression;
        then_Statement = then_statement;
        else_Statement = else_statement;
    }

    void initial_Statement_For(Node* expression1, Node* expression2, Node* expression3, Node* statement){
        tem_StatementType = Stmt_For;
        init_Expression = expression1;
        cond_Expression = expression2;
        update_Expression = expression3;
        for_Statement = statement;
    }

    void initial_Statement_StmtBlock(vector<Node*>* declarations, vector<Node*>* statements){
        tem_StatementType = Stmt_StatementBlock;
        declarations_in_block = declarations;
        statements_in_block = statements;
    }

    void initial_Function(vector<string>* paras, Node* body){
        if((*paras)[paras->size()-1]!="main") ms_Name = (*paras)[paras->size()-1] + "_global";
        else ms_Name = (*paras)[paras->size()-1];
        paras->pop_back();
        parameters = paras;
        function_Body = body;
    }
};
#endif