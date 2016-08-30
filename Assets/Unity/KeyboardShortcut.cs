using UnityEngine;
using UnityEngine.UI;

public class KeyboardShortcut : MonoBehaviour
{
    public KeyCode key;
	
	// Update is called once per frame
	internal void Update () {
        if (Input.GetKeyDown(key))
            GetComponent<Button>().onClick.Invoke();
	}
}