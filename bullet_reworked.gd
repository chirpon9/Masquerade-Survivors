extends CharacterBody2D

@export var speed = 125.0

func _ready():
	add_to_group("mobs")
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		look_at(player.global_position)
		# rotation is used for rectangular projectiles
		rotation += deg_to_rad(90)
		velocity = direction * speed

func _physics_process(_delta):
	var collision = move_and_collide(velocity * _delta)
	if collision:
		print("Collision occured")
		queue_free()
			
		
		# Handle logic for hitting the player specifically
		#var collider = collision.get_collider()
		#if collider.is_in_group("player"):
			#print("projectile hits player")
			#queue_free()
	else:
		move_and_slide()

	


	
