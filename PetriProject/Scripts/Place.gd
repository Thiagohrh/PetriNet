extends Area2D

var pos_identity = Vector2()
var token_list = Array()
var avaliable = true

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func set_identity(_x, _y):
	pos_identity.x = _x
	pos_identity.y = _y

func get_pos_identity():
	return pos_identity

func set_avaliable(_avaliable):
	avaliable = _avaliable
	if !_avaliable:
		modulate = Color(0.5,0.5,0.5,1)

func check_avaliable():
	return avaliable

func get_token(_index):
	if !token_list.empty():
		#If its not empty...returns one!
		return token_list.front()
		pass
	else:
		return null
	pass

func get_token_from_this_place():
	#Returns a token from here, also removing it from thos domain.
	if !token_list.empty():
		
		var token_reference = token_list.front()
		token_list.pop_front()
		print("A token has been removed from " , name)
		return token_reference
		pass
	else:
		return null
	pass

func add_token(_token):
	if avaliable:
		token_list.push_back(_token)
		print("A token has been added to " , name)
	pass

func check_token_amount():
	return token_list.size()