extends Node3D
@onready var rigid_body_3d = $MeshInstance3D
@onready var pause_menu = $PauseMenu

func _ready():
	for i in range(1500):
		var clone := rigid_body_3d.duplicate()
		add_child(clone)
		clone.position = rigid_body_3d.position + Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5))


func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		pause_menu.visible = !pause_menu.visible
		if (pause_menu.visible):
			EnergySaver.enter_menu()
		else:
			EnergySaver.exit_menu()

func enter_pause_menu():
	 pause_menu.visible = true;
