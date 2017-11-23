; Написать программу на языке Ассемблера,
; которая позволяет ввести с клавиатуры массив из 8 символов,
; составить и вывести на экран слово, состоящее из минимального
; и максимального символов исходного массива.


s_s segment stack
	db		100h dup (?)						; Резервируем память
s_s ends


d_s segment
	a_len	equ		8							; Длинна массива
	a		db		a_len+1,0,a_len+1 dup (?)	; Исходный массив
	endl	db		0ah,0dh,'$'					; Перевод строки
	res		db		'**$'						; Результирующая строка
d_s ends


c_s segment
assume cs:c_s, ss:s_s, ds:d_s, es:d_s
start:

	; Инициализация сегментных регистров
	mov		ax, d_s
	mov		ds, ax
	mov		es, ax
	
	; Ввод массива
	mov		ah,	0ah
	mov		dx, offset a
	int		21h
	
	; Поиск минимального и максимального символов строки
	xor		al, al				; al - максимальный символ
	mov		ah, 255				; ah - минимальный символ
	mov		si, 2				; Индекс символа строки
	xor		ch, ch
	mov		cl,	byte ptr a+1	; Количество символов в строке и число повторений цикла
FIND_SYM:
	; Проверка на новый меньший символ
	cmp		ah, a[si]
	jbe		CMP_MAX				; Если ah <= a[si]
	; Иначе сохраняем новый минимум
	mov		ah, a[si]
	
CMP_MAX:
	; Проверка на новый максимальный символ
	cmp		al, a[si]
	jae		FIND_SYM_NEXT		; Если ah >= a[si]
	; Иначе сохраняем новый максимум
	mov		al, a[si]

FIND_SYM_NEXT:	
	inc		si					; Переходи к следующему символу
	loop	FIND_SYM
	
	; Запись найденных символов в строку
	mov		res, ah				; Минимум
	mov		res+1, al			; Максимум
	
	; Вывод перевода строки
	mov		ah, 09h
	mov		dx, offset endl
	int		21h	
	
	; Вывод результата
	mov		ah, 09h
	mov		dx, offset res
	int		21h	
	
	; Завершение работы
	mov		ax, 4c00h
	int		21h
	
c_s ends
end start
