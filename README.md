# PetriNet
A Basic petri network implementation.

Made using Godot 3.0.5. 

A Petri Network implementation on a game setting.

Arrow Keys move the character. If you move, you also send a signal for the enemies to move randomly as well. Press Enter to check diferent levels.

Volcanoes spawn randomly, and cause the map layout to change.

Press M to apply a Retro CRT Shader!

You can move the viewport with the middle mouse button, and get a close up using the mouse wheel scroll. Maximize it for true throwback feels.

Press enter in order to remake the dungeon positioning. It serves as a reboot of the network.

The transitions dictionary is always used to check if the connection between places is avaliable, as well as to check that the place isnt occupied.

Techniques employed:
-Flood Fill Algorithm
-Petri Network
-Cellular Automata