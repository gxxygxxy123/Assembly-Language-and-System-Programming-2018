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
TITLE quiz two

include Irvine32.inc
include Macros.inc

.data

_a REAL8 ?
_b REAL8 ?
_c REAL8 ?
X_UNIT          BYTE    ?
Y_UNIT          BYTE    ?
Num_Chars_X     DWORD   ?
Num_Chars_Y     DWORD   ?
Row_Up			BYTE	?
Row_Down		BYTE	?
Col_Left		BYTE	?
Col_Right		BYTE	?
TMP BYTE ?
current_X BYTE ?
current_Y BYTE ?
delete_X BYTE ?
delete_Y BYTE ?
ShowingFrame	BYTE 0
.code

main PROC
L0:
	call ShowMenu
	loop L0
	call ReadInt
	exit
main ENDP

ShowMenu PROC
	mov eax, lightgray + black * 16
	call SetTextColor
	call ClrScr
	mWrite "1) Floating point calculation"
	call crlf
	mWrite "2) Simple control"
	call crlf
	call crlf
	mWrite "Please press a key to continue"
	call crlf
LookForKey:
	mov eax, 50
	call Delay
	call ReadKey
	jz LookForKey
	cmp al, '1'
	je Q1
	cmp al, '2'
	je Q2
	jmp LookForKey
Q1:
	call Question1
	jmp L_Quit
Q2:
	mov ShowingFrame, 1
	mov eax, white + gray * 16
	call SetTextColor
	call Clrscr
	call DrawBlueFrame
	call BuildNewMap
L0:
	call HandleKeyEvent
	loop L0
	jmp L_Quit
L_Quit:
	ret
ShowMenu ENDP

Question1 PROC
	call Clrscr
	finit
	mWrite "Enter a: "
	call ReadFloat
	fst _a
	mWrite "Enter b: "
	call ReadFloat
	fst _b
	mWrite "Enter c: "
	call ReadFloat
	fst _c
	fmulp
	faddp
	mWrite "a+b*c = "
	call WriteFloat
	call crlf
LookForKey:
	mov eax, 50
	call Delay
	call ReadKey
	jz LookForKey
	ret
Question1 ENDP

BuildNewMap PROC
	mov Row_Up, 0
	mov Row_Down, 24
	mov Col_Left, 0
	mov Col_Right, 66
	mov dl, 1
	mov dh, 1
	call GotoXY
	mov current_X, 0
	mov current_Y, 1
RERANDOMIZE:
	mov eax, 1
	call Delay
	call Randomize                 ; re-seed
	call Random32
	mov TMP, al                    ; if color is gray
	and TMP, 11110000b             ; |
	cmp TMP, 10000000b             ; then re-randomize
	je RERANDOMIZE
	mov al, TMP
	mov ah, 0						; no grid it's ugly
	call SetTextColor
	cmp current_X, 65
	jge ADDY
	inc current_X
	jmp L0
AddY:
	mov current_X, 1
	inc current_Y
	cmp current_Y, 24
	jge L_Quit
L0:
	mov dl, current_X
	mov dh, current_Y
	call GotoXY
	mov al, ' '
	call WriteChar
	jmp RERANDOMIZE
L_Quit:
	ret
BuildNewMap ENDP

DrawBlueFrame PROC
	mov dl, 0
	mov dh, 0
	call GotoXY
	cmp ShowingFrame, 1
	je Show
	cmp ShowingFrame, 0
	je Hide
Show:
	mov eax, black + blue * 16
	call SetTextColor
	jmp L0
Hide:
	mov eax, black + gray * 16
	call SetTextColor
	jmp L0
L0:
	mov Num_Chars_X, 66
	mov Num_Chars_Y, 24
	call DrawOneFrame
	ret
DrawBlueFrame ENDP

DrawOneFrame PROC
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
L0:
	mov al, ' '
	call WriteChar
	add dl, X_UNIT
	add dh, Y_UNIT
	call GotoXY
	loop L0
	ret
DrawOneLine ENDP

HandleKeyEvent PROC
LookForKey:
	mov eax, 10
	call Delay
	call ReadKey
	jz LookForKey
	cmp al, 'r'
	je L0
	cmp al, 'w'
	je L1
	cmp al, 'a'
	je L2
	cmp al, 's'
	je L3
	cmp al, 'd'
	je L4
	cmp al, 'f'
	je L5
	cmp al, 'q'
	je L6
	jmp L_Quit
L0:
	call BuildNewMap
	jmp L_Quit
L1:
	call Delete_Up
	jmp L_Quit
L2:
	call Delete_Left
	jmp L_Quit
L3:
	call Delete_Down
	jmp L_Quit
L4:
	call Delete_Right
	jmp L_Quit
L5:
	call ShowHideFrame
	jmp L_Quit
L6:
	call ShowInformation
	jmp L_Quit
L_Quit:
	ret
HandleKeyEvent ENDP

ShowHideFrame PROC
	cmp ShowingFrame, 1
	je Hide
	cmp ShowingFrame, 0
	je Show
	jmp L_Quit
Hide:
	mov ShowingFrame, 0
	call DrawBlueFrame
	jmp L_Quit
Show:
	mov ShowingFrame, 1
	call DrawBlueFrame
	jmp L_Quit
L_Quit:
	ret
ShowHideFrame ENDP

ShowInformation PROC USES eax,

	mov eax, blue + gray * 16
	call SetTextColor
	call Clrscr
	mWrite "Student ID: 0516021"
	call crlf
	mWrite "Name: 楊家安"
	call crlf
	mWrite "Email: gxxygxxy@gmail.com"
	call crlf
LookForKey:
	mov eax, 50
	call Delay
	call ReadKey
	jz LookForKey
	exit
	ret
ShowInformation ENDP

Delete_Up PROC USES eax,

	mov al, Row_Down
	dec al
	cmp Row_Up, al
	jge L_Quit
	mov dl, Col_Left
	mov dh, Row_Up
	inc dh
	mov delete_X, dl
	mov delete_Y, dh
	call GotoXY
	mov eax, black + gray * 16
	call SetTextColor
L0:
	inc delete_X
	mov al, Col_Right
	cmp delete_X, al
	jge ADDY
	mov dl, delete_X
	mov dh, delete_Y
	call GotoXY
	mov al, ' '
	call WriteChar
	loop L0
ADDY:
	inc Row_Up
L_Quit:
	ret
Delete_Up ENDP

Delete_Down PROC USES eax,

	mov al, Row_Up
	inc al
	cmp Row_Down, al
	jle L_Quit
	mov dl, Col_Left
	mov dh, Row_Down
	dec dh
	mov delete_X, dl
	mov delete_Y, dh
	call GotoXY
	mov eax, black + gray * 16
	call SetTextColor
L0:
	inc delete_X
	mov al, Col_Right
	cmp delete_X, al
	jge SUBY
	mov dl, delete_X
	mov dh, delete_Y
	call GotoXY
	mov al, ' '
	call WriteChar
	loop L0
SUBY:
	dec Row_Down
L_Quit:
	ret
Delete_Down ENDP

Delete_Left PROC USES eax,

	mov al,  Col_Right
	dec al
	cmp Col_Left, al
	jge L_Quit
	mov dl, Col_Left
	mov dh, Row_Up
	inc dl
	mov delete_X, dl
	mov delete_Y, dh
	call GotoXY
	mov eax, black + gray * 16
	call SetTextColor
L0:
	inc delete_Y
	mov al, Row_Down
	cmp delete_Y, al
	jge ADDX
	mov dl, delete_X
	mov dh, delete_Y
	call GotoXY
	mov al, ' '
	call WriteChar
	loop L0
ADDX:
	inc Col_Left
L_Quit:
	ret
Delete_Left ENDP

Delete_Right PROC USES eax,

	mov al,  Col_Left
	inc al
	cmp Col_Right, al
	jle L_Quit
	mov dl, Col_Right
	mov dh, Row_Up
	dec dl
	mov delete_X, dl
	mov delete_Y, dh
	call GotoXY
	mov eax, black + gray * 16
	call SetTextColor
L0:
	inc delete_Y
	mov al, Row_Down
	cmp delete_Y, al
	jge SUBX
	mov dl, delete_X
	mov dh, delete_Y
	call GotoXY
	mov al, ' '
	call WriteChar
	loop L0
SUBX:
	dec Col_Right
L_Quit:
	ret
Delete_Right ENDP
END main
