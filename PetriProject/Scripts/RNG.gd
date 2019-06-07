extends Node

var a = 1140671485
var c = 128201163
var m# = 2 % 24

var rand

func _ready():
	randomize()
	rand = randi() % 10 + 1
	m = 2 % 24
	pass

func _process(delta):
	
	pass

func get_random_number():
	#rand = (a * rand + c) % m + 1
	#return rand / m
	#print(rand / m)
	var x = randi() % 10 + 1
	x = x ^ (x << 21)
	x = x ^ (x >> 35)
	x = x ^(x << 4)
	print(x)
	#return x;
	
	
	#For now, get a random number the traditional way.
	#Change this return later on.
	return randi() % 2 + 1