using Godot;
using Godot.Collections;

public partial class EnemyStateDie01 : State
{
	[Export] private CharacterBody2D character;
	[Export] private HealthComponent health;

	[Export] private AudioStreamPlayer2D hurtSfx;
	[Export] private AudioStreamPlayer2D dieSfx;

	[Export] private CollisionShape2D hurtboxCollision;
	[Export] private CollisionShape2D hitboxCollision;
	[Export] private AnimationPlayer effectPlayer;

	public override void _Ready()
	{
		base._Ready();
		health.DamageTaken += onDamageTaken;
		animationPlayer.AnimationFinished += onAnimationFinished;
	}

	private void onDamageTaken(int _previous_hp, Area2D _hitbox)
	{
		effectPlayer.Play("hurt");
		hurtSfx.Play();

		if (health.HealthPoints <= 0)
		{
			stateMachine.TransitionState("EnemyStateDie01");
		}
	}

	public override void OnEnter(Dictionary message = null)
	{
		hurtboxCollision.SetDeferred(
			CollisionShape2D.PropertyName.Disabled,
			true
		);

		hitboxCollision.SetDeferred(
			CollisionShape2D.PropertyName.Disabled,
			true
		);

		dieSfx.Play();
		animationPlayer.Play("die");
	}

	private void onAnimationFinished(StringName _animName)
	{
		if (stateMachine.ActiveState != this)
		{
			return;
		}

		character.QueueFree();
	}
}
