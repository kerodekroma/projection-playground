extends Node2D

const Ball = preload("res://ball.tscn")
var ball_instance: Ball
var is_ball_outside = false

func _input(event):
	if event.is_action_released("click"):
		create_ball()

func _process(_delta):
	for node in get_tree().get_nodes_in_group("balls"):
		if node.position.x < -64 || node.position.y < -64:
			remove_child(node)

func create_ball():
	ball_instance = Ball.instance()
	ball_instance.position = Vector2(50, 100)
	ball_instance.add_to_group("balls")
	add_child(ball_instance)
	ball_instance.apply_central_impulse(Vector2(500, 0))
