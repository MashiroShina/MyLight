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
		CGPROGRAM
		#pragma vertex MyVertexProgram
		#pragma fragment MyFragmentProgram

		#include "UnityCG.cginc"

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
		i.normal=v.normal;
		//i.uv = v.uv*_MainTex_ST.xy+_MainTex_ST.zw;  ==  TRANSFORM_TEX(v.uv, _MainTex);
		return i;
		}

		float4 MyFragmentProgram(Interpolators i):SV_TARGET
		{
		return float4(i.normal*0.5+0.5,1);
		//return float4(i.uv,1,1);
		//return float4(i.localPosition+0.5,1);////Because negative colors get clamped to zero, our sphere ends up rather dark. As the default sphere has an object-space radius of ½, the color channels end up somewhere between −½ and ½. We want to move them into the 0–1 range, which we can do by adding ½ to all channels.
		}
		
		ENDCG
		}
	
	}
}
