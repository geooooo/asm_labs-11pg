;============================;
;							 ;
;	Практическая работа №9	 ;
;	Написание собственного	 ;
;   прерывания               ;
;							 ;
;============================;


.model	tiny


;================ DATA ==================;
d_s segment 	
	
	my_str		db		'My string !'	; Тестовая строка для вывода
	my_str_len	equ		$-my_str		; Длина тестовой строки
	chr			db		'Y'				; Тестовый символ для вывода
	chr_attr 	db		00010100b		; Тестовый атрибут символа
	
d_s ends


;================ STACK ==================;
s_s segment stack
	
			db		0ffh dup(?)		; Резервирование 256 байт
	
s_s ends


;================ CODE ==================;
c_s segment
assume cs:c_s, ss:s_s, ds:d_s, es:d_s
start:

	; Инициализация сегмента данных
	mov		ax, d_s
	mov		ds, ax
	
	; Установка вектора нового прерывания
	mov		ah, 25h
	mov		al, 99h
	mov		bx, c_s
	mov		ds, bx
	mov		dx, offset my_int_99h
	int		21h
	mov		bx, d_s
	mov		ds, bx
	
	; Тестирование нового прерывания
	; Тестовый вывод символа
	mov		ah, 00h
	mov		al, chr
	mov		bl, chr_attr
	int		99h
	; Тестовый вывод строки
	mov		ah, 01h
	mov		bl, chr_attr
	mov		dx, d_s
	mov		es, dx
	mov		dl, 5
	mov		dh, 5
	mov		bp, offset my_str
	mov		cx, my_str_len
	int		99h
	
	; Завершение программы
	mov		ax, 4c00h
	int		21h
	
	
	
	
	
	; Вывод строки или символа
	; ah - номер подфункции:
	; 	00h - вывод символа
	;		al    - код символа
	;	01h - вывод строки
	;		es:bp  - адрес строки в памяти;
	;		cx     - длина строки
	;		dh, dl - строка и столбец, начиная с которых будет вывод строки
	; bl - атрибут символа
	my_int_99h proc
		
		; Если 0 - подфункция вывода символа
		cmp		ah, 0
		jz      OUT_CHAR
		; Если 1 - подфункция вывода строки
		cmp     ah, 1
		jz      OUT_STRING	
		; Иначе неизвестная подфункция
		jmp		EXIT
		
	OUT_CHAR:	
		; Вывод символа
		mov		ah, 09h
		xor		bh, bh
		mov		cx, 1
		int		10h
		jmp     EXIT
		
	OUT_STRING:
		; Вывод строки
		mov		ah, 13h
		xor		al, al
		int		10h		
		
	EXIT:
		iret
		
	my_int_99h endp

c_s ends
end start