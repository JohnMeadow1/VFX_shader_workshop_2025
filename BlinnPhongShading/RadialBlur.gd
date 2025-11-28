extends ColorRect

@export var light : DirectionalLight2D

var stored_position:Vector2

func _ready():
	material.set_shader_parameter("viewport_texture", %SubViewport.get_texture())
	stored_position = get_global_mouse_position()

func _process(_delta: float) -> void:
	stored_position = get_global_mouse_position()
	material.set_shader_parameter("light_source_pos", stored_position)
	%LightSource.global_position = stored_position

	var light_direction = (Vector3(stored_position.x - %Sprite2D.global_position.x,stored_position.y- %Sprite2D.global_position.y, 50.0)).normalized()
	%Sprite2D.material.set_shader_parameter("light_direction", light_direction.normalized())
