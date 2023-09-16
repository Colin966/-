assume cs:codesg,ds:datasg,ss:stacksg
datasg segment
	db 'welcome to masm!'				;字符串
	db 00000010b,00100100b,01110001b	;三种颜色属性
datasg ends

stacksg segment
	dw 3 dup(0)							;涉及二层循环,考虑用栈用来保存寄存器数据
	stacksg ends
	
codesg segment
start:	mov ax,stacksg
		mov ss,ax
		mov sp,6h						;栈顶指针
		
		mov ax,datasg
		mov ds,ax
		mov bx,0						;ds:[bx]指向字符串中第一个字符'w'
		mov di,10h						;ds:[di]指向第一个颜色属性
				
		mov ax,0b800h
		mov es,ax
		mov si,720h						;es:[si]指向显存中第12行应该显示'w'的位置
		
			
		mov cx,3						;外层循环进行3次，打印三次字符串
		
	s2:	push cx							;内层循环会改变cx，将cx入栈保存
		push si							;si是显存中第一个字符串首字符的偏移,内层循环中会改变si，将si入栈保存
		push bx							;bx是数据段中字符串首字符的偏移，内层循环中会改变bx，将si入栈保存
		
		mov cx,16						;内层循环16次(字符串16 Byte)
		
	s1:	mov al,byte ptr ds:[bx]			;按字节从数据段中取出字符串,放到ax低位
		mov ah,byte ptr ds:[di]			;在ax高位中放入字符串颜色属性
		mov es:[si],ax					;将ax放到显存中，小端，高位属性放到高地址，低位字符放到低地址
		inc bx
		add si,2
		loop s1
		
		inc di							;ds:[di]指向下一个颜色属性
		
		pop bx							;bx出栈
		
		pop si							;si出栈
		add si,0a0h						;es:[si]指向显存下一行字符串首字符位置
		
		pop cx							;cx出栈
		loop s2
		
		mov ax,4c00h
		int 21h
codesg ends

end start