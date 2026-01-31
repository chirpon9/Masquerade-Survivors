extends CharacterBody2D

@export var speed = 125.0
@export var damage = 10
const bullet = preload("res://entities/projectiles/ghost_projectiles/ghost_projectile.tscn")

func _ready():
	$AnimatedSprite2D.play("default")
	add_to_group("mobs")
	
	# Initialize the first random shot
	randomize_shoot_timer()

func _physics_process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	print(player.global_position)
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0

func _on_shoot_timer_timeout():
	# Instantiate and fire bullet
	var b = bullet.instantiate()
	get_tree().root.add_child(b)
	b.start($Marker2D.global_position)

	# Set the next random interval
	randomize_shoot_timer()

func randomize_shoot_timer():
	# Changes wait_time to a random value between 5 and 10 seconds
	$ShootTimer.wait_time = randf_range(3.0, 4.0)
	print($ShootTimer.wait_time)
	$ShootTimer.start()
