extends CharacterBody2D
@export var mass = 10
const G = 6.673*pow(10,1**-1.5)
var acceleration = Vector2(0,0)
@export var maxVel = 50
@export var maxx = 50
@export var thrust:float = 1.3
var thrust_vector= Vector2(0,0)
var resultant_gravity = Vector2(0,0)
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(delta):
	timer+=delta
	if timer>0.05:
		draw()
		timer = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	##process gravity from other objects
	##F = (G * m1 * m2) / d^2. 
	##Where G is the gravitational constant
	##m1 and m2 are the masses of the bodies, 
	##and d is the distance between them.
	## or so sayeth google
	delta*=40
	move_and_collide(velocity * delta)  # Correctly scale velocity with delta
	acceleration = Vector2.ZERO
	acceleration += processMovement($"../../Planetary Parent".get_children())
	velocity += acceleration * delta  # Scale acceleration by delta
	thrust_vector = thrust * position.direction_to(position + velocity).normalized()
	print("b", thrust_vector / velocity)
	velocity += (thrust_vector / velocity.length_squared()) * delta  # Apply thrust with delta
	
	# Clamp velocity and acceleration
	velocity = velocity.normalized() * clamp(velocity.length(), -maxVel, maxVel)
	acceleration = acceleration.normalized() * clamp(acceleration.length(), -maxx, maxx)
	
	look_at(position + velocity)
	$Lines.position = position

	
	
func processMovement(bodies: Array) -> Vector2:
	var resultant: Vector2 = Vector2.ZERO

	# Add gravitational forces from other bodies
	for body in bodies:
		var distance: Vector2 = body.global_position - self.global_position
		var force = (G * body.mass * mass) / distance.length_squared()
		var result = distance.normalized() * force
		resultant += result
	resultant_gravity=resultant

	
	# Debugging
	#print("Rotation (radians): ", rotation)
	#print("Thrust Vector: ", thrust_vector)
	#print("Resultant Vector: ", resultant)
	
	#print(resultant)
	return resultant

func draw():
		#draw_line(Vector2.ZERO, velocity * 50, Color.RED)  # Velocity vector
	$Lines/Velocity.set_point_position(1,velocity*10)
	print("velocity",velocity)
	$Lines/Acceleration.set_point_position(1,acceleration*10)
	print("acceleration",acceleration)
	$Lines/GravityForce.set_point_position(1,resultant_gravity*10)
	print("gravity",resultant_gravity)
	$Lines/Thrust.set_point_position(1,thrust_vector*10)
	print("thrust",thrust_vector)
	#$Thrust.set_point_position(1,velocity*20)
	
