extends CSGBox3D

# Public field for the prefab
@export var prefab: PackedScene

# Public field for the spawn rate in seconds
@export var spawn_rate: float = 3.0

# Timer to handle spawning intervals
var spawn_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize the timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_rate
	spawn_timer.one_shot = false  # Repeat the timer
	spawn_timer.timeout.connect(spawn_prefab)
	add_child(spawn_timer)
	spawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Function to spawn the prefab
func spawn_prefab() -> void:
	if prefab:
		var instance = prefab.instantiate()
		instance.position = self.position
		get_parent().add_child(instance)
