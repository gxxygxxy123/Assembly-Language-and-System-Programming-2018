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
TITLE 

include Irvine32.inc
include Macros.inc

.data

MYBITMAP_WIDTH	DWORD 5
MYBITMAP_HEIGHT	DWORD 3
MYBITMAP1	BYTE	1,1,0,1,1,0,0,1,0,0,1,1,0,1,1
MYBITMAP2	BYTE	1,1,1,1,1,0,1,0,1,0,1,1,1,1,1
bitmap		BYTE	0
X_UNIT				BYTE ?
Y_UNIT				BYTE ?
Num_Chars_X			DWORD 66
Num_Chars_Y			DWORD 24
Map_X_UNIT			BYTE 0
Map_Y_UNIT			BYTE 0
tmp1				BYTE ?
tmp2				BYTE ?
tmp3				BYTE ?
current_X			BYTE ?
current_Y			BYTE ?
.code

main PROC
	call DrawGreenFrame
	mov current_X, 1
	mov current_Y, 1
	call GotoXY
LL0:
	call HandleKeyEvent
	loop LL0
	call ReadInt
	exit
main ENDP

DrawGreenFrame PROC
	mov dl, 0
	mov dh, 0
	call GotoXY
	mov eax, black + green * 16
	call SetTextColor
	mov Num_Chars_X, 66
	mov Num_Chars_Y, 24
	call DrawOneFrame
	ret
DrawGreenFrame ENDP

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
	cmp al, 'b'
	je L0
	cmp al, 'w'
	je L1
	cmp al, 'a'
	je L2
	cmp al, 's'
	je L3
	cmp al, 'd'
	je L4
	cmp al, ' '
	je L5
	cmp al, 'q'
	je L6
	cmp al, 27
	je L7
	jmp L_Quit
L0:
	call CleanMap
	mov bitmap, 1
	mov Map_X_UNIT, 0
	mov Map_Y_UNIT, 0
	call DrawBitMap
	jmp L_Quit
L1:
	cmp current_Y, 1
	jle LookForKey
	call CleanMap
	mov Map_X_UNIT, 0
	mov Map_Y_UNIT, -1
	call DrawBitMap
	jmp L_Quit
L2:
	cmp current_X, 1
	jle LookForKey
	call CleanMap
	mov Map_X_UNIT, -1
	mov Map_Y_UNIT, 0
	call DrawBitMap
	jmp L_Quit
L3:
	cmp current_Y, 21
	jge LookForKey
	call CleanMap
	mov Map_X_UNIT, 0
	mov Map_Y_UNIT, 1
	call DrawBitMap
	jmp L_Quit
L4:
	cmp current_X, 61
	jge LookForKey
	call CleanMap
	mov Map_X_UNIT, 1
	mov Map_Y_UNIT, 0
	call DrawBitMap
	jmp L_Quit
L5:
	call SwitchBitMap
	jmp L_Quit
L6:
	call ShowInformation
	jmp L_Quit
L7:
	mov eax, lightGray + black * 16
	call SetTextColor
	call Clrscr
	mWrite "Student ID: 0516021"
	call crlf
	mWrite "Name: 楊家安"
	call crlf
	mWrite "Press Enter to close the program"
	call crlf
	call ReadInt
	exit
L_Quit:
	ret
HandleKeyEvent ENDP

CleanMap PROC USES eax,

	mov dl, current_X
	mov dh, current_Y
	call GotoXY
	mov eax, lightGray + black * 16
	call SetTextColor
	mov ecx, MYBITMAP_HEIGHT
L0:
	push ecx
	mov ecx, MYBITMAP_WIDTH
L1:
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	loop L1

	mov dl, current_X
	inc dh
	call GotoXY
	pop ecx
	loop L0
	ret
CleanMap ENDP

DrawBitMap PROC
	mov dl, current_X
	mov dh, current_Y
	add dl, Map_X_UNIT
	add dh, Map_Y_UNIT
	call GotoXY
	mov current_X, dl
	mov current_Y, dh
	mov eax, blue + yellow * 16
	call SetTextColor
	cmp bitmap, 1
	je BITMAP1
	cmp bitmap, 2
	je BITMAP2
	jmp L_Quit
BITMAP1:
	mov esi, 0
L0:
	mov ecx, MYBITMAP_WIDTH
L4:
	cmp esi, LENGTHOF MYBITMAP1
	jge L_Quit
	mov al, [MYBITMAP1+esi]
	cmp al, 0
	je L1
	cmp al, 1
	je L2
L1:
	inc dl
	jmp L3
L2:
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	jmp L3
L3:
	inc esi
	loop L4
	mov dl, current_X
	inc dh
	call GotoXY
	loop L0
	jmp L_Quit
BITMAP2:
	mov esi, 0
L5:
	mov ecx, MYBITMAP_WIDTH
L9:
	cmp esi, LENGTHOF MYBITMAP2
	jge L_Quit
	mov al, [MYBITMAP2+esi]
	cmp al, 0
	je L6
	cmp al, 1
	je L7
L6:
	inc dl
	jmp L8
L7:
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	jmp L8
L8:
	inc esi
	loop L9
	mov dl, current_X
	inc dh
	call GotoXY
	loop L5
	jmp L_Quit
L_Quit:
	ret
DrawBitMap ENDP

SwitchBitMap PROC
	cmp bitmap, 1
	je L1
	cmp bitmap, 2
	je L2
L1:
	mov bitmap, 2
	jmp L_Quit
L2:
	mov bitmap, 1
	jmp L_Quit
L_Quit:
	call CleanMap
	mov Map_X_UNIT, 0
	mov Map_Y_UNIT, 0
	call DrawBitMap
	ret
SwitchBitMap ENDP
	
ShowInformation PROC USES eax,

	mov eax, white + black * 16
	call SetTextColor
	call CleanMap
	mov dl, 1
	mov dh, 1
	call GotoXY
	mWrite "Student ID: 0516021"
	mov dl, 1
	mov dh, 2
	call GotoXY
	mWrite "Name: 楊家安"
	ret
ShowInformation ENDP
DEBUG PROC USES eax,

	mov eax, white+red*16
	call SetTextColor
	mov al,'p'
	call WriteChar
	ret
DEBUG ENDP	
END main

