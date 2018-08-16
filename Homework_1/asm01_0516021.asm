;========================================================
; Assignment 01
; Student Name: 楊家安 Chia-An Yang
; Student ID: 0516021
; Email: gxxygxxy@gmail.com
;========================================================
; Instructor: Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: 706
; Assembly Language and System Programming
;========================================================

TITLE Homework01

include Irvine32.inc
include Macros.inc

.data

randVal         DWORD   ?
Option1         BYTE    "1)Show colorful frames", 0
Option2         BYTE    "2)Sum up signed integers", 0
Option3         BYTE    "3)Sum up unsigned integers", 0
Option4         BYTE    "4)Compute sin(x)", 0
Option5         BYTE    "5)Show student information", 0
Option6         BYTE    "6)Quit", 0
SelectPlz       BYTE    "Please select an option......", 0
X_UNIT          BYTE    ?
Y_UNIT          BYTE    ?
Num_Chars_X     DWORD   ?
Num_Chars_Y     DWORD   ?
TMP             BYTE    ?               ;To see if al is black(0000????)
LastFrameColor  BYTE    00001111b      ;last one frame's color(initialize black)
Question2Ans    SDWORD  ?
Question3Ans    DWORD   ?
Question4Ans	REAL8	?
x               REAL8   ?
terms			DWORD   ?
trash			REAL8	?
denominator		DWORD	?				;1! 3! 5!...
MINUS1			DWORD   -1				;constant -1
.code

main PROC
START:
	call ShowMenu
	call ChooseOption
LookForKey:
	mov eax, 50       ; sleep, to allow OS to time slice
	call Delay        ; (otherwise, some key presses are lost)
	call ReadKey      ; look for keyboard input
	jz LookForKey     ; not key pressed yet
	mov eax, lightGray + ( black*16 )  ; default color
	call SetTextColor
	call Clrscr
	loop START
	call ReadInt			        ; block the program
	exit
main ENDP

ShowMenu PROC
	mov edx, offset Option1
	call WriteString
	call Crlf
	mov edx, offset Option2
	call WriteString
	call Crlf
	mov edx, offset Option3
	call WriteString
	call Crlf
	mov edx, offset Option4
	call WriteString
	call Crlf
	mov edx, offset Option5
	call WriteString
	call Crlf
	mov edx, offset Option6
	call WriteString
	call Crlf
	call Crlf
	mov edx, offset SelectPlz
	call WriteString
	call Crlf
	ret
ShowMenu ENDP

ChooseOption PROC
LookForKey:
	mov eax, 50       ; sleep, to allow OS to time slice
	call Delay        ; (otherwise, some key presses are lost)
	call ReadKey      ; look for keyboard input
	jz LookForKey     ; not key pressed yet
	cmp al, '1'       
	je One
	cmp al, '2'
	je Two
	cmp al, '3'
	je Three
	cmp al, '4'
	je Four
	cmp al, '5'
	je Five
	cmp al, '6'
	je Quit
	jmp End_Pressed
One:
	call Clrscr                            ;clear the screen
	mov dl, 0                              ;column
	mov dh, 0                              ;row
	mov Num_Chars_X, 84
	mov Num_Chars_Y, 24
L0:
	call DrawOneFrame
	inc dh
	inc dl
	call GotoXY
	sub Num_Chars_X, 2
	sub Num_Chars_Y, 2
	cmp Num_Chars_X, 0
	je L1
	cmp Num_Chars_Y, 0
	je L1
	jmp L0
L1:
	call DrawOneFrame
	jmp End_Pressed
Two:
	call Clrscr
	mov Question2Ans, 0
	mWrite "Input the number of signed integers:"
	call ReadDec
	mov ecx, eax
L2:
	mWrite "Input the signed integers:"
	call ReadInt
	add Question2Ans, eax
	loop L2
	mWrite "The sum is:"
	mov eax, Question2Ans
	call WriteInt
	call Crlf
	mWrite "Press a key to go back to the menu"
	jmp End_Pressed
Three:
	call Clrscr
	mov Question3Ans, 0
	mWrite "Input the number of unsigned integers:"
	call ReadDec
	mov ecx, eax
L3:
	mWrite "Input the unsigned integers:"
	call ReadDec
	add Question3Ans, eax
	loop L3
	mWrite "The sum is:"
	mov eax, Question3Ans
	call WriteDec
	call Crlf
	mWrite "Press a key to go back to the menu"
	jmp End_Pressed
Four:
	call Clrscr
	finit
	mWrite "Input a floating number x:"
	call ReadFloat
	fst x
	fld ST(0)
	mWrite "Input the number of terms:"
	call ReadDec
	mov terms, eax
	mov ecx, terms
	call Compute_Q4
	mWrite "The result sin(x) using the first n terms is:"
	call WriteFloat
	call Crlf
	mWrite "Press a key to go back to the menu"
	jmp End_Pressed
Five:
	call Clrscr
	mWrite "Student ID: 0516021"
	call Crlf
	mWrite "Student name: 楊家安"
	call Crlf
	mWrite "Student email address: gxxygxxy@gmail.com"
	call Crlf
	mWrite "Press a key to go back to the menu"
	jmp End_Pressed
Quit:
	exit
End_Pressed:
	ret
ChooseOption ENDP

DrawOneFrame PROC
	mov eax, 500
	call Delay
RERANDOMIZE:
	call Randomize                 ; re-seed
	call Random32
	;mov eax, white + ( blue*16 )   ;test for lastframecolor
	mov TMP, al                    ; if background is black
	and TMP, 11110000b             ; |
	cmp TMP, 00000000b             ; then re-randomize
	je RERANDOMIZE
	mov bl, LastFrameColor         ; if the color background is same as the last one
	xor bl, al                     ; |
	and bl, 11110000b              ; |
	cmp bl, 0                      ; |
	je RERANDOMIZE                 ; then re-randomize
	mov LastFrameColor, al         ; LastFrameColor = al
	                               ;
	mov ah, 0                      ; no grid it's ugly
	call SetTextColor              ; color in al(8bits)
	; draw from left to right
	mov ecx, Num_Chars_X
	mov X_UNIT, 1
	mov Y_UNIT, 0
	call DrawOneLine
	cmp Num_Chars_Y, 0
	jle SKIP1
	; draw from top to bottom
	mov ecx, Num_Chars_Y
	mov X_UNIT, 0
	mov Y_UNIT, 1
	call DrawOneLine
SKIP1:
	; draw from right to left
	mov ecx, Num_Chars_X
	mov X_UNIT, -1
	mov Y_UNIT, 0
	call DrawOneLine
	cmp Num_Chars_Y, 0
	jle SKIP2
	; draw from bottom to top
	mov ecx, Num_Chars_Y
	mov X_UNIT, 0
	mov Y_UNIT, -1
	call DrawOneLine
SKIP2:
	ret
DrawOneFrame ENDP

DrawOneLine PROC
L2:
	mov al, ' '
	call WriteChar
	add dl, X_UNIT
	add dh, Y_UNIT
	call GotoXY
	loop L2
	ret
DrawOneLine ENDP

Compute_Q4 PROC
								; ST(0) = x  ST(1) = x
	mov denominator, 1			; Start from 1!
L0:
	fimul MINUS1				; ST(0) * -1
	fmul x						; ST(0) * x
	fmul x						; ST(0) * x
	add denominator, 1			; +1
	fidiv denominator			; divide
	add denominator, 1			; +1
	fidiv denominator			; divide
	fadd ST(1), ST(0)			; add the term to the answer
	loop L0						; ecx = input n
	fstp trash					; pop ST(0)
	fst Question4Ans			; now ST(0) is what we want
	ret
Compute_Q4 ENDP

END main