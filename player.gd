extends Area2D

# 每秒移动多少像素
@export var speed = 400
# 游戏窗口大小
var screen_size
# 击中信号
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# 确定动作正常工作时，在游戏开始时隐藏玩家
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 玩家移动向量
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1	
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		# 使用 normallized 归一化速度
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()	
	
	# 更新位置	
	position += velocity * delta	
	# 防止离开屏幕
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 选择移动动画
	if velocity.x != 0:
		$AnimatedSprite2D.animation = 'walk'
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = 'up'
		$AnimatedSprite2D.flip_v = velocity.y > 0	
		


func _on_body_entered(body):
	# 玩家被击中后消失
	hide()
	hit.emit()
	# 禁用玩家的碰撞，这样我们就不会hit多次触发信号
	# 如果禁用该区域的碰撞形状发生在引擎碰撞处理过程中，可能会导致错误。using set_deferred()告诉 Godot 等待禁用该形状，直到安全为止。
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false	
