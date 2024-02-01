using Godot;

public partial class DeathScreen : CanvasLayer
{
	private TransitionScreen transitionScreen;

	public override void _Ready()
	{
		transitionScreen = GetNode<TransitionScreen>("/root/TransitionScreen");

		transitionScreen.TransitionComplete += selfDestroy;
	}

	private void selfDestroy()
	{
		QueueFree();
	}
}
