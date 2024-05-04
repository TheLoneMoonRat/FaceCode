extends Node


# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
var ordered_list = []
var variable_storage = []
var variable_object_storage = []
var mouse_index = -1
var clone
var hover = -1
var to_string = ""
var carry = false
func _ready():
	pass
	var list_ints = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	for i in range (0, 10):
		var my_random_number = rng.randi_range(0, len(list_ints) - 1)
		var underlying_number = list_ints[my_random_number]
		get_parent().get_node(str("Block(", underlying_number, ")")).position = Vector2((50 + i * 100), 612)
		list_ints.remove_at(my_random_number)
		ordered_list.append(underlying_number)

func _unhandled_input(event):
	pass
	var mouse_co = get_viewport().get_mouse_position()
	if event is InputEventMouseButton:
		if event.pressed and mouse_co.y >= 576:
			mouse_index = ordered_list[floor((mouse_co.x) / 100)]
			#print("setting to: ", floor((mouse_co.x) / 100))
			to_string = str("array[", floor((mouse_co.x) / 100), "]")
			#print("mouse down")
		elif (event.pressed and mouse_co.x <= len(variable_storage) * 75) and (mouse_co.y >= 115 and mouse_co.y <= 185):
			carry = true
			#print(variable_storage[floor((mouse_co.x) / 75)])
			#print(str(floor((mouse_co.x) / 75), "->", variable_storage[floor((mouse_co.x) / 75)]))
			mouse_index = variable_storage[floor((mouse_co.x) / 75)]
			to_string = str("variable_", floor((mouse_co.x) / 75))
		else:
			#print("mouse up")
			if clone != null:
				clone.queue_free()
				if hover >= 0 and mouse_co.y >= 540:
					var temp = get_parent().get_node(str("Block(", ordered_list[hover], ")"))
					#print("setting: ", hover)
					to_string = str("array[", hover, "]", " = ", to_string)
					#print("reassignment")
					temp.texture = clone.texture
					#print(str("moving value: ", mouse_index, "\nindex: ", hover, "\n ordered_list: ", ordered_list[hover]))
					#ordered_list[hover] = mouse_index
					hover = -1
					get_parent().get_node("terminal_content").text += str(to_string, "\n")
				elif (mouse_co.y <= 200 and (mouse_co.x >= len(variable_storage) * 75 + 50 and mouse_co.x <= 400)) and (len(variable_storage) + 1) <= 5:
					to_string = str("var variable_", len(variable_storage), " = ", to_string)
					var temp = clone.duplicate()
					get_parent().get_node("Stack").add_child(temp)
					temp.position = Vector2(len(variable_storage) * 75 + 50, 150)
					#print(mouse_index)
					variable_storage.append(mouse_index)
					variable_object_storage.append(temp)
					get_parent().get_node("terminal_content").text += str(to_string, "\n")
				elif mouse_co.y <= 200 and mouse_co.x < len(variable_storage) * 75 + 50:
					print("hello")
					var this_index =  floor((mouse_co.x) / 75)
					to_string = str("variable_", this_index, " = ", to_string)
					var this_position = variable_object_storage[this_index].position 
					variable_object_storage[this_index].queue_free()
					variable_object_storage[this_index] = clone.duplicate()
					get_parent().add_child(variable_object_storage[this_index])
					variable_object_storage[this_index].move_to_front()
					variable_object_storage[this_index].position = this_position
					variable_storage[this_index] = mouse_index
					get_parent().get_node("terminal_content").text += str(to_string, "\n")
			carry = false
			to_string = ""
			mouse_index = -1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	var mouse_co = get_viewport().get_mouse_position()
	if mouse_index != -1 and mouse_co.x <= 986:
		if clone == null:
			#print(mouse_index)
			clone = get_parent().get_node(str("Block(", mouse_index, ")")).duplicate()
			if carry:
				clone.texture = get_parent().get_node(str("Block(", mouse_index, ")2")).texture
			get_parent().get_node("Stack").add_child(clone)
		#print(get_viewport().get_mouse_position())
		#print(clone.texture)
		if mouse_co.y > 485:
			#print(mouse_index)
			clone.position.x = floor(mouse_co.x / 100) * 100 + 50
			hover = floor(mouse_co.x / 100)
			clone.position.y = mouse_co.y
		elif mouse_co.y >= 385:
			if int(mouse_co.x) % 100 > 75 or int(mouse_co.x) % 100 < 25: 
				clone.position.x = mouse_co.x
			else:
				clone.position.x = floor(mouse_co.x / 100) * 100 + 50
				hover = floor(mouse_co.x / 100)
		else:
			clone.position = mouse_co
	
	#print(str("Block(", mouse_index, ")"))
	#print(get_viewport().get_mouse_position())
	#print(mouse_index)
	#print(hover)
