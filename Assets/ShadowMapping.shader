﻿Shader "Unlit/ShadowMapping"
{
	Properties
	{
		_DepthTexture("Depth Texture", 2D) = "black" {}
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
				float2 uv                   : TEXCOORD0;
				float4 vertex               : SV_POSITION;
				float4 fragPosLightSpace    : TEXCOORD1;
			};

            sampler2D _DepthTexture;
            float4x4 _CameraLightSpace;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.uv                = v.uv;
				o.vertex            = UnityObjectToClipPos(v.vertex);
                
                float4 v_WorldPos   = mul(UNITY_MATRIX_M, v.vertex);
                o.fragPosLightSpace = mul(_CameraLightSpace, v_WorldPos);
				
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
                float3 projCoords = i.fragPosLightSpace.xyz;
                float closestDepth = tex2D(_DepthTexture, projCoords.xy).r; 
                float currentDepth = projCoords.z;
                float shadow = lerp(0.0, 1.0, currentDepth - 0.005 < closestDepth);
			        
			    return shadow;
			}
			ENDCG
		}
	}
}
