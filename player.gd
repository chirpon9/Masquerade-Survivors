extends CharacterBody2D
signal hit

@export var speed = 300 
@export var max_health = 100 

var current_health

func _ready() -> void:
	current_health = max_health
	hide()

# Use _physics_process for CharacterBody2D movement logic
func _physics_process(delta: float) -> void:
	var input_velocity = Vector2.ZERO 
	
	if Input.is_action_pressed("move_right"):
		input_velocity.x += 1
	if Input.is_action_pressed("move_left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		input_velocity.y += 1
	if Input.is_action_pressed("move_up"):
		input_velocity.y -= 1

	if input_velocity.length() > 0:
		# Set the built-in velocity property instead of updating position
		velocity = input_velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.stop()
		
	# This function handles the physics and stops you at obstacles
	move_and_slide()
	
	# Animation logic
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"

# Connect your Area2D (Hurtbox) body_entered signal here
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if "damage" in body:
		take_damage(body.damage)
	else:
		take_damage(10)

func take_damage(amount):
	current_health -= amount
	if current_health <= 0:
		die()

func die():
	hide()
	hit.emit()
	# Disable the detection shape
	$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	current_health = max_health # Reset health on start
	show()
	$Hurtbox/CollisionShape2D.disabled = false
