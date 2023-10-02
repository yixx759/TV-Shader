Shader "Unlit/DepthTesterMat"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 depth : TEXCOORD1;
                float4 screenpos : TEXCOORD2;
               
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _CameraDepthTexture;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.depth = -(UnityObjectToViewPos(v.vertex).z * _ProjectionParams.w);
                o.screenpos = ComputeScreenPos( o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed2 uv = i.screenpos.xy / i.screenpos.w;
                float4 depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
                depth = Linear01Depth(depth);
                float diff = saturate(i.depth-depth);
                   if (diff > 0.0001)
                {
                    return float4(0,0,0,0);
                }
                
                  return col;
            
                
            }
            ENDCG
        }
    }
}
