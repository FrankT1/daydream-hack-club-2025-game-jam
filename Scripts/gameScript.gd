extends Node

@export var snakeDir = 0 # 0 up 1 right, etc.
@export var snakeLen = 1
@export var gridSize = 128
@export var health = 100


@export var player: Node2D



func move(dir : Vector2):
	player.position += (dir * gridSize)
	



func gameTick():
	if snakeDir == 0:
		move(Vector2(0, -1))
	elif snakeDir == 1:
		move(Vector2(1, 0))
	elif snakeDir == 2:
		move(Vector2(0, 1))
	elif snakeDir == 3:
		move(Vector2(-1, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CanvasLayer/Control/Label.text = "Health: " + str(health)
	
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
