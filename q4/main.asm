;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; National Chiao Tung University
; Department Of Computer Science
; 
; Assembly Programming Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write programs in the Release mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $Student Name:	Chia-An
; $Student ID:	0516021
; $Student Email:	gxxygxxy@gmail.com
;
; Instructor Name: Sai-Keung Wong 
; Date: 2018/05/17
;
TITLE 

include Irvine32.inc
include Macros.inc

.data
X_UNIT	BYTE ?
Y_UNIT	BYTE ?
Num_Chars_X     DWORD   ?
Num_Chars_Y     DWORD   ?
Map_X			BYTE	?
Map_Y			BYTE	?
Dontprint1		BYTE	?
Dontprint2		BYTE	?
DontArray		BYTE	100 DUP(?)
AI_posX			BYTE	65
AI_posY			BYTE	1
YOU_posX		BYTE	65
YOU_posY		BYTE	23
up_difference	BYTE	100
down_difference	BYTE	100
counter			DWORD	1
flg_stop		BYTE	0
flg_Win			BYTE	0
.code

main PROC

RESET:
	mov eax, black+black*16
	call SetTextColor
	call Clrscr
	mov dl, 0
	mov dh, 0
	call GotoXY
	mov Num_Chars_X, 66
	mov Num_Chars_Y, 24
	call DrawBlueFrame
	call BuildMap
	mov counter, 1
L0:
	call HandleKey
	cmp YOU_posX, 1
	jle L_YouWin
	cmp AI_posX, 1
	jle L_ProgramWin
	jmp L0
L_YouWin:
	mov dl, 25
	mov dh, 0
	call GotoXY
	mov eax, black + yellow*16
	call SetTextColor
	mWrite "You win!"
	jmp L_Quit
L_ProgramWin:
	mov dl, 22
	mov dh, 0
	call GotoXY
	mov eax, black + yellow*16
	call SetTextColor
	mWrite "Program win!"
	jmp L_Quit
L_Quit:
LookForKey:
	mov eax, 1
	call Delay
	call ReadKey
	cmp al, 'r'
	je RESET
	cmp al, 'q'
	je ShowInformation
	jmp LookForKey
ShowInformation:
	mov dl, 0
	mov dh, 25
	call GotoXY
	mov eax, lightgray + black*16
	call SetTextColor
	mWrite "Student ID: 0516021"
	call Crlf
	mWrite "Name: Chia-An Yang"
	call Crlf
	mWrite "Email: gxxygxxy@gmail.com"
	jmp LookForKey
	call ReadInt
	exit
main ENDP

DrawBlueFrame PROC
	mov ah, 0                      ; no grid it's ugly
	mov eax, black + blue * 16
	call SetTextColor              ; color in al(8bits)
	; draw from left to right
	mov ecx, Num_Chars_X
	mov X_UNIT, 1
	mov Y_UNIT, 0
	call DrawOneLine
	; draw from top to bottom
	mov ecx, Num_Chars_Y
	mov X_UNIT, 0
	mov Y_UNIT, 1
	call DrawOneLine
	; draw from right to left
	mov ecx, Num_Chars_X
	mov X_UNIT, -1
	mov Y_UNIT, 0
	call DrawOneLine
	; draw from bottom to top
	mov ecx, Num_Chars_Y
	mov X_UNIT, 0
	mov Y_UNIT, -1
	call DrawOneLine
	ret
DrawBlueFrame ENDP

BuildMap PROC
	mov eax, black+black*16
	call SetTextColor
	call Crlf
	mov flg_stop, 0
	mov flg_Win, 0
	mov AI_posX, 65
	mov YOU_posX, 65
	mov AI_posY, 1
	mov YOU_posY, 23
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, red+red*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, yellow+yellow*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	mov eax, blue + blue * 16
	call SetTextColor
	call Randomize 
	mov Map_X, 66
	mov Map_Y, 0
	call GotoXY
	mov edi, OFFSET DontArray
	mov ecx, 32
L0:
	sub Map_X, 2
	mov Map_Y, 0
	push ecx
	mov ecx, Num_Chars_Y
	sub ecx, 1
	mov eax, 23					; 0~22
	call RandomRange
	inc al
	mov Dontprint1, al
Re:
	mov eax, 23
	call RandomRange			; 0~22
	inc al						; 1~23
	cmp Dontprint1, al
	je Re
	mov Dontprint2, al
	
	mov bl, Dontprint1
	mov [edi], bl
	add edi, 1
	mov bl, Dontprint2
	mov [edi], bl
	add edi, 1
L1:
	call DrawWall
	mov bl, Map_Y
	cmp Dontprint1, bl
	je L_Dont
	cmp Dontprint2, bl
	je L_Dont
	mov al, ' '
	call WriteChar
L_Dont:
	loop L1
	pop ecx
	loop L0
	ret
BuildMap ENDP

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

DrawWall PROC USES ebx edx,

	inc Map_Y
	mov bl, Map_X
	mov dl, bl
	mov bh, Map_Y
	mov dh, bh
	call GotoXY
	ret
DrawWall ENDP

HandleKey PROC

LookForKey:
	mov eax, 1
	call Delay
	inc counter
	cmp counter, 110
	je L_AI
	call ReadKey
	jz LookForKey
	cmp al, ' '
	je Stop
	cmp flg_stop, 1
	je L_Quit
	cmp al, 'r'
	je Reset
	cmp al, 'q'
	je ShowInformation
	cmp al, 'w'
	je Up
	cmp al, 's'
	je Down
	cmp al, 'a'
	je Left
	cmp al, 'd'
	je Right
	jmp L_Quit
Stop:
	cmp flg_stop, 0
	je LL
	mov flg_stop, 0
	jmp L_Quit
LL:
	mov flg_stop, 1
	jmp L_Quit
Reset:
	mov eax, black+black*16
	call SetTextColor
	call Clrscr
	mov dl, 0
	mov dh, 0
	call GotoXY
	mov Num_Chars_X, 66
	mov Num_Chars_Y, 24
	call DrawBlueFrame
	call BuildMap
	mov counter, 1
	jmp L_Quit
ShowInformation:
	mov dl, 0
	mov dh, 25
	call GotoXY
	mov eax, lightgray + black*16
	call SetTextColor
	mWrite "Student ID: 0516021"
	call Crlf
	mWrite "Name: Chia-An Yang"
	call Crlf
	mWrite "Email: gxxygxxy@gmail.com"
	jmp L_Quit
Up:
	call _Up
	jmp L_Quit
Down:
	call _Down
	jmp L_Quit
Left:
	call _Left
	jmp L_Quit
Right:
	call _Right
	jmp L_Quit
L_AI:
	call AImove
	mov counter, 0
	jmp L_Quit
L_Quit:
	ret
HandleKey ENDP

_Up PROC USES edx,

	mov al, YOU_posY
	cmp al, 1
	jle L_Quit
	mov al, YOU_posX
	;movzx ax, al
	cbw
	mov bl, 2
	idiv bl
	cmp ah, 0			;remainder : ah
	je	L_Even			;even
L_Move:
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	sub YOU_posY, 1
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, yellow + yellow*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	jmp L_Quit
L_Even:
	mov al, 64
	sub al, YOU_posX
	cbw
	cwd
	mov edi, OFFSET DontArray
	add edi, eax
	mov bl, YOU_posY
	dec bl
	cmp [edi], bl
	je L_Move
	add edi, 1
	cmp [edi], bl
	je L_Move
L_Quit:
	ret
_Up ENDP
_Down PROC USES edx,

	mov al, YOU_posY
	cmp al, 23
	jge L_Quit
	mov al, YOU_posX
	cbw
	mov bl, 2
	idiv bl
	cmp ah, 0			;remainder : ah
	je	L_Even			;even
L_Move:
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	add YOU_posY, 1
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, yellow + yellow*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	jmp L_Quit
L_Even:
	mov al, 64
	sub al, YOU_posX
	cbw
	cwd
	mov edi, OFFSET DontArray
	add edi, eax
	mov bl, YOU_posY
	inc bl
	cmp [edi], bl
	je L_Move
	add edi, 1
	cmp [edi], bl
	je L_Move
L_Quit:
	ret
_Down ENDP
_Left PROC USES ebx edi,

	cmp YOU_posX, 1
	jle L_Quit
	mov al, YOU_posX
	cbw
	mov bl, 2
	idiv bl
	cmp ah, 0			;remainder : ah
	je	L_Move			;even
	mov al, 65
	sub al, YOU_posX
	cbw
	cwd
	mov edi, OFFSET DontArray
	add edi, eax
	mov bl, YOU_posY
	cmp [edi], bl
	je L_Move
	add edi, 1
	cmp [edi], bl
	je L_Move
	jmp L_Quit
L_Move:
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	sub YOU_posX, 1
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, yellow + yellow*16
	call SetTextColor
	mov al, ' '
	call WriteChar
L_Quit:
	ret
_Left ENDP
_Right PROC USES ebx edi,

	cmp YOU_posX, 65
	jge L_Quit
	mov al, YOU_posX
	cbw
	mov bl, 2
	idiv bl
	cmp ah, 0			;remainder : ah
	je	L_Move			;even
	mov al, 63
	sub al, YOU_posX
	cbw
	cwd
	mov edi, OFFSET DontArray
	add edi, eax
	mov bl, YOU_posY
	cmp [edi], bl
	je L_Move
	add edi, 1
	cmp [edi], bl
	je L_Move
	jmp L_Quit
L_Move:
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	add YOU_posX, 1
	mov dl, YOU_posX
	mov dh, YOU_posY
	call GotoXY
	mov eax, yellow + yellow*16
	call SetTextColor
	mov al, ' '
	call WriteChar
L_Quit:
	ret
_Right ENDP

AImove PROC	USES ebx edi,

	cmp flg_stop, 1
	je L_Quit
	cmp AI_posX, 1
	je L_Win
	mov al, AI_posX
	cbw
	mov bl, 2
	idiv bl
	cmp ah, 0			;remainder : ah
	je	L_Even			;even
	jmp L_Odd
	jmp L_Quit
L_Even:
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	sub AI_posX, 1
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, red + red*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	jmp L_Quit
L_Odd:
	mov al, 65
	sub al, AI_posX
	cbw
	cwd
	mov edi, OFFSET DontArray
	add edi, eax
	mov bl, AI_posY
	cmp [edi], bl
	je L_Left
	add edi, 1
	cmp [edi], bl
	je L_Left
	jmp L_UpDown
	jmp L_Quit
L_Left:
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	sub AI_posX, 1
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, red + red*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	jmp L_Quit
L_UpDown:
	mov up_difference, 100
	mov down_difference, 100
	mov al, 65
	sub al, AI_posX
	cbw
	cwd
	mov edi, OFFSET DontArray
	add edi, eax
	mov bl, [edi]
	cmp bl, AI_posY
	jle L_small_1				; hole 1 is above
	jmp L_big_1
L_small_1:
	mov al, AI_posY
	sub al, bl
	mov up_difference, al
	jmp L_out
L_big_1:
	mov al, bl
	sub al, AI_posY
	mov down_difference, al
	jmp L_out
L_out:
	add edi, 1
	mov bl, [edi]
	cmp bl, AI_posY
	jle L_small_2
	jmp L_big_2
L_small_2:
	mov al, AI_posY
	sub al, bl
	cmp al, up_difference
	jl L0
	jmp L_out2
L0:
	mov up_difference, al
	jmp L_out2
L_big_2:
	mov al, bl
	sub al, AI_posY
	cmp al, down_difference
	jl L1
	jmp L_out2
L1:
	mov down_difference, al
	jmp L_out2
L_out2:
	mov bl, up_difference
	cmp bl, down_difference
	jl L_goUp
	jmp L_goDown
L_goUp:
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	sub AI_posY, 1
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, red + red*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	jmp L_Quit
L_goDown:
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, black + black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	add AI_posY, 1
	mov dl, AI_posX
	mov dh, AI_posY
	call GotoXY
	mov eax, red + red*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	jmp L_Quit
L_Win:
	mov flg_Win, 1
	jmp L_Quit
L_Quit:
	ret
AImove ENDP
END main
