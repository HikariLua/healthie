using Godot;
using Godot.Collections;

public partial class TransitionScreen : CanvasLayer
{
    [Signal] public delegate void TransitionCompleteEventHandler();
    [Signal] public delegate void FadeOutedEventHandler();

    [Export] private AnimationPlayer animationPlayer;

    private CharacterBody2D player;

    public override void _Ready()
    {
        animationPlayer.AnimationFinished += onAnimationPlayerAnimationFinished;
    }

    async public void TransitionTo(string path, SceneTree tree)
    {
        animationPlayer.Play("fade_out");

        await ToSignal(animationPlayer, "animation_finished");
        tree.ChangeSceneToFile(path);

        deleteProjectiles();
    }

    async public void TransitionToPacked(PackedScene scene, SceneTree tree)
    {
        animationPlayer.Play("fade_out");

        await ToSignal(animationPlayer, "animation_finished");
        tree.ChangeSceneToPacked(scene);

        deleteProjectiles();
    }

    async public void ReloadScene(SceneTree tree)
    {
        animationPlayer.Play("fade_out");

        await ToSignal(animationPlayer, "animation_finished");
        tree.ReloadCurrentScene();

        deleteProjectiles();
    }

    private void deleteProjectiles()
    {
        Array<Node> nodes = GetTree().GetNodesInGroup("projectile");

        foreach (Node node in nodes)
        {
            node.QueueFree();
        }
    }

    private void onAnimationPlayerAnimationFinished(StringName animName)
    {
        if (animName == "fade_out")
        {
            EmitSignal(SignalName.FadeOuted);
            animationPlayer.Play("fade_in");
        }

        if (animName == "fade_in")
        {
            EmitSignal(SignalName.TransitionComplete);
        }
    }
}
