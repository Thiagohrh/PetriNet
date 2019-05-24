extends Node

onready var cell_automata_node = get_node("CAutomata")
onready var fade_panel = get_node("CanvasLayer/Panel")

var can_move = true

func _process(delta):
	pass


func _ready():
	#Should assemble all of the network in here, as a sequencial instruction. The PetriNetwork will do the rest...
	#Get this and pass it to the PetriNetwork node in order to instantiate the places in the correct grid.
	var map_grid = cell_automata_node.start_map_creation()
	
	$PetriNetwork.connect("game_end", self, "game_ended")
	
	$PetriNetwork.start_board(map_grid)
	pass

#A basic exit strategy
func _input(event):
	if can_move:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
		
		if Input.is_key_pressed(KEY_S):
			$PetriNetwork.stop_PetriNetwork()
		
		if Input.is_action_just_pressed("ui_up"):
			$PetriNetwork.move_player(Vector2(0,-1))
		elif Input.is_action_just_pressed("ui_down"):
			$PetriNetwork.move_player(Vector2(0,1))
		elif Input.is_action_just_pressed("ui_left"):
			$PetriNetwork.move_player(Vector2(-1,0))
		elif Input.is_action_just_pressed("ui_right"):
			$PetriNetwork.move_player(Vector2(1,0))
		elif Input.is_action_just_pressed("ui_accept"):
			restart_game()
		pass

func restart_game():
	#Should redo the whole network, in order to better show diferent possible configurations of the labyrinth.
	fade_panel.fade_in_to_exit()
	yield(fade_panel, "faded")
	$PetriNetwork.detele_board()
	#Should also delete the sprites of the CAutomata....
	$CAutomata.delete_sprites()
	#Then recreate the whole thing...
	var map_grid = cell_automata_node.start_map_creation()
	$PetriNetwork.start_board(map_grid)
	#And make the fade work again in order to bring everything back....
	fade_panel.fade_out_to_game()
	
	if !$BackgroundMusic.is_playing():
		$BackgroundMusic.play()
	pass

func game_ended():
	can_move = false
	$BackgroundMusic.stop()
	$TimeDelayToNextMatch.start()
	yield($TimeDelayToNextMatch,"timeout")
	$GameEnd.play()
	$AnimationPlayer.play("GameWin")
	yield($AnimationPlayer, "animation_finished")
	can_move = true
	restart_game()
	pass