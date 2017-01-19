/*
  File:     intermediate.h
  Author:   Hu Hu
  Function: This file is the header file of intermediate.h. I declare the 
            functions here, which are used to operate symbol table and do 
            semantic checking.
  Output:   intermediate.o
*/
#ifndef INTERMEDIATE_H
#define INTERMEDIATE_H

#include "node.h"
#include "SymbolTable.h"
#include "inter.h"
#include "mips.h"
#include <set>

struct SymbolTable;
struct Intermediates;

extern SymbolTable* global_table;
extern vector<Intermediate*>* global_intermediates;
extern set<Register> remainingRegisters;
extern set<Register> registersInUse;
extern map<Node*, Register> intermediate;
extern string label;		
extern string currentLoopContinueLabel;
extern string currentLoopBreakLabel;
extern int stackSize;

SymbolTable* pushScope(SymbolTable* table);
SymbolTable* popScope(SymbolTable* table);

Definition* getDefinition(string name, SymbolTable* table, int linenum);
Register getVarAddress(Node* cur, SymbolTable* table, int linenum);
Register getStructMemberAddress(Node* cur, SymbolTable* table, int linenum);
Register getArraySubscriptAddress(Node* cur, SymbolTable* table, int linenum);

void reclainRegisters();
void returnRegister(Register r);
Register getFreeRegister();

bool generate_intermediates(SymbolTable* symbol_table, vector<Inter*>* intermediates, Node* root, vector<Instruction*>* instrs);
bool check(Node* cur, SymbolTable* table);

bool defineGlobal_Var_Array(Variable_ArrayDeclarationInfo* info, SymbolTable* table, int linenum);
bool defineGlobal_Struct(string structname, vector<string>* structMembers, vector<string>* structDeclarations, SymbolTable* table, int linenum);
bool defineFunction(Node* cur, SymbolTable* table, int linenum);
bool defineLocal_Var_Array(Variable_ArrayDeclarationInfo* info, SymbolTable* table, int linenum);
bool defineLocal_Struct(string structname, vector<string>* structMembers, vector<string>* structDeclarations, SymbolTable* table, int linenum);
bool defineIf_Statement(Node* cur, SymbolTable* table, int linenum);
bool defineIfElse_Statement(Node* cur, SymbolTable* table, int linenum);
bool defineFor_Statement(Node* cur, SymbolTable* table, int linenum);
bool defineBreak_Statement(Node* cur, SymbolTable* table, int linenum);
bool defineContinue_Statement(Node* cur, SymbolTable* table, int linenum);
bool defineReturn_Statement(Node* cur, SymbolTable* table, int linenum);
bool defineAssign_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineUnaryAssign_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineInt_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineBinaryOp_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineUnaryOp_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineVariable_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineArray_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineFunctionCall_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineStructMember_Expression(Node* cur, SymbolTable* table, int linenum);
bool defineRead_Statement(Node* cur, SymbolTable* table, int linenum);
bool defineWrite_Statement(Node* cur, SymbolTable* table, int linenum);

#endif