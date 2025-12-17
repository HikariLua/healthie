use super::{MotionComponent, HealthComponent};
use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node2D)]
pub struct CombatComponent {
    #[export]
    motion : OnEditor<Gd<MotionComponent>>,
    
    #[export]
    health : OnEditor<Gd<HealthComponent>>,

    #[export]
    attack_damage: i64,

    #[export]
    contact_damage: i64
}