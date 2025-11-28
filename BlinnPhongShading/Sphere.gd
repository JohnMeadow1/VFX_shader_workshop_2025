@tool
extends Node2D

var angle = 0.0
func _ready():
	pass

func _process(delta):
	angle += delta
	var light_direction = (Vector3($Marker2D.position.x,$Marker2D.position.y, 500.0)).normalized()
	#var light_direction = Vector3(1.0,0.0,1.0).normalized().rotated(Vector3.FORWARD,angle)
	$Sprite2D.material.set_shader_parameter("light_direction", light_direction)
