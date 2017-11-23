; Лабораторная работа 8


S_S segment stack
	db		100h dup(?)		; Резервируем память
S_S ends


D_S segment
	a		db	9 dup(1, 2, 3, 4, 5, 6, 7, 8, 9)	; матрица
	color	db  00000010b							; цвет
D_S ends


C_S segment
assume cs:C_S, ss:S_S, ds:D_S, es:D_S
start:

	; Инициализация сегментных регистров
	mov		ax, D_S
	mov		ds, ax
	
	mov		ax, 0003h
	int		10h
	
	; Вывод элементов
	mov		ah, 09h
	mov		bh, 0
	mov		al, a	; [1,1]
	add		al, '0'
	mov		bl, color
	mov		cx, 1
	int		10h
	
	mov		ah, 02h	; смена позиции курсора
	mov		bh, 0
	mov		dh, 0
	mov		dl, 2
	int		10h
	
	mov		ah, 09h
	mov		bh, 0
	mov		al, a+4	; [2,2]
	add		al, '0'
	mov		bl, color
	mov		cx, 1
	int		10h
	
	mov		ah, 02h
	mov		bh, 0
	mov		dh, 0
	mov		dl, 4
	int		10h
	
	mov		ah, 09h	; смена позиции курсора
	mov		bh, 0
	mov		al, a+8	; [3,3]
	add		al, '0'
	mov		bl, color
	mov		cx, 1
	int		10h
	
	; Завершение программы
	mov		ax, 4c00h
	int		21h
	
C_S ends
end start