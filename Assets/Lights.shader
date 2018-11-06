// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Lights"
{
	Properties {
	_Tint ("Tint", Color) = (1, 1, 1, 1)
	_MainTex("Texture",2D)="white"{}
	}
	SubShader{
		Pass{
		Tags{
		  "LightMode" = "ForwardBase"
		}
		CGPROGRAM
		#pragma vertex MyVertexProgram
		#pragma fragment MyFragmentProgram

		#include "UnityCG.cginc"
		 #include "UnityStandardBRDF.cginc"

		float4 _Tint;
		sampler2D _MainTex;
		float4 _MainTex_ST;

		struct VertexData {
		float4 position : POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : NORMAL;
		};

		struct Interpolators {
		float4 position:SV_POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : TEXCOORD1;
		};

		Interpolators MyVertexProgram(VertexData v)
		{
		Interpolators i;
		i.position = UnityObjectToClipPos(v.position);
		i.uv = TRANSFORM_TEX(v.uv, _MainTex);
		//i.uv = v.uv*_MainTex_ST.xy+_MainTex_ST.zw;  ==  TRANSFORM_TEX(v.uv, _MainTex);
		//i.normal=mul(transpose((float3x3)unity_WorldToObject),v.normal);//UnityObjectToWorldNormal(v.normal);
		i.normal=UnityObjectToWorldNormal(v.normal);
	
		return i;
		}

		float4 MyFragmentProgram(Interpolators i):SV_TARGET
		{
		i.normal=normalize(i.normal);
		float3 lightDir=_WorldSpaceLightPos0.xyz;
		float3 lightColor = _LightColor0.rgb;
		float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
		float3 diffuse=albedo*lightColor*DotClamped(lightDir, i.normal);

		return float4(diffuse,1);
		//return max(0, dot(float3(0,1,0),i.normal));
		}
		
		ENDCG
		}
	
	}
}
