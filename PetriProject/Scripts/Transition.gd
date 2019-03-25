extends Area2D

var token_list = Array()

var id = null

var connInList = Array()
var connOutList = Array()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_id(_id):
	id = _id

func get_id():
	return id

func add_connection_to_list(_connection):
	#Checks if the connection is of entrance or exit. Adds it to an Array() to better control where it is.
	if _connection.get_is_entrance_to_transition():
		#Ok...if it IS and entrance to THIS transition...
		connInList.push_back(_connection)
		pass
	else:
		connOutList.push_back(_connection)
		pass
	pass

func get_connection_entrances():
	return connInList

func get_connection_exits():
	return connOutList

func check_token_amount():
	return token_list.size()