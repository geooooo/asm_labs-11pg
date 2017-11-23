s_s segment stack
	db	100 dup(?)
s_s ends



d_s segment
	msg_mn	db	'Input M and N: $'
	msg_a1	db	0ah,0dh,'Input array 1:',0ah,0dh,'$'
	msg_a2	db	0ah,0dh,'Input array 2:',0ah,0dh,'$'
	
	m		db	?
	n		db 	?
	
	a1		db	9 dup(?)
	a2		db	9 dup(?)
	a3		db	9 dup(?)
d_s ends



c_s segment
assume cs:c_s, ss:s_s, ds:d_s, es:d_s
start:

	mov		ax, d_s
	mov		ds, ax
	
	mov		ah, 09h
	mov		dx, offset msg_mn
	int		21h
	
	; M
	mov		ah, 01h
	int		21h
	sub		al, '0'
	mov		m, al
	; Пробел
	mov		ah, 01h
	int		21h
	; N
	mov		ah, 01h
	int		21h
	sub		al, '0'
	mov		n, al
	
	cmp		al, m
	jz		CMP_OK
	jmp		EXIT
	
CMP_OK:
	mov		ah, 09h
	mov		dx, offset msg_a1
	int		21h
	
	mov 	si, 0
	xor		ch, ch
	mov 	cl, m
VVOD1:
	mov 	ah, 01h
	int 	21h
	cmp 	al, ' '
	jz 		VVOD1
	cmp 	al, '0'                        
	jae 	M11
	jmp		EXIT
M11:
	cmp 	al, '9'                            
	jbe		M12
	jmp		EXIT
M12:
	sub		al, '0'
	mov		a1[si], al
	add		si, 1
	loop 	VVOD1
	
	mov		ah, 09h
	mov		dx, offset msg_a2
	int		21h
	
	mov 	si, 0
	xor		ch, ch
	mov 	cl, n
VVOD2:
	mov 	ah, 01h
	int 	21h
	cmp 	al, ' '
	jz 		VVOD2
	cmp 	al, '0'                        
	jae 	M21
	jmp		EXIT
M21:
	cmp 	al, '9'                            
	jbe		M22
	jmp		EXIT
M22:
	sub		al, '0'
	mov		a2[si], al
	add		si, 1
	loop 	VVOD2
	
	xor		ch, ch
	mov		cl, m
	mov		si, 0
SUM_A12:

	mov		al, a1[si]
	add		al, a2[si]
	mov		a3[si], al
	
	inc		si
	loop	SUM_A12
	
	xor		ch, ch
	mov		cl, m
	xor		si, si
	
	mov		ah, 06h
	mov		dl, 0ah
	int		21h
	mov		ah, 06h
	mov		dl, 0dh
	int		21h
	
	
OUT_A3:

	mov		bl, 10
	xor		ah, ah
	mov		al, a3[si]
	div		bl
	mov		bx, ax
	
	mov		ah, 06h
	mov		dl, bl
	add		dl, '0'
	int		21h
	mov		ah, 06h
	mov		dl, bh
	add		dl, '0'
	int		21h
	mov		ah, 06h
	mov		dl, ' '
	int		21h

	inc		si
	loop	OUT_A3
	

EXIT:	
	mov		ax, 4c00h
	int		21h

c_s ends
end start