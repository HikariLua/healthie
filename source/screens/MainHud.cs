using Godot;

public partial class MainHud : Node
{
	[Export] private CollectableComponent collectable;
	[Export] private HealthComponent health;
	[Export] private Label foodLabel;
	[Export] private Label lives;
	[Export] private ProgressBar foodBar;
	[Export] private ProgressBar timeBar;

	public override void _Ready()
	{
		timeBar.MaxValue = collectable.SequenceDuration;
	}

	public override void _Process(double delta)
	{
		foodLabel.Text = "= " + collectable.CollectedFood as string;
		lives.Text = "= " + health.Lives as string;

		foodBar.Value = collectable.CollectSequence;
		timeBar.Value = collectable.SequenceTimer.TimeLeft;
	}
}
