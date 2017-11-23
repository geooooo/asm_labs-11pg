S_S segment stack
	db		50 dup(?)	; память для стека
S_S ends



D_S segment
	x	dw	3		; факториал чего вычисляем
	r	dw	?		; сюда поместим результат
D_S ends



C_S segment
assume cs:C_S, ss:S_S, ds:D_S
start:

	mov		ax, D_S
	mov		ds, ax

	; вычисление факториала числа
	mov		cx, x		; количество итераций цикла и число, факториал которого вычисляется
	mov		ax, 1	

	faktorial:	
	mul		cx
	loop	faktorial
	
	; запись результата
	mov		r, ax	

	; выход
	mov		ax, 4c00h
	int		21h

C_S ends
end start