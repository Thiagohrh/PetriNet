extends Node2D

#Should have some prefabs here...
export (PackedScene) var Token
export (PackedScene) var Flag
export (PackedScene) var Npc
export (PackedScene) var Player
export (PackedScene) var Item
export (PackedScene) var Place
export (PackedScene) var Transition
export (PackedScene) var Connection
export (PackedScene) var Enemy
#Should have some prefabs here...

const CELL_HEIGHT = 16
const CELL_WIDTH = 16

var matrix
var lines = 3
var columns = 3

var cicle_time = 1

var main_character = null
#Remember the difference!
#--PLACES--TRANSITIONS--CONNECTIONS
#PLACES: Hold tokens. Passive like that.
#TRANSITIONS: Always in between the places. Serves as a checkpoint for the connections to work with.
#CONNECTIONS: Kindda guide the whole network. In a "pulse", it will check all connections in order to see if 
#There are avaliable transitions to be made (Enough tokens, respecting the transitions and whatnot.) 

#New rule. Fuck that noise. Lets simplify it using dictionaries.

var ConnectionsDir = {} #A dictionary, made to hold all the info about transitions.

func _ready():
	pass

func start_board(_map_grid):
	lines = _map_grid.size()
	columns = _map_grid[0].size()
	
	matrix = Array()
	matrix.resize(columns)
	
	for i in range(columns):
		matrix[i] = Array()
		matrix[i].resize(lines)
		
	#Now after creating the matrix...to populate it...
	for x in range(matrix.size()):
		for y in range(matrix[0].size()):
			var new_place = Place.instance()
			new_place.set_identity(x,y)
			matrix[x][y] = new_place
			$Places.add_child(new_place)
			#Also should put it into its correct place...and set it to be accessible or not.
			new_place.global_position.x = 0 + x * CELL_WIDTH
			new_place.global_position.y = 0 + y * CELL_HEIGHT
			if _map_grid[x][y] == 1:
				matrix[x][y].set_avaliable(false)
	
	#Now i should create the transitions between all of those places...hmmm...
	#The theory is to just create transitions of ENTERING another place...so...hmmm....
	for x in range(matrix.size()):
		for y in range(matrix[0].size()):
			var pos_to_connect = {}
			pos_to_connect.Right = x + 1
			pos_to_connect.Left = x - 1
			pos_to_connect.Up = y - 1
			pos_to_connect.Down = y + 1
			
			
			#This connects to 8 possible places around. Change it to only 4 later, as seen above.
			for neighbourX in range(x - 1, x + 2):
				for neighbourY in range(y - 1, y + 2):
					if neighbourX >= 0 && neighbourX < matrix.size() && neighbourY >= 0 && neighbourY < matrix[0].size():
						if neighbourX != x || neighbourY != y:
							create_transition_from_to(matrix[x][y], matrix[neighbourX][neighbourY])
							pass
			
			pass
	
	set_player_on_board()
	set_enemies_on_board(2)
	set_itens_on_board(2)
	#And to test how to access it.... lets do....
	print("The Amount of connections from Place 1 X 1 is...: ", ConnectionsDir[matrix[1][1]].size())
	#print("The Weight of the transition between 0 X 0 and  1 X 0 is: ", ConnectionsDir[matrix[0][0]][matrix[1][0]].Weight)
	pass

func set_itens_on_board(_item_amount):
	#Sets the number of itens anywhere on the board.
	print("SETTING THE ITEM ON PLACE")
	for i in range(_item_amount):
		
		randomize()
		var x = randi() % matrix.size()
		var y = randi() % matrix[0].size()
		
		var chosen_place = matrix[x][y]
		#A safety check just so it doesnt spawn at an unavaliable place
		if !chosen_place.check_avaliable():
			while !chosen_place.check_avaliable():
				x = randi() % matrix.size()
				y = randi() % matrix[0].size()
				chosen_place = matrix[x][y]
				pass
			pass
		print("Item spawn at position X: " , x, " Y: " , y)
		var new_item = Item.instance()
		$Itens.add_child(new_item)
		
		chosen_place.add_token(new_item)
		
		pass
	pass

func detele_board():
	#First delete enemies...
	for i in $Enemies.get_children():
		i.queue_free()
		pass
	#Second, delete the player....
	for i in $Players.get_children():
		i.queue_free()
	
	#Third delete all the places....
	for x in range(matrix.size()):
		for y in range(matrix[0].size()):
			matrix[x][y].queue_free()
			pass
	
	#Delete all the references as to start anew...
	ConnectionsDir = {}
	pass

func create_transition_from_to(_from, _to):
	#First calculate all the data thats needed to add to this particular connection.
	var data = {
		"Weight" : 1,
		"Inhibitor" : false,
		"Start" : _from,
		"End" : _to,
		"Enabled" : _to.check_avaliable()
	}
	
	if !ConnectionsDir.has(_from):
		ConnectionsDir[_from] = {}
	
	ConnectionsDir[_from][_to] = data
	#-------------Fuck all this noise below. Start above and delete the rest.-----------------------------
	#First, create a transition....
	#var new_transition = createTransition(null)
	
	#Second, create a CONNECTION, from the PLACE to the TRANSITION.
	#createConnection(_from, new_transition ,1 , true, false)
	#Third, create a CONNECTION from the TRANSITION to the PLACE
	#createConnection(_to, new_transition, 1, false, false)
	
	#Maybe should add to the transition its DESTINATION, as to better check where it leads to....
	
	pass

func set_player_on_board():
	#Set one instance of the player on the board. Also keeps a reference to it in order know its location. Easier to ask from him.
	main_character = Player.instance()
	$Players.add_child(main_character)
	
	#In order to figure out where it should be....
	var target_place = get_first_avaliable_position()
	
	target_place.add_token(main_character)
	#main_character.set_position_on_grid()
	pass

func get_first_avaliable_position():
	for x in range(matrix.size()):
		for y in range(matrix[0].size()):
			if matrix[x][y].check_avaliable():
				return matrix[x][y]
			pass
	
	return null

func move_player(_direction):
	print("Direction is: ", _direction)
	#First, get the player actual position...
	
	var current_position = main_character.get_position_on_grid()
	var desired_position = main_character.get_position_on_grid() + _direction
	
	print("The player is in position: ",current_position, " and wants to go to position: " , desired_position)
	
	#Ok, so far so good...now....in order to check that particular transition....
	if ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]].Enabled:
		print("Checked and....its avaliable!")
		#Ok, so i know its avaliable...hmmm...
		var connection_info = ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]]
		if connection_info.End.check_token_amount() == 0:
			var current_token = connection_info.Start.get_token_from_this_place()
			connection_info.End.add_token(current_token)
		pass
	
	move_enemies()
	pass

func set_enemies_on_board(_amount):
	for i in range(_amount):
		#Should grab a random position on the board...that position should be avaliable, and shouldnt have any tokens on it.
		randomize()
		var x = randi() % matrix.size()
		var y = randi() % matrix[0].size()
		print("Would spawn at position X: " , x, " Y: " , y)
		var chosen_place = matrix[x][y]
		#A safety check just so it doesnt spawn at an unavaliable place
		if !chosen_place.check_avaliable():
			while !chosen_place.check_avaliable():
				x = randi() % matrix.size()
				y = randi() % matrix[0].size()
				chosen_place = matrix[x][y]
				pass
			pass
		
		var new_enemy = Enemy.instance()
		$Enemies.add_child(new_enemy)
		
		chosen_place.add_token(new_enemy)
		pass
	pass

func move_enemies():
	var all_enemies = $Enemies.get_children()
	for i in all_enemies:
		var current_position = i.get_position_on_grid()
		var desired_position = i.get_position_on_grid() + i.get_new_direction_intent()
		
		print("The Enemy is in position: ",current_position, " and wants to go to position: " , desired_position)
		
		#Ok, so far so good...now....in order to check that particular transition....
		if ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]].Enabled:
			print("Checked and....its avaliable!")
			#Ok, so i know its avaliable...hmmm...
			
			var connection_info = ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]]
			if connection_info.End.check_token_amount() == 0:
				var current_token = connection_info.Start.get_token_from_this_place()
				connection_info.End.add_token(current_token)
			
		pass
	pass

func start_matrix_size(_lines, _columns):
	
	lines = _lines
	columns = _columns
	
	matrix = []
	
	for x in range(lines):
		var col = []
		col.resize(columns)
		matrix.append(col)
		pass
	
	print("Matrix of the game has been started\nLines: " , _lines, "\nColumns: " , _columns)
	
	#Populate it like so...
	#matrix[0][0] = 4
	#print(matrix[0][0])
	pass

#------All these functions work as to permit creating and editing of the network.
func createPlace(_line, _column):
	#Functions creates a PLACE on those coordinates.
	#This is the place where it should create stuff...ok...
	var newPlace = Place.instance()
	matrix[_line][_column] = newPlace
	$Places.add_child(newPlace)
	print("A new place has been created at location : ", _line , " X ", _column)
	#Should add a better positioning system at a later date.
	pass

func getPlace(_line, _column):#Returns a PLACE when asked. acoording to the position it recieves as arguments.
	return matrix[_line][_column]

func removePlace(_line, _column):#Removes and puts NULLPTR on that position of the matrix.
	matrix[_line][_column] = null

#Speaking of transitions, i guess they are gonna be put on its own dictionary, in order to better access them.
func createTransition(_id):
	#Creates a transition that connects two PLACES!
	var new_id = _id
	var newTransition = Transition.instance()
	$Transitions.add_child(newTransition)
	#Still no idea on the logics behind the IDS....maybe it WOULD be easier to just add them to a dictionary. Hmmm...how about....
	if _id == null:#If for some reason a manual ID wasnt put...
		newTransition.set_id($Transitions.get_child_count() - 1)
		new_id = $Transitions.get_child_count() - 1
	else:
		newTransition.set_id(_id)
	
	print("A new transition has been created. Its current ID is: " , new_id)
	return newTransition

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
	print("Created a connection between place: " , _place.name, " and transition: " , _transition.name)
	print("Its weight is: " , _int_weight)
	
	if _bool_is_entrance:
		print("Its a connection from a transition to place!")
	else:
		print("Its a connection from a place to transition!")
	
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

func insert_token_in_place(_line, _column):
	
	if matrix[_line][_column] != null:
		var new_token = Token.instance()
		$Tokens.add_child(new_token)
		matrix[_line][_column].add_token(new_token)
	else:
		print("Trying to add a token in an empty cell")
	
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
	#Goes through out all the network identifying all TRANSITIONS that are active, and executing them.
	for i in $Transitions.get_children():
		#Use a method from each transition! if its avaliable, EXECUTE IT!
		if i.check_avaliability():
			print("Connection " , i.name, " is avaliable!")
			i.execute_transition()
			pass
		pass
	#The movement of Tokens and signal of each transition could
	#mean the calling of methods of call back so it can be seen on screen.
	
	#This is what SHOULD be working by the time you make the delivery.
	print("----------------------CICLE!----------------------")
	pass

func _on_StepTimer_timeout():
	#Use this function to call execute_cicle! That way, the steps are separated in chunks of time.
	execute_cicle()
	pass # replace with function body

#I have a feeling i will need these...
func start_PetriNetwork():
	$StepTimer.start()
	print("PetriNetwork has been STARTED")
func stop_PetriNetwork():
	$StepTimer.stop()
	print("PetriNetwork has been STOPPED")