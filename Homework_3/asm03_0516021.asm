
;========================================================
; Student Name: Chia-An Yang
; Student ID: 0516021
; Email: gxxygxxy@gmail.com
;========================================================
; Prof. Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: EC706
; Assembly Language 
; Date: 2018/04/15
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

MOVE_LEFT	= 0
MOVE_RIGHT	= 1
MOVE_UP		= 2
MOVE_DOWN	= 3
MOVE_STOP	= 4

MOVE_LEFT_KEY	= 'a'
MOVE_RIGHT_KEY	= 'd'
MOVE_UP_KEY		= 'w'
MOVE_DOWN_KEY	= 's'


; PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C

ShowSubRegionAtLoc PROTO,
	x : DWORD, y: DWORD, w : DWORD, h : DWORD, x0 : DWORD, y0 : DWORD
	
computeLocationOfPixelInImage PROTO,
	x0 : DWORD, y0 : DWORD, w : DWORD, h : DWORD

swapPickedGridCellandCurGridCellRegion PROTO

PROGRAM_STATE_PRE_START_GAME	= 0
PROGRAM_STATE_START_GAME		= 1
PROGRAM_STATE_PRE_PLAY_GAME		= 2
PROGRAM_STATE_PLAY_GAME			= 3
PROGRAM_STATE_PRE_END_GAME		= 4
PROGRAM_STATE_END_GAME			= 5

.data 
colors BYTE 01ch
colorOriginal BYTE 01ch

MYINFO	BYTE "My Student Name: Chia-An Yang StudentID: 0516021",0 

OpenMsgDelay	DWORD	25
EnterStageDelay	DWORD	50

MyMsg BYTE "Assignment Three for Assembly Language...",0dh, 0ah
BYTE "My Student Name: Chia-An Yang",0dh, 0ah 
BYTE "My student ID: 0516021.", 0dh, 0ah, 0dh, 0ah
BYTE "My Email is: gxxygxxy@gmail.com.", 0dh, 0ah, 0dh, 0ah
BYTE "Make sure that the screen dimension is (120, 30).", 0dh, 0ah, 0dh, 0ah
BYTE "Key usages:", 0dh, 0ah
BYTE "Control keys: a, d, w, s", 0dh, 0ah
BYTE "Mouse.......", 0dh, 0ah
BYTE "More key usage......", 0

CaptionString BYTE "Student Name: Chia-An Yang",0
MessageString BYTE "Welcome to Wonderful World", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0516021", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: gxxygxxy@gmail.com.", 0dh, 0ah, 0dh, 0ah
				BYTE "Control keys: a, d, w, s", 0dh, 0ah
				BYTE "Mouse.......", 0dh, 0ah, 0dh, 0ah
				BYTE "......", 0dh, 0ah, 0dh, 0ah
				BYTE "ESC: quit", 0dh, 0ah
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

mouseX		SDWORD 0	; mouse x-coordinate
mouseY		SDWORD 0	; mouse y-coordinate

maxNumSnakeObj	DWORD	1000
numSnakeObj	DWORD	1
snakeObjPosX SDWORD	1024 DUP(0)
snakeObjPosY SDWORD	1024 DUP(0)
snakeLife	DWORD	0
snakeLifeCycle	DWORD	25

counter	DWORD 0				; My variable

cur_snakeObjPosX DWORD 0
cur_snakeObjPosY DWORD 0

Save_cur_snakeObjPosX DWORD 0	; My variable
Save_cur_snakeObjPosY DWORD 0	; My variable
default_snakeLifeCycle	DWORD 25

snakeSpeed				DWORD 100
Default_SnakeMaxSpeed	DWORD 200

snakeMoveDirection	DWORD	MOVE_RIGHT

flg_target	DWORD	0		; is the target set? true or false
target_x	DWORD	?		; target x-coordinate
target_y	DWORD	?		; target y-coordinate

x_difference	SDWORD	?	; my variable
y_difference	SDWORD	?	; my variable

flg_growing		BYTE	1	; my variable

flgQuit		DWORD	0
maxNumObjects	DWORD 512
numObjects	DWORD	1
objPosX		SDWORD	0, 2047 DUP(100000)
objPosY		SDWORD	0, 2047 DUP(100000)

SaveobjPosX	SDWORD	0, 2047 DUP(100000)
SaveobjPosY	SDWORD	0, 2047 DUP(100000)

objTypes	BYTE	2048 DUP(1)
objSpeedX	SDWORD	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	2048 DUP(?)
objSpeedY	SDWORD	2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	2048 DUP(?)			
objColor	DWORD	2048*3 DUP(100)		; I modify it
SaveobjColor DWORD	2048*3 DUP(100)
studentObjColor	DWORD	1024 DUP(?)
goMsg		BYTE "I love assembly programming. Let's start...", 0
bell		BYTE 0,0, 0
					
testDBL	REAL4	3.141592654
zero REAL8 0.0

particleState BYTE 0
negOne REAL8 -1.0

openingMsg	BYTE	"This program allows a user to draw a picture using spheres......", 0dh
			BYTE	"Great programming.", 0
movementDIR	BYTE	0
state		BYTE	0

imagePercentage DWORD	0

mImageStatus DWORD 0
mImagePtr0 BYTE 200000 DUP(?)
mImagePtr1 BYTE 200000 DUP(?)
mImagePtr2 BYTE 200000 DUP(?)
mTmpBuffer	BYTE	200000 DUP(?)
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

.code

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
	mov dx, 0
	call GotoXY
	xor eax, eax
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset MyMsg
	call WriteString
	ret
asm_ShowTitle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitializeApp()
;
;This function is called
;at the beginning of the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitializeApp PROC C USES ebx edi esi edx
	call AskForInput_Initialization
	call initSnake
	ret
asm_InitializeApp ENDP

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
	ret
asm_EndingMessage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_updateSimulationNow()
;
;Update the simulation.
;For example,
;we can update the positions of the objects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_updateSimulationNow PROC C USES edi esi ebx
	;
	call updateSnake
	;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;DO NOT REMOVE THE FOLLOWING LINE
	call c_updatePositionsOfAllObjects 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_updateSimulationNow ENDP

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
;void asm_GetMouseXY(int &out_mouseX, int &out_mouseY)
;or
;void asm_GetMouseXY(int *out_mouseX, int *out_mouseY)
;Get the mouse coordinates
; out_mouseX = mouseX;	// or *out_mouseX = mouseX;
; out_mouseY = mouseY;	// or *out_mouseY = mouseY;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetMouseXY PROC C USES edi,
	out_mouseX: PTR SDWORD, out_mouseY: PTR SDWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	mov edi, out_mouseX
	mov eax, mouseX
	mov [edi], eax
	mov edi, out_mouseY
	mov eax, mouseY
	mov [edi], eax
	ret
asm_GetMouseXY ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; bool asm_GetTargetXY(int &out_mouseX, int &out_mouseY)
; or
; bool asm_GetTargetXY(int *out_mouseX, int *out_mouseY)
;
; Get the target coordinates and also return a flag.
; Return true if the target is set and false otherwise.
; 
; out_mouseX = target_x;	// or *out_mouseX = target_x
; out_mouseY = target_y;	// or *out_mouseY = target_y
; return flg_target
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetTargetXY PROC C USES edi,
	out_mouseX: PTR SDWORD, out_mouseY: PTR SDWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	mov edi, out_mouseX
	mov eax, target_X
	mov [edi], eax
	mov edi, out_mouseY
	mov eax, target_Y
	mov [edi], eax
	mov eax, flg_target
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetTargetXY ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumParticles PROC C
	mov eax, numParticles
	ret
asm_GetNumParticles ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleMaxSpeed PROC C
	mov eax, particleMaxSpeed
	ret
asm_GetParticleMaxSpeed ENDP

;
;int asm_GetParticleSize()
;
;Return the particle size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSize PROC C
	;modify this procedure
	mov eax, 1
	ret
asm_GetParticleSize ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMousePassiveEvent( int x, int y )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMousePassiveEvent PROC C USES eax ebx edx,
	x : DWORD, y : DWORD
	mov eax, x
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, canvasMaxX
	sub ebx, canvasMinX
	mov eax, x
	mul ebx
	div windowWidth
	add eax, canvasMinX
	mov mouseX, eax 
	;
	mov ebx, canvasMaxY
	sub ebx, canvasMinY
	mov eax, windowHeight
	sub eax, y
	mul ebx
	div windowHeight
	add eax, canvasMinY
	mov mouseY, eax 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, windowHeight
	cdq
	mov ecx, GridDimensionH
	div ecx
	mov ebx, eax	; ebx = y
	
	mov eax, windowWidth
	cdq
	mov ecx, GridDimensionW
	div ecx			; eax = x
	
	mov ecx, eax
	mov eax, x
	cmp mFlipX, 0
	je L0
	mov edx, windowWidth
	sub edx, eax
	mov eax, edx
L0:
	cdq
	div ecx
	mov CurGridX, eax
	;
	mov ecx, ebx
	mov eax, y
;
	cmp mFlipY, 1
	je L1
	mov edx, windowHeight
	sub edx, eax
	mov eax, edx
;
L1:
	cdq
	div ecx
	mov CurGridY, eax
	
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
	;
	;mov flg_target, 0
	cmp button, 0
	jne exit0
	cmp status, 0
	jne exit0
	;
	mov flg_target, 1
	mov ebx, canvasMaxX
	sub ebx, canvasMinX
	mov eax, x
	mul ebx
	div windowWidth
	add eax, canvasMinX
	mov target_x, eax 
	;
	mov ebx, canvasMaxY
	sub ebx, canvasMinY
	mov eax, windowHeight
	sub eax, y
	mul ebx
	div windowHeight
	add eax, canvasMinY
	mov target_y, eax 
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
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	cmp eax, 'w'
	je MoveUp
	cmp eax, 's'
	je MoveDown
	cmp eax, 'a'
	je MoveLeft
	cmp eax, 'd'
	je MoveRight
	cmp eax, 'r'
	je Colorful
	cmp eax, 'p'
	je Rainbow
	cmp eax, 'v'
	je Save
	cmp eax, 'c'
	je Clear
	cmp eax, 'l'
	je Load
	cmp eax, ' '
	je Toggle
	cmp eax, 27
	je ESCAPE
	jmp L_Quit
MoveUp:
	mov snakeMoveDirection, MOVE_UP
	cmp flg_target, 1
	je LU
	jmp L_Quit
LU:
	mov flg_target, 0
	jmp L_Quit
MoveDown:
	mov snakeMoveDirection, MOVE_DOWN
	cmp flg_target, 1
	je LD
	jmp L_Quit
LD:
	mov flg_target, 0
	jmp L_Quit
MoveLeft:
	mov snakeMoveDirection, MOVE_LEFT
	cmp flg_target, 1
	je LM
	jmp L_Quit
LM:
	mov flg_target, 0
	jmp L_Quit
MoveRight:
	mov snakeMoveDirection, MOVE_RIGHT
	cmp flg_target, 1
	je LR
	jmp L_Quit
LR:
	mov flg_target, 0
	jmp L_Quit
Colorful:
	call RandomColor
	jmp L_Quit
Rainbow:
	call RainbowColor
	jmp L_Quit
Save:
	call SaveData
	jmp L_Quit
Clear:
	call ClearData
	jmp L_Quit
Load:
	call LoadData
	jmp L_Quit
Toggle:
	cmp flg_growing, 1
	je L_stop
	mov flg_growing, 1
	jmp L_Quit
L_stop:
	mov flg_growing, 0
	jmp L_Quit
ESCAPE:
	call asm_EndingMessage
	;;;;;;;;;;;;;;;;;;;;;;;
L_Quit:
	ret
asm_HandleKey ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
;
;w: window resolution (i.e. number of pixels) along the x-axis.
;h: window resolution (i.e. number of pixels) along the y-axis. 
;scaledWidth : scaled up width
;scaledHeight : scaled up height
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
;	call asm_ComputeGridCellDimension
	ret
asm_SetWindowDimension ENDP	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetNumOfObjects()
;
;Return the number of objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumOfObjects PROC C
	mov eax, maxNumObjects
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	;mov eax, 1
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
;void asm_GetObjectColor (int &r, int &g, int &b, int objID)
;Input: objID, the ID of the object
;
;Return the color three color components
;red, green and blue.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectColor  PROC C USES ebx edi esi,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
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
;int asm_ComputeObjPositionX(int x, int objID)
;
;Return the x-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionX PROC C USES edi esi,
	x: DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	mov esi, OFFSET objPosX
	mov eax, objID
	mov ebx, 4
	mul ebx
	add esi, eax		; esi = OFFSET objPosX + objID * 4
	mov eax, [esi]
	;mov eax, 0
	ret
asm_ComputeObjPositionX ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeObjPositionY(int y, int objID)
;
;Return the y-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionY PROC C USES ebx esi edx,
	y: DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	mov esi, OFFSET objPosY
	mov eax, objID
	mov ebx, 4
	mul ebx
	add esi, eax			; esi = OFFSET objPosY + objID * 4
	mov eax, [esi]
	;mov eax, 0
	ret
asm_ComputeObjPositionY ENDP

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

;
; void asm_SetImageInfo(
;	int imageindex, 
;	char *imagePtr, 
;	unsigned int w, // width
;	unsigned int h, // height
;	unsigned int bytesPerPixel
; )
;
; Assume bytesPerPixel = 3
;
; Save the image to a buffer, e.g., mImagePtr0
; The buffer must be large enough to store all the bytes
;
; Set mImageWidth and mImageHeight.
;
asm_SetImageInfo PROC C USES esi edi ebx,
	imageIndex : DWORD,
	imagePtr : PTR BYTE, w : DWORD, h : DWORD, 
	bytesPerPixel : DWORD
	;;;;;;;;;;;;;;;;;;;;;;;

	mov eax, w
	mov ebx, h
	mul ebx
	mov ebx, 3
	mul ebx
	mov ecx, eax				; ecx = w * h * 3
	mov esi, imagePtr
	cmp imageIndex, 1
	je L1
	mov edi, OFFSET mImagePtr0
	jmp L_out
L1:
	mov edi, OFFSET mImagePtr1
L_out:
	cld
	rep movsb

	mov eax, w
	mov mImageWidth, eax
	mov eax, h
	mov mImageHeight, eax
	mov bytesPerPixel, 3
	mov mBytesPerPixel, 3
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;	
	ret
asm_SetImageInfo ENDP

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
;
;
;asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
;
asm_GetImageColour PROC C USES ebx esi, 
	imageIndex : DWORD,
	ix: DWORD, iy : DWORD,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, mImageWidth
	mov ebx, mImageHeight
	sub ebx, iy
	mul ebx
	add eax, ix
	mov ebx, 3
	mul ebx				; ebx = (mImageWidth*(mImageHeight-iy)+ix)*3
	cmp imageIndex, 1
	je L1
	mov esi, OFFSET mImagePtr0
	jmp L_out
L1:
	mov esi, OFFSET mImagePtr1
L_out:
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
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetImageColour ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;const char *asm_getStudentInfoString()
;
;return pointer in edx
asm_getStudentInfoString PROC C
	mov eax, offset MYINFO
	ret
asm_getStudentInfoString ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetImageDimension(int &iw, int &ih)
; iw = mImageWidth
; ih = mImageHeight
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetImageDimension PROC C USES ebx,
iw : PTR DWORD, ih : PTR DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, iw
	mov eax, mImageWidth
	mov [ebx], eax
	mov ebx, ih
	mov eax, mImageHeight
	mov [ebx], eax
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	;mov ebx, iw
	;mov eax, 2
	;mov [ebx], eax
	;mov ebx, ih
	;mov [ebx], eax
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

;
AskForInput_Initialization PROC USES ebx edi esi
	mov al, blue + white*16
	or al, 88h
	mov ah, 080h
	call SetTextColor
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; add your own stuff
	call Crlf
	call Crlf
	call Crlf
	call Crlf
	mov eax, blue + white * 16
	call SetTextColor
	mWrite "This program allows a user to draw a picture using spheres......"
	call Crlf
	mWrite "Great programming."
	call Crlf
	mov eax, lightgreen + black * 16
	call SetTextColor
	mWrite "Enter the speed of the snake (integer)[1, 200]:"
	call ReadInt
	jz L0
	mov snakeSpeed, eax
L0:
	mov eax, blue + white * 16
	call SetTextColor
	mWrite "Enter the snake life cycle (integer) [1, 100]:"
	call ReadInt
	jz L1
	mov snakeLifeCycle, eax
L1:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, OFFSET CaptionString
	mov edx, OFFSET MessageString
	call MsgBox
	ret
AskForInput_Initialization ENDP

initSnake PROC USES ebx edi esi
	;;;;;;;;;;;;;;;;;;;;;;;
	; add your own stuff
	;;;;;;;;;;;;;;;;;;;;;;;
	mov flg_growing, 1
	mov edi, OFFSET objColor	; head must be red
	mov eax, 255				; R
	mov [edi], eax				;
	add edi, 4					;
	mov eax, 0					; G
	mov [edi], eax				; 
	add edi, 4					;
	mov eax, 0					; B
	mov [edi], eax				;
	;mov eax, 255
	;stosd
	;add edi, 4
	;mov eax, 0
	;stosd
	ret
initSnake ENDP

updateSnake PROC USES ebx edx edi esi,

	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	;;;;;;;;;;;;;;;;;;;;;;;
	call GotoTarget
	cmp cur_snakeObjPosX, -50000
	jle L_Bound_0
	cmp cur_snakeObjPosX, 50000
	jge L_Bound_1
	cmp cur_snakeObjPosY, 50000
	jge L_Bound_2
	cmp cur_snakeObjPosY, -50000
	jle L_Bound_3
	jmp L_NotBound
L_Bound_0:
	mov snakeMoveDirection, 1
	jmp L_NotBound
L_Bound_1:
	mov snakeMoveDirection, 0
	jmp L_NotBound
L_Bound_2:
	mov snakeMoveDirection, 3
	jmp L_NotBound
L_Bound_3:
	mov snakeMoveDirection, 2
	jmp L_NotBound
L_NotBound:
	cmp snakeMoveDirection, 0
	je Go_Left
	cmp snakeMoveDirection, 1
	je Go_Right
	cmp snakeMoveDirection, 2
	je Go_Up
	cmp snakeMoveDirection, 3
	je Go_Down
	cmp snakeMoveDirection, 4
	je Go_Stop
	jmp L0
Go_Left:
	mov ebx, snakeSpeed
	sub cur_snakeObjPosX, ebx
	jmp L0
Go_Right:
	mov ebx, snakeSpeed
	add cur_snakeObjPosX, ebx
	jmp L0
Go_Up:
	mov ebx, snakeSpeed
	add cur_snakeObjPosY, ebx
	jmp L0
Go_Down:
	mov ebx, snakeSpeed
	sub cur_snakeObjPosY, ebx
	jmp L0
Go_Stop:
	jmp L_Quit
L0:
	mov esi, OFFSET objPosX
	mov ebx, cur_snakeObjPosX
	mov [esi], ebx
	mov esi, OFFSET objPosY
	mov ebx, cur_snakeObjPosY
	mov [esi], ebx

	cmp flg_growing, 0				; stop growing but head is going
	je	L_Quit

	inc counter
	mov eax, snakeLifeCycle
	cmp counter, eax
	je Print
	jmp L_Quit
Print:
	mov counter, 0
	mov edi, OFFSET objPosX
	mov eax, numObjects
	mov ebx, 4
	mul ebx
	add edi, eax			; edi = edi + numObjects*4
	mov eax, cur_snakeObjPosX
	mov [edi], eax			; [edi] = cur_snakeObjPosX
	;;;;;;;;;;;;;;;;Y
	mov edi, OFFSET objPosY
	mov eax, numObjects
	mov ebx, 4
	mul ebx
	add edi, eax			; edi = edi + numObjects*4
	mov eax, cur_snakeObjPosY
	mov [edi], eax			; [edi] = cur_snakeObjPosY
	inc numObjects
L_Quit:
	ret
updateSnake ENDP

;;;;;;;;;;;;;;;;;;;;;;;mine

RandomColor PROC
	mov esi, OFFSET objColor
	add esi, 12			; start from objColor[3]
	mov ecx, 6140		; 2048*3=6144
	call Randomize
L0:
	call Random32
	and eax, 255
	mov [esi], eax
	add esi, 4
	loop L0
	ret
RandomColor ENDP

RainbowColor PROC
	mov esi, OFFSET objColor
	add esi, 12
	mov ecx, 292		; 2047*3/21 = 292.42857...
L0:
	call _Red
	call _Orange
	call _Yellow
	call _Green
	call _Blue
	call _Indigo
	call _Violet
	loop L0
	ret
RainbowColor ENDP

_Red PROC USES ebx,

	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	ret
_Red ENDP
_Orange PROC USES ebx,

	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	mov ebx, 128
	mov [esi], ebx
	add esi, 4
	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	ret
_Orange ENDP
_Yellow PROC USES ebx,

	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	ret
_Yellow	ENDP
_Green PROC USES ebx,

	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	ret
_Green ENDP
_Blue PROC USES ebx,

	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	mov ebx, 127
	mov [esi], ebx
	add esi, 4
	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	ret
_Blue ENDP


_Indigo PROC USES ebx,

	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	ret
_Indigo	ENDP
_Violet PROC USES ebx,

	mov ebx, 139
	mov [esi], ebx
	add esi, 4
	mov ebx, 0
	mov [esi], ebx
	add esi, 4
	mov ebx, 255
	mov [esi], ebx
	add esi, 4
	ret
_Violet ENDP

SaveData PROC USES ebx,

	cld
	mov ecx, LENGTHOF objPosX
	mov esi, OFFSET objPosX
	mov edi, OFFSET SaveobjPosX
	rep movsd
	mov ecx, LENGTHOF objPosY
	mov esi, OFFSET objPosY
	mov edi, OFFSET	SaveobjPosY
	rep movsd
	mov ecx, LENGTHOF objColor
	mov esi, OFFSET objColor
	mov edi, OFFSET SaveobjColor
	rep movsd
	mov ebx, cur_snakeObjPosX
	mov Save_cur_snakeObjPosX, ebx
	mov ebx, cur_snakeObjPosY
	mov Save_cur_snakeObjPosY, ebx
	ret
SaveData ENDP

LoadData PROC USES ebx,

	cld
	mov ecx, LENGTHOF SaveobjPosX
	mov esi, OFFSET SaveobjPosX
	mov edi, OFFSET objPosX
	rep movsd
	mov ecx, LENGTHOF SaveobjPosY
	mov esi, OFFSET SaveobjPosY
	mov edi, OFFSET	objPosY
	rep movsd
	mov ecx, LENGTHOF SaveobjColor
	mov esi, OFFSET SaveobjColor
	mov edi, OFFSET objColor
	rep movsd
	mov ebx, Save_cur_snakeObjPosX
	mov cur_snakeObjPosX, ebx
	mov ebx, Save_cur_snakeObjPosY
	mov cur_snakeObjPosY, ebx
	ret
LoadData ENDP

ClearData PROC USES ebx,

	mov eax, 100000
	mov edi, OFFSET objPosX
	mov ecx, LENGTHOF objPosX
	cld
	rep stosb
	mov eax, 100000
	mov edi, OFFSET objPosY
	mov ecx, LENGTHOF objPosY
	cld
	rep stosb
	;	Don't clear the color of the sphere
	;mov eax, 100
	;mov edi, OFFSET objColor
	;mov ecx, LENGTHOF objColor
	;cld
	;rep stosb
	ret
ClearData ENDP
GotoTarget PROC USES ebx,

	cmp flg_target, 0
	je L_Quit
	mov eax, cur_snakeObjPosX
	cmp eax, target_x
	jge L0				; cur_snakeObjPosX >= target_x
	mov eax, target_x
	sub eax, cur_snakeObjPosX
	mov x_difference, eax
	jmp L1
L0:
	mov eax, cur_snakeObjPosX
	sub eax, target_x
	mov x_difference, eax
L1:						; x_difference = abs(target_x - cur_snakeObjPosX)
	mov eax, cur_snakeObjPosY
	cmp eax, target_y
	jge L2				; cur_snakeObjPosY >= target_y
	mov eax, target_y
	sub eax, cur_snakeObjPosY
	mov y_difference, eax
	jmp L3
L2:
	mov eax, cur_snakeObjPosY
	sub eax, target_y
	mov y_difference, eax
L3:						; y_difference = abs(target_y - cur_snakeObjPosY)
	mov eax, x_difference
	cmp eax, y_difference
	jge x_biggerthan_y
	jmp y_biggerthan_x
x_biggerthan_y:						; move x-direction
	mov eax, cur_snakeObjPosX
	cmp eax, target_x
	jge L_left
	jmp L_right
L_left:
	mov snakeMoveDirection, 0
	jmp Outside
L_right:
	mov snakeMoveDirection, 1
	jmp Outside
y_biggerthan_x:						; move y-direction
	mov eax, cur_snakeObjPosY
	cmp eax, target_y
	jge L_down
	jmp L_up
L_up:
	mov snakeMoveDirection, 2
	jmp Outside
L_down:
	mov snakeMoveDirection, 3
	jmp Outside
Outside:
	mov ebx, snakeSpeed
	cmp x_difference, ebx
	jle LL
	jmp LLL
LL:							; reach the target
	mov snakeMoveDirection, 4
	mov flg_target, 0
	jmp L_Quit
LLL:
	mov ebx, snakeSpeed
	cmp y_difference, ebx
	jle LLLL
	jmp L_Quit
LLLL:						; reach the target
	mov snakeMoveDirection, 4
	mov flg_target, 0
	jmp L_Quit
L_Quit:
	ret
GotoTarget ENDP
END