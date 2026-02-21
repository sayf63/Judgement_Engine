extends State

var target_position := Vector2.ZERO

# this state speeds up the weapon until it reaches past the targetted point.
func enter_state():
    target_position = entity.get_global_mouse_position()
    #entity.velocity = Vector2.ZERO
    entity.reset_cooldown("Swinging")

func do_physics_process(delta):
    if (entity.position-target_position).length() < 100:
        set_state("Moving")
    
    var to_target = entity.global_position.direction_to(target_position)
    
    # perpendicular vector (rotated 90 degrees)
    var sideways = to_target.orthogonal()
    
    var desired_velocity = to_target * entity.SPEED*2 + sideways*entity.SWING_ARC_SIZE
    
    entity.velocity = desired_velocity
    
