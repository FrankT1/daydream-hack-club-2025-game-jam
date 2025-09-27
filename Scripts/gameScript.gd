extends Node

@export var snakeDir = 0 # 0 up 1 right, etc.
@export var snakeLen = 1
@export var gridSize = 128
@export var health = 100
@export var score = 0
@export var started = false

@export var player: Node2D

var mob = "res://Assets/mob.tscn"


func move(dir : Vector2):
	
	player.position += (dir * gridSize)

func end():
	$CanvasLayer/End.visible = true
	Engine.time_scale = 0
	

func gameTick():
	if snakeDir == 0:
		move(Vector2(0, -1))
	elif snakeDir == 1:
		move(Vector2(1, 0))
		$game/Player/Sprite2D.flip_h = true
	elif snakeDir == 2:
		move(Vector2(0, 1))
	elif snakeDir == 3:
		move(Vector2(-1, 0))
		$game/Player/Sprite2D.flip_h = false

func diffTick():
	if $SpawnTick.wait_time >= 0.02:
		$SpawnTick.wait_time -= 0.005
 	
func spawnTick():
	if health < 100:
		health += 5
	
	# score += 10
	var newmob : Node2D = preload("res://Assets/mob.tscn").instantiate()
	$game/Mobs.add_child(newmob)
	var dir = [-1, 1].pick_random()
	newmob.position = Vector2(dir * 5 * gridSize, randi_range(-4, 4) * gridSize)
	newmob.get_node("Kill").area_entered.connect(func(area : Area2D):
		if area.name == "Player":
			newmob.queue_free()
	)
	if dir == -1:
		newmob.get_node("Sprite2D").flip_h = true
	var tw = create_tween().tween_property(newmob, "position", Vector2(gridSize * 8 * dir * -1, newmob.position.y), randf_range(2, 10))
	tw.finished.connect(func():
		if newmob:
			newmob.queue_free()
		)
	
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Control/Health.text = "Health: " + str(health)
	$CanvasLayer/Control/Score.text = "Score: " + str(score)
	if abs(player.position.x) > 600 || abs(player.position.y) > 600:
		health = 0
	if health <= 0:
		end()
func sacHealth():
		if health >= 10:
			health -= 10
			score += 50
func startmove():
	if not started:
		$Tick.start()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Up"):
		snakeDir = 0
		startmove()
	elif event.is_action_pressed("Right"):
		snakeDir = 1
		startmove()
	elif event.is_action_pressed("Down"):
		snakeDir = 2
		startmove()
	elif event.is_action_pressed("Left"):
		snakeDir = 3
		startmove()
	if event.is_action_pressed("Space"):
		sacHealth()
	if event.is_action_pressed("TEST"):
		pass
	
	
func _ready() -> void:
	$Tick.timeout.connect(gameTick)
	$SpawnTick.timeout.connect(spawnTick)
	$DifficultyTick.timeout.connect(diffTick)
	
	$CanvasLayer/Control/SacHealth.pressed.connect(sacHealth)
	$CanvasLayer/Control/SacScore.pressed.connect(func():
		if score >= 100:
			score -= 100
			health += 5
	)
	
	
	$game/Player/Player.area_entered.connect(func(area : Area2D):
		health -= 10
	)
