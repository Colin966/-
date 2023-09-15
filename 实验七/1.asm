assume cs:codesg

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
  
    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514   
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000   

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226   
    dw 11542,14430,15257,17800   
data ends   
  
table segment   
    db 21 dup ('year summ ne ?? ')   
table ends  

codesg segment
start:	mov ax,data
		mov ds,ax			;数据段地址放入ds
		mov bx,0			;年份偏移
		mov si,54h			;收入偏移
		mov di,0a8h			;雇员数量偏移
		
		mov ax,table
		mov es,ax
		mov bp,0			;表格段地址放入es
		
		mov cx,21			;循环21次
		
	s:	mov al,ds:[bx]
		mov es:[bp],al
		mov al,ds:1h[bx]
		mov es:1h[bp],al
		mov al,ds:2h[bx]
		mov es:2h[bp],al
		mov al,ds:3h[bx]
		mov es:3h[bp],al		;年份字符串是 db 字节定义的，分成四个字节存储	
		                        	;将年份送入table中
		
		mov ax,ds:[si]
		mov dx,ds:2h[si]
		mov es:5h[bp],ax
		mov es:7h[bp],dx		;总收入是由 dd 定义的双字(4 Byte)存储，取出时考虑 高位的字(2 Byte)和低位的字(2 Byte)
						;为了方便接下来计算平均收入，选择将高位放在dx中，低位放在ax中
						;将总收入分高位，低位送入table
		
		div word ptr ds:[di]		;段地址ds偏移di是雇员数量地址，雇员数量是dw定义的字型(2 Byte)存储,满足div除法中32位除16位的情况
		mov es:0dh[bp],ax		;商被放在ax中，送入table
		
		mov ax,ds:[di]
		mov es:0ah[bp],ax		;雇员数量送入table
		
		add bx,4h			;年份4字节，偏移增4h
		add si,4h			;总收入4字节，偏移增4h
		add di,2h			;雇员数量字节，偏移增2h
		add bp,10h			;表格一轮16字节，偏移增10h
		loop s
		
		mov ax,4c00h
		int 21h
	
codesg ends

end start	
