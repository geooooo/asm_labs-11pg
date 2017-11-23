s_s segment stack
	mem		db 100 dup(?)	  ; Резервируем память в стеке
s_s ends



d_s segment
	; 3 переменные
	a	db	 1
	b   db   2
	c   db   3
	; результат
	r   db   ?
d_s ends



c_s segment
assume cs:c_s, ss:s_s, ds:d_s
begin:

	; Подготовка сегментных регистров
	mov		ax, d_s
	mov		ds, ax
	
	; Наименьшее изначально a
	mov		al, a
	; Сравнение a > b
	cmp		al, b
	jle		CMP_C	; Если a <= b
	; Иначе
	mov		al, b
CMP_C:
	; Сравнение c "c"
	cmp		al, c
	jle		EXIT
	mov		al, c
	
EXIT:	
	mov		r, al
	; Выход из программы
	mov		ax, 4c00h
	int		21h

c_s ends
end begin