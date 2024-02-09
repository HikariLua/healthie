using Godot;

public partial class SpeedTrigger : Area2D
{
	[Export] private MotionComponent motion;
	[Export] private AnimationPlayer animationPlayer;
	[Export] private float speedScale = 3;

	private double normalSpeed;

	public override void _Ready()
	{
		base._Ready();
		BodyEntered += onBodyEntered;
		BodyExited += onBodyExited;
	}

	private void onBodyEntered(Node2D _body)
	{
		animationPlayer.SpeedScale = this.speedScale;
		normalSpeed = motion.MaxSpeed;
		motion.MaxSpeed *= this.speedScale;
	}

	private void onBodyExited(Node2D _body)
	{
		animationPlayer.SpeedScale = 1;
		motion.MaxSpeed = normalSpeed;
	}
}
