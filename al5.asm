; Лабораторная работа 5


S_S segment stack
			dw		5 dup(?)	; Резервируем память
S_S ends


D_S segment
	a		db		1,0,0,4,4,3,1,2			; Исходный массив
	a0		db		8 dup(0)				; Массив нулей
D_S ends


C_S segment
assume ss:S_S, cs:C_S, ds:D_S, es:D_S
start:
	
	; Инициализация сегмента данных
	mov		ax, D_S
	mov		ds, ax
	
	; Сортировка массива по возрастанию
	
	mov		bx, offset a
	mov		cx, 8
	call	sort
	
	; Завершение работы
	mov		ax, 4c00h
	int		21h
	
	
	
	; Процедура сортировки массива по возрастанию
	; Входные параметры:
	;	bx - адрес сортируемого массива
	;	cx - длинна массива
	; На выходе:
	; 	Упорядоченный по возрастанию массив
	sort proc
		xor		si, si			; Обнуление si - позиция вставки очередного минимума
	SORT_O:
		mov		bp, cx
		mov		al, 127			; Текущий минимальный элемент 
		
		; Поиск очередного минимума
		mov		di, si			; Индекс элемента массива
		mov		cx, bp
	FIND_MIN:
		cmp		al, bx[di]
		jle		FIND_MIN_NEXT	; Если <= идём к следующему элементу
		mov		al, bx[di]		; Если > сохраняем минимум и его индекс
		mov		dx, di			
	FIND_MIN_NEXT:
		inc		di
		loop	FIND_MIN
		
		; Меняем местами крайний левый и минимум
		mov		cl, bx[si]
		mov		di, dx
		mov		bx[di], cl
		mov		bx[si], al
		
		mov		cx, bp
		inc		si			; Переходим к следующей позиции
		loop	SORT_O
		ret
	sort endp
	
C_S ends
end start