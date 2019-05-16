extends Node2D

var cell_size = 32
var possessed_by = null
var matrix_position = Vector2()

var gotten = false

func _ready():
	add_to_group("item")
	pass

func set_grid_position(_L, _C):
	#Should call the MovementTween in order to move this token.
	pass

func set_position_on_grid(_x, _y):
	matrix_position.x = _x
	matrix_position.y = _y
	pass

func get_position_on_grid():
	return matrix_position

func get_place_holding_this():
	return possessed_by

func set_destination_node(_node):
	possessed_by = _node
	if $MovementTween.is_processing():
		$MovementTween.stop()
	
	$MovementTween.interpolate_property(self,"global_position", global_position, possessed_by.global_position, 0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0)
	$MovementTween.start()
	pass

func set_gotten(_state):
	gotten = _state
	if gotten:
		var rec_pos = Vector2(80,128)
		var rec_dim = Vector2(16,16)
		var final_rec = Rect2(rec_pos, rec_dim)
		$Sprite.region_rect = final_rec
		$ItemGet.play()
	pass

func get_gotten():
	return gotten