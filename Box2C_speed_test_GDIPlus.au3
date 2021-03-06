#include <Array.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Timers.au3>
#include "Box2CEx.au3"

AutoItSetOption("GUIOnEventMode", 1)

Local $idMsg
Global $g_hGUI

; Box2C World

_Box2C_b2World_Setup(50, 640, 480, 0.000000000, -10.0000000)

; GUI Setup

Local $world_width = _Box2C_b2World_GetGUIArea(0)
Local $world_height = _Box2C_b2World_GetGUIArea(1)

$g_hGUI = GUICreate("Box2C Speed Test for the GDI+ Renderer", $world_width + 400, $world_height)

GUICtrlCreateGroup("World", $world_width + 10, 10, 380, 120)
Global $number_of_bodies_label = GUICtrlCreateLabel("Number of bodies = ", $world_width + 20, 80, 160, 20)
Global $fps_label = GUICtrlCreateLabel("FPS = ", $world_width + 20, 100, 160, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)


GUICtrlCreateGroup("Body", $world_width + 20, 220, 150, 50)
Global $create_body_button = GUICtrlCreateButton("Add (&a)", $world_width + 30, 240, 60, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)


GUICtrlCreateGroup("Center Platorm", $world_width + 20, 310, 150, 50)
Global $increase_platform_angle_button = GUICtrlCreateButton("Left (&q)", $world_width + 30, 330, 60, 20)
Global $decrease_platform_angle_button = GUICtrlCreateButton("Right (&e)", $world_width + 100, 330, 60, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

;GUICtrlSetOnEvent($restart_button, "restart")
;GUICtrlSetOnEvent($next_body_shape_button, "next_body_shape")
GUICtrlSetOnEvent($create_body_button, "create_body_button")
GUICtrlSetOnEvent($decrease_platform_angle_button, "decrease_platform_angle")
GUICtrlSetOnEvent($increase_platform_angle_button, "increase_platform_angle")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)

; GDI+ Setup

_Box2C_b2World_GDIPlusSetup($g_hGUI)

; Box2C shapes

Global $platform_shape_vertice[4][2] = [[0,0],[5,0],[5,1],[0,1]]
Local $platform_shape_index = _Box2C_b2PolygonShape_ArrayAdd_GDIPlus($platform_shape_vertice, @ScriptDir & "\platform.gif")

Global $small_crate_shape_vertice[4][2] = [[0,0],[0.5,0],[0.5,0.5],[0,0.5]]
Local $small_crate_shape_index = _Box2C_b2PolygonShape_ArrayAdd_GDIPlus($small_crate_shape_vertice, @ScriptDir & "\small_crate.gif")

Global $triangle_shape_vertice[3][2] = [[0,0],[1,0],[0.5,1]]
Local $triangle_shape_index = _Box2C_b2PolygonShape_ArrayAdd_GDIPlus($triangle_shape_vertice, @ScriptDir & "\sporttriangle.gif")

; Box2C body definitions


Local $platform_bodydef_index = _Box2C_b2BodyDefArray_AddItem(0, 0, -4, 0)
Local $platform2_bodydef_index = _Box2C_b2BodyDefArray_AddItem(0, -5, -3.2, -0.261799)
Local $platform3_bodydef_index = _Box2C_b2BodyDefArray_AddItem(0, +5, -3.2, +0.261799)
Local $falling_bodydef_index = _Box2C_b2BodyDefArray_AddItem(2, 0, 4, 0)

; Box2C Bodies

Local $platform_body_index = _Box2C_b2Body_ArrayAdd_GDIPlus($platform_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_vertice, 0, -4)
Local $platform2_body_index = _Box2C_b2Body_ArrayAdd_GDIPlus($platform2_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_vertice, -5, -3.2)
Local $platform3_body_index = _Box2C_b2Body_ArrayAdd_GDIPlus($platform3_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_vertice, +5, -3.2)
Local $falling_body_index = _Box2C_b2Body_ArrayAdd_GDIPlus($falling_bodydef_index, $small_crate_shape_index, 1, 0.2, 0.3, $small_crate_shape_vertice, 0, 4)

; Animation loop


Local $fps = 0
Local $fps_timer = _Timer_Init()


While True

	if $__destroy_all_bodies = True Then

		Exit
	EndIf

	; Every second calculate and display the FPS and number of active bodies

	if _Timer_Diff($fps_timer) > 1000 Then

		$fps_timer = _Timer_Init()

		GUICtrlSetData($number_of_bodies_label, "Number of bodies = " & UBound($__body_struct_ptr))
		GUICtrlSetData($fps_label, "FPS = " & $fps)
		$fps = 0
	EndIf


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

	Local $body_num = -1

	While True

		$body_num = $body_num + 1

		if $body_num > (UBound($__body_struct_ptr) - 1) Then

			ExitLoop
		EndIf

		_GDIPlus_GraphicsDrawImage($__body_hGfx_Buffer[$body_num], $__shape_image[$__body_shape_index[$body_num]], $__body_gui_pos[$body_num][0], $__body_gui_pos[$body_num][1])
	WEnd

	_GDIPlus_GraphicsDrawImage($__g_hGraphics, $__g_hBmp_Buffer, 0, 0)

	$fps = $fps + 1

	$__playing_anim = False

WEnd


; Functions

Func _Exit()

	$__destroy_all_bodies = True

	sleep(250)

	While UBound($__body_struct_ptr) > 0

		_Box2C_b2Body_Destroy(0)
	WEnd

	_Box2C_Shutdown()

	While UBound($__shape_image) > 0

		_GDIPlus_ImageDispose($__shape_image[0])
		_ArrayDelete($__shape_image, 0)
	WEnd

;    _GDIPlus_ImageDispose($__shape_image[$platform_shape_index])
;    _GDIPlus_ImageDispose($__shape_image[$crate_shape_index])
;	_ArrayDelete($__shape_image, $crate_shape_index)
 ;   _GDIPlus_GraphicsDispose($__body_hGfx_Buffer[$platform_body_index])
 ;   _GDIPlus_GraphicsDispose($__body_hGfx_Buffer[$falling_body_index])

	_GDIPlus_BitmapDispose($__g_hBmp_Buffer)
    _GDIPlus_GraphicsDispose($__g_hGraphics)
	_GDIPlus_Shutdown()

	GUIDelete($g_hGUI)

	Exit
EndFunc   ;==>_Exit


Func increase_platform_angle()

	Local $curr_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$platform_body_index])
	Local $curr_angle_degrees = radians_to_degrees($curr_angle)
	$curr_angle_degrees = $curr_angle_degrees + 5
	_Box2C_b2Body_SetAngle($__body_struct_ptr[$platform_body_index], degrees_to_radians($curr_angle_degrees))
EndFunc

Func decrease_platform_angle()

	Local $curr_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$platform_body_index])
	Local $curr_angle_degrees = radians_to_degrees($curr_angle)
	$curr_angle_degrees = $curr_angle_degrees - 5
	_Box2C_b2Body_SetAngle($__body_struct_ptr[$platform_body_index], degrees_to_radians($curr_angle_degrees))
EndFunc


#cs
Func next_body_shape()

	Switch $current_shape_image

		Case $crate_shape_image

			$current_shape_vertice = $triangle_shape_vertice
			$current_shape_image = $triangle_shape_image

		Case $triangle_shape_image

			$current_shape_vertice = $crate_shape_vertice
			$current_shape_image = $crate_shape_image
	EndSwitch

	$__body_def[0][$width] = _ArrayMax($current_shape_vertice, 1, -1, -1, 0)
	$__body_def[0][$height] = _ArrayMax($current_shape_vertice, 1, -1, -1, 1)

	Local $tmp_gui_pos = _Box2C_b2Vec2_GetGUIPosition(0, 4, $current_shape_vertice)
	$__body_def[0][$origin_gui_x] = $tmp_gui_pos[0]
	$__body_def[0][$origin_gui_y] = $tmp_gui_pos[1]

	$__body_def[0][$b2PolygonShapePortable_struct] = _Box2C_b2PolygonShape_Constructor($current_shape_vertice)
	$__body_def[0][$b2PolygonShapePortable_ptr] = DllStructGetPtr($__body_def[0][$b2PolygonShapePortable_struct])

	restart()
EndFunc
#ce

Func create_body_button()

	_Box2C_b2Body_ArrayAdd_GDIPlus($falling_bodydef_index, $small_crate_shape_index, 1, 0.2, 0.3, $small_crate_shape_vertice, 0, 4)

EndFunc

Func update_gui($hWnd, $iMsg, $iIDtimer, $iTime)
    #forceref $hWnd, $iMsg, $iIDTimer,$iTime

	GUICtrlSetData($number_of_bodies_label, "Number of bodies = " & UBound($__body_struct_ptr))

EndFunc
