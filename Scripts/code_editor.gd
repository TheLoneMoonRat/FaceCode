extends Node2D
var toolkit = ["Reference", "Assign", "Operate", "Compare", "Repeat"]
var mouse_index = -1
var clone = null
var canvas = []
var highlighted_index
var highlighting = false
var outliner
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
				else:
					var temp = []
					var index = len(canvas)
					for i in range (highlighted_index, index):
						temp.append(canvas[highlighted_index])
						canvas.remove_at(highlighted_index)
					canvas.append(clone.duplicate())
					get_parent().add_child(canvas[highlighted_index])
					canvas[highlighted_index].move_to_front()
					for item in temp:
						canvas.append(item)
					temp.clear()
				if len(canvas) <= 18:
					for i in range (0, len(canvas)):
						if not outliner:
							canvas[i].position = Vector2(394, first_index + i * 30)
						elif i == highlighted_index or canvas[i].position.x == 435:
							canvas[i].position = Vector2(435, first_index + i * 30)
			if clone != null:
				clone.queue_free()
				clone = null
			if outliner != null:
				outliner.queue_free()
				outliner = null
			mouse_index = -1
			highlighted_index = -1
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
				highlighted_index = floor((mouse_co.y - canvas[0].position.y) / 30) + 1
				var first_index = 365 - 30 * floor((len(canvas) + 1) / 2) - 15 * ((len(canvas) + 1) % 2)
				for i in range (0, len(canvas)):
					if i < highlighted_index:
						if canvas[i].position.x != 435:
							canvas[i].position = Vector2(394, first_index + i * 30)
						else:
							canvas[i].position = Vector2(435, first_index + i * 30)
					else:
						if canvas[i].position.x != 435:
							canvas[i].position = Vector2(394, first_index + i * 30 + 30)
						else:
							canvas[i].position = Vector2(435, first_index + i * 30 + 30)
				if mouse_co.x >= 465 and outliner == null:
					outliner = get_parent().get_node("Outline").duplicate()
					get_parent().add_child(outliner)
					outliner.visible = true
					outliner.move_to_front()
					outliner.position = Vector2(435, first_index + highlighted_index * 30)
				elif outliner != null and (mouse_co.y <= outliner.position.y - 15 or mouse_co.y >= outliner.position.y + 15):
					outliner.queue_free()
					outliner = null		
		elif outliner != null:
			outliner.queue_free()
			outliner = null
	#print(mouse_co)
		
