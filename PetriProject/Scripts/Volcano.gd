extends "res://Scripts/Token.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var rock_particles = get_node("LavaRocks")

func _ready():
	add_to_group("volcano")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func start_volcano():
	$LavaRocks.emitting = true
	$TimeToDie.start()
	pass

func _on_TimeToDie_timeout():
	$ColorTween.interpolate_property(self, "modulate", modulate, Color(1,1,1,0),1,Tween.TRANS_LINEAR,Tween.EASE_OUT,0)
	$ColorTween.start()
	yield($ColorTween, "tween_completed")
	queue_free()
	pass # replace with function body
