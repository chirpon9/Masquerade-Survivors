extends Node

@export var furniture_scene: PackedScene
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
	
	
	#add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	print(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_furniture_timer_timeout() -> void:
	# 1. Create the table
	var table = furniture_scene.instantiate()

	# 2. Use the same MobPath following the player
	var spawn_location = $Player/MobPath/MobSpawnLocation
	spawn_location.progress_ratio = randf()

	# 3. Randomize the "sprawl"
	# Rotate the table randomly so they aren't all aligned
	
	# Set position to the global location on the path
	table.global_position = spawn_location.global_position

	# 4. Add to the main scene
	add_child(table)

func update_timer_display():
	var minutes = int(survival_time) / 60
	var seconds = int(survival_time) % 60
	# Formats as "00:00"
	$CanvasLayer/SurvivalTimerLabel.text = "%02d:%02d" % [minutes, seconds]
