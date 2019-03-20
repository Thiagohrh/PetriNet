extends Area2D

#Should have some prefabs here...
export (PackedScene) var Token
export (PackedScene) var Flag
export (PackedScene) var Npc
export (PackedScene) var Player
export (PackedScene) var Place
export (PackedScene) var Transition
export (PackedScene) var Connection
#Should have some prefabs here...


var matrix
var lines = 3
var columns = 3

var cicle_time = 1

func _ready():
	var matrix = []
	
	for x in range(lines):
		var col = []
		col.resize(columns)
		matrix.append(col)
		pass
	#Use this in order to populate it...
	
	matrix[0][0] = 4
	print(matrix[0][0])
	pass

#------All these functions work as to permit creating and editing of the network.
func createPlace(_line, _column):
	#Functions creates a PLACE on those coordinates.
	#This is the place where it should create stuff...ok...
	var newPlace = Place.instance()
	matrix[_line][_column] = newPlace
	$Places.add_child(newPlace)
	#Should add a better positioning system at a later date.
	pass

func getPlace(_line, _column):#Returns a PLACE when asked. acoording to the position it recieves as arguments.
	return matrix[_line][_column]

func removePlace(_line, _column):#Removes and puts NULLPTR on that position of the matrix.
	matrix[_line][_column] = null

#Speaking of transitions, i guess they are gonna be put on its own dictionary, in order to better access them.
func createTransition(_id):
	#Creates a transition that connects two PLACES!
	var newTransition = Transition.instance()
	$Transitions.add_child(newTransition)
	#Still no idea on the logics behind the IDS....maybe it WOULD be easier to just add them to a dictionary. Hmmm...how about....
	if _id == null:#If for some reason a manual ID wasnt put...
		newTransition.set_id($Transitions.get_child_count() - 1)
	else:
		newTransition.set_id(_id)
	pass

func removeTransition(_id):
	#Should remove the transition with a certain ID
	#Goes trough all the child instances of the type TRANSITIONS. If they have a certain ID, Delete them.
	var index_to_delete = null 
	if $Transitions.get_child_count() > 0 and _id != null:
		for i in $Transitions.get_children():
			if i.get_id() == _id:
				index_to_delete = $Transitions.get_children().find(i)
				pass
			pass
		pass
		$Transitions.get_child(index_to_delete).queue_free()
	pass

func getTransition(_id):
	#Should return a certain transition based on its ID.
	if $Transitions.get_child_count() > 0 :
		#Only goes through all the children if it HAS children amirite? hue hue
		for i in $Transitions.get_children():
			if i.get_id() == _id:
				return i
				pass
			else:
				return null
			pass
		pass
	else:
		print("Something has gone wrong here. GetTransition doesnt have children to get back!")
		return null
	pass

func createConnection(_place, _transition, _int_weight, _bool_is_entrance, _bool_is_inhibitor_arc):
	var newConnection = Connection.instance()
	$Connections.add_child(newConnection)
	
	#Should probrably have some easier way to do this. But i rather have some diferent functions to do this.
	#In case you need to set these parameters manually.
	newConnection.set_Place(_place)
	newConnection.set_Transition(_transition)
	newConnection.set_Weight(_int_weight)
	newConnection.set_is_entrance_to_transition(_bool_is_entrance)
	newConnection.set_is_inhibitor_arc(_bool_is_inhibitor_arc)
	
	#Here it should ALSO warn both the _place and the _transition about this connection...
	#the _transition needs to have 2 arrays, one for each connection type......so....
	_transition.add_connection_to_list(newConnection)
	
	pass

func removeConnection(_place, _transition):
	#In order to delete a Connection....hmmm....not thinking about queue_free() stuff...but mainly...hmmm...
	#I dunno how to remove a connection considering it needs to use a Place?...kindda confusing...
	pass

func get_place_of_connection(_connection):
	return _connection.get_Place()
	pass

func get_transition_of_connection(_connection):
	return _connection.get_Transition()
	pass

func get_all_entrance_connections(_id):
	#Should return an array() of the connections of entrance from a certain TRANSITION
	#Search for the transition with that ID....hmmm....
	if $Transitions.get_child_count() > 0:
		for i in $Transitions.get_children():
			if i.get_id() == _id:
				return i.get_connection_entrances()
				pass
			pass
		pass
	else:
		return null
	pass

func get_all_exit_connections(_id):
	#Should return an array() of the connections of exit from a certain transition
	if $Transitions.get_child_count() > 0:
		for i in $Transitions.get_children():
			if i.get_id() == _id:
				return i.get_connection_exits()
				pass
			pass
		pass
	else:
		return null
	pass

#---------------------------------These functions work as to permit modifications/inspections of the network.

func insert_token_in_place(_token, _place):
	#Do i even need these?
	#Like..._token...ill create that....
	#_place...well it would be nice to know where should i put the new token...hmmm...
	pass

func remove_token_from_place(_token, _place):
	
	pass

func clearPlace(_place):
	#Should remove all tokens from that place.
	
	pass

func getToken(_place):
	#Returns a token.
	pass

func getAllTokens(_place):
	#Returns an array() of tokens
	pass

func get_how_many_tokens(_line, _column):
	#Returns the quantity of tokens in a certain place
	pass

func get_transition_status(_id):
	#Returns true if the transition is allowed, or false if not allowed
	pass

func setTransicaoInactive(_id): # sets a tansition as inactive
	
	pass

func setTransicaoActive(_id): # sets a tansition as active
	
	pass

func is_transition_active(_id):
	#Checks if that transition is active. Returns a bool
	pass

#-----------------------These as i see them are optional.
func save_network(_string_file_name):
	
	pass

func load_network(_string_file_name):
	
	pass

func execute_cicle():
	#Goes through out all the network identifying all transitions that are active, and executing them. The movement of Tokens and signal of each transition could
	#mean the calling of methods of call back so it can be seen on screen.
	
	#This is what SHOULD be working by the time you make the delivery.
	print("CICLE!")
	pass

func _on_StepTimer_timeout():
	#Use this function to call execute_cicle! That way, the steps are separated in chunks of time.
	execute_cicle()
	pass # replace with function body
