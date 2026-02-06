extends Node

static var normal_fps = 1

func set_normal_fps(value):
	normal_fps = value

func set_max_fps(value):
	Engine.max_fps = value

func reset_max_fps():
	Engine.max_fps = normal_fps
