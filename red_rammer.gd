extends Node3D

# Movement speed
@export var speed: float = 10.0

# NavigationAgent3D node
var navigation_agent: NavigationAgent3D

# Reference to the TargetObject node
var target_object: Node3D

# String variable for the target object's name
@export var target_object_name: String = "TargetObject"

# Timer for searching the target object
var search_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize the NavigationAgent3D
	navigation_agent = NavigationAgent3D.new()
	add_child(navigation_agent)
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	navigation_agent.avoidance_enabled = true  # Enable avoidance
	navigation_agent.radius = 200  # Set the radius for avoidance (adjust as needed)
	
	# Initialize the search timer
	search_timer = Timer.new()
	search_timer.wait_time = 1.0  # Search once per second
	search_timer.autostart = true
	search_timer.timeout.connect(search_target_object)  # Corrected connection method
	add_child(search_timer)
	
	# Start the search immediately
	search_target_object()

# Function to search for the target object
func search_target_object() -> void:
	target_object = get_node_or_null("/root/" + get_tree().current_scene.name + "/" + target_object_name)
	if target_object:
		print("TargetObject found: ", target_object.name)
		update_target_position()
	else:
		print("TargetObject not found!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_object:
		print("Processing movement towards TargetObject")
		# Update the target position
		update_target_position()
		# Get the next navigation point
		var next_path_position = navigation_agent.get_next_path_position()
		# Calculate the direction to the next path point
		var direction = (next_path_position - self.global_transform.origin).normalized()
		# Move towards the next path point
		self.global_transform.origin += direction * speed * delta

# Update the target position for the navigation agent
func update_target_position() -> void:
	if target_object:
		navigation_agent.set_target_position(target_object.global_transform.origin)
		print("Target position updated to: ", target_object.global_transform.origin)
