
; #INDEX# =======================================================================================================================
; Title .........: Box2CEx
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Convenience functions and Graphical library extensions (GDI+, Direct2D, SFML, Irrlicht) for Box2D
; Author(s) .....: Sean Griffin
; Dlls ..........:
; ===============================================================================================================================

#include-once
#include <Array.au3>
#include <GDIPlus.au3>
#include <Timers.au3>
#include "Box2C.au3"
#include "CSFML.au3"

; #VARIABLES# ===================================================================================================================
Global $__pixels_per_metre = 50
Global $__GUI_Area[2]
Global $__playing_anim
Global $__interrupt_anim = False
Global $__destroy_all_bodies = False
Global $__body_def[0][21]
Global $__current_shape_vertice
Global $__shape_vertice_struct[0]
Global $__shape_vertice_struct_ptr[0]
Global $__shape_vertice_struct_size[0]

Global $__shape_vertice[0]
Global $__shape_image[0]
Global $__shape_struct[0]
Global $__shape_struct_ptr[0]

Global $__bodydef_struct[0]
Global $__bodydef_struct_ptr[0]

Global $__body_struct_ptr[0]
Global $__fixture_struct_ptr[0]
Global $__body_hGfx_Buffer[0]
Global $__body_width[0]
Global $__body_height[0]
Global $__body_prev_screen_x[0]
Global $__body_prev_screen_y[0]
Global $__body_curr_screen_x[0]
Global $__body_curr_screen_y[0]
Global $__body_prev_angle_degrees[0]
Global $__body_curr_angle_degrees[0]
Global $__body_gui_pos[0][2]
Global $__body_shape_index[0]

Global $__world_ptr
Global $__world_animation_timer

Global $__g_hGraphics
Global $__g_hBmp_Buffer
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Enum $width, $height, $origin_x, $origin_y, $origin_angle_degrees, $origin_gui_x, $origin_gui_y, $prev_screen_x, $prev_screen_y, $curr_screen_x, $curr_screen_y, $prev_angle_degrees, $curr_angle_degrees, $b2BodyDef_struct, $b2BodyDef_ptr, $b2PolygonShapePortable_struct, $b2PolygonShapePortable_ptr, $b2Body_ptr, $b2Fixture_ptr, $g_hGfx_Buffer, $hImage
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; x_metres_to_gui_x
; y_metres_to_gui_y
; metres_to_pixels
; atan2
; radians_to_degrees
; degrees_to_radians
; _Box2C_b2Vec2_GetGUIPosition
; _Box2C_b2World_SetPixelsPerMetre
; _Box2C_b2World_SetGUIArea
; _Box2C_b2World_GetGUIArea
; _Box2C_b2World_GetGUIAreaCenter
; _Box2C_b2World_StartAnimation
; _Box2C_b2World_Setup
; _Box2C_b2World_GDIPlusSetup
; _Box2C_b2World_Create
; _Box2C_b2World_Animate_GDIPlus
; _Box2C_b2World_WaitForAnimateEnd
; _Box2C_b2PolygonShape_ArrayAdd
; _Box2C_b2PolygonShape_ArrayAdd_SFML
; _Box2C_b2BodyDef_ArrayAdd
; _Box2C_b2Body_ArrayAdd
; _Box2C_b2Body_ArrayAdd_SFML
; _Box2C_b2Body_Transform_GDIPlus
; _Box2C_b2Body_Destroy
; _Box2C_b2Body_Rotate_GDIPlus
; ===============================================================================================================================


; #MISCELLANEOUS FUNCTIONS# =====================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: x_metres_to_gui_x
; Description ...: Convert horizontal (Box2D) metres to a horizontal GUI (pixel) position
; Syntax.........: x_metres_to_gui_x($metres, $x_origin)
; Parameters ....: $metres - the number of metres (in the Box2D world)
;				   $x_origin - the horizontal (Box2D world) origin in the GUI.  Typically the center pixel of the GUI.
; Return values .: the horizontal (pixel) position in the GUI
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func x_metres_to_gui_x($metres, $x_origin)

	Return int($x_origin + metres_to_pixels($metres))
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: y_metres_to_gui_y
; Description ...: Convert vertical (Box2D) metres to a vertical GUI (pixel) position
; Syntax.........: y_metres_to_gui_y($metres, $y_origin)
; Parameters ....: $metres - the number of metres (in the Box2D world)
;				   $y_origin - the vertical (Box2D world) origin in the GUI.  Typically the center pixel of the GUI.
; Return values .: the vertical (pixel) position in the GUI
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func y_metres_to_gui_y($metres, $y_origin)

	Return int($y_origin - metres_to_pixels($metres))
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: metres_to_pixels
; Description ...: Convert (Box2D) metres to (GUI) pixels
; Syntax.........: metres_to_pixels($metres)
; Parameters ....: $metres - the number of metres (in the Box2D world)
; Return values .: the number of pixels (in the GUI)
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func metres_to_pixels($metres)

	Return $metres * $__pixels_per_metre
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: atan2
; Description ...:
; Syntax.........: atan2($y, $x)
; Parameters ....: $y -
;				   $x -
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func atan2($y, $x)

    Return (2 * ATan($y / ($x + Sqrt($x * $x + $y * $y))))
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: radians_to_degrees
; Description ...: Convert (Box2D) radians to (SFML) degrees
; Syntax.........: radians_to_degrees($radians)
; Parameters ....: $radians - the number of radians (in the Box2D world)
; Return values .: the number of degrees (in SFML)
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func radians_to_degrees($radians)

	Return $radians / 0.01745329252
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: degrees_to_radians
; Description ...: Convert (SFML) degrees to (Box2D) radians
; Syntax.........: degrees_to_radians($degrees)
; Parameters ....: $degrees - the number of degrees (in SFML)
; Return values .: the number of radians (in Box2D)
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func degrees_to_radians($degrees)

	Return $degrees * 0.01745329252
EndFunc


; #B2VEC2 FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Vec2_GetGUIPosition
; Description ...: Convert a Box2D position (in metres) to a SFML / GUI position (in pixels)
; Syntax.........: _Box2C_b2Vec2_GetGUIPosition($world_x, $world_y, $vertices)
; Parameters ....: $world_x - the horizontal component of the Box2D vector
;				   $world_y - the vertical component of the Box2D vector
;				   $vertices - a two dimensional array of vertices making up the shape
; Return values .: the GUI position in a two element array
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Vec2_GetGUIPosition($world_x, $world_y, $vertices)

	Local $gui_pos[2]

	; get the GUI center
	Local $gui_x_center = $__GUI_Area[0] / 2
	Local $gui_y_center = $__GUI_Area[1] / 2

	; get the size (largest vertice values) of the polygon

;	Local $world_width = _ArrayMax($vertices, 1, -1, -1, 0)
	Local $world_height = _ArrayMax($vertices, 1, -1, -1, 1)

	; get the centroid of the vertices

	Local $centroid = _Box2C_b2PolygonShape_ComputeCentroid($vertices)

	$gui_pos[0] = $gui_x_center + ($world_x * $__pixels_per_metre) - (($centroid[0]) * $__pixels_per_metre)
	$gui_pos[1] = $gui_y_center - ($world_y * $__pixels_per_metre) - (($world_height - $centroid[1]) * $__pixels_per_metre)
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $centroid[1] = ' & $centroid[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $world_y = ' & $world_y & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $gui_y_center = ' & $gui_y_center & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


	return $gui_pos

endFunc


; #B2WORLD FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_SetPixelsPerMetre
; Description ...: Define the number of SFML / GUI pixels representing a single Box2D metre
; Syntax.........: _Box2C_b2World_SetPixelsPerMetre($pixels_per_metre)
; Parameters ....: $pixels_per_metre - the number of pixels per metre
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: The pixels per metres you set here will be used in all other functions in this UDF
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_SetPixelsPerMetre($pixels_per_metre = 50)

	$__pixels_per_metre = $pixels_per_metre
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_SetGUIArea
; Description ...: Define the width and height (area) of the GUI that the Box2D world is within
; Syntax.........: _Box2C_b2World_SetGUIArea($x, $y)
; Parameters ....: $x - the width of the GUI area in pixels
;				   $y - the height of the GUI area in pixels
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_SetGUIArea($x, $y)

	$__GUI_Area[0] = $x
	$__GUI_Area[1] = $y
EndFunc

; $flag = 0 (get width)
; $flag = 1 (get height)
; $flag = 2 (get array of width and height)

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_GetGUIArea
; Description ...: Get the defined area of the GUI for Box2D
; Syntax.........: _Box2C_b2World_GetGUIArea($flag)
; Parameters ....: $flag - 0 = return the horizontal width of the area
;						   1 = return the vertical height of the area
;						   2 = return both the width and height of the area
; Return values .: as above
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_GetGUIArea($flag = 2)

	Switch $flag

		Case 0

			Return $__GUI_Area[0]

		Case 1

			Return $__GUI_Area[1]

		Case 2

			Return $__GUI_Area
	EndSwitch

	Return -1
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_GetGUIAreaCenter
; Description ...: Get the center of the defined area of the GUI for Box2D
; Syntax.........: _Box2C_b2World_GetGUIAreaCenter($flag)
; Parameters ....: $flag - 0 = return the horizontal center of the area
;						   1 = return the vertical center of the area
;						   2 = return both horizontal and vertical center of the area
; Return values .: as above
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_GetGUIAreaCenter($flag = 2)

	Switch $flag

		Case 0

			Return $__GUI_Area[0] / 2

		Case 1

			Return $__GUI_Area[1] / 2

		Case 2

			Local $gui_center[2]
			$gui_center[0] = $__GUI_Area[0] / 2
			$gui_center[1] = $__GUI_Area[1] / 2
			Return $gui_center

	EndSwitch

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_StartAnimation
; Description ...: Trigger a timed interation for a Box2D animation loop
; Syntax.........: _Box2C_b2World_StartAnimation($g_hGUI, $iSleep)
; Parameters ....: $g_hGUI - the AutoIT GUI to set the timer for
;				   $iSleep - the interval
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_StartAnimation($g_hGUI, $iSleep)

	$__world_animation_timer = _Timer_SetTimer($g_hGUI, $iSleep, "_Box2C_b2World_Animate")

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_Setup
; Description ...: A convenience function that configures the entire Box2D world in one call.
;				   Sets the pixels per metre, GUI area, and creates the world with the defined gravity values.
; Syntax.........: _Box2C_b2World_Setup($pixels_per_metre, $gui_width, $gui_height, $gravity_x, $gravity_y)
; Parameters ....: $pixels_per_metre - the AutoIT GUI to set the timer for
;				   $gui_width - the interval
;				   $gui_height -
;				   $gravity_x -
;				   $gravity_y -
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_Setup($pixels_per_metre = 50, $gui_width = 640, $gui_height = 480, $gravity_x = 0, $gravity_y = -10)

	_Box2C_Startup()
	_Box2C_b2World_SetPixelsPerMetre($pixels_per_metre)
	_Box2C_b2World_SetGUIArea($gui_width, $gui_height)
	_Box2C_b2World_Create($gravity_x, $gravity_y)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_Create
; Description ...: A convenience function that creates the Box2D world in one call.
; Syntax.........: _Box2C_b2World_Create($gravity_x, $gravity_y)
; Parameters ....: $gravity_x - the horizontal component of gravity
;				   $gravity_y - the vertical component of gravity
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_Create($gravity_x, $gravity_y)

	local $gravity = _Box2C_b2Vec2_Constructor($gravity_x, $gravity_y)
	$__world_ptr = _Box2C_b2World_Constructor($gravity, True)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_GDIPlusSetup
; Description ...: A setup routine specifically for GDI+ (not Box2D)
; Syntax.........: _Box2C_b2World_GDIPlusSetup($g_hGUI)
; Parameters ....: $g_hGUI - the AutoIT GUI
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_GDIPlusSetup($g_hGUI)

	_GDIPlus_Startup()
	$__g_hGraphics = _GDIPlus_GraphicsCreateFromHWND($g_hGUI)
	$__g_hBmp_Buffer = _GDIPlus_BitmapCreateFromGraphics(_Box2C_b2World_GetGUIArea(0), _Box2C_b2World_GetGUIArea(1), $__g_hGraphics)


EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_Animate_GDIPlus
; Description ...: The animation loop specifically for Box2D and GDI+
; Syntax.........: _Box2C_b2World_Animate_GDIPlus($hWnd, $iMsg, $iIDTimer, $iTime)
; Parameters ....: $hWnd
;				   $iMsg
;				   $iIDTimer
;				   $iTime
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_Animate_GDIPlus($hWnd, $iMsg, $iIDTimer, $iTime)
    #forceref $hWnd, $iMsg, $iIDTimer, $iTime

	if $__destroy_all_bodies = True Then

		Exit
	EndIf

	if $__interrupt_anim = False Then

		$__playing_anim = True
		Local $transform_result = False

		; Animation step

		_Box2C_b2World_Step($__world_ptr, (1.0 / 60.0), 6, 2)

		; Transform Bodies

		for $body_num = 0 to (UBound($__body_struct_ptr) - 1)

			$transform_result = _Box2C_b2Body_Transform_GDIPlus($body_num)

			; if a body was destroyed then skip this frame of animation
			if $transform_result = False Then

				ExitLoop
			EndIf
		Next

		; Draw the shapes at the body GUI positions

		_GDIPlus_GraphicsClear($__body_hGfx_Buffer[0], 0xFFFFFFFF)

		for $body_num = 0 to (UBound($__body_struct_ptr) - 1)

			_GDIPlus_GraphicsDrawImage($__body_hGfx_Buffer[$body_num], $__shape_image[$__body_shape_index[$body_num]], $__body_gui_pos[$body_num][0], $__body_gui_pos[$body_num][1])
		Next

		_GDIPlus_GraphicsDrawImage($__g_hGraphics, $__g_hBmp_Buffer, 0, 0)

		$__playing_anim = False
	EndIf

EndFunc   ;==>PlayAnim

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_WaitForAnimateEnd
; Description ...:
; Syntax.........: _Box2C_b2World_WaitForAnimateEnd()
; Parameters ....: None
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_WaitForAnimateEnd()

	While $__playing_anim = True

		Sleep(250)
	WEnd

EndFunc


; #B2POLYGONSHAPE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_ArrayAdd_GDIPlus
; Description ...: A convenience function for GDI+ that adds a polygon shape (b2PolygonShape) to an internal array of shapes.
; Syntax.........: _Box2C_b2PolygonShape_ArrayAdd_GDIPlus($vertice, $shape_image_file_path)
; Parameters ....: $vertice
;				   $shape_image_file_path
; Return values .: The index of the shape within the internal array of shapes.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_ArrayAdd_GDIPlus($vertice, $shape_image_file_path)

;	Local $vertice_struct_str = "STRUCT"

;	for $i = 1 to UBound($vertice)

;		$vertice_struct_str = $vertice_struct_str & ";float;float"
;	Next

;	$vertice_struct_str = $vertice_struct_str & ";ENDSTRUCT"

;	$struct_array_index = _ArrayAdd($__shape_vertice_struct, Null)

;	$__shape_vertice_struct[$struct_array_index] = DllStructCreate($vertice_struct_str)
;	Local $shape_vertice_struct_element_num = 0

;	for $i = 0 to (UBound($vertice) - 1)

;		$shape_vertice_struct_element_num = $shape_vertice_struct_element_num + 1
;		DllStructSetData($__shape_vertice_struct[$struct_array_index], $shape_vertice_struct_element_num, $vertice[$i][0])
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $shape_vertice_struct_element_num = ' & $shape_vertice_struct_element_num & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $vertice[$i][0] = ' & $vertice[$i][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;		$shape_vertice_struct_element_num = $shape_vertice_struct_element_num + 1
;		DllStructSetData($__shape_vertice_struct[$struct_array_index], $shape_vertice_struct_element_num, $vertice[$i][1])
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $shape_vertice_struct_element_num = ' & $shape_vertice_struct_element_num & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $vertice[$i][1] = ' & $vertice[$i][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;	Next

;	Local $struct_ptr_array_index = _ArrayAdd($__shape_vertice_struct_ptr, Null)

;	$__shape_vertice_struct_ptr[$struct_ptr_array_index] = DllStructGetPtr($__shape_vertice_struct[$struct_array_index])

;	_ArrayAdd($__shape_vertice_struct_size, (UBound($vertice) * 2))


;	Local $shape_vertice_index = _ArrayAdd($__shape_vertice, $vertice)
	Local $shape_vertice_index = _ArrayAdd($__shape_vertice, Null)
	$__shape_vertice[$shape_vertice_index] = $vertice

;	Local $struct_image_array_index = _ArrayAdd($__shape_image, _CSFML_sfTexture_createFromFile($shape_image_file_path, Null))

	Local $struct_image_array_index = _ArrayAdd($__shape_image, _GDIPlus_ImageLoadFromFile($shape_image_file_path))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $shape_image_file_path = ' & $shape_image_file_path & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	Local $shape_struct_index = _ArrayAdd($__shape_struct, _Box2C_b2PolygonShape_Constructor($vertice))
	_ArrayAdd($__shape_struct_ptr, DllStructGetPtr($__shape_struct[$shape_struct_index]))

	Return $shape_struct_index







;	Return $struct_array_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_ArrayAdd_SFML
; Description ...: A convenience function for SFML that adds a polygon shape (b2PolygonShape) to an internal array of shapes.
; Syntax.........: _Box2C_b2PolygonShape_ArrayAdd_SFML($vertice, $shape_image_file_path)
; Parameters ....: $vertice - the vectices of the shape to add
;				   $shape_image_file_path - the path to the image file of the shape to add
; Return values .: The index of the shape within the internal array of shapes.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_ArrayAdd_SFML($vertice, $shape_image_file_path)

	; add the new vertices to the internal array of shape vertices
	Local $shape_vertice_index = _ArrayAdd($__shape_vertice, Null)
	$__shape_vertice[$shape_vertice_index] = $vertice

	; add the new sfTexture to the internal array of shape images
	Local $struct_image_array_index = _ArrayAdd($__shape_image, _CSFML_sfTexture_createFromFile($shape_image_file_path, Null))

	; create a new Box2C Polygone Shape for the new vertices and add it to the internal array of shape structures
	Local $shape_struct_index = _ArrayAdd($__shape_struct, _Box2C_b2PolygonShape_Constructor($vertice))
	_ArrayAdd($__shape_struct_ptr, DllStructGetPtr($__shape_struct[$shape_struct_index]))

	; return the index of the new shape within the internal arrays of shapes
	Return $shape_struct_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2PolygonShape_ArrayAdd_Irrlicht
; Description ...: A convenience function for Irrlicht that adds a polygon shape (b2PolygonShape) to an internal array of shapes.
; Syntax.........: _Box2C_b2PolygonShape_ArrayAdd_Irrlicht($vertice, $shape_image_file_path)
; Parameters ....: $vertice - the vectices of the shape to add
;				   $shape_image_file_path - the path to the image file of the shape to add
; Return values .: The index of the shape within the internal array of shapes.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2PolygonShape_ArrayAdd_Irrlicht($vertice, $shape_image_file_path)

	; add the new vertices to the internal array of shape vertices
	Local $shape_vertice_index = _ArrayAdd($__shape_vertice, Null)
	$__shape_vertice[$shape_vertice_index] = $vertice

	; add the new sfTexture to the internal array of shape images
;	Local $struct_image_array_index = _ArrayAdd($__shape_image, _CSFML_sfTexture_createFromFile($shape_image_file_path, Null))

	; create a new Box2C Polygone Shape for the new vertices and add it to the internal array of shape structures
	Local $shape_struct_index = _ArrayAdd($__shape_struct, _Box2C_b2PolygonShape_Constructor($vertice))
	_ArrayAdd($__shape_struct_ptr, DllStructGetPtr($__shape_struct[$shape_struct_index]))

	; return the index of the new shape within the internal arrays of shapes
	Return $shape_struct_index
EndFunc


; #B2BODYDEF FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyDef_ArrayAdd
; Description ...: A convenience function that adds a body definition (b2BodyDef) to an internal array of body definitions.
; Syntax.........: _Box2C_b2BodyDef_ArrayAdd($body_type, $initial_x, $initial_y, $initial_angle)
; Parameters ....: $body_type
;				   $initial_x
;				   $initial_y
;				   $initial_angle
; Return values .: The index of the body definition within the internal array of body definitions.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyDef_ArrayAdd($body_type, $initial_x = 0, $initial_y = 0, $initial_angle = 0)

	; create a new Box2C Body Definition for the body type, initial x and y and angles, and add it to the internal array of body definition structures
	Local $bodydef_struct_index = _ArrayAdd($__bodydef_struct, _Box2C_b2BodyDef_Constructor($body_type, $initial_x, $initial_y, $initial_angle, 0, 0, 0, 0, 0, True, True, False, False, True, Null, 1))
	_ArrayAdd($__bodydef_struct_ptr, DllStructGetPtr($__bodydef_struct[$bodydef_struct_index]))

	; return the index of the new body definition within the internal array of body definitions
	Return $bodydef_struct_index




	; get the vertices from the internal shape vertice collection

;	Local $initial_vertice[$__shape_vertice_struct_size[$initial_shape_vertice_index] / 2][2]
;	Local $initial_vertice_index = -1

;	for $i = 1 to $__shape_vertice_struct_size[$initial_shape_vertice_index] step 2

;		$initial_vertice_index = $initial_vertice_index + 1
;		$initial_vertice[$initial_vertice_index][0] = DllStructGetData($__shape_vertice_struct[$initial_shape_vertice_index], $i)
;		$initial_vertice[$initial_vertice_index][1] = DllStructGetData($__shape_vertice_struct[$initial_shape_vertice_index], $i + 1)
;	Next

;	_ArrayDisplay($initial_vertice)

; body definitions
;	index 0 = body width (in metres)
;	index 1 = body height (in metres)
;	index 2 = initial body x (in metres)
;	index 3 = initial body y (in metres)
;	index 4 = initial body angle (in degrees)
;	index 5 = initial body gui pos x (in pixels)
;	index 6 = initial body gui pos y (in pixels)
;	index 7 = previous body screen x (in pixels)
;	index 8 = previous body screen y (in pixels)
;	index 9 = current body screen x (in pixels)
;	index 10 = current body screen y (in pixels)
;	index 11 = previous body angle (in degrees)
;	index 12 = current body angle (in degrees)
;	index 13 = b2BodyDef structure
;	index 14 = b2BodyDef pointer
;	index 15 = b2PolygonShapePortable structure
;	index 16 = b2PolygonShapePortable pointer
;	index 17 = b2Body pointer
;	index 18 = b2Fixture pointer
;	index 19 = GDIPlus graphics object
;	index 20 = GDIPlus image

;	Local $body_def_str = _ArrayMax($initial_vertice, 1, -1, -1, 0) & "|" & _ArrayMax($initial_vertice, 1, -1, -1, 1) & "|" & $initial_x & "|" & $initial_y & "|" & $initial_angle_degrees & "|||-1|-1|-1|-1|-1|-1||||||||"

;	Local $tmp_index = _ArrayAdd($__body_def, $body_def_str)
	;_ArrayDisplay($__body_def)

;	$__body_def[$tmp_index][$hImage] = $__shape_image[$initial_shape_vertice_index]

EndFunc


; #B2BODY FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ArrayAdd_GDIPlus
; Description ...: A convenience function for GDI+ that adds a body (b2Body) to an internal (PTR) array of bodies.
; Syntax.........: _Box2C_b2Body_ArrayAdd_GDIPlus($bodydef_index, $shape_index, $density, $restitution, $friction, $vertice, $initial_x, $initial_y)
; Parameters ....: $bodydef_index - the index of the body definition within the internal array of body definitions to create the body with
;				   $shape_index - the index of the shape within the internal arrays of shapes to create the body with
;				   $density - the density of the new body
;				   $restitution - the $restitution of the new body
;				   $friction - the $friction of the new body
;				   $vertice - the index of the shape containing the vertices for the new body
;				   $initial_x - the initial horizontal position of the new body
;				   $initial_y - the initial vertical position of the new body
; Return values .: The index of the body within the internal array of bodies.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ArrayAdd_GDIPlus($bodydef_index, $shape_index, $density, $restitution, $friction, $vertice, $initial_x, $initial_y)

	; create a new Box2C Body for the index of the body definition supplied, and add it to the internal array of body structures
	Local $body_struct_ptr_index = _ArrayAdd($__body_struct_ptr, _Box2C_b2World_CreateBody($__world_ptr, $__bodydef_struct_ptr[$bodydef_index]))
	_Box2C_b2Body_SetAwake($__body_struct_ptr[$body_struct_ptr_index], True)
;	_Box2C_b2Body_SetAngle($__body_struct_ptr[$body_struct_ptr_index], degrees_to_radians($__body_def[0][$origin_angle_degrees]))

	; add other attributes, such as the initial positions, angles and body widths and heights to the internal arrays for bodies
	_ArrayAdd($__body_prev_screen_x, -1)
	_ArrayAdd($__body_prev_screen_y, -1)
	_ArrayAdd($__body_curr_screen_x, -1)
	_ArrayAdd($__body_curr_screen_y, -1)
	_ArrayAdd($__body_prev_angle_degrees, -1)
	_ArrayAdd($__body_curr_angle_degrees, -1)
	_ArrayAdd($__body_width, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 0))
	_ArrayAdd($__body_height, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 1))

	; create a new Box2C Fixture for the index of the body created, and the index of the shape supplied, and other attributes supplied (density, restitution and friction), add it to the internal array of fixture structures
	Local $fixture_struct_ptr_index = _ArrayAdd($__fixture_struct_ptr, _Box2C_b2World_CreateFixture($__body_struct_ptr[$body_struct_ptr_index], $__shape_struct_ptr[$shape_index], $density, $restitution, $friction))

	Local $body_hGfx_Buffer_index = _ArrayAdd($__body_hGfx_Buffer, _GDIPlus_ImageGetGraphicsContext($__g_hBmp_Buffer))



	Local $tmp_gui_pos = _Box2C_b2Vec2_GetGUIPosition($initial_x, $initial_y, $vertice)
	_ArrayAdd($__body_gui_pos, $tmp_gui_pos[0] & "|" & $tmp_gui_pos[1])
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tmp_gui_pos[1] = ' & $tmp_gui_pos[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tmp_gui_pos[0] = ' & $tmp_gui_pos[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	_ArrayAdd($__body_shape_index, $shape_index)


	Return $body_struct_ptr_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ArrayAdd_SFML
; Description ...: A convenience function for SFML that adds a body (b2Body) to an internal (PTR) array of bodies.
; Syntax.........: _Box2C_b2Body_ArrayAdd_SFML($bodydef_index, $shape_index, $density, $restitution, $friction, $vertice, $initial_x, $initial_y)
; Parameters ....: $bodydef_index - the index of the body definition within the internal array of body definitions to create the body with
;				   $shape_index - the index of the shape within the internal arrays of shapes to create the body with
;				   $density - the density of the new body
;				   $restitution - the $restitution of the new body
;				   $friction - the $friction of the new body
;				   $vertice - the index of the shape containing the vertices for the new body
;				   $initial_x - the initial horizontal position of the new body
;				   $initial_y - the initial vertical position of the new body
; Return values .: The index of the body within the internal array of bodies.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ArrayAdd_SFML($bodydef_index, $shape_index, $density, $restitution, $friction, $vertice, $initial_x, $initial_y)

	; create a new Box2C Body for the index of the body definition supplied, and add it to the internal array of body structures
	Local $body_struct_ptr_index = _ArrayAdd($__body_struct_ptr, _Box2C_b2World_CreateBody($__world_ptr, $__bodydef_struct_ptr[$bodydef_index]))
	_Box2C_b2Body_SetAwake($__body_struct_ptr[$body_struct_ptr_index], True)

	; add other attributes, such as the initial positions, angles and body widths and heights to the internal arrays for bodies
	_ArrayAdd($__body_prev_screen_x, -1)
	_ArrayAdd($__body_prev_screen_y, -1)
	_ArrayAdd($__body_curr_screen_x, -1)
	_ArrayAdd($__body_curr_screen_y, -1)
	_ArrayAdd($__body_prev_angle_degrees, -1)
	_ArrayAdd($__body_curr_angle_degrees, -1)
	_ArrayAdd($__body_width, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 0))
	_ArrayAdd($__body_height, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 1))

	; create a new Box2C Fixture for the index of the body created, and the index of the shape supplied, and other attributes supplied (density, restitution and friction), add it to the internal array of fixture structures
	Local $fixture_struct_ptr_index = _ArrayAdd($__fixture_struct_ptr, _Box2C_b2World_CreateFixture($__body_struct_ptr[$body_struct_ptr_index], $__shape_struct_ptr[$shape_index], $density, $restitution, $friction))

	; get the GUI position of the initial (vector) position of the body, and add it to the internal array of body GUI positions
	Local $tmp_gui_pos = _Box2C_b2Vec2_GetGUIPosition($initial_x, $initial_y, $vertice)
	_ArrayAdd($__body_gui_pos, $tmp_gui_pos[0] & "|" & $tmp_gui_pos[1])

	; add the index of the shape to the internal array of body shapes
	_ArrayAdd($__body_shape_index, $shape_index)

	; return the index to the new body
	Return $body_struct_ptr_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ArrayAdd_Irrlicht
; Description ...: A convenience function for Irrlicht that adds a body (b2Body) to an internal (PTR) array of bodies.
; Syntax.........: _Box2C_b2Body_ArrayAdd_Irrlicht($bodydef_index, $shape_index, $density, $restitution, $friction, $vertice, $initial_x, $initial_y)
; Parameters ....: $bodydef_index - the index of the body definition within the internal array of body definitions to create the body with
;				   $shape_index - the index of the shape within the internal arrays of shapes to create the body with
;				   $density - the density of the new body
;				   $restitution - the $restitution of the new body
;				   $friction - the $friction of the new body
;				   $vertice - the index of the shape containing the vertices for the new body
;				   $initial_x - the initial horizontal position of the new body
;				   $initial_y - the initial vertical position of the new body
; Return values .: The index of the body within the internal array of bodies.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ArrayAdd_Irrlicht($bodydef_index, $shape_index, $density, $restitution, $friction, $vertice, $initial_x, $initial_y)

	; create a new Box2C Body for the index of the body definition supplied, and add it to the internal array of body structures
	Local $body_struct_ptr_index = _ArrayAdd($__body_struct_ptr, _Box2C_b2World_CreateBody($__world_ptr, $__bodydef_struct_ptr[$bodydef_index]))
	_Box2C_b2Body_SetAwake($__body_struct_ptr[$body_struct_ptr_index], True)

	; add other attributes, such as the initial positions, angles and body widths and heights to the internal arrays for bodies
	_ArrayAdd($__body_prev_screen_x, -1)
	_ArrayAdd($__body_prev_screen_y, -1)
	_ArrayAdd($__body_curr_screen_x, -1)
	_ArrayAdd($__body_curr_screen_y, -1)
	_ArrayAdd($__body_prev_angle_degrees, -1)
	_ArrayAdd($__body_curr_angle_degrees, -1)
	_ArrayAdd($__body_width, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 0))
	_ArrayAdd($__body_height, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 1))

	; create a new Box2C Fixture for the index of the body created, and the index of the shape supplied, and other attributes supplied (density, restitution and friction), add it to the internal array of fixture structures
	Local $fixture_struct_ptr_index = _ArrayAdd($__fixture_struct_ptr, _Box2C_b2World_CreateFixture($__body_struct_ptr[$body_struct_ptr_index], $__shape_struct_ptr[$shape_index], $density, $restitution, $friction))

	; get the GUI position of the initial (vector) position of the body, and add it to the internal array of body GUI positions
	Local $tmp_gui_pos = _Box2C_b2Vec2_GetGUIPosition($initial_x, $initial_y, $vertice)
	_ArrayAdd($__body_gui_pos, $tmp_gui_pos[0] & "|" & $tmp_gui_pos[1])

	; add the index of the shape to the internal array of body shapes
	_ArrayAdd($__body_shape_index, $shape_index)

	; return the index to the new body
	Return $body_struct_ptr_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_Transform_GDIPlus
; Description ...: A convenience function that transforms a body (b2Body) within the internal (PTR) array of bodies.
; Syntax.........: _Box2C_b2Body_Transform_GDIPlus($body_index)
; Parameters ....: $body_index - the index of the body within the internal array of bodies to transform
; Return values .: False means a body has been destroyed.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_Transform_GDIPlus($body_index)

	Local $body_position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_index])

	Local $body_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_index])

;	if $body_index = 0 Then

;		ConsoleWrite(StringFormat("%4.2f", $body_position[0]) & " " & StringFormat("%4.2f", $body_position[1]) & " " & StringFormat("%4.2f", $body_angle) & " " & StringFormat("%4.2f", radians_to_degrees($body_angle)) & @CRLF)
;	EndIf

	Local $tmp_gui_center_x = _Box2C_b2World_GetGUIAreaCenter(0)
	$__body_curr_screen_x[$body_index] = x_metres_to_gui_x($body_position[0], $tmp_gui_center_x)

	if $__body_curr_screen_x[$body_index] > $__GUI_Area[0] + ($__body_width[$body_index] * $__pixels_per_metre) Or $__body_curr_screen_x[$body_index] < 0 - ($__body_width[$body_index] * $__pixels_per_metre) Then

		_Box2C_b2Body_Destroy($body_index)
		Return False
	EndIf

	; if no previous screen x

	if $__body_prev_screen_x[$body_index] = -1 Then

		$__body_prev_screen_x[$body_index] = $__body_curr_screen_x[$body_index]
	EndIf

	Local $tmp_gui_center_y = _Box2C_b2World_GetGUIAreaCenter(1)
	$__body_curr_screen_y[$body_index] = y_metres_to_gui_y($body_position[1], $tmp_gui_center_y)

	if $__body_curr_screen_y[$body_index] > $__GUI_Area[1] + ($__body_height[$body_index] * $__pixels_per_metre) Or $__body_curr_screen_y[$body_index] < 0 - ($__body_height[$body_index] * $__pixels_per_metre) Then

		_Box2C_b2Body_Destroy($body_index)
		Return False
	EndIf

	; if no previous screen y

	if $__body_prev_screen_y[$body_index] = -1 Then

		$__body_prev_screen_y[$body_index] = $__body_curr_screen_y[$body_index]
	EndIf

	$__body_curr_angle_degrees[$body_index] = radians_to_degrees($body_angle)

	; if no previous angle then do the initial / first time rotation

	if $__body_prev_angle_degrees[$body_index] = -1 Then

		$__body_prev_angle_degrees[$body_index] = 0
		_Box2C_b2Body_Rotate_GDIPlus($__body_hGfx_Buffer[$body_index], $__body_curr_screen_x[$body_index], $__body_curr_screen_y[$body_index], $__body_prev_angle_degrees[$body_index], $__body_curr_angle_degrees[$body_index])
		$__body_prev_angle_degrees[$body_index] = $__body_curr_angle_degrees[$body_index]
	EndIf

    _GDIPlus_GraphicsTranslateTransform($__body_hGfx_Buffer[$body_index], $__body_curr_screen_x[$body_index] - $__body_prev_screen_x[$body_index], $__body_curr_screen_y[$body_index] - $__body_prev_screen_y[$body_index], True)
	_Box2C_b2Body_Rotate_GDIPlus($__body_hGfx_Buffer[$body_index], $__body_curr_screen_x[$body_index], $__body_curr_screen_y[$body_index], $__body_prev_angle_degrees[$body_index], $__body_curr_angle_degrees[$body_index])

	$__body_prev_screen_x[$body_index] = $__body_curr_screen_x[$body_index]
	$__body_prev_screen_y[$body_index] = $__body_curr_screen_y[$body_index]
	$__body_prev_angle_degrees[$body_index] = $__body_curr_angle_degrees[$body_index]

	Return True

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_Destroy
; Description ...: A convenience function that destroys a body (b2Body) within the internal (PTR) array of bodies.
; Syntax.........: _Box2C_b2Body_Destroy($body_index)
; Parameters ....: $body_index - the index of the body within the internal array of bodies to destroy
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_Destroy($body_index)

	; destroy the fixture

	_Box2C_b2Body_DestroyFixture($__body_struct_ptr[$body_index], $__fixture_struct_ptr[$body_index])
	_ArrayDelete($__fixture_struct_ptr, $body_index)

	; destroy the body

	_Box2C_b2World_DestroyBody($__world_ptr, $__body_struct_ptr[$body_index])
	_ArrayDelete($__body_struct_ptr, $body_index)
	_ArrayDelete($__body_prev_screen_x, $body_index)
	_ArrayDelete($__body_prev_screen_y, $body_index)
	_ArrayDelete($__body_curr_screen_x, $body_index)
	_ArrayDelete($__body_curr_screen_y, $body_index)
	_ArrayDelete($__body_prev_angle_degrees, $body_index)
	_ArrayDelete($__body_curr_angle_degrees, $body_index)
	_ArrayDelete($__body_width, $body_index)
	_ArrayDelete($__body_height, $body_index)
	_ArrayDelete($__body_gui_pos, $body_index)
	_ArrayDelete($__body_shape_index, $body_index)

	; destroy the graphics

	_GDIPlus_GraphicsDispose($__body_hGfx_Buffer[$body_index])
	_ArrayDelete($__body_hGfx_Buffer, $body_index)

EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_Rotate_GDIPlus
; Description ...: A convenience function for GDI+ that rotates a body (b2Body) within the internal (PTR) array of bodies.
; Syntax.........: _Box2C_b2Body_Rotate_GDIPlus($gfx_buffer, $body_center_x, $body_center_y, $body_prev_angle_degrees, $body_curr_angle_degrees)
; Parameters ....: $gfx_buffer -
;				   $body_center_x -
;				   $body_center_y -
;				   $body_prev_angle_degrees -
;				   $body_curr_angle_degrees -
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_Rotate_GDIPlus($gfx_buffer, $body_center_x, $body_center_y, $body_prev_angle_degrees, $body_curr_angle_degrees)


	Local $aMousePos[2][2] = [[1]]
	$aMousePos[1][0] = $body_center_x
	$aMousePos[1][1] = $body_center_y
	_GDIPlus_GraphicsTransformPoints($gfx_buffer, $aMousePos)
	_GDIPlus_GraphicsTranslateTransform($gfx_buffer, $aMousePos[1][0], $aMousePos[1][1])
    _GDIPlus_GraphicsRotateTransform($gfx_buffer, 360 - ($body_curr_angle_degrees - $body_prev_angle_degrees))
	_GDIPlus_GraphicsTranslateTransform($gfx_buffer, -$aMousePos[1][0], -$aMousePos[1][1])

EndFunc



