extends Node

#func _ready():
#	pass

func _process(delta):
	randomize()
	pass

func get_random_number():
	
	#For now, get a random number the traditional way.
	#Change this return later on.
	return randi() % 2 + 1