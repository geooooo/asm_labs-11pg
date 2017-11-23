;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;    Лабораторная работа №2      ;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



.model	huge



s_s segment stack

	reserve_memory		db		20 dup(?)
	
s_s ends



d_s1 segment private
	
	var1				db		1111b			; Просто однобайтовое число
	
d_s1 ends



d_s2 segment private
	
	addr_cs1			dd		c_s1, 0			; Адрес перехода на первый сегмент кода
	
d_s2 ends



d_s3 segment private
	
	var2				db		11110000b		; Ещё простое однобайтовое число
	
d_s3 ends



c_s1 segment private
	
	;
	
c_s1 ends



c_s2 segment private
	
	;
	
c_s2 ends



c_s3 segment private
start:
	
	nop
	
c_s3 ends
end start