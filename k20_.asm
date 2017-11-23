;==============================;
;                              ;
;	Контрольная работа         ;
;	Вариант 20                 ;
;                              ;
;==============================;


.model	tiny


;============== STACK ==============;
s_s segment stack

					db		0ffh dup(?)		; Резервирование 256 байт.

s_s ends


;============== DATA ==============;
d_s segment
	
	arr_size 		equ		7											; Размер массива
	arr				db		arr_size dup(?)								; Исходный массив
	msg_inp_arr		db		0dh,0ah,'Input array:',0dh,0ah,'$'			; Приглашение на ввод массива
	msg_err_read	db		0dh,0ah,'Error input element',0dh,0ah,'$'	; Ошибка ввода элемента массива
	msg_res         db      0dh,0ah,'Result = ',0dh,0ah,'$'				; Сообщение о результате

d_s ends


;============== CODE ==============;
c_s segment
assume cs:c_s, ss:s_s, ds:d_s, es:d_s
start:

	jmp		BEGIN

ERROR_READ_ELEMENT:
	; Вывод сообщения об ошибке чтения элемента массива
	mov		ah, 09h
	mov		dx, offset msg_err_read
	int		21h
	jmp		EXIT

BEGIN:
	; Инициализация сегмента данных
	mov		ax, d_s
	mov		ds, ax
	
	; Вывод приглашения на ввод массива
	mov		ah, 09h
	mov		dx, offset msg_inp_arr
	int		21h
	
	; Ввод массива с клавиатуры
	mov		bh, arr_size						; Коичество вводимых элементов
	xor		si, si								; Индекс элементов массива
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
	jmp     short SAVE_ELEMENT
	
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
	jb		ERROR_READ_ELEMENT
	cmp		al, '9'
	ja		ERROR_READ_ELEMENT
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
	mov		arr[si], dl
	; Переход к вводу следующего элемента
	inc		si
	dec		bh
	cmp		bh, 0
	jnz		READ_ELEMENT
	
	; Поиск минимального элемента
	mov		bl, 127				; Минимальный элемент
	xor		si, si				; Индекс элементов массива
	mov		cx, arr_size		; Поиск во всём массиве
FIND_MIN:
	cmp		bl, arr[si]
	jle		FIND_MIN_NEXT
	mov		bl, arr[si]
FIND_MIN_NEXT:
	inc		si
	loop	FIND_MIN
	
	
	; Суммирование всех элементов массива из диапазона [-5;15]
	xor		al, al				; Сумма элементов массива
	xor		si, si				; Индекс элементов массива
	mov		cx, arr_size		; Суммирование элементов всего массива
SUM_NEXT:
	add		al, arr[si]
	inc		si
	loop	SUM_NEXT
	
	; Умножение суммы на минимум
	xor		ah, ah
	imul	bl
	mov		di, ax
	
	; Подсчёт количества цифр в результате
	xor		cx, cx				; Количество цифр в результате
	mov		dl, 10
COUNT_DIG:
	inc		cx
	div		dl
	xor		ah, ah
	cmp		al, 0
	jnz		COUNT_DIG
	mov		si, cx
	
	; Вывод сообщения о результате
	mov		ah, 09h
	mov		dx, offset msg_res
	int		21h	
	
	; Вывод результата
	; Вывод минуса, если число отрицательно
	cmp		di, 0
	jge		OUT_DIG_
	neg		di
	mov		ah, 02h
	mov		dl, '-'
	int		21h
	
OUT_DIG_:
	
	; Вывод числа
	mov		cx, si
	mov		ax, 1
	mov		si, 10
STEP_10:
	mul		si
	loop 	STEP_10
	mov		bx, ax
	mov		cx, di
OUT_DIG:
	mov		ax, cx
	div		ebx
	mov		cx, dx
	mov		dl, 10
	mov		ax, bx
	div		dl
	mov		bx, ax
	mov		ah, 02h
	mov		dl, cl
	add		dl, '0'
	;int		21h
	cmp		cx, 0
	jnz		OUT_DIG

EXIT:
	; Завершение программы
	mov		ax, 4c00h
	int		21h
	
c_s ends
end start