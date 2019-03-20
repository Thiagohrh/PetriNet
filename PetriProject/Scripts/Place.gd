extends Area2D
 
var token_list = Array()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func get_token(_index):
	if !token_list.empty():
		#If its not empty...returns one!
		return token_list.front()
		pass
	else:
		return null
	pass

func add_token(_token):
	token_list.push_back(_token)
	
	pass