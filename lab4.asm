;-----------------------------------------
;--ЛР№4 Дослідження стеку-----------------
;----------------Група №5:----------------
;--Яремчук Д.В.--Митєв А.Ю.--Шевчук Д.Д.--		 		  
;-----------------------------------------

IDEAL			; Директива - тип Асемблера tasm 
MODEL SMALL		; Директива - тип моделі пам’яті 
STACK 1280		; Директива - розмір стеку 

DATASEG
; Оголошуємо двовимірний масив 8х16
arr_stack dw 2E2Eh, 2980, 4753, 3213, 4123, 2525, 1542, 1097, 3742, 9822, 9919, 1207, 6894, 3253, 4484, 6895
		  dw 1252, 9997, 7652, 6484, 1945, 8976, 8057, 1358, 1847, 9036, 9378, 9343, 2420, 4061, 7649, 6136 
		  dw 5050, 5277, 6871, 2960, 2347, 7399, 6785, 7781, 7429, 3930, 7071, 3614 ,3467, 2480, 2320, 3831
		  dw 6403, 5487, 2403, 6256, 3116, 3665, 8095, 2063, 1106, 3411, 6548, 8012, 7435, 6991, 3989, 1767
		  dw 3563, 9981, 2680, 2050, 1746, 1772, 1595, 8867, 9895, 7911, 1040, 3476, 7439, 1687, 3929, 7082
		  dw 3508, 7443, 1217, 7494, 9166, 3360, 1422, 5095, 6801, 7721, 2914, 6855, 5804, 5318, 4323, 3693
		  dw 4642, 7697, 2237, 4021, 2765, 7683, 6606, 3106, 8526, 6357, 7379, 7471, 1080, 7760, 3213, 4575
		  dw 3407, 4557, 7205, 0532, 7303, 2111, 4552, 7662, 9629, 5718, 7825, 6423, 1399, 7882, 4021, 1438

exCode db 0

CODESEG

copyArray:
	mov cx, 128   ; лічильник циклу - кількість елементів масиву
	xor si, si    ; очищуємо регістр si
	a1:
	mov ax, [si]  ; переміщуємо число з масиву в регістр ax
	mov [word di], ax ; переміщуємо число з регістру ax в необхідну ділянку
	add di, 2  ; збільшуємо регістр для коректної роботи
	add si, 2  ; збільшуємо регістр для коректної роботи
	loop a1
ret

Start:
mov	ax, @data	  ; ax <- @data
mov	ds, ax		  ; ds <- ax
mov	es, ax		

xor di, 100h    ; початок ділянки для копій масиву
mov cx, 4       ; лічильник циклу - кількість копій масиву     
do_copy:
mov dx, cx 		; зберігаємо лічильник в регістрі dx
call copyArray   ; викликаємо функцію копіювання масиву
mov cx, dx      ; повертаємо значення лічильника
loop do_copy

lea si, [arr_stack]   ; переміщуємо адресу початку масиву в регістр si
mov ax, 128		; кількість елементів масиву
mov cx, ax		; лічильник циклу - кількість елементів масиву
stack1:
mov ax, [si]	; переміщуємо число з масиву в регістр ax
push ax			; додаємо число в стек
add si, 2		; збільшуємо регістр для коректної роботи
loop stack1

mov bp, sp     ; регістр bp - адреса вершини стеку
add bp, 40h    ; за варіантом (5) отримуємо необхідну адресу

mov [word bp], 0909h  ; переміщуємо дані в стек
add bp, 02h
mov [word bp], 0320h	; переміщуємо дані в стек
add bp, 02h
mov [word bp], 1021h	; переміщуємо дані в стек
add bp, 02h
mov [word bp], 0320h	; переміщуємо дані в стек
add bp, 02h
mov [word bp], 1129h	; переміщуємо дані в стек
add bp, 02h
mov [word bp], 0220h	; переміщуємо дані в стек

mov ah, 048h ; код переривання
mov bx, 02h ; розмір нової ділянки у параграфі
int 21h  ; виклик функції

mov es,ax ;Ініціалізація сегментного регістру
mov cx, 8 ;Визначення розміру нової ділянки масиву множенням
mov ax, 16
mul cx
mov cx, ax ;підготовка циклу
xor di, di
lea si, [arr_stack]

mem1:
mov dx, [si] ;нульовий елемент в регістр
mov [es:di], dx ; запис до нової ділянки
add si, 2 ; перехід на новий елемент масиву
add di, 2
loop mem1

mov ah, 049h  ; код переривання для очищення ділянки
int 21h    ; виклик функції

; Exit:
mov ah,04Ch
mov al,[exCode]   ; отримання коду виходу
int 21h           ; виклик функції 04ch  
;----------
END Start
;----------
