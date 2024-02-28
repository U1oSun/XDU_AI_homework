#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

#define M 5000

// ��������������нڵ�Ľṹ
typedef struct node {
    int count;
    char word[26];
    struct node *lchild, *rchild;  // �����ڵ�ʱ��ÿ���ڵ㶼�����ӽڵ�����ӽڵ�
} BTNode, *BTREE;

int flag;

// ���ļ��ж�ȡһ�����ʵĺ���
int get_word(char *temp_word, FILE *in);

// �����ʲ�������������ĺ���
BTREE insert(BTREE T, char temp_word[]);

// �Զ����������������������������Ŀ�굥�ʵĺ���
void inorder(BTREE root, char word[]);

// �滻���������ļ��ĺ���
void replaceAndGenerateNewFile(BTREE root, char oldWord[], char newWord[], const char* originalFile, const char* newFile);

// �ݹ��滻���������ļ��ĺ���
void replaceAndGenerateNewFileRecursive(BTREE root, char oldWord[], char newWord[], FILE *originalIn, FILE *newOut);

int main() {
    char temp_word[26] = {0};  // ׼����temp_word�����ݷ��������ĵ��ʿ�.word��
    char words[26] = {0};
    int number;
    FILE *in;
    int i, j;

    // ���ļ����ж�ȡ
    if ((in = fopen("D:\\����ͯ\\2023\\20231225_���ݽṹ����ҵ\\test.txt", "r")) == NULL) {
        perror("���ļ�����");
        return 1;  // ���ش�������ʾ�ļ���ʧ��
    }

    BTREE root = NULL;  // ÿ�β��붼�����ڵ���Ϊ��������
    // ���ļ��ж�ȡ���ʲ��������������
    while (!feof(in)) {
        char temp_word[26] = {0};
        get_word(temp_word, in);  // ���ļ����ҵ�һ�����ʲ�����������temp_word��
        root = insert(root, temp_word);  // �������������������ڵ�Ϊroot
    }

    // ��ѯ���ʵ�����
    printf("������Ҫ��ѯ�ĵ���������");
    scanf("%d", &number);

    // ��ѯָ�������ĵ���
    for (int i = 0; i < number + 1; i++) {
        if (i > 0) printf("����Ŀ�굥�ʣ�");
        fgets(words, sizeof(words), stdin);
        words[strcspn(words, "\n")] = '\0';  // �Ƴ�ĩβ�Ļ��з�

        char a[strlen(words) + 1];
        strcpy(a, words);

        if (i > 0) {
            // �ڶ���������������Ŀ�굥��
            inorder(root, a);

            // �������δ�ҵ��������Ϣ
            if (flag == 0) {
                printf("������δ�ҵ����� %s\n\n", a);
                flag = 0;
            }
        }
    }

    // �������ڲ�
    char oldWord[26] = {0};
    char newWord[26] = {0};

    printf("����Ҫ�滻�ĵ��ʣ�");
    fgets(oldWord, sizeof(oldWord), stdin);
    oldWord[strcspn(oldWord, "\n")] = '\0';  // �Ƴ�ĩβ�Ļ��з�

    printf("�����µ��ʣ�");
    fgets(newWord, sizeof(newWord), stdin);
    newWord[strcspn(newWord, "\n")] = '\0';  // �Ƴ�ĩβ�Ļ��з�

    // ����һ���滻��ָ�����ʵ����ļ�
    replaceAndGenerateNewFile(root, oldWord, newWord, "D:\\����ͯ\\2023\\20231225_���ݽṹ����ҵ\\test.txt", "D:\\����ͯ\\2023\\20231225_���ݽṹ����ҵ\\newFile.txt");

    return 0;
}

// ���ļ��ж�ȡһ�����ʵĺ���
int get_word(char *temp_word, FILE *in) {
    int i = 0;
    char temp = '0';
    temp = fgetc(in);

    // ��������ĸ�ַ�ֱ���ҵ���Ч�ַ�
    while (!isalpha(temp)) {
        temp = fgetc(in);
        if (temp == EOF)  // �ַ��ǿո�
            return 1;  // �����ļ���βʱ����
    }

    // ��ȡ��ĸ�ַ�ֱ�������ո�
    while (isalpha(temp) && !isspace(temp)) {
        temp = tolower(temp);
        temp_word[i] = temp;
        i++;
        temp = fgetc(in);
    }

    return 0;  // ���سɹ�
}

// �����ʲ�������������ĺ���
BTREE insert(BTREE p, char temp_word[]) {
    int cond;

    // ����ڵ�Ϊ�գ������ڴ沢�����½ڵ�
    if (p == NULL) {
        p = (BTREE)malloc(sizeof(BTNode));  // Ϊ�ڵ�p����ռ�
        strcpy(p->word, temp_word);  // ���ַ���temp_word���Ƶ��ڵ�p��word������
        p->count = 1;  // ��¼���ʳ���
        p->lchild = p->rchild = NULL;  // �ڵ�p�����ӽڵ�����ӽڵ�Ϊ��
    }
        // ��������Ѿ������У����Ӽ���
    else if ((cond = strcmp(temp_word, p->word)) == 0) {
        p->count++;
    }
        // �������С�ڵ�ǰ�ڵ�ĵ��ʣ����뵽���
    else if (cond < 0) {
        p->lchild = insert(p->lchild, temp_word);  // ��Ŀ�굥�ʲ��뵽p�����ӽڵ���
    }
        // ������ʴ��ڵ�ǰ�ڵ�ĵ��ʣ����뵽�Ҳ�
    else {
        p->rchild = insert(p->rchild, temp_word);  // ��Ŀ�굥�ʲ��뵽p�����ӽڵ���
    }

    return (p);
}

// �Զ����������������������������Ŀ�굥�ʵĺ���
void inorder(BTREE T, char word[]) {
    if (T != NULL) {
        inorder(T->lchild, word);

        // ����ҵ�Ŀ�굥�ʣ���ӡ���������ñ�־
        if (strcmp(word, T->word) == 0) {
            printf("���� %s �������г��� %d ��\n\n", T->word, T->count);
            flag = 1;
        }

        inorder(T->rchild, word);
    }
}

// �滻���������ļ��ĺ���
void replaceAndGenerateNewFile(BTREE root, char oldWord[], char newWord[], const char* originalFile, const char* newFile) {
    FILE *originalIn, *newOut;

    // ��Ҫ��ȡ��ԭ�ļ�
    if ((originalIn = fopen(originalFile, "r")) == NULL) {
        perror("��ԭ�ļ�����");
        return;
    }

    // ��Ҫд������ļ�
    if ((newOut = fopen(newFile, "w")) == NULL) {
        perror("�����ļ�����");
        fclose(originalIn);  // ��������ļ�ʱ�����ر�ԭ�ļ�
        return;
    }

    // �������������ļ������µ����滻�ɵ���
    replaceAndGenerateNewFileRecursive(root, oldWord, newWord, originalIn, newOut);

    // �ر��ļ�
    fclose(originalIn);
    fclose(newOut);

    printf("�ɹ������滻��ָ�����ʵ����ļ���\n");
}

// �ݹ��滻���������ļ��ĺ���
void replaceAndGenerateNewFileRecursive(BTREE root, char oldWord[], char newWord[], FILE *originalIn, FILE *newOut) {
    if (root != NULL) {
        char tempWord[26];
        int count = root->count;

        // ��ԭ�ļ��ж�ȡ���ʲ�д�����ļ�
        while (fscanf(originalIn, "%s", tempWord) != EOF) {
            if (strcmp(oldWord, tempWord) == 0) {
                // ���µ����滻�ɵ���
                fprintf(newOut, "%s ", newWord);
                count--;  // �����滻���ʵļ���
            } else {
                // ����ǰ����д�����ļ�
                fprintf(newOut, "%s ", tempWord);
            }

            if (count == 0) {
                break;  // ������г��ֶ����滻���˳�ѭ��
            }
        }

        // �ݹ����������
        replaceAndGenerateNewFileRecursive(root->lchild, oldWord, newWord, originalIn, newOut);

        // �ݹ����������
        replaceAndGenerateNewFileRecursive(root->rchild, oldWord, newWord, originalIn, newOut);
    }
}