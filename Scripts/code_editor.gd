extends Node2D
var toolkit = ["Reference", "Assign", "Operate", "Compare", "Repeat"]
var mouse_index = -1
var clone = null
var canvas = []
var highlighted_index
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	var mouse_co = get_viewport().get_mouse_position()
	if event is InputEventMouseButton:
		if event.pressed:
			if (mouse_co.x >= 54 and mouse_co.x <= 154) and (mouse_co.y >= 110 and mouse_co.y <= 537) and (int(mouse_co.y) % 100 <= 38 and int(mouse_co.y) % 100 >= 9):
				mouse_index = floor(mouse_co.y / 100) - 1
		else:
			if mouse_index != -1 and (mouse_co.y >= 80 and mouse_co.y <= 650) and (mouse_co.x >= 204 and mouse_co.x <= 584):
				var first_index = 365 - 30 * floor((len(canvas) + 1) / 2) - 15 * ((len(canvas) + 1) % 2)
				if len(canvas) == 0 or mouse_co.y > canvas[len(canvas) - 1].position.y:
					canvas.append(clone.duplicate())
					get_parent().add_child(canvas[len(canvas) - 1])
					canvas[len(canvas) - 1].move_to_front()
				elif mouse_co.y < canvas[0].position.y:
					var temp = []
					for item in canvas:
						temp.append(item)
					canvas.clear()
					canvas.append(clone.duplicate())
					for item in temp:
						canvas.append(item)
					temp.clear()
					get_parent().add_child(canvas[0])
					canvas[0].move_to_front()
				if len(canvas) <= 18:
					for i in range (0, len(canvas)):
						canvas[i].position = Vector2(394, first_index + i * 30)
			if clone != null:
				clone.queue_free()
				clone = null
			mouse_index = -1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_co = get_viewport().get_mouse_position()
	if mouse_index != -1:
		if clone == null:
			clone = get_parent().get_node(toolkit[mouse_index]).duplicate()
			get_parent().add_child(clone)
			clone.move_to_front()
		clone.position = mouse_co
		if len(canvas) > 0 and (mouse_co.y >= 80 and mouse_co.y <= 650) and (mouse_co.x >= 204 and mouse_co.x <= 584):
			if mouse_co.y > canvas[0].position.y and mouse_co.y < canvas[len(canvas) - 1].position.y:
				highlighted_index = floor((mouse_co.y - canvas[0].position.y) / 30)
				print(highlighted_index + 1)
				var temp = []
				for i in range (highlighted_index + 1, len(canvas) - 1):
					temp.append(canvas[i])
					canvas.remove_at(i)
				#canvas.append(get_parent().get_node("Outline").duplicate())
				#get_parent().add_child(canvas[highlighted_index + 1])
				#canvas[highlighted_index + 1].move_to_front()
				#canvas[highlighted_index + 1].visible = true
				#for item in temp:
					#canvas.append(item)
				#temp.clear()
		elif highlighted_index != null:
			canvas[highlighted_index + 1].queue_free()
			canvas.remove_at(highlighted_index + 1)
	#print(mouse_co)
		
