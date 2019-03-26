extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	#Should assemble all of the network in here, as a sequencial instruction. The PetriNetwork will do the rest...
	print("--------------------EXECUTING PROGRAM----------------------")
	#Starting the world matrix, with a grid of 3X3
	$PetriNetwork.start_matrix_size(3,3)
	#Create a place in location 0, 0
	$PetriNetwork.createPlace(0, 0)
	#Create a second place in location 0,1
	$PetriNetwork.createPlace(0, 1)
	
	#Create a TRANSITION between those two places!
	$PetriNetwork.createTransition(0)
	
	#Create a CONNECTION that should bridge the first PLACE to the first TRANSITION
	$PetriNetwork.createConnection($PetriNetwork.getPlace(0, 0),$PetriNetwork.getTransition(0),1,true,false)
	#Create another CONNECTION, that should bridge the first TRANSITION to the second PLACE
	$PetriNetwork.createConnection($PetriNetwork.getPlace(0, 1),$PetriNetwork.getTransition(0),1,false,false)
	
	#Put a single token on the first transition in order to test the petriNetwork...
	$PetriNetwork.insert_token_in_place(0,0)
	
	print("---------------------SETUP DONE--------------------------")
	print("------------------STARTING NETWORK!--------------------------")
	#Start the timer with this, and see what happens...
	$PetriNetwork.start_PetriNetwork()
	pass

#A basic exit strategy
func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if Input.is_key_pressed(KEY_S):
		$PetriNetwork.stop_PetriNetwork()
	