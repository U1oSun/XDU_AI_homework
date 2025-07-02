DATA SEGMENT
    ChooseModel DB 'Plesse input the number(1-5) to get in the model:','$'
    Model1txt1 DB 'Now, we are doing function 1:','$'
    Model1txt2 DB 'input character:','$'
    Model2txt1 DB 'Now, we are doing function 2:','$'
    Model2txt2 DB 'input character:','$'
    Model2txt3 DB 'max is:','$'
    Model3txt1 DB 'Now, we are doing function 3:','$'
    Model3txt2 DB 'input the decimal number:','$'
    Model4txt1 DB 'Now, we are doing function 4:','$'
    Model4txt2 DB 'press anykey to display the time','$'
    Finaltxt DB 'What do you want to do next"Main Menu or Redo"[ESC or any other key]:','$'
    TIPInputTIME DB 'Please input TIME(HH:MM:SS:):','$'
    
    
    STRING DB 100, DB 0, DB 100 DUP(0)
    MaxStr DB 0
    Array DB 100 DUP(0)
	ArrayLength DB 0
	SpiltStr DB 20H;空格的ASCII
	Decimal DB 10 
    
DATA ENDS

STACK SEGMENT STACK
    
    
STACK ENDS

CODE SEGMENT 
    ASSUME CS:CODE,DS:DATA,SS:STACK
    
START:
    MOV AX,DATA
    MOV DS,AX  
Menu:
    MOV AH,0
	MOV AL,3
	INT 10H
	;设置显示器模式
	    
    MOV AH,9
    LEA DX,ChooseModel
    INT 21H
    MOV AH,1
    INT 21H
    
    CMP AL,'1'
	JZ Model1
	CMP AL,'2'
	JZ Model2
	CMP AL,'3'
	JZ Model3
	CMP AL,'4'
	JZ Model4
	CMP AL,'5'
	JZ Model5

Model1: 

    MOV AH,0
	MOV AL,3
	MOV BL,0
	INT 10H
	;清屏幕	
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,0
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model1txt1
    INT 21H
    ;显示Model1txt1
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,1
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model1txt2
    INT 21H
	;显示Model1txt2
	CALL CapitalizeString
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,5
	INT 10H
	;设置光标
	LEA DX,Finaltxt
    MOV AH,9
    INT 21H
	;显示Finaltxt
	MOV AH,8
	INT 21H
	CMP AL,1BH;Esc的ascii码值
	JZ Menu
	JMP Model1;检测键盘输入是否为Esc，若是则返回主菜单，否则重做
                                                                 
Model2:
    MOV AH,0
	MOV AL,3
	MOV BL,0
	INT 10H
	;清屏幕
	
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,0
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model2txt1
    INT 21H
    ;显示Model2txt1
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,1
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model2txt2
    INT 21H
	;显示Model2txt2
	CALL FindMax
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,4
	INT 10H
	;设置光标
	LEA DX,Finaltxt
    MOV AH,9
    INT 21H
	;显示Finaltxt
	MOV AH,8
	INT 21H
	CMP AL,1BH
	JZ Menu
	JMP Model2;检测键盘输入是否为Esc，若是则返回主菜单，否则重做 
	
Model3:
    MOV AH,0
	MOV AL,3
	MOV BL,0
	INT 10H
	;清屏幕
	
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,0
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model3txt1
    INT 21H
    ;显示Model3txt1
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,1
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model3txt2
    INT 21H
	;显示Model3txt2
	CALL Sort
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,8
	INT 10H
	;设置光标
	LEA DX,Finaltxt
    MOV AH,9
    INT 21H
	;显示Finaltxt
	MOV AH,8
	INT 21H
	CMP AL,1BH
	JZ Menu
	JMP Model3;检测键盘输入是否为Esc，若是则返回主菜单，否则重做 
	
Model4: 
    MOV AH,0
	MOV AL,3
	MOV BL,0
	INT 10H
	;清屏幕
	
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,0
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model4txt1
    INT 21H
    
    ;显示Model4txt1
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,1
	INT 10H
	;设置光标
	MOV AH,9
    LEA DX,Model4txt2
    INT 21H
	;显示Model4txt2
	MOV AH,2CH
	INT 21H
	
	
	CALL TIME
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,6
	INT 10H
	;设置光标
	LEA DX,Finaltxt
    MOV AH,9
    INT 21H
	;显示Finaltxt
	MOV AH,8
	INT 21H
	CMP AL,1BH
	JZ Menu
	JMP Model4;检测键盘输入是否为Esc，若是则返回主菜单，否则重做
	
Model5:
    MOV AH,0
	MOV AL,3
	MOV BL,0
	INT 10H
	MOV AH,4CH
    INT 21H
	;返回操作系统

CapitalizeString PROC NEAR
    LEA DX,STRING
    MOV AH,0AH
    INT 21H
    ;键盘输入到缓冲区
    XOR BX,BX
    LEA SI,STRING+1
    MOV BL,BYTE PTR[SI]
    MOV STRING[BX+2],'$' 
    ;加结束符号$ 
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,2
	INT 10H
	;设置光标 
	LEA DX,STRING+2
	MOV AH,9
	INT 21H
    
    
    LEA SI,STRING+2          
    MOV CH,0 
    MOV CL,STRING+1         
    CHANGE:
        CMP BYTE PTR[SI],41H ;STRING为字符串，将其和 41H（大写 A）比较
        JB INCNUMBER         ;若小于 41H，就是数字，处理下一个，若为字母，与 5FH加和，得到大写字母的 ASCII码。
        AND BYTE PTR[SI],5FH
    INCNUMBER:
        INC SI
    LOOP CHANGE
    
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,3
	INT 10H
	;设置光标
    LEA DX,STRING+2
    MOV AH,9
    INT 21H
    
    
    RET
CapitalizeString ENDP

FindMax PROC NEAR
    LEA DX,STRING
    MOV AH,0AH
    INT 21H
    ;键盘输入到缓冲区
    XOR BX,BX
    LEA SI,STRING+1
    MOV BL,BYTE PTR[SI]
    MOV STRING[BX+2],'$' 
    ;加结束符号$ 
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,2
	INT 10H
	;设置光标 
	LEA DX,STRING+2
	MOV AH,9
	INT 21H
    ;显示
    MOV AH,3
    INT 10H
    ;获取光标位置
    INC DL
    MOV AH,2
    INT 10H
    ;设置光标
    LEA DX,Model2txt3
	MOV AH,9
	INT 21H
    
      
    LEA SI,STRING+2
    MOV CH,0 
    MOV CL,STRING+1
    MOV DL,[SI]
    MAX:
        CMP DL,[SI]
        JA INCNUMBER2
        MOV DL,[SI]
    INCNUMBER2:
        INC SI
    LOOP MAX
    ;找最大值并放在DL中
    
    MOV AH,2
    INT 21H
    ;显示DL 
    
    RET
FindMax ENDP  

Sort PROC NEAR
    
    LEA DX,STRING
    MOV AH,0AH
    INT 21H
    ;键盘输入到缓冲区
    XOR BX,BX
    LEA SI,STRING+1
    MOV BL,BYTE PTR[SI]
    MOV STRING[BX+2],'$' 
    ;加结束符号$ 
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,2
	INT 10H
	;设置光标 
	LEA DX,STRING+2
	MOV AH,9
	INT 21H
    ;显示
    
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,4
	INT 10H
	;设置光标 
	LEA DX,STRING+2
	MOV AH,9
	INT 21H
    ;显示
    
    MOV AH,0
    MOV AL,STRING+1
    MOV CX,AX
    
    LEA SI,STRING+2
	LEA DI,Array
	MOV DH,0	;用于存放数组个数
    MOV AL,0	;用于存放该数字十进制
	MOV DL,0	;用于存放该数字位数    
	;SpiltStr中存储着空格，spilt函数是为了将以空格为间隙的输入数字读取 并转为十进制数
	Spilt: 

		MOV BL,[SpiltStr]
		CMP [SI],BL
		JZ Addnum
		INC SI
		INC DL
		JMP NotSpilt
	Addnum:
		INC DH
		
	PUSH CX
	PUSH SI
				
	MOV AL,DL
	MOV AH,0
    MOV CX,AX
    			
    Return:
    		DEC SI
    		LOOP Return
    			
    MOV CX,AX
    DEC CX
    MOV AX,0
    MOV AL,[SI]
    SUB AL,30H;ASCII减30H就是十进制数
    CMP CX,0
    JZ Continue
    			
    StrToDeci:
		INC SI
		MUL Decimal
		MOV BL,[SI]
		SUB BL,30H
		ADD AL,BL
		LOOP StrToDeci
	Continue:				
	MOV [DI],AL
	INC DI
	MOV DL,0

	POP SI
	INC SI;指向逗号下一个
	POP CX
	NotSpilt:
		LOOP Spilt 
    
    ;给最后一个数再来一次
    MOV AL,DL
	MOV AH,0
    MOV CX,AX
    			
    Return2:
    		DEC SI
    		LOOP Return2
    			
    MOV CX,AX
    DEC CX
    MOV AX,0
    MOV AL,[SI]
    SUB AL,30H;ASCII减30H就是十进制数
    CMP CX,0
    JZ Continue2
    			
    StrToDeci2:
		INC SI
		MUL Decimal
		MOV BL,[SI]
		SUB BL,30H
		ADD AL,BL
		LOOP StrToDeci2
	Continue2:				
	MOV [DI],AL
	INC DI
	MOV DL,0

    INC DH
	MOV [ArrayLength],DH
	;至此，已经将数字存入Array中
	
	
	;输出16进制
	;接下来输出16进制数
	MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,5
	INT 10H
	;设置光标
	DispArray:
	    MOV AL,[ArrayLength]
	    MOV AH,0
	    MOV CX,AX
	    LEA SI,Array
	    
	    
	    DispOne:
	        MOV AL,[SI]
	        PUSH AX
	        SHR AL,4
	        CALL ChangeH
	        MOV AH,02
	        MOV DL,AL
	        INT 21H
	        POP AX
	        AND AL,0FH
	        CALL ChangeH
	        MOV AH,02
	        MOV DL,AL
	        INT 21H
	        MOV DL,48H
	        INT 21H
	        MOV DL,20H
	        INT 21H
	        INC SI

	        LOOP DispOne
    
    
    
    
    ;接下来是排序
		
	MOV AL,[ArrayLength]
    MOV CH,0
    MOV CL,AL
    DEC CX;外循环次数
    LEA SI,Array
    ADD SI,CX
    LP1:
        PUSH CX 
        PUSH SI
    LP2:
        MOV AL,[SI]
        CMP AL,[SI-1]
        JAE NOXCHG
        XCHG AL,[SI-1]
        MOV [SI],AL
    NOXCHG:
        DEC SI
        LOOP LP2
        POP SI
        POP CX
        LOOP LP1
	

	
	;排序后的结果放在ArraySorted
	;再输出一次16进制
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,6
	INT 10H
	;设置光标
	DispArray2:
	    MOV AL,[ArrayLength]
	    MOV AH,0
	    MOV CX,AX
	    LEA SI,Array
	    
	    
	    DispOne2:
	        MOV AL,[SI]
	        PUSH AX
	        SHR AL,4
	        CALL ChangeH
	        MOV AH,02
	        MOV DL,AL
	        INT 21H
	        POP AX
	        AND AL,0FH
	        CALL ChangeH
	        MOV AH,02
	        MOV DL,AL
	        INT 21H
	        MOV DL,48H
	        INT 21H
	        MOV DL,20H
	        INT 21H
	        INC SI

	        LOOP DispOne2  
 
    RET
Sort ENDP

ChangeH PROC NEAR
	CMP AL,10
	JNGE Change1
	ADD AL,7
	Change1:
        ADD AL,30H
    RET
ChangeH ENDP


TIME PROC NEAR

    ;2CH号功能获取时间并存储在Array中  
	MOV AH,2CH
    INT 21H
    MOV [Array],CH
    MOV [Array+1],CL
    MOV [Array+2],DH
        
    MOV AH,2
	MOV BH,0
	MOV DL,0
	MOV DH,2
	INT 10H
	;设置光标
	LEA SI,Array
    CALL DispDec
    
    MOV DL,':'
    MOV AH,02H
    INT 21H
    ;时、分、秒添加间隔“：”
    INC SI
    CALL DispDec
    
    MOV DL,':'
    MOV AH,02H
    INT 21H
    
    INC SI
    CALL DispDec

 
    RET
TIME ENDP 

DispDec PROC NEAR 
        ;将获取的时间转化为10进制数
 	    MOV AL,[SI]
	    CBW
	    DIV Decimal
	    ADD AH,'0'
	    MOV BH,AH
	    ADD AL,'0'
		
	    MOV DL,AL
        MOV AH,02H
        INT 21H
    	
        MOV DL,BH
        INT 21H

	    RET
DispDec ENDP
                                                             
CODE ENDS
    END START