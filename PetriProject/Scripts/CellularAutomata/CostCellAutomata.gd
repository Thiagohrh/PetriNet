extends Node

#Lets just set it at 30 30 for now...
var cost_matrix = Array()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func start_cost_matrix():
	#Start a matrix.
	cost_matrix = Array()
	cost_matrix.resize(30)
	
	for i in range(30):
		cost_matrix[i] = Array()
		cost_matrix[i].resize(30)
	
	randomly_populate_matrix()
	for i in range(10):
		smooth_map()
		pass
	return cost_matrix

func randomly_populate_matrix():
	randomize()
	for x in range(cost_matrix.size()):
		for y in range(cost_matrix[0].size()):
			cost_matrix[x][y] = randi() % 4 + 1
	pass

func smooth_map():
	randomize()
	for x in range(cost_matrix.size()):
		for y in range(cost_matrix.size()):
			if GetSurroundingWallCost(x, y) >= 24:
				var random_chance = randi() % 5
				if random_chance == 0:
					cost_matrix[x][y] = 4
				else:
					cost_matrix[x][y] = 3
				pass
			elif GetSurroundingWallCost(x, y) >= 16:
				var random_chance = randi() % 5
				if random_chance == 0:
					cost_matrix[x][y] = 3
				else:
					cost_matrix[x][y] = 2
				pass
			elif GetSurroundingWallCost(x, y) < 16:
				var random_chance = randi() % 5
				if random_chance == 0:
					cost_matrix[x][y] = 2
				else:
					cost_matrix[x][y] = 1
				pass
			pass
	pass



func GetSurroundingWallCost(gridX, gridY):
	#Use this function to check how many walls are around the target tile (coordinates: x and y)
	var wallCost = 0
	#for i in range(2, 5):
	#	print(i)
	for neighbourX in range(gridX - 1, gridX + 2):
		for neighbourY in range(gridY - 1, gridY + 2):
			if neighbourX >= 0 && neighbourX < 30 && neighbourY >= 0 && neighbourY < 30:
				if neighbourX != gridX || neighbourY != gridY:
					#wallCount += map[neighbourX][neighbourY]
					wallCost += cost_matrix[neighbourX][neighbourX]
				pass
			pass
		pass
	
	#This is the end of the function
	return wallCost

func delete_cost_matrix():
	for i in range(cost_matrix.size()):
		cost_matrix[i].clear()
	cost_matrix.clear()