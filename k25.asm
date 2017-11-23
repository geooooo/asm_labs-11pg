; Контрольная работа 25
;
; Условие:
; 	Написать программу на языке Ассемблера,
; 	которая позволяет ввести с клавиатуры
; 	целочисленный массив из 9 элементов
; 	и некоторое натуральное число N, найти и вывести
; 	на экран сумму тех элементов массива, которые стоят
; 	на позициях, кратных введённому числу N


S_S segment stack
			db		0ffh dup(?)						; Резервирование 256 байт.
S_S ends


D_S segment
	a_size 			equ		9						; Размер массива
	a				db		a_size dup(?)			; Исходный массив
	msg_inp_arr		db		'Input array: $'		; Приглашение на ввод массива
	c				dw		?						; Операнд для сопроцессора	
D_S ends


C_S segment
assume cs:C_S, ss:S_S, ds:D_S, es:D_S
START:
	
	; Инициализация сегментых регистров
	mov		ax, D_S
	mov		ds, ax
	mov		es, ax
	
	; Вывод приглашения на ввод массива
	mov		ah, 09h
	mov		dx, offset msg_inp_arr
	int		21h
	
	; Ввод массива с клавиатуры
	mov		bh, a_size						; Коичество вводимых элементов
	xor		si, si							; Индекс элементов массива
READ_ELEMENT:
	; Чтение очередного числа
	mov		cx, 3								; Максимум можно ввести 3 цифры, т.к. числа 1 байтные
	xor		dl, dl								; Очередное считываемое число
	xor		dh, dh								; Признак знака 0(+), 1(-)
READ_CHR:
	; Считывание символа
	mov		ah, 01h
	int		21h
	; Если введёный символ не является цифрой, минусом, пробелом генерация ошибки
	; Пропуск пробелов
	cmp		al, ' '
	jnz		CMP_NEG
	cmp		cx, 3
	jz      READ_CHR
	jmp     SAVE_ELEMENT
	
	; Возможен ввод отрицательного числа
CMP_NEG:
	cmp		cx, 3
	jnz     CMP_DIG
	cmp     al, '-'
	jnz     CMP_DIG
	; Число отрицательно
	mov		dh, 1
	jmp		short READ_CHR
CMP_DIG:
	cmp		al, '0'
	jge		CMP_DIG_9
	jmp		EXIT
CMP_DIG_9:
	cmp		al, '9'
	jbe		DIGTONUM
	jmp		EXIT
DIGTONUM:
	; Иначе преобразуем цифру в число
	mov		bl, al
	sub		bl, '0';
	xor		ah, ah
	mov		al, 10
	mul		dl
	mov		dl, al
	add		dl, bl
READ_NEXT_CHR:
	loop	READ_CHR
SAVE_ELEMENT:
	cmp		dh, 0
	jz		SAVE_ELEMENT_
	neg		dl
SAVE_ELEMENT_:
	mov		a[si], dl
	; Переход к вводу следующего элемента
	inc		si
	dec		bh
	cmp		bh, 0
	jnz		READ_ELEMENT
	
READ_N:	
	; Ввод числа N [1;9]
	; Считывание символа с клавиатуры, al - код введёного символа
	mov		ah, 01h
	int		21h
	; Проверка введённого символа
	; Проверка на ввод пробела
	cmp		al, ' '
	je		READ_N
	; Проверяем, является ли символ числом, если нет, то выходим из программы
	cmp		al, '0'
	jg		CMP_9
	jmp		EXIT
CMP_9:	
	cmp		al, '9'
	jbe		OK_N
	jmp		EXIT
OK_N:
	sub		al, '0'
	
	; Суммирование элементов массива, позиции которых кратны введённому N
	xor		ah, ah
	mov		si, ax			; Индекс элементов массива
	dec		si
	xor		dh, dh
	mov		dl, al
	xor		bx, bx
SUM_N:
	mov		al, byte ptr a[si]
	cbw
	add		bx, ax
	add		si, dx
	cmp		si, a_size
	jl		SUM_N
	mov		di, bx
	
	; Вывод результата
	mov		ah, 03h
	xor		bh, bh
	int		10h
	mov		dl, 6
	inc		dh
	mov		bp, dx
	mov		ah, 02h
	mov		bx, bp
	mov		dh, bh
	mov		dl, 1
	xor		bh, bh
	int		10h
	; Вывод минуса, если число отрицательно
	cmp		di, 0
	jge		OUT_DIG
	neg		di
	mov		ah, 02h
	mov		dl, '-'
	int		21h
	
	; Вывод числа
OUT_DIG:
	finit
	fstcw	c
	or		c, 0000110000000000b
	fldcw	c
	mov		c, di
	fild	c
	mov		c, 10
	fidiv	c
	frndint
	fistp	c
	mov		cx, di
	mov		di, c
MOD_10:
	cmp 	cx, 10
	jl		OUT_DIG__
	sub		cx, 10
	jmp		MOD_10
OUT_DIG__:		
	mov		ah, 02h
	mov		bx, bp
	mov		dh, bh
	mov		dl, bl
	xor		bh, bh
	int		10h
	mov		ah, 02h
	mov		dl, cl
	add		dl, '0'
	int		21h	
	dec		bp
	cmp		di, 0
	jnz		OUT_DIG

EXIT:	
	; Завершение программы
	mov		ax, 4c00h
	int		21h	

C_S ends
end START