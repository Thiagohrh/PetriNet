extends Area2D

var cell_size = 32
var possessed_by = null

func _ready():
	pass

#func _process(delta):
#	In the future:
	#If possessed_by != null:
		#Move towards that reference position. Possibly do it by a TWEEN!
#	pass

func set_grid_position(_L, _C):
	#Should call the MovementTween in order to move this token.
	pass

func set_destination_node(_node):
	possessed_by = _node
	pass