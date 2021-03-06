;****************************************;
; Пример работы с одномерными массивами: ;
;										 ;
; ввод и вывод массива					 ;
; 										 ;
;****************************************;



.model small



;================================ STACK =========================================
S_S segment stack 'stack'

	db 0ffh dup(?)							; Резервируем 255 байт
	
S_S ends



;================================ DATA =========================================
D_S segment memory 'data'

	ARR_SIZE 	equ		5								; Константа для хранения длинны массива
	arr			db		ARR_SIZE dup(?)	    			; Массив для работы
	msg_input   db		'Input the array:',0dh,0ah,'$'	; Строка приглашения к вводу
	
D_S ends



;================================ CODE =========================================
C_S segment public 'code'
assume cs:C_S, ss:S_S, ds:D_S, es:D_S
start:

	; Инициализация регистра сегмента данных
	mov		ax, D_S
	mov		ds, ax
	
	; Переход в текстовый режим 80x25 и очистка экрана
	mov		ax, 0003h
	int		10h
	
	; Вывод приглашения к вводу
	mov		ah, 09h
	mov		dx, offset msg_input
	int		21h
		
	; Ввод массива поэлементно
	mov		cx, ARR_SIZE			; Количество элементов для считывния
	xor		si, si 					; Индекс первого элемента массива  = 0
	mov		dh, 1					; Номер строки в консоли для ввода элементов массива
	xor		dl, dl					; Номер столбца в консоли для ввода первого элемета массива = 0
INPUT_ARR:
	mov		ah, 01h					; Будем заносить в массив код любого символа с клавиатуры, al код введённого символа
	int		21h
	
	mov		arr[si], al				; Начало массива arr + индекс элемента di = адрес элемента массива
	inc		si						; Индекс следующего элемента
	
	add		dl, 2					; Смещаем положение курсора по столбцам
	mov     ah, 02h					; Установка позиции курсора для создания отступа между введёнными символами
	int		10h
	loop	INPUT_ARR

	; Вывод массива поэлементно
	mov		cx, ARR_SIZE			; Количество элеметов для вывода
	xor		si, si					; Индекс первого элемента массива
	mov		dh, 2					; Номер строки в консоли для вывода элементов массива
	xor		dl, dl					; Номер столбца в консоли для вывода первого элемета массива = 0
OUTPUT_ARR:		
	mov     ah, 02h					; Установка позиции курсора для создания отступа между выведёнными символами
	int		10h
	add		dl, 2					; Смещаем положение курсора по столбцам
	
	mov		ah, 0eh					; Вывод элемета массива, bh = 0 (видеостраница)
	mov		al, arr[si]				; Начало массива arr + индекс элемента di = адрес элемента массива
	int		10h
	
	inc		si						; Индекс следующего элемента
	loop	OUTPUT_ARR
	
	; Завершение работы
	mov		ax, 4c00h
	int		21h
	
C_S ends
end start