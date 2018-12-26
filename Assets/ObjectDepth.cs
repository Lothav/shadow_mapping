using UnityEngine;

[ExecuteInEditMode]
public class ObjectDepth : MonoBehaviour
{
	public RenderTexture depthTexture;
	public Camera camera;
	
	// Update is called once per frame
	void Update ()
	{
		var M = camera.transform.localToWorldMatrix;
		var V = camera.GetComponent<Camera>().worldToCameraMatrix;
		var P = camera.GetComponent<Camera>().projectionMatrix;
        
		var rend = gameObject.GetComponent<Renderer>();
		rend.sharedMaterial.SetMatrix("_ShadowMapMVP", P*V*M);
		rend.sharedMaterial.SetTexture("_DepthTexture", depthTexture);
	}
}
