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
			if randi() % 2:
				treat_cell_neighboors(x,y);
			pass
	pass

func treat_cell_neighboors(gridX, gridY):
	var cell_cost = cost_matrix[gridX][gridY]
	
	for neighbourX in range(gridX - 1, gridX + 2):
		for neighbourY in range(gridY - 1, gridY + 2):
			if neighbourX >= 0 && neighbourX < 30 && neighbourY >= 0 && neighbourY < 30:
				if neighbourX != gridX || neighbourY != gridY:
					
					if cost_matrix[gridX][gridY] == 1 and randi() % 10 < 1:
						cost_matrix[neighbourX][neighbourY] = 1
						pass
					elif cost_matrix[gridX][gridY] == 4 and randi() % 20 < 1:
						cost_matrix[neighbourX][neighbourY] = 4
						pass
					
					if cell_cost == 4 and cost_matrix[neighbourX][neighbourY] < 3:
						cost_matrix[neighbourX][neighbourY] = 3
						pass
					elif cell_cost == 3 and cost_matrix[neighbourX][neighbourY] < 2:
						cost_matrix[neighbourX][neighbourY] = 2
						pass
					elif cell_cost == 2 and cost_matrix[neighbourX][neighbourY] > 3:
						cost_matrix[neighbourX][neighbourY] = 3
						pass
					elif cell_cost == 1 and cost_matrix[neighbourX][neighbourY] > 2:
						cost_matrix[neighbourX][neighbourY] = 2
						pass
					
					
					#wallCost += cost_matrix[neighbourX][neighbourX]
					pass
				pass
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