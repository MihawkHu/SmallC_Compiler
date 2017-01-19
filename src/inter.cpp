/*
  File:     inter.cpp
  Author:   Hu Hu
  Function: This file is a utility file of the intermediate code generation, 
            which is all implemented by the method of class. It mainly to make
            it more convenient to output the intermediate code. In this file, I
            overloading some IO function of the class I wrote in other files. 
            That is to say, I can use standrand operation "<<" to output three
            address intermediate code.
  Output:   inter.o
*/
#include "inter.h"
#include <string>
#include <vector>
#include <sstream>
#include <map>

using namespace std;

const Temporary T_0 = 0;
const Temporary T_1 = 1;
const Temporary T_2 = 2;
const Temporary T_3 = 3;
const Temporary T_4 = 4;
const Temporary T_5 = 5;
const Temporary T_6 = 6;
const Temporary T_7 = 7;
const Temporary T_8 = 8;
const Temporary T_9 = 9;
const Temporary T_10 = 10;
const Temporary T_11 = 11;
const Temporary T_12 = 12;
const Temporary T_13 = 13;
const Temporary T_14 = 14;
const Temporary T_15 = 15;
const Temporary T_16 = 16;
const Temporary T_17 = 17;
const Temporary T_18 = 18;
const Temporary T_19 = 19;
const Temporary T_20 = 20;
const Temporary T_21 = 21;
const Temporary T_22 = 22;
const Temporary T_23 = 23;
const Temporary T_24 = 24;
const Temporary T_25 = 25;
const Temporary T_26 = 26;
const Temporary T_27 = 27;
const Temporary T_28 = 28;
const Temporary T_29 = 29;
const Temporary T_30 = 30;

template<class T>
std::string toString(T t){
    std::stringstream s;
    s << t;
    return s.str();
}

string tempoStr(Temporary t){
    map<Temporary, string> replacee;
    replacee[T_0] = "#0";
    replacee[T_1] = "#1";
    replacee[T_2] = "#2";
    replacee[T_3] = "#3";
    replacee[T_4] = "#4";
    replacee[T_5] = "#5";
    replacee[T_6] = "#6";
    replacee[T_7] = "#7";
    replacee[T_8] = "#8";
    replacee[T_9] = "#9";
    replacee[T_10] = "#10";
    replacee[T_11] = "#11";
    replacee[T_12] = "#12";
    replacee[T_13] = "#13";
    replacee[T_14] = "#14";
    replacee[T_15] = "#15";
    replacee[T_16] = "#16";
    replacee[T_17] = "#17";
    replacee[T_18] = "#18";
    replacee[T_19] = "#19";
    replacee[T_20] = "#20";
    replacee[T_21] = "#21";
    replacee[T_22] = "#22";
    replacee[T_23] = "#23";
    replacee[T_24] = "#24";
    replacee[T_25] = "#25";
    replacee[T_26] = "#26";
    replacee[T_27] = "#27";
    replacee[T_28] = "#28";
    replacee[T_29] = "#29";
    replacee[T_30] = "#30";
    
    return replacee[t];
}

ostream& operator<<(ostream& output, const Inter& inter){
    return inter.output(output);
}

Inter::Inter() {}
Inter::~Inter() {}

InterLabel::InterLabel(const string& name) : name(name) {}
InterLabel::~InterLabel() {}

ostream& InterLabel::output(ostream& output) const {
    return output << endl << name << ":" << endl;
}

InterJumpLabel::InterJumpLabel(const string& name) : name(name) {}
InterJumpLabel::~InterJumpLabel() {}

ostream& InterJumpLabel::output(ostream& output) const {
    return output << "jmp\t" << name << endl;
}

InterReturn::InterReturn(Temporary ret) : ret(ret) {}

InterReturn::~InterReturn() {}

ostream& InterReturn::output(ostream& output) const {
    return output << "return\t" << tempoStr(ret) << endl;
}


IfGoto::IfGoto(Temporary cond, const string& target) : cond(cond), target(target) {}
IfGoto::~IfGoto() {}

ostream& IfGoto::output(ostream& output) const {
    return output << "if\t" << tempoStr(cond) << "\tgoto\t" << target << endl;
}

IfFalseGoto::IfFalseGoto(Temporary cond, const string& target) : cond(cond), target(target) {}
IfFalseGoto::~IfFalseGoto() {}

ostream& IfFalseGoto::output(ostream& output) const {
    return output << "ifFalse\t" << tempoStr(cond) << "\tgoto\t" << target << endl;
}

Move::Move(Temporary from, Temporary to) : from(from), to(to) {}
Move::~Move() {}

ostream& Move::output(ostream& output) const {
    return output << "mov\t" << tempoStr(from) << "\t\t" << tempoStr(to) << endl;
}

InterIntGlobal::InterIntGlobal(const string& name, int value) : name(name), value(value) {}
InterIntGlobal::~InterIntGlobal() {}

ostream& InterIntGlobal::output(ostream& output) const {
    return output << "global_int\t" << name << "\t" << "initial\t" << value << endl;
}

InterArrayGlobal::InterArrayGlobal(const string& name, int global_array_size, vector<int> initial_values) : name(name), Global_Array_Size(global_array_size), Initial_Values(initial_values) {}
InterArrayGlobal::~InterArrayGlobal() {}

ostream& InterArrayGlobal::output(ostream& output) const {
    string tmp = "global_array\t";
    tmp += name;
    tmp += "\tsize\t";
    tmp += toString(Global_Array_Size);
    tmp += "\tinitial\t";
    for(auto it=Initial_Values.begin(); it!=Initial_Values.end(); ++it){
        tmp += toString(*it);
        tmp += " ";
    }
    return output << tmp << endl;
}

InterStructGlobal::InterStructGlobal(const string& name, int global_struct_size) : name(name), Global_Struct_Size(global_struct_size) {}
InterStructGlobal::~InterStructGlobal() {}

ostream& InterStructGlobal::output(ostream& output) const {
    return output << "global_struct\t" << name << "\tsize\t" << toString(Global_Struct_Size) << endl; 
}

InterIntLocal::InterIntLocal(const string& name, int stackoffset) : name(name), Stack_Offset(stackoffset) {}
InterIntLocal::~InterIntLocal() {}

ostream& InterIntLocal::output(ostream& output) const {
    return output << "local_int\t" << name << "\tstack_offset\t" << toString(Stack_Offset) << endl;
}


InterArrayLocal::InterArrayLocal(const string& name, int initial_size, int offset, vector<int> initial_values) : name(name), Initial_Size(initial_size), Stack_Offset(offset), Initial_Values(initial_values) {}
InterArrayLocal::~InterArrayLocal() {}

ostream& InterArrayLocal::output(ostream& output) const {
    string tmp = "local_array\t";
    tmp += name;
    tmp += "\tstack_offset\t";
    tmp += toString(Stack_Offset);
    tmp += "\tsize\t";
    tmp += toString(Initial_Size);
    tmp += "\tinitial\t";
    for(auto it=Initial_Values.begin(); it!=Initial_Values.end(); ++it){
        tmp += toString(*it);
        tmp += " ";
    }
    return output << tmp << endl;
}

InterStructLocal::InterStructLocal(const string& name, int initial_size, int offset) : name(name), Initial_Size(initial_size), Stack_Offset(offset) {}
InterStructLocal::~InterStructLocal() {}

ostream& InterStructLocal::output(ostream& output) const {
    return output << "local_struct\t" << name << "\tstack_offset\t" << toString(Stack_Offset) << "\tsize\t" << toString(Initial_Size) << endl;
}

InterBinOp::InterBinOp(const string& op, Temporary left, Temporary right, Temporary dest) : op(op), left(left), right(right), dest(dest) {}
InterBinOp::~InterBinOp() {}

ostream& InterBinOp::output(ostream& output) const {
    return output << op << "\t" << tempoStr(left) << "\t" << tempoStr(right) << "\t" << tempoStr(dest) << endl;
}

InterUnaryOp::InterUnaryOp(const string& op, Temporary right, Temporary dest) : op(op), right(right), dest(dest) {}
InterUnaryOp::~InterUnaryOp() {}

ostream& InterUnaryOp::output(ostream& output) const {
    return output << op << "\t" << tempoStr(right) << "\t\t" << tempoStr(dest) << endl;
}

MoveImmediate::MoveImmediate(Temporary dest, int value) : dest(dest), value(value) {}
MoveImmediate::~MoveImmediate() {}

ostream& MoveImmediate::output(ostream& output) const {
    return output << "mov\t" << value << "\t\t" << tempoStr(dest) << endl;
}

MoveVariable::MoveVariable(Temporary dest, string name) : dest(dest), name(name) {}
MoveVariable::~MoveVariable() {}

ostream& MoveVariable::output(ostream& output) const {
    return output << "mov\t" << name << "\t\t" << tempoStr(dest) << endl;;
}

MoveArray::MoveArray(Temporary dest, string name, Temporary bias) : dest(dest), name(name), bias(bias) {}
MoveArray::~MoveArray() {}

ostream& MoveArray::output(ostream& output) const {
    return output << "mov_arr\t" << name << "\t" << tempoStr(bias) << "\t" << tempoStr(dest) <<endl;
}

MoveStruct::MoveStruct(Temporary dest, string name, string member) : dest(dest), name(name), member(member) {}
MoveStruct::~MoveStruct() {}

ostream& MoveStruct::output(ostream& output) const {
    return output << "mov_struct\t" << name << "\t" << member << "\t" << tempoStr(dest) <<endl;
}

MoveToVariable::MoveToVariable(Temporary from, string name) : from(from), name(name) {}
MoveToVariable::~MoveToVariable() {}

ostream& MoveToVariable::output(ostream& output) const {
    return output << "mov\t" << tempoStr(from) << "\t\t" << name << endl;;
}

MoveToArray::MoveToArray(Temporary from, string name, Temporary bias) : from(from), name(name), bias(bias) {}
MoveToArray::~MoveToArray() {}

ostream& MoveToArray::output(ostream& output) const {
    return output << "mov_arr\t" << tempoStr(from) << "\t" << tempoStr(bias) << "\t" << name << "\t" << endl;
}

MoveToStruct::MoveToStruct(Temporary from, string name, string member) : from(from), name(name), member(member) {}
MoveToStruct::~MoveToStruct() {}

ostream& MoveToStruct::output(ostream& output) const {
    return output << "mov_struct\t" << tempoStr(from) << "\t" << name << "\t" << member << "\t" <<endl;
}

CallFunction::CallFunction(string name) : name(name) {}
CallFunction::~CallFunction() {}

ostream& CallFunction::output(ostream& output) const {
    return output << "call\t" << name << "\t" <<endl;
}

CallRead::CallRead() {}
CallRead::~CallRead() {}

ostream& CallRead::output(ostream& output) const {
    return output << "read" << endl;
}

CallWrite::CallWrite() {}
CallWrite::~CallWrite() {}

ostream& CallWrite::output(ostream& output) const {
    return output << "write" << endl;
}