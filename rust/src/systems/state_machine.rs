use super::State;
use godot::classes::INode2D;
use godot::classes::Node2D;
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node2D)]
pub struct StateMachine {
    #[export]
    initial_state: OnEditor<Gd<State>>,

    #[var]
    #[init(val = Gd::from_init_fn(State::init))]
    active_state: Gd<State>,

    base: Base<Node2D>,
}

#[godot_api]
impl INode2D for StateMachine {
    fn ready(&mut self) {
        self.active_state = self.initial_state.clone();
    }

    fn physics_process(&mut self, delta: f64) {
        self.active_state.bind_mut().physics_update(delta);
        self.check_transitions();
    }
}

#[godot_api]
impl StateMachine {
    #[func]
    fn transition_state(&mut self, target_state: Gd<State>) {
        self.active_state.bind_mut().on_exit();
        self.active_state = target_state;
        self.active_state.bind_mut().on_enter();
    }

    #[func]
    fn transition_state_with_message(&mut self, target_state: Gd<State>, message: VarDictionary) {
        self.active_state.bind_mut().on_exit();
        self.active_state = target_state;
        self.active_state.bind_mut().on_enter_with_message(message);
    }

    #[func]
    fn check_transitions(&mut self) {
        let transitions = self.active_state.bind().transitions.clone();

        for (state_key, condition_value) in transitions.iter_shared() {
            let target_state = state_key.try_to::<Gd<State>>().unwrap();

            let condition = condition_value.try_to::<Callable>().unwrap();

            let result = condition.callv(&varray![]);

            if let Ok(is_true) = result.try_to::<bool>() {
                if is_true {
                    self.transition_state(target_state);
                    break;
                }
            }
        }
    }
}
