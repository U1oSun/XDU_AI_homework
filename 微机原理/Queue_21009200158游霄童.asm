STACK SEGMENT STACK

STACK ENDS

DATA SEGMENT
     VAR1 DB 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17  ;VAR1�洢n
     QUEUE DB 17 DUP(0)
   
DATA ENDS

CODE SEGMENT
     ASSUME CS:CODE,DS:DATA,ES:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
              ;BXΪ�����е��˵ı�ţ�AXΪ��ǰ�ı���
    XOR AX,AX
    XOR BX,BX
    XOR CX,CX
    XOR DX,DX
    
    MOV CL,VAR1
    MOV DX,DI 
    MOV AX,1
    MOV SI,0 
    
LOOP1:
    CMP BL,11H
    JNZ GO
    
    MOV BX,0
    
GO:
    MOV CL,[BX]
    CMP CL,0
    JNZ LOOP2
    INC BX
    JMP LOOP1    
     
LOOP2:
    
    CMP AL,0BH ;��ѭ����������ALΪ��ǰ����
    JZ  LOOP3
    INC AL
    INC BX
    JMP LOOP1

LOOP3:
    MOV [SI+17],CL
    MOV [BX],0
    MOV AX,1 
    CMP SI,10H
    JZ OVER
    INC SI
    INC BX
    JMP LOOP1
OVER:
    MOV AH,4CH
    INT 21H
CODE ENDS
    END START