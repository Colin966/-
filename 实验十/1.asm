assume cs:code
data segment
	db 'welcome to masm!',0
data ends

code segment
start:	mov dh,8
		mov dl,3
		mov cl,2
		mov ax,data
		mov ds,ax
		mov si,0
		call show_str
		
		mov ax,4c00h
		int 21h
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