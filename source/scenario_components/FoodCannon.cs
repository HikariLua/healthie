using Godot;

public partial class FoodCannon : StaticBody2D
{
	[Export] private Timer timer;
	[Export] private float timerDuration;
	[Export] private float delay;
	[Export] private AnimationPlayer animationPlayer;

	[Export] private AudioStreamPlayer2D shootSfx;
	[Export] private double shootSpeed;
	[Export] private Vector2 direction = Vector2.Left;

	private PackedScene junkFood = GD.Load(
		"res://scenes/collectibles/junk_food.tscn"
	) as PackedScene;

	async public override void _Ready()
	{
		timer.Timeout += onTimerTimeout;

		if (delay != 0)
		{
			timer.Start(delay);
			await ToSignal(timer, "timeout");
		}

		animationPlayer.SpeedScale = 1 / timerDuration;
		animationPlayer.Play("blink");

		timer.Start(timerDuration);
	}

	private void onTimerTimeout()
	{
		JunkFood food = junkFood.Instantiate() as JunkFood;

		food.GlobalPosition = this.GlobalPosition;
		food.Speed = this.shootSpeed;
		food.Direction = this.direction.Normalized();

		GetTree().Root.AddChild(food);
		shootSfx.Play();
	}
}
