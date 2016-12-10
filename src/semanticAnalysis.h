/*

*/

#ifndef SEMANTIC_ANALYSIS_H
#define SEMANTIC_ANALYSIS_H

#include "parseTree.h"
#include <cstdlib>
#include <map>
#include <vector>
using namespace std;

// report the error
// include the information of line
void error(const char *s1, const char *s2, const char *s3, int linecount) {
    fprintf(stderr, "\033[1mLine: %d\033[0m ", linecount);
    fprintf(stderr, "\033[1;30merror:\033[0m ");
    if (s1 != NULL) fprintf(stderr, "%s ", s1);
    if (s2 != NULL) fprintf(stderr, "%s ", s2);
    if (s3 != NULL) fprintf(stderr, "%s ", s3);
    fprintf(stderr, "\n");
    exit(-1);
}


// used in struct SymbolTable to compare two string
struct ptr_cmp {
    bool operator()(const char *s1, const char *s2) const {
        return strcmp(s1, s2) < 0;
    }
};

struct SymbolTable {
    SymbolTable *parent; // record the parent scope SymbolTable
    map <const char*, const char*, ptr_cmp> id_table; // store identifier
    map <const char*, vector<char*>, ptr_cmp> struct_table; // store struct member
        
};

map <const char*, vector<int>, ptr_cmp> function_table;


void programCheck(Node *node);
void extdefsCheck(Node *node);
void extdefCheck(Node *node);
void extvarsCheck(Node *node);
void stspecCheck(Node *node);
void sextvarsCheck(Node *node);
void varCheck(Node *node);
void funcCheck(Node *node);
void parasCheck(Node *node);
void sdefsCheck(Node *node);
void stmtblockCheck(Node *node);
void stmtsCheck(Node *node);
void stmtCheck(Node *node);
void defsCheck(Node *node);
void decsCheck(Node *node);
void initCheck(Node *node);
void expsCheck(Node *node);
void expCheck(Node *node);
void arrsCheck(Node *node);
void argsCheck(Node *node);
void sdecsCheck(Node *node);
void idCheck(Node *node);

bool isDefined(const char *s);

// semantic check function
// input is the node from parse tree
void semantic(Node *node) {
    if (strcmp(node->name, "PROGRAM") == 0) {  
        programCheck(node);
    }
    else if (strcmp(node->name, "EXTDEFS") == 0) { 
        extdefsCheck(node);
    }
    else if (strcmp(node->name, "EXTDEF") == 0) {  
        extdefCheck(node);
    }
    else if (strcmp(node->name, "EXTVARS") == 0) {
        extvarsCheck(node);
    }
    else if (strcmp(node->name, "STSPEC") == 0) {
        stspecCheck(node);
    }
    else if (strcmp(node->name, "SEXTVARS") == 0) {
        sextvarsCheck(node);
    }
    else if (strcmp(node->name, "VAR") == 0) {
        varCheck(node);
    }
    else if (strcmp(node->name, "FUNC") == 0) {
        funcCheck(node);
    }
    else if (strcmp(node->name, "PARAS") == 0) {
        parasCheck(node);
    }
    else if (strcmp(node->name, "SDEFS") == 0) {
        sdefsCheck(node);
    }
    else if (strcmp(node->name, "STMTS") == 0) {
        stmtsCheck(node);
    }
    else if (strcmp(node->name, "STMTBLOCK") == 0) {
        stmtblockCheck(node);
    }
    else if (strcmp(node->name, "STMT") == 0) {
        stmtCheck(node);
    }
    else if (strcmp(node->name, "DEFS") == 0) {
        defsCheck(node);
    }
    else if (strcmp(node->name, "DECS") == 0) {
        decsCheck(node);
    }
    else if (strcmp(node->name, "INIT") == 0) {
        initCheck(node);
    }
    else if (strcmp(node->name, "EXPS") == 0) {
        expsCheck(node);
    }
    else if (strcmp(node->name, "EXP") == 0) {
        expCheck(node);
    }
    else if (strcmp(node->name, "ARRS") == 0) {
        arrsCheck(node);
    }
    else if (strcmp(node->name, "ARGS") == 0) {
        argsCheck(node);
    }
    else if (strcmp(node->name, "SDECS") == 0) {
        sdecsCheck(node);
    }
    else {
        // the other thing in the parse tree are operator or so
        // syntax analysis did check these simbols
        // so there is no need to check these simbols
    }
    
}

// main function
// from root node traverse the whole tree
void semanticAnalysis(Node *root) {
    semantic(root);
}

// PROGRAM : EXTDEFS
void programCheck(Node *node) {
    extdefsCheck(node->children[0]);
}

// EXTDEFS : EXTDEF EXTDEFS 
//         | e
void extdefsCheck(Node *node) {
    if (node->size != 0) {
        extdefCheck(node->children[0]);
        extdefsCheck(node->children[1]);
    }
}

// EXTDEF : TYPE EXTVARS SEMI
//        | STSPEC SEXTVARS SEMI
//        | TYPE FUNC STMTBLOCK
void extdefCheck(Node *node) {
    
}

// EXTVARS : ID
//         | ID COMMA SEXTVARS 
//         | e
void extvarsCheck(Node *node) {

}

// STSPEC : STRUCT ID LC SDEFS RC
//        | STRUCT LC SDEFS RC
//        | STRUCT ID
void stspecCheck(Node *node) {
    
}

// FUNC : ID LP PARAS RP
void funcCheck(Node *node) {
    
}

// PARAS : TYPE ID COMMA PARAS
//       | TYPE ID
//       | e
void parasCheck(Node *node) {
    
}

// STMTBLOCK : LC DEFS STMTS RC
void stmtblockCheck(Node *p) {
    
}

// STMTS : STMT STMTS
//       | e
void stmtsCheck(Node *p) {
    
}

// STMT : EXP SEMI
//      | STMTBLOCK
//      | RETURN EXP SEMI
//      | IF LP EXP RP STMT %prec LTIF
//      | IF LP EXP RP STMT ELSE STMT
//      | FOR LP EXP SEMI EXP SEMI EXP RP STMT
//      | CONT SEMI
//      | BREAK SEMI
void stmtCheck(Node *node) {
    
}

// DEFS : TYPE DECS SEMI DEFS
//      | STSPEC SDECS SEMI DEFS
//      | e
void defsCheck(Node *node) {
    
}

// SDEFS : TYPE SDECS SEMI SDEFS
//       | e
void sdefsCheck(Node *node) {
    
}

// SDECS : ID COMMA SDECS
//       | ID
void sdecsCheck(Node *node) {
    
}

// DECS : VAR
//      | VAR COMMA DECS
//      | VAR ASSIGN INIT COMMA DECS
//      | VAR ASSIGN INIT
void decsCheck(Node *node) {
    
}

// VAR : ID
//     | VAR LB INT RB
void varCheck(Node *node) {
    if (node->size == 1) {
        if (isDefined(node->children[0]->name)) {
            error("redeclearation of", node->children[0]->name, "with no linkage", node->linecount);
        }
        else {
            // TODO
        }
    }
    else {
        // int int_value = atoi(node->children[2]->name);
        varCheck(node->children[0]);
    }
}

// INIT : EXP
//      | LC ARGS RC
void initCheck(Node *node) {
    
}

// EXP : EXPS
//     | e
void expCheck(Node *node) {
    
}

// EXPS : EXPS BINARYOP EXPS
//      | UNARYOP EXPS
//      | LP EXPS RP
//      | ID LP ARGS RP
//      | ID ARRS
//      | ID DOT ID
//      | INT
void expsCheck(Node *node) {
    
}

// ARRS : LB EXP RB ARRS
//      | e
void arrsCheck(Node *node) {
    
}

// ARGS : EXP COMMA ARGS
//      | EXP
void argsCheck(Node *node) {
    
}



bool isDefined(const char *s) {
    // TODO
    return false;
}

#endif