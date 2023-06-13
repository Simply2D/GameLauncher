extends Control

# links 
@onready var bt_actiontexture = $buttons/bt_action/TextureRect
@onready var bt_delete = $buttons/bt_delete

@onready var mp3_clicking = $"../audios/audio2D_clicking"
@onready var action_progressbar = $buttons/bt_action/ProgressBar

@onready var action_download_png = preload("res://assets/images/buttons/download.png")
@onready var action_launch_png = preload("res://assets/images/buttons/launch.png")
@onready var file_version = FileAccess.open("res://assets/others/launcher_version.txt", FileAccess.READ)

# storage
var download_started = false
var download_percentage:float = 0.0

# http
var httpreq:HTTPRequest = HTTPRequest.new()

# settings
@onready var downloadfile_path = 'https://github.com/Justinnn04/GameLauncher/releases/download/v1.0.0.1-beta/GameLauncher.exe'
var file_path = 'user://'
var file_name = 'WCLauncher.exe'

func _process(_delta):
	if download_started:
		# show bar
		action_progressbar.visible = true
		
		# process
		var currentfilesize:float = httpreq.get_downloaded_bytes()
		var totalfilesize:float = httpreq.get_body_size()
		download_percentage = abs(ceil((currentfilesize / totalfilesize) * 100))
		
		# display progress
		action_progressbar.value = download_percentage
		
		# change
		if action_progressbar.value == 100:
			bt_actiontexture.texture = action_launch_png
			action_progressbar.visible = false
			download_started = false

	# check file
	var result = globalscript._on_request_check_file(file_path + file_name)
	# option to delete
	if result and bt_actiontexture.texture == action_launch_png:
		bt_delete.visible = true
	else:
		bt_delete.visible = false

func _ready():
	# launcher version
	var text = file_version.get_as_text()
	$Label.text = text
	
	# check for game
	var result = globalscript._on_request_check_file(file_path + file_name)
	if result:
		bt_actiontexture.texture = action_launch_png
	
	# change parent
	add_child(httpreq)
	httpreq.request_completed.connect(_on_request_completed)
	
func _on_bt_action_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# bt sound effect
			mp3_clicking.play()

			# check file
			var result = globalscript._on_request_check_file(file_path + file_name)
			if not result:
				# texture
				bt_actiontexture.texture = action_download_png

				# process
				httpreq.download_file = file_path + file_name
				var err = httpreq.request(downloadfile_path)
				if err!=OK:
					print('Server Error?')
				download_started = true

			# run application
			elif bt_actiontexture.texture == action_launch_png:
				print('execute exe')

func _on_request_completed(body):
	print('Received: '+str(body))

# delete file
func _on_bt_delete_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# bt sound effect
			mp3_clicking.play()

			var file2delete = file_path + file_name
			DirAccess.remove_absolute(file2delete)
			bt_actiontexture.texture = action_download_png
