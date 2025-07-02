STACK SEGMENT STACK'STACK'
    DW 100H DUP(?)     ; 定义堆栈段，大小为100H字节
TOP LABEL WORD
STACK ENDS

DATA SEGMENT
    CNT DB 0            ; 存储奇数的个数
    SUMODD DW 0         ; 存储奇数的和
    VAR1 DB 1           ; 循环计数器初始值
    VAR2 DB 255         ; 同余法产生小于256的随机数：AX=(AX*11+3) mod 255
    VAR3 DB 200         ; 要产生200个随机数，循环200次
    VAR4 DW 0           ; 临时变量
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, ES:DATA, SS:STACK
START:
    MOV AX, DATA        ; 将数据段地址加载到AX寄存器
    MOV DS, AX          ; 将数据段地址复制到DS寄存器
    XOR AX, AX          ; 清零
    XOR BX, BX         
    XOR CX, CX          
    XOR DX, DX          
    MOV AL, VAR1        ; 作为循环计数器
    MOV BL, VAR2        ; 用于同余法计算
    MOV CL, VAR3        ; 控制循环次数

SUM:                    ; 外层循环标签，计算奇数的和
    PUSH CX             ; 将外层循环次数压入堆栈
    MOV CX, 10          ; 内层循环次数
    MOV VAR4, AX        ; 将当前计数器值保存到VAR4
TONGYU:                 ; 内层循环标签，进行同余法计算
    ADD AX, VAR4        ; 计算AX*11
    LOOP TONGYU         ; 循环10次
    ADD AX, 3           ; AX*11+3
    DIV BL              ; 计算(AX*11+3) mod 255，余数存放在AH中
    ROR AH, 1           ; 将AH的最低位移到CF中，判断奇偶
    JNC EVEN            ; 如果是偶数，跳转到EVEN标签
    ROL AH, 1           ; 如果是奇数，将AH左移一位
    MOV CL, 8           ; 移动8位
    SHR AX, CL          ; 更新AX，将AH右移8位，得到奇数值
    ADD DX, AX          ; 奇数值加到SUM中
    INC BH              ; 奇数个数加1
    JMP NEXT            ; 跳转到NEXT标签
EVEN:                   ; 如果是偶数，执行此部分代码
    ROL AH, 1           ; 将AH左移一位
    MOV CL, 8           ; 移动8位
    SHR AX, CL          ; 更新AX，将AH右移8位
NEXT:                   ; NEXT标签，用于循环控制
    POP CX              ; 弹出循环次数
    LOOP SUM            ; 循环控制，继续SUM循环
    MOV CNT, BH         ; 将奇数的个数保存到CNT
    MOV SUMODD, DX      ; 将奇数的和保存到SUMODD
    MOV AH, 4CH         ; 退出程序的DOS中断号
    INT 21H             ; 调用DOS中断21H，结束程序运行
CODE ENDS
END START


