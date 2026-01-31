extends CharacterBody2D

@export var speed = 400

# Inside bullet_reworked.gd
func start(_pos):
	global_position = _pos


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
	move_and_slide()
	for i in get_slide_collision_count():
		queue_free()

	


	
