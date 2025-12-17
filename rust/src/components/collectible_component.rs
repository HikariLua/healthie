use godot::classes::{AnimationPlayer, Area2D, AudioStreamPlayer2D, Timer};
use godot::prelude::*;
use crate::systems::{StateMachine, State};

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct ColectibleComponent {
    #[export]
    sequence_timer: OnEditor<Gd<Timer>>,

    #[export]
    #[init(val = 5.0)]
    sequence_duration: f64,

    #[export]
    pickup_sfx: OnEditor<Gd<AudioStreamPlayer2D>>,

    #[export]
    effect: OnEditor<Gd<AnimationPlayer>>,

    #[export]
    state_machine: OnEditor<Gd<StateMachine>>,

    #[export]
    player_state_die: OnEditor<Gd<State>>,

    #[var]
    #[init(val = 0)]
    collected_food: i64,

    #[var]
    #[init(val = 0)]
    collect_sequence: i64
}

#[godot_api]
impl ColectibleComponent {
    #[func]
    fn _on_interactbox_area_entered (&mut self, _area: Gd<Area2D>) {
        self.collected_food += 1;
        self.collect_sequence += 1;
        self.pickup_sfx.play();
        self.effect.play_ex().name("hit").done();

        if self.collect_sequence >= 7 {
            self.state_machine.bind_mut().transition_state(self.player_state_die.clone());
            return
        }

        self.sequence_timer.start();
    }

    #[func]
    fn _on_sequence_timer_timeout (&mut self) {
        self.collect_sequence = 0;
    }
}