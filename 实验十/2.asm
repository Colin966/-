;解决除法溢出问题
assume cs:code,ss:stack
stack segment
	dw 8 dup(0)
stack ends

code segment
start:	mov ax,stack
		mov ss,ax
		mov sp,16		;栈(8 word空间)
		
		mov ax,4240h	;32位被除数的低16位
		mov dx,000fh	;32位被除数的高16位
		mov cx,0ah		;除数
		call divdw
		
		mov ax,4c00h
		int 21h
	
divdw:	push ax			;ax入栈，保护被除数低16位

		mov ax,dx	
		mov dx,0		
		div cx			;将被除数高16位放到ax中，dx设为0，得到的商放进ax中，余数放dx
		
		mov bx,ax		;(ax就是结果32位商的高16位)，放bx中保存起来
		
		pop ax			;ax取出被除数低16位
		div cx			;dx中有之前的余数，商放ax(ax就是结果32位商的低16位)，余数放dx
		
		mov cx,dx		;余数放cx
		mov dx,bx		;bx中保存的32位商的高16位放dx
		ret
		
code ends
end start