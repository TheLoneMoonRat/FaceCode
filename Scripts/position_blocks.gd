extends Node


# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
var ordered_list = []
var mouse_index = -1
var clone
var hover = -1
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
	if event is InputEventMouseButton:
		if event.pressed and get_viewport().get_mouse_position().y >= 576:
			mouse_index = floor((get_viewport().get_mouse_position().x) / 100)
			print("mouse down")
		else:
			print("mouse up")
			mouse_index = -1
			if clone != null:
				clone.queue_free()
				if hover >= 0 and get_viewport().get_mouse_position().y >= 540:
					var temp = get_parent().get_node(str("Block(", hover, ")"))
					#String thing = clone.texture
					temp.texture = clone.texture
					hover = -1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if mouse_index != -1:
		if clone == null:
			clone = get_parent().get_node(str("Block(", ordered_list[mouse_index], ")")).duplicate()
			get_parent().get_node("Stack").add_child(clone)
		#print(get_viewport().get_mouse_position())
		var mouse_co = get_viewport().get_mouse_position()
		if mouse_co.y > 485:
			clone.position.y = mouse_co.y
		else:
			if int(mouse_co.x) % 100 > 75 or int(mouse_co.x) % 100 < 25: 
				clone.position.x = mouse_co.x
			else:
				clone.position.x = floor(mouse_co.x / 100) * 100 + 50
				hover = ordered_list[floor(mouse_co.x / 100)]
