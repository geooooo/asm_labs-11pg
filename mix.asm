s_s segment stack
s_s ends



d_s segment
	
	Pers struc
		fname db	10 dup('$')
		lname db    10 dup('$')
		grp   db	10 dup('$')
	Pers ends
	
	person Pers <'Mixail','Poliakov','11-pg'>, <'Vlad','Proidak','11-pg'>, <'Kolia','Gribanov','11-pg'>

d_s ends



c_s segment
assume cs:c_s, ss:s_s, ds:d_s, es:d_s
start:

	mov		ax, d_s
	mov		ds, ax
		
	mov		si, size Pers	  ; Размер одной записи
	mov		bx, offset person ; Адрес начала массива записей
		
	; Вывод имени
	add		bx, si			  ; Переход ко 2-ой записи на начало имени
	mov		ah, 09h
	mov		dx, bx
	int		21h
	
	; Запятая
	mov		ah, 06h
	mov		dl, ','
	int		21h
	
	; Вывод фамилии
	add		bx, 10
	mov		ah, 09h
	mov		dx, bx
	int		21h
	
	; Запятая
	mov		ah, 06h
	mov		dl, ','
	int		21h
	
	
	; Вывод группы
	add		bx, 10
	mov		ah, 09h
	mov		dx, bx
	int		21h
	
	mov		ax, 4c00h
	int		21h

c_s ends
end start