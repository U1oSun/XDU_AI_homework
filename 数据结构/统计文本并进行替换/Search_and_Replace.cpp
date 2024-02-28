#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

#define M 5000

// 定义二叉搜索树中节点的结构
typedef struct node {
    int count;
    char word[26];
    struct node *lchild, *rchild;  // 创建节点时，每个节点都有左子节点和右子节点
} BTNode, *BTREE;

int flag;

// 从文件中读取一个单词的函数
int get_word(char *temp_word, FILE *in);

// 将单词插入二叉搜索树的函数
BTREE insert(BTREE T, char temp_word[]);

// 对二叉搜索树进行中序遍历，并查找目标单词的函数
void inorder(BTREE root, char word[]);

// 替换并生成新文件的函数
void replaceAndGenerateNewFile(BTREE root, char oldWord[], char newWord[], const char* originalFile, const char* newFile);

// 递归替换并生成新文件的函数
void replaceAndGenerateNewFileRecursive(BTREE root, char oldWord[], char newWord[], FILE *originalIn, FILE *newOut);

int main() {
    char temp_word[26] = {0};  // 准备将temp_word的内容放入真正的单词块.word中
    char words[26] = {0};
    int number;
    FILE *in;
    int i, j;

    // 打开文件进行读取
    if ((in = fopen("D:\\游霄童\\2023\\20231225_数据结构大作业\\test.txt", "r")) == NULL) {
        perror("打开文件错误");
        return 1;  // 返回错误代码表示文件打开失败
    }

    BTREE root = NULL;  // 每次插入都将根节点作为参数处理
    // 从文件中读取单词并插入二叉搜索树
    while (!feof(in)) {
        char temp_word[26] = {0};
        get_word(temp_word, in);  // 从文件中找到一个单词并保存在数组temp_word中
        root = insert(root, temp_word);  // 建立二叉搜索树，根节点为root
    }

    // 查询单词的数量
    printf("输入您要查询的单词数量：");
    scanf("%d", &number);

    // 查询指定数量的单词
    for (int i = 0; i < number + 1; i++) {
        if (i > 0) printf("输入目标单词：");
        fgets(words, sizeof(words), stdin);
        words[strcspn(words, "\n")] = '\0';  // 移除末尾的换行符

        char a[strlen(words) + 1];
        strcpy(a, words);

        if (i > 0) {
            // 在二叉搜索树中搜索目标单词
            inorder(root, a);

            // 如果单词未找到，输出消息
            if (flag == 0) {
                printf("文章中未找到单词 %s\n\n", a);
                flag = 0;
            }
        }
    }

    // 主函数内部
    char oldWord[26] = {0};
    char newWord[26] = {0};

    printf("输入要替换的单词：");
    fgets(oldWord, sizeof(oldWord), stdin);
    oldWord[strcspn(oldWord, "\n")] = '\0';  // 移除末尾的换行符

    printf("输入新单词：");
    fgets(newWord, sizeof(newWord), stdin);
    newWord[strcspn(newWord, "\n")] = '\0';  // 移除末尾的换行符

    // 生成一个替换了指定单词的新文件
    replaceAndGenerateNewFile(root, oldWord, newWord, "D:\\游霄童\\2023\\20231225_数据结构大作业\\test.txt", "D:\\游霄童\\2023\\20231225_数据结构大作业\\newFile.txt");

    return 0;
}

// 从文件中读取一个单词的函数
int get_word(char *temp_word, FILE *in) {
    int i = 0;
    char temp = '0';
    temp = fgetc(in);

    // 跳过非字母字符直到找到有效字符
    while (!isalpha(temp)) {
        temp = fgetc(in);
        if (temp == EOF)  // 字符是空格
            return 1;  // 到达文件结尾时返回
    }

    // 读取字母字符直到遇到空格
    while (isalpha(temp) && !isspace(temp)) {
        temp = tolower(temp);
        temp_word[i] = temp;
        i++;
        temp = fgetc(in);
    }

    return 0;  // 返回成功
}

// 将单词插入二叉搜索树的函数
BTREE insert(BTREE p, char temp_word[]) {
    int cond;

    // 如果节点为空，分配内存并创建新节点
    if (p == NULL) {
        p = (BTREE)malloc(sizeof(BTNode));  // 为节点p分配空间
        strcpy(p->word, temp_word);  // 将字符串temp_word复制到节点p的word数组中
        p->count = 1;  // 记录单词出现
        p->lchild = p->rchild = NULL;  // 节点p的左子节点和右子节点为空
    }
        // 如果单词已经在树中，增加计数
    else if ((cond = strcmp(temp_word, p->word)) == 0) {
        p->count++;
    }
        // 如果单词小于当前节点的单词，插入到左侧
    else if (cond < 0) {
        p->lchild = insert(p->lchild, temp_word);  // 将目标单词插入到p的左子节点中
    }
        // 如果单词大于当前节点的单词，插入到右侧
    else {
        p->rchild = insert(p->rchild, temp_word);  // 将目标单词插入到p的右子节点中
    }

    return (p);
}

// 对二叉搜索树进行中序遍历，并查找目标单词的函数
void inorder(BTREE T, char word[]) {
    if (T != NULL) {
        inorder(T->lchild, word);

        // 如果找到目标单词，打印计数并设置标志
        if (strcmp(word, T->word) == 0) {
            printf("单词 %s 在文章中出现 %d 次\n\n", T->word, T->count);
            flag = 1;
        }

        inorder(T->rchild, word);
    }
}

// 替换并生成新文件的函数
void replaceAndGenerateNewFile(BTREE root, char oldWord[], char newWord[], const char* originalFile, const char* newFile) {
    FILE *originalIn, *newOut;

    // 打开要读取的原文件
    if ((originalIn = fopen(originalFile, "r")) == NULL) {
        perror("打开原文件错误");
        return;
    }

    // 打开要写入的新文件
    if ((newOut = fopen(newFile, "w")) == NULL) {
        perror("打开新文件错误");
        fclose(originalIn);  // 如果打开新文件时出错，关闭原文件
        return;
    }

    // 遍历树并在新文件中用新单词替换旧单词
    replaceAndGenerateNewFileRecursive(root, oldWord, newWord, originalIn, newOut);

    // 关闭文件
    fclose(originalIn);
    fclose(newOut);

    printf("成功生成替换了指定单词的新文件。\n");
}

// 递归替换并生成新文件的函数
void replaceAndGenerateNewFileRecursive(BTREE root, char oldWord[], char newWord[], FILE *originalIn, FILE *newOut) {
    if (root != NULL) {
        char tempWord[26];
        int count = root->count;

        // 从原文件中读取单词并写入新文件
        while (fscanf(originalIn, "%s", tempWord) != EOF) {
            if (strcmp(oldWord, tempWord) == 0) {
                // 用新单词替换旧单词
                fprintf(newOut, "%s ", newWord);
                count--;  // 减少替换单词的计数
            } else {
                // 将当前单词写入新文件
                fprintf(newOut, "%s ", tempWord);
            }

            if (count == 0) {
                break;  // 如果所有出现都被替换，退出循环
            }
        }

        // 递归更新左子树
        replaceAndGenerateNewFileRecursive(root->lchild, oldWord, newWord, originalIn, newOut);

        // 递归更新右子树
        replaceAndGenerateNewFileRecursive(root->rchild, oldWord, newWord, originalIn, newOut);
    }
}