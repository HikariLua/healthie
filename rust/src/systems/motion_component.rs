use godot::classes::{AnimationPlayer, CharacterBody2D, Input, Node, ProjectSettings};
use godot::global::move_toward;
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct MotionComponent {
    #[export]
    #[init(val = -32.0 * 8.7)]
    jump_velocity: f64,

    #[export]
    #[init(val = 92.0)]
    max_speed: f64,

    #[export]
    #[init(val = 200.0)]
    max_fall_speed: f64,
    
    #[export]
    #[init(val = Vector2::RIGHT)]
    looking_direction: Vector2,

    #[export]
    #[init(val = false)]
    was_on_floor: bool,

    #[var]
    #[init(val = Vector2::ZERO)]
    input_direction: Vector2,

    #[var]
    gravity: f64,

}

#[godot_api]
impl INode for MotionComponent {
    fn ready (&mut self) {
        self.gravity = ProjectSettings::singleton().get_setting("physics/2d/default_gravity").to::<f64>();
    }
}

#[godot_api]
impl MotionComponent {
    #[func]
    fn update_input_direction() -> Vector2 {
        let mut new_input_direction = Vector2::new(
            Input::singleton().get_axis("left", "right"),
            Input::singleton().get_axis("up", "down")
        );

        if !(new_input_direction.x == 0.0) {
            new_input_direction.x = if new_input_direction.x > 0.0 { 1.0 } else { -1.0 };
        }

        if !(new_input_direction.y == 0.0) {
            new_input_direction.y = if new_input_direction.y > 0.0 { 1.0 } else { -1.0 };
        }

        new_input_direction
    }

    // DESSA FORMA NÃO MUDA O CAMPO, APENAS RETORNA O VALOR
    #[func]
    fn set_new_looking_direction(&mut self, new_looking_direction: Vector2) -> Vector2 {
        if new_looking_direction.x == 0.0 {
            return self.looking_direction;
        }
        
        return new_looking_direction
    }

    #[func]
    fn apply_gravity(&mut self, body: Gd<CharacterBody2D>, delta: f64) -> f64 {
        if body.is_on_floor() {
            return body.get_velocity().y as f64
        }
        return move_toward(body.get_velocity().y as f64, self.max_fall_speed, self.gravity * delta)
    }

    #[func]
    fn move_x(speed: f64, direction: f64) -> f64 {
        speed * direction
    }
    
    #[func]
    fn two_direction_animation(&mut self, mut animation_player: Gd<AnimationPlayer>, animation_prefix: GString) {
        let mut suffix = if self.looking_direction.x < 0.0 { "-left" } else { "-right" };
        let mut new_animation = animation_prefix.to_string() + suffix;
        
        
        
    }
}