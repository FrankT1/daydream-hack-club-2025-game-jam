extends Node

@export var snakeDir = 0 # 0 up 1 right, etc.


func gameTick():
	pass	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Up"):
		snakeDir = 0
	elif event.is_action_pressed("Right"):
		snakeDir = 1
	elif event.is_action_pressed("Down"):
		snakeDir = 2
	elif event.is_action_pressed("Left"):
		snakeDir = 3
	print(snakeDir)
	
	
func _ready() -> void:
	$Tick.timeout.connect(gameTick)
