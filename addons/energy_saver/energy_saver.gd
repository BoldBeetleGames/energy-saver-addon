extends Control
class_name EnergySaver

static var instance

@export var game_node : Node
@export_category("Default FPS")
@export var use_project_settings := false
@export var normal_fps := 60
@export_category("Idle Settings")
@export var idle_fps := 1
@export var time_to_idle := 120 #in seconds
@export var pause_tree := true
@export var low_processor_in_idle := true
@export var low_processor_sleep_usec := 500000
@export_category("Screen Dim")
@export var time_to_dim := 60 #in seconds
@export_range(0., 1.) var max_dim := 1.
@export_category("Menu FPS")
@export var menu_fps := 30

var idle_time : float :
	set(value):
		if ((value >= time_to_idle) && (!is_active)):
			enter_idle()
		idle_time = value
		screen_darken.color.a = clamp((idle_time - time_to_dim) / (time_to_idle - time_to_dim), 0., max_dim)

var is_in_menu: bool = false
var is_active: bool = false

const SCREEN_DARKEN = preload("uid://cuvbqtjk478td")
const IDLE_SCREEN = preload("uid://dioy2f41fwiuw")

var screen_darken : Control
var idle_screen : Control

@onready var low_processor_usage_mode = OS.low_processor_usage_mode
@onready var low_processor_usage_mode_sleep_usec = OS.low_processor_usage_mode_sleep_usec


func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	size = DisplayServer.screen_get_size()
	instance = self
	
	var fps_system
	
	if (use_project_settings):
		FpsSystem.set_normal_fps(Engine.max_fps)
	else:
		FpsSystem.set_normal_fps(normal_fps)
	FpsSystem.reset_max_fps()
	
	screen_darken = SCREEN_DARKEN.instantiate()
	add_child(screen_darken)
	idle_screen = IDLE_SCREEN.instantiate()
	add_child(idle_screen)
	idle_screen.visible = false


static func enter_menu():
	instance.is_in_menu = true
	
	FpsSystem.set_max_fps(instance.menu_fps)
	
	print("Energy Saver started, limiting FPS to:", instance.menu_fps)
	instance.idle_time = 0.


static func exit_menu():
	FpsSystem.reset_max_fps()
	
	instance.is_in_menu = false
	instance.idle_time = 0.


func _input(event: InputEvent) -> void:
	if is_in_menu:
		return
	
	if not event.is_pressed():
		return
	if is_active:
		print("Player active, deactivate Energy Saver")
		FpsSystem.reset_max_fps()
		is_active = false
		
		if (null != game_node):
			game_node.visible = true
		if (pause_tree):
			get_tree().paused = false
		idle_screen.visible = false
		if (low_processor_in_idle):
			OS.low_processor_usage_mode = low_processor_usage_mode
			OS.low_processor_usage_mode_sleep_usec = low_processor_usage_mode_sleep_usec
	idle_time = 0.

func _process(delta):
	if (!is_in_menu):
		idle_time += delta

func enter_idle():
	print("Player inactive, activate Energy Saver")
	is_active = true
	FpsSystem.set_max_fps(idle_fps)
	print("Energy Saver started: limiting FPS to:", idle_fps)
	
	if (pause_tree):
		get_tree().paused = true
	idle_screen.visible = true
	if (null != game_node):
		game_node.visible = false
	if (low_processor_in_idle):
		OS.low_processor_usage_mode = true
		OS.low_processor_usage_mode_sleep_usec = low_processor_sleep_usec
