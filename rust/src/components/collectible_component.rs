use crate::systems::{State, StateMachine};
use godot::classes::{AnimationPlayer, Area2D, AudioStreamPlayer2D, Timer};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct CollectibleComponent {
    #[export]
    #[init(val = 5.0)]
    sequence_duration: f64,

    #[export]
    sequence_timer: OnEditor<Gd<Timer>>,

    #[export]
    pickup_sfx: OnEditor<Gd<AudioStreamPlayer2D>>,

    #[export]
    effect: OnEditor<Gd<AnimationPlayer>>,

    #[export]
    state_machine: OnEditor<Gd<StateMachine>>,

    #[export]
    player_state_die: OnEditor<Gd<State>>,

    #[export]
    interactbox: OnEditor<Gd<Area2D>>,

    #[var]
    #[init(val = 0)]
    collected_food: i32,

    #[var]
    #[init(val = 0)]
    collect_sequence: i32,

    base: Base<Node>,
}

#[godot_api]
impl INode for CollectibleComponent {
    fn ready(&mut self) {
        /*
        let collectible_node = self.base().clone();

        self.interactbox.connect(
            "area_entered",
            &Callable::from_object_method(&collectible_node, "on_interactbox_area_entered")
        );

        self.timer.connect(
            "timeout",
            &Callable::from_object_method(&collectible_node, "on_sequence_timer_timeout")
        );*/

        self.interactbox
            .signals()
            .area_entered()
            .connect_other(self, Self::on_interactbox_area_entered);

        self.sequence_timer
            .signals()
            .timeout()
            .connect_other(self, Self::on_sequence_timer_timeout);
    }
}

#[godot_api]
impl CollectibleComponent {
    #[func]
    fn on_interactbox_area_entered(&mut self, _area: Gd<Area2D>) {
        self.collected_food += 1;
        self.collect_sequence += 1;
        self.pickup_sfx.play();
        self.effect.play_ex().name("hit").done();

        if self.collect_sequence >= 7 {
            self.state_machine
                .bind_mut()
                .transition_state(self.player_state_die.clone());
            return;
        }

        self.sequence_timer.start();
    }

    #[func]
    fn on_sequence_timer_timeout(&mut self) {
        self.collect_sequence = 0;
    }
}

