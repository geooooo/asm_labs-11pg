;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1) Программа выводит приглашение на ввод
; 2) Считывает строку
; 3) Выводит введённую строку
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



assume ds:d_s, es:d_s, ss:s_s, cs:c_s



s_s segment stack 'stack'
s_s ends



d_s segment 'data'

	msg		db		"Input string: $"
	mystr	db		30, 0, 30 dup(?)

d_s ends



c_s segment 'code'
start:
	
	; Подготовка регистра ds и es
	mov			ax, d_s
	mov			ds, ax
	mov			es, ax
	
	; Очистка экрана
	mov			ax, 0003h
	int			10h	
	
	; Вывод приглашения на ввод
	mov			ah, 09h
	mov			dx,	offset msg
	int			21h
	
	; Ввод строки
	mov			ah, 0ah
	mov			dx, offset mystr
	int			21h
	
	; Замена символа "CR" на "$" в введённой строке
	cld
	mov			al, 0dh
	mov			di, offset mystr+2
	mov			cl, mystr[1]
	xor			ch, ch
	repne		scasb
	mov			byte ptr [di],  '$'	
	
	; Очистка экрана
	mov			ax, 0003h
	int			10h	
	
	; Вывод считанной строки
	mov			ah, 09h
	mov			dx, offset mystr+2
	int			21h
	
	; Завершение программы
	mov			ax, 4c00h
	int			21h
	
c_s ends
end start