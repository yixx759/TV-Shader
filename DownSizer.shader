Shader "Unlit/DownSizer"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        CGINCLUDE
             #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 _MainTex_TexelSize;
        #pragma vertex vert
            #pragma fragment frag
            // make fog work
           float _Threshold, _SoftThreshold;
            sampler2D _Glower;

        
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                
            };

            
          

            v2f vert (appdata v)
            {
                v2f o;
                 o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
              
                return o;
            }
        
            float4 getbrit(float4 col)
            {
                half brightness = max(col.r, max(col.g, col.b));
                half knee = _Threshold * _SoftThreshold;
                half soft = brightness - _Threshold + knee;
                soft = clamp(soft, 0, 2 * knee);
                soft = soft * soft / (4 * knee * 0.00001);
                half contribution = max(soft, brightness - _Threshold);
                contribution /= max(contribution, 0.00001);

                return col * contribution;

                
            }
        
             float4 getblure(float2 uv,float delta)
            {
                float2 del = float2(-delta, delta);
                float4 pos = _MainTex_TexelSize.xyxy * del.xxyy;
                float4 col  =tex2D(_MainTex, uv+pos.xy) + tex2D(_MainTex, uv+pos.xw)+tex2D(_MainTex, uv+pos.zy)+tex2D(_MainTex, uv+pos.zw);
                col *= 0.25;

                return col;
                

                
            }
        ENDCG
        
        
        Pass
        {
            CGPROGRAM
            
             #pragma vertex vert
            #pragma fragment frag
            
            
            
            
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // apply fog
                float4 col = tex2D(_Glower, i.uv); 
                
                
                return float4(col.xyz,1);
            }
            ENDCG
        }
        
        Pass
        {
            CGPROGRAM
            

            
            float del;
            
            
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // apply fog
                
                
                return float4(getblure(i.uv, del).xyz,1);
            }
            ENDCG
        }
        
        Pass
        {
             Blend One One
            CGPROGRAM
           
            #pragma vertex vert
            #pragma fragment frag
            
            float del1;
            

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // apply fog
                
                
                return float4(getblure(i.uv, del1).xyz,1);
            }
            ENDCG
        }
        
        Pass
        {
            CGPROGRAM
            
             #pragma vertex vert
            #pragma fragment frag


           sampler2D _ogtex;

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // apply fog
                float4 col = tex2D(_MainTex, i.uv); 
                float4 col1 = tex2D(_ogtex, i.uv); 
                
                return float4((col+col1).xyz,1);
            }
            ENDCG
        }
        
        
        
        
        
        
    }
}
