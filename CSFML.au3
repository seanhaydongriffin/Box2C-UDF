#include <Array.au3>
#include <WinAPIDiag.au3>
#include "Binary.au3"

; #INDEX# =======================================================================================================================
; Title .........: CSFML
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: SFML Functions.
; Author(s) .....: Sean Griffin
; Dlls ..........: csfml-system-2.dll, csfml-graphics-2.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__CSFML_System_DLL = -1
Global $__CSFML_Graphics_DLL = -1
Global $__CSFML_Window_DLL = -1
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $CSFML_sfFalse = 0
Global Const $CSFML_sfTrue = 1
Global Const $CSFML_sfWindowStyle_sfNone = 0
Global Const $CSFML_sfWindowStyle_sfTitlebar = 1
Global Const $CSFML_sfWindowStyle_sfResize = 2
Global Const $CSFML_sfWindowStyle_sfClose = 4
Global Const $CSFML_sfWindowStyle_sfFullscreen = 8
Global Const $CSFML_sfWindowStyle_sfDefaultStyle = $CSFML_sfWindowStyle_sfTitlebar + $CSFML_sfWindowStyle_sfResize + $CSFML_sfWindowStyle_sfClose
Global Enum $CSFML_sfEvtClosed, $CSFML_sfEvtResized, $CSFML_sfEvtLostFocus, $CSFML_sfEvtGainedFocus, $CSFML_sfEvtTextEntered, $CSFML_sfEvtKeyPressed, $CSFML_sfEvtKeyReleased, $CSFML_sfEvtMouseWheelMoved, $CSFML_sfEvtMouseWheelScrolled, $CSFML_sfEvtMouseButtonPressed, $CSFML_sfEvtMouseButtonReleased, $CSFML_sfEvtMouseMoved, $CSFML_sfEvtMouseEntered, $CSFML_sfEvtMouseLeft, $CSFML_sfEvtJoystickButtonPressed, $CSFML_sfEvtJoystickButtonReleased, $CSFML_sfEvtJoystickMoved, $CSFML_sfEvtJoystickConnected, $CSFML_sfEvtJoystickDisconnected, $CSFML_sfEvtTouchBegan, $CSFML_sfEvtTouchMoved, $CSFML_sfEvtTouchEnded, $CSFML_sfEvtSensorChanged, $CSFML_sfEvtCount
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _CSFML_Startup
; _CSFML_Shutdown
; _CSFML_sfClock_create
; _CSFML_sfClock_getElapsedTime
; _CSFML_sfClock_restart
; _CSFML_sfVector2f_Constructor
; _CSFML_sfVector2f_Update
; _CSFML_sfVector2f_Move
; _CSFML_sfColor_Constructor
; _CSFML_sfColor_fromRGB
; _CSFML_sfSizeEvent_Constructor
; _CSFML_sfEvent_Constructor
; _CSFML_sfVideoMode_Constructor
; _CSFML_sfRenderWindow_create
; _CSFML_sfRenderWindow_setVerticalSyncEnabled
; _CSFML_sfRenderWindow_isOpen
; _CSFML_sfRenderWindow_pollEvent
; _CSFML_sfRenderWindow_clear
; _CSFML_sfRenderWindow_drawText
; _CSFML_sfRenderWindow_drawSprite
; _CSFML_sfRenderWindow_display
; _CSFML_sfRenderWindow_close
; _CSFML_sfTexture_createFromFile
; _CSFML_sfSprite_create
; _CSFML_sfSprite_destroy
; _CSFML_sfSprite_setTexture
; _CSFML_sfSprite_setPosition
; _CSFML_sfSprite_setRotation
; _CSFML_sfSprite_rotate
; _CSFML_sfSprite_setOrigin
; _CSFML_sfFont_createFromFile
; _CSFML_sfText_create
; _CSFML_sfText_setString
; _CSFML_sfText_setFont
; _CSFML_sfText_setCharacterSize
; _CSFML_sfText_setFillColor
; ===============================================================================================================================




; #MISCELLANEOUS FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_Startup
; Description ...: Loads the CSFML DLLs
; Syntax.........: _CSFML_Startup ($CSFMLSystemDLL, $CSFMLGraphicsDLL)
; Parameters ....: $CSFMLSystemDLL - the filename of the CSFML System DLL
;				   $CSFMLGraphicsDLL - the filename of the CSFML Graphics DLL
; Return values .: True - DLLs loaded successfully
;                  False - DLL load failed
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_Shutdown
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_Startup($CSFMLSystemDLL = "csfml-system-2.dll", $CSFMLGraphicsDLL = "csfml-graphics-2.dll", $CSFMLWindowDLL = "csfml-window-2.dll")

	If $__CSFML_System_DLL >= 0 Then Return 1
	$__CSFML_System_DLL = DllOpen($CSFMLSystemDLL)
	If $__CSFML_System_DLL = -1 Then Return SetError(@error,0,0)

	If $__CSFML_Graphics_DLL >= 0 Then Return 1
	$__CSFML_Graphics_DLL = DllOpen($CSFMLGraphicsDLL)
	If $__CSFML_System_DLL = -1 Then Return SetError(@error,0,0)

	If $__CSFML_Window_DLL >= 0 Then Return 1
	$__CSFML_Window_DLL = DllOpen($CSFMLWindowDLL)
	If $__CSFML_Window_DLL = -1 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_Shutdown
; Description ...: Unloads the CSFML DLLs
; Syntax.........: _CSFML_Shutdown()
; Parameters ....:
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_Startup
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_Shutdown()

	DllClose($__CSFML_System_DLL)
	DllClose($__CSFML_Graphics_DLL)
EndFunc


; #SFKEYBOARD FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfClock_getElapsedTime
; Description ...: Get the time elapsed in a clock.
;				   This function returns the time elapsed since the last call to _CSFML_sfClock_restart or _CSFML_sfClock_create.
; Syntax.........: _CSFML_sfClock_getElapsedTime($clock)
; Parameters ....:
; Return values .: Success - Time elapsed (in microseconds).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfClock_create, _CSFML_sfClock_restart
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfKeyboard_isKeyPressed($key)

	Local $key_pressed = DllCall($__CSFML_Window_DLL, "BOOL:cdecl", "sfKeyboard_isKeyPressed", "INT", $key)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $key_pressed[0]
EndFunc


; #SFCLOCK FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfClock_create
; Description ...: Create a new clock and start it.
; Syntax.........: _CSFML_sfClock_create()
; Parameters ....:
; Return values .: Success - A pointer to the clock (sfClock).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfClock_getElapsedTime
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfClock_create()

	Local $sfClock = DllCall($__CSFML_System_DLL, "PTR:cdecl", "sfClock_create")
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfClock_ptr = $sfClock[0]
	Return $sfClock_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfClock_getElapsedTime
; Description ...: Get the time elapsed in a clock.
;				   This function returns the time elapsed since the last call to _CSFML_sfClock_restart or _CSFML_sfClock_create.
; Syntax.........: _CSFML_sfClock_getElapsedTime($clock)
; Parameters ....:
; Return values .: Success - Time elapsed (in microseconds).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfClock_create, _CSFML_sfClock_restart
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfClock_getElapsedTime($clock)

	Local $sfTime = DllCall($__CSFML_System_DLL, "INT64:cdecl", "sfClock_getElapsedTime", "PTR", $clock)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfTime[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfClock_restart
; Description ...: Restart a clock.
;				   This function puts the time counter back to zero. It also returns the time elapsed since the clock was started.
; Syntax.........: _CSFML_sfClock_restart($clock)
; Parameters ....:
; Return values .: Success - Time elapsed (in microseconds).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfClock_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfClock_restart($clock)

	Local $sfTime = DllCall($__CSFML_System_DLL, "INT64:cdecl", "sfClock_restart", "PTR", $clock)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfTime[0]
EndFunc


; #SFVECTOR2F FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfVector2f_Constructor
; Description ...: Constructs a sfVector2f structure.
; Syntax.........: _CSFML_sfVector2f_Constructor($x, $y)
; Parameters ....: $x - horizontal component (pixel position) of the vector.
;				   $y - vertical component (pixel position) of the vector.
; Return values .: Success - the sfVector2f structure (STRUCT).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfVector2f_Constructor($x, $y)

	local $sfVector2f = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVector2f, 1, $x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVector2f, 2, $y)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfVector2f
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfVector2f_Update
; Description ...: Updates a sfVector2f structure.
; Syntax.........: _CSFML_sfVector2f_Update($vector, $x, $y)
; Parameters ....: $vector - a pointer to the vector structure to update.
;				   $x - the new horizontal component (pixel position) of the vector.
;				   $y - the new vertical component (pixel position) of the vector.
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfVector2f_Update($vector, $x, $y)

	local $sfVector2f = DllStructCreate("STRUCT;float;float;ENDSTRUCT", $vector)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVector2f, 1, $x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVector2f, 2, $y)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfVector2f_Move
; Description ...: Shifts the x and / or y components (pixel positions) of a sfVector2f structure.
; Syntax.........: _CSFML_sfVector2f_Move($vector, $x, $y)
; Parameters ....: $vector - a pointer to the vector structure to move
;				   $x - the horizontal component (number of pixels) to add to the vector.
;				   $y - the vertical component (number of pixels) to add to the vector.
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfVector2f_Move($vector, $x, $y)

	local $sfVector2f = DllStructCreate("STRUCT;float;float;ENDSTRUCT", $vector)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVector2f, 1, DllStructGetData($sfVector2f, 1) + $x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVector2f, 2, DllStructGetData($sfVector2f, 2) + $y)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc


; #SFVERTEX FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfVertex_Constructor
; Description ...: Constructs a sfVertex structure.
; Syntax.........: _CSFML_sfVertex_Constructor($position_x, $position_y, $color, $texCoords_x, $texCoords_y)
; Parameters ....: $position_x - horizontal component (pixel position) of the vertex
;				   $position_y - vertical component (pixel position) of the vertex
;				   $r - the red component (value) of the color
;				   $g - the green component (value) of the color
;				   $b - the blue component (value) of the color
;				   $a - the alpha channel component (value) of the color
;				   $texCoords_x
;				   $texCoords_y
; Return values .: Success - the sfVector2f structure (STRUCT).
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfVertex_Constructor($position_x, $position_y, $r, $g, $b, $a, $texCoords_x, $texCoords_y)

	local $sfVertex = DllStructCreate("STRUCT;float;float;byte;byte;byte;byte;float;float;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 1, $position_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 2, $position_y)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 3, $r)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 4, $g)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 5, $b)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 6, $a)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 7, $texCoords_x)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVertex, 8, $texCoords_y)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfVertex
EndFunc


; #SFVERTEXARRAY FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfVertexArray_Create
; Description ...: Creates a new vertex array (sfVertexArray).
; Syntax.........: _CSFML_sfVertexArray_Create()
; Parameters ....:
; Return values .: Success - the vertex array
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfVertexArray_Create()

	Local $sfVertexArray = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfVertexArray_create")
	If @error > 0 Then Return SetError(@error,0,0)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	return $sfVertexArray[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfVertexArray_Append
; Description ...: Add a vertex (sfVertex) to a vertex array (sfVertexArray).
; Syntax.........: _CSFML_sfVertexArray_Append($vertexArray, $vertex)
; Parameters ....:
; Return values .: Success - the vertex array
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfVertexArray_Append($vertexArray, $vertex)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfVertexArray_append", "PTR", $vertexArray, "STRUCT", $vertex)
	If @error > 0 Then Return SetError(@error,0,0)

	return True
EndFunc


; #SFCONVEXSHAPRE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfConvexShape_Create
; Description ...: Create a new convex shape (sfConvexShape).
; Syntax.........: _CSFML_sfConvexShape_Create()
; Parameters ....:
; Return values .: Success - the sfConvexShape object
;				   Failure - Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfConvexShape_Create()

	Local $sfConvexShape = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfConvexShape_create")
	If @error > 0 Then Return SetError(@error,0,0)

	return $sfConvexShape[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfConvexShape_setPointCount
; Description ...: Set the number of points of a convex shape. count must be greater than 2 to define a valid shape.
; Syntax.........: _CSFML_sfConvexShape_setPointCount($shape, $count)
; Parameters ....: $shape - Shape object
;				   $count - New number of points of the shape
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfConvexShape_setPointCount($shape, $count)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfConvexShape_setPointCount", "PTR", $shape, "INT", $count)
	If @error > 0 Then Return SetError(@error,0,0)

	return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfConvexShape_setPoint
; Description ...: Set the position of a point in a convex shape.
;					Don't forget that the polygon must remain convex, and the points need to stay ordered!
;					setPointCount must be called first in order to set the total number of points.
;					The result is undefined if index is out of the valid range.
; Syntax.........: _CSFML_sfConvexShape_setPoint($shape, $index, $point_x, $point_y)
; Parameters ....: $shape - Shape object
;				   $index - Index of the point to change, in range [0 .. GetPointCount() - 1]
;				   $point - New point
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfConvexShape_setPoint($shape, $index, $point_x, $point_y)

	Local $point = _CSFML_sfVector2f_Constructor($point_x, $point_y)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfConvexShape_setPoint", "PTR", $shape, "INT", $index, "STRUCT", $point)
	If @error > 0 Then Return SetError(@error,0,0)

	return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfConvexShape_setPosition
; Description ...: Set the position of a convex shape.
;					This function completely overwrites the previous position.
;					See sfConvexShape_move to apply an offset based on the previous position instead.
;					The default position of a circle Shape object is (0, 0).
; Syntax.........: _CSFML_sfConvexShape_setPosition($shape, $position_x, $position_y)
; Parameters ....: $shape - Shape object
;				   $index - Index of the point to change, in range [0 .. GetPointCount() - 1]
;				   $point - New point
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfConvexShape_setPosition($shape, $position_x, $position_y)

	Local $position = _CSFML_sfVector2f_Constructor($position_x, $position_y)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfConvexShape_setPosition", "PTR", $shape, "STRUCT", $position)
	If @error > 0 Then Return SetError(@error,0,0)

	return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfConvexShape_setRotation
; Description ...: Set the orientation of a convex shape.
;					This function completely overwrites the previous rotation.
;					See sfConvexShape_rotate to add an angle based on the previous rotation instead.
;					The default rotation of a circle Shape object is 0.
; Syntax.........: _CSFML_sfConvexShape_setRotation($shape, $angle)
; Parameters ....: $shape - Shape object
;				   $angle - New rotation, in degrees
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfConvexShape_setRotation($shape, $angle)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfConvexShape_setRotation", "PTR", $shape, "FLOAT", $angle)
	If @error > 0 Then Return SetError(@error,0,0)

	return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfConvexShape_setOrigin
; Description ...: Set the local origin of a convex shape.
;					The origin of an object defines the center point for all transformations (position, scale, rotation).
;					The coordinates of this point must be relative to the top-left corner of the object, and ignore all
;					transformations (position, scale, rotation). The default origin of a circle Shape object is (0, 0).
; Syntax.........: _CSFML_sfConvexShape_setOrigin($shape, $origin)
; Parameters ....: $shape - Shape object
;				   $origin - New origin (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfConvexShape_setOrigin($shape, $origin)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfConvexShape_setOrigin", "PTR", $shape, "STRUCT", $origin)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfConvexShape_setFillColor
; Description ...: Set the fill color of a convex shape.
;					This color is modulated (multiplied) with the shape's texture if any. It can be used to colorize the shape,
;					or change its global opacity. You can use sfTransparent to make the inside of the shape transparent,
;					and have the outline alone. By default, the shape's fill color is opaque white.
; Syntax.........: _CSFML_sfConvexShape_setFillColor($shape, $origin)
; Parameters ....: $shape - Shape object
;				   $origin - New origin (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfConvexShape_setFillColor($shape, $color)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfConvexShape_setFillColor", "PTR", $shape, "STRUCT", $color)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #SFCOLOR FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfColor_Constructor
; Description ...: Constructs a sfColor structure.
; Syntax.........: _CSFML_sfColor_Constructor($r, $g, $b, $a)
; Parameters ....: $r - the red component (value) of the color
;				   $g - the green component (value) of the color
;				   $b - the blue component (value) of the color
;				   $a - the alpha channel component (value) of the color
; Return values .: Success - the sfColor structure (STRUCT)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfColor_Constructor($r, $g, $b, $a)

	local $sfColor = DllStructCreate("STRUCT;byte;byte;byte;byte;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfColor, 1, $r)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfColor, 2, $g)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfColor, 3, $b)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfColor, 4, $a)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfColor
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfColor_fromRGB
; Description ...: Constructs a sfColor structure, from a RGB value.
; Syntax.........: _CSFML_sfColor_fromRGB($red, $green, $blue)
; Parameters ....: $red - the red component (value) of the color
;				   $green - the green component (value) of the color
;				   $blue - the blue component (value) of the color
; Return values .: Success - the sfColor structure (STRUCT)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfColor_fromRGB($red, $green, $blue)

	Local $sfColor = DllCall($__CSFML_Graphics_DLL, "STRUCT:cdecl", "sfColor_fromRGB", "BYTE", $red, "BYTE", $green, "BYTE", $blue)
	If @error > 0 Then Return SetError(@error,0,0)

	return $sfColor
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfColor_fromInteger
; Description ...: Constructs a sfColor structure, from a RGB value.
; Syntax.........: _CSFML_sfColor_fromInteger($color)
; Parameters ....: $color - Number containing the RGBA components (in that order)
; Return values .: Success - the sfColor structure (STRUCT)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfColor_fromInteger($color)

	Local $sfColor = DllCall($__CSFML_Graphics_DLL, "STRUCT:cdecl", "sfColor_fromInteger", "UINT", $color)
	If @error > 0 Then Return SetError(@error,0,0)

	return $sfColor[0]
EndFunc


; #SFSIZEEVENT FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSizeEvent_Constructor
; Description ...: Constructs a sfSizeEvent structure.
; Syntax.........: _CSFML_sfSizeEvent_Constructor($type, $width, $height)
; Parameters ....: $type - TBD
;				   $width - TBD
;				   $height - TBD
; Return values .: Success - the sfSizeEvent structure (STRUCT)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfSizeEvent_Constructor($type, $width, $height)

	local $sfSizeEvent = DllStructCreate("STRUCT;int;uint;uint;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfSizeEvent, 1, $type)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfSizeEvent, 2, $width)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfSizeEvent, 3, $height)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfSizeEvent
EndFunc


; #SFEVENT FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfEvent_Constructor
; Description ...: Constructs a sfEvent structure.
; Syntax.........: _CSFML_sfEvent_Constructor()
; Parameters ....:
; Return values .: Success - the sfEvent structure (STRUCT)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfEvent_Constructor()

	; type(enum sfEventType);width;height
	local $sfSizeEvent_struct = "int;uint;uint"

	; type(enum sfEventType);code(enum sfKeyCode);alt;control;shift;system
	local $sfKeyEvent_struct = "int;int;bool;bool;bool;bool"

	; type(enum sfEventType);unicode
	local $sfTextEvent_struct = "int;uint"

	; type(enum sfEventType);x;y
	local $sfMouseMoveEvent_struct = "int;int;int"

	; type(enum sfEventType);button(enum sfMouseButton);x;y
	local $sfMouseButtonEvent_struct = "int;int;int;int"

	; type(enum sfEventType);delta;x;y
	local $sfMouseWheelEvent_struct = "int;int;int;int"

	; type(enum sfEventType);wheel(enum sfMouseWheel);delta;x;y
	local $sfMouseWheelScrollEvent_struct = "int;int;float;int;int"

	; type(enum sfEventType);joystickld;axis(enum sfJoystickAxis);position
	local $sfJoystickMoveEvent_struct = "int;uint;int;float"

	; type(enum sfEventType);joystickld;button
	local $sfJoystickButtonEvent_struct = "int;uint;uint"

	; type(enum sfEventType);joystickld
	local $sfJoystickConnectEvent_struct = "int;uint"

	; type(enum sfEventType);finger;x;y
	local $sfTouchEvent_struct = "int;uint;int;int"

	; type(enum sfEventType);sensorType(enum sfSensorType);x;y;z
	local $sfSensorEvent_struct = "int;int;float;float;float"

	local $sfEvent = DllStructCreate("STRUCT;int;" & $sfSizeEvent_struct & ";" & $sfKeyEvent_struct & ";" & $sfTextEvent_struct & ";" & $sfMouseMoveEvent_struct & ";" & $sfMouseButtonEvent_struct & ";" & $sfMouseWheelEvent_struct & ";" & $sfMouseWheelScrollEvent_struct & ";" & $sfJoystickMoveEvent_struct & ";" & $sfJoystickButtonEvent_struct & ";" & $sfJoystickConnectEvent_struct & ";" & $sfTouchEvent_struct & ";" & $sfSensorEvent_struct & ";ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfEvent
EndFunc


; #SFMOUSEBUTTONEVENT FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfMouseButtonEvent_GetData
; Description ...: Gets the data from a mouse button event.
; Syntax.........: _CSFML_sfMouseButtonEvent_GetData()
; Parameters ....: $ptr - the pointer to the mouse button event
; Return values .: Success - the data as a two dimensional array:
;								0 - event type
;								1 - button
;								2 - x position
;								3 - y position
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfMouseButtonEvent_GetData($ptr)

	local $struct = DllStructCreate("STRUCT;int;int;int;int;ENDSTRUCT", $ptr)
	Local $event_type = DllStructGetData($struct, 1)
	Local $button = DllStructGetData($struct, 2)
	Local $x = DllStructGetData($struct, 3)
	Local $y = DllStructGetData($struct, 4)

	Local $data[4] = [$event_type, $button, $x, $y]
	Return $data

EndFunc


; #SFVIDEOMODE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfVideoMode_Constructor
; Description ...: Constructs a sfVideoMode structure.
; Syntax.........: _CSFML_sfVideoMode_Constructor()
; Parameters ....: $width - the width (in pixels) of the video mode.
;				   $height - the height (in pixels) of the video mode.
;				   $bitsPerPixel - the number of bits per pixel of the video mode.
; Return values .: Success - the sfVideoMode structure (STRUCT)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _CSFML_sfVideoMode_Constructor($width, $height, $bitsPerPixel)

	local $sfVideoMode = DllStructCreate("STRUCT;uint;uint;uint;ENDSTRUCT")
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVideoMode, 1, $width)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVideoMode, 2, $height)
	If @error > 0 Then Return SetError(@error,0,0)

	DllStructSetData($sfVideoMode, 3, $bitsPerPixel)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $sfVideoMode
EndFunc


; #SFRENDERWINDOW FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_create
; Description ...: Constructs a new render window.
; Syntax.........: _CSFML_sfRenderWindow_create($mode, $title, $style, $settings)
; Parameters ....: $mode - Video mode to use
;				   $title - Title of the window
;				   $style - Window style
;				   $settings - Creation settings (pass Null to use default values)
; Return values .: Success - a pointer to the sfRenderWindow structure (PTR)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_create($mode, $title, $style, $settings = Null)

	Local $sfRenderWindow = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfRenderWindow_create", "STRUCT", $mode, "STR", $title, "UINT", $style, "PTR", $settings)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfRenderWindow_ptr = $sfRenderWindow[0]
	Return $sfRenderWindow_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_setVerticalSyncEnabled
; Description ...: Enable / disable vertical synchronization on a render window.
; Syntax.........: _CSFML_sfRenderWindow_setVerticalSyncEnabled($renderWindow, $enabled)
; Parameters ....: $renderWindow - Render window object
;				   $enabled - True to enable v-sync, False to deactivate
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_setVerticalSyncEnabled($renderWindow, $enabled)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_setVerticalSyncEnabled", "PTR", $renderWindow, "BOOL", $enabled)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_setFramerateLimit
; Description ...: Enable / disable vertical synchronization on a render window.
; Syntax.........: _CSFML_sfRenderWindow_setFramerateLimit($renderWindow, $limit)
; Parameters ....: $renderWindow - Render window object
;				   $limit - Framerate limit, in frames per seconds (use 0 to disable limit)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_setFramerateLimit($renderWindow, $limit)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_setVerticalSyncEnabled", "PTR", $renderWindow, "UINT", $limit)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_getSystemHandle
; Description ...: Retrieve the OS-specific handle of a render window.
; Syntax.........: _CSFML_sfRenderWindow_getSystemHandle($renderWindow, $limit)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - Window handle
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_getSystemHandle($renderWindow)

	Local $sfWindowHandle = DllCall($__CSFML_Graphics_DLL, "HWND:cdecl", "sfRenderWindow_getSystemHandle", "PTR", $renderWindow)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfWindowHandle_val = $sfWindowHandle[0]
	Return $sfWindowHandle_val

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_isOpen
; Description ...: Tell whether or not a render window is opened.
; Syntax.........: _CSFML_sfRenderWindow_isOpen($renderWindow)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - True is window is open, False if it is not open
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_isOpen($renderWindow)

	Local $sfBool = DllCall($__CSFML_Graphics_DLL, "INT:cdecl", "sfRenderWindow_isOpen", "PTR", $renderWindow)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfBool_val = $sfBool[0]
	Return $sfBool_val
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_pollEvent
; Description ...: Get the event on top of event queue of a render window, if any, and pop it.
; Syntax.........: _CSFML_sfRenderWindow_pollEvent($renderWindow, $event)
; Parameters ....: $renderWindow - Render window object
;				   $event - Event to fill, if any
; Return values .: Success - True if an event was returned, False if event queue was empty
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_pollEvent($renderWindow, $event)

	Local $sfBool = DllCall($__CSFML_Graphics_DLL, "INT:cdecl", "sfRenderWindow_pollEvent", "PTR", $renderWindow, "PTR", $event)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfBool_val = $sfBool[0]
	Return $sfBool_val
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_clear
; Description ...: Clear a render window with the given color.
; Syntax.........: _CSFML_sfRenderWindow_clear($renderWindow, $color)
; Parameters ....: $renderWindow - Render window object
;				   $color - Fill color
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_clear($renderWindow, $color)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_clear", "PTR", $renderWindow, "STRUCT", $color)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_drawText
; Description ...: Draw text in a render window.
; Syntax.........: _CSFML_sfRenderWindow_drawText($renderWindow, $object, $states)
; Parameters ....: $renderWindow - Render window object
;				   $object - the text to draw
;				   $states - Render states to use for drawing (Null to use the default states)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_drawText($renderWindow, $object, $states)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_drawText", "PTR", $renderWindow, "PTR", $object, "PTR", $states)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_drawTextString
; Description ...: A convenience function to set the string of a sfText object and draw it in one call.
; Syntax.........: _CSFML_sfRenderWindow_drawTextString($renderWindow, $object, $states)
; Parameters ....: $renderWindow - Render window object
;				   $object - the text to draw
;				   $states - Render states to use for drawing (Null to use the default states)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_drawTextString($renderWindow, $object, $string, $states)

	_CSFML_sfText_setString($object, $string)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_drawText", "PTR", $renderWindow, "PTR", $object, "PTR", $states)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_drawSprite
; Description ...: Draw a drawable object to the render-target.
; Syntax.........: _CSFML_sfRenderWindow_drawSprite($renderWindow, $object, $states)
; Parameters ....: $renderWindow - Render window object
;				   $object - the sprite to draw
;				   $states - Render states to use for drawing (Null to use the default states)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_drawSprite($renderWindow, $object, $states)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_drawSprite", "PTR", $renderWindow, "PTR", $object, "PTR", $states)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_drawConvexShape
; Description ...: Draw a drawable object to the render-target.
; Syntax.........: _CSFML_sfRenderWindow_drawConvexShape($renderWindow, $object, $states)
; Parameters ....: $renderWindow - Render window object
;				   $object - the convex shape to draw
;				   $states - Render states to use for drawing (Null to use the default states)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_drawConvexShape($renderWindow, $object, $states)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_drawConvexShape", "PTR", $renderWindow, "PTR", $object, "PTR", $states)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_display
; Description ...: Display a render window on screen.
; Syntax.........: _CSFML_sfRenderWindow_display($renderWindow)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_display($renderWindow)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_display", "PTR", $renderWindow)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfRenderWindow_close
; Description ...: Close a render window (but doesn't destroy the internal data).
; Syntax.........: _CSFML_sfRenderWindow_close($renderWindow)
; Parameters ....: $renderWindow - Render window object
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfRenderWindow_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfRenderWindow_close($renderWindow)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfRenderWindow_close", "PTR", $renderWindow)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc


; #SFTEXTURE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfTexture_createFromFile
; Description ...: Create a new texture from a file.
; Syntax.........: _CSFML_sfTexture_createFromFile($filename, $area)
; Parameters ....: $filename - Path of the image file to load
;				   $area - Area of the source image to load (Null to load the entire image)
; Return values .: Success - a pointer to the sfTexture (PTR)
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfTexture_createFromFile($filename, $area)

	Local $sfTexture = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfTexture_createFromFile", "STR", $filename, "PTR", $area)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfTexture_ptr = $sfTexture[0]
	Return $sfTexture_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfTexture_destroy
; Description ...: Destroys a texture.
; Syntax.........: _CSFML_sfTexture_destroy($texture)
; Parameters ....: $texture - pointer
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfTexture_destroy($texture)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfTexture_destroy", "PTR", $texture)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc


; #SFSPRITE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSpriteArray_GetItemRotation
; Description ...: A convenience function that gets the rotation of a sprite based on it's index in the internal array
; Syntax.........: _CSFML_sfSpriteArray_GetItemRotation($index)
; Parameters ....:
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
;Func _CSFML_sfSpriteArray_GetItemRotation($index)

;	Return _CSFML_sfSprite_getRotation($__sprite_ptr[$index])

;EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSpriteArray_SetItemRotation
; Description ...: A convenience function that sets the rotation of a sprite based on it's index in the internal array
; Syntax.........: _CSFML_sfSpriteArray_SetItemRotation()
; Parameters ....:
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
;Func _CSFML_sfSpriteArray_SetItemRotation($index, $angle)

;	_CSFML_sfSprite_setRotation($__sprite_ptr[$index], $angle)

;EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_create
; Description ...: Create a new sprite.
; Syntax.........: _CSFML_sfSprite_create()
; Parameters ....: None
; Return values .: Success - A new sfSprite object (PTR)
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_create()

	Local $sfSprite = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfSprite_create")
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfSprite_ptr = $sfSprite[0]
	Return $sfSprite_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_destroy
; Description ...: Destroy an existing sprite.
; Syntax.........: _CSFML_sfSprite_destroy($sprite)
; Parameters ....: $sprite - Sprite to delete
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_destroy($sprite)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_destroy", "PTR", $sprite)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setTexture
; Description ...: Change the source texture of a sprite.
;				   The texture argument refers to a texture that must exist as long as the sprite uses it.
;				   Indeed, the sprite doesn't store its own copy of the texture, but rather keeps a pointer to the one that
;				   you passed to this function. If the source texture is destroyed and the sprite tries to use it, the behaviour
;                  is undefined. If resetRect is true, the TextureRect property of the sprite is automatically adjusted to the
;				   size of the new texture. If it is false, the texture rect is left unchanged.
; Syntax.........: _CSFML_sfSprite_setTexture($sprite, $texture, $resetRect)
; Parameters ....: $sprite - Sprite to delete
;				   $texture - New texture
;				   $resetRect - Should the texture rect be reset to the size of the new texture?
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_setTexture($sprite, $texture, $resetRect)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_setTexture", "PTR", $sprite, "PTR", $texture)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setTextureRect
; Description ...: Set the sub-rectangle of the texture that a sprite will display.
;				   The texture rect is useful when you don't want to display the whole texture, but rather a part of it.
;				   By default, the texture rect covers the entire texture.
; Syntax.........: _CSFML_sfSprite_setTextureRect($sprite, $left, $top, $width, $height)
; Parameters ....: $sprite - Sprite to delete
;				   $left
;				   $top
;				   $width
;				   $height
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_setTextureRect($sprite, $left, $top, $width, $height)

	local $rectangle = DllStructCreate("STRUCT;int;int;int;int;ENDSTRUCT")
	DllStructSetData($rectangle, 1, $left)
	DllStructSetData($rectangle, 2, $top)
	DllStructSetData($rectangle, 3, $width)
	DllStructSetData($rectangle, 4, $height)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_setTextureRect", "PTR", $sprite, "STRUCT", $rectangle)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setPosition
; Description ...: Set the position of a sprite, with a sfVector2f structure.
;				   This function completely overwrites the previous position. See sfSprite_move to apply an offset based
;				   on the previous position instead. The default position of a sprite Sprite object is (0, 0).
; Syntax.........: _CSFML_sfSprite_setPosition($sprite, $position)
; Parameters ....: $sprite - Sprite object
;				   $position - New position (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: This function is slightly slower than _CSFML_sfSprite_setPosition_xy by about 100 frames per second
; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_setPosition($sprite, $position)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_setPosition", "PTR", $sprite, "STRUCT", $position)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setPosition_xy
; Description ...: Set the position of a sprite, with horizontal and vertical coordinates.
;				   This function completely overwrites the previous position. See sfSprite_move to apply an offset based
;				   on the previous position instead. The default position of a sprite Sprite object is (0, 0).
; Syntax.........: _CSFML_sfSprite_setPosition_xy($sprite, $x, $y)
; Parameters ....: $sprite - Sprite object
;				   $position - New position (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: This function is slightly faster than _CSFML_sfSprite_setPosition by about 100 frames per second
; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_setPosition_xy($sprite, $x, $y)


	local $sfVector2f = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	DllStructSetData($sfVector2f, 1, $x)
	DllStructSetData($sfVector2f, 2, $y)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_setPosition", "PTR", $sprite, "STRUCT", $sfVector2f)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_getRotation
; Description ...: Get the orientation of a sprite.
;					The rotation is always in the range [0, 360].
; Syntax.........: _CSFML_sfSprite_getRotation($sprite)
; Parameters ....: $sprite - Sprite object
; Return values .: Success - Current rotation, in degrees
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_getRotation($sprite)

	Local $angle = DllCall($__CSFML_Graphics_DLL, "FLOAT:cdecl", "sfSprite_getRotation", "PTR", $sprite)
	If @error > 0 Then Return SetError(@error,0,0)

	Return $angle[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setRotation
; Description ...: Set the orientation of a sprite.
;				   This function completely overwrites the previous rotation. See sfSprite_rotate to add an angle based on
;				   the previous rotation instead. The default rotation of a sprite Sprite object is 0.
; Syntax.........: _CSFML_sfSprite_setRotation($sprite, $angle)
; Parameters ....: $sprite - Sprite object
;				   $angle - New rotation, in degrees
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_setRotation($sprite, $angle)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_setRotation", "PTR", $sprite, "FLOAT", $angle)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_rotate
; Description ...: Rotate a sprite.
;				   This function adds to the current rotation of the object, unlike sfSprite_setRotation which overwrites it.
; Syntax.........: _CSFML_sfSprite_rotate($sprite, $angle)
; Parameters ....: $sprite - Sprite object
;				   $angle - Angle of rotation, in degrees
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_rotate($sprite, $angle)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_rotate", "PTR", $sprite, "float", $angle)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfSprite_setOrigin
; Description ...: Set the local origin of a sprite.
;				   The origin of an object defines the center point for all transformations (position, scale, rotation).
;				   The coordinates of this point must be relative to the top-left corner of the object, and ignore all
;				   transformations (position, scale, rotation). The default origin of a sprite Sprite object is (0, 0).
; Syntax.........: _CSFML_sfSprite_setOrigin($sprite, $origin)
; Parameters ....: $sprite - Sprite object
;				   $origin - New origin (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfSprite_setOrigin($sprite, $origin)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfSprite_setOrigin", "PTR", $sprite, "STRUCT", $origin)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc


; #SFFONT FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfFont_createFromFile
; Description ...: Create a new font from a file.
; Syntax.........: _CSFML_sfFont_createFromFile($filename)
; Parameters ....: $filename - Path of the font file to load
; Return values .: Success - A new sfFont object
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfFont_createFromFile($filename)

	Local $sfFont = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfFont_createFromFile", "STR", $filename)
;	_ArrayDisplay($sfFont)
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfFont_ptr = $sfFont[0]
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sfFont_ptr = ' & $sfFont_ptr & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Return $sfFont_ptr
EndFunc


; #SFTEXT FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_create
; Description ...: Create a new text.
; Syntax.........: _CSFML_sfText_create()
; Parameters ....: None
; Return values .: Success - A new sfText object
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_create()

	Local $sfText = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfText_create")
;	_ArrayDisplay($sfText)
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfText_ptr = $sfText[0]
	Return $sfText_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_create_and_set
; Description ...: A convenience function to create a new text and also set it's properties in one call.
; Syntax.........: _CSFML_sfText_create_and_set()
; Parameters ....: None
; Return values .: Success - A new sfText object
;				   Failure - 0 or Null
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_create_and_set($font_ptr, $size, $color, $x, $y)

	Local $sfText = DllCall($__CSFML_Graphics_DLL, "PTR:cdecl", "sfText_create")
	If @error > 0 Then Return SetError(@error,0,0)

	Local $sfText_ptr = $sfText[0]

	_CSFML_sfText_setFont($sfText_ptr, $font_ptr)
	_CSFML_sfText_setCharacterSize($sfText_ptr, $size)
	_CSFML_sfText_setFillColor($sfText_ptr, $color)
	_CSFML_sfText_setPosition_xy($sfText_ptr, $x, $y)

	Return $sfText_ptr
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setString
; Description ...: Set the string of a text (from an ANSI string).
;				   A text's string is empty by default
; Syntax.........: _CSFML_sfText_setString($text, $string)
; Parameters ....: $text - Text object
;				   $string - New string
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_setString($text, $string)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfText_setString", "PTR", $text, "STR", $string)
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setPosition
; Description ...: Set the position of a text.
;				   This function completely overwrites the previous position. See sfText_move to apply an offset based on
;				   the previous position instead. The default position of a text Text object is (0, 0).

; Syntax.........: _CSFML_sfText_setPosition($text, $position)
; Parameters ....: $text - Text object
;				   $position - New position
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_setPosition($text, $position)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfText_setPosition", "PTR", $text, "PTR", $position)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setPosition_xy
; Description ...: Set the position of a sprite, with horizontal and vertical coordinates.
;				   This function completely overwrites the previous position. See sfSprite_move to apply an offset based
;				   on the previous position instead. The default position of a sprite Sprite object is (0, 0).
; Syntax.........: _CSFML_sfText_setPosition_xy($text, $x, $y)
; Parameters ....: $sprite - Text object
;				   $position - New position (sfVector2f)
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: This function is slightly faster than _CSFML_sfSprite_setPosition by about 100 frames per second
; Related .......: _CSFML_sfSprite_create, _CSFML_sfVector2f_Constructor
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_setPosition_xy($text, $x, $y)


	local $sfVector2f = DllStructCreate("STRUCT;float;float;ENDSTRUCT")
	DllStructSetData($sfVector2f, 1, $x)
	DllStructSetData($sfVector2f, 2, $y)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfText_setPosition", "PTR", $text, "STRUCT", $sfVector2f)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setFont
; Description ...: Set the font of a text.
;				   The font argument refers to a texture that must exist as long as the text uses it. Indeed, the text
;				   doesn't store its own copy of the font, but rather keeps a pointer to the one that you passed to this
;				   function. If the font is destroyed and the text tries to use it, the behaviour is undefined
; Syntax.........: _CSFML_sfText_setFont($text, $font)
; Parameters ....: $text - Text object
;				   $font - New font
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_setFont($text, $font)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfText_setFont", "PTR", $text, "PTR", $font)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setCharacterSize
; Description ...: Set the character size of a text.
;				   The default size is 30.
; Syntax.........: _CSFML_sfText_setCharacterSize($text, $size)
; Parameters ....: $text - Text object
;				   $size - New character size, in pixels
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_setCharacterSize($text, $size)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfText_setCharacterSize", "PTR", $text, "UINT", $size)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfText_setFillColor
; Description ...: Set the fill color of a text.
;				   By default, the text's fill color is opaque white. Setting the fill color to a transparent color with an
;				   outline will cause the outline to be displayed in the fill area of the text.
; Syntax.........: _CSFML_sfText_setFillColor($text, $color)
; Parameters ....: $text - Text object
;				   $color - New fill color of the text
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfText_setFillColor($text, $color)

	DllCall($__CSFML_Graphics_DLL, "NONE:cdecl", "sfText_setFillColor", "PTR", $text, "STRUCT", $color)
	If @error > 0 Then Return SetError(@error,0,0)

	Return True
EndFunc


; #SFTEXT FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _CSFML_sfMouse_getPosition
; Description ...: Set the fill color of a text.
;				   By default, the text's fill color is opaque white. Setting the fill color to a transparent color with an
;				   outline will cause the outline to be displayed in the fill area of the text.
; Syntax.........: _CSFML_sfMouse_getPosition($text, $color)
; Parameters ....: $text - Text object
;				   $color - New fill color of the text
; Return values .: Success - True
;				   Failure - 0
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: I can't seem to get this function working.  In the interim use AutoIT's own mouse functions.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func  _CSFML_sfMouse_getPosition($relativeTo)

	Local $sfVector2i = DllCall($__CSFML_Window_DLL, "STRUCT:cdecl", "sfMouse_getPosition", "PTR", $relativeTo)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If @error > 0 Then Return SetError(@error,0,0)

	local $sfVector2i_struct = DllStructCreate("STRUCT;uint;uint;ENDSTRUCT", DllStructGetPtr($sfVector2i[0]))

	$rr = DllStructGetSize($sfVector2i_struct)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $rr = ' & $rr & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	Local $position_x = DllStructGetData($sfVector2i_struct, 1)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $position_x = ' & $position_x & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Local $position_y = DllStructGetData($sfVector2i_struct, 2)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $position_y = ' & $position_y & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Local $position[2] = [$position_x, $position_y]

	Return $position
EndFunc

