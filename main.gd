extends Node2D

const Ball = preload("res://ball.tscn")
const max_points = 500
const initial_ball_position = Vector2(100, 100)

onready var line_by_formula = $ProjectionByFormula

var ball_instance: Ball
var is_ball_outside = false
var steps = []
var line = Line2D.new()
const impulse = Vector2(100, 0)

func _ready():
	create_ball()
	add_child(line)

func _input(event):
	if event.is_action_released("click"):
		create_ball()

func _process(_delta):
	for node in get_tree().get_nodes_in_group("balls"):
		if node.position.x < -64 || node.position.y < -64:
			remove_child(node)

func _physics_process(delta):
	print("_physics_process:delta", delta)
	line.add_point(ball_instance.position)
	render_projection_v2(delta)

func create_ball():
	ball_instance = Ball.instance()
	ball_instance.position = initial_ball_position
	ball_instance.add_to_group("balls")
	add_child(ball_instance)
	ball_instance.apply_central_impulse(impulse)

	print("mass", ball_instance.mass)
	if line.points.size() > 1:
		line.clear_points()
	
	line.width = 1
	line.default_color = Color.red

func render_projection_v1():
	line_by_formula.clear_points()
	var delta = Engine.get_frames_per_second()
	var gravity = 1
	var pos = initial_ball_position
	var radius = 10
	var vel = Vector2(radius, 0) * delta

	for i in max_points:
		line_by_formula.add_point(pos)
		vel.y += gravity
		pos += vel

func render_projection_v2(delta):
	if max_points == line_by_formula.points.size():
		return

	line_by_formula.clear_points()
	var pos = initial_ball_position
	var radius = 10 * 2

	var _gravity = Vector2(0, 1)
	var _inv_mass = 1.0 / 1 # ball mass
	var _force = _gravity + impulse
	var vel = _force * delta

	for i in max_points:
		line_by_formula.add_point(pos)
		vel += _gravity * 2 * delta
		pos += vel
