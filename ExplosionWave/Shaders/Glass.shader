Shader "Holistic/Glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_ScaleUV ("Scale", Range(1,20)) = 1
		
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent"}
		GrabPass{}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			 #define TAU 6.283185307179586

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
				float2 uvbump : TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _ScaleUV;


			 float GetWave(float2 uv)
            {
                float2 uvCentered= uv*2-1;
                float4 radialDistance = length(uvCentered);
			 	//return radialDistance;
                float4 wave = cos(radialDistance*TAU*2-_Time.y*5)*0.5+0.5;
                wave *= .9-radialDistance;
                return wave;
            }
			
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uvgrab.xy = (float2(o.vertex.x, -1*o.vertex.y) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				o.uv = TRANSFORM_TEX( v.uv, _MainTex );
				o.uvbump = TRANSFORM_TEX( v.uv, _BumpMap );
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				
				//float bump = UnpackNormal(tex2D( _BumpMap, i.uvbump )).rg;
				float bump = GetWave(i.uv);

				//return float4(bump.xxxx);
				float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
				i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
				
				fixed4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				fixed4 tint = tex2D(_MainTex, i.uv);
				col *= tint;
				return col;
			}
			ENDCG
		}
	}
}

