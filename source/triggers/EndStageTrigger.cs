using Godot;

public partial class EndStageTrigger : Area2D
{
	[Export] private int requierdHealth = 85;
	[Export] private int nextLevelIndex;
	[Export] private AudioStreamPlayer2D clearSfx;
	[Export] private AudioStreamPlayer2D extraClearSfx;
	[Export] private PackedScene endStageScreen;

	private TransitionScreen transitionScreen;

	private int health = 100;
	private CharacterBody2D player;

	private int finalHealth;
	private string result;
	private string plus;


	public override void _Ready()
	{
		transitionScreen = GetNode<TransitionScreen>("/root/TransitionScreen");
		BodyEntered += onBodyEntered;
	}

	async private void onBodyEntered(Node2D body)
	{
		player = body as CharacterBody2D;

		HealthComponent healthComponent = player.GetNode<HealthComponent>(
			"Components/HealthComponent"
		);

		StateMachine stateMachine = player.GetNode<StateMachine>(
			"StateMachine"
		);

		player.GetNode<CollisionShape2D>("Interactbox/CollisionShape2D")
			.SetDeferred("disabled", true);

		stateMachine.SetPhysicsProcess(false);

		int playerFood = player
			.GetNode<CollectableComponent>("Components/CollectibleComponent")
			.CollectedFood;

		finalHealth = health - playerFood;

		if (finalHealth < requierdHealth)
		{
			result = "Fail";

			showScreen();
			await ToSignal(GetTree().CreateTimer(6), "timeout");
			stateMachine.TransitionState("PlayerStateDie");
		}
		else if (finalHealth >= requierdHealth + 8)
		{
			result = "Extra Success";
			plus = "+2 Lifes";
			healthComponent.Lives += 2;
			extraClearSfx.Play();

			showScreen();
			await ToSignal(GetTree().CreateTimer(6), "timeout");
			nextLevel();
		}
		else
		{
			result = "Success";
			plus = "+1 Lifes";
			healthComponent.Lives += 1;
			showScreen();
			clearSfx.Play();

			await ToSignal(GetTree().CreateTimer(6), "timeout");
			nextLevel();
		}
	}

	private void nextLevel()
	{
		transitionScreen.TransitionTo("to refactor", GetTree());
	}

	private void showScreen()
	{
		CanvasLayer endScreen = endStageScreen.Instantiate() as CanvasLayer;

		// endScreen.requierd.text = "Requierd Health: " + str(requierd_health);
		// endScreen.final.text = "Final Health: " + str(final_health);
		// endScreen.result.text = result;
		// endScreen.plus.text = plus;
		GetTree().Root.AddChild(endScreen);
	}
}
