Shader "Unlit/ShadowMapping"
{
	Properties
	{
		_DepthTexture("Texture", 2D) = "black" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float2 uv       : TEXCOORD0;
				float4 vertex   : POSITION;
			};

			struct v2f
			{
				float2 uv           : TEXCOORD0;
				float4 vertex       : SV_POSITION;
				float3 shadowCoord  : TEXCOORD1;
			};

            sampler2D _DepthTexture;
            float4x4  _ShadowMapMVP;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.uv = v.uv;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.shadowCoord = mul(_ShadowMapMVP, v.vertex).xyz;
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
			    float shadowMap_z = tex2D(_DepthTexture, i.shadowCoord.xy).z;
			    
			    if (shadowMap_z > i.shadowCoord.z){
                    return fixed4(0, 0, 0, 1);			    
                }
			    
				return fixed4(1, 1, 1, 1);
			}
			ENDCG
		}
	}
}
