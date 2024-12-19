extends Control

const GRID_SIZE = 10

var pixels = []

var is_drawing = false
var is_erasing = false

var highlight_square : ColorRect

var draw_size = 1

func _process(delta: float) -> void:
	update_highlight_square()

	if Input.is_action_pressed("left click"):
		if not is_drawing:
			is_drawing = true
		place_pixel()
	elif Input.is_action_just_released("left click"):
		is_drawing = false

	if Input.is_action_pressed("right click"):
		if not is_erasing:
			is_erasing = true
		remove_pixel()
	elif Input.is_action_just_released("right click"):
		is_erasing = false

func _input(event):
	if event is InputEventMouseButton and Input.is_action_pressed("ctrl"):
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			adjust_draw_size(1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			adjust_draw_size(-1)

func adjust_draw_size(amount: int):
	draw_size = max(1, draw_size + amount)
	highlight_square.size = Vector2(draw_size * GRID_SIZE, draw_size * GRID_SIZE)

func update_highlight_square():
	var mouse_pos = get_viewport().get_mouse_position()
	var grid_pos = snap_to_grid(mouse_pos)
	highlight_square.position = grid_pos

func place_pixel():
	var mouse_pos = get_viewport().get_mouse_position()
	var grid_pos = snap_to_grid(mouse_pos)

	for x in range(draw_size):
		for y in range(draw_size):
			var offset_pos = grid_pos + Vector2(x * GRID_SIZE, y * GRID_SIZE)

			var pixel_exists = false
			for pixel in pixels:
				if pixel.position == offset_pos:
					pixel_exists = true
					break

			if not pixel_exists:
				var pixel = ColorRect.new()
				pixel.size = Vector2(GRID_SIZE, GRID_SIZE)
				pixel.color = Color(1, 1, 1)
				pixel.position = offset_pos
				add_child(pixel)
				pixels.append(pixel)

func remove_pixel():
	var mouse_pos = get_viewport().get_mouse_position()
	var grid_pos = snap_to_grid(mouse_pos)

	for x in range(draw_size):
		for y in range(draw_size):
			var offset_pos = grid_pos + Vector2(x * GRID_SIZE, y * GRID_SIZE)

			for pixel in pixels:
				if pixel.position == offset_pos:
					pixels.erase(pixel)
					pixel.queue_free()
					break

func snap_to_grid(position: Vector2) -> Vector2:
	return Vector2(
		int(position.x / GRID_SIZE) * GRID_SIZE,
		int(position.y / GRID_SIZE) * GRID_SIZE
	)

func _ready():
	highlight_square = ColorRect.new()
	highlight_square.size = Vector2(GRID_SIZE, GRID_SIZE)
	highlight_square.color = Color(1, 1, 0, 0.5)
	add_child(highlight_square)
