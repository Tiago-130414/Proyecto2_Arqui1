;///////////////////////////////// macro que recibe una cadena y la imprime 16 bits
imprimir MACRO string
    MOV ah, 09h
    LEA dx, string                 
    INT 21h
ENDM  

;///////////////////////////////// macro que imprime un caracter
imp MACRO string
    mov dx,0d
    mov dl, string                 
    mov ah,02h
    int 21h 
endm

;///////////////////////////////// imprime un numero de 16 bits
imprimir_numeroAUX MACRO num_imp   
    mov ah,02h
    mov dx,num_imp
    add dx,30h
    int 21h
ENDM

;///////////////////////////////// imprime un numero de 8 bits
imprimir_numero MACRO num_imp   
    mov ah,02h
    mov dl,num_imp
    add dl,30h
    int 21h
ENDM

;///////////////////////////////// macro que imprime un salto de linea
impS  MACRO                       
 mov   ah,09
 lea   dx,strSalto
 int   21h   
ENDM
;///////////////////////////////// macro que imprime un numero de 16 bits
imprimirNum16B MACRO num_imp
   local  dowhile, saldowhile ,cfor5 ,salfor5
   
; DOWHILE
   mov ax,0d
   mov ax,num_imp
   mov auxImpPila,0 
   dowhile:
     
     and dx,0
     mov cx,10d

     div cx
     inc auxImpPila
     push dx
        
     cmp ax, 0d
     jne dowhile
     jmp saldowhile

   saldowhile:    
   
   mov contDigitosImp, 0
   mov numResultado,0
   and cx,0d
   
   cfor5:
      mov cx, auxImpPila
      cmp contDigitosImp, cx
      jge salfor5
      and ax,0d
      pop ax
      mov numResultado,ax
     
     imprimir_numeroAUX numResultado

      inc contDigitosImp
   jmp cfor5
   salfor5:
ENDM
;///////////////////////////////// macro que inserta un valor en el vector, indice en el que se le indique 8 bits
insertarVector macro vector,indice,valor
    mov si,0d               ;limpio el iterador si
    xor dx,dx               ;limpio el registro dx
    mov dl,valor            ;se guarda el valor recibido como parametro en dl
    mov si,indice           ;se copia el indice enviado en si
    mov vector[si],dl       ;se inserta el valor en el vector recibido en el indice si
endm

;///////////////////////////////// macro que obtiene un valor del vector en el indice que se le indique 8 bits
obtenerValorVector macro valor, vector,indice
    mov si,0d               ;limpio el iterador si
    xor dx,dx               ;limpio el registro dx
    mov si,indice           ;se copia el indice enviado en si
    mov dl,vector[si]       ;se obtiene el valor del vector en si, se copia en dl
    mov valor,dl        ;se guarda el valor leido de dl a la variable temporal valVector
endm

;///////////////////////////////// macro que inserta un valor en el vector, indice en el que se le indique 16 bits
insertarVector16Bits macro vector,indice,valor
    mov si,0d               ;limpio el iterador si
    xor cx,cx               ;limpio el registro dx
    xor bx,bx
    xor ax,ax
    
    mov ax,indice
    mov cx,2d
    mul cx 
    mov si,ax               ;se copia el indice enviado en si  

    mov bx,valor            ;se guarda el valor recibido como parametro en dl
    mov vector[si],bx       ;se inserta el valor en el vector recibido en el indice si
    ;pausa
endm

;///////////////////////////////// macro que obtiene un valor del vector en el indice que se le indique 16 bits
obtenerValorVector16Bits macro valor, vector,indice
    mov si,0d               ;limpio el iterador si
    xor cx,cx               ;limpio el registro dx
    xor bx,bx
    xor ax,ax

    mov ax,indice
    mov cx,2d
    mul cx   
    mov si,ax           ;se copia el indice enviado en si
    mov bx,vector[si]       ;se obtiene el valor del vector en si, se copia en dl
    mov valor,bx        ;se guarda el valor leido de dl a la variable temporal valVector
endm

;///////////////////////////////// macro que muestra los valores de un vector de 16 bits
mostrarVector macro vector,tamVector
   local for,finFor
   mov contadorFor,0d
   for:
       mov bx,tamVector
       cmp contadorFor,bx
       jge finFor

       obtenerValorVector16Bits valVector, vecNumeros,contadorFor
       imprimirNum16B valVector
       imprimir espacio_   
       inc contadorFor

   jmp for
   finFor:  
endm

;///////////////////////////////// macro que copia los valores de un vector1 al vector 2 ambos de 16 bits
copiarVector macro vec1,vec2
    local for,finFor
    mov contadorFor,0d
    mov valVector,0d
    mov bx,N 
    mov si,0d
    for:
       cmp contadorFor,bx
       jge finFor
       
       obtenerValorVector16Bits valVector, vec1,contadorFor

       insertarVector16Bits vec2,contadorFor,valVector 
       
       inc contadorFor
   jmp for
   finFor:
endm

;///////////////////////////////// macro que guarda valores de un vector de ascii a un vector de numeros binarios de 16 bits
guardarNumeros MACRO
  local for,finFor,obtenerNumero,continuarCiclo,for2,finFor2
    
    xor ax,ax
    mov si,0d
    mov contadorI,0d
    mov contVector,0d
    mov numTemp,0d
    
    for:
      xor bx,bx
      mov cx,2000
      cmp contadorI,cx
      jge finFor
      
      mov si,contadorI
      mov bl,vecTempNumeros[si]
      mov val,bl
      
      cmp val,36            ;si es $ me salgo de la lectura
      je finFor
      
      cmp val,44            ;si es , tengo que sacar de la pila y operar 
      je  obtenerNumero
      
      ;si no es coma ni $ significa que es numero y se inserta en la pila      
      
      push bx
      inc contPila
      jmp continuarCiclo
      
      obtenerNumero:
        mov multiplicador,1d
        mov numTemp,0d
        for2:
            
            cmp contPila,0d 
            jle finFor2

            pop bx
            sub bx,30h
            mov ax,multiplicador
            cwd
            mul bx   
            add numTemp,ax

            mov ax,10d
            mov bx,multiplicador
            mul bx
            mov multiplicador,ax

            dec contPila  
        jmp for2
        finFor2:

        insertarVector16Bits vecNumeros,contVector,numTemp            
        inc contVector

      continuarCiclo:
      inc contadorI
      jmp for
    finFor:
  
  ;//////////////APLICANDO ORDENAMIENTO
  ordenarBurbuja

ENDM 

;/////////////////////////////////MACRO QUE HACE EL ORDENAMIENTO BURBUJA ASCENDENTE
ordenarBurbuja macro 
	local for,for2,finFor,finFor2,intercambio,finIf

    mov contadorForBurbuja,0d

	for:
		mov cx,contVector
		cmp contadorForBurbuja,cx
		jge finFor

		mov contadorForBurbuja2,0d
		
		for2:
		mov bx,contVector
		sub bx,contadorForBurbuja
		sub bx,1d
		
		cmp contadorForBurbuja2,bx
		jge finFor2

			obtenerValorVector16Bits temp, vecNumeros,contadorForBurbuja2

			mov bx,contadorForBurbuja2
			add bx,1d
			mov posSig,bx
			
			obtenerValorVector16Bits temp2, vecNumeros,posSig
			
			and bx,0d
			mov bx,temp2
			
			cmp temp,bx
			jg  intercambio
			jmp finIf
			
			intercambio:

				insertarVector16Bits  vecNumeros, contadorForBurbuja2, temp2
				insertarVector16Bits  vecNumeros, posSig, temp

			finIf:

		inc contadorForBurbuja2
		jmp for2
		
		finFor2:  
	
	inc contadorForBurbuja
	jmp for
	
	finFor:

endm

;//////////////////////////////// macro que suma los numeros binarios guardados en vecNumeros
sumarNumerosVector macro
    local for,finFor
    mov sumaProm, 0d
    mov contForSumaProm,0d
    for:
        and bx,0d
        mov bx,contVector
        cmp contForSumaProm,bx
        jge finFor
        obtenerValorVector16Bits valSumarProm,vecNumeros,contForSumaProm
        and ax,0d
        mov ax,valSumarProm
        adc sumaProm,ax
        inc contForSumaProm
    jmp for
    finFor:
endm

;//////////////////////////////// macro que hace la division para promedio
hacerPromedio macro
    local for,finFor,for2,finFor2

                ;valor_promedio    dw 0d
            ;valor_dec_prom    dw 0d

    mov parteEntera,0d
    mov residuo,0d
    and ax,0d
    and bx,0d

    mov ax,sumaProm     ;dividendo
    mov bx,contVector   ;divisor
    ;cwd                 ;expandiendo registro
    div bx              ;dividiendo ax/bx

    mov parteEntera,ax           ;cociente = 1 (parte entera)
    mov valor_promedio,ax
    mov residuo,dx
    mov contForDecimales,0d

    for:
        and ax,0d
        mov ax,residuo
        cmp contForDecimales,3d
        jge finFor
        
        and bx,0d           ;limpio bx
        mov bx,10d
        mul bx              ;multiplico ax*bx
                            ;en ax esta lo que quiero dividir primera iteracion es 30
        
        and bx,0d           ;limpio bx
        mov bx,contVector   ;copio el divisor
        div bx              ;divido el residuo anterior con el divisor
        mov decimal,ax      ;variable para que se vea el decimal
        mov residuo,dx      ;variable en la que se lleva el residuo
        push ax             ;guardando en la pila el decimal

        inc contForDecimales 
        jmp for
    finFor:

    ;////FOR PARA FORMAR LOS DECIMALES
    mov contForFormarDec,0d
    mov parteDecimal,0d
    mov multiploDecimales,1d
    for2:
        cmp contForFormarDec,3d
        je finFor2

        and ax,0d
        and bx,0d
        pop ax
        mov bx,multiploDecimales
        mul bx
        adc parteDecimal,ax

        and ax,0d
        and bx,0d
        mov ax,multiploDecimales
        mov bx,10d
        mul bx
        mov multiploDecimales,ax
        inc contForFormarDec
        jmp for2
    finFor2:

    and ax,0d
    mov ax,parteDecimal
    mov valor_dec_prom,ax

    imprimir strConsola
    imprimirNum16B parteEntera
    imprimir puntoDec
    imprimirNum16B parteDecimal
    impS

endm

;/////////////////////////////// macro que hace la tabla de frecuencias
generarTablaFrecuencia macro
    local for,finFor,for2,finFor2

    mov contadorForFrec,0d
    for:
        and cx,0d
        mov cx,contVector
        cmp contadorForFrec,cx 
        jge finFor

        obtenerValorVector16Bits valorFrecuencia, vecNumeros,contadorForFrec

        and ax,0d
        mov ax,contadorForFrec
        mov contadorForFrec2,0d
        mov contadorForFrec2,ax
        mov repitoFrecuencia,0d
        for2:
            and bx,0d
            mov bx,contVector
            cmp contadorForFrec2,bx 
            jge finFor2

            obtenerValorVector16Bits valorFrecuencia2, vecNumeros,contadorForFrec2

            and ax,0d
            mov ax,valorFrecuencia2
            cmp valorFrecuencia,ax
            je  numIguales
            jmp noIguales
            numIguales:
              inc repitoFrecuencia
              jmp continuar  
            noIguales:
                ;insertarVector16Bits macro vector,indice,valor
                insertarVector16Bits tablaFrecuencias,contFrecuencias,valorFrecuencia 
                insertarVector16Bits numeroFrecuencia,contFrecuencias,repitoFrecuencia 
                inc contFrecuencias
            continuar:  
            inc contadorForFrec2
            jmp for2
        finFor2:

        and ax,0d
        mov ax,contadorForFrec2
        mov contadorForFrec,ax
        jmp for
    finFor:
endm


;///////////////////////////////// macro que hace la tabla de frecuencias
realizarFrecuencias macro 
    local for,finFor,son_iguales,no_son_iguales,continuar_frec
    mov contadorForFrec,0d
    mov contForFrecSig,0d
    mov repitoFrecuencia,1d
    mov contFrecuencias,0d
    for:
        and cx,0d
        mov cx,contVector
        cmp contadorForFrec,cx 
        jge finFor
        
        and ax,0d
        mov ax,contadorForFrec
        mov contForFrecSig,ax
        add contForFrecSig,1d

        obtenerValorVector16Bits valorFrecuencia, vecNumeros,contadorForFrec
        obtenerValorVector16Bits valorFrecuencia2, vecNumeros,contForFrecSig
        
        and ax,0d
        mov ax,valorFrecuencia2
        cmp valorFrecuencia,ax
        je son_iguales
        jmp no_son_iguales
        
        son_iguales:
            inc repitoFrecuencia
            jmp continuar_frec
        
        no_son_iguales:
            insertarVector16Bits tablaFrecuencias,contFrecuencias,repitoFrecuencia
            insertarVector16Bits numeroFrecuencia,contFrecuencias,valorFrecuencia
            mov repitoFrecuencia,1d
            inc contFrecuencias
        continuar_frec:
        inc contadorForFrec
        jmp for
            
    finFor:
        ;mostrarTabla contFrecuencias
endm

;///////////////////////////////// macro que muestra los valores de la tabla de frecuencias
mostrarTabla macro cont
   local for,finFor
   mov contadorFor,0d
   for:
       mov bx,cont
       cmp contadorFor,bx
       jge finFor

       obtenerValorVector16Bits impFrec, tablaFrecuencias,contadorFor
       obtenerValorVector16Bits impRepi, numeroFrecuencia,contadorFor

        imprimirNum16B impFrec
        imprimir espacio_
        imprimirNum16B impRepi
        impS
       
       inc contadorFor
   jmp for
   finFor:  
endm

;///////////////////////////////// macro que ordena tabla de frecuencias por frecuencia
comando_moda macro moda_ret,tamFrec
local for,for2,finFor,finFor2,intercambio,finIf

    mov contadorForBurbuja,0d
    for:
        and cx,0d
        mov cx,tamFrec
        cmp contadorForBurbuja,cx
        jge finFor

        mov contadorForBurbuja2,0d
        
        for2:
        and bx,0d
        mov bx,tamFrec
        sub bx,contadorForBurbuja
        sub bx,1d
        
        cmp contadorForBurbuja2,bx
        jge finFor2

            obtenerValorVector16Bits val_frec, tablaFrecuencias,contadorForBurbuja2
            obtenerValorVector16Bits val_num, numeroFrecuencia,contadorForBurbuja2
            
            and bx,0d
            mov bx,contadorForBurbuja2
            add bx,1d
            mov posSig,bx
            
            obtenerValorVector16Bits val_frec2, tablaFrecuencias,posSig
            obtenerValorVector16Bits val_num2, numeroFrecuencia,posSig

            and bx,0d
            mov bx,val_frec2
            
            cmp val_frec,bx
            jg  intercambio
            jmp finIf
            
            intercambio:

                insertarVector16Bits  tablaFrecuencias, contadorForBurbuja2, val_frec2
                insertarVector16Bits  tablaFrecuencias, posSig, val_frec

                insertarVector16Bits  numeroFrecuencia, contadorForBurbuja2, val_num2
                insertarVector16Bits  numeroFrecuencia, posSig, val_num

            finIf:

        inc contadorForBurbuja2
        jmp for2
        
        finFor2:  
    
    inc contadorForBurbuja
    jmp for
    
    finFor: 

    and ax,0d
    mov ax,tamFrec
    sub ax,1d
    mov posModa,ax
    obtenerValorVector16Bits moda_ret, numeroFrecuencia,posModa
endm

;///////////////////////////////// macro que hace la division cuando el numero es par
dividirNumero macro v1,v2
    local for,finFor,for2,finFor2

    mov parteEntera,0d
    mov residuo,0d
    and ax,0d
    and bx,0d

    mov ax,v1     ;dividendo
    mov bx,v2     ;divisor
    ;cwd                 ;expandiendo registro
    div bx              ;dividiendo ax/bx

    mov parteEntera,ax           ;cociente = 1 (parte entera)
    mov valor_mediana,ax
    mov residuo,dx
    mov contForDecimales,0d

    for:
        and ax,0d
        mov ax,residuo
        cmp contForDecimales,3d
        jge finFor
        
        and bx,0d           ;limpio bx
        mov bx,10d
        mul bx              ;multiplico ax*bx
                            ;en ax esta lo que quiero dividir primera iteracion es 30
        
        and bx,0d           ;limpio bx
        mov bx,v2   ;copio el divisor
        div bx              ;divido el residuo anterior con el divisor
        mov decimal,ax      ;variable para que se vea el decimal
        mov residuo,dx      ;variable en la que se lleva el residuo
        push ax             ;guardando en la pila el decimal

        inc contForDecimales 
        jmp for
    finFor:

    ;////FOR PARA FORMAR LOS DECIMALES
    mov contForFormarDec,0d
    mov parteDecimal,0d
    mov multiploDecimales,1d
    for2:
        cmp contForFormarDec,3d
        je finFor2

        and ax,0d
        and bx,0d
        pop ax
        mov bx,multiploDecimales
        mul bx
        adc parteDecimal,ax

        and ax,0d
        and bx,0d
        mov ax,multiploDecimales
        mov bx,10d
        mul bx
        mov multiploDecimales,ax
        inc contForFormarDec
        jmp for2
    
    finFor2:

    and ax,0d
    mov ax,parteDecimal
    mov valor_dec_med,ax

    imprimir strConsola
    imprimirNum16B parteEntera
    imprimir puntoDec
    imprimirNum16B parteDecimal
    impS
endm

;///////////////////////////////// macro que escribe en el archivo
escribirArchivo macro cadena,tam
     mov ah,40h
     mov bx,handler2
     mov cx,tam ;//numero de bytes que se van a escribir en el archivo   
     mov dx,offset cadena
     int 21h        
endm

;///////////////////////////////// macro que escribe un numero de 16 bits en el reporte
escribirBinarioReporte16B macro num_imp
  local  dowhile, saldowhile ,cfor5 ,salfor5
    
; DOWHILE
   mov ax,0d
   mov ax,num_imp
   mov auxImpPila,0 
   dowhile:
     
     and dx,0
     mov cx,10d

     div cx
     inc auxImpPila
     push dx
        
     cmp ax, 0d
     jne dowhile
     jmp saldowhile

   saldowhile:  
   
   ; CICLO FOR
   mov cx, auxImpPila
   mov contDigitosImp, 0
   mov numResultado,0
   
   cfor5:
      cmp contDigitosImp, cx
      jge salfor5
      pop ax
      mov numResultado,ax
      add numResultado,30h
      
      escribirArchivo  numResultado,1
      
      mov cx, auxImpPila
      inc contDigitosImp
   jmp cfor5
   salfor5:
endm

;///////////////////////////////// macro que escribe un numero de 8 bits en el reporte
escribirBinarioReporte macro num_imp
  local  dowhile, saldowhile ,cfor5 ,salfor5
    
; DOWHILE
   mov ax,0d
   mov al,num_imp
   mov auxImpPila,0 
   dowhile:
     
     and dx,0
     mov cx,10d

     div cx
     inc auxImpPila
     push dx
        
     cmp ax, 0d
     jne dowhile
     jmp saldowhile

   saldowhile:    
     
   ; CICLO FOR
   mov cx, auxImpPila
   mov contDigitosImp, 0
   mov numResultado,0
   
   cfor5:
      cmp contDigitosImp, cx
      jge salfor5
      pop ax
      mov numResultado,ax
      add numResultado,30h
      escribirArchivo  numResultado,1
      mov cx, auxImpPila
      inc contDigitosImp
   jmp cfor5
   salfor5:
endm

;///////////////////////////////// macro que muestra los valores de la tabla de frecuencias
escribirTabla macro cont
   local for,finFor
   mov contadorFor,0d
   for:
       mov bx,cont
       cmp contadorFor,bx
       jge finFor

       obtenerValorVector16Bits impFrec, tablaFrecuencias,contadorFor
       obtenerValorVector16Bits impRepi, numeroFrecuencia,contadorFor

        escribirBinarioReporte16B impFrec
        escribirArchivo strTabulacionR,4d
        escribirBinarioReporte16B impRepi
        escribirArchivo strSaltoAr,1d
       
       inc contadorFor
   jmp for
   finFor:  
endm

