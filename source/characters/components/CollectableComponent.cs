using Godot;

public partial class CollectableComponent : Node
{
    [Export] public double SequenceDuration = 5;
    [Export] public Timer SequenceTimer;

    [Export] private Area2D interactBox;
    [Export] private AudioStreamPlayer2D pickupSfx;
    [Export] private AnimationPlayer effect;
    [Export] private StateMachine stateMachine;

    public int CollectedFood = 0;
    public int CollectSequence = 0;

    public override void _Ready()
    {
        interactBox.AreaEntered += OnInteractBoxAreaEntered;
        SequenceTimer.Timeout += OnSequenceTimerTimeout;
    }

    public void OnInteractBoxAreaEntered(Area2D _area)
    {
        CollectedFood += 1;
        CollectSequence += 1;

        pickupSfx.Play();
        effect.Play("hit");

        if (CollectSequence >= 7)
        {
            stateMachine.TransitionState("PlayerStateDie");
            return;
        }

        SequenceTimer.Start(SequenceDuration);
    }

    private void OnSequenceTimerTimeout()
    {
        CollectSequence = 0;
    }
}
