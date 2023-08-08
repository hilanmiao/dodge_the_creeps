extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
#	new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message('Get Ready')

func _on_mob_timer_timeout():
	# 创建 Mob 场景的新实例
	var mob = mob_scene.instantiate()
	
	# 在 Path2D 上选择一个随机位置
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# 将 Mob 的方向设置为垂直于路径方向
	var direction = mob_spawn_location.rotation + PI / 2
	
	# 将 Mob 的位置设置为随机位置
	mob.position = mob_spawn_location.position
	
	# 为方向添加一些随机性
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# 选择 Mob 的速度
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# 通过将其添加到主场景来生成生物
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
