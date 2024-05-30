extends Node2D
class_name Plant

# Параметры
var pos_x: int
var pos_y: int
var growth_cycle_duration: float
var total_cycles: int

# Внутренние поля
var current_cycle: int = 0
var growth_timer: Timer

# Конструктор
func _init(pos_x: int, pos_y: int, growth_cycle_duration: float = 2.0, total_cycles: int = 3):
	self.pos_x = pos_x
	self.pos_y = pos_y
	self.growth_cycle_duration = growth_cycle_duration
	self.total_cycles = total_cycles

	# Создание таймера
	growth_timer = Timer.new()
	growth_timer.wait_time = growth_cycle_duration
	growth_timer.autostart = true
	growth_timer.one_shot = true

	growth_timer.connect("timeout", _on_growth_timer_timeout)
	add_child(growth_timer)

# Обработчик таймера
func _on_growth_timer_timeout():
	if current_cycle < self.total_cycles:
		current_cycle += 1
		print("Cycle reached: ", current_cycle, "/", self.total_cycles)
		# Ожидание полива
		growth_timer.stop()
		print("Waiting for watering...")
	else:
		print("Plant has fully grown")

# Метод для полива растения
func water():
	if current_cycle < self.total_cycles:
		print("Watering plant...")
		growth_timer.start()
	else:
		print("Plant does not need more water")

