using Godot;

public partial class PlayerProjectile : Area2D
{
	[Export] private int speed = 200;
	[Export] private Hitbox hitbox;
	[Export] private VisibleOnScreenNotifier2D visibleNotifier;

	public Vector2 Direction = Vector2.Right;
	public int Damage = 1;

	public override void _Ready()
	{
		float newY = (float)(GlobalPosition.Y - 7.5);
		GlobalPosition = new Vector2(GlobalPosition.X, newY);

		hitbox.Damage = this.Damage;

		hitbox.AreaEntered += onHitboxAreaEntered;
		visibleNotifier.ScreenExited += onVisibleNotifierScreenExited;
	}

	public override void _EnterTree()
	{
		Color color = Color.Color8(
			(byte)GD.RandRange(80, 255),
			(byte)GD.RandRange(80, 255),
			(byte)GD.RandRange(80, 255)
		);

		this.Modulate = color;
	}

	public override void _PhysicsProcess(double delta)
	{
		Position += (Direction * speed) * (float)delta;

		if (HasOverlappingBodies())
		{
			selfDestroy();
		}
	}

	private void selfDestroy()
	{
		QueueFree();
	}

	private void onHitboxAreaEntered(Area2D _area)
	{
		selfDestroy();
	}

	private void onVisibleNotifierScreenExited()
	{
		selfDestroy();
	}
}
