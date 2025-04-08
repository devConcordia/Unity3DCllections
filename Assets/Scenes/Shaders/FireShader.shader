Shader "Hidden/FireShader"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        //Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			
            //sampler2D _MainTex;
			float iTime;
			
			
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
                o.uv = v.uv;
                return o;
            }

			
			
			float rand(float2 n) {
				return frac( sin(cos(dot( n, float2(12.9898,12.1414) ))) * 83758.5453 );
			}

			float noise(float2 n) {
				const float2 d = float2(0.0, 1.0);
				float2 b = floor(n);
				float2 f = smoothstep( float2(0.0, 0.0), float2(1.0, 1.0), frac(n) );
				return lerp(lerp(rand(b), rand(b + d.yx), f.x), lerp(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
			}

			float fbm( float2 n ) {
				float total = 0.0, amplitude = 1.0;
				for( int i = 0; i <5; i++ ) {
					total += noise(n) * amplitude;
					n += n*1.7;
					amplitude *= 0.47;
				}
				return total;
			}

			
			
			
            fixed4 frag (v2f i) : SV_Target {
			
                //fixed4 col = tex2D(_MainTex, i.uv);
                //// just invert the colors
                //col.rgb = 1 - col.rgb;
                //return col;
				
				const float3 c1 = float3(0.5, 0.0, 0.1);
				const float3 c2 = float3(0.9, 0.1, 0.0);
				const float3 c3 = float3(0.2, 0.1, 0.7);
				const float3 c4 = float3(1.0, 0.9, 0.1);
				const float3 c5 = float3(0.1, 0.1, 0.1);
				const float3 c6 = float3(0.9, 0.9, 0.9);

				float2 speed = float2(0.1, 0.9);
				float shift = 1.327 + sin(iTime*2.0)/2.4;
				
				float dist = 3.5 - sin(iTime*0.4)/1.89;
				
				float2 uv = i.uv;
				float2 p = uv * dist; // / iResolution.xx;
				
				p += sin(p.yx*4.0+float2(.2,-.3)*iTime)*0.04;
				p += sin(p.yx*8.0+float2(.6,+.1)*iTime)*0.01;
				p.x -= iTime/1.1;
				
				float q = fbm(p - iTime * 0.3+1.0*sin(iTime+0.5)/2.0);
				float qb = fbm(p - iTime * 0.4+0.1*cos(iTime)/2.0);
				float q2 = fbm(p - iTime * 0.44 - 5.0*cos(iTime)/2.0) - 6.0;
				float q3 = fbm(p - iTime * 0.9 - 10.0*cos(iTime)/15.0)-4.0;
				float q4 = fbm(p - iTime * 1.4 - 20.0*sin(iTime)/14.0)+2.0;
				
				q = (q + qb - .4 * q2 -2.0*q3  + .6*q4)/3.8;
				
				float2 r = float2(fbm(p + q /2.0 + iTime * speed.x - p.x - p.y), fbm(p + q - iTime * speed.y));
				float3 c = lerp(c1, c2, fbm(p + r)) + lerp(c3, c4, r.x) - lerp(c5, c6, r.y);
				
				
				float3 color = float3( 1.0/(pow(c+1.61,float3(4.0,4.0,4.0))) * cos(shift * uv.y));
				
				color = float3(1.0,.2,.05)/(pow((r.y+r.y)* max(.0,p.y)+0.1, 4.0));;
			   
				color += (0.01*pow((r.y+r.y)*.65,5.0)+0.055)*lerp( float3(.9,.4,.3),float3(.7,.5,.2), uv.y);
				
				color = color/(1.0+max(float3(0,0,0),color));
				return float4(color.x, color.y, color.z, 1.0);
				
				
            }
            ENDCG
        }
    }
}
