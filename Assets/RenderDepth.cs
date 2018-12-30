using UnityEngine;
 
[ExecuteInEditMode]
public class RenderDepth : MonoBehaviour
{
    public Material material;
    private Camera cam;

    public void Awake()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            Debug.Log("System doesn't support image effects");
            enabled = false;
            return;
        }

        // Retrieve camera component
        cam = GetComponent<Camera>();
        // turn on depth rendering for the camera so that the shader can access it via _CameraDepthTexture
        cam.depthTextureMode = DepthTextureMode.Depth;
    }
     
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_DepthLevel", 1);
            //Graphics.Blit(src, dest, material);
            
            var V = cam.worldToCameraMatrix;
            var P = cam.projectionMatrix;

            var bias_mat = new Matrix4x4(
                new Vector4(0.5f, 0.0f, 0.0f, 0.0f),
                new Vector4(0.0f, 0.5f, 0.0f, 0.0f),
                new Vector4(0.0f, 0.0f, 0.5f, 0.0f),
                new Vector4(0.5f, 0.5f, 0.5f, 1.0f)
            );
            
            var light_space = bias_mat*P*V;
            
            material.SetMatrix("_CameraLightSpace", light_space);
        }
    }
}