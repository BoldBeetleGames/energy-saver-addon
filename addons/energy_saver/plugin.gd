@tool
extends EditorPlugin


func _enable_plugin():
	add_autoload_singleton("FpsSystem", "res://addons/energy_saver/Internal/fps_system.tscn")


func _disable_plugin():
	remove_autoload_singleton("FpsSystem")


func _enter_tree():
	add_custom_type("EnergySaver", "Control", load("res://addons/energy_saver/energy_saver.gd"), load("res://addons/energy_saver/Icon.png"))


func _exit_tree():
	remove_custom_type("EnergySaver")
