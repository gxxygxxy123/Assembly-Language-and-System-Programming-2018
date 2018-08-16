TITLE Homework02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Assembly Programming
;
; Student Name: 楊家安
; Student ID: 0516021
; Student Email Address: gxxygxxy@gmail.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prof. Sai-Keung Wong
; College of Computer Science
; National Chiao Tung University, Taiwan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Description
; Play a game
; Control a ship to move
; Use ReadKey to control the robot.
;
; Key Usage:
; 'e', 'c'
;

include Irvine32.inc
include Macros.inc

.data


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
QuitFlg				BYTE	0						; if the flag is 1, then quit
MoveFlg				BYTE	0						; if move, then the flag is 1
X_UNIT				BYTE ?							; direction of drawing frame
Y_UNIT				BYTE ?							; direction of drawing frame
Num_Chars_X			DWORD ?							; width of frame
Num_Chars_Y			DWORD ?							; height of frame
ShipColor			DWORD (black + yellow * 16)
DrawDelay			DWORD ?
ShipX_Old			SBYTE 5							; old position of ship
ShipY_Old			SBYTE 10						; old position of ship
ShipX				SBYTE 5							; current position of ship
ShipY				SBYTE 10						; current position of ship
KEY_UP				BYTE	'e'						; move upward
KEY_DOWN			BYTE	'c'						; move downward
KEY_QUIT			BYTE	' '						; quit
BackGroundColor DWORD	(lightGray + black * 16)
.code

main PROC
START:
	call ShowMenu									; To show the menu
	call ChooseOption								; to choose option
	mov eax, (lightGray + black * 16); default color
	call SetTextColor
	call Clrscr										; clean the screen
	loop START
	exit
main ENDP

ShowMenu PROC
	call Clrscr
	mov dl, 0
	mov dh, 0
	call GotoXY
	mov Num_Chars_X, 82								; width of frame
	mov Num_Chars_Y, 24								; height of frame
	mov eax, ShipColor								; color of frame (= shipcolor)
	call SetTextColor
	mov DrawDelay, 0
	call DrawOneFrame								; draw the frame around the optionsl
	mov eax, (lightGray + black * 16)
	call SetTextColor
	mov dl, 1				;X(horizon)
	mov dh, 1				;Y(vertical)
	call GotoXY
	mWrite "1) Change ship color"
	inc dh
	call GotoXY
	mWrite "2) Show a frame around the screen rectangular area"
	inc dh
	call GotoXY
	mWrite "3) Play now!!!"
	inc dh
	call GotoXY
	mWrite "4) Show author information"
	inc dh
	call GotoXY
	mWrite "5) Quit game"
	add dh, 2
	call GotoXY
	mWrite "Please enter an option......"
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
	exit
End_Pressed:
	ret
ChooseOption ENDP

Option1 PROC
	call Clrscr
	mov ecx, 20
L1:							; push the string to middle top
	mov al, ' '				; push the string to middle top
	call WriteChar			; push the string to middle top
	loop L1
	mWrite "Please select a color for the space ship"
	call Crlf
	mov eax, (black + lightblue * 16)
	call SetTextColor
	mov dl, 28
	mov dh, 1
	call GotoXY
	mov Num_Chars_X, 3		; draw the blue option frame(4x2)
	mov Num_Chars_Y, 1		; draw the blue option frame(4x2)
	mov DrawDelay, 0
	call DrawOneFrame		; draw the blue option frame(4x2)
	mov dl, 29
	mov dh, 3
	call GotoXY
	mov eax, (white + black * 16)
	call SetTextColor
	mWrite "1"
	;-----------------------
	mov eax, (black + lightgreen * 16)
	call SetTextColor
	mov dl, 36
	mov dh, 1
	call GotoXY
	mov Num_Chars_X, 3		; draw the green option frame(4x2)
	mov Num_Chars_Y, 1		; draw the green option frame(4x2)
	mov DrawDelay, 0
	call DrawOneFrame		; draw the green option frame(4x2)
	mov dl, 37
	mov dh, 3
	call GotoXY
	mov eax, (white + black * 16)
	call SetTextColor
	mWrite "2"
	;-----------------------
	mov eax, (black + yellow * 16)
	call SetTextColor
	mov dl, 44
	mov dh, 1
	call GotoXY
	mov Num_Chars_X, 3		; draw the yellow option frame(4x2)
	mov Num_Chars_Y, 1		; draw the yellow option frame(4x2)
	mov DrawDelay, 0
	call DrawOneFrame		; draw the yellow option frame(4x2)
	mov dl, 45
	mov dh, 3
	call GotoXY
	mov eax, (white + black * 16)
	call SetTextColor
	mWrite "3"
	;-----------------------
LookForKey:
	mov eax, 50
	call Delay
	call ReadKey
	jz LookForKey
	cmp al, '1'
	je SelectBlue
	cmp al, '2'
	je SelectGreen
	cmp al, '3'
	je SelectYellow
	jmp LookForKey			; not in the selection list
SelectBlue:
	mov ShipColor, (black + lightblue * 16)
	call PlaySound
	jmp End_Pressed
SelectGreen:
	mov ShipColor, (black + lightgreen * 16)
	call PlaySound
	jmp End_Pressed
SelectYellow:
	mov ShipColor, (black + yellow * 16)
	call PlaySound
	jmp End_Pressed
End_Pressed:
	ret
Option1 ENDP

Option2 PROC
	call Clrscr
	mov dl, 0
	mov dh, 0
	call GotoXY
	mov DrawDelay, 50				; draw frame delay 50 msec
	mov Num_Chars_X, 82				; width of frame
	mov Num_Chars_Y, 24				; height of frame
	mov eax, ShipColor
	call SetTextColor
	call DrawOneFrame
LookForKey:
	mov eax, 50
	call Delay
	call ReadKey
	jz LookForKey
	ret
Option2 ENDP

Option3 PROC
	; intitialze
	mov Quitflg, 0
	; initial the position
	mov ShipX_Old, 5
	mov ShipY_Old, 10
	mov ShipX, 5
	mov ShipY, 10
	call Clrscr
	; draw the frame edge
	mov eax, ShipColor
	call SetTextColor
	mov DrawDelay, 0
	mov dl, 0
	mov dh, 0
	call GotoXY
	mov Num_Chars_X, 82		; width of frame
	mov Num_Chars_Y, 24		; height of frame
	call DrawOneFrame		; draw the frame
	call ShowShip			; show the ship in the beginning
	call ControlShip		; playing the game
	ret
Option3 ENDP

Option4 PROC
	call Clrscr
	mov eax, (lightGray + black * 16)
	mWrite "Student ID: 0516021"
	call Crlf
	mWrite "Student name: 楊家安"
	call Crlf
	mWrite "Student email address: gxxygxxy@gmail.com"
	call Crlf
LookForKey:
	mov eax, 50
	call Delay
	call ReadKey
	jz LookForKey
	ret
Option4 ENDP

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
	mov eax, DrawDelay
	call Delay
	loop L1
	ret
DrawOneLine ENDP

ShowShip PROC					; show the ship in the position
	mov eax, ShipColor
	call SetTextColor
	mov dl, ShipX
	mov dh, ShipY
	call GotoXY
	mov al, ' '
	call WriteChar				; draw the ship
	call WriteChar				; draw the ship
	call WriteChar				; draw the ship
	ret
ShowShip ENDP

ClearShip PROC
	mov dl, ShipX_Old
	mov dh, ShipY_Old
	call GotoXY
	mov eax, BackGroundColor	; background color
	call SetTextColor
	mov al, ' '					; clean the ship
	call WriteChar
	call WriteChar
	call WriteChar
	ret
ClearShip ENDP

ControlShip PROC
L0:
	call SaveShipPosition		; save the ship position first
	call AutoMove				; move rightward
	call HandleKeyEvent			; use 'e' and 'c' to control
	cmp QuitFlg, 1				; if flg == 1 then quit
	je L1
	call ClearShip
	call ShowShip
	jmp L0
L1:
	ret
ControlShip ENDP

HandleKeyEvent PROC
	mov Moveflg, 0
	call ReadKey
	cmp al, KEY_UP
	je L0
	cmp al, KEY_DOWN
	je L1
	cmp al, KEY_QUIT
	je L2
	jmp L3
L0:
	call MoveUp
	jmp L3
L1:
	call MoveDown
	jmp L3
L2:
	mov QuitFlg, 1
	jmp L3
L3:
	ret
HandleKeyEvent ENDP

AutoMove PROC
	mov eax, 50					; delay 50 msec
	call Delay
	cmp ShipX, 79				; ship reaches the right side
	je L0
	inc ShipX
	jmp L_Quit
L0:								; return to the left side
	mov ShipX, 1
	jmp L_Quit
L_Quit:
	ret
AutoMove ENDP

SaveShipPosition PROC
	mov al, ShipX
	mov ShipX_Old, al
	mov al, ShipY
	mov ShipY_Old, al
	ret
SaveShipPosition ENDP

MoveUp PROC
	cmp ShipY, 1					;reach the top bound
	je L0
	dec ShipY
	mov Moveflg, 1
	jmp L_Quit
L0:
	mov ShipY, 23
	mov Moveflg, 1
L_Quit:
	ret
MoveUp ENDP

MoveDown PROC
	cmp ShipY, 23					; reach the bottom bound
	je L0
	inc ShipY
	mov Moveflg, 1
	jmp L_Quit
L0:
	mov ShipY, 1
	mov Moveflg, 1
L_Quit:
	ret
MoveDown ENDP

PlaySound PROC
	mov al, 7						; sound
	call WriteChar
	ret
PlaySound ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


END main

