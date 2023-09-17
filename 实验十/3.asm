assume cs:code

data segment
	db 10 dup(0)
data ends

stack segment
	dw 16 dup(0)
stack ends

code segment
start:	mov ax,stack
		mov ss,ax
		mov sp,32
		
		mov ax,12666
		mov bx,data
		mov ds,bx
		mov si,0
		mov di,0
		call dtoc
		
		
		mov dh,8
		mov dl,3
		mov cl,2
		call show_str
		
		mov ax,4c00h
		int 21h


dtoc:	
	s5:	mov cl,10
		call divw
		mov dh,0
		push dx			;余数入栈保存
		inc di
		mov cx,ax
		jcxz s6
		jmp short s5
		
	s6:	pop dx
		add dl,30h
		mov ds:[si],dl
		inc si
		dec di
		mov cx,di
		jcxz s7
		jmp short s6
		
	s7: mov dl,0
		mov ds:[si],dl	;字符串结束'0'
		mov si,0
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
		mov ah,bl
		ret


show_str:
		mov ax,0B800h
		mov es,ax
		mov di,0
		mov al,160
		mul dh
		add di,ax
		mov al,2
		mul dl
		add di,ax
		mov bx,0
		
		mov bl,cl
		
	s1:	mov ah,bl
		mov al,byte ptr ds:[si]
		mov cl,al
		mov ch,0
		jcxz s2
		mov word ptr es:[di],ax
		add di,2
		inc si
		jmp short s1
	s2:	ret
	
	
code ends

end start