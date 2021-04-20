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

 
   ; CICLO FOR
   
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
   imprimir separador
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

mostrarVector macro vector,tamVector
   local for,finFor
   mov contadorFor,0d
   for:
       mov bx,tamVector
       cmp contadorFor,bx
       jge finFor

       obtenerValorVector16Bits valVector, vecNumeros,contadorFor
       imprimirNum16B valVector   
       inc contadorFor

   jmp for
   finFor:  
endm

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
        
ENDM 