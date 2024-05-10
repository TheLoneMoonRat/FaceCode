extends Node2D
var toolkit = ["Reference", "Assign", "Operate", "Compare", "Repeat", "Conditional"]
var mouse_index = -1
var clone = null
var canvas = []
var highlighted_index
var highlighting = false
var outliner
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func determine_nest(this_object, bound_one, bound_two, bound_three, bound_four):
	var distance = bound_one - 394
	var size = bound_two - bound_one
	var mouse_co = get_viewport().get_mouse_position()
	if abs(mouse_co.y - this_object.position.y) <= 5:
		if mouse_co.x >= bound_one and mouse_co.x <= bound_two:
			if str(this_object.get_children()[len(this_object.get_children()) - 1].get_name())[0] == '_' and this_object.get_children()[len(this_object.get_children()) - 1].position == Vector2(25, 0):
#use bound_one and bound_two
				determine_nest(this_object.get_children()[len(this_object.get_children()) - 1], bound_one, bound_two, bound_three, bound_four)
			else:	
				this_object.add_child(clone.duplicate())
				this_object.get_children()[len(this_object.get_children()) - 1].position = Vector2(25, 0)
				movement_changes(this_object.get_children()[len(this_object.get_children()) - 1])
				this_object.get_children()[len(this_object.get_children()) - 1].scale = Vector2(0.5, 0.5)
		elif mouse_co.x >= bound_three and mouse_co.x <= bound_four:
			if str(this_object.get_children()[len(this_object.get_children()) - 1].get_name())[0] == '_' and this_object.get_children()[len(this_object.get_children()) - 1].position == Vector2(25, 0):
#use bound_three and bound_four
				determine_nest(this_object.get_children()[len(this_object.get_children()) - 1], bound_one, bound_two, bound_three, bound_four)
			else:
				this_object.add_child(clone.duplicate())
				this_object.get_children()[len(this_object.get_children()) - 1].position = Vector2(-25, 0)
				movement_changes(this_object.get_children()[len(this_object.get_children()) - 1])
				this_object.get_children()[len(this_object.get_children()) - 1].scale = Vector2(0.5, 0.5)
		return false
	return true
func movement_changes(moved_object):
	moved_object.move_to_front()
	moved_object.scale = Vector2(2, 1)
	moved_object.get_node("RichTextLabel").queue_free()
	for n in moved_object.get_children():
		n.scale = Vector2(0.5, 1)
		if n.get_name() == "Equal":
			n.scale = Vector2(0.05, 0.1)
		elif n.get_name() == "ItemList":
			n.scale = Vector2(0.1, 0.2)
			n.position = Vector2(-7.5, -7.5)
		elif n.get_name() != "RichTextLabel":
			n.get_node("LineEdit").visible = true
		n.visible = true
func _unhandled_input(event):
	var mouse_co = get_viewport().get_mouse_position()
	if event is InputEventMouseButton:
		if event.pressed:
			if abs(mouse_co.x - 676) <= 60 and abs(mouse_co.y - 35) <= 25:
				for i in range(0, len(canvas)):
					for j in range(0, 6):
						if canvas[i].texture == get_parent().get_node(toolkit[j]).texture:
							print(toolkit[j])
			elif abs(mouse_co.x - 817) <= 60 and abs(mouse_co.y - 35) <= 25:
				for i in range(0, len(canvas)):
					canvas[i].queue_free()
				canvas.clear()
			elif (mouse_co.x >= 54 and mouse_co.x <= 154) and (mouse_co.y >= 85 and mouse_co.y <= 615) and (int(mouse_co.y) % 100 <= 15 or int(mouse_co.y) % 100 >= 85):
				mouse_index = (floor((mouse_co.y + 15) / 100)) -1
		else:
			if mouse_index != -1 and (mouse_co.y >= 80 and mouse_co.y <= 650) and (mouse_co.x >= 204 and mouse_co.x <= 584):
				var first_index = 365 - 45 * floor((len(canvas) + 1) / 2) - 15 * ((len(canvas) + 1) % 2)
				var basis = true
				for j in range (0, len(canvas)):
					if determine_nest(canvas[j], 410, 477, 310, 377) == false:
						basis = false
						break
				if basis:
					if len(canvas) == 0 or mouse_co.y > canvas[len(canvas) - 1].position.y:
						canvas.append(clone.duplicate())
						get_parent().add_child(canvas[len(canvas) - 1])
						canvas[len(canvas) - 1].position = Vector2(394, 0)
						movement_changes(canvas[len(canvas) - 1])
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
						canvas[0].position = Vector2(394, 0)
						movement_changes(canvas[0])
					else:
						var temp = []
						var index = len(canvas)
						for i in range (highlighted_index, index):
							temp.append(canvas[highlighted_index])
							canvas.remove_at(highlighted_index)
						canvas.append(clone.duplicate())
						get_parent().add_child(canvas[highlighted_index])
						if outliner:
							canvas[highlighted_index].position = Vector2(canvas[highlighted_index - 1].position.x + 41, 0)
						else:
							canvas[highlighted_index].position = Vector2(394, 0)
						movement_changes(canvas[highlighted_index])
						for item in temp:
							canvas.append(item)
						temp.clear()
					if len(canvas) <= 18:
						for i in range (0, len(canvas)):
							canvas[i].position = Vector2(canvas[i].position.x, first_index + i * 45)
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
			var basis = true
			for j in range (0, len(canvas)):
				if basis and abs(mouse_co.y - canvas[j].position.y) <= 5:
					if mouse_co.x >= 410 and mouse_co.x <= 477:
						canvas[j].get_node("TheBox").get_node("LineEdit").text = "NEST"
					elif mouse_co.x >= 310 and mouse_co.x <= 377:
						canvas[j].get_node("TheBox2").get_node("LineEdit").text = "NEST"
					basis = false
				else:
					canvas[j].get_node("TheBox").get_node("LineEdit").text = canvas[j].get_node("TheBox").get_node("LineEdit").placeholder_text
					canvas[j].get_node("TheBox2").get_node("LineEdit").text = canvas[j].get_node("TheBox2").get_node("LineEdit").placeholder_text
			var first_index = 365 - 45 * floor((len(canvas) + 1) / 2) - 15 * ((len(canvas) + 1) % 2)
			if basis and mouse_co.y > canvas[0].position.y and mouse_co.y < canvas[len(canvas) - 1].position.y:
				highlighted_index = floor((mouse_co.y - canvas[0].position.y) / 45) + 1

				for i in range (0, len(canvas)):
					if i < highlighted_index:
						canvas[i].position = Vector2(canvas[i].position.x, first_index + i * 45)
					else:
						canvas[i].position = Vector2(canvas[i].position.x, first_index + i * 45 + 45)
				if canvas[highlighted_index - 1].position.x <= 500 and mouse_co.x >= 465 and outliner == null:
					outliner = get_parent().get_node("Outline").duplicate()
					get_parent().add_child(outliner)
					outliner.visible = true
					outliner.move_to_front()
					outliner.position = Vector2(canvas[highlighted_index - 1].position.x + 41, first_index + highlighted_index * 45)
				elif outliner != null and ((mouse_co.y <= outliner.position.y - 15 or mouse_co.y >= outliner.position.y + 15) or mouse_co.x < 465):
					outliner.queue_free()
					outliner = null
		elif outliner != null:
			outliner.queue_free()
			outliner = null
	#print(mouse_co)
		
