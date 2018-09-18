
;========================================================
; Student Name: Chia-An Yang
; Student ID: 0516021
; Email: gxxygxxy@gmail.com
;========================================================
; Instructor: Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: 706
; Assembly Language 
; Date: 2018/05
;========================================================
; Description:
;
; IMPORTANT: always save EBX, EDX, EDI and ESI as their
; values are preserved by the callers in C calling convention.
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

invisibleDigitX  TEXTEQU %(-100000)
invisibleDigitY  TEXTEQU %(-100000)

; PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C


.data 
colors BYTE 01ch
colorOriginal BYTE 01ch

MYINFO	BYTE "My Student Name: Chia-An Yang, StudentID: 0516021",0 

OpenMsgDelay	DWORD	25
EnterStageDelay	DWORD	50

MyMsg BYTE "Final Project for Assembly Language...",0dh, 0ah
BYTE "My Student Name: Chia-An Yang",0dh, 0ah 
BYTE "My student ID: 0516021.", 0dh, 0ah, 0dh, 0ah
BYTE "My Email is: gxxygxxy@gmail.com.", 0dh, 0ah, 0dh, 0ah
BYTE "Make sure the screen dimension is (120, 30).", 0dh, 0ah, 0dh, 0ah
BYTE "Key usages:", 0dh, 0ah
BYTE "x (flip), y (flip)", 0dh, 0ah
BYTE "w (gray), g (grid)", 0dh, 0ah
BYTE "a (reset), b (blue)", 0dh, 0ah
BYTE "1-5: point size", 0dh, 0ah
BYTE "8:2x4, 9:4x8, 0:8x8", 0dh, 0ah
BYTE "< (blending), > (blending)", 0

CaptionString BYTE "Student Name: Chia-An Yang",0
MessageString BYTE "Welcome to Wonderful World", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0516021", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: gxxygxxy@gmail.com.", 0dh, 0ah, 0dh, 0ah
				BYTE "'1','2','3','4' and '5': change image point size ", 0dh, 0ah
				BYTE "'i': toggle to show or hide the student ID", 0dh, 0ah
				BYTE "'a': change the current image to back to the initial flower and change it to yellow", 0dh, 0ah
				BYTE "'s': switch the image between gray image and initial image", 0dh, 0ah
				BYTE "'g': toggle the game mode state. If in game mode, show the grid.", 0dh, 0ah
				BYTE "'x': flip the current image horizontally", 0dh, 0ah
				BYTE "'y': turn the current image upside-down ", 0dh, 0ah
				BYTE "mouse : select and exchange the images for two selected grid cells", 0dh, 0ah
				BYTE "ESC : show student information and press Enter to quit the program", 0dh, 0ah
				BYTE "Enjoy playing!", 0
CaptionString_EndingMessage BYTE "Student Name: Chia-An Yang",0
MessageString_EndingMessage BYTE "Thanks for playing...", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0516021", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: gxxygxxy@gmail.com.", 0dh, 0ah, 0dh, 0ah
				BYTE "See you later!", 0

EndingMsg BYTE "Thanks for playing.", 0

windowWidth		DWORD 8000
windowHeight	DWORD 8000

scaleFactor	DWORD	128
canvasMinX	DWORD -4000
canvasMaxX	DWORD 4000
canvasMinY	DWORD -4000
canvasMaxY	DWORD 4000
;
particleRangeMinX REAL8 0.0
particleRangeMaxX REAL8 0.0
particleRangeMinY REAL8 0.0
particleRangeMaxY REAL8 0.0
;
tmpParticleY DWORD ?
;
particleSize DWORD  2
numParticles DWORD 20000
particleMaxSpeed DWORD 3

flgQuit		DWORD	0
numObjects	DWORD	1024
objPosX		SDWORD	512 DUP(100000)
objPosY		SDWORD	512 DUP(100000)
objPosX_tmp	SDWORD	512 DUP(100000) ;mine
objPosY_tmp	SDWORD	512 DUP(100000) ;mine
objnumbers	SDWORD	0				;mine
objTypes	BYTE	512 DUP(1)
objSpeedX	SDWORD	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	512 DUP(?)
objSpeedY	SDWORD	2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	512 DUP(?)			
objColor	DWORD	1536 DUP(255)
studentObjColor	DWORD	1024 DUP(?)
goMsg		BYTE "Final Project for Assembly Language. Let's start...", 0
bell		BYTE 0,0, 0
					
testDBL	REAL4	3.141592654
zero REAL8 0.0

studentIDDigit DWORD 0
studentID	DWORD 0, 1, 2, 3, 4, 5, 6

particleState BYTE 0
negOne REAL8 -1.0

DIGIT_ALL		BYTE 1, 1, 1, 1
				BYTE 1, 1, 1, 1
				BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 1
				BYTE 1, 1, 1, 1

DIGIT_MO_0		BYTE 0, 0, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
DIGIT_MO_SIZE = ($-DIGIT_MO_0)				
DIGIT_MO_1		BYTE 0, 1, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
				
DIGIT_MO_2		BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
				
DIGIT_MO_3		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
				
DIGIT_MO_4		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
				
DIGIT_MO_5		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
				
DIGIT_MO_6		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh

DIGIT_MO_7		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 0, 0, 0, 0ffh

DIGIT_MO_8		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 0, 0, 1, 0ffh

				
DIGIT_MO_9		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 0, 1, 1, 0ffh

DIGIT_MO_10		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh
				
DIGIT_MO_11		BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh
				
DIGIT_MO_12		BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh
				
DIGIT_MO_13		BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 1, 1, 0ffh
												
DIGIT_INDEX		DWORD	0
TOTALDIGITS		DWORD	13


DIGIT_0			BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh
DIGIT_SIZE = ($-DIGIT_0)				
DIGIT_1			BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0ffh
				
DIGIT_2			BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0ffh
				
DIGIT_5			BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh

DIGIT_6			BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh

stage				DWORD 0
currentDigit			DWORD 0
objPosForOneDigitX	SDWORD 1000 DUP(0)
objPosForOneDigitY	SDWORD 1000 DUP(0)
digitX SDWORD -8000
digitY SDWORD 25000
digit_Left	SDWORD -8000
digit_Right	SDWORD -8000
digitTimer DWORD 0
colorTimer DWORD 0
colorIndex DWORD 0

offsetImage DWORD 0

digitOffsetX DWORD 0
digitSpacingDFTWidth DWORD	2000
digitSpacingDFTHeight DWORD 2000

digitSpacingWidth DWORD	2000
digitSpacingHeight DWORD 2000

digitMaxSpeed DWORD 100
digitMaxDFTSpeed DWORD 10

digitWidth DWORD 0

totalColors	DWORD	0
colorRed	BYTE	10000 DUP(0)
colorGreen	BYTE	10000 DUP(0)
colorBlue	BYTE	10000 DUP(0)

openingMsg	BYTE	"This program shows the student ID using bitmap and manipulates images....", 0dh
			BYTE	"Great programming.", 0
movementDIR	BYTE 0
state		BYTE	0

imagePercentage DWORD	0

mImageStatus DWORD 0
mImagePtr0 BYTE 200000 DUP(?)
mImagePtr1 BYTE 200000 DUP(?)
mImagePtr2 BYTE 200000 DUP(?)
mTmpBuffer0 BYTE	200000 DUP(?)					; display
mTmpBuffer1 BYTE	200000 DUP(?)
mTmpPlace0	BYTE	200000 DUP(?)
mTmpPlace1	BYTE	200000 DUP(?)
mImageWidth DWORD 0
mImageHeight DWORD 0
mBytesPerPixel DWORD 0
mImagePixelPointSize DWORD 6

mFlipX DWORD 0
mFlipY DWORD 1
mEnableBrighter DWORD 0
mAmountOfBrightness DWORD 1
mBrightnessDirection DWORD 0

				;x, y, width, height	
mSubImage		DWORD	0, 0, 30, 30
mShowAtLocation	DWORD	30, 30
;
;

;width and height
GridDimensionW	DWORD	8
GridDimensionH	DWORD	8
GridCellW			DWORD	1
GridCellH			DWORD	1
CurGridX		DWORD	0
CurGridY		DWORD	0
flgPickedGrid	DWORD	0
PickedGridX		DWORD	-1
PickedGridY		DWORD	-1

OldPickedGridX		DWORD	-1
OldPickedGridY		DWORD	-1

GridColorRed		BYTE	0
GridColorGreen		BYTE	0
GridColorBlue		BYTE	0


FlgSaveImage		BYTE	0
FlgRestoreImage		BYTE	0
FlgShowGrid			BYTE	0	;2
FlgYellowFlower		BYTE	0	;3
FlgBrigtenImage		BYTE	0	;4
FlgDarkenImage		BYTE	0	;5
FlgGrayLevelImage	BYTE	0	;6

programState		BYTE	0
;;;;;;;mine
flag_horizon		BYTE	0			; useless
flag_vertical		BYTE	0			; useless
flag_gray			BYTE	0			; check if the state is gray
flag_yellow			BYTE	0			; check if the state is yellow
flag_showdigit		BYTE	0			; check if it should show digit
flag_bounding		BYTE	0			; check the current direction
flag_gamemode		BYTE	0			; check if it is in game mode
grid_x				DWORD	?			; byte size of a grid cell in x-coordinate
grid_y				DWORD	?			; byte size of a grid cell in y-coordinate
flag_griddimension	BYTE	8			; first time pressing 'h' default 8
flag_colorstate		BYTE	0			; to compute the colorful grid
flag_target			BYTE	0			; check if the left button has been clicked once
target1_x			DWORD	1000		; the position of target in x-coordinate
target1_y			DWORD	1000		; the position of target in y-coordinate
target1_in_x		DWORD	100			; the number of grid cell of target in x-coordinate
target1_in_y		DWORD	100			; the number of grid cell of target in y-coordinate
game_size_x			DWORD	?			; record ? * y
game_size_y			DWORD	?			; record x * ?
Red_				BYTE	255			; for color state
Green_				BYTE	255			; for color	state
Blue_				BYTE	255			; for color state
cursorX				DWORD	?			; the position of cursor in x-coordinate
cursorY				DWORD	?			; the position of cursor in y-coordinate
cursor_in_x			DWORD	100			; the number of grid cell of cursor in x-coordinate
cursor_in_y			DWORD	100			; the number of grid cell of cursor in y-coordinate
.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitializeApp()
;
;This function is called
;at the beginning of the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitializeApp PROC C USES ebx edi esi edx
	mov al, blue + white*16
	or al, 88h
	mov ah, 080h
	call SetTextColor
mov dl, 0
mov dh, 16
mov edi, offset openingMsg
call gotoxy
P0:
mov al, [edi]
call writechar
;mov eax, 25
mov eax, 1
call delay
mov al, [edi]
inc edi
cmp al, 0
je P1
cmp al, 0dh
jne P0
inc dh
call gotoxy
jmp P0
P1:
	call Crlf
	mov eax, lightgreen+black*16
	call SetTextColor
	mWrite "Enter the maximum speed of a digit (integer)(default:100):"
	call ReadInt
	jz L0
	mov digitMaxSpeed, eax
L0:
	mov eax, blue+white*16
	call SetTextColor
	mWrite "Enter the spacing for the blocks along the X-axis (integer)(default:2000):"
	call ReadInt
	jz L1
	mov digitSpacingWidth, eax
L1:
	mWrite "Enter the spacing for the blocks along the Y-axis (integer)(default:2000):"
	call ReadInt
	jz L2
	mov digitSpacingHeight, eax
L2:
	mov ebx, OFFSET CaptionString
	mov edx, OFFSET MessageString
	call MsgBox
	ret
asm_InitializeApp ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void setCursor(int x, int y)
;
;Set the position of the cursor 
;in the console (text) window.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setCursor PROC C USES edx,
	x:DWORD, y:DWORD
	mov edx, y
	shl edx, 8
	xor edx, x
	call Gotoxy
	ret
setCursor ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ClearScreen()
;
;Clear the screen.
;We can set text color if you want.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ClearScreen PROC C
	mov al, 0
	mov ah, 0
	call SetTextColor
	call clrscr
	ret
asm_ClearScreen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ShowTitle()
;
;Show the title of the program
;at the beginning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ShowTitle PROC C USES edx
	INVOKE setCursor, 0, 0
	xor eax, eax
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset MyMsg
	call WriteString
	ret
asm_ShowTitle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitObjects()
;
;Initialize the objects,
;including the speed, colors, etc.
;That're up to you (programmers).
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitObjects PROC C USES esi edi
	;modify this procedure
	mov edi, OFFSET objPosX_tmp
	mov esi, OFFSET DIGIT_0
	call ShowDigit_X
	mov esi, OFFSET DIGIT_5
	call ShowDigit_X
	mov esi, OFFSET DIGIT_1
	call ShowDigit_X
	mov esi, OFFSET DIGIT_6
	call ShowDigit_X
	mov esi, OFFSET DIGIT_0
	call ShowDigit_X
	mov esi, OFFSET DIGIT_2
	call ShowDigit_X
	mov esi, OFFSET DIGIT_1
	call ShowDigit_X
	mov eax, digitSpacingWidth
	mov ebx, 26
	imul ebx
	add digit_Right, eax
	mov edi, OFFSET objPosY_tmp
	mov esi, OFFSET DIGIT_0
	call ShowDigit_Y
	mov esi, OFFSET DIGIT_5
	call ShowDigit_Y
	mov esi, OFFSET DIGIT_1
	call ShowDigit_Y
	mov esi, OFFSET DIGIT_6
	call ShowDigit_Y
	mov esi, OFFSET DIGIT_0
	call ShowDigit_Y
	mov esi, OFFSET DIGIT_2
	call ShowDigit_Y
	mov esi, OFFSET DIGIT_1
	call ShowDigit_Y
	ret
asm_InitObjects ENDP	

asm_computeCircularPosX PROC C
	fld testDBL
	ret
asm_computeCircularPosX ENDP

asm_GetNumParticles PROC C
mov eax, numParticles
ret
asm_GetNumParticles ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleMaxSpeed PROC C
mov eax, particleMaxSpeed
ret
asm_GetParticleMaxSpeed ENDP

;int asm_GetParticleSize()
;
;Return the particle size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSize PROC C
	mov eax, 2
	ret
asm_GetParticleSize ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMousePassiveEvent( int x, int y )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMousePassiveEvent PROC C USES eax ebx edx,
	x : DWORD, y : DWORD
	mov eax, x
	mov cursorX, eax		; mine
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mov cursorY, eax		; mine
	mWrite "y:"
	call WriteDec
	mWriteln " "	
	ret
asm_handleMousePassiveEvent ENDP



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMouseEvent(int button, int status, int x, int y)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMouseEvent PROC C USES ebx,
	button : DWORD, status : DWORD, x : DWORD, y : DWORD
	
	mWriteln "asm_handleMouseEvent"
	mov eax, button
	mWrite "button:"
	call WriteDec
	mWriteln " "
	mov eax, status
	mWrite "status:"
	call WriteDec
	mov eax, x
	mWriteln " "
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
	mov eax, windowWidth
	mWrite "windowWidth:"
	call WriteDec
	mWriteln " "
	mov eax, windowHeight
	mWrite "windowHeight:"
	call WriteDec
	mWriteln " "
	cmp flag_GameMode, 0
	je exit0
	cmp button, 0
	jne exit0
	cmp status, 0
	jne exit0
	;;;;;;;;;;;;;;					; if left mouse clicked
	cmp flag_target, 0
	je L0
	cmp flag_target, 1
	je L1
	jmp exit0
L0:
	mov eax, windowWidth			; compute the target1_in_x
	mov ebx, game_size_x
	cdq
	idiv ebx						; "4" x 2
	mov ebx, eax
	mov eax, x
	cdq
	idiv ebx
	mov target1_in_x, eax
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, windowHeight
	mov ebx, game_size_y
	cdq
	idiv ebx						; 4 x "2"
	mov ebx, eax
	mov eax, y
	cdq
	idiv ebx
	mov target1_in_y, eax
	mov flag_target, 1
	jmp exit0
L1:
	call Switch_Cell
	jmp exit0
exit0:
	ret
asm_handleMouseEvent ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_HandleKey(int key)
;
;Handle key events.
;Return 1 if the key has been handled.
;Return 0, otherwise.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_HandleKey PROC C, 
	key : DWORD
	mov eax, key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	cmp al, '8'
	je Eight
	cmp al, '9'
	je Nine
	cmp al, '0'
	je Zeroo
	cmp al, 'i'
	je Toggle
	cmp al, 'a'
	je Initial_flower
	cmp al, 's'
	je Switch
	cmp al, 'g'
	je Game
	cmp al, 'x'
	je Flip_horizon
	cmp al, 'y'
	je Flip_vertical
	cmp al, 27
	je ESCAPE
	jmp L_Quit
One:
	mov mImagePixelPointSize, 1
	jmp L_Quit
Two:
	mov mImagePixelPointSize, 2
	jmp L_Quit
Three:
	mov mImagePixelPointSize, 3
	jmp L_Quit
Four:
	mov mImagePixelPointSize, 4
	jmp L_Quit
Five:
	mov mImagePixelPointSize, 5
	jmp L_Quit
Eight:
	mov game_size_x, 4
	mov game_size_y, 2
	mov flag_griddimension, 8
	cmp flag_GameMode, 1
	jne Lno1
	call CopyToBuffer0
	call CopyToPlace0
	mov flag_gray, 0
	mov flag_target, 0
	call _4x2
	call CopyFromPlace0ToBuffer0
Lno1:
	jmp L_Quit
Nine:
	mov game_size_x, 8
	mov game_size_y, 4
	mov flag_griddimension, 9
	cmp flag_GameMode, 1
	jne Lno2
	call CopyToBuffer0
	call CopyToPlace0
	mov flag_gray, 0
	mov flag_target, 0
	call _8x4
	call CopyFromPlace0ToBuffer0
Lno2:
	jmp L_Quit
Zeroo:
	mov game_size_x, 8
	mov game_size_y, 8
	mov flag_griddimension, 0
	cmp flag_GameMode, 1
	jne Lno3
	call CopyToBuffer0
	call CopyToPlace0
	mov flag_gray, 0
	mov flag_target, 0
	call _8x8
	call CopyFromPlace0ToBuffer0
Lno3:
	jmp L_Quit
Toggle:
	xor flag_showdigit, 1
	cmp flag_showdigit, 0
	je No_Show
	mov esi, OFFSET objPosX_tmp
	mov edi, OFFSET objPosX
	mov ecx, 512
	cld
	rep movsd
	mov esi, OFFSET objPosY_tmp
	mov edi, OFFSET objPosY
	mov ecx, 512
	cld
	rep movsd
	jmp L_Quit
No_Show:
	mov edi, OFFSET objPosX
	mov ecx, 512
	mov eax, 100000
L_noshowx:
	mov [edi], eax
	add edi, 4
	loop L_noshowx
	mov edi, OFFSET objPosY
	mov ecx, 512
	mov eax, 100000
L_noshowy:
	mov [edi], eax
	add edi, 4
	loop L_noshowy
	jmp L_Quit
Initial_flower:
	call Change_yellow
	jmp L_Quit
Switch:
	call Switch_Gray
	jmp L_Quit
Game:
	call GameMode
	jmp L_Quit
Flip_horizon:
	call FlipHorizon
	jmp L_Quit
Flip_vertical:
	call FlipVertical
	jmp L_Quit
ESCAPE:
	call asm_EndingMessage
	;mov al, white + blue*16
	;mov ah, 01h
	;call SetTextColor
	;mWriteLn "Thanks for playing..."
	;mWriteLn "My student name is Chia-An Yang"
	;mWriteLn "My student ID is: 0516021."
	;mWriteLn "Press ENTER to quit."
	;call ReadInt
	;exit
	;mov state, 0
L_Quit:
	;mov eax, 0
	ret
asm_HandleKey ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_EndingMessage()
;
;This function is called
;when the program exits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_EndingMessage PROC C USES ebx edx
	mov ebx, OFFSET CaptionString_EndingMessage
	mov edx, OFFSET MessageString_EndingMessage
	call MsgBox
	;mov ah, 0h
	;mov al, 0e1h
	;call SetTextColor
	;mov edx, offset EndingMsg
	;call WriteString
	ret
asm_EndingMessage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
;
;w: window resolution (i.e. number of pixels) along the x-axis.
;h: window resolution (i.e. number of pixels) along the y-axis. 
;scaledWidth : scaled up width
;scaledHeight : scaled up height
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_SetWindowDimension PROC C USES ebx,
	w: DWORD, h: DWORD, scaledWidth : DWORD, scaledHeight : DWORD
	mov ebx, offset windowWidth
	mov eax, w
	mov [ebx], eax
	mov eax, scaledWidth
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxX
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinX
	mov [ebx], eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, offset windowHeight
	mov eax, h
	mov [ebx], eax
	mov eax, scaledHeight
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxY
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinY
	mov [ebx], eax
	;
	finit
	fild canvasMinX
	fstp particleRangeMinX
	;
	finit
	fild canvasMaxX
	fstp particleRangeMaxX
	;
	finit
	fild canvasMinY
	fstp particleRangeMinY
	;
	finit
	fild canvasMaxY
	fstp particleRangeMaxY	
	;
	ret
asm_SetWindowDimension ENDP	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetNumOfObjects()
;
;Return the number of objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumOfObjects PROC C
	mov eax, numObjects
	ret
asm_GetNumOfObjects ENDP	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetObjectType(int objID)
;
;Return the object type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectType		PROC C USES ebx edx,
	objID: DWORD
	push ebx
	push edx
	xor eax, eax
	mov edx, offset objTypes
	mov ebx, objID
	mov al, [edx + ebx]
	pop edx
	pop ebx
	ret
asm_GetObjectType		ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjPosX		PROC C
mov eax,objPosX
ret
asm_GetObjPosX		ENDP

asm_GetObjPosY		PROC C
mov eax,objPosY
ret
asm_GetObjPosY		ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetObjectColor (int &r, int &g, int &b, int objID)
;Input: objID, the ID of the object
;
;Return the color three color components
;red, green and blue.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectColor  PROC C USES ebx edi esi,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
;	
	mov esi, OFFSET objColor
	mov eax, objID
	mov ebx, 3
	mul ebx
	mov ebx, 4
	mul ebx
	add esi, eax		; esi = esi + objID*3*4
	mov ebx, r			; r
	mov eax, [esi]
	mov [ebx], eax
	add esi, 4			; esi = esi + 4
	mov ebx, g			; g
	mov eax, [esi]
	mov [ebx], eax
	add esi, 4			; esi = esi + 4
	mov ebx, b			; b
	mov eax, [esi]
	mov [ebx], eax
	ret
;
asm_GetObjectColor ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeRotationAngle(a, b)
;return an angle*10.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeRotationAngle PROC C USES ebx,
	a: DWORD, b: DWORD
	mov ebx, b
	shl ebx, 1
	mov eax, a
	add eax, 10
	ret
asm_ComputeRotationAngle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputePositionX(int x, int objID)
;
;Return the x-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputePositionX PROC C USES edi esi,
	x: DWORD, objID: DWORD
	;modify this procedure
	mov esi, OFFSET objPosX
	mov eax, objID
	mov ebx, 4
	mul ebx
	add esi, eax		; esi = OFFSET objPosX + objID * 4
	mov eax, [esi]
	ret
asm_ComputePositionX ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputePositionY(int y, int objID)
;
;Return the y-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputePositionY PROC C USES ebx esi edx,
	y: DWORD, objID: DWORD
	;modify this procedure
	mov esi, OFFSET objPosY
	mov eax, objID
	mov ebx, 4
	mul ebx
	add esi, eax			; esi = OFFSET objPosY + objID * 4
	mov eax, [esi]
	ret
asm_ComputePositionY ENDP

ASM_setText PROC C
	;mov al, 0e1h
	mov al, 01eh
	call SetTextColor
	ret
ASM_setText ENDP

asm_ComputeParticlePosX PROC C,
xPtr : PTR REAL8
ret
asm_ComputeParticlePosX ENDP

;
asm_ComputeParticlePosY PROC C,
x : DWORD, yPtr : PTR REAL8, yVelocityPtr : PTR REAL8
ret
asm_ComputeParticlePosY ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_updateSimulationNow()
;
;Update the simulation.
;For examples,
;we can update the positions of the objects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_updateSimulationNow PROC C USES edi esi ebx
; modify this procedure
;
;

		call updateSnake
		cmp flag_yellow, 1
		jne L_q
		call Graduate_yellow
L_q:
		cmp flag_GameMode, 1
		jne L0
		call updateGrid
		jmp L_Quit
L0:
update0:
L_Quit:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;DO NOT DELETE THE FOLLOWING LINES
	INVOKE c_updatePositionsOfAllObjects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_updateSimulationNow ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_SetImageInfo PROC C USES esi edi ebx edx,
	imageIndex : DWORD,
	imagePtr : PTR BYTE, w : DWORD, h : DWORD, bytesPerPixel : DWORD
	; modify this procedure
	mov eax, w
	mov ebx, h
	mul ebx
	mov ebx, 3
	mul ebx
	mov edx, eax	; edx = w * h * 3
	cmp imageIndex, 1
	je L1
	;mov mImageStatus, 0
	mov ecx, edx
	mov esi, imagePtr
	mov edi, OFFSET mTmpBuffer0
	cld
	rep movsb
	mov ecx, edx
	mov esi, OFFSET mTmpBuffer0
	mov edi, OFFSET mImagePtr0
	cld
	rep movsb
	mov ecx, edx
	mov esi, OFFSET mTmpBuffer0
	mov edi, OFFSET mTmpPlace0
	cld
	rep movsb
	jmp L_out
L1:
	;mov mImageStatus, 1
	mov ecx, edx
	mov esi, imagePtr
	mov edi, OFFSET mTmpBuffer1
	cld
	rep movsb
	mov ecx, edx
	mov esi, OFFSET mTmpBuffer1
	mov edi, OFFSET mImagePtr1
	cld
	rep movsb
	mov ecx, edx
	mov esi, OFFSET mTmpBuffer1
	mov edi, OFFSET mTmpPlace1
	cld
	rep movsb
L_out:

	mov eax, w
	mov mImageWidth, eax
	mov eax, h
	mov mImageHeight, eax
	mov bytesPerPixel, 3
	mov mBytesPerPixel, 3
	ret
asm_SetImageInfo ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm_GetImagePixelSize PROC C
	mov eax, mImagePixelPointSize
ret
asm_GetImagePixelSize ENDP

asm_GetImageStatus PROC C
mov eax, mImageStatus
ret
asm_GetImageStatus ENDP

asm_getImagePercentage PROC C
mov eax, imagePercentage
ret
asm_getImagePercentage ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
;
asm_GetImageColour PROC C USES ebx esi, 
	imageIndex : DWORD,
	ix: DWORD, iy : DWORD,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD
	; modify this procedure
	mov eax, mImageWidth
	mov ebx, mImageHeight
	sub ebx, iy
	mul ebx
	add eax, ix
	mov ebx, 3
	mul ebx				; ebx = (mImageWidth*(mImageHeight-iy)+ix)*3
	cmp imageIndex, 1
	je L1
	mov esi, OFFSET mTmpBuffer0
	jmp L_Out
L1:
	;mov mImageStatus, 1
	mov esi, OFFSET mTmpBuffer1
L_Out:
	add esi, eax
	cld
	lodsb
	mov ebx, r
	mov [ebx], al
	lodsb
	mov ebx, g
	mov [ebx], al
	lodsb
	mov ebx, b
	mov [ebx], al
	;mov ebx, r
	;mov DWORD PTR [ebx], 50
	ret
asm_GetImageColour ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;const char *asm_getStudentInfoString()
;
;return pointer in edx
asm_getStudentInfoString PROC C
	mov eax, offset MYINFO
	ret
asm_getStudentInfoString ENDP

;void asm_GetImageDimension(int &iw, int &ih)
asm_GetImageDimension PROC C USES ebx,
	iw : PTR DWORD, ih : PTR DWORD
	mov ebx, iw
	mov eax, mImageWidth
	mov [ebx], eax
	mov ebx, ih
	mov eax, mImageHeight
	mov [ebx], eax
	; modify this procedure
	;mov ebx, iw
	;mov DWORD PTR [ebx], 100
	;mov ebx, ih
	;mov DWORD PTR [ebx], 100
	ret
asm_GetImageDimension ENDP

asm_GetImagePos PROC C USES ebx,
x : PTR DWORD,
y : PTR DWORD
mov eax, canvasMinX
mov ebx, scaleFactor
cdq
idiv ebx
mov ebx, x
mov [ebx], eax

mov eax, canvasMinY
mov ebx, scaleFactor
cdq
idiv ebx
mov ebx, y
mov [ebx], eax
ret
asm_GetImagePos ENDP

;;;;;;;;;;;;;;;;;;;;;;

Switch_Gray PROC USES ebx esi edi
	xor flag_gray, 1
	cmp flag_gray, 0
	je L_initial
	mov edi, OFFSET mTmpPlace0
	mov eax, mImageWidth
	mov ebx, mImageHeight
	imul ebx
	mov ecx, eax	; ecx = mImageWidth * mImageHeight
L0:
	mov esi, edi
	xor ebx, ebx
	mov bl, [esi]
	inc esi
	mov al, [esi]
	movzx ax, al
	add bx, ax
	inc esi
	mov al, [esi]
	movzx ax, al
	add bx, ax
	mov eax, ebx
	mov ebx, 3
	cdq
	idiv ebx
	mov esi, edi
	mov [esi], al
	inc esi
	mov [esi], al
	inc esi
	mov [esi], al
	add edi, 3
	loop L0
	mov flag_yellow, 0
	mov flag_gray, 1
	jmp L_Quit
L_initial:
	call CopyToPlace0
	mov flag_gray, 0
	jmp L_Quit
L_Quit:
	cmp flag_GameMode, 0
	je exit0
	cmp flag_griddimension, 8
	je L_8
	cmp flag_griddimension, 9
	je L_9
	cmp flag_griddimension, 0
	je L_0
	jmp exit0
L_8:
	call _4x2
	jmp exit0
L_9:
	call _8x4
	jmp exit0
L_0:
	call _8x8
	jmp exit0
exit0:
	call CopyFromPlace0ToBuffer0
	ret
Switch_Gray ENDP

Change_yellow PROC USES edi
	call CopyToBuffer0
	call CopyToPlace0
	mov flag_yellow, 1

	ret
Change_yellow ENDP

ShowDigit_X PROC USES ebx edx esi
	mov edx, digitX			; Left-Upper Position
	mov ecx, 5
L0:
	push ecx
	mov ecx, 4
L1:
	push ecx
	mov al, 1
	mov bl, [esi]
	cmp al, bl
	jne No_Show
	mov [edi], edx
	add edi, 4
	inc objnumbers
No_Show:
	inc esi
	add edx, digitSpacingWidth
	pop ecx
	loop L1
	mov edx, digitX
	pop ecx
	loop L0
	mov eax, digitSpacingWidth
	mov ebx, 4
	imul ebx
	add digitX, eax
	ret
ShowDigit_X ENDP

ShowDigit_Y PROC USES ebx edx esi
	mov edx, digitY			; Left-Upper Position
	mov ecx, 5
L0:
	push ecx
	mov ecx, 4
L1:
	push ecx
	mov al, 1
	mov bl, [esi]
	cmp al, bl
	jne No_Show
	mov [edi], edx
	add edi, 4
No_Show:
	inc esi
	pop ecx
	loop L1
	sub edx, digitSpacingHeight
	pop ecx
	loop L0
	ret
ShowDigit_Y ENDP


updateSnake PROC USES edi
	cmp flag_bounding, 1
	je L_bounding
	mov eax, canvasMaxX
	sub eax, digitMaxSpeed
	cmp digit_Right, eax
	jge L_Bound
	jmp L_Out
L_bounding:
	mov eax, canvasMinX
	add eax, digitMaxSpeed
	cmp digit_Left, eax
	jge L_Bound
L_Out:
	mov flag_bounding, 0
	mov eax, digitMaxSpeed
	add digit_Left, eax
	add digit_Right, eax
	mov ecx, objnumbers
	mov edi, OFFSET objPosX_tmp
L0:
	mov eax, digitMaxSpeed
	add [edi], eax
	add edi, 4
	loop L0
	cmp flag_showdigit, 1
	jne L_Quit
	mov ecx, objnumbers
	mov edi, OFFSET objPosX
L1:
	mov eax, digitMaxSpeed
	add [edi], eax
	add edi, 4
	loop L1
	jmp L_Quit
L_Bound:
	mov flag_bounding, 1
	mov eax, digitMaxSpeed
	sub digit_Left, eax
	sub digit_Right, eax
	mov ecx, objnumbers
	mov edi, OFFSET objPosX_tmp
L2:
	mov eax, digitMaxSpeed
	sub [edi], eax
	add edi, 4
	loop L2
	cmp flag_showdigit, 1
	jne L_Quit
	mov ecx, objnumbers
	mov edi, OFFSET objPosX
L3:
	mov eax, digitMaxSpeed
	sub [edi], eax
	add edi, 4
	loop L3
	jmp L_Quit
L_Quit:
	ret
updateSnake ENDP

updateGrid PROC USES ebx edx esi edi

	call ChooseColor
	cmp flag_griddimension, 8
	je L_s
	cmp flag_griddimension, 9
	je L_s
	cmp flag_griddimension, 0
	je L_s
	jmp L_Quit
L_s:
	;;;;;;;;;;;;;;;;;;;;;;;;;;  the cursor
	mov eax, windowWidth
	mov ebx, game_size_x			; "?" x y
	cdq
	idiv ebx
	mov ebx, eax
	mov eax, cursorX
	cdq
	idiv ebx
	cmp flag_target, 1
	je L_savefirstx
	jmp L_out1
L_savefirstx:
	mov target1_x, eax
	jmp L_out1
L_out1:
	cmp cursor_in_x, eax
	je L_same
	call CopyFromPlace0ToBuffer0
L_same:
	mov cursor_in_x, eax			; remainder
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, windowHeight
	mov ebx, game_size_y			; x x "?"
	cdq
	idiv ebx
	mov ebx, eax
	mov eax, cursorY
	cdq
	idiv ebx
	cmp flag_target, 1
	je L_savefirsty
	jmp L_out2
L_savefirsty:
	mov target1_y, eax
	jmp L_out2
L_out2:
	cmp cursor_in_y, eax
	je L_same2
	call CopyFromPlace0ToBuffer0
L_same2:
	mov cursor_in_y, eax			; remainder
	;;;;;;;;;;;;;;;;;;;;;;;;;
L_out3:
	mov edi, OFFSET mTmpBuffer0		; draw ranbowcolor
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	mov ebx, grid_y
	imul ebx
	mov ebx, cursor_in_y
	imul ebx
	add edi, eax					; edi += w * 3 *grid_y * cursor_in_y
	mov eax, grid_x
	mov ebx, cursor_in_x
	imul ebx
	add edi, eax					; edi += grid_x * cursor_in_x
	call DrawGridCell_Colorful
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp flag_target, 1
	je L_PrintTheFirst
	jmp L_Quit
	;;;;;;;;;;;;;;;;;;;;;;;;;;
L_PrintTheFirst:
	mov edi, OFFSET mTmpBuffer0		; draw ranbowcolor
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	mov ebx, grid_y
	imul ebx
	mov ebx, target1_in_y
	imul ebx
	add edi, eax					; edi += w * 3 *grid_y * target1_in_y
	mov eax, grid_x
	mov ebx, target1_in_x
	imul ebx
	add edi, eax					; edi += grid_x * target1_in_x
	call DrawGridCell_Colorful
	;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp L_Quit
L_Quit:
	ret
updateGrid ENDP

_4x2 PROC USES eax ebx ecx edx esi edi
	;;;;;;;;
	mov eax, mImageHeight
	shr eax, 1
	mov grid_y, eax			; grid_y = h / 2
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	shr eax, 2
	mov grid_x, eax			; grid_x = w * 3 / 4

	mov edi, OFFSET mTmpPlace0
	mov ecx, 2				; 4 * 2
L0:
	push ecx
	mov ecx, 4
L1:
	call DrawGridCell
	add edi, grid_x
	loop L1
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	mov ebx, grid_y
	sub ebx, 1
	imul ebx
	add edi, eax			; 
	pop ecx
	loop L0
	;call CopyFromPlace0ToBuffer0
	ret
_4x2 ENDP

_8x4 PROC
	;;;;;;;;
	mov eax, mImageHeight
	shr eax, 2
	mov grid_y, eax			; grid_y = h / 4
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	shr eax, 3
	mov grid_x, eax			; grid_x = w * 3 / 8

	mov edi, OFFSET mTmpPlace0
	mov ecx, 4				; 8 * 4
L0:
	push ecx
	mov ecx, 8
L1:
	call DrawGridCell
	add edi, grid_x
	loop L1
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	mov ebx, grid_y
	sub ebx, 1
	imul ebx
	add edi, eax			; 
	pop ecx
	loop L0
	;call CopyFromPlace0ToBuffer0
	ret
_8x4 ENDP

_8x8 PROC
	;;;;;;;;
	mov eax, mImageHeight
	shr eax, 3
	mov grid_y, eax			; grid_y = h / 8
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	shr eax, 3
	mov grid_x, eax			; grid_x = w * 3 / 8

	mov edi, OFFSET mTmpPlace0
	mov ecx, 8				; 8 * 8
L0:
	push ecx
	mov ecx, 8
L1:
	call DrawGridCell
	add edi, grid_x
	loop L1
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	mov ebx, grid_y
	sub ebx, 1
	imul ebx
	add edi, eax			; 
	pop ecx
	loop L0
	;call CopyFromPlace0ToBuffer0
	ret
_8x8 ENDP



DrawGridCell PROC USES eax ebx ecx edx
	; edi will come in, but dont modify edi
	mov ebx, edi
	mov ecx, grid_x
L0:
	mov al, 255
	mov [ebx], al
	inc ebx
	loop L0
	mov ebx, edi
	mov ecx, grid_y
	sub ecx, 1
L1:
	mov eax, mImageWidth
	mov edx, 3
	imul edx
	add ebx, eax		; eax = w * 3
	mov edx, ebx
	mov al, 255
	mov [edx], al
	inc edx
	mov [edx], al
	inc edx
	mov [edx], al
	mov edx, ebx
	mov eax, grid_x
	sub eax, 3
	add edx, eax
	mov al, 255
	mov [edx], al
	inc edx
	mov [edx], al
	inc edx
	mov [edx], al
	loop L1

	mov ecx, grid_x
L2:
	mov al, 255
	mov [ebx], al
	inc ebx
	loop L2
	ret
DrawGridCell ENDP

DrawGridCell_Colorful PROC USES eax ebx ecx edx
	; edi will come in, but dont modify edi
	mov ebx, edi
	mov eax, grid_x
	mov ecx, 3
	cdq
	idiv ecx
	mov ecx, eax			; ecx = grid_x / 3
L0:
	mov al, Red_
	mov [ebx], al
	mov al, Green_
	mov [ebx+1], al
	mov al, Blue_
	mov [ebx+2], al
	add ebx, 3
	loop L0
	mov ebx, edi
	mov ecx, grid_y
	sub ecx, 1
L1:
	mov eax, mImageWidth
	mov edx, 3
	imul edx
	add ebx, eax		; eax = w * 3
	mov edx, ebx
	mov al, Red_
	mov [edx], al
	inc edx
	mov al, Green_
	mov [edx], al
	inc edx
	mov al, Blue_
	mov [edx], al
	mov edx, ebx
	mov eax, grid_x
	sub eax, 3
	add edx, eax
	mov al, Red_
	mov [edx], al
	inc edx
	mov al, Green_
	mov [edx], al
	inc edx
	mov al, Blue_
	mov [edx], al
	loop L1

	mov eax, grid_x
	mov ecx, 3
	cdq
	idiv ecx
	mov ecx, eax			; ecx = grid_x / 3
L2:
	mov al, Red_
	mov [ebx], al
	mov al, Green_
	mov [ebx+1], al
	mov al, Blue_
	mov [ebx+2], al
	add ebx, 3
	loop L2

	ret
DrawGridCell_Colorful ENDP

ChooseColor PROC
	; don't uses eax
	cmp flag_colorstate, 0
	je L0
	cmp flag_colorstate, 1
	je L1
	cmp flag_colorstate, 2
	je L2
	cmp flag_colorstate, 3
	je L3
	jmp L_Quit
L0:
	mov al, 255
	mov Red_, al
	mov al, 0
	mov Green_, al
	mov Blue_, al
	mov flag_colorstate, 1
	jmp L_Quit
L1:
	mov al, 255
	mov Red_, al
	mov al, 127
	mov Green_, al
	mov al, 0
	mov Blue_, al
	mov flag_colorstate, 2
	jmp L_Quit
L2:
	mov al, 255
	mov Red_, al
	mov Green_, al
	mov al, 0
	mov Blue_, al
	mov flag_colorstate, 3
	jmp L_Quit
L3:
	mov al, 0
	mov Red_, al
	mov al, 255
	mov Green_, al
	mov al, 0
	mov Blue_, al
	mov flag_colorstate, 0
	jmp L_Quit
L_Quit:
	ret
ChooseColor ENDP

GameMode PROC
	mov flag_target, 0
	xor flag_GameMode, 1
	cmp flag_GameMode, 1
	je L_Game
	mov flag_gray, 0
	call CopyToBuffer0
	call CopyToPlace0
	jmp L_Quit
L_Game:
	;call CopyToBuffer0
	;call CopyToPlace0
	mov flag_griddimension, 8
	mov game_size_x, 4
	mov game_size_y, 2
	call _4x2						;  press 'g' default mode
	call CopyFromPlace0ToBuffer0
L_Quit:
	ret
GameMode ENDP

CopyToBuffer0 PROC USES eax ebx ecx edx esi edi
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mTmpBuffer0
	mov eax, mImageWidth
	mov ebx, mImageHeight
	imul ebx
	mov ebx, 3
	imul ebx
	mov ecx, eax
	cld
	rep movsb
	ret
CopyToBuffer0 ENDP

CopyToPlace0 PROC USES eax ebx ecx edx esi edi
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mTmpPlace0
	mov eax, mImageWidth
	mov ebx, mImageHeight
	imul ebx
	mov ebx, 3
	imul ebx
	mov ecx, eax
	cld
	rep movsb
	ret
CopyToPlace0 ENDP

CopyFromPlace0ToBuffer0 PROC USES eax ebx ecx edx esi edi
	mov esi, OFFSET mTmpPlace0
	mov edi, OFFSET mTmpBuffer0
	mov eax, mImageWidth
	mov ebx, mImageHeight
	imul ebx
	mov ebx, 3
	imul ebx
	mov ecx, eax
	cld
	rep movsb
	ret
CopyFromPlace0ToBuffer0 ENDP

CopyFromBuffer0ToPlace0 PROC USES eax ebx ecx edx esi edi
	mov esi, OFFSET mTmpBuffer0
	mov edi, OFFSET mTmpPlace0
	mov eax, mImageWidth
	mov ebx, mImageHeight
	imul ebx
	mov ebx, 3
	imul ebx
	mov ecx, eax
	cld
	rep movsb
	ret
CopyFromBuffer0ToPlace0 ENDP


Switch_Cell PROC USES eax ebx ecx edx esi edi
	mov flag_target, 0
	; target1_in_x cursor_in_x
	mov edi, OFFSET mTmpPlace0
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	mov ebx, grid_y
	imul ebx
	mov ebx, target1_in_y
	imul ebx
	add edi, eax					; edi += w * 3 *grid_y * target1_in_y
	mov eax, grid_x
	mov ebx, target1_in_x
	imul ebx
	add edi, eax					; edi += grid_x * target1_in_x
	mov esi, edi					; esi = target1 left-upper
	;;;;;;;;;;;;;;;;;;;;;;;;;
	mov edi, OFFSET mTmpPlace0
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	mov ebx, grid_y
	imul ebx
	mov ebx, cursor_in_y
	imul ebx
	add edi, eax					; edi += w * 3 *grid_y * cursor_in_y
	mov eax, grid_x
	mov ebx, cursor_in_x
	imul ebx
	add edi, eax					; edi += grid_x * cursor_in_x					
									; edi = cursor left-upper
	;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ecx, grid_y
L0:
	push ecx
	mov ecx, grid_x
L1:
	mov al, [esi]					; switch the byte
	mov bl, [edi]
	mov [esi], bl
	mov [edi], al
	inc esi
	inc edi
	loop L1
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	add esi, eax
	sub esi, grid_x
	add edi, eax
	sub edi, grid_x
	pop ecx
	loop L0
	mov flag_target, 0
	call CopyFromPlace0ToBuffer0
	ret
Switch_Cell ENDP

Graduate_Yellow PROC USES eax ebx ecx edx edi
	mov eax, mImageWidth
	mov ebx, mImageHeight
	imul ebx
	mov ecx, eax
	mov edi, OFFSET mTmpPlace0
L0:
	mov al, [edi+1]
	cmp [edi], al		; if R > G
	ja decreaseRincreaseG
	jmp L_out
decreaseRincreaseG:
	mov al, [edi]
	dec al
	mov [edi], al			; R --
	mov al, [edi+1]
	inc al
	mov [edi+1], al			; G++
L_out:
	mov al, 0
	cmp [edi+2], al			; if B > 0
	ja decreaseB
	jmp L_out2
decreaseB:
	mov al, [edi+2]
	dec al
	mov [edi+2], al			; B--
L_out2:
	add edi, 3
	loop L0
	call CopyFromPlace0ToBuffer0
	cmp flag_GameMode, 1
	je L_Game
	jmp L_Quit
L_Game:
	cmp flag_griddimension, 8
	je L_8
	cmp flag_griddimension, 9
	je L_9
	cmp flag_griddimension, 0
	je L_0
	jmp L_Quit
L_8:
	call _4x2
	call CopyFromPlace0ToBuffer0
	jmp L_Quit
L_9:
	call _8x4
	call CopyFromPlace0ToBuffer0
	jmp L_Quit
L_0:
	call _8x8
	call CopyFromPlace0ToBuffer0
	jmp L_Quit
L_Quit:
	ret
Graduate_Yellow ENDP

FlipHorizon PROC USES eax ebx ecx edx esi edi
	mov esi, OFFSET mTmpPlace0
	mov edi, OFFSET mTmpBuffer0		; edi is from Buffer0 upper left
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	add esi, eax					; esi is from Place0 upper right
	mov ecx, mImageHeight
L0:
	push ecx
	mov ecx, mImageWidth
L1:
	push ecx
	mov al, [esi-1]
	mov [edi+2], al
	mov al, [esi-2]
	mov [edi+1], al
	mov al, [esi-3]
	mov [edi], al
	sub esi, 3
	add edi, 3
	pop ecx
	loop L1
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	add esi, eax
	add esi, eax
	pop ecx
	loop L0
	call CopyFromBuffer0ToPlace0
	ret
FlipHorizon ENDP

FlipVertical PROC USES eax ebx ecx edx esi edi
	mov esi, OFFSET mTmpPlace0
	mov edi, OFFSET mTmpBuffer0
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	add edi, eax						; edi is from Buffer0 upper left
	mov ebx, mImageHeight
	imul ebx
	add esi, eax						; esi is from Place0 bottom left

	mov ecx, mImageHeight
L0:
	push ecx
	mov ecx, mImageWidth
L1:
	push ecx
	mov al, [esi-1]
	mov [edi-1], al
	mov al, [esi-2]
	mov [edi-2], al
	mov al, [esi-3]
	mov [edi-3], al
	sub esi, 3
	sub edi, 3
	pop ecx
	loop L1
	mov eax, mImageWidth
	mov ebx, 3
	imul ebx
	add edi, eax
	add edi, eax
	pop ecx
	loop L0
	call CopyFromBuffer0ToPlace0
	ret
FlipVertical ENDP

END