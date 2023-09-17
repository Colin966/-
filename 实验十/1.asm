assume cs:code
data segment
	db 'welcome to masm!',0
data ends

code segment
start:
		mov dh,8		;行号(0-24)
		mov dl,3		;列号(0-79)
		mov cl,2		;颜色属性
		mov ax,data
		mov ds,ax
		mov si,0		;ds:[si] 指向数据段中第一个字符
		call show_str		
		
		mov ax,4c00h
		int 21h
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