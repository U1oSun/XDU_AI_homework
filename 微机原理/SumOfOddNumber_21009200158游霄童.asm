STACK SEGMENT STACK'STACK'
    DW 100H DUP(?)     ; �����ջ�Σ���СΪ100H�ֽ�
TOP LABEL WORD
STACK ENDS

DATA SEGMENT
    CNT DB 0            ; �洢�����ĸ���
    SUMODD DW 0         ; �洢�����ĺ�
    VAR1 DB 1           ; ѭ����������ʼֵ
    VAR2 DB 255         ; ͬ�෨����С��256���������AX=(AX*11+3) mod 255
    VAR3 DB 200         ; Ҫ����200���������ѭ��200��
    VAR4 DW 0           ; ��ʱ����
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK
START:
    MOV AX, DATA        ; �����ݶε�ַ���ص�AX�Ĵ���
    MOV DS, AX          ; �����ݶε�ַ���Ƶ�DS�Ĵ���
    XOR AX, AX          ; ����
    XOR BX, BX         
    XOR CX, CX          
    XOR DX, DX          
    MOV AL, VAR1        ; ��Ϊѭ��������
    MOV BL, VAR2        ; ����ͬ�෨����
    MOV CL, VAR3        ; ����ѭ������

SUM:                    ; ���ѭ����ǩ�����������ĺ�
    PUSH CX             ; �����ѭ������ѹ���ջ
    MOV CX, 10          ; �ڲ�ѭ������
    MOV VAR4, AX        ; ����ǰ������ֵ���浽VAR4
TONGYU:                 ; �ڲ�ѭ����ǩ������ͬ�෨����
    ADD AX, VAR4        ; ����AX*11
    LOOP TONGYU         ; ѭ��10��
    ADD AX, 3           ; AX*11+3
    DIV BL              ; ����(AX*11+3) mod 255�����������AH��
    ROR AH, 1           ; ��AH�����λ�Ƶ�CF�У��ж���ż
    JNC EVEN            ; �����ż������ת��EVEN��ǩ
    ROL AH, 1           ; �������������AH����һλ
    MOV CL, 8           ; �ƶ�8λ
    SHR AX, CL          ; ����AX����AH����8λ���õ�����ֵ
    ADD DX, AX          ; ����ֵ�ӵ�SUM��
    INC BH              ; ����������1
    JMP NEXT            ; ��ת��NEXT��ǩ
EVEN:                   ; �����ż����ִ�д˲��ִ���
    ROL AH, 1           ; ��AH����һλ
    MOV CL, 8           ; �ƶ�8λ
    SHR AX, CL          ; ����AX����AH����8λ
NEXT:                   ; NEXT��ǩ������ѭ������
    POP CX              ; ����ѭ������
    LOOP SUM            ; ѭ�����ƣ�����SUMѭ��
    MOV CNT, BH         ; �������ĸ������浽CNT
    MOV SUMODD, DX      ; �������ĺͱ��浽SUMODD
    MOV AH, 4CH         ; �˳������DOS�жϺ�
    INT 21H             ; ����DOS�ж�21H��������������
CODE ENDS
END START


