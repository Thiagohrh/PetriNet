extends Node2D

#Should have some prefabs here...
export (PackedScene) var Token
export (PackedScene) var Flag
export (PackedScene) var Player
export (PackedScene) var Item
export (PackedScene) var Place
export (PackedScene) var Enemy
#Should have some prefabs here...

const CELL_HEIGHT = 16
const CELL_WIDTH = 16

var matrix
var lines = 3
var columns = 3

var cicle_time = 1

var main_character = null

signal game_end()
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
			else:
				matrix[x][y].set_weight(randi() % 4 + 1)
	
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
	
	#Just to show the first paths to the items...
	var player_coordinates = main_character.get_position_on_grid()
	
	#$DijkstraPathfinder.delete_paths()
	
	for i in $Itens.get_children():
		#$DijkstraPathfinder.find_path(matrix[player_coordinates.x][player_coordinates.y], i.get_place_holding_this(), matrix, ConnectionsDir)
		pass
	
	#And to test how to access it.... lets do....
	#print("The Amount of connections from Place 1 X 1 is...: ", ConnectionsDir[matrix[1][1]].size())
	#print("The Weight of the transition between 0 X 0 and  1 X 0 is: ", ConnectionsDir[matrix[0][0]][matrix[1][0]].Weight)
	pass

func set_itens_on_board(_item_amount):
	#Sets the number of itens anywhere on the board.
	#print("SETTING THE ITEM ON PLACE")
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
		#print("Item spawn at position X: " , x, " Y: " , y)
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
	
	#Delete the items...
	for i in $Itens.get_children():
		i.queue_free()
	
	#Third delete all the places....
	for x in range(matrix.size()):
		for y in range(matrix[0].size()):
			matrix[x][y].queue_free()
			pass
	
	#Delete all the references as to start anew...
	ConnectionsDir = {}
	
	#Delete any paths existing...
	$DijkstraPathfinder.delete_paths()
	pass

func create_transition_from_to(_from, _to):
	#First calculate all the data thats needed to add to this particular connection.
	randomize()
	var data = {
		"Weight" : _to.get_weight(),
		"Inhibitor" : false,
		"Start" : _from,
		"End" : _to,
		"Enabled" : _to.check_avaliable()
	}
	
	if !ConnectionsDir.has(_from):
		ConnectionsDir[_from] = {}
	
	ConnectionsDir[_from][_to] = data
	
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
	#print("Direction is: ", _direction)
	#First, get the player actual position...
	
	var current_position = main_character.get_position_on_grid()
	var desired_position = main_character.get_position_on_grid() + _direction
	
	#print("The player is in position: ",current_position, " and wants to go to position: " , desired_position)
	
	#Ok, so far so good...now....in order to check that particular transition....
	if ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]].Enabled:
		#print("Checked and....its avaliable!")
		#Ok, so i know its avaliable...hmmm...
		var connection_info = ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]]
		if connection_info.End.check_token_amount() == 0:
			var current_token = connection_info.Start.get_token_from_this_place()
			connection_info.End.add_token(current_token)
			#Apply Dijkstra in order to pathfind....
			$DijkstraPathfinder.delete_paths()
			for i in $Itens.get_children():
				if !i.get_gotten():
					$DijkstraPathfinder.find_path(matrix[desired_position.x][desired_position.y], i.get_place_holding_this(), matrix, ConnectionsDir)
		elif connection_info.End.check_token_amount() == 1:
			#If there is SOMETHING there...Needs to check if that is an ITEM or not.
			var possible_item = connection_info.End.get_token(0)
			if possible_item.is_in_group("item"):
				#If its an item, remove the item from the place in order to empty it up
				connection_info.End.get_token_from_this_place()
				#Sets the Item as GOTTEN, in order to trigger a change in sprites and just keeps it into its place.
				possible_item.set_gotten(true)
				check_for_game_end()
				pass
			pass
		pass
	
	move_enemies()
	pass

func check_for_game_end():
	var game_end = false
	var itens_gotten = 0
	for i in $Itens.get_children():
		if i.get_gotten():
			game_end = true
			itens_gotten = itens_gotten + 1
	
	if game_end and itens_gotten == $Itens.get_child_count():
		#Should emit a signal that warns the World that the game is over.
		emit_signal("game_end")
		pass
	pass


func set_enemies_on_board(_amount):
	for i in range(_amount):
		#Should grab a random position on the board...that position should be avaliable, and shouldnt have any tokens on it.
		randomize()
		var x = randi() % matrix.size()
		var y = randi() % matrix[0].size()
		#print("Would spawn at position X: " , x, " Y: " , y)
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
		
		#print("The Enemy is in position: ",current_position, " and wants to go to position: " , desired_position)
		
		#Ok, so far so good...now....in order to check that particular transition....
		if ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]].Enabled:
			#print("Checked and....its avaliable!")
			#Ok, so i know its avaliable...hmmm...
			
			var connection_info = ConnectionsDir[matrix[current_position.x][current_position.y]][matrix[desired_position.x][desired_position.y]]
			if connection_info.End.check_token_amount() == 0:
				var current_token = connection_info.Start.get_token_from_this_place()
				connection_info.End.add_token(current_token)
			
		pass
	pass
