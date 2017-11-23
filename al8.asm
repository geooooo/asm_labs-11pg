; Лабораторная работа 8


S_S segment stack
	db		100h dup(?)		; Резервируем память
S_S ends


D_S segment
	a			dw		3h		; Аргумент, передаваемый по значению
	b			dw		3h		; Аргумент, передаваемый по ссылке
	res_fak_val	dw		1		; Результат вычисления факториала с передачей аргумента по значению
	res_fak_ref	dw		?		; Результат вычисления факториала с передачей аргумента по ссылке
D_S ends


C_S segment
assume cs:C_S, ss:S_S, ds:D_S, es:D_S
start:

	; Инициализация сегментных регистров
	mov		ax, D_S
	mov		ds, ax
	
	; Вычисление факториала числа с передачей аргумента по значению
	mov		ax, a
	push	ax
	call	fak_val
	
	; Вычисление факториала числа с передачей аргумента по ссылке
	mov		ax, offset b
	push	ax
	call	fak_ref
	
	; Завершение программы
	mov		ax, 4c00h
	int		21h
	
	
	
	; Вычисление факторила (рекурсивный вариант)
	; Входные параметры в стеке:
	; 	dw - число, факториал которого необходимо вычислить
	; Результат:
	; 	dw res_fak_val - факториал числа
	fak_val proc
		
		mov		bp, sp
		mov		bx, [bp+2]	; Число, факториал которого вычисляется
		
		cmp		bx, 1
		jz		FAK_END		; Есил bx = 1, остановить рекурсию
		
		mov		ax, res_fak_val
		mul		bx
		mov		res_fak_val, ax
		dec		bx
		push	bx
		call	fak_val
	
	FAK_END:
		ret		2
		
	fak_val endp
	
	
	
	; Вычисление факторила (через цикл)
	; Входные параметры в стеке:
	; 	dw -  ссылка на число, факториал которого необходимо вычислить
	; Результат:
	; 	dw res_fak_ref - факториал числа
	fak_ref proc
		
		mov		bp, sp
		mov		bx, [bp+2]		; Получаем ссылку на аргумент из стека
		mov		cx, [bx]		; Количество итераций цикла и число, факториал которого вычисляется
		mov		ax, 1			; Результат вычислений
		
fak:	
		mul		cx
		loop	fak
		
		mov		res_fak_ref, ax
		ret		
		
	fak_ref endp
	
	

C_S ends
end start