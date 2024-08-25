extends Sprite2D

@onready var start_button = $"../CanvLayer/CenterContainer/Start"
@onready var game_over = $"../CanvLayer/CenterContainer/GameOver"
@onready var ui_cont = $"../CanvLayer/UI"
@onready var player_obj = $"../Player"


var enemy = preload("res://enemy.tscn")
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	spawn_enemies()
	game_over.hide()
	start_button.show()
	


func spawn_enemies():
	for x in range(9):
		for y in range(3):
			var e = enemy.instantiate()
			var pos = Vector2(x * (16 + 8) + 24, 16 * 4 + y * 16)
			add_child(e)
			e.start(pos)
			e.died.connect(_on_enemy_died)


func _on_enemy_died(value):
	score += value
	# simple $CanvLayer not works...analyze it later
	var ui_node = get_node("/root/Main/CanvLayer/UI")
	ui_node.update_score(score)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_pressed():
	start_button.hide()
	new_game()


func new_game():
	score = 0
	ui_cont.update_score(score)
	player_obj.start()
	spawn_enemies()

	
func _on_player_died():
	get_tree().call_group("enemies", "queue_free")
	game_over.show()
	await get_tree().create_timer(2).timeout
	game_over.hide()
	start_button.show()	

