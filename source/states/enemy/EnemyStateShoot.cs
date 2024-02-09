using Godot;
using Godot.Collections;

public partial class EnemyStateShoot : State
{
	[Export] private MotionComponent motion;
	[Export] private AudioStreamPlayer2D shootSfx;
	[Export] private CharacterBody2D character;

	[Export] private double shootSpeed = 70;

	private PackedScene junkFood = GD.Load(
		"res://scenes/collectibles/junk_food.tscn"
	) as PackedScene;

	public override void _Ready()
	{
		base._Ready();
		animationPlayer.AnimationFinished += onAnimationFinished;
	}

	public override void OnEnter(Dictionary message = null)
	{
		JunkFood food = junkFood.Instantiate() as JunkFood;

		food.GlobalPosition = character.GlobalPosition + new Vector2(0, -8);
		food.Speed = this.shootSpeed;
		food.Direction = motion.LookingDirection.Normalized();

		GetTree().Root.AddChild(food);
		motion.TwoDirectionAnimation(animationPlayer, "shoot");
		shootSfx.Play();
	}

	private void onAnimationFinished(StringName _animName)
	{
		if (stateMachine.ActiveState != this)
		{
			return;
		}

		stateMachine.TransitionState("EnemyStateIdle01");
	}
}
