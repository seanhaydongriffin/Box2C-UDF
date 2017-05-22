#include-once
#include <Array.au3>
#include "Box2CEx.au3"
#include "Direct2D_1.au3"
#include "WIC.au3"
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
Opt("GUIOnEventMode", 1)

Global $oError = ObjEvent("AutoIt.Error", "_ErrFunc")
Func _ErrFunc()
	ConsoleWrite("COM Error, ScriptLine(" & $oError.ScriptLine & ") : Number 0x" & Hex($oError.Number, 8) & " - " & $oError.WinDescription & @CRLF)
EndFunc   ;==>_ErrFunc


Local $video_mode, $video_mode_ptr


; Setup Windows Imaging Component

Global $oWIC_ImagingFactory = _WIC_ImagingFactory_Create()

; Startup SFML

;_CSFML_Startup()

; Setup the Box2D World

_Box2C_b2World_Setup(50, 800, 600, 0.000000000, -10.0000000)
Local $tmp_gui_center_x = _Box2C_b2World_GetGUIAreaCenter(0)
Local $tmp_gui_center_y = _Box2C_b2World_GetGUIAreaCenter(1)

; Setup the Box2D Shapes

Global $platform_shape_vertice[4][2] = [[0,0],[5,0],[5,1],[0,1]]
Local $platform_shape_index = _Box2C_b2PolygonShape_ArrayAdd_SFML($platform_shape_vertice, @ScriptDir & "\platform.gif")

Global $crate_shape_vertice[4][2] = [[0,0],[0.25,0],[0.25,0.25],[0,0.25]]
Local $crate_shape_index = _Box2C_b2PolygonShape_ArrayAdd_SFML($crate_shape_vertice, @ScriptDir & "\smallest_crate.gif")

; Setup the Box2D Body Definitions

Local $platform_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(0, 0, -4, 0)
Local $platform2_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(0, -4.5, -2, -0.785398)
Local $platform3_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(0, +4.5, -2, +0.785398)
Local $falling_bodydef_index = _Box2C_b2BodyDef_ArrayAdd(2, 0, 4, 0)

; Setup the Box2D Bodies

Local $platform_body_index = _Box2C_b2Body_ArrayAdd_SFML($platform_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_index, 0, -4)
Local $platform2_body_index = _Box2C_b2Body_ArrayAdd_SFML($platform2_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_index, -4.5, -2)
Local $platform3_body_index = _Box2C_b2Body_ArrayAdd_SFML($platform3_bodydef_index, $platform_shape_index, 0, 0, 0, $platform_shape_index, +4.5, -2)
Local $falling_body_index = _Box2C_b2Body_ArrayAdd_SFML($falling_bodydef_index, $crate_shape_index, 1, 0.2, 0.3, $crate_shape_index, 0, 4)

; Setup basic variables for SFML

;Local $event = _CSFML_sfEvent_Constructor()
;Local $event_ptr = DllStructGetPtr($event)
;Local $black = _CSFML_sfColor_Constructor(0,0,0,0)
;Local $white = _CSFML_sfColor_Constructor(255,255,255,0)
;Local $pos = _CSFML_sfVector2f_Constructor(1,1)
;Local $pos_ptr = DllStructGetPtr($pos)

; Setup D2D

Global $oD2D_DeviceContext, $oID3D11SwapChain
Global $oD2D_Factory = _D2D_Factory1_Create()

; Setup the GUI for D2D

;$video_mode = _CSFML_sfVideoMode_Constructor(800, 600, 16)
;Local $window_ptr = _CSFML_sfRenderWindow_create($video_mode, "SFML window", $CSFML_sfWindowStyle_sfResize + $CSFML_sfWindowStyle_sfClose, Null)
;_CSFML_sfRenderWindow_setVerticalSyncEnabled($window_ptr, False)

Global $hGui = GUICreate("Box2C Speed Test for the Direct2D Renderer", 800, 600)

Global $create_body_button = GUICtrlCreateButton("Add Body (&a)", 10, 10, 80, 20)
GUICtrlSetOnEvent($create_body_button, "create_body_button")



GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
_D2D_CreateHWNDContext($oD2D_Factory, $hGui, $oD2D_DeviceContext, $oID3D11SwapChain)
;_D2D_Factory_CreateHwndRenderTarget($oD2D_Factory, $oD2D_DeviceContext, 0, 0, $D2D1_PRESENT_OPTIONS_IMMEDIATELY)
GUISetState(@SW_SHOW)


; Attach an AutoIT GUI for reporting

;Local $irr_win_pos = WinGetPos("Direct2D")
Global $g_hGUI = GUICreate("Stats", 300, 400);, $irr_win_pos[0] + $irr_win_pos[2], $irr_win_pos[1])
;Global $number_of_bodies_label = GUICtrlCreateLabel("Number of bodies = ", 20, 80, 160, 20)
;Global $b2world_step_time_label = GUICtrlCreateLabel("b2World_Step runtime = ", 20, 100, 160, 20)
;Global $CSFML_clear_transform_display_runtime_label = GUICtrlCreateLabel("CSFML_clear_tranform_display runtime = ", 20, 120, 260, 20)
GUICtrlCreateLabel("Press ""A"" to add (drop) a new box / body to the world", 20, 60, 160, 40)
Global $number_of_bodies_label = GUICtrlCreateLabel("Number of bodies = ", 20, 100, 160, 20)
Global $fps_label = GUICtrlCreateLabel("FPS = ", 20, 120, 160, 20)
GUISetState(@SW_SHOW)
;WinActivate( "SFML window" )


; Setup the initial 4 D2D sprites

Global $iImgW[0]
Global $iImgH[0]
Global $pOutPut[0]
Global $oWIC_BitmapDecoder[0]
Global $oWIC_Bitmap[0]
Global $oWIC_FormatConverter[0]
Global $oD2D_Bitmap[0]
Global $oD2D_PerspectiveTransformEffect[0]
Global $pOutPut[0]

;local $sprite_ptr[UBound($__body_struct_ptr)]

for $body_num = 0 to (UBound($__body_struct_ptr) - 1)

;	$sprite_ptr[$body_num] = _CSFML_sfSprite_create()

	Local $image_path

	if $body_num >= 0 and $body_num <= 2 Then

		$image_path = @ScriptDir & "\platform.gif"
	Else

		$image_path = @ScriptDir & "\smallest_crate.gif"
	EndIf

	D2D_sprite_arrayadd($image_path)


;	if $body_num >= 0 and $body_num <= 2 Then

;		_CSFML_sfSprite_setTexture($sprite_ptr[$body_num], $__shape_image[$platform_shape_index], $CSFML_sfTrue)
;	Else

;		_CSFML_sfSprite_setTexture($sprite_ptr[$body_num], $__shape_image[$crate_shape_index], $CSFML_sfTrue)
;	EndIf

;	_CSFML_sfSprite_setOrigin($sprite_ptr[$body_num], _CSFML_sfVector2f_Constructor(($__body_width[$body_num] / 2) * $__pixels_per_metre, ($__body_height[$body_num] / 2) * $__pixels_per_metre))
Next


; Setup the Box2D animation, including the clocks (timers) and animation rate

;Local $clock_ptr = _CSFML_sfClock_create()
;Local $b2World_Step_clock_ptr = _CSFML_sfClock_create()
;Local $b2World_Step_runtime_clock_ptr = _CSFML_sfClock_create()
;Local $CSFML_clear_transform_display_runtime_clock_ptr = _CSFML_sfClock_create()
;Local $fps_clock_ptr = _CSFML_sfClock_create()
;Local $fps = 0

; in microseconds (i.e. 1 60th of a second times 1,000,000 microseconds in a second)
Local $animation_rate = Int(1 / 60 * 1000000)
Local $fps = 0

; The animation loop

Local $fps_timer = _Timer_Init()
Local $anim_timer = _Timer_Init()

While True

	; Every second calculate and display the FPS and number of active bodies

	if _Timer_Diff($fps_timer) > 1000 Then

		$fps_timer = _Timer_Init()

		GUICtrlSetData($number_of_bodies_label, "Number of bodies = " & UBound($__body_struct_ptr))
		GUICtrlSetData($fps_label, "FPS = " & $fps)
		$fps = 0
	EndIf

	; Every animation frame update the Box2D world

;	if _Timer_Diff($anim_timer) > ((5 / 60) * 1000) Then

		$anim_timer = _Timer_Init()

		_Box2C_b2World_Step($__world_ptr, (1.0 / 60.0), 6, 2)
;		_Box2C_b2World_Step($__world_ptr, (0.1 + (UBound($__body_struct_ptr) / 50)) / 60.0, 6, 2)

		; Clear the animation frame

		$oD2D_DeviceContext.BeginDraw()
		$oD2D_DeviceContext.Clear(_D2D1_COLOR_F(0, 0, 0, 1))

		; Transform the Box2D bodies and SFML sprites

		Local $body_num = -1

		While True

			$body_num = $body_num + 1

			if $body_num > (UBound($__body_struct_ptr) - 1) Then

				ExitLoop
			EndIf

			Local $body_position = _Box2C_b2Body_GetPosition($__body_struct_ptr[$body_num])

			if $body_position[1] < -11 Then

				_Box2C_b2Body_Destroy($body_num)
;				_CSFML_sfSprite_destroy($sprite_ptr[$body_num])
;				_ArrayDelete($sprite_ptr, $body_num)
			Else

				$__body_curr_screen_x[$body_num] = $tmp_gui_center_x + ($body_position[0] * $__pixels_per_metre)
;				$__body_curr_screen_x[$body_num] = x_metres_to_gui_x($body_position[0], $tmp_gui_center_x)

				$__body_curr_screen_y[$body_num] = $tmp_gui_center_y - ($body_position[1] * $__pixels_per_metre)
;				$__body_curr_screen_y[$body_num] = y_metres_to_gui_y($body_position[1], $tmp_gui_center_y)

				Local $body_angle = _Box2C_b2Body_GetAngle($__body_struct_ptr[$body_num])
				$__body_curr_angle_degrees[$body_num] = 0 - radians_to_degrees($body_angle)

				$oD2D_PerspectiveTransformEffect[$body_num].SetValue($D2D1_3DPERSPECTIVETRANSFORM_PROP_ROTATION, $D2D1_PROPERTY_TYPE_VECTOR3, _D2D1_VECTOR_3F(0, 0, $__body_curr_angle_degrees[$body_num]), _D2D1_SIZEOF($tagD2D1_VECTOR_3F))
				_D2D_DeviceContext_DrawImage($oD2D_DeviceContext, $pOutPut[$body_num], $__body_curr_screen_x[$body_num], $__body_curr_screen_y[$body_num])
			EndIf
		WEnd

		; Render the animation frame

		$oD2D_DeviceContext.EndDraw(0, 0)
;		$oID3D11SwapChain.Present(1, 0)
		$oID3D11SwapChain.Present(0, 0)
;	EndIf

		$fps = $fps + 1
WEnd

; Shutdown SFML
;_CSFML_Shutdown()



Func create_body_button()


	Local $new_body_num = _Box2C_b2Body_ArrayAdd_SFML($falling_bodydef_index, $crate_shape_index, 1, 0.2, 0.3, $crate_shape_vertice, 0, 4)

	D2D_sprite_arrayadd(@ScriptDir & "\smallest_crate.gif")

;	_ArrayAdd($sprite_ptr, Null)
;	$sprite_ptr[$new_body_num] = _CSFML_sfSprite_create()
;	_CSFML_sfSprite_setTexture($sprite_ptr[$new_body_num], $__shape_image[$crate_shape_index], $CSFML_sfTrue)
;	_CSFML_sfSprite_setOrigin($sprite_ptr[$new_body_num], _CSFML_sfVector2f_Constructor(($__body_width[$new_body_num] / 2) * $__pixels_per_metre, ($__body_height[$new_body_num] / 2) * $__pixels_per_metre))

EndFunc



Func _Exit()
	$oD2D_Bitmap = 0
	$oD2D_PerspectiveTransformEffect = 0

	$oWIC_Bitmap = 0
	$oWIC_Bitmap2 = 0
	$oWIC_BitmapDecoder = 0
	$oWIC_BitmapDecoder2 = 0
	$oWIC_FormatConverter = 0
	$oWIC_FormatConverter2 = 0
	$oWIC_ImagingFactory = 0

	$oID3D11SwapChain = 0
	$oD2D_DeviceContext = 0
	$oD2D_Factory = 0

	GUIDelete($hGui)
	Exit
EndFunc   ;==>_Exit

Func D2D_sprite_arrayadd($image_path)

	Local $body_num = _ArrayAdd($iImgW, Null)
	_ArrayAdd($iImgH, Null)
	_ArrayAdd($pOutPut, Null)
	_ArrayAdd($oWIC_BitmapDecoder, Null)
	_ArrayAdd($oWIC_Bitmap, Null)
	_ArrayAdd($oWIC_FormatConverter, Null)
	_ArrayAdd($oD2D_Bitmap, Null)
	_ArrayAdd($oD2D_PerspectiveTransformEffect, Null)
	_ArrayAdd($pOutPut, Null)

	$oWIC_BitmapDecoder[$body_num] = _WIC_ImagingFactory_CreateDecoderFromFilename($oWIC_ImagingFactory, $image_path)
	$oWIC_Bitmap[$body_num] = _WIC_BitmapDecoder_GetFrame($oWIC_BitmapDecoder[$body_num])
	$oWIC_FormatConverter[$body_num] = _WIC_ImagingFactory_CreateFormatConverter($oWIC_ImagingFactory)
	$oWIC_FormatConverter[$body_num].Initialize($oWIC_Bitmap[$body_num], _WinAPI_GUIDFromString($sGUID_WICPixelFormat32bppPBGRA), 0, Null, 0.0, 0)
	$oWIC_FormatConverter[$body_num].GetSize($iImgW[$body_num], $iImgH[$body_num])
	$oD2D_Bitmap = _D2D_RenderTarget_CreateBitmapFromWicBitmap($oD2D_DeviceContext, $oWIC_FormatConverter[$body_num])
	$oD2D_PerspectiveTransformEffect[$body_num] = _D2D_DeviceContext_CreateEffect($oD2D_DeviceContext, $sIID_D2D13DPerspectiveTransform)
	$oD2D_PerspectiveTransformEffect[$body_num].SetInput(0, $oD2D_Bitmap, True)
	$oD2D_PerspectiveTransformEffect[$body_num].SetValue($D2D1_3DPERSPECTIVETRANSFORM_PROP_PERSPECTIVE_ORIGIN, $D2D1_PROPERTY_TYPE_VECTOR2, _D2D1_VECTOR_2F($iImgW[$body_num] * 0.5, $iImgH[$body_num] * 0.5), _D2D1_SIZEOF($tagD2D1_VECTOR_2F))
	$oD2D_PerspectiveTransformEffect[$body_num].SetValue($D2D1_3DPERSPECTIVETRANSFORM_PROP_ROTATION_ORIGIN, $D2D1_PROPERTY_TYPE_VECTOR3, _D2D1_VECTOR_3F($iImgW[$body_num] * 0.5, $iImgH[$body_num] * 0.5), _D2D1_SIZEOF($tagD2D1_VECTOR_3F))
	$oD2D_PerspectiveTransformEffect[$body_num].SetValue($D2D1_3DPERSPECTIVETRANSFORM_PROP_INTERPOLATION_MODE, $D2D1_PROPERTY_TYPE_ENUM, _D2D1_UINT($D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR), _D2D1_SIZEOF("uint"))
	$oD2D_PerspectiveTransformEffect[$body_num].GetOutput($pOutPut[$body_num])

EndFunc


