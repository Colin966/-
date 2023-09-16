assume cs:codesg,ds:datasg
datasg segment
	db 'welcome to masm!'
datasg ends

codesg segment
start:	mov ax,datasg
		mov ds,ax
		mov bx,0					
				
		mov ax,0b800h			
		mov es,ax					
		mov si,0b40h				;定位到要显示字符串的段地址和偏移地址(计算得出)
		
		mov cx,7
		
	s1:	mov al,byte ptr ds:[bx]		;按字节从数据段中取出字符串,放到ax低位
		mov ah,00000010b			;在ax高位中放入字符串颜色属性
		inc bx
		mov es:[si],ax				;将ax放到显存中，小端，高位属性放到高地址，低位字符放到低地址
		add si,2
		loop s1						;循环7次把'welcome'打印出来
		
		inc bx
		add ax,2					;跳过空格
		
		mov cx,2
		
	s2:	mov al,byte ptr ds:[bx]
		mov ah,00100100b
		inc bx
		mov es:[si],ax
		add si,2
		loop s2						;循环2次把'to'打印出来
		
		inc bx
		add ax,2					;跳过空格
		
		mov cx,5
		
	s3:	mov al,byte ptr ds:[bx]
		mov ah,01110001b
		inc bx
		mov es:[si],ax
		add si,2
		loop s3						;循环5次把'masm!'打印出来
		
		mov ax,4c00h
		int 21h
codesg ends

end start