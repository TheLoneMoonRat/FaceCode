extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_node("Block(3)").position = Vector2(250, 250) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
