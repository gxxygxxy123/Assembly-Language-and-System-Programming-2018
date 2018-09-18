;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; National Chiao Tung University
; Department Of Computer Science
; 
; Assembly Programming Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write programs in the Release mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $Student Name: 楊家安
; $Student ID: 0516021
; $Student Email: gxxygxxy@gmail.com
;
; Instructor Name: Sai-Keung Wong 
;
TITLE Quiz1

include Irvine32.inc
include Macros.inc
.data
nQ1					DWORD ?
mQ1					DWORD ?
ansQ1				DWORD ?
remQ1				DWORD ?
Evenflg				BYTE 0
nQ2					DWORD ?
mQ2					DWORD ?
ansQ2				DWORD ?
nQ3					DWORD ?
ansQ3				DWORD ?
S0					REAL8 1.0
S1					REAL8 3.5
tmp1				REAL8 ?
tmp2				REAL8 ?
Leftflg				BYTE 0
Quitflg				BYTE 0
X_UNIT				BYTE ?
Y_UNIT				BYTE ?
Num_Chars_X			DWORD ?
Num_Chars_Y			DWORD ?
CharacterX_Old			SBYTE 30
CharacterY_Old			SBYTE 12
CharacterX				SBYTE 30
CharacterY				SBYTE 12
BackGroundColor DWORD	(lightGray + blue * 16)
.code

main PROC
START:
	call ShowMenu
	call ChooseOption
	mov eax, (lightGray + blue * 16); default color
	call SetTextColor
	call Clrscr
	loop START

	exit
main ENDP

ShowMenu PROC
	mov eax, (white + blue * 16)
	call SetTextColor
	call Clrscr
	mov dl, 0
	mov dh, 0
	call GotoXY
	mov Num_Chars_X, 100
	mov Num_Chars_Y, 24
	mov eax, (white + green * 16)
	call SetTextColor
	call DrawOneFrame
	mov eax, (white + blue * 16)
	call SetTextColor
	mov dl, 1				;X(horizon)
	mov dh, 1				;Y(vertical)
	call GotoXY
	mWrite "My student ID is: 0516021"
	inc dh
	call GotoXY
	mWrite "Please select one of the option"
	inc dh
	call GotoXY
	mWrite "1. Compute (2+4+6+...+2n)/m"
	inc dh
	call GotoXY
	mWrite "2. Compute (2-4+6-...+(-1)^(n+1)2n)*m"
	inc dh
	call GotoXY
	mWrite "3. Compute S(n). Define S(n) = S(n-1) + S(n-2), n >= 2. S(0) = 1, S(1) = 3.5 ."
	inc dh
	call GotoXY
	mWrite "4. Animate a character to move horizontally"
	inc dh
	call GotoXY
	mWrite "5. Quit the program"
	inc dh
	call GotoXY
	mWrite "Please select an option......"
	ret
ShowMenu ENDP

ChooseOption PROC
LookForKey:
	mov eax, 50		; sleep, to allow OS to time slice
	call Delay		; (otherwise, some key presses are lost)
	call ReadKey	; look for keyboard input
	jz LookForKey	; not key pressed yet
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
	jmp LookForKey
One:
	call Option1
	jmp End_Pressed
Two:
	call Option2
	jmp End_Pressed
Three:
	call Option3
	jmp End_Pressed
Four:
	call Option4
	jmp End_Pressed
Five:
	call Option5
	exit
End_Pressed:
	ret
ChooseOption ENDP

Option1 PROC
	mov eax, BackGroundColor
	call SetTextColor
	call Clrscr
RESTART:
	mWrite "1. Compute (2+4+6+...+2n)/m  Input n [0, 100]:"
	call ReadInt
	cmp eax, 0
	JL Warning
	cmp eax, 100
	JG Warning
	cmp eax, 0
	je L_Quit
	mov nQ1, eax
	mWrite "Input m(non-zero, signed integer):"
	call ReadInt
	mov mQ1, eax
	call ComputeQ1				; n is positive
	mWrite "Quotient is:"
	mov eax, ansQ1
	call WriteInt
	call Crlf
	mWrite "Remainer is:"
	mov eax, remQ1
	call WriteInt
	call Crlf
	jmp RESTART
Warning:
	mWrite "Warning! Please input n(0~100) in correct range again"
	call Crlf
	jmp RESTART
L_Quit:
	ret
Option1 ENDP

Option2 PROC
	mov eax, BackGroundColor
	call SetTextColor
	call Clrscr
RESTART:
	mWrite "2. Compute (2-4+6-...+(-1)^(n+1) 2n)*m  Please input n [0, 50]:"
	call ReadInt
	cmp eax, 0
	JL Warning
	cmp eax, 50
	JG Warning
	cmp eax, 0
	je L_Quit
	mov nQ2, eax
	mWrite "Input m(non-zero, signed integer):"
	call ReadInt
	mov mQ2, eax
	call ComputeQ2				; n is positive
	mWrite "The result is:"
	mov eax, ansQ2
	call WriteInt
	call Crlf
	jmp RESTART
Warning:
	mWrite "Warning! Please input n(0~50) in the correct range again"
	call Crlf
	jmp RESTART
L_Quit:
	ret
Option2 ENDP

Option3 PROC
	mov eax, BackGroundColor
	call SetTextColor
	call Clrscr
RESTART:
	mWrite "3. Compute S(n). Define S(n) = S(n-1)+S(n-2), n>=2."
	call Crlf
	mWrite "S(0) = 1.0, S(1) = 3.5"
	call Crlf
	mWrite "Please input n:"
	call ReadInt
	cmp eax, 0
	je L_Quit
	cmp eax, 1
	je L1
	mov nQ3, eax
	call ComputeQ3
	mWrite "The result is:"
	call WriteFloat
	call Crlf
	jmp RESTART
L1:
	mWrite "The result is:3.5"
	call Crlf
	jmp RESTART
L_Quit:
	ret
Option3 ENDP

Option4 PROC
	mov CharacterX, 30
	mov CharacterY, 12
	mov Quitflg, 0
	mov Leftflg, 0
	call DrawBackground
	call ShowCharacter
	call ControlCharacter
	ret
Option4 ENDP

Option5 PROC
	mov eax, BackGroundColor
	call SetTextColor
	call Clrscr
	mWrite "Thanks for playing this system."
	call Crlf
	mWrite "This program is written by"
	call Crlf
	mWrite " Name: 楊家安"
	call Crlf
	mWrite " ID: 0516021"
	call Crlf
	mWrite "I am learning assembly programming"
	call Crlf
	mWrite "Please contact me at gxxygxxy@gmail.com"
	call Crlf
	mWrite "Press any KEY to quit..."
LookForKey:
	mov eax, 50
	call Delay
	call ReadKey
	jz LookForKey
	ret
Option5 ENDP

ComputeQ1 PROC
	mov ansQ1, 0
	mov eax, 0
	mov ecx, nQ1
L0:
	add eax, 2
	add ansQ1, eax
	loop L0
	mov eax, ansQ1
	cdq
	mov ebx, mQ1
	idiv ebx
	mov ansQ1, eax
	mov remQ1, edx
	ret
ComputeQ1 ENDP

ComputeQ2 PROC
	mov Evenflg, 1
	mov ansQ2, 0
	mov eax, 0
	mov ecx, nQ2
L0:
	xor Evenflg, 1
	add eax, 2
	cmp Evenflg, 0
	je Oddterm
	cmp Evenflg, 1
	je Eventerm
Oddterm:
	add ansQ2, eax
	jmp L1
Eventerm:
	sub ansQ2, eax
	jmp L1
L1:
	loop L0
	mov ebx, ansQ2
	mov eax, mQ2
	imul ebx
	mov ansQ2, eax
	ret
ComputeQ2 ENDP

ComputeQ3 PROC
	finit
	mov ecx, nQ3
	sub ecx, 1
	fld S0
	fld S1
L0:
	fadd ST(1), ST(0)
	fstp tmp1
	fstp tmp2 
	fld tmp1
	fld tmp2
	loop L0
L_Quit:
	ret
ComputeQ3 ENDP

DrawBackground PROC
	mov eax, (white + black * 16)
	call SetTextColor
	call Clrscr
	mov eax, (white + blue * 16)
	call SetTextColor
	mov ecx, 25
L0:
	push ecx
	mov ecx, 60
L1:
	mov al, ' '
	call WriteChar
	loop L1
	call Crlf
	pop ecx
	loop L0
	ret
DrawBackground ENDP

DrawOneFrame PROC
	;Give color, DrawDelay, position, width, height first before endter the proc
	mov ah, 0				; no grid it's ugly
	; draw from top to bottom
	mov ecx, Num_Chars_Y
	mov X_UNIT, 0
	mov Y_UNIT, 1
	call DrawOneLine
	; draw from left to right
	mov ecx, Num_Chars_X
	mov X_UNIT, 1
	mov Y_UNIT, 0
	call DrawOneLine
	; draw from bottom to top
	mov ecx, Num_Chars_Y
	mov X_UNIT, 0
	mov Y_UNIT, -1
	call DrawOneLine
	; draw from right to left
	mov ecx, Num_Chars_X
	mov X_UNIT, -1
	mov Y_UNIT, 0
	call DrawOneLine
	ret
DrawOneFrame ENDP

DrawOneLine PROC
L1:
	mov al, ' '
	call WriteChar
	add dl, X_UNIT
	add dh, Y_UNIT
	call GotoXY
	loop L1
	ret
DrawOneLine ENDP

ShowCharacter PROC
	mov eax, (black + white * 16)
	call SetTextColor
	mov dl, CharacterX
	mov dh, CharacterY
	call GotoXY
	mov al, ' '
	call WriteChar
	ret
ShowCharacter ENDP

ClearCharacter PROC
	mov dl, CharacterX_Old
	mov dh, CharacterY_Old
	call GotoXY
	mov eax, BackGroundColor
	call SetTextColor
	mov al, ' '
	call WriteChar
	ret
ClearCharacter ENDP

ControlCharacter PROC
L0:
	call SaveCharacterPosition
	call AutoMove
	call ClearCharacter
	call ShowCharacter
	cmp Quitflg, 1
	je L1
	jmp L0
L1:
	ret
ControlCharacter ENDP

AutoMove PROC
	mov eax, 100
	call Delay
	cmp CharacterX, 59				; ship reaches the right side
	je L0
	cmp Leftflg, 1
	je L0
	inc CharacterX
	jmp L_Quit
L0:
	mov Leftflg, 1
	cmp CharacterX, 0
	je L1
	sub CharacterX, 1
	jmp L_Quit
L1:
	mov Quitflg, 1
	jmp L_Quit
L_Quit:
	ret
AutoMove ENDP

SaveCharacterPosition PROC
	mov al, CharacterX
	mov CharacterX_Old, al
	mov al, CharacterY
	mov CharacterY_Old, al
	ret
SaveCharacterPosition ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

END main
