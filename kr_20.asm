;==============================;
;                              ;
;	Контрольная работа         ;
;	Вариант 20                 ;
;                              ;
;==============================;


.model	tiny


;============== STACK ==============;
s_s segment stack

				db		0ffh dup(?)					; Резервирование 256 байт.

s_s ends


;============== DATA ==============;
d_s segment

	arr_size 	equ		7							; Размер массива
	arr			db		arr_size dup(?)				; Исходный массив
	msg_inp_arr db		'Input array:',0dh,0ah,'$'	; Приглашение на ввод массива

d_s ends


;============== CODE ==============;
c_s segment
assume cs:c_s, ss:s_s, ds:d_s, es:d_s
start:

	; Инициализация сегмента данных
	mov		ax, d_s
	mov		ds, ax
	
	; Вывод приглашения на ввод массива
	mov		ah, 09h
	mov		dx, offset arr
	int		21h
	
	; Ввод массива с клавиатуры
	mov		cx, arr_size						; Коичество вводимых элементов
	xor		si, si								; Индекс элементов массива
NEXT_ELEMENT:
	
	nop
	; Переход к вводу следующего элемента
	loop	NEXT_ELEMENT						
	
	
	; Завершение программы
	mov		ax, 4c00h
	int		21h
	
c_s ends
end start