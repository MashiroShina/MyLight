// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Lights"
{
	Properties {
	_Tint ("Tint", Color) = (1, 1, 1, 1)
	_MainTex("Texture",2D)="white"{}
	_SpecularTint ("Specular", Color) = (0.5, 0.5, 0.5)
	_Smoothness ("Smoothness", Range(0, 1)) = 0.5
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
		float _Smoothness;
		float4 _SpecularTint;

		struct VertexData {
		float4 position : POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : NORMAL;
		};

		struct Interpolators {
		float4 position:SV_POSITION;
		float2 uv : TEXCOORD0;
		float3 normal : TEXCOORD1;
		float3 worldPos : TEXCOORD2;
		};

		Interpolators MyVertexProgram(VertexData v)
		{
		Interpolators i;
		i.position = UnityObjectToClipPos(v.position);
		i.worldPos=mul(unity_ObjectToWorld,v.position);
		i.uv = TRANSFORM_TEX(v.uv, _MainTex);
		//i.uv = v.uv*_MainTex_ST.xy+_MainTex_ST.zw;  ==  TRANSFORM_TEX(v.uv, _MainTex);
		//i.normal=mul(transpose((float3x3)unity_WorldToObject),v.normal);//UnityObjectToWorldNormal(v.normal);
		i.normal=UnityObjectToWorldNormal(v.normal);
	
		return i;
		}

		float4 MyFragmentProgram(Interpolators i):SV_TARGET
		{
		i.normal=normalize(i.normal);
		
		float3 viewDir=normalize(_WorldSpaceCameraPos-i.worldPos);
		float3 lightDir=_WorldSpaceLightPos0.xyz;
		float3 lightColor = _LightColor0.rgb;
		float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
		//DotClamped(float3(0,1,0),i.normal)==max(0, dot(float3(0,1,0),i.normal));

		//=================================================diffuse
		//float3 diffuse=albedo*lightColor*DotClamped(lightDir, i.normal);
		//return float4(diffuse + specular, 1);
		//=================================================

		//=================================================reflect
		//float3 reflectionDir = reflect(-lightDir, i.normal);
		//return float4(reflectionDir * 0.5 + 0.5, 1); //debug reflect to NORMAL //reflect= 2*dot(n,l);
		//return DotClamped(viewDir, reflectionDir); 
		//=================================================
		
		//=================================================Blinn-Phong
		//float3 halfVector = normalize(lightDir + viewDir);
		//return pow(
		//			DotClamped(halfVector, i.normal),
		//			_Smoothness * 100
		//);// x^y x=DotClamped(viewDir, reflectionDir) , y=_Smoothness * 100
		//=================================================

		//=================================================specular
		//float3 halfVector = normalize(lightDir + viewDir);
		//float3 specular = _SpecularTint.rgb *lightColor * pow(
		//			DotClamped(halfVector, i.normal),
		//			_Smoothness * 100
		//);
		//return float4(specular, 1);
		//=================================================

		//=================================================diffuse+specular
		float3 halfVector = normalize(lightDir + viewDir);
		float3 diffuse=albedo*lightColor*DotClamped(lightDir, i.normal);
		float3 specular = _SpecularTint.rgb *lightColor * pow(
					DotClamped(halfVector, i.normal),
					_Smoothness * 100
		);
		return float4(diffuse + specular, 1);
		//=================================================



		}
		
		ENDCG
		}
	
	}
}
