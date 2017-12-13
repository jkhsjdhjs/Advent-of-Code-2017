#include <fstream>
#include <iostream>
#include <vector>

class Group {
    public:
        std::vector<Group*> *children;
        std::string *text;
        bool is_garbage;
        Group *parent;
        Group(Group *parent, bool is_garbage = false) {
            this->children = new std::vector<Group*>();
            this->text = new std::string();
            this->parent = parent;
            this->is_garbage = is_garbage;
        }
        void addChild(Group *child) {
            this->children->push_back(child);
        }
        void appendChar(char *c) {
            this->text->append(c, 0, 1);
        }
        int calcScore(int start = 1) {
            int sum = start;
            for(auto &child: *this->children)
                if(!child->is_garbage)
                    sum += child->calcScore(start + 1);
            return sum;
        }
        int garbageLength() {
            int sum = this->text->length();
            for(auto &child: *this->children)
                sum += child->garbageLength();
            return sum;
        }
};

Group *parseInputFile(std::ifstream *file) {
    std::string line;
    getline(*file, line);
    Group *current = NULL;
    for(std::string::iterator it = line.begin(); it < line.end(); it++) {
        if(current != NULL && current->is_garbage) {
            if(it < line.end() - 1 && *it == '!') {
                it++;
                continue;
            }
            if(*it != '>')
                current->appendChar(&*it);
            else {
                if(current->parent == NULL)
                    return current;
                current->parent->addChild(current);
                current = current->parent;
            }
            continue;
        }
        switch(*it) {
            case '<':
                current = new Group(current, true);
                break;
            case '{':
                current = new Group(current);
                break;
            case '!':
                it++;
                break;
            case ',':
                if(it < line.end() - 1 && *(it + 1) == ',')
                    return NULL;
                break;
            case '}':
                if(current->parent == NULL)
                    return current;
                current->parent->addChild(current);
                current = current->parent;
                break;
            default:
                return NULL;
        }
    }
    return NULL;
}

int main(int argc, char** argv) {
    Group *start;
    std::ifstream *input_file = new std::ifstream();
    if(argc < 2) {
        std::cout << "Invalid Arguments!" << std::endl;
        return 1;
    }
    input_file->open(argv[1]);
    if(!input_file->is_open()) {
        std::cout << "Error opening file!" << std::endl;
        return 1;
    }
    if((start = parseInputFile(input_file)) == NULL) {
        std::cout << "Error parsing file!" << std::endl;
        return 1;
    }
    std::cout << "The total score is " << start->calcScore() << "!" << std::endl;
    std::cout << "The input contains " << start->garbageLength() << " non-canceled characters!" << std::endl;
}
