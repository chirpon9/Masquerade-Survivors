extends CharacterBody2D

@export var speed = 125.0
@export var damage = 10 #

func _ready():
	
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
	add_to_group("mobs")

func _physics_process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x > 0
