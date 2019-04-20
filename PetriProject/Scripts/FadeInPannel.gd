extends Panel

func _ready():
	$Tween.interpolate_property(self,"modulate",modulate,Color(1,1,1,0),2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT,0)
	$Tween.start()
	pass

func _on_Tween_tween_completed(object, key):
	queue_free()
	pass # replace with function body
