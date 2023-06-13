extends Node

# links
@onready var mp3_clicking = $"../audios/audio2D_clicking"
var github_link = 'https://github.com/Simply2D'

# open github
func _on_bt_github_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			mp3_clicking.play()
			OS.shell_open(github_link)

# exit game
func _on_bt_exit_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			mp3_clicking.play()
			get_tree().quit()

# check file
func _on_request_check_file(file_directory):
	var err = FileAccess.file_exists(file_directory)
	if err==false:
		return false
	else:
		return true
