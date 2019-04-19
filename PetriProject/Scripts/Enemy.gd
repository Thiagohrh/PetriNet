extends Node2D

var cell_size = 32
var possessed_by = null
var matrix_position = Vector2()

var movement_intent = Vector2()

func _ready():
	randomize()
	add_to_group("enemy")
	pass

func get_new_direction_intent():
	randomize()
	var opt = randi() % 4
	
	match opt:
		0:
			movement_intent = Vector2(-1,0)
		1:
			movement_intent = Vector2(1,0)
		2:
			movement_intent = Vector2(0,-1)
		3:
			movement_intent = Vector2(0,1)
	
	return movement_intent


func set_grid_position(_L, _C):
	#Should call the MovementTween in order to move this token.
	pass

func set_position_on_grid(_x, _y):
	matrix_position.x = _x
	matrix_position.y = _y
	
	pass

func get_position_on_grid():
	return matrix_position

func set_destination_node(_node):
	possessed_by = _node
	if $MovementTween.is_processing():
		$MovementTween.stop()
	
	$MovementTween.interpolate_property(self,"global_position", global_position, possessed_by.global_position, 0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0)
	$MovementTween.start()
	pass