using Godot;
using Godot.Collections;

public partial class HealthComponent : Node
{
    [Signal]
    public delegate void DamageTakenEventHandler(
        int previousHp,
        Area2D attakerHitbox
    );
    [Signal] public delegate void LifeChangedEventHandler(int previousLife);

    [Export] public int MaxHealth = 6;
    [Export] private Area2D hurtbox;

    private int lives = 3;
    public int Lives
    {
        get { return lives; }
        set { lives = SetLives(value); }
    }

    public int HealthPoints = 0;

    private SaveLoad saveLoad;

    public override void _Ready()
    {
        hurtbox.AreaEntered += OnHurtboxAreaEnterd;

        HealthPoints = MaxHealth;
        saveLoad = GetNode<SaveLoad>("/root/SaveLoad");

        if (saveLoad.SavedDict.ContainsKey("player"))
        {
            lives = (int)saveLoad.LoadFromPreviousScene("player")["lives"];
        }
    }

    public void TakeDamage(Hitbox attackerHitbox)
    {
        int previousHealth = HealthPoints;
        HealthPoints -= attackerHitbox.Damage;

        EmitSignal(SignalName.DamageTaken, previousHealth, attackerHitbox);
    }

    public int SetLives(int value)
    {
        EmitSignal(SignalName.LifeChanged, lives);

        lives = value;

        Dictionary dict = new Dictionary();
        dict["lives"] = lives;

        saveLoad.SaveToNextScene("player", dict);
        return value;
    }

    private void OnHurtboxAreaEnterd(Area2D area)
    {
        TakeDamage(area as Hitbox);
    }
}
