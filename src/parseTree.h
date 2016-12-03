/*


*/
#ifndef PARSETREE_H
#define PARSETREE_H
#include <malloc.h>
#include <cstdarg>
#include <cstring>

struct Node{
    char *name;
    int size;  // number of children
    int linecount; // line count, to report error position
    struct Node **children;
};

Node* newNode(int linecount, const char *name, int size,...) {
    Node *tt = (Node*)malloc(sizeof(Node));
    tt->name = strdup(name);
    tt->linecount = linecount;
    tt->size = size;
    if (size > 0) {
        tt->children = (Node**)malloc(sizeof(Node*) * size);
        
        va_list ap;
        va_start(ap, size);
        
        int i = 0;
        while (i < size) {
            tt->children[i] = va_arg(ap, Node*);
            ++i;
        }
        va_end(ap);
    }
    return tt;
}

// print the parse tree to check whether parsing is correct

void printNode(Node *node, int h) {
    int tt = h;
    while (tt--) printf("    ");
    printf("%s\n", node->name);
    
    for (int j = 0; j < node->size; ++j) {
        printNode(node->children[j], h + 1);
    }
}

void printParseTree(Node *root) {
    printf("========= Parse Tree ========\n");
    printf("%s\n", root->name);
    
    for (int i = 0; i < root->size; ++i) {
        printNode(root->children[i], 1);
    }
}



#endif 