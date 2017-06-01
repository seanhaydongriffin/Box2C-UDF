
; #INDEX# =======================================================================================================================
; Title .........: Box2CEx
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Convenience functions and Graphical library extensions (GDI+, Direct2D, SFML, Irrlicht) for Box2D
; Author(s) .....: Sean Griffin
; Dlls ..........:
; ===============================================================================================================================

#include-once
#include <Math.au3>
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
Global $__shape_image_file_path[0]
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
Global $__body_draw[0]
Global $__body_out_of_bounds_behaviour[0]

Global $__world_ptr
Global $__world_animation_timer

Global $__g_hGraphics
Global $__g_hBmp_Buffer

Global $__convex_shape_ptr[0]
Global $__convex_shape_draw_lower_index
Global $__convex_shape_draw_upper_index

Global $__sprite_ptr[0]
Global $__sprite_screen_x_offset[0]
Global $__sprite_screen_y_offset[0]
Global $__sprite_draw_lower_index
Global $__sprite_draw_upper_index
Global $__body_curr_screen_y[0]
Global $__gui_center_x
Global $__gui_center_y

Global $__event
Global $__event_ptr
Global $__black
Global $__green
Global $__white
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
; _Box2C_Setup_SFML
; _Box2C_b2Vec2_GetGUIPosition
; _Box2C_b2World_Setup
; _Box2C_b2World_GDIPlusSetup
; _Box2C_b2World_SetPixelsPerMetre
; _Box2C_b2World_SetGUIArea
; _Box2C_b2World_GetGUIArea
; _Box2C_b2World_GetGUIAreaCenter
; _Box2C_b2World_Create
; _Box2C_b2World_Step_Ex
; _Box2C_b2World_StartAnimation
; _Box2C_b2World_Animate_SFML
; _Box2C_b2World_Animate_GDIPlus
; _Box2C_b2World_WaitForAnimateEnd
; _Box2C_b2ShapeArray_AddItem_SFML
; _Box2C_b2ShapeArray_SetItem_SFML
; _Box2C_b2ShapeArray_GetItemImagePath_SFML
; _Box2C_b2PolygonShape_ArrayAdd_Irrlicht
; _Box2C_b2PolygonShape_ArrayAdd_GDIPlus
; _Box2C_b2BodyDefArray_AddItem
; _Box2C_b2FixtureArray_SetItemSensor
; _Box2C_b2FixtureArray_GetItemDensity
; _Box2C_b2FixtureArray_SetItemDensity
; _Box2C_b2FixtureArray_GetItemRestitution
; _Box2C_b2FixtureArray_SetItemRestitution
; _Box2C_b2FixtureArray_GetItemFriction
; _Box2C_b2FixtureArray_SetItemFriction
; _Box2C_b2BodyArray_AddItem_SFML
; _Box2C_b2Body_ArrayAdd_Irrlicht
; _Box2C_b2Body_ArrayAdd_GDIPlus
; _Box2C_b2BodyArray_GetItemCount
; _Box2C_b2BodyArray_GetItemPosition
; _Box2C_b2BodyArray_SetItemPosition
; _Box2C_b2BodyArray_GetItemAngle
; _Box2C_b2BodyArray_SetItemAngle
; _Box2C_b2BodyArray_GetItemLinearVelocity
; _Box2C_b2BodyArray_SetItemActive
; _Box2C_b2BodyArray_SetItemAwake
; _Box2C_b2BodyArray_SetItemImage_SFML
; _Box2C_b2BodyArray_SetItemDraw
; _Box2C_b2BodyArray_ApplyItemForceAtBody
; _Box2C_b2BodyArray_ApplyItemDirectionalForceAtBody
; _Box2C_b2BodyArray_Transform_SFML
; _Box2C_b2Body_Transform_GDIPlus
; _Box2C_b2BodyArray_Draw_SFML
; _Box2C_b2Body_ArrayDrawDisplay_SFML
; _Box2C_b2Body_Destroy
; _Box2C_b2Body_Destroy_SFML
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
; Name...........: _Box2C_Setup_SFML
; Description ...: A convenience function that sets up SFML for Box2D rendering.
; Syntax.........: _Box2C_Setup_SFML()
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
Func _Box2C_Setup_SFML()

	_CSFML_Startup()

	; Setup basic variables for SFML

	Global $__event = _CSFML_sfEvent_Constructor()
	Global $__event_ptr = DllStructGetPtr($__event)

	; Setup colors for SFML

	Global $__black = _CSFML_sfColor_Constructor(0,0,0,255)
	Global $__green = _CSFML_sfColor_Constructor(0,255,0,255)
	Global $__white = _CSFML_sfColor_Constructor(255,255,255,255)

	; Setup fonts for SFML

	Global $__courier_new_font_ptr = _CSFML_sfFont_createFromFile("C:\Windows\Fonts\cour.ttf")
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

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Vec2_GetAngleBetweenTwoVectors
; Description ...:
; Syntax.........: _Box2C_b2Vec2_GetAngleBetweenTwoVectors($x1, $y1, $x2, $y2)
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
Func _Box2C_b2Vec2_GetAngleBetweenTwoVectors($x1, $y1, $x2, $y2)

	;Local $angle = atan2($y2, $x2) - atan2($y1, $x1);
	Local $angle = atan2($y1 - $y2, $x1 - $x2)
	Return $angle
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Vec2_GetAngleBetweenThreePoints
; Description ...:
; Syntax.........: _Box2C_b2Vec2_GetAngleBetweenThreePoints($x1, $y1, $x2, $y2, $x3, $y3, ByRef $clockwise)
; Parameters ....: $x1 - the first point
;				   $y1 - the first point
;				   $x2 - the second point
;				   $y2 - the second point
;				   $x3 - the third point
;				   $y3 - the third point
;				   $clockwise - returns True if the angle indicates a clockwise movement through the points, otherwise False
; Return values .: The angle (degrees)
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Vec2_GetAngleBetweenThreePoints($x1, $y1, $x2, $y2, $x3, $y3, ByRef $clockwise)

	Local $angle1 = atan2($y1 - $y2, $x1 - $x2)
	Local $angle2 = atan2($y3 - $y2, $x3 - $x2)
	Local $angle =  $angle1 - $angle2
	Local $deg = _Degree($angle)
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $deg = ' & $deg & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	$clockwise = True

	if $deg < 0 Then

		$deg = 360 + $deg
	Else

		if $deg > 180 Then

			$clockwise = False
		EndIf
	EndIf

;	if $deg > 180 Then

;		$clockwise = False
;		$deg = 360 - $deg
;	Else

;		if $deg < 0 Then

;			$deg = 0 - $deg
;		EndIf
;	EndIf

	Return $deg
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Vec2Array_IsConvexAndClockwise
; Description ...: Check whether an array of vertices (a polygon) is convex and in a clockwise direction.
;					This is a requirement for a the vertices of a Box2D shape.
; Syntax.........: _Box2C_b2Vec2Array_IsConvexAndClockwise($vertices)
; Parameters ....: $vertices - an array of vertices
; Return values .: True if convex, otherwise False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Vec2Array_IsConvexAndClockwise($vertices)

	Local $edited_angle, $angles = "", $edited_total_angles = 0, $clockwise

	; angle at points #2 and more

	for $i = 1 to (UBound($vertices) - 2)

		$edited_angle = _Box2C_b2Vec2_GetAngleBetweenThreePoints($vertices[$i - 1][0], $vertices[$i - 1][1], $vertices[$i][0], $vertices[$i][1], $vertices[$i + 1][0], $vertices[$i + 1][1], $clockwise)

		if $i = 1 and $clockwise = False Then

			Return False
		EndIf

		$angles = $angles & ", #" & $i & " = " & $edited_angle
		$edited_total_angles = $edited_total_angles + $edited_angle
	Next

	; angle at the last point

	$edited_angle = _Box2C_b2Vec2_GetAngleBetweenThreePoints($vertices[UBound($vertices) - 2][0], $vertices[UBound($vertices) - 2][1], $vertices[UBound($vertices) - 1][0], $vertices[UBound($vertices) - 1][1], $vertices[0][0], $vertices[0][1], $clockwise)
	$angles = $angles & ", last # = " & $edited_angle
	$edited_total_angles = $edited_total_angles + $edited_angle

	; angle at the first point

	$edited_angle = _Box2C_b2Vec2_GetAngleBetweenThreePoints($vertices[UBound($vertices) - 1][0], $vertices[UBound($vertices) - 1][1], $vertices[0][0], $vertices[0][1], $vertices[1][0], $vertices[1][1], $clockwise)
	$angles = "first # = " & $edited_angle & $angles
	$edited_total_angles = $edited_total_angles + $edited_angle
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $edited_total_angles = ' & $edited_total_angles & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $angles = ' & $angles & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	if Round($edited_total_angles) = ((UBound($vertices) - 2) * 180) Then

		Return True
	EndIf

	Return False

EndFunc


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

; $flag = 0 (get width)
; $flag = 1 (get height)
; $flag = 2 (get array of width and height)

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

	$__gui_center_x = $__GUI_Area[0] / 2
	$__gui_center_y = $__GUI_Area[1] / 2
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
; Name...........: _Box2C_b2World_Step_Ex
; Description ...: A convenience function that steps a frame of animation in the internally defined world (b2World).
; Syntax.........: _Box2C_b2World_Step_Ex()
; Parameters ....:
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_Step_Ex($timeStep, $velocityIterations = 6, $positionIterations = 2)

	_Box2C_b2World_Step($__world_ptr, $timeStep, $velocityIterations, $positionIterations)
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

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2World_Animate_SFML
; Description ...: The animation loop specifically for Box2D and SFML
; Syntax.........: _Box2C_b2World_Animate_SFML($window_ptr, $window_color, $info_text_ptr, $info_text_string)
; Parameters ....: $window_ptr
;				   $window_color
;				   $info_text_ptr
;				   $info_text_string
;				   $draw_info_text_before_body - the index of the body to draw the info text before
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2World_Animate_SFML(ByRef $window_ptr, ByRef $window_color, ByRef $info_text_ptr, ByRef $info_text_string, $draw_info_text_before_body = 0)

	; Clear the animation frame

	_CSFML_sfRenderWindow_clear($window_ptr, $window_color)

	; Transform the Box2D bodies and draw SFML sprites

	Local $body_num = -1

	While True

		$body_num = $body_num + 1

		if $body_num > (UBound($__body_struct_ptr) - 1) Then

			ExitLoop
		EndIf

		if $body_num = $draw_info_text_before_body Then

			; Draw the info text

			_CSFML_sfRenderWindow_drawTextString($window_ptr, $info_text_ptr, $info_text_string, Null)
		EndIf

		Local $body_position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_num])

		if $body_position[0] < -8 or $body_position[0] > 8 or $body_position[1] < -6 or $body_position[1] > 6 Then

			if $__body_out_of_bounds_behaviour[$body_num] = 2 Then

				Local $velocity = _Box2C_b2Body_GetLinearVelocity($__body_struct_ptr[$body_num])

				if $body_position[0] < -8 or $body_position[0] > 8 Then

					_Box2C_b2Body_SetPosition($__body_struct_ptr[$body_num], $body_position[0] * 0.99, $body_position[1])
					_Box2C_b2Body_SetLinearVelocity($__body_struct_ptr[$body_num], 0 - $velocity[0], $velocity[1])
				EndIf

				if $body_position[1] < -6 or $body_position[1] > 6 Then

					_Box2C_b2Body_SetPosition($__body_struct_ptr[$body_num], $body_position[0], $body_position[1] * 0.99)
					_Box2C_b2Body_SetLinearVelocity($__body_struct_ptr[$body_num], $velocity[0], 0 - $velocity[1])
				EndIf
			EndIf

			if $__body_out_of_bounds_behaviour[$body_num] = 1 Then

				_Box2C_b2Body_Destroy_SFML($body_num)
				_CSFML_sfSprite_destroy($__sprite_ptr[$body_num])
				_ArrayDelete($__sprite_ptr, $body_num)
			EndIf
		Else

			; Update sprite position

			; converting the below to C might improve animations by a further 500 frames per seconds

			$__body_curr_screen_x[$body_num] = $__gui_center_x + ($body_position[0] * $__pixels_per_metre)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_position[0] = ' & $body_position[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;				$__body_curr_screen_x[$body_num] = x_metres_to_gui_x($body_position[0], $tmp_gui_center_x)

			$__body_curr_screen_y[$body_num] = $__gui_center_y - ($body_position[1] * $__pixels_per_metre)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_position[1] = ' & $body_position[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;				$__body_curr_screen_y[$body_num] = y_metres_to_gui_y($body_position[1], $tmp_gui_center_y)

			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_num = ' & $body_num & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

			_CSFML_sfSprite_setPosition_xy($__sprite_ptr[$body_num], $__body_curr_screen_x[$body_num], $__body_curr_screen_y[$body_num])

			; Update sprite rotation

			Local $body_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_num])
			$__body_curr_angle_degrees[$body_num] = 0 - _Degree($body_angle)
			_CSFML_sfSprite_setRotation($__sprite_ptr[$body_num], $__body_curr_angle_degrees[$body_num])

			_CSFML_sfRenderWindow_drawSprite($window_ptr, $__sprite_ptr[$body_num], Null)

		EndIf
	WEnd

	; Render the animation frame

	_CSFML_sfRenderWindow_display($window_ptr)

EndFunc


; #B2SHAPE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2ShapeArray_AddItem_SFML
; Description ...: A convenience function for SFML that adds a polygon shape (b2PolygonShape) to an internal array of shapes.
; Syntax.........: _Box2C_b2ShapeArray_AddItem_SFML($type, $radius_vertice, $shape_image_file_path)
; Parameters ....: $type - the type of shape:
;						$Box2C_e_circle (0) = a circle shape
;						$Box2C_e_edge (1) = an edge shape
;						$Box2C_e_polygon (2) = a polygon shape
;						$Box2C_e_chain (3) = a chain shape
;				   $radius_vertice:
;						for a $type of $Box2C_e_circle this is the radius of the circle
;						for a $type of $Box2C_e_edge this is a two dimensional vector array of the edges of the polygon
;				   $shape_image_file_path - the path to the image file of the shape to add
; Return values .: The index of the shape within the internal array of shapes.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2ShapeArray_AddItem_SFML($type, $radius_vertice, $shape_image_file_path)

	; add the new vertices to the internal array of shape vertices
	Local $shape_vertice_index = _ArrayAdd($__shape_vertice, Null)

	if $type = $Box2C_e_edge Then

		$__shape_vertice[$shape_vertice_index] = $radius_vertice
	EndIf

	; add the new sfTexture to the internal array of shape images

	_ArrayAdd($__shape_image_file_path, $shape_image_file_path)

	Local $struct_image_array_index = _ArrayAdd($__shape_image, _CSFML_sfTexture_createFromFile($shape_image_file_path, Null))

	; create a new Box2C Polygone Shape for the new vertices and add it to the internal array of shape structures
	Local $shape_struct_index

	Switch $type

		case $Box2C_e_circle

			$shape_struct_index = _ArrayAdd($__shape_struct, _Box2C_b2CircleShape_Constructor($radius_vertice))

		case $Box2C_e_edge

			$shape_struct_index = _ArrayAdd($__shape_struct, _Box2C_b2PolygonShape_Constructor($radius_vertice))
	EndSwitch

	_ArrayAdd($__shape_struct_ptr, DllStructGetPtr($__shape_struct[$shape_struct_index]))

	; return the index of the new shape within the internal arrays of shapes
	Return $shape_struct_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2ShapeArray_SetItem_SFML
; Description ...: A convenience function for SFML that sets the type, vertices and image of a polygon shape (b2PolygonShape) in the internal array of shapes.
; Syntax.........: _Box2C_b2ShapeArray_SetItem_SFML($shape_index, $type, $radius_vertice, $shape_image_file_path)
; Parameters ....: $shape_index - the index of the shape
;				   $type - the type of shape:
;						$Box2C_e_circle (0) = a circle shape
;						$Box2C_e_edge (1) = an edge shape
;						$Box2C_e_polygon (2) = a polygon shape
;						$Box2C_e_chain (3) = a chain shape
;				   $radius_vertice:
;						for a $type of $Box2C_e_circle this is the radius of the circle
;						for a $type of $Box2C_e_edge this is a two dimensional vector array of the edges of the polygon
;				   $shape_image_file_path - the path to the image file of the shape to add
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2ShapeArray_SetItem_SFML($shape_index, $type, $radius_vertice, $shape_image_file_path)

	; add the new vertices to the internal array of shape vertices
	if $type = $Box2C_e_edge Then

		$__shape_vertice[$shape_index] = $radius_vertice
	EndIf

	; add the new sfTexture to the internal array of shape images

	$__shape_image_file_path[$shape_index] = $shape_image_file_path
	$__shape_image[$shape_index] = _CSFML_sfTexture_createFromFile($shape_image_file_path, Null)

	; create a new Box2C Polygone Shape for the new vertices and add it to the internal array of shape structures

	; deallocated existing struct / memory
	$__shape_struct[$shape_index] = 0

	Switch $type

		case $Box2C_e_circle

			$__shape_struct[$shape_index] = _Box2C_b2CircleShape_Constructor($radius_vertice)

		case $Box2C_e_edge

			$__shape_struct[$shape_index] = _Box2C_b2PolygonShape_Constructor($radius_vertice)
	EndSwitch

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2ShapeArray_GetItemImagePath_SFML
; Description ...: A convenience function for SFML that gets the image file path of a polygon shape (b2PolygonShape) from the internal array of shapes.
; Syntax.........: _Box2C_b2ShapeArray_GetItemImagePath_SFML($shape_index, $type, $radius_vertice, $shape_image_file_path)
; Parameters ....: $shape_index - the index of the shape
; Return values .: the path of the image
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2ShapeArray_GetItemImagePath_SFML($shape_index)

	Return $__shape_image_file_path[$shape_index]
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
; Name...........: _Box2C_b2BodyDefArray_AddItem
; Description ...: A convenience function that adds a body definition (b2BodyDef) to an internal array of body definitions.
; Syntax.........: _Box2C_b2BodyDefArray_AddItem($body_type, $initial_x, $initial_y, $initial_angle, $linearDamping, $angularDamping)
; Parameters ....: $body_type
;				   $initial_x
;				   $initial_y
;				   $initial_angle
;				   $linearDamping
;				   $angularDamping
; Return values .: The index of the body definition within the internal array of body definitions.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyDefArray_AddItem($body_type, $initial_x = 0, $initial_y = 0, $initial_angle = 0, $linearDamping = 0, $angularDamping = 0)

	; create a new Box2C Body Definition for the body type, initial x and y and angles, and add it to the internal array of body definition structures
	Local $bodydef_struct_index = _ArrayAdd($__bodydef_struct, _Box2C_b2BodyDef_Constructor($body_type, $initial_x, $initial_y, $initial_angle, 0, 0, 0, $linearDamping, $angularDamping, True, True, False, False, True, Null, 1))
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


; #B2FIXTURE FUNCTIONS# =====================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2FixtureArray_SetItemSensor
; Description ...: A convenience function to set the sensor of a fixture (b2Fixture) based on it's index within the internal fixture array
; Syntax.........: _Box2C_b2FixtureArray_SetItemSensor($fixture_index, $value)
; Parameters ....: $fixture_index - the index of the fixture
;				   $value - True will turn the sensor on, False will turn the sensor off
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2FixtureArray_SetItemSensor($fixture_index, $value)

	_Box2C_b2Fixture_SetSensor($__fixture_struct_ptr[$fixture_index], $value)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2FixtureArray_GetItemDensity
; Description ...: A convenience function to get the density of a fixture (b2Fixture) based on it's index within the internal fixture array
; Syntax.........: _Box2C_b2FixtureArray_GetItemDensity($fixture_index)
; Parameters ....: $fixture_index - the index of the fixture
; Return values .: Success - the density
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2FixtureArray_GetItemDensity($fixture_index)

	Return _Box2C_b2Fixture_GetDensity($__fixture_struct_ptr[$fixture_index])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2FixtureArray_SetItemDensity
; Description ...: A convenience function to set the density of a fixture (b2Fixture) based on it's index within the internal fixture array
; Syntax.........: _Box2C_b2FixtureArray_SetItemDensity($fixture_index, $value)
; Parameters ....: $fixture_index - the index of the fixture, or -1 for all items
;				   $value - the density
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2FixtureArray_SetItemDensity($fixture_index, $value)

	if $fixture_index < 0 Then

		for $i = 0 to (UBound($__fixture_struct_ptr) - 1)

			_Box2C_b2Fixture_SetDensity($__fixture_struct_ptr[$i], $value)
		Next
	Else

		_Box2C_b2Fixture_SetDensity($__fixture_struct_ptr[$fixture_index], $value)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2FixtureArray_GetItemRestitution
; Description ...: A convenience function to get the restitution of a fixture (b2Fixture) based on it's index within the internal fixture array
; Syntax.........: _Box2C_b2FixtureArray_GetItemRestitution($fixture_index)
; Parameters ....: $fixture_index - the index of the fixture
; Return values .: Success - the restitution
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2FixtureArray_GetItemRestitution($fixture_index)

	Return _Box2C_b2Fixture_GetRestitution($__fixture_struct_ptr[$fixture_index])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2FixtureArray_SetItemRestitution
; Description ...: A convenience function to set the restitution of a fixture (b2Fixture) based on it's index within the internal fixture array
; Syntax.........: _Box2C_b2FixtureArray_SetItemRestitution($fixture_index, $value)
; Parameters ....: $fixture_index - the index of the fixture, or -1 for all items
;				   $value - the restitution
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2FixtureArray_SetItemRestitution($fixture_index, $value)

	if $fixture_index < 0 Then

		for $i = 0 to (UBound($__fixture_struct_ptr) - 1)

			_Box2C_b2Fixture_SetRestitution($__fixture_struct_ptr[$i], $value)
		Next
	Else

		_Box2C_b2Fixture_SetRestitution($__fixture_struct_ptr[$fixture_index], $value)
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2FixtureArray_GetItemFriction
; Description ...: A convenience function to get the friction of a fixture (b2Fixture) based on it's index within the internal fixture array
; Syntax.........: _Box2C_b2FixtureArray_GetItemFriction($fixture_index)
; Parameters ....: $fixture_index - the index of the fixture
; Return values .: Success - the friction
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2FixtureArray_GetItemFriction($fixture_index)

	Return _Box2C_b2Fixture_GetFriction($__fixture_struct_ptr[$fixture_index])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2FixtureArray_SetItemFriction
; Description ...: A convenience function to set the friction of a fixture (b2Fixture) based on it's index within the internal fixture array
; Syntax.........: _Box2C_b2FixtureArray_SetItemFriction($fixture_index, $value)
; Parameters ....: $fixture_index - the index of the fixture, or -1 for all items
;				   $value - the friction
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2FixtureArray_SetItemFriction($fixture_index, $value)

	if $fixture_index < 0 Then

		for $i = 0 to (UBound($__fixture_struct_ptr) - 1)

			_Box2C_b2Fixture_SetFriction($__fixture_struct_ptr[$i], $value)
		Next
	Else

		_Box2C_b2Fixture_SetFriction($__fixture_struct_ptr[$fixture_index], $value)
	EndIf
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
;	_Box2C_b2Body_SetAngle($__body_struct_ptr[$body_struct_ptr_index],  _Radian($__body_def[0][$origin_angle_degrees]))

	; add other attributes, such as the initial positions, angles and body widths and heights to the internal arrays for bodies
	_ArrayAdd($__body_prev_screen_x, -1)
	_ArrayAdd($__body_prev_screen_y, -1)
	_ArrayAdd($__body_curr_screen_x, -1)
	_ArrayAdd($__body_curr_screen_y, -1)
	_ArrayAdd($__body_prev_angle_degrees, -1)
	_ArrayAdd($__body_curr_angle_degrees, -1)
	_ArrayAdd($__body_width, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 0))
	_ArrayAdd($__body_height, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 1))
	_ArrayAdd($__body_out_of_bounds_behaviour, 0)
	_ArrayAdd($__body_draw, True)

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
; Name...........: _Box2C_b2BodyArray_AddItem_SFML
; Description ...: A convenience function for SFML that adds a body (b2Body) and sprite to an internal (PTR) array of bodies and sprites.
; Syntax.........: _Box2C_b2BodyArray_AddItem_SFML($bodydef_index, $shape_index, $density, $restitution, $friction, $vertice, $initial_x, $initial_y)
; Parameters ....: $bodydef_index - the index of the body definition within the internal array of body definitions to create the body with
;				   $shape_index - the index of the shape within the internal arrays of shapes to create the body with
;				   $density - the density of the new body
;				   $restitution - the $restitution of the new body
;				   $friction - the $friction of the new body
;				   $x - the horizontal position of the new body (overriding the position from the BodyDef)
;						use blank string to skip
;				   $y - the vertical position of the new body (overriding the position from the BodyDef)
;						use blank string to skip
;				   $angle - the angle of the new body (overriding the angle from the BodyDef)
;						use blank string to skip
;				   $out_of_bounds_behaviour - a flag that indicates what bodies / sprites should do when they go outside the GUI area
;						0 = do nothing (keep animating)
;						1 = destroy the body / sprite
;						2 = bounce the linear velocity of the body / sprite (like bouncing off a wall)
;						3 = stop the linear velocity of the body / sprite (like hitting a wall)
;						4 = hide the sprite (do not draw) and sleep the body (stops moving in Box2D)
;				   $shape_x_pixel_offset - an offset for the sprite in relation to the Box2D body (in pixels), see remarks below
;				   $shape_y_pixel_offset - an offset for the sprite in relation to the Box2D body (in pixels), see remarks below
; Return values .: The index of the body within the internal array of bodies.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......: The SFML SetPosition functions will by default draw the top-left corner of the sprite at the location
;				   you specify in those calls.  But Box2D will by default calculate a body with the centroid at this position
;				   (not the top-left of the body, like SFML).  Therefore, when the location of a Box2D body is passed into
;				   the SFML SetPosition functions, the sprite is drawn with it's top-left corner at the centre of the Box2D body.
;				   Usually this is not the desired behaviour.
;				   If you want to position the sprite properly over the centroid of the Box2D body then use the
;				   $shape_x_pixel_offset and $shape_y_pixel_offset parameters above.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_AddItem_SFML($bodydef_index, $shape_index, $density, $restitution, $friction, $x = "", $y = "", $angle = "", $out_of_bounds_behaviour = 0, $shape_x_pixel_offset = 0, $shape_y_pixel_offset = 0)

	; create a new Box2C Body for the index of the body definition supplied, and add it to the internal array of body structures
	Local $body_struct_ptr_index = _ArrayAdd($__body_struct_ptr, _Box2C_b2World_CreateBody($__world_ptr, $__bodydef_struct_ptr[$bodydef_index]))
	_Box2C_b2Body_SetAwake($__body_struct_ptr[$body_struct_ptr_index], True)

	if IsNumber($x) = True And IsNumber($y) = True Then

		_Box2C_b2Body_SetPosition($__body_struct_ptr[$body_struct_ptr_index], $x, $y)
	EndIf

	if IsNumber($angle) = True Then

		_Box2C_b2Body_SetAngle($__body_struct_ptr[$body_struct_ptr_index], $angle)
	EndIf

	; add other attributes, such as the initial positions, angles and body widths and heights to the internal arrays for bodies
	_ArrayAdd($__body_prev_screen_x, -1)
	_ArrayAdd($__body_prev_screen_y, -1)
	_ArrayAdd($__body_curr_screen_x, -1)
	_ArrayAdd($__body_curr_screen_y, -1)
	_ArrayAdd($__body_prev_angle_degrees, -1)
	_ArrayAdd($__body_curr_angle_degrees, -1)
	_ArrayAdd($__body_width, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 0))
	_ArrayAdd($__body_height, _ArrayMax($__shape_vertice[$shape_index], 1, -1, -1, 1))
	_ArrayAdd($__body_out_of_bounds_behaviour, $out_of_bounds_behaviour)
	_ArrayAdd($__body_draw, True)

	; create a new Box2C Fixture for the index of the body created, and the index of the shape supplied, and other attributes supplied (density, restitution and friction), add it to the internal array of fixture structures
	Local $fixture_struct_ptr_index = _ArrayAdd($__fixture_struct_ptr, _Box2C_b2World_CreateFixture($__body_struct_ptr[$body_struct_ptr_index], $__shape_struct_ptr[$shape_index], $density, $restitution, $friction))

	; get the GUI position of the initial (vector) position of the body, and add it to the internal array of body GUI positions

	if IsNumber($x) = False or IsNumber($y) = False Then

		local $b2BodyDef = DllStructCreate("STRUCT;int;float;float;float;float;float;float;float;float;bool;bool;bool;bool;bool;ptr;float;ENDSTRUCT", $__bodydef_struct_ptr[$bodydef_index])
		$x = DllStructGetData($b2BodyDef, 2)
		$y = DllStructGetData($b2BodyDef, 3)
	EndIf

	Local $tmp_gui_pos = _Box2C_b2Vec2_GetGUIPosition($x, $y, $__shape_vertice[$shape_index])
	_ArrayAdd($__body_gui_pos, $tmp_gui_pos[0] & "|" & $tmp_gui_pos[1])

	; add the index of the shape to the internal array of body shapes
	_ArrayAdd($__body_shape_index, $shape_index)

	; Add the SFML sprite

	_ArrayAdd($__sprite_ptr, Null)
	$__sprite_ptr[$body_struct_ptr_index] = _CSFML_sfSprite_create()
	_CSFML_sfSprite_setTexture($__sprite_ptr[$body_struct_ptr_index], $__shape_image[$shape_index], $CSFML_sfTrue)
;	_CSFML_sfSprite_setOrigin($__sprite_ptr[$body_struct_ptr_index], _CSFML_sfVector2f_Constructor((($__body_width[$body_struct_ptr_index] / 2) * $__pixels_per_metre) + $shape_x_pixel_offset, (($__body_height[$body_struct_ptr_index] / 2) * $__pixels_per_metre) + $shape_y_pixel_offset))
	_CSFML_sfSprite_setOrigin($__sprite_ptr[$body_struct_ptr_index], _CSFML_sfVector2f_Constructor(-$shape_x_pixel_offset, -$shape_y_pixel_offset))
	_ArrayAdd($__sprite_screen_x_offset, $shape_x_pixel_offset)
	_ArrayAdd($__sprite_screen_y_offset, $shape_y_pixel_offset)

	; Add the SFML convex shape

	Local $tmp_shape_vertice_arr = $__shape_vertice[$shape_index]

	_ArrayAdd($__convex_shape_ptr, Null)
	$__convex_shape_ptr[$body_struct_ptr_index] = _CSFML_sfConvexShape_Create()
	_CSFML_sfConvexShape_setPointCount($__convex_shape_ptr[$body_struct_ptr_index], UBound($tmp_shape_vertice_arr))

;_ArrayDisplay($tmp_shape_vertice_arr)

	for $i = 0 to (UBound($tmp_shape_vertice_arr) - 1)

		_CSFML_sfConvexShape_setPoint($__convex_shape_ptr[$body_struct_ptr_index], $i, $tmp_shape_vertice_arr[$i][0] * 50, $tmp_shape_vertice_arr[$i][1] * 50)
	Next

;	_CSFML_sfConvexShape_setOrigin($__convex_shape_ptr[$body_struct_ptr_index], _CSFML_sfVector2f_Constructor(($__body_width[$body_struct_ptr_index] / 2) * $__pixels_per_metre, ($__body_height[$body_struct_ptr_index] / 2) * $__pixels_per_metre))
	_CSFML_sfConvexShape_setOrigin($__convex_shape_ptr[$body_struct_ptr_index], _CSFML_sfVector2f_Constructor(0, 0))
	_CSFML_sfConvexShape_setFillColor($__convex_shape_ptr[$body_struct_ptr_index], _CSFML_sfColor_Constructor(255, 255, 255, 128))



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
	_ArrayAdd($__body_out_of_bounds_behaviour, 0)
	_ArrayAdd($__body_draw, True)

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
; Name...........: _Box2C_b2BodyArray_SetItemImage_SFML
; Description ...: A convenience function for SFML that sets the image for a body (b2Body) and sprite to an internal (PTR) array of bodies and sprites.
; Syntax.........: _Box2C_b2BodyArray_SetItemImage_SFML($body_index, $shape_index)
; Parameters ....: $body_index - the index of the body
;				   $shape_index - the index of the shape
; Return values .: The index of the body within the internal array of bodies.
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetItemImage_SFML($body_index, $shape_index)


	; Add the SFML sprite

;	_ArrayAdd($__sprite_ptr, Null)
;	$__sprite_ptr[$body_struct_ptr_index] = _CSFML_sfSprite_create()
	_CSFML_sfSprite_setTexture($__sprite_ptr[$body_index], $__shape_image[$shape_index], $CSFML_sfTrue)
	_CSFML_sfSprite_setOrigin($__sprite_ptr[$body_index], _CSFML_sfVector2f_Constructor(($__body_width[$body_index] / 2) * $__pixels_per_metre, ($__body_height[$body_index] / 2) * $__pixels_per_metre))

	$__body_shape_index[$body_index] = $shape_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetItemActive
; Description ...: A convenience function that activates or deactivates a body based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_SetItemActive($body_index, $active)
; Parameters ....: $body_index - the index of the body
;				   $active - True to activate, False to deactivate
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetItemActive($body_index, $active)

	_Box2C_b2Body_SetActive($__body_struct_ptr[$body_index], $active)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_GetItemPosition
; Description ...: A convenience function that gets the position (vector) of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_GetItemPosition($body_index)
; Parameters ....: $body_index - the index of the body
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_GetItemPosition($body_index)

	Return _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_index])
EndFunc

Func _Box2C_b2BodyArray_GetItemGUIPosition($body_index)

	Local $position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_index])

	Local $gui_pos[2]

	; get the GUI center
	Local $gui_x_center = $__GUI_Area[0] / 2
	Local $gui_y_center = $__GUI_Area[1] / 2

	$gui_pos[0] = $gui_x_center + ($position[0] * $__pixels_per_metre)
	$gui_pos[1] = $gui_y_center - ($position[1] * $__pixels_per_metre)


	return $gui_pos
EndFunc






; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetItemPosition
; Description ...: A convenience function that sets the position (vector) of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_SetItemPosition($body_index)
; Parameters ....: $body_index - the index of the body
;				   $x -
;				   $y -
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetItemPosition($body_index, $x, $y)

	_Box2C_b2Body_SetPosition($__body_struct_ptr[$body_index], $x, $y)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_GetItemAngle
; Description ...: A convenience function that gets the angle (radians) of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_GetItemAngle($body_index)
; Parameters ....: $body_index - the index of the body
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_GetItemAngle($body_index)

	Return _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_index])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetItemAngle
; Description ...: A convenience function that sets the angle (radians) of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_SetItemAngle($body_index, $angle)
; Parameters ....: $body_index - the index of the body
;				   $angle - the angle to set the body to
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetItemAngle($body_index, $angle)

	_Box2C_b2Body_SetAngle($__body_struct_ptr[$body_index], $angle)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_GetItemLinearVelocity
; Description ...: A convenience function that gets the linear velocity of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_GetItemLinearVelocity($body_index)
; Parameters ....: $body_index - the index of the body
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_GetItemLinearVelocity($body_index)

	Return _Box2C_b2Body_GetLinearVelocity($__body_struct_ptr[$body_index])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetItemLinearVelocity
; Description ...: A convenience function that sets the linear velocity of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_SetItemLinearVelocity($body_index)
; Parameters ....: $body_index - the index of the body
;				   $velocity
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetItemLinearVelocity($body_index, $velocity)

	Return _Box2C_b2Body_SetLinearVelocity($__body_struct_ptr[$body_index], $velocity[0], $velocity[1])
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetItemAwake
; Description ...: A convenience function that sets the awake state of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_SetItemAwake($body_index, $awake)
; Parameters ....: $body_index - the index of the body
;				   $awake - True for awake, False for sleep
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetItemAwake($body_index, $awake)

	_Box2C_b2Body_SetAwake($__body_struct_ptr[$body_index], $awake)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_ApplyItemForceAtBody
; Description ...: A convenience function to apply a linear force of a given magnitude to a body based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_ApplyItemForceAtBody($body_index)
; Parameters ....: $body_index - the index of the body
;				   $force_x - the horizontal component of the force
;				   $force_y - the vertical component of the force
;				   $offset_point_x - the horizontal component of an offset point from the centroid (defaults to 0 for no offset)
;				   $offset_point_y - the vertical component of offset point from the centroid (defaults to 0 for no offset)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_ApplyItemForceAtBody($body_index, $force_x, $force_y, $offset_point_x = 0, $offset_point_y = 0)

	_Box2C_b2Body_ApplyForceAtBody($__body_struct_ptr[$body_index], $force_x, $force_y, $offset_point_x, $offset_point_y)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_ApplyItemDirectionalForceAtBody
; Description ...: A convenience function to apply a force of a given magnitude to a body, based on it's index within the internal body array, and relative to it's centroid (b2Body) and angle
; Syntax.........: _Box2C_b2BodyArray_ApplyItemDirectionalForceAtBody($body_index)
; Parameters ....: $body_index - the index of the body
;				   $force_magnitude - the size of the force
;				   $offset_point_x - the horizontal component of an offset point from the centroid (defaults to 0 for no offset)
;				   $offset_point_y - the vertical component of offset point from the centroid (defaults to 0 for no offset)
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_ApplyItemDirectionalForceAtBody($body_index, $force_magnitude, $offset_point_x = 0, $offset_point_y = 0)

	_Box2C_b2Body_ApplyDirectionalForceAtBody($__body_struct_ptr[$body_index], $force_magnitude, $offset_point_x, $offset_point_y)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_GetItemCount
; Description ...: A convenience function that gets the number of bodies within the internal body array
; Syntax.........: _Box2C_b2BodyArray_GetItemCount()
; Parameters ....:
; Return values .: Success - the number of bodies
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_GetItemCount()

	Return UBound($__body_struct_ptr)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetItemDraw
; Description ...: A convenience function that sets the draw state of a body based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_SetItemDraw($draw)
; Parameters ....: $body_index - the index of the body
;				   $draw - True to draw the body / sprite, False to not draw the body / sprite
; Return values .: Success - the number of bodies
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetItemDraw($body_index, $draw = True)

	$__body_draw[$body_index] = $draw
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_RotateItemTowardAngle
; Description ...: A convenience function that sets the angle (radians) of a body (b2Body) based on it's index within the internal body array
; Syntax.........: _Box2C_b2BodyArray_RotateItemTowardAngle($body_index, $angle, $rate)
; Parameters ....: $body_index - the index of the body
;				   $angle - the angle to rotate the body towards (must be between 0 and 360)
;				   $rate - the rate to rotate
; Return values .: Success - True
;				   Failure - False
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_RotateItemTowardAngle($body_index, $angle, $rate)

	Local $body_angle = _Degree(_Box2C_b2BodyArray_GetItemAngle($body_index))

	Local $diff_angle1 = $angle - $body_angle
	Local $diff_angle2 = $angle - 360 - $body_angle
	Local $diff_angle = $diff_angle2

	if abs($diff_angle1) < Abs($diff_angle2) Then

		$diff_angle = $diff_angle1
	EndIf

	Local $new_angle = $body_angle + (($diff_angle) * 0.08)
	_Box2C_b2BodyArray_SetItemAngle($body_index, _Radian($new_angle))
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_Transform_SFML
; Description ...: A convenience function for SFML that transforms all bodies (b2Body) in the internal array to SFML sprite positions and rotations
; Syntax.........: _Box2C_b2BodyArray_Transform_SFML()
; Parameters ....:
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_Transform_SFML()


	; Transform the Box2D bodies and draw SFML sprites

	Local $body_num = -1

	While True

		$body_num = $body_num + 1

		if $body_num > (UBound($__body_struct_ptr) - 1) Then

			ExitLoop
		EndIf

;		if $body_num = $draw_info_text_before_body Then

			; Draw the info text

;			_CSFML_sfRenderWindow_drawTextString($window_ptr, $info_text_ptr, $info_text_string, Null)
;		EndIf

		Local $body_position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_num])

		if $body_position[0] < -8 or $body_position[0] > 8 or $body_position[1] < -6 or $body_position[1] > 6 Then

			if $__body_out_of_bounds_behaviour[$body_num] = 4 Then

				_Box2C_b2BodyArray_SetItemAwake($body_num, False)
				$__body_draw[$body_num] = False
			EndIf

			if $__body_out_of_bounds_behaviour[$body_num] = 2 Then

				Local $velocity = _Box2C_b2Body_GetLinearVelocity($__body_struct_ptr[$body_num])

				if $body_position[0] < -8 or $body_position[0] > 8 Then

					_Box2C_b2Body_SetPosition($__body_struct_ptr[$body_num], $body_position[0] * 0.99, $body_position[1])
					_Box2C_b2Body_SetLinearVelocity($__body_struct_ptr[$body_num], 0 - $velocity[0], $velocity[1])
				EndIf

				if $body_position[1] < -6 or $body_position[1] > 6 Then

					_Box2C_b2Body_SetPosition($__body_struct_ptr[$body_num], $body_position[0], $body_position[1] * 0.99)
					_Box2C_b2Body_SetLinearVelocity($__body_struct_ptr[$body_num], $velocity[0], 0 - $velocity[1])
				EndIf
			EndIf

			if $__body_out_of_bounds_behaviour[$body_num] = 1 Then

				_Box2C_b2Body_Destroy_SFML($body_num)
				$body_num = $body_num - 1
			EndIf
		Else

			; Update sprite position

			; converting the below to C might improve animations by a further 500 frames per seconds

			$__body_curr_screen_x[$body_num] = $__gui_center_x + ($body_position[0] * $__pixels_per_metre)
;			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_position[0] = ' & $body_position[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;				$__body_curr_screen_x[$body_num] = x_metres_to_gui_x($body_position[0], $tmp_gui_center_x)

			$__body_curr_screen_y[$body_num] = $__gui_center_y - ($body_position[1] * $__pixels_per_metre)
;			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_position[1] = ' & $body_position[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;				$__body_curr_screen_y[$body_num] = y_metres_to_gui_y($body_position[1], $tmp_gui_center_y)

			_CSFML_sfSprite_setPosition_xy($__sprite_ptr[$body_num], $__body_curr_screen_x[$body_num], $__body_curr_screen_y[$body_num])
;			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_num = ' & $body_num & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;			_CSFML_sfConvexShape_setPosition($__convex_shape_ptr[$body_num], $__body_curr_screen_x[$body_num], $__body_curr_screen_y[$body_num])


			; Update sprite rotation

			Local $body_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_num])
			$__body_curr_angle_degrees[$body_num] = _Degree($body_angle)
			_CSFML_sfSprite_setRotation($__sprite_ptr[$body_num], $__body_curr_angle_degrees[$body_num])
;			_CSFML_sfConvexShape_setRotation($__convex_shape_ptr[$body_num], $__body_curr_angle_degrees[$body_num])
		EndIf
	WEnd

EndFunc



; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_ScrollerTransform_SFML
; Description ...: A convenience function for SFML that transforms all bodies (b2Body) in the internal array to SFML sprite positions and rotations for a scroller
; Syntax.........: _Box2C_b2BodyArray_ScrollerTransform_SFML()
; Parameters ....:
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_ScrollerTransform_SFML($view_centre_pos, $player_body_index)


	; Transform the Box2D bodies and draw SFML sprites

	Local $body_num = 0

	While True

		$body_num = $body_num + 1

		if $body_num > (UBound($__body_struct_ptr) - 1) Then

			ExitLoop
		EndIf

;		if $body_num = $draw_info_text_before_body Then

			; Draw the info text

;			_CSFML_sfRenderWindow_drawTextString($window_ptr, $info_text_ptr, $info_text_string, Null)
;		EndIf

		Local $body_position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_num])


		; Update sprite position

		; converting the below to C might improve animations by a further 500 frames per seconds

		if $body_num = $player_body_index And $body_position[0] < 8 Then

			$__body_curr_screen_x[$body_num] = $body_position[0] * $__pixels_per_metre
		Else

			if $body_num = $player_body_index And $body_position[0] > 150 Then

				$__body_curr_screen_x[$body_num] = 400 + (($body_position[0] - 150) * $__pixels_per_metre)
			Else

				$__body_curr_screen_x[$body_num] = ($body_position[0] - ($view_centre_pos[0] - 8)) * $__pixels_per_metre
			EndIf
		EndIf


		if $body_num = $player_body_index And $body_position[1] < -6 Then

			$__body_curr_screen_y[$body_num] = ($body_position[1] + 12) * $__pixels_per_metre
		Else

			if $body_num = $player_body_index And $body_position[1] > 37 Then

				$__body_curr_screen_y[$body_num] = 300 + (($body_position[1] - 37) * $__pixels_per_metre)
			Else

				$__body_curr_screen_y[$body_num] = ($body_position[1] - ($view_centre_pos[1] - 6)) * $__pixels_per_metre
			EndIf
		EndIf


;		_CSFML_sfSprite_setOrigin($__sprite_ptr[$body_num], _CSFML_sfVector2f_Constructor(0, 0))
		_CSFML_sfSprite_setPosition_xy($__sprite_ptr[$body_num], $__body_curr_screen_x[$body_num], $__body_curr_screen_y[$body_num])
;		_CSFML_sfConvexShape_setOrigin($__convex_shape_ptr[$body_num], _CSFML_sfVector2f_Constructor(0, 0))
		_CSFML_sfConvexShape_setPosition($__convex_shape_ptr[$body_num], $__body_curr_screen_x[$body_num], $__body_curr_screen_y[$body_num])

		; Update sprite rotation

		Local $body_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_num])
		$__body_curr_angle_degrees[$body_num] = _Degree($body_angle)
		_CSFML_sfSprite_setRotation($__sprite_ptr[$body_num], $__body_curr_angle_degrees[$body_num])
		_CSFML_sfConvexShape_setRotation($__convex_shape_ptr[$body_num], $__body_curr_angle_degrees[$body_num])
	WEnd

EndFunc




; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_GetDrawSpriteRange_SFML
; Description ...: A convenience function for SFML that gets the range of sprites to draw
; Syntax.........: _Box2C_b2BodyArray_GetDrawSpriteRange_SFML()
; Parameters ....:
; Return values .: a two dimensional array of the range
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_GetDrawSpriteRange_SFML()

	Local $range[2] = [$__sprite_draw_lower_index, $__sprite_draw_upper_index]
	return $range
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetDrawSpriteRange_SFML
; Description ...: A convenience function for SFML that sets a range of sprites to draw
; Syntax.........: _Box2C_b2BodyArray_SetDrawSpriteRange_SFML($lower_index, $upper_index)
; Parameters ....: $lower_index
;				   $upper_index
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetDrawSpriteRange_SFML($lower_index, $upper_index)

	$__sprite_draw_lower_index = $lower_index
	$__sprite_draw_upper_index = $upper_index
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_GetDrawConvexShapeRange_SFML
; Description ...: A convenience function for SFML that gets the range of convex shapes to draw
; Syntax.........: _Box2C_b2BodyArray_GetDrawConvexShapeRange_SFML()
; Parameters ....:
; Return values .: a two dimensional array of the range
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_GetDrawConvexShapeRange_SFML()

	Local $range[2] = [$__convex_shape_draw_lower_index, $__convex_shape_draw_upper_index]
	return $range
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_SetDrawConvexShapeRange_SFML
; Description ...: A convenience function for SFML that sets a range of convex shapes to draw
; Syntax.........: _Box2C_b2BodyArray_SetDrawConvexShapeRange_SFML($lower_index, $upper_index)
; Parameters ....: $lower_index
;				   $upper_index
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_SetDrawConvexShapeRange_SFML($lower_index, $upper_index)

	$__convex_shape_draw_lower_index = $lower_index
	$__convex_shape_draw_upper_index = $upper_index
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2BodyArray_Draw_SFML
; Description ...: A convenience function for SFML that draws all the SFML sprites in the internal array
; Syntax.........: _Box2C_b2BodyArray_Draw_SFML()
; Parameters ....:
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2BodyArray_Draw_SFML($window_ptr, $info_text_ptr = -1, $info_text_string = "", $draw_info_text_before_body = -1)

	Local $body_num = -1

	While True

		$body_num = $body_num + 1

		if $body_num > (UBound($__body_struct_ptr) - 1) Then

			ExitLoop
		EndIf

		if $draw_info_text_before_body > -1 And $body_num = $draw_info_text_before_body Then

			; Draw the info text

			_CSFML_sfRenderWindow_drawTextString($window_ptr, $info_text_ptr, $info_text_string, Null)
		EndIf

		if $__body_draw[$body_num] = True Then

			if $body_num >= $__sprite_draw_lower_index and $body_num <= $__sprite_draw_upper_index Then

				_CSFML_sfRenderWindow_drawSprite($window_ptr, $__sprite_ptr[$body_num], Null)
			EndIf

			if $body_num >= $__convex_shape_draw_lower_index and $body_num <= $__convex_shape_draw_upper_index Then

				_CSFML_sfRenderWindow_drawConvexShape($window_ptr, $__convex_shape_ptr[$body_num], Null)
			EndIf
		EndIf
	WEnd

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_ArrayDrawDisplay_SFML
; Description ...: A convenience function for SFML that draws and displays all the SFML sprites in the internal array
; Syntax.........: _Box2C_b2Body_ArrayDrawDisplay_SFML()
; Parameters ....:
; Return values .:
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _Box2C_b2Body_ArrayDrawDisplay_SFML($window_ptr, $info_text_ptr = -1, $info_text_string = "", $draw_info_text_before_body = -1)

	; Draw all sprites in the array

	_Box2C_b2BodyArray_Draw_SFML($window_ptr, $info_text_ptr, $info_text_string, $draw_info_text_before_body)

	; Render all the sprites to the Render Window

	_CSFML_sfRenderWindow_display($window_ptr)

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

;		ConsoleWrite(StringFormat("%4.2f", $body_position[0]) & " " & StringFormat("%4.2f", $body_position[1]) & " " & StringFormat("%4.2f", $body_angle) & " " & StringFormat("%4.2f", _Degree($body_angle)) & @CRLF)
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

	$__body_curr_angle_degrees[$body_index] = _Degree($body_angle)

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
	_ArrayDelete($__body_out_of_bounds_behaviour, $body_index)
	_ArrayDelete($__body_draw, $body_index)

	; destroy the graphics

	_GDIPlus_GraphicsDispose($__body_hGfx_Buffer[$body_index])
	_ArrayDelete($__body_hGfx_Buffer, $body_index)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Box2C_b2Body_Destroy_SFML
; Description ...: A convenience function for SFML that destroys a body (b2Body) within the internal (PTR) array of bodies.
; Syntax.........: _Box2C_b2Body_Destroy_SFML($body_index)
; Parameters ....: $body_index - the index of the body within the internal array of bodies to destroy
; Return values .: None
; Author ........: Sean Griffin
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
;Func _Box2C_b2Body_Destroy_SFML($body_index, $sprite_ptr)
Func _Box2C_b2Body_Destroy_SFML($body_index)

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
	_ArrayDelete($__body_out_of_bounds_behaviour, $body_index)
	_ArrayDelete($__body_draw, $body_index)

	; destroy the graphics

	_CSFML_sfSprite_destroy($__sprite_ptr[$body_index])
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_index = ' & $body_index & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	_ArrayDelete($__sprite_ptr, $body_index)
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $body_index = ' & $body_index & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console




	; Add the SFML sprite

;	_ArrayAdd($__sprite_ptr, Null)
;	$__sprite_ptr[$body_struct_ptr_index] = _CSFML_sfSprite_create()
;	_CSFML_sfSprite_setTexture($__sprite_ptr[$body_struct_ptr_index], $__shape_image[$shape_index], $CSFML_sfTrue)
;	_CSFML_sfSprite_setOrigin($__sprite_ptr[$body_struct_ptr_index], _CSFML_sfVector2f_Constructor(($__body_width[$body_struct_ptr_index] / 2) * $__pixels_per_metre, ($__body_height[$body_struct_ptr_index] / 2) * $__pixels_per_metre))



EndFunc

Func _Box2C_b2Body_DestroyAll_SFML($first_body_num = 0)

	while True

		if $first_body_num > (UBound($__body_struct_ptr) - 1) then

			ExitLoop
		EndIf

		_Box2C_b2Body_Destroy_SFML($first_body_num)
	WEnd
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



func _StringSplit2d($str,$delimiter = ",")

    ; #FUNCTION# ======================================================================================
    ; Name ................:    _DBG_StringSplit2D($str,$delimiter)
    ; Description .........:    Create 2d array from delimited string
    ; Syntax ..............:    _DBG_StringSplit2D($str, $delimiter)
    ; Parameters ..........:    $str        - pipe (|) delimited string to split
    ;                           $delimiter  - Delimter for columns
    ; Return values .......:    2D array
    ; Author ..............:    kylomas
    ; =================================================================================================

    local $a1 = stringregexp($str,'.*?(?:\||$)',3), $a2

    local $rows = ubound($a1) - 1, $cols = 0

    ; determine max number of columns by splitting each row and keeping highest ubound value

    for $i = 0 to ubound($a1) - 1
        $a2 = stringsplit($a1[$i],$delimiter,1)
        if ubound($a2) > $cols then $cols = ubound($a2)
    next

    ; define and populate array

    local $aRET[$rows][$cols-1]

    for $i = 0 to $rows - 1
        $a2 = stringsplit($a1[$i],$delimiter,3)
        for $j = 0 to ubound($a2) - 1
            $aRET[$i][$j] = StringReplace($a2[$j], "|", "")
        Next
    next

    return $aRET

endfunc

