extends Sprite2D


func _process(delta):
	position = get_global_mouse_position()

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		rotation += delta
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		rotation -= delta
