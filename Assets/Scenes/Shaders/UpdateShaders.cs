using UnityEngine;

public class UpdateShaders : MonoBehaviour {
	
	
	[SerializeField] private Material smokeMaterial;
	[SerializeField] private Material fireMaterial;
	
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start() {
        
    }

    // Update is called once per frame
    void Update() {
		
		smokeMaterial.SetFloat("iTime", Time.time);
		fireMaterial.SetFloat("iTime", Time.time);
		
    }
}
