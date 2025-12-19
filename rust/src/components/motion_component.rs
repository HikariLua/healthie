use godot::classes::{AnimationPlayer, CharacterBody2D, Input, ProjectSettings};
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
    #[var(get, set = set_looking_direction)]
    #[init(val = Vector2::RIGHT)]
    looking_direction: Vector2,

    #[export]
    #[init(val = false)]
    was_on_floor: bool,

    #[var(get, set = set_input_direction)]
    #[init(val = Vector2::ZERO)]
    input_direction: Vector2,

    #[var]
    gravity: f64,

    base: Base<Node>,
}

#[godot_api]
impl INode for MotionComponent {
    fn ready(&mut self) {
        self.gravity = ProjectSettings::singleton()
            .get_setting("physics/2d/default_gravity")
            .to::<f64>();
    }
}

#[godot_api]
impl MotionComponent {
    #[signal]
    pub fn looking_direction_changed(old_value: Vector2, new_value: Vector2);

    #[signal]
    pub fn input_direction_changed(old_value: Vector2, new_value: Vector2);

    #[func]
    fn update_input_direction() -> Vector2 {
        let input = Input::singleton();

        let mut new_input_direction = Vector2::new(
            input.get_axis("left", "right"),
            input.get_axis("up", "down"),
        );

        if new_input_direction.x != 0.0 {
            new_input_direction.x = if new_input_direction.x > 0.0 {
                1.0
            } else {
                -1.0
            };
        }

        if new_input_direction.y != 0.0 {
            new_input_direction.y = if new_input_direction.y > 0.0 {
                1.0
            } else {
                -1.0
            };
        }

        return new_input_direction;
    }

    #[func]
    fn apply_gravity(
        body: Gd<CharacterBody2D>,
        max_fall_speed: f64,
        gravity: f64,
        delta: f64,
    ) -> f64 {
        if body.is_on_floor() {
            return body.get_velocity().y as f64;
        }

        return move_toward(
            body.get_velocity().y as f64,
            max_fall_speed,
            gravity * delta,
        );
    }

    #[func]
    fn move_x(speed: f64, direction: f64) -> f64 {
        speed * direction
    }

    // TODO: colocar função em classe de animação apropriada
    // TODO: tornar a função sem side effect e fazer mudança direcional por sinal
    #[func]
    fn two_direction_animation(
        mut animation_player: Gd<AnimationPlayer>,
        direction: f64,
        animation_prefix: GString,
    ) {
        let suffix = if direction < 0.0 { "-left" } else { "-right" };
        let new_animation = animation_prefix.to_string() + suffix;

        if new_animation == String::from(animation_player.get_current_animation()) {
            return;
        }

        let new_animation = &new_animation;

        animation_player.play_ex().name(new_animation).done();
    }

    #[func]
    fn set_looking_direction(&mut self, new_looking_direction: Vector2) {
        if new_looking_direction.x == 0.0 {
            return;
        }

        let old_value = self.looking_direction;
        let new_value = new_looking_direction;

        self.looking_direction = new_looking_direction;

        self.signals()
            .looking_direction_changed()
            .emit(old_value, new_value);
    }

    #[func]
    fn set_input_direction(&mut self, new_input_direction: Vector2) {
        let old_value = self.input_direction;
        let new_value = new_input_direction;

        self.input_direction = new_input_direction;

        self.signals()
            .input_direction_changed()
            .emit(old_value, new_value);
    }
}
