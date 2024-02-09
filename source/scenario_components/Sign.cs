using Godot;

public partial class Sign : Area2D
{
	[Export] private Label textLabel;
	[Export] private ColorRect colorRect;
	[Export] private Node2D messageNode;
	[Export] private AnimationPlayer animationPlayer;

	[Export] private AudioStreamPlayer2D openSfx;
	[Export] private AudioStreamPlayer2D closeSfx;

	public override void _Ready()
	{
		BodyEntered += onBodyEntered;
		BodyExited += onBodyExited;
	}

	private void onBodyEntered(Node2D _body)
	{
		colorRect.Size = textLabel.Size;
		colorRect.Position = textLabel.Position;
		colorRect.Scale = textLabel.Scale;

		messageNode.Show();

		animationPlayer.Play("in");
		openSfx.Play();
	}

	private void onBodyExited(Node2D _body)
	{
		messageNode.Hide();
		animationPlayer.Play("out");
		closeSfx.Play();
	}
}
