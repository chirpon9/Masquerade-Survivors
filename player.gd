extends Area2D
signal hit


@export var speed = 400 # How fast the player will move (pixels/sec).
@export var max_health = 100 # max health

var current_health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	
	hide()


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = false
	


func _on_body_entered(body: Node2D) -> void:
	# Check if the body has a damage value (works for mobs and future projectiles)
	var damage = 10
	if "damage" in body:
		damage = body.damage
		take_damage(damage)


func take_damage(amount):
	current_health -= amount

	# Update UI (We will create this signal next)
	# health_changed.emit(current_health) 

	if current_health <= 0:
		die()

func die():
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
	
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
