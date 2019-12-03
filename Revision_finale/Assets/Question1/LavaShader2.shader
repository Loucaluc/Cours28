Shader "Custom/LavaShader2" {
	Properties{
		_LavaTexture("Albedo (RGB)", 2D) = "white" {}
		_RockTexture("Texture de roche", 2D) = "white" {}
		_ScrollSpeed("Scroll Speed", Range(1,100)) = 10
		_DisplacementFactor("Displacement", Range(0, 1.0)) = 0.3
		_DispTexture("Texture de displacement", 2D) = "white" {}
	}
		SubShader{
			Tags {"RenderType"="Opaque"}
			LOD 200
			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows vertex:disp 

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _LavaTexture;
			sampler2D _RockTexture;
			sampler2D _DispTexture;


			fixed4 _Color;
			half _ScrollSpeed;
			half _DisplacementFactor;

			struct Input {
				float2 uv_LavaTexture;
				float2 uv_RockTexture;
				float2 uv_DispTexture;
			};

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			void disp(inout appdata v) {
				float splat = tex2Dlod(_DispTexture, float4(v.texcoord.xy, 0, 0)).r * _DisplacementFactor;
				v.vertex.xyz -= v.normal * splat;
				v.vertex.xyz += v.normal * _DisplacementFactor;
			}

			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {
				// Albedo comes from a texture tinted by color
				fixed2 scolledUV = IN.uv_LavaTexture;
				fixed scrollValue = _Time * _ScrollSpeed;
				scolledUV += fixed2(scrollValue, 0);
				scrollValue = _Time * _ScrollSpeed / 3;
				fixed2 scolledUV2 = IN.uv_LavaTexture + fixed2(scrollValue, 0);
				fixed4 c = tex2D(_LavaTexture, scolledUV) - 2.5 * tex2D(_RockTexture, IN.uv_RockTexture);
				o.Albedo = c.rgb;
				o.Alpha = c.rgb;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
