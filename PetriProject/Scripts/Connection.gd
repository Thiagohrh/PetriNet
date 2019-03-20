extends Area2D

var place
var transition
var weight
var is_entrance
var is_inhibitor_arc

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func set_Place(_place):
	place = _place

func set_Transition(_transition):
	transition = _transition

func set_Weight(_weight):
	weight = _weight

func set_is_entrance_to_transition(_is_it):
	is_entrance = _is_it

func set_is_inhibitor_arc(_is_it):
	is_inhibitor_arc = _is_it

func get_Place():
	return place

func get_Transition():
	return transition

func get_Weight():
	return weight

func get_is_entrance_to_transition():
	return is_entrance

func get_is_inhibitor_arc():
	return is_inhibitor_arc

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
