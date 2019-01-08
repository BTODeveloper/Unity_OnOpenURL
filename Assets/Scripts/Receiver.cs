using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public sealed class Receiver : MonoBehaviour
{
    public UnityEngine.UI.Text Text = null;

    private List<string> Lines = new List<string>();

    const int LinesMax = 20;

    private void AddLog(string message)
    {
        if (Lines.Count > LinesMax) {
            Lines.RemoveRange(0, Lines.Count - LinesMax);
        }
        var timeStamp = System.DateTime.Now.ToLongTimeString();
        Lines.Add(timeStamp + ": " + message);
        Text.text = string.Join("\n", Lines);
    }

    public void OnOpenURL(string url)
    {
        AddLog(string.Format("OnOpenURL: {0}", url));
    }

    void OnApplicationPause (bool pauseStatus)
	{
		if (!pauseStatus) {
            AddLog("Resumed");
#if UNITY_IOS && !UNITY_EDITOR
            var urlString = NativeBinding.OnOpenURLListener_GetOpenURLString();
            AddLog(string.Format("GetOpenURLString: [{0}]", urlString));
#endif
		}
	}
}
