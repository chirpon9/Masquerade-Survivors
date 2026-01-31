extends CharacterBody2D

@export var speed = 400
@export var damage = 10

func start(_pos):
	global_position = _pos

func _ready():	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		look_at(player.global_position)
		velocity = direction * speed

func _physics_process(_delta):
	move_and_slide()
	for i in get_slide_collision_count():
		var collider = get_last_slide_collision().get_collider()
		
		# If the thing we hit has a 'take_damage' function, call it
		if collider.has_method("take_damage"):
			collider.take_damage(10) # Or use a variable
		queue_free()

	


	
