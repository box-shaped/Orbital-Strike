extends CharacterBody2D
const G = 6.673*pow(10,1**-1.5)
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var acceleration: Vector2 = Vector2(0, 0)
@export var accelDamping = 0.9
@export var velocityDamping = 0.97
@export var recoil = 300
@export var gravity = 0
@export var top_acceleration: Vector2 = Vector2(20, 20)
@export var pew = 0.5
@export_category("Trajectory Prediction")
@export var trajectory_steps = 5000
var readyforprocess=false
@export var trajectory_step_time = 0.1
@export var thrust = 1.3
@export var maxVel = 50
@export var maxAccel= 50
var trajectory_points = []
func _ready():
	await get_tree().process_frame
	readyforprocess=true
func _unhandled_input(event):
	if event is InputEventMouse:
		# Rotate gun towards the mouse
		$gunpivot.look_at(get_global_mouse_position())
		if !readyforprocess:return
		generate_trajectory(position, Vector2(cos($gunpivot.rotation), sin($gunpivot.rotation)) * pew)
		draw_trajectory()
func player_shoot(event: Vector2):
	# Launch the player in the opposite direction to the bullet
	
	var bullet = preload("res://bullet.tscn").instantiate()
	bullet.rotation = $gunpivot.rotation
	bullet.velocity = Vector2(cos($gunpivot.rotation), sin($gunpivot.rotation)) * pew
	bullet.position = position
	generate_trajectory(bullet.position, bullet.velocity)
	draw_trajectory()
	$"../BulletParent".add_child(bullet)
	velocity += get_global_mouse_position().direction_to(position).normalized() * recoil
	

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			player_shoot(event.position)

func handle_movement(delta):
	# Apply friction/damping to velocity and acceleration
	velocity *= velocityDamping
	acceleration.y += gravity
	acceleration.x = clamp(acceleration.x, -top_acceleration.x, top_acceleration.x)
	acceleration.y = clamp(acceleration.y, -top_acceleration.y, top_acceleration.y)

	velocity += acceleration * delta * 20

func _process(delta: float) -> void:
	handle_movement(delta)
	# Add the gravity.
	if not is_on_floor():
		pass
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
	#draw_trajectory()

func generate_trajectory(start_position: Vector2, start_velocity: Vector2):
	trajectory_points.clear()
	var position = start_position
	var velocity = start_velocity
	var thrust_vector= Vector2(0,0)
	
	for i in range(trajectory_steps):
		# Simulate physics for each step
		var acceleration = Vector2(0, 0)
		acceleration += calculate_gravity(position)
		position += velocity * trajectory_step_time
		velocity += acceleration * trajectory_step_time
		trajectory_points.append(position)
		thrust_vector = thrust * position.direction_to(position + velocity).normalized()
		velocity += (thrust_vector / velocity.length_squared()) * trajectory_step_time
		velocity = velocity.normalized() * clamp(velocity.length(), -maxVel, maxVel)
		acceleration = acceleration.normalized() * clamp(acceleration.length(), -maxAccel, maxAccel)
func calculate_gravity(position: Vector2) -> Vector2:
	var resultant: Vector2 = Vector2.ZERO
	for body in $"../Planetary Parent".get_children():
		var distance: Vector2 = body.global_position - position
		var force = (G * body.mass * 10) / distance.length_squared()
		resultant += distance.normalized() * force
	return resultant

func draw_trajectory():
	$TrajectoryLine.clear_points()
	for point in trajectory_points:
		$TrajectoryLine.add_point(point)
