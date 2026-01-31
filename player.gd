extends CharacterBody2D
signal hit

@export var speed = 300.0 
@export var max_health = 100
@export var base_damage = 10.0
@export var base_attack_speed = 1.0 # Times per second
var armor = 0
var projectile_count = 1
var regen_rate = 1

var masks_collected = {
	"werewolf": 0,
	"cat": 0,
	"banshee": 0
}


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
		
	if current_health < max_health:
		current_health += regen_rate * delta
		# Ensure we don't go over max
		current_health = min(current_health, max_health)

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
	
func apply_mask_effects():
	# 1. Werewolf: Damage & Regen
	# Damage = base + (5% per mask)
	var damage_mult = 1.0 + (masks_collected["werewolf"] * 0.05)
	# Regen = 0.5 per mask
	regen_rate = masks_collected["werewolf"] * 0.5
	
	# 2. Cat: Speed & Attack Speed
	speed = speed + (masks_collected["cat"] * 15.0) # Flat speed boost
	# Attack speed could be used by your future weapon timer
	var attack_speed_mult = 1.0 + (masks_collected["cat"] * 0.10)
	
	# 3. Banshee: Projectiles & Max Health
	projectile_count = 1 + masks_collected["banshee"]
	max_health = 100 + (masks_collected["banshee"] * 10)
	
	# Important: Update the UI Health Bar max value if max_health changed
	# health_changed.emit()
