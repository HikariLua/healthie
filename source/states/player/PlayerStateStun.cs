using Godot;
using Godot.Collections;

public partial class PlayerStateStun : State
{
	[Export] private CharacterBody2D character;
	[Export] private MotionComponent motion;
	[Export] private Timer stunTimer;
	[Export] private double stunDuration = 0.5;
	[Export] private Area2D hurtbox;
	[Export] private double knockbackDuration = 0.2;
	[Export] private Vector2 knockbackDistance = new Vector2(8, -20);

	private Vector2 knockbackSpeed;

	public override void _Ready()
	{
		base._Ready();

		Vector2 divisor = new Vector2(
			(float)knockbackDuration,
			(float)knockbackDuration
		);
		knockbackSpeed = knockbackDistance / divisor;

		hurtbox.AreaEntered += onHurtboxAreaEntered;
		stunTimer.Timeout += onStunTimerTimeout;
	}

	private void onHurtboxAreaEntered(Area2D area)
	{
		Vector2 direction = getKnockbackDirection(area);

		Dictionary dict = new Dictionary();
		dict["direction"] = direction * -1;

		stateMachine.TransitionState(
			"PlayerStateStun",
			dict
		);
	}

	public override void OnEnter(Dictionary message = null)
	{
		motion.TwoDirectionAnimation(animationPlayer, "stun");
		stunTimer.Start(stunDuration);

		Vector2 direction = (Vector2)message["direction"];

		applyKnockback(direction);
	}

	public override void PhysicsUpdate(double delta)
	{
		float newY = (float)motion.ApplyGravity(
			character,
			delta / 2
		);
		character.Velocity = new Vector2(character.Velocity.X, newY);

		character.MoveAndSlide();
	}

	async private void applyKnockback(Vector2 direction)
	{
		character.Velocity = knockbackSpeed * direction;

		await ToSignal(GetTree().CreateTimer(knockbackDuration), "timeout");

		character.Velocity = new Vector2(0, character.Velocity.Y);
	}

	private Vector2 getKnockbackDirection(Area2D attackerHitbox)
	{
		Vector2 direction = character.GlobalPosition.DirectionTo(
			attackerHitbox.GlobalPosition
		);

		float newX = direction.X <= 0 ? -1 : 1;
		float newY = -1;

		direction = new Vector2(newX, newY);
		return direction;
	}

	private void onStunTimerTimeout()
	{
		stateMachine.TransitionState("PlayerStateIdle");
	}

	public override void OnExit()
	{
		stunTimer.Stop();
	}
}
