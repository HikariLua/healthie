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
    pub active_state: Gd<State>,

    base: Base<Node2D>,
}

#[godot_api]
impl INode2D for StateMachine {
    fn ready(&mut self) {
        self.active_state = self.initial_state.clone();
        self.active_state.bind_mut().on_enter();
    }

    fn physics_process(&mut self, delta: f64) {
        self.active_state.bind_mut().physics_update(delta);
        self.check_transitions();
    }
}

#[godot_api]
impl StateMachine {
    #[func]
    pub fn transition_state(&mut self, target_state: Gd<State>) {
        self.active_state.bind_mut().on_exit();
        self.active_state = target_state;
        self.active_state.bind_mut().on_enter();
    }

    #[func]
    pub fn transition_state_with_message(
        &mut self,
        target_state: Gd<State>,
        message: VarDictionary,
    ) {
        self.active_state.bind_mut().on_exit();
        self.active_state = target_state;
        self.active_state.bind_mut().on_enter_with_message(message);
    }

    #[func]
    pub fn check_transitions(&mut self) {
        let transitions = self.active_state.bind().transitions.clone();

        for (state_key, condition_value) in transitions.iter_shared() {
            let target_state = state_key.try_to::<Gd<State>>().unwrap();
            let transition_func = condition_value.try_to::<Callable>().unwrap();

            let result_array = transition_func
                .callv(&varray![])
                .try_to::<VarArray>()
                .unwrap();

            if result_array.len() < 2 {
                panic!("Condition array must have 2 elements");
            }

            let should_transition = match result_array.get(0).unwrap().try_to::<bool>() {
                Ok(val) => val,
                Err(_) => {
                    panic!("First array element must be a boolean");
                }
            };

            let message_variant = match result_array.get(1) {
                Some(val) => val,
                None => {
                    panic!("Array must have length 2");
                }
            };

            if should_transition {
                if message_variant.is_nil() {
                    self.transition_state(target_state);
                    return;
                }

                match message_variant.try_to::<VarDictionary>() {
                    Ok(message_dict) => {
                        self.transition_state_with_message(target_state, message_dict);
                    }
                    Err(_) => {
                        panic!("Second array element must be null or a Dictionary");
                    }
                }

                break;
            }
        }
    }
}
