extends Node2D

export(int) var width
export(int) var height
export(PackedScene) var wallSprite

var spriteDimentions = 16
var string_seed

var bool_use_random_seed

export(int, 100) var randomFillPercent

var map = Array()

func _ready():
	pass

func start_map_creation():
	map.resize(width)
	for i in range(map.size()):
		var new_array = Array()
		new_array.resize(height)
		map[i] = new_array
		pass
	
	#Test to see if it can access any position through expressions like:
	#map[2][3] or whatever.... that will make things easier.
	GenerateMap()
	
	#Checks if the map has been created correctly, using the flood fill algorithm.
	flood_fill_check()
	if flood_fill_check():
		#print("Flood fill say its ok!")
		pass
	else:
		#print("Flood fill say its NOT OKAY! Time to redo the map...")
		while !flood_fill_check():
			GenerateMap()
			pass
	#In order to actually spawn the map....
	SpawnSprites()
	
	return map

func GenerateMap():
	#Use this function in order to start the map
	if map != null:
		for i in map:
			i.clear()
			i = null
		map.clear()
		
		map = Array()
		map.resize(width)
		for i in range(map.size()):
			var new_array = Array()
			new_array.resize(height)
			map[i] = new_array
		pass
	
	#First part of the magic
	RandomFillMap()
	#Second part of the magic. This should have a variable state in order to control how many times it will apply the cicle.
	for i in range(10):
		SmoothMap()
		pass
	pass

func RandomFillMap():
	#Use this function in order to start all the map with random positions everywhere.
	randomize()
	
	for x in range(width):
		for y in range(height):
			if x == 0 || x == width-1 || y == 0 || y == height -1:
				map[x][y] = 1;
				pass
			else:
				var random_number = randi() % 100
				if random_number < randomFillPercent:
					map[x][y] = 1
				else:
					map[x][y] = 0
				pass
			pass
		pass
	
	
	
	#This is the end of the function...
	pass

func SmoothMap():
	#Use this to apply the rules of smoothing, acoording to the MapOfLive Algorithm seen in:
	#https://unity3d.com/pt/learn/tutorials/projects/procedural-cave-generation-tutorial/cellular-automata
	for x in range(width):
		for y in range(height):
			var neighbourWallTiles = GetSurroundingWallCount(x,y)
			
			if neighbourWallTiles > 4:
				map[x][y] = 1
				pass
			elif neighbourWallTiles < 4:
				map[x][y] = 0
			
			pass
		pass
	
	
	#This is the end of the function!
	pass

func GetSurroundingWallCount(gridX, gridY):
	#Use this function to check how many walls are around the target tile (coordinates: x and y)
	var wallCount = 0
	#for i in range(2, 5):
	#	print(i)
	
	for neighbourX in range(gridX - 1, gridX + 2):
		for neighbourY in range(gridY - 1, gridY + 2):
			if neighbourX >= 0 && neighbourX < width && neighbourY >= 0 && neighbourY < height:
				if neighbourX != gridX || neighbourY != gridY:
					wallCount += map[neighbourX][neighbourY]
				pass
			else:
				wallCount += 1
				pass
			pass
		pass
	
	#This is the end of the function
	return wallCount

#Needs a function to draw the whole shebang, like a OnDrawGizmos on unity, but instead it should spawn the map.
func SpawnSprites():
	for x in range(width):
		for y in range(height):
			
			if map[x][y] == 1:
				#If there is supposed to be a wall here.....hmmm...
				var new_sprite = wallSprite.instance()
				$VisualMapHolder.add_child(new_sprite)
				
				new_sprite.global_position.x = 0 + x * 16
				new_sprite.global_position.y = 0 + y * 16
				pass
			pass
		pass
	pass

func delete_sprites():
	for i in $VisualMapHolder.get_children():
		i.queue_free()

func get_map():
	return map

func flood_fill_check():
	#Applies the flood fill algorithm in order to check if every walkable cell is acessible from a starting position.
	#Remember: 1 is a wall, 0 is walkable cell.
	
	#First, get the first cell to the left to start with....
	var start_pos = get_first_avaliable_position()
	#Now create a dictionary that checks if a particular cell has been checked already or not.
	var visited_dict = {}
	#Check how many walkable tiles are there.
	var walkable_tiles_amount = 0
	for x in range(width):
		for y in range(height):
			#Go through all the cells and put a false flag on all of them...
			visited_dict[Vector2(x,y)] = false
			if map[x][y] == 0:
				walkable_tiles_amount += 1
	
	#Create a list that keeps track of possible cells to check...
	var cells_to_check = Array()
	
	#Adds to the end of that list the start_pos, so that it can start the chain reaction.
	cells_to_check.push_back(start_pos)
	
	#Start the check loop.
	while !cells_to_check.empty():
		#Gets the first one.
		var cell_coord = cells_to_check.front()
		#If it is a walkable tile, and i havent checked it yet...
		if map[cell_coord.x][cell_coord.y] == 0 and visited_dict[cell_coord] == false:
			#Checks it as already investigated.
			visited_dict[cell_coord] = true
			
			#Gets all possible neighbours directly in its side and add it to the list
			#Gets above neighborhood
			if map[cell_coord.x][cell_coord.y - 1] == 0 and visited_dict[Vector2(cell_coord.x, cell_coord.y - 1)] == false:
				cells_to_check.push_back(Vector2(cell_coord.x, cell_coord.y - 1))
				pass
			#Gets below neighborhood
			if map[cell_coord.x][cell_coord.y + 1] == 0 and visited_dict[Vector2(cell_coord.x, cell_coord.y + 1)] == false:
				cells_to_check.push_back(Vector2(cell_coord.x, cell_coord.y + 1))
				pass
			
			#Gets right neighborhood
			if map[cell_coord.x + 1][cell_coord.y] == 0 and visited_dict[Vector2(cell_coord.x + 1, cell_coord.y)] == false:
				cells_to_check.push_back(Vector2(cell_coord.x + 1, cell_coord.y))
				pass
			
			#Gets left neighborhood
			if map[cell_coord.x - 1][cell_coord.y] == 0 and visited_dict[Vector2(cell_coord.x - 1, cell_coord.y)] == false:
				cells_to_check.push_back(Vector2(cell_coord.x - 1, cell_coord.y))
				pass
			
			#After getting all the possible neighbors...its done.
			pass
		
		#Done everything it has to do with this cell...so lets pop the front vector and proceed to the next.
		cells_to_check.pop_front()
		#And proceed with the while untill all possible cells have been walked and marked as visited.
		pass
	
	var visited_amount = 0
	#Having checked all that, count how many cells i've visited....
	for coord in visited_dict:
		if visited_dict[coord] == true:
			visited_amount += 1
			pass
	
	#After all that, makes the final check...
	if visited_amount == walkable_tiles_amount:
		return true
	else:
		return false

func get_first_avaliable_position():
	for x in range(map.size()):
		for y in range(map[0].size()):
			if map[x][y] == 0:
				return Vector2(x,y)
			pass
	
	return null