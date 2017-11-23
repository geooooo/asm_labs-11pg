s_s segment stack
     mem  db  100 dup(?)
s_s ends

data segment
     string db 100, 0, 100 dup ('$')
data ends 

code segment
assume cs:code,ds:data,ss:s_s
start:

	mov ax, data
	mov ds, ax  

	mov ax,0003h        ;очистка экрана
	int 10h		   

	mov ah, 0ah		  	;ввод
	lea dx, string		  	 
	int 21h 			 

	mov ah,6			;строка
	mov dl,10
	int 21h
	mov dl,13
	int 21h
		 
	mov ah,9h			;звезда
	mov al,'*'
	mov bh,0
	mov bl,00110000b
	mov cx,10
	int 10h 

	mov ah,6			;строка
	mov dl,10
	int 21h
	mov dl,13
	int 21h
		  
	mov ah,9h			;вывод
	lea dx,string+2
	int 21h

	mov ax, 4c00h
	int 21h
	
code ends
end start
