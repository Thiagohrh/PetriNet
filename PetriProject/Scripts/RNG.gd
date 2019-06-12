extends Node

var a = 48271
var c = 0
var m = 2147483647

var rand

var blocker = true
var x
var last_x

func _ready():
	#randomize()
	rand = randi() % 10 + 1
	#m = 2 % 24
	pass

func _process(delta):
	
	pass

func get_normal(_average, _standard_deviation):
	
	var W = 1
	var U1
	var U2
	var V1
	var V2
	
	while W >= 1:
		U1 = get_random_number()
		U2 = get_random_number()
		V1 = 2* U1 - 1
		V2 = 2* U2 - 1
		W  = V1 * V1 + V2 * V2
	
	var Y = sqrt((-2 * log(W)) / W)
	
	var X = V1 * Y
	
	return _average + _standard_deviation * X

func get_uniform(_min, _max):
	var result = _min + (_max - _min) * get_random_number()
	return result

func get_random_number():
	if blocker:
		randomize()
		last_x = randi()
		blocker = false
	last_x = (last_x * a + c) % m
	var buffer = float(last_x) / (float(m) - 1)
	
	return float(last_x) / (float(m) - 1)

func exponential_value(_average):
	var U = - _average * log(1 - get_random_number())
	return U