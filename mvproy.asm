modoVideo macro
 	mov ax,13h
  	int 10h
  	mov ax, 0A000h
  	mov ds, ax  ; DS = A000h (memoria de graficos).

  	mov ah,01h
  	mov ch,04h
  	mov cl,04h
  	int 10h

endm 

modoLectura macro
	MOV dx,@data 
	MOV ds,dx 
	 ; regresar a modo texto
  	mov ax,0003h
	int 10h
endm

irLectura macro
	push ds
	MOV dx,@data
	MOV ds,dx
endm

irVideo macro
	pop ds
endm


esperarTecla macro
  ; esperar por tecla
  push ax
  mov ah,10h
  int 16h
  pop ax
endm

escribirCaracter macro caracter
	push ax
	push bx
	push cx

	irLectura
	mov ah,0ah
	mov al,caracter
	irVideo
	mov bl,0Fh
	xor cx,cx
	inc cx
	int 10h

	pop ax
	pop bx
	pop cx
endm

printOrdenamiento macro numeroascii
	LOCAL INIT,FIN
	
	push ax
	push si

	irLectura
	xor ax,ax
	mov al,numeroascii
	convertirString num
	xor si,si
	INIT:
	escribirCaracter num[si]
	inc si
	cmp num[si],'$'
	je FIN
	call aumentarCursor
	jmp INIT
	FIN:

	irVideo
	pop si
	pop ax
endm

printvideo macro buffervideo
LOCAL INICIO,FIN
	push si
	push cx
	irLectura
	xor si,si
	INICIO:
	escribirCaracter buffervideo[si]
	inc si
	cmp buffervideo[si],'$'
	je FIN
	call aumentarCursor
	jmp INICIO

	FIN:
	irVideo
	pop cx
	pop si
endm


;PINTA EL TABLERO EN BASE A LOS ARREGLOS CREADOS
pintarTablero macro tablero
LOCAL INICIO,PINTARPIXELB,PINTARPIXELR,PINTARPIXELV,PINTARPIXELAM,PINTARPIXELA,FIN
	;xor dx,dx     ; contador de columnas y color
  	;xor di,di
  	;mov dx,0Fh
  	;mov [di], dx ; poner color en A000:DI
  	;esperarTecla
  	;push ds
  	irLectura
	xor di,di
	xor dx,dx
	INICIO:
		cmp di,0F7F9h		;FIN DE pantalla
		je FIN
		cmp tablero[di],'1'
		je PINTARPIXELB
		;cmp tablero[di],'2'
		;je PINTARPIXELV
		;cmp tablero[di],'3'
		;je PINTARPIXELAM
		;cmp tablero[di],'4'
		;je PINTARPIXELA
		;cmp tablero[di],'5'
		;je PINTARPIXELR
		inc di
		jmp INICIO

	PINTARPIXELB:
		irVideo
		mov dx,0Fh
		mov [di],dx	
		inc di
		irLectura
		jmp INICIO

	PINTARPIXELV:
		irVideo
		mov dx,02h
		mov [di],dx	
		inc di
		irLectura
		jmp INICIO

	PINTARPIXELAM:
		irVideo
		mov dx,0Eh
		mov [di],dx	
		inc di
		irLectura
		jmp INICIO

	PINTARPIXELA:
		irVideo
		mov dx,01h
		mov [di],dx	
		inc di
		irLectura
		jmp INICIO

	PINTARPIXELR:
		irVideo
		mov dx,04h
		mov [di],dx	
		inc di
		irLectura
		jmp INICIO



	FIN:
	irVideo
	;printOrdenamiento ordenamiento[0]
endm




crearBarras macro posib,posfb,altura,index
LOCAL INICIO,FIN
	push si
	push ax
	push bx
	push dx
	push di
	;IMRPIMIR EL NUMERO CORRESPONDIENTE
	;printOrdenamiento ordenamiento[index]

	;ACTIVAR MODO LECTURA
	irLectura
	xor dx,dx

	mov ax,posib
	mov bx,posfb
	mov dl,altura
	xor di,di
	mov si,ax

;POSICIONAR EN PUNTO PRINCIPAL DE ABAJO 
;AGREGAR NUMERO RESPECTIVO DEL ARREGLO "ORDENAMIENTO"
	;poscursornums 
	INICIO:
;PINTAR DESDE POSICION INICIAL HASTA POSICION FINAL
		cmp si,bx
		je AUMENTARALTURA
		;COMPARACIONES
		mov atab[si],'1'
		;cblanco ordenamiento[index]
		;cmp dx,01h
		;je R
		;mov atab[si],'2'
		;cverde ordenamiento[index]
		;cmp dx,01h
		;je R
		;mov atab[si],'3'
		;camarillo ordenamiento[index]
		;cmp dx,01h
		;je R
		;mov atab[si],'4'
		;cazul ordenamiento[index]
		;cmp dx,01h
		;je R
		;mov atab[si],'5'

		R:
			inc si
			;REPETIR N VECES
			jmp INICIO

	AUMENTARALTURA:
		;COMPARAR SI YA SE LLEGO A LA ALTURA DESEADA
		cmp di,dx
		je FIN
		;INCREMENTAR LA ALTURA
		inc di
		sub ax,140h
		sub bx,140h
		mov si,ax
		jmp INICIO

	FIN:
		irVideo
		pop di
		pop dx
		pop bx
		pop ax
		pop si
endm

poscursornums macro
push ax
push dx
push bx
xor bx,bx

mov ah,02h
mov dh,17h ;LINEA -> 17h = 24 en decimal (linea mas abajo)
mov al,02h ;COLUMNA
mov dl,al  ;COLUMNA
int 10h

pop bx
pop dx
pop ax
endm



cazul macro numero
;ENTRE 21 Y 40
LOCAL ESMAYOR,ESMENOR,FIN,S
push AX
push BX
xor dx,dx
mov al,numero
mov bl,14h		;20
sub al,bl 		;numero - 20
jc S 	;SI SE ACTIVA EL CARRY NO CUMPLE EL NUMERO PORQUE ES MENOR QUE EL NUMERO MENOR
	ESMAYOR:
			mov al,29h
			mov bl,numero
			sub al,bl ;41 - numero
			jc FIN
			;Accion a realizarse
			mov dx,01h
			pop BX
			pop AX
			jmp FIN		
	
	S:
		pop BX
		pop AX

	FIN:
		
endm

camarillo macro numero
;ENTRE 41 Y 60
LOCAL ESMAYOR,ESMENOR,FIN,S
push AX
push BX
xor dx,dx
mov al,numero
mov bl,28h		;40
sub al,bl 		;numero - 40
jc S 	;SI SE ACTIVA EL CARRY NO CUMPLE EL NUMERO PORQUE ES MENOR QUE EL NUMERO MENOR
	ESMAYOR:
			mov al,3dh
			mov bl,numero
			sub al,bl ;61 - numero
			jc FIN
			;Accion a realizarse
			mov dx,01h
			pop BX
			pop AX
			jmp FIN		
	
	S:
		pop BX
		pop AX

	FIN:
endm

cverde macro numero
;ENTRE 61 Y 80
LOCAL ESMAYOR,ESMENOR,FIN,S
push AX
push BX
xor dx,dx
mov al,numero
mov bl,3Ch		;60
sub al,bl 		;numero - 60
jc S 	;SI SE ACTIVA EL CARRY NO CUMPLE EL NUMERO PORQUE ES MENOR QUE EL NUMERO MENOR
	ESMAYOR:
			mov al,51h
			mov bl,numero
			sub al,bl ;81 - numero
			jc FIN
			;Accion a realizarse
			mov dx,01h
			pop BX
			pop AX
			jmp FIN		
	S:
		pop BX
		pop AX

	FIN:
endm

cblanco macro numero
;ENTRE 81 Y 99
LOCAL ESMAYOR,ESMENOR,FIN,S
push AX
push BX
xor dx,dx
mov al,numero
mov bl,50h		;80
sub al,bl 		;numero - 80
jc S 	;SI SE ACTIVA EL CARRY NO CUMPLE EL NUMERO PORQUE ES MENOR QUE EL NUMERO MENOR
	ESMAYOR:
			mov al,64h
			mov bl,numero
			sub al,bl ;100 - numero
			jc FIN
			;Accion a realizarse
			mov dx,01h
			pop BX
			pop AX
			jmp FIN		
	
	S:
		pop BX
		pop AX
	FIN:
endm

