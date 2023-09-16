assume cs:codesg,ds:datasg,ss:stacksg
datasg segment
	db 'welcome to masm!'
	db 00000010b,00100100b,01110001b
datasg ends

stacksg segment
	dw 3 dup(0)
	stacksg ends
	
codesg segment
start:	mov ax,stacksg
		mov ss,ax
		mov sp,6h
		
		mov ax,datasg
		mov ds,ax
		mov bx,0
		mov di,10h
				
		mov ax,0b800h
		mov es,ax
		mov si,720h
		
			
		mov cx,3
		
	s2:	push cx
		push si
		push bx
		
		mov cx,16
		
	s1:	mov al,byte ptr ds:[bx]
		mov ah,byte ptr ds:[di]
		mov es:[si],ax
		inc bx
		add si,2
		loop s1
		
		inc di
		pop bx
		pop si
		add si,0a0h
		pop cx		
		loop s2
		
		mov ax,4c00h
		int 21h
codesg ends

end start