; Лабораторная работа 7


S_S segment stack
	dw		20 dup ('$')			; Резервирование памяти
S_S ends


D_S segment
	res			db		0				; Результат анализа строки:
										;	0 - ошибок нет
										;	1 - несоответствие скобок
										;	2 - не все скобки закрыты
										;	3 - лишние закрывающие скобки
	s			db		'1{[23]}[d]' 	; Исходная анализируемая строка
	slen		equ		$-s				; Длина исходной строки
	hstack		dw		?				; Хранение изначальной вершины стека
	brackets	db		'([{}])'		; Набор допустимых скобок
D_S ends


C_S segment
assume ss:S_S, cs:C_S, ds:D_S
start:

	; Инициализация сегментных регистров
	mov		ax, D_S
	mov		ds, ax
	mov		es, ax
	
	; Проход по все строке
	mov		hstack, sp			; Сохраняем изначальную верхушку стека
	xor		dl, dl				; В случае ошибки 1 - несоответствие скобок, dl - код ожидаемой скобки, иначе 0
	mov		cx,	slen
	xor		si, si				; Индекс очередного символа строки, ичзначально 0
NEXT_CHAR:
	mov		bp, cx
	xor		ah, ah
	mov		al, s[si]			; Текущий символ строки в ax
	
	; Все символы, кроме скобок игнорируются
	mov		di, offset brackets
	mov		cx, 6				; Всего 6 скобок
	repne	scasb
	jz		CMP_BRACKET			; Если текущий символ скобка
	jmp		NEXT_CHAR_CONTINUE	; Если иной символ

CMP_BRACKET:
	; Все открывающие скобки помещаем в стек
	cmp		al, '('
	jnz		CMP_OPEN_NEXT1		; Если al != '('
	push	ax
	jmp		NEXT_CHAR_CONTINUE  ; Переходим к следующему символу строки
CMP_OPEN_NEXT1:
	cmp		al, '['
	jnz		CMP_OPEN_NEXT2		; Если al != '['
	push	ax
	jmp		NEXT_CHAR_CONTINUE  ; Переходим к следующему символу строки
CMP_OPEN_NEXT2:
	cmp		al, '{'
	jnz		CMP_OPEN_NEXT_END	; Если al != '{'
	push	ax
	jmp		NEXT_CHAR_CONTINUE  ; Переходим к следующему символу строки
CMP_OPEN_NEXT_END:
	
	; При всех закрывающих скобках проверяем есть ли
	; соответствующая открывающая
	cmp		sp, hstack			; Если стек пуст, ошибка 3 - лишние закрывающие скобки	
	jnz		STACK_NOT_EMPTY		; Если sp != 0fffeh, т.е. стек не пуст
	; В противном случае ошибка
	mov		res, 3		
	jmp		EXIT
STACK_NOT_EMPTY:

	; Если стек не пуст, проверяем соответствие скобок
	pop		bx					; bl - код открывающей скобки
	; Получаем код нужной закрывающей скобки
	cmp		bl, '('
	jz		CMP_ROUND_OPEN1		; Если bl = '('
	; Иначе '[' и '{'
	add		bl, 2
	jmp		CMP_OPEN_CLOSE
CMP_ROUND_OPEN1:
	; Для '('
	inc		bl
CMP_OPEN_CLOSE:
	cmp		bl, al
	jz		NEXT_CHAR_CONTINUE	; Если bl = al, ошибок нет
	; Иначе ошибка 1 - несоответствие скобок
	mov		res, 1
	mov		dl, bl				; dl - код ожидаемой скобки
	jmp		EXIT

NEXT_CHAR_CONTINUE:	
	inc		si
	mov		cx, bp
	loop	NEXT_CHAR
	
	; Проверка - все ли скобки закрыты, т.е. пуст ли стек
	cmp		sp, hstack
	jz		OK					; Если sp = 0fffeh
	; Иначе ошибка 2 - не все скобки закрыты
	mov		res, 2
	jmp		EXIT
OK:
	mov		res, 0				; 0 - ошибок нет
	
EXIT:
	; Завершение работы
	mov		ax, 4c00h
	int		21h	

C_S ends
end start