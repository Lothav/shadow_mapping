using UnityEngine;
 
[ExecuteInEditMode]
public class RenderDepth : MonoBehaviour
{
    [Range(0f, 3f)]
    public float depthLevel = 0.5f;
     
    public Material material;

    private void Awake()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            Debug.Log("System doesn't support image effects");
            enabled = false;
            return;
        }

        // turn on depth rendering for the camera so that the shader can access it via _CameraDepthTexture
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
     
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_DepthLevel", depthLevel);
            Graphics.Blit(src, dest, material);   
        }
    }
}