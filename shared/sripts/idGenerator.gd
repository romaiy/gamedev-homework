extends Node

var current_id: int = 0

# Функция для генерации уникальных ID
func generate_id() -> int:
	current_id += 1
	return current_id
