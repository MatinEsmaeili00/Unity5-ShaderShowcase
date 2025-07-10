Shader "Unlit/CustomColorGradient"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _ColorA ("Color A",Color) = (0,0,0,1)
        _ColorB ("Color B",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue"="Geometry" // render order
             }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            float4 _ColorA;
            float4 _ColorB;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 coords = i.uv*2-1;
                float distanceCenter = frac(length(coords)-_Time.y);
                float4 color = lerp(_ColorA,_ColorB,distanceCenter);
                return color;
            }
            ENDCG
        }
    }
}
