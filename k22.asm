s_s segment stack
	db	100 dup (?)
s_s ends



d_s segment
	str1	db	255, 0, 255 dup ('$')
	str2	db	255, 0, 255 dup ('$')
	prefix	db	255 dup ('$')
	
	endl				db	0ah, 0dh, '$'
	msg_input_s1		db	'Input string 1: $'
	msg_input_s2		db	'Input string 2: $'
	msg_not_found		db	'Prefix not found.$'
d_s ends



c_s segment
assume ss:s_s, cs:c_s, ds:d_s, es:d_s
begin:

	mov		ax, d_s
	mov		ds, ax
	mov		es, ax
	
	; Ввод строк
	
	mov		ax, 0003h
	int		10h
	
	mov		ah, 09h
	mov		dx, offset msg_input_s1
	int		21h
	mov		ah, 0ah
	mov		dx, offset str1
	int		21h
	
	mov		ah, 09h
	mov		dx, offset endl
	int		21h
	
	mov		ah, 09h
	mov		dx, offset msg_input_s2
	int		21h
	mov		ah, 0ah
	mov		dx, offset str2
	int		21h
	
	mov		ah, 09h
	mov		dx, offset endl
	int		21h
	
	; Поиск префикса
	mov		al, str1+2
	cmp		al, str2+2
	jz		PREFIX_FOUND
	mov		ah, 09h
	mov		dx, offset msg_not_found
	int		21h
	jmp		EXIT
	
PREFIX_FOUND:
	cld
	xor		ch, ch
	mov		cl, str1+1
	cmp		cl, str2+1
	jbe		FIND_PREFIX	
	mov		cl, str2+1
FIND_PREFIX:
	mov		si, 2
	mov		di, 0
FIND_PREFIX_NEXT:
	mov		al, str1[si]
	cmp		al, str2[si]
	jnz		OUT_PREFIX
	mov		prefix[di], al
	
	inc		si
	inc		di
	loop	FIND_PREFIX_NEXT
	
OUT_PREFIX:
	mov		ah, 09h
	mov		dx, offset prefix
	int		21h
	
	; Выход
EXIT:
	mov		ah, 09h
	mov		dx, offset endl
	int		21h

	mov		ax, 4c00h
	int		21h

c_s ends
end begin
