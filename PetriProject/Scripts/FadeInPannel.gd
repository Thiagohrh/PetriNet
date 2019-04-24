extends Panel

export var fade_out_to_game = true

signal faded()

func _ready():
	if fade_out_to_game:
		$Tween.interpolate_property(self,"modulate",modulate,Color(1,1,1,0),2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0)
		$Tween.start()
	pass

func _on_Tween_tween_completed(object, key):
	#queue_free()
	emit_signal("faded")
	pass # replace with function body

func fade_in_to_exit():
	$Tween.interpolate_property(self,"modulate",modulate,Color(0,0,0,1),0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0)
	$Tween.start()

func fade_out_to_game():
	$Tween.interpolate_property(self,"modulate",modulate,Color(1,1,1,0),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0)
	$Tween.start()
	pass