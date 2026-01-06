use crate::systems::{SaveLoad};
use godot::classes::{Area2D, Node};
use godot::prelude::*;
use godot::tools::try_get_autoload_by_name;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct HealthComponent {
    #[export]
    #[init(val = 6)]
    max_health: i32,

    #[export]
    hurtbox: OnEditor<Gd<Area2D>>,

    #[export]
    lifes: i32,

    #[var]
    health_points: i32,

    base: Base<Node>,
}

#[godot_api]
impl INode for HealthComponent {
    fn ready(&mut self) {
        self.hurtbox
            .signals()
            .area_entered()
            .connect_other(self, Self::on_hurtbox_area_entered);

        self.health_points = self.max_health;

        let mut saveload = try_get_autoload_by_name::<SaveLoad>("SaveLoadAutoload").unwrap();

        let save_dict = saveload.bind_mut().get_saved_dict();


        if save_dict.contains_key("player") {
            self.lifes = saveload.bind_mut().load_from_previous_scene("player".into()).get_or_nil("lifes").to();
        }

    }
}

#[godot_api]
impl HealthComponent {
    #[signal]
    fn damage_taken(previous_hp: i32, attacker_hitbox: Gd<Area2D>);
    #[signal]
    fn life_changed(previous_life: i32);

    #[func]
    fn change_lifes(&mut self, new_lifes: i32) {
        self.base_mut()
            .emit_signal("life_changed", &[Variant::from(new_lifes)]);


        self.lifes = new_lifes;
        
        let mut saveload = try_get_autoload_by_name::<SaveLoad>("SaveLoadAutoload").unwrap();

        saveload
            .bind_mut()
            .save_to_next_scene("player".into(), vdict! {"lifes": self.lifes});
    }

    #[func]
    fn take_damage(&mut self, attacker_hitbox: Gd<Area2D>) {
        let previous_health = self.health_points;
        
        self.health_points = self.health_points - 1;

        self.base_mut().emit_signal(
            "damage_taken",
            &[
                Variant::from(previous_health),
                Variant::from(attacker_hitbox),
            ],
        );
    }

    #[func]
    fn on_hurtbox_area_entered(&mut self, area: Gd<Area2D>) {
        self.take_damage(area);
    }
}

