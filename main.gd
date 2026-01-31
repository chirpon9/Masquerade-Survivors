extends Node

@export var furniture_scenes: Array[PackedScene]
@export var mob_scene: PackedScene
var score
var survival_time: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var health_bar = $Player/HealthBar
	health_bar.value = $Player.current_health
	
	survival_time += delta
	update_timer_display()
	$MobTimer.wait_time = max(0.2, 1.0 - (survival_time * 0.01))
	
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
	
func _on_furniture_timer_timeout() -> void:
	if furniture_scenes.is_empty():
		return
		
	# 1. Pick a random furniture scene from the array
	var random_scene = furniture_scenes.pick_random()
	var furniture = random_scene.instantiate()

	# 2. Use your existing spawning logic
	var spawn_location = $Player/MobPath/MobSpawnLocation
	spawn_location.progress_ratio = randf()
	furniture.global_position = spawn_location.global_position

	# 3. Add to the scene
	add_child(furniture)

func update_timer_display():
	var minutes = int(survival_time) / 60
	var seconds = int(survival_time) % 60
	# Formats as "00:00"
	$CanvasLayer/SurvivalTimerLabel.text = "%02d:%02d" % [minutes, seconds]
