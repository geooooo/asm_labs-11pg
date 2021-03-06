; Контрольная работа. Задача №1.
; Ввод массива целых чисел.
; Поиск и вывод элементов массива,
; которые одновременно отрицательны и нечётны
; Допустимый диапазон вводимых целых чисел: -9..9


S_S segment stack
			db		256 dup (?)		; Резервирование памяти
S_S ends


D_S segment
	a_size	equ		5				; Размер массива
	a		db		a_size dup (?)	; Исходный массив
	
	; Сообщение на ввод массива
	msg_array_inp	db		'Input array:$'
D_S ends


C_S segment
assume ss:S_S, cs:C_S, ds:D_S, es:D_S
start:

	; Инициализация сегментных регистров
	mov		ax, D_S
	mov		ds, ax
	mov		es, ax
	
	; Вывод сообщения о вводе массива
	mov		ah, 09h
	mov		dx, offset msg_array_inp
	int		21h
	
	; Ввод массива целых чисел
	mov		cx, a_size		; Количество вводимых чисел и повторов цикла
	xor		si, si			; Обнуляем индекс элементов массива
NEXT_NUM:
	mov		dl, 1			; Знак очередного числа: 1(+), -1(-)
	
NEXT_CHAR:
	; Чтение символа с клавиатуры, al - код символа
	mov		ah, 01h
	int		21h
	
	; Проверка на ввод пробела ' '
	cmp		al, ' '
	jnz     CMP_NEG			; Если введён не пробел
	jmp		NEXT_CHAR		; Если пробел
	
CMP_NEG:
	; Проверка на ввод минуса '-'
	cmp		al, '-'
	jnz		CMP_NUM			; Если al неравен '-'
	; Если минус '-'
	mov		dl, -1			; Значит число будет отрицательно
	jmp		NEXT_CHAR
	
CMP_NUM:
	; Проверка на ввод цифры
	cmp		al, '0'
	jb		ERROR_CHAR		; Если код введённого символа < '0'
	cmp		al, '9'
	jg		ERROR_CHAR		; Если код введённого символа > '9'
	; Введена цифра
	jmp		SAVE_NUM
	
ERROR_CHAR:	
	; Ошибка ввода
	jmp		EXIT
	
SAVE_NUM:
	; Во всех остальных случаях преобразуем символ в число и заносим в массив
	sub		al, '0'			; Преобразуем символ в число
	xor		ah, ah
	imul	dl				; Устанавливаем знак числа ax*bl
	mov		a[si], al		; Заносим число в массив
	
	inc		si				; Переходим к следующему элементу
	loop	NEXT_NUM
	
	; Вывод перевода строки
	mov		ah, 02h
	mov		dl, 0ah
	int		21h
	mov		ah, 02h
	mov		dl, 0dh
	int		21h
	
	; Поиск и вывод элементов массива,
	; которые одновременно отрицательны и нечётны
	mov		cx, a_size		; Количество чисел в массиве
	xor		si, si			; Обнуляем индекс элементов массива
FIND_NUM:
	mov		bl, a[si]		; Считываем текущий элемент массива
	
	; Проверка на отрицательность числа
	cmp		bl, 0
	jge		FIND_NUM_NEXT	; Если >= 0
	; Проверка на нечётность
	test	bl, 1
	jz		FIND_NUM_NEXT	; Если нулевой бит равен 0, число чётное
	
	; Если число отрицательно и нечётно, выводим его
	; Вывод знака минус
	mov		ah, 02h
	mov		dl, '-'
	int		21h
	; Преобразуем число в символ
	neg		bl				; Преобразуем в положительное
	add		bl, '0'			; Преобразуем в символ
	; Вывод числа
	mov		ah, 02h
	mov		dl, bl
	int		21h
	; Вывод пробела ' '
	mov		ah, 02h
	mov		dl, ' '
	int		21h
	
FIND_NUM_NEXT:
	inc		si				; Переходим к следующему элементу
	loop	FIND_NUM
	
EXIT:
	; Завершение программы
	mov		ax, 4c00h
	int		21h

C_S ends
end start