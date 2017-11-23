; Задача 24
; 	1) Ввод строки символов
; 	2) Группировка одинаковых символов строки по возрастанию
; 	3) Вывод получившейся строки


S_S segment stack
			db		100h dup(?)			; Резервируем память: 256 байт
S_S ends


D_S segment
	s		db		21,0,21 dup(?)		; Вводимая строка
	
	; Сообщение-приглашение на ввод строки
	msg1	db		'Input string:',0ah,0dh,'$'
	; Сообщение при выводе результата
	msg2	db		0ah,0dh,'Result string:',0ah,0dh,'$'
D_S ends


C_S segment
assume cs:C_S, ss:S_S, ds:D_S, es:D_S
start:

	; Инициализация сегментных регистров
	mov		ax, D_S
	mov		ds, ax
	mov		es, ax
	
	; Вывод приглашения на ввод строки
	mov		ah, 09h
	mov		dx, offset msg1
	int		21h
	
	; Ввод исходной строки
	mov		ah, 0ah
	mov		dx, offset s
	int		21h
	
	; Группировка одинаковых символов строки по возрастанию
	mov		bx, offset s
	call	sgrup
	
	; Меняем в строке 'CR'(0dh) на '$'
	; si - позиция 'CR'
	mov		bx,	offset s
	mov		si, bx[1]
	add		si, 2
	mov		ax, si
	xor		ah, ah
	mov		si, ax
	mov		byte ptr bx[si], '$'
	
	; Вывод сообщения о выводе результата
	mov		ah, 09h
	mov		dx, offset msg2
	int		21h
	
	; Вывод получившейся строки
	mov		ah, 09h
	mov		dx, offset s+2		; Пропускаем 2 служебных байта
	int		21h
	
	; Завершение работы
	mov		ax, 4c00h
	int		21h
	
	
	
	; Процедура группировки символов строки по возрастанию
	; Входные параметры:
	;	bx - адрес исходной строки
	; На выходе:
	; 	Сгруппированная строка
	sgrup proc
		; Получение длинны строки
		mov		cl, byte ptr bx[1]
		xor		ch, ch
		
		mov		si, 2			; Позиция вставки очередного минимума, также пропускаем 2 служебных байта
	SORT_O:
		mov		bp, cx
		mov		al, 127			; Текущий минимальный элемент 
		
		; Поиск очередного минимума
		mov		di, si			; Индекс элемента строки
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
	sgrup endp

	
	
C_S ends
end start