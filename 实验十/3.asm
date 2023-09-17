;数值显示
assume cs:code

data segment
	db 10 dup(0)
data ends

stack segment
	dw 16 dup(0)
stack ends

code segment
start:	
		mov ax,stack
		mov ss,ax
		mov sp,32		;栈(16 word空间)
				
		mov bx,data
		mov ds,bx
		mov si,0		;ds:[si]指向数据段首地址
		mov di,0
		mov ax,12666	;要显示的数
		call dtoc
		
		
		mov dh,8		;行号(0-24)
		mov dl,3		;列号(0-79)
		mov cl,2		;颜色属性
		call show_str
		
		mov ax,4c00h
		int 21h


dtoc:	
	s5:	mov cl,10		;除数10
		call divw
		mov dh,0
		push dx			;余数入栈保存
		inc di			;di表示入栈余数个数
		
		mov cx,ax		
		jcxz s6			;商传递给cx，cx为0时结束循环
		jmp short s5
		
	s6:	pop dx
		add dl,30h
		mov ds:[si],dl	;余数出栈转换成ASCII码并存入数据段
		
		inc si			;ds:[si]指向数据段下一个字符地址
		dec di			;入栈的余数个数-1
		
		mov cx,di		
		jcxz s7			;栈中剩余余数为0时，跳出循环
		jmp short s6
		
	s7: mov dl,0
		mov ds:[si],dl	;字符串结束'0'
		mov si,0		;si恢复0
		ret
		
		
		


divw:					;安全16位除8位  ax被除数(16位) cl除数(8位) 商保存在ax(16位) 余数保存在dl(8位)
		mov dl,al
		mov dh,0
		push dx			;用栈保存ax低8位
		
		mov al,ah
		mov ah,0
		div cl
		mov bl,al		;用bl保存al 这里al是 最终商的高8位
		
		pop dx
		mov al,dl
		div cl			
		mov dl,ah
		mov ah,bl		;逻辑和2.asm中32位除16位原理相同，可参考2.asm
		ret


show_str:				;显示字符串子程序
		mov ax,0B800h
		mov es,ax		;es是显存中要显示字符串处段地址
		mov di,0
		
		mov al,160
		mul dh
		add di,ax		
		mov al,2
		mul dl
		add di,ax		;di是显存中要显示字符串处偏移，es:[di]指向要显示字符串首地址
		
		mov bx,0		
		mov bl,cl		;cl放到bl中保存起来(下面要用到jcxz指令要配合cx用，会改变cl值)
		
	s1:	mov ah,bl		;将ax高位放入颜色属性
		mov al,byte ptr ds:[si]		;将ax低位放入字符串
		
		mov cl,al
		mov ch,0
		jcxz s2			;判断字符串是否为'0'，如果为'0'，跳出循环，字符串全部显示
		
		mov word ptr es:[di],ax		;将ax放入显存中
		
		add di,2		;es:[di]指向下一字符和属性在显存中要放入的地址
		inc si			;ds:[si]指向数据段中下一个字符
		
		jmp short s1	;循环向显存中放入字符和属性(直到jcxz达成条件跳出)
	s2:	ret
	
	
code ends

end start