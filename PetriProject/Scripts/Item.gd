extends Node2D

var cell_size = 32
var possessed_by = null
var matrix_position = Vector2()

func _ready():
	add_to_group("item")
	pass

#func _process(delta):
#	In the future:
	#If possessed_by != null:
		#Move towards that reference position. Possibly do it by a TWEEN!
#	pass

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