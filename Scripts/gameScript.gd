extends Node

@export var snakeDir = 0 # 0 up 1 right, etc.
@export var snakeLen = 1
@export var gridSize = 128
@export var health = 100
@export var score = 0

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
	elif snakeDir == 2:
		move(Vector2(0, 1))
	elif snakeDir == 3:
		move(Vector2(-1, 0))

func spawnTick():
	score += 10
	var newmob : Node2D = preload("res://Assets/mob.tscn").instantiate()
	$game/Mobs.add_child(newmob)
	var dir = [-1, 1].pick_random()
	newmob.position = Vector2(dir * 5 * gridSize, randi_range(-4, 4) * gridSize)
	if dir == -1:
		newmob.get_node("Sprite2D").flip_h = true
	var tw = create_tween().tween_property(newmob, "position", Vector2(gridSize * 8 * dir * -1, newmob.position.y), randf_range(2, 10))
	tw.finished.connect(func():
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
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Up"):
		snakeDir = 0
	elif event.is_action_pressed("Right"):
		snakeDir = 1
	elif event.is_action_pressed("Down"):
		snakeDir = 2
	elif event.is_action_pressed("Left"):
		snakeDir = 3
	if event.is_action_pressed("TEST"):
		pass
	print(snakeDir)
	
	
func _ready() -> void:
	$Tick.timeout.connect(gameTick)
	$SpawnTick.timeout.connect(spawnTick)
	$game/Player/Area2D.area_entered.connect(func(area : Area2D):
		health -= 10
	)
