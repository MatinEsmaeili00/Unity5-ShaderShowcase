    Shader "Unlit/Re_VertexOffcet"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ColorA ("Color", Color) = (1,1,1,1)
         _ColorB ("Color", Color) = (0,0,0,1)
        _Scale ("UV Scale", Float) = 1
        _Offset ("UV Offset", float) = 0
        _ColorStart ("Color Start", Range(0,1)) =0
        _ColorEnd ("Color End", Range(0,1)) =1
        _LineNumber ("Number of lines", float) = 1
        _WaveAmp ("Wave Amplitiude",Range(0.0,0.2)) = 0.01
        
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue"="Geometry"
            
            
        }
     

        
        
        Pass
        {
            
            //Blend One One
             
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           
            #include "UnityCG.cginc"

            #define TAU 6.283185307179586
            
            struct appdata
            {
                float4 vertex : POSITION;
                //float2 uv : TEXCOORD0;
                float3 normal :NORMAL;

                float2 uv0 :TEXCOORD0;

               
            };

            struct v2f
            {
                float3 normal : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 uv :TEXCOORD1;
                
            };

            sampler2D _MainTex;
            //float4 _MainTex_ST;

            float4 _ColorA;
            float4 _ColorB;
            float _Scale;
            float _Offset;
            float _ColorStart;
            float _ColorEnd;
            float _LineNumber;
            float _WaveAmp;


            float GetWave(float2 uv)
            {
                float2 uvCentered= uv*2-1;
                float4 radialDistance = length(uvCentered);
                float4 wave = cos(radialDistance*TAU*5-_Time.y*5)*0.5+0.5;
                wave *= 1-radialDistance;
                return wave;
            }

            v2f vert (appdata v)
            {
                v2f o;

                float wave = cos(v.uv0.x*TAU*5-_Time.y*5);
                float wave2 = sin(v.uv0.y*TAU*5-_Time.y*5);
                //v.vertex.y = wave*wave2*_WaveAmp;

                v.vertex.y = GetWave(v.uv0)*_WaveAmp;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.normal = v.normal;
                o.normal = UnityObjectToWorldNormal(v.normal);

              

                
                
                o.uv = v.uv0;
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);

            }

            fixed4 frag (v2f i) : SV_Target
            {
                return GetWave(i.uv);
            }
            ENDCG
        }
    }
}
