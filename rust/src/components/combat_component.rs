use super::{HealthComponent, MotionComponent};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct CombatComponent {
    #[export]
    motion: OnEditor<Gd<MotionComponent>>,

    #[export]
    health: OnEditor<Gd<HealthComponent>>,

    #[export]
    #[init(val = 1)]
    attack_damage: i32,

    #[export]
    #[init(val = 1)]
    contact_damage: i64,

    base: Base<Node>,
}
