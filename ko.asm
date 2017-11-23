s_s segment stack
    dw  6 dup(?)     
s_s ends


d_s segment
	a db 6 dup(?)
d_s ends


c_s segment
assume cs:c_s, ss:s_s, ds:d_s
begin:

	mov ax,d_s
	mov ds,ax
	
	mov si,0
	mov cx,6
	vvod:
	mov ah,01h
	int 21h
	cmp al, ' '
	jz vvod
	cmp al, '0'                        
	jb exit                                  
	cmp al, '9'                            
	ja exit  
	sub	al, '0'
	mov a[si],al
	add si,1
	loop vvod

	mov si,0
	mov dl,a[si]
	mov si,1
	mov cx,5
	pr:
	mov bl,a[si]
	cmp dl,bl
	jle m1
	mov dl,a[si]
	m1:
	add si,1
	loop pr

	mov cx,6
	mov si,0
	m2:
	mov bl,a[si]
	add bl,dl
	mov a[si],bl
	add si,1
	loop m2

	exit:
	mov ax,4c00h
	int 21h

c_s ends
end begin
