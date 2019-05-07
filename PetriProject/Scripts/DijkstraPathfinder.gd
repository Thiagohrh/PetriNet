extends Node

func find_path(_start_node, _end_node, _matrix, _transition_dict):
	#Creates a path using a line renderer, from the _start_node to the _end_node, by the Dijkstra algorithm.
	var path = dijkstra(_start_node, _end_node, _matrix, _transition_dict)
	#Ok so that works. Now to implement the line renderer between all those nodes up there...
	#create_line(path)
	
	pass

func dijkstra(_start_node, _end_node, _matrix, _transition_dict):
	#Returns an array of nodes that, in order, make a path to the end node.
	#Original code found at:
	#https://www.codingame.com/playgrounds/1608/shortest-paths-with-dijkstras-algorithm/keeping-track-of-paths
	
	#Recieving two nodes, finds a path along the graph made up by the array of all_nodes. Returns an Array() with the path.
	var final_path = Array()
	final_path.clear()
	#A dictionary that's used to keep the shortest path to each KEY
	var shortest_path_to = {}
	shortest_path_to.clear()
	
	var all_nodes = get_avaliable_places_array(_matrix)
	#An array to store the min distances to that final position.
	for i in all_nodes:
		i.set_visited(false)
		i.set_min_distance(99999)
		#Does this work?
		shortest_path_to[i] = Array()
	
	_start_node.set_min_distance(0)
	shortest_path_to[_start_node].append(_start_node)
	
	#print("The shortest path to ", _start_node, " is ", shortest_path_to[_start_node])
	
	var current_node = _start_node
	
	#Loop could probrably start here-----------------------------------------
	var repetition = 0
	
	while repetition <= all_nodes.size() - 1:
		#Should get all possible_neighbours in order to check them...hmmm....how about....
		
		var neighbours = get_possible_neighboors(current_node,_matrix)
		
		#var neighbours = current_node.get_neighbours()
		for j in neighbours:
			if !j.check_visited():
				var weight_from_to = _transition_dict[current_node][j].Weight
				var distance_buffer = current_node.get_min_distance() + weight_from_to
				#print("distance buffer here is...", distance_buffer)
				if distance_buffer < j.get_min_distance():
					j.set_min_distance(distance_buffer)
					shortest_path_to[j].clear()
					#Should iterate trough all of the objects INSIDE this array here...and add them...ok...
					for w in shortest_path_to[current_node]:
						shortest_path_to[j].append(w)
						pass
					shortest_path_to[j].append(j)
					pass
			pass
		current_node.set_visited(true)
		
		#Picking another node, that has not been visited, and has the smallest distance.
		var smallest_distance_so_far = 999999
		var unvisited_smallest_distance = null
		for i in all_nodes:
			if !i.check_visited() and i.get_min_distance() < smallest_distance_so_far:
				smallest_distance_so_far = i.get_min_distance()
				current_node = i
				pass
			pass
		
		
		#Attempt at using a wait function...
		#yield(get_tree(), "idle_frame")
		
		#yield(get_tree().create_timer(0.01), "timeout")
		#print("Chosen node for this repetition is: " , current_node.name)
		repetition += 1
		pass
	
	
	#Lets print all paths to each node shall we?
	#var keys = shortest_path_to.keys()
	#for i in keys:
	#	var values = shortest_path_to[i]
	#	print("The shortest Path to: ", i.name, " is: ")
	#	for j in values:
	#		print(j.name, " then ")
	#		pass
	#	pass
	
	#When its node3 as the destination, it returns an empty array? thats...weird
	
	#for i in all_nodes:
	#	print("Final distances are..." , i.get_min_distance())
	#Finally, to return the array with the positions in order....
	final_path = shortest_path_to[_end_node]
	#print("Is it a problem with path: " , final_path)
	create_line(final_path)
	return final_path

func get_possible_neighboors(_current_node, _matrix):
	#Returns an Array() with all possible neighboors from the current_node being investigated.
	var possible_neighboors = Array()
	var node_position = _current_node.get_pos_identity()
	#gets possible neighbours from that position on the matrix...so....
	if node_position.x - 1 >= 0:
		if _matrix[node_position.x - 1][node_position.y].check_avaliable():#To the left
			possible_neighboors.push_back(_matrix[node_position.x - 1][node_position.y])
	if node_position.x + 1 <= _matrix.size():
		if _matrix[node_position.x + 1][node_position.y].check_avaliable():#Right
			possible_neighboors.push_back(_matrix[node_position.x + 1][node_position.y])
	if node_position.y + 1 <= _matrix[0].size():
		if _matrix[node_position.x][node_position.y + 1].check_avaliable():#Down
			possible_neighboors.push_back(_matrix[node_position.x][node_position.y + 1])
	if node_position.y - 1 >= 0:
		if _matrix[node_position.x][node_position.y - 1].check_avaliable():#Up
			possible_neighboors.push_back(_matrix[node_position.x][node_position.y - 1])
	return possible_neighboors

func get_avaliable_places_array(_matrix):
	#Returns an array with the avaliable nodes ONLY!
	var avaliable_places = Array()
	for x in range(_matrix.size()):
		for y in range(_matrix[0].size()):
			if _matrix[x][y].check_avaliable():
				avaliable_places.push_back(_matrix[x][y])
	return avaliable_places

func create_line(_path):
	#Creates a line renderer as a child node, that uses vertices that have the same position as all the nodes in the _path.
	var new_line =  Line2D.new()
	add_child(new_line)
	new_line.width = 5
	new_line.set_joint_mode(Line2D.LINE_JOINT_ROUND)
	new_line.set_begin_cap_mode(Line2D.LINE_CAP_ROUND)
	new_line.set_end_cap_mode(Line2D.LINE_CAP_ROUND)
	new_line.set_default_color(Color( 0.54, 0.17, 0.89, 1 ))
	
	
	new_line.set_point_position(0, _path.front().global_position)
	_path.pop_front()
	
	while !_path.empty():
		new_line.add_point(_path.front().global_position)
		_path.pop_front()
		pass
	
	
	pass

func delete_paths():
	if get_child_count() > 0:
		for i in get_children():
			i.queue_free()