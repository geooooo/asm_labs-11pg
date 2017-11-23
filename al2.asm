;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;    Лабораторная работа №2      ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



.model	large
assume ss:s_s



;===============================================
;                 STACK
;===============================================

s_s segment stack

	reserve_memory		db		20 dup(?)
	
s_s ends



;===============================================
;                 DATA
;===============================================

d_s1 segment private
	
	var1				db		1111b			; Просто однобайтовое число
	
d_s1 ends



d_s2 segment private
	
	addr_cs1				dd		c1		 	; Адрес перехода на первый сегмент кода
	
d_s2 ends



d_s3 segment private
	
	var2				db		11110000b		; Ещё простое однобайтовое число
	
d_s3 ends



;===============================================
;                 CODE
;===============================================

c_s2 segment private
assume cs:c_s2, es:d_s3, es:c_s3
c2:
	
	; Получение 5 бита числа в CF
	
	clc
	mov		ax, d_s3
	mov		es, ax
	mov		bh, es:var2
	rol		bh, 3
	
	; Переход к завершению программы
	
	mov		ax, c_s3
	mov		es, ax
	jmp		far ptr es:exit_success
	
c_s2 ends



c_s1 segment private
assume cs:c_s1, ds:d_s1, es:c_s2
c1:

	;Получение 3 бита в CF
	
	clc
	mov		bl, var1
	ror		bl, 4	
	
	; Переход во 2 сегмент кода
	mov		ax, c_s2
	mov		es, ax
	jmp		far ptr es:c2	
	
c_s1 ends



c_s3 segment private
assume cs:c_s3, ds:d_s1, es:d_s2, es:d_s3
start:
	
	; Загрузка в ds первого сегмента данных
	
	mov		ax, d_s1
	mov		ds, ax
	
	; Умножение на 2
	
	shl		var1, 1
	
	; Загрузка в es третьего сегмента данных
	
	mov		ax, d_s3
	mov		es, ax
	
	;Деление на 4
	
	shr		es:var2, 2
	
	; Переход в первый сегмент кода
	
	mov		ax, d_s2
	mov		es, ax
	jmp		dword ptr es:[addr_cs1]
	
exit_success:

	; Завершение работы
	
	mov		ax, 4c00h
	int		21h
	
c_s3 ends
end start