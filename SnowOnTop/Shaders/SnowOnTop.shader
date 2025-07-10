Shader "Unlit/SnowOnTop"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (0,0,0,0)
        _SnowStart("Snow Start", Range(0,1) ) = 0
        _SnowEnd("Snow End", Range(0,1) ) = 1
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }


        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct MeshData
            {
                float3 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _SnowStart;
            float _SnowEnd;

            v2f vert (MeshData v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                //o.worldNormal =  mul(UNITY_MATRIX_M,float4(v.vertex,1));
                o.uv = v.uv;
                return o;
            }

            float invLerp(float a,float b, float v)
            {
                return (v-a)/(b-a);
            }
            
            float4 frag (v2f i) : SV_Target
            {
                float t = invLerp(_SnowStart,_SnowEnd,i.worldNormal.y);
                t = saturate(t);
                float4 texColor = tex2D(_MainTex,i.uv);
                float4 color = lerp(texColor,_Color,t);
                return color;
            }
            ENDCG
        }
    }
}
