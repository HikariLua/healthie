use godot::prelude::*;

#[derive(GodotClass)]
#[class(init, base=Node)]
pub struct SaveLoad {
    #[var]
    pub saved_dict: VarDictionary,
}

#[godot_api]
impl SaveLoad {
    #[func]
    pub fn save_to_next_scene(&mut self, key: GString, dict: VarDictionary) {
        self.saved_dict.set(key, dict);
    }

    #[func]
    pub fn load_from_previous_scene(&mut self, key: GString) -> VarDictionary {
        let load_value = self.saved_dict.at(key).to();

        load_value
    }
}
