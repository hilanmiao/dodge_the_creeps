extends CanvasLayer

# 通知“Main”节点按钮已被按下
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
# 当玩家失败时调用此函数。它将显示“游戏结束”2 秒，然后返回到标题屏幕，并在短暂暂停后显示“开始”按钮
func show_game_over():	
	show_message('Game Over')
	# 等待消息计时器发出 timeout 信号
	await $MessageTimer.timeout	
	
	$Message.text = 'Dodge the Creeps!'
	$Message.show()
	
	# 创建一个一次性计时器并等待它完成
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
	
func update_score(score):
	$ScoreLabel.text = str(score)	
	


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()
