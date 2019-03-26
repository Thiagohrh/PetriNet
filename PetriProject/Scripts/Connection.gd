extends Area2D

var place
var transition
var weight
var is_entrance
var is_inhibitor_arc

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func execute():
	#Should do the transition!
	pass

func set_Place(_place):
	place = _place

func set_Transition(_transition):
	transition = _transition

func set_Weight(_weight):
	weight = _weight

func set_is_entrance_to_transition(_is_it): #Important to note: If this is TRUE: Place -> Transition. FALSE: Transition -> Place
	is_entrance = _is_it

func set_is_inhibitor_arc(_is_it):
	is_inhibitor_arc = _is_it

func get_Place():
	return place

func get_Transition():
	return transition

func get_Weight():
	return weight

func get_is_entrance_to_transition():
	return is_entrance

func get_is_inhibitor_arc():
	return is_inhibitor_arc

func check_if_its_avaliable():
	#Should check all its necessities....lesse.....
	#print("is_entrance? " , is_entrance)
	if is_entrance: #If should go from PLACE to TRANSITION...
		#Check how many tokens the PLACE has...
		#print("Place currently has..." , place.check_token_amount())
		if place.check_token_amount() >= weight: #If the number that the place has is LESS than what this needs...
			return true
		else:
			return false
		pass
	pass