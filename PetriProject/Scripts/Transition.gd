extends Node2D

var token_list = Array()

var id = null

var connInList = Array()
var connOutList = Array()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func set_id(_id):
	id = _id

func get_id():
	return id

func add_connection_to_list(_connection):
	#Checks if the connection is of entrance or exit. Adds it to an Array() to better control where it is.
	if _connection.get_is_entrance_to_transition():
		#Ok...if it IS and entrance to THIS transition...
		connInList.push_back(_connection)
		pass
	else:
		connOutList.push_back(_connection)
		pass
	pass

func get_connection_entrances():
	return connInList

func get_connection_exits():
	return connOutList

func check_token_amount():
	return token_list.size()

func check_avaliability():
	#Checks to see if it has the same tokens among the CONNINLIST and CONNOUTLIST! If both weights of those connections are
	#avaliable, then a transition CAN occur. This function returns a bool in order to check that.
	if connInList.size() > 0 and connOutList.size() > 0:
		var amount_of_tokens_entering = 0
		var amount_of_tokens_exiting = 0
		
		var n_connections_IN_avaliable = 0
		var n_connections_OUT_avaliable = 0
		
		#Check how much can i get from the entering connections...
		for i in connInList:
			if i.check_if_its_avaliable():
				print("THERE IS A CONN IN AVALIABLE")
				amount_of_tokens_entering += i.get_Weight()
				n_connections_IN_avaliable += 1
				pass
			else:
				print("1 Connection not avaliable...")
			pass
		
		#Checks how much i should pass along for the exiting connections...
		for i in connOutList:
			if i.check_if_its_avaliable():
				amount_of_tokens_exiting += i.get_Weight()
				n_connections_OUT_avaliable += 1
			pass
		
		print("connInList.size(): " , connInList.size())
		print("connOutList.size(): " , connInList.size())
		print("Amount entering: " , amount_of_tokens_entering)
		print("Amount exiting: " , amount_of_tokens_exiting)
		#If I have more tokens avaliable than tokens that i need to output, and all my connections
		# IN are avaliable..then this transition is avaliable!
		if n_connections_IN_avaliable > 0 and n_connections_OUT_avaliable > 0:
			return true
		else:
			return false
	else:
		return false

func execute_transition():
	if check_avaliability():#If for some reason you didnt check this transition before...
		print("Executing a transition...!")
		#A basic holder in order to save the references needed to pass forward stuff...
		var place
		var weight
		
		var tokens_to_transfer = Array()
		for i in connInList:
			#At this point, all the connections are possible. So just take tokens from the places they point to.
			#Also, take as many tokens as to match the Weight from that connection.
			place = i.get_Place()
			weight = i.get_Weight()
			
			for j in range(weight):
				tokens_to_transfer.push_back(place.get_token_from_this_place())
				pass
			pass
		
		#Ok so I've gotten all tokens from all the connections...time to distribuite them.
		
		for i in connOutList:
			place = i.get_Place()
			weight = i.get_Weight()
			
			for j in range(weight):
				place.add_token(tokens_to_transfer.front())
				tokens_to_transfer.pop_front()
				#tokens_to_transfer.push_back(place.get_token_from_this_place())
				pass
			pass
		pass
	pass