;===========================GENERALES=======================

print macro cadena 
LOCAL ETIQUETA 
ETIQUETA: 
	push AX
	MOV ah,09h 
	MOV dx,@data 
	MOV ds,dx 
	MOV dx, offset cadena 
	int 21h
	pop AX 
endm

printChar macro char
mov ah,02h
mov dl,char
int 21h
endm

getChar macro ;ENVIA EL CARACTER INGRESADO A AL
mov ah,01h
int 21h
endm

;Guarda la informacion en un arreglo 
saveData macro buffer
LOCAL INICIO,FIN
	xor si,si
INICIO:
	getChar
	cmp al,0dh
	je FIN
	mov buffer[si],al
	inc si
	jmp INICIO
FIN:
	mov buffer[si],00h
endm

;Busca si el usuario existe(getText-> Texto ingresado; usuarios-> Usuarios existentes)
;EN SI QUEDA GUARDADA GUARDADA LA POSICION DE "," ANTERIOR A LA CONTRASENA
buscarUsuario macro getText,usuarios
LOCAL INICIO,FIN,FINN,FINE,CF,EN,BN
push di
xor si,si
xor di,di
INICIO:
mov al,getText[di]
mov bl,usuarios[si]
cmp al,bl
je CF
jmp BN

CF:
mov al,getText[di+1]
cmp al,00h
je FINE
inc si
cmp usuarios[si],','
je BN
inc di
jmp INICIO

BN:
inc si
mov bl,usuarios[si]
cmp bl,';'
je EN
mov bl,usuarios[si]
cmp bl,'$'
je FINN
jmp BN

EN:
xor di,di
inc si
jmp INICIO



FINE:
print eusuario
buscarContrasena
jmp FIN

FINN:
print nusuario
jmp FIN

FIN:
pop di
endm

buscarContrasena macro
LOCAL INICIO,CF,FINE,FINN,SALIR
push di
xor di,di
inc si
inc si
INICIO:
mov al,valcontrasena[di]
mov bl,datausuarios[si]
cmp al,bl
je CF
jmp FINN

CF:
mov al,datausuarios[si+1]
cmp al,'$'
je FINE
cmp al,';'
je FINE
inc si
inc di
jmp INICIO

FINE:
print econtrasena
jmp ESUSUARIO
FINN:
print ncontrasena
jmp SALIR
SALIR:
pop di
endm

registrarusuario macro usuario,contra,datos
LOCAL INICIO,IC,IN,FIN
buscarEspacio datos
xor di,di
mov al,3Bh
mov datos[si],al
inc si
INICIO:
mov al,usuario[di]
cmp al,00h
je IC
mov datos[si],al
inc si
inc di
jmp INICIO


IC:
xor di,di
mov al,2ch
mov datos[si],al
inc si
jmp IN

IN:
mov al,contra[di]
cmp al,00h
je FIN
mov datos[si],al
inc si
inc di
jmp IN


FIN:
print usreg
getChar
	

endm


;BUSCA UN ESPACIO PARA PODER SEGUIR INSERTANDO ELEMENTOS, COMO INSERTAR NUEVO USUARIO
buscarEspacio macro buffer
LOCAL INICIO,SALIR
xor si,si

INICIO:
cmp buffer[si],'$'
je SALIR
inc si
jmp INICIO

SALIR:
endm

;Busca si hay un usuario repetido
usuarioRepetido macro getText,usuarios
LOCAL INICIO,IC,IN,FIN,EN,BN
push di
xor si,si
xor di,di
INICIO:
mov al,getText[di]
mov bl,usuarios[si]
cmp al,bl
je CF
jmp BN

CF:
mov al,getText[di+1]
cmp al,00h
je FINE
inc si
cmp usuarios[si],','
je BN
inc di
jmp INICIO

BN:
inc si
mov bl,usuarios[si]
cmp bl,';'
je EN
mov bl,usuarios[si]
cmp bl,'$'
je FINN
jmp BN

EN:
xor di,di
inc si
jmp INICIO



FINE:
print usrep
getChar
jmp FIN

FINN:
registrarusuario valusuario,valcontrasena,datausuarios
jmp FIN

FIN:
pop di

endm

compararACMACRO macro ara,arb,res ;ara -> valor ingresado1 , arb -> valor ingresado2 , res -> Accion Si se Cumple
LOCAL INICIAR,COMPROBARFIN,RESPUESTA,FIN
xor si,si
INICIAR:
mov al,ara[si]
mov bl,arb[si]
cmp al,bl
je COMPROBARFIN
pop si
jmp FIN

COMPROBARFIN:
mov al,ara[si+1]
cmp al,'$'
je RESPUESTA
inc si
jmp INICIAR

RESPUESTA:
res

FIN:

endm

compararACETIQUETA macro ara,arb,res ;ara -> valor ingresado1 , arb -> valor ingresado2 , res -> Accion Si se Cumple
LOCAL INICIAR,COMPROBARFIN,RESPUESTA,FIN
xor si,si
INICIAR:
mov al,ara[si]
mov bl,arb[si]
cmp al,bl
je COMPROBARFIN
pop si
jmp FIN

COMPROBARFIN:
mov al,ara[si+1]
cmp al,'$'
je RESPUESTA
inc si
jmp INICIAR

RESPUESTA:
jmp res

FIN:

endm



verificarUsAdmin macro
	mov usadmin[0],'a'
	mov usadmin[1],'d'
	mov usadmin[2],'m'
	mov usadmin[3],'i'
	mov usadmin[4],'n'
	mov usadmin[5],'A'
	mov usadmin[6],'P'
	mov usadmin[7],'$'

	mov conadmin[0],'1'
	mov conadmin[1],'2'
	mov conadmin[2],'3'
	mov conadmin[3],'4'
	mov conadmin[4],'$'

	compararACMACRO usadmin,valusuario,verficarConAdmin
	
	
endm

verficarConAdmin macro

	compararACETIQUETA conadmin,valcontrasena,ESADMIN

endm

mostrarTopPuntos macro
print barras
print topptsTag

INICIO:



print barras

endm

;================MACROS PARA ARCHIVO======================

abrirF macro ruta,handle
mov ah,3dh
mov al,10b
lea dx,ruta
int 21h
mov handle,ax
jc ErrorAbrir
endm

leerF macro numbytes,buffer,handle
mov ah,3fh
mov bx,handle
mov cx,numbytes
lea dx,buffer
int 21h
jc ErrorLeer
endm

crearF macro buffer,handle
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
mov handle,ax
jc ErrorCrear
endm

cerrarF macro handle
mov ah,3eh
mov handle,bx
int 21h
endm

escribirF macro numbytes,buffer,handle
	mov ah, 40h
	mov bx,handle
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc ErrorEscribir
endm


;================================================================

;==============================MACROS PARA NUMEROS=====================
ConvertirAscii macro numero
	LOCAL INICIO,FIN
	PUSH SI
	push bx
	push cx


	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO
	FIN:
		POP cx
		POP BX
		POP SI
endm


ConvertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	push si
	push bx
	push cx

	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov ah,24h
		mov buffer[si],ah
		inc si
	FIN:
		POP cx
		POP BX
		pop SI
endm


cleararray macro arr
	Local INICIO,FIN
	push cx
	push di
	mov cx, SIZEOF arr
		INICIO:
			mov di,cx 
			mov arr[di],'$'
			loop INICIO
			mov arr[0],'$'
		FIN:
			pop di
			pop cx

endm

;======================OPERACIONES LOGICAS
;Se obtiene el numero mayor
esMayor macro numa,numb,accion
LOCAL ESMAYOR,ESMENOR,FIN
push AX
push BX
mov ax,numa
mov bx,numb
sub ax,bx
jc ESMENOR 	;SI SE ACTIVA EL CARRY AX ES MENOR QUE BX

	ESMAYOR:
		pop BX
		pop AX
		jmp FIN
	ESMENOR:
		pop BX
		pop AX
		jmp accion
	FIN:
endm



esMenor macro numa,numb,accion
LOCAL ESMAYOR,ESMENOR,FIN
push AX
push BX
mov ax,numa
mov bx,numb
sub ax,bx
jc ESMENOR 	;SI SE ACTIVA EL CARRY AX ES MENOR QUE BX
jmp ESMAYOR
	ESMENOR:
		pop BX
		pop AX
		jmp FIN

	ESMAYOR:
		pop BX
		pop AX
		jmp accion
	FIN:
	
endm

showString macro buffer,pantalla
	push ax
	push bx
	xor ax,ax
	cleararray pantalla
	mov al,buffer
	ConvertirString pantalla
	print pantalla
	getChar
	pop bx
	pop ax
endm

getlength macro buffer
LOCAL INICIO,FIN
	push si
	push bx

	mov bl,SIZEOF buffer
	xor si,si
	xor cx,cx
	INICIO:
		cmp buffer[si],'$'
		je FIN
		inc si
		cmp buffer[si],bl
		je FIN
		jmp INICIO
	FIN:
		mov cx,si
		pop bx
		pop si

endm

delay macro constante
	LOCAL D1,D2,Fin
	push si
	push di

	mov si,constante

	D1:
		dec si
		jz fin
		mov di,constante
	D2:
		dec di
		jnz D2
		jmp D1

	Fin:
		pop di
		pop si
endm

