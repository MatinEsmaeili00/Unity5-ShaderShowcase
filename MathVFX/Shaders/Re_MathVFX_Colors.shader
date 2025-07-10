    Shader "Unlit/Re_MathVFX_Colors"
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
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
     

        
        
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

            v2f vert (appdata v)
            {
                v2f o;
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
                // float outputColor1 = frac(abs(i.uv*4-2));
                // float outputColor2 = abs(frac(i.uv*_Scale)*2-1);

                
                float y = cos(i.uv.x*TAU*5+_Time.y*10)*0.01;    
                float trigonometry = cos((i.uv.y+y-_Time.y*0.3)*TAU*_LineNumber)*0.5+0.5;

                float4 result01 = lerp(_ColorA,_ColorB,trigonometry);
                //return result01;
                float4 result02 = 1-i.uv.y*_Scale;
                float4 result = result01*result02;

                return  result ;
                
                

                 //float4 outColor = lerp(_ColorA,_ColorB,(i.uv.x+_Offset)*_Scale);
                 //return float4(outColor);
                
            }
            ENDCG
        }
    }
}
