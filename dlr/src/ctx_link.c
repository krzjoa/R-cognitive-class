#include "context.h"

//' Link
//' A simple structure which serves to implement linked lists
//' * linked list in DlrContext: full list of all the Dlr operations without describing relations between them
//' * individaul linked lists for every single operation, which store their inputs and outputs

struct Link;

void _Link_finalizer(struct Link *link){
  free(link); // ???
}

struct Link* create_Link(struct Ops *contained_ops, struct Link *next_link){
  struct Link* l = (struct Link*) calloc(1, sizeof(struct Link));
  l->contained = contained_ops;
  l->next = next_link;
  return l;
}

struct Link* last_link(struct Link *current_link){
  while(current_link->next){
    current_link = current_link->next;
  }
  return current_link;
}

int get_chain_length(struct Link* current_link){
  int i = 0;
  while(current_link){
    i++;
    current_link = current_link->next;
  }
  return i;

}
