extends Node


@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var health_bar = $Player/HealthBar
	health_bar.value = $Player.current_health
	
	var health_pct = float($Player.current_health) / $Player.max_health
	health_bar.get("theme_override_styles/fill").bg_color = Color.GREEN


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)       
	$StartTimer.start()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $Player/MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.global_position
	
	
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	print(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
