using Godot;
using Godot.Collections;

public partial class SaveLoad : Node
{
    public Dictionary SavedDict = new Dictionary();

    public void SaveToNextScene(string key, Dictionary dict)
    {
        SavedDict[key] = dict;
    }

    public Dictionary LoadFromPreviousScene(string key)
    {
        return (Dictionary)SavedDict[key];
    }
}
