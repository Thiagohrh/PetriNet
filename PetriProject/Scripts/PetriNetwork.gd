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
var lines = 5
var columns = 5

func _ready():
	var matrix = []
	
	for x in range(lines):
		var col = []
		col.resize(columns)
		matrix.append(col)
		pass
	#Use this in order to populate it...
	
	#matrix[0][0] = 4
	print(matrix[0][0])
	pass

#------All these functions work as to permit creating and editing of the network.
func createPlace(_line, _column):
	#Functions creates a PLACE on those coordinates.
	pass

func getPlace(_line, _column):
	#Returns a PLACE when asked. acoording to the position it recieves as arguments.
	pass

func removePlace(_line, _column):
	#Removes and puts NULLPTR on that position of the matrix.
	pass

#Speaking of transitions, i guess they are gonna be put on its own dictionary, in order to better access them.
func createTransition(_id):
	#Creates a transition that connects two PLACES!
	pass

func removeTransition(_id):
	#Should remove the transition with a certain ID
	pass

func getTransition(_id):
	#Should return a certain transition based on its ID.
	pass

func createConnection(_place, _transition, _int_weight, _bool_is_entrance, _bool_is_inhibitor_arc):
	
	pass

func removeConnection(_place, _transition):
	
	pass

func get_place_of_connection(_connection):
	
	pass

func get_transition_of_connection(_connection):
	
	pass

func get_all_entrance_connections(_id):
	#Should return an array() of the connections of entrance from a certain transition
	pass

func get_all_exit_connections(_id):
	#Should return an array() of the connections of exit from a certain transition
	pass

#---------------------------------These functions work as to permit modifications/inspections of the network.

func insert_token_in_place(_token, _place):
	
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
	pass

