extends Node

onready var camera = get_parent()
var time = 0
const duration = 0.50
const magnitude = 3

var shaking = false

func shake():
	if shaking:
		return
	else:
		shaking = true
	var initial_offset = camera.get_offset()
	while time < duration:
		time += get_process_delta_time()
		time = min(time, duration)
		
		var offset = Vector2()
		offset.x = rand_range(-magnitude, magnitude)
		offset.y = rand_range(-magnitude, magnitude)
		camera.set_offset(initial_offset + offset)
		
		yield(get_tree(), "idle_frame")
		pass
	
	time = 0
	camera.set_offset(initial_offset)
	shaking = false
	pass