Shader "Clip/Plane" {
    Properties {
    
      _PlanePoint ("Plane Point", Vector) = (0,0,0,0)
      _PlaneNormal ("Plane Normal", Vector) = (1,0,0,0)
      
      _ConvertEmission ("Convert Emission", Range(0,1)) = 0.5
      _ConvertDistance ("Conversion Distance", float) = 0.5
      _Conversion ("Conversion (RGB)", 2D) = "white" {}
    
      _MainTex ("Main Texture", 2D) = "white" {}
      _BumpMap ("Bumpmap", 2D) = "bump" {}
      
      _Glossiness ("Smoothness", Range(0,1)) = 0.5
	  _Metallic ("Metallic", Range(0,1)) = 0.0
	  
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
      Cull Off
      CGPROGRAM
      // Physically based Standard lighting model, and enable shadows on all light types
	  #pragma surface surf Standard fullforwardshadows

	  // Use shader model 3.0 target, to get nicer looking lighting
	  #pragma target 3.0
		
      struct Input {
          float2 uv_MainTex;
          float2 uv_BumpMap;
          float2 uv_Conversion;
          float3 worldPos;
      };

      half _Glossiness;
	  half _Metallic;
	  half _ConvertDistance;
	  half _ConvertEmission;
	  
      float3 _PlanePoint;
      float3 _PlaneNormal;
      
      sampler2D _MainTex;
      sampler2D _BumpMap;
      sampler2D _Conversion;
      
      
      void surf (Input IN, inout SurfaceOutputStandard o) {
      
         //clip (frac((IN.worldPos.y+IN.worldPos.z*0.1) * 5) - 0.5);
         // clip ( distance( IN.worldPos, _Point) - _Distance);
         
         _PlaneNormal = normalize(_PlaneNormal);
          
          half dist = (IN.worldPos.x * _PlaneNormal.x) + (IN.worldPos.y * _PlaneNormal.y) + (IN.worldPos.z * _PlaneNormal.z)
        - (_PlanePoint.x * _PlaneNormal.x) - (_PlanePoint.y * _PlaneNormal.y) - (_PlanePoint.z * _PlaneNormal.z) 
        / sqrt( pow(_PlaneNormal.x, 2) + pow(_PlaneNormal.y, 2) + pow(_PlaneNormal.z,2));
          
          // distance from plane
          clip(dist);
          
          
          // min = 0 // value = dist // max = _ConvertDistance
          float convert_mask = dist / _ConvertDistance;
		  convert_mask = clamp(convert_mask, 0, 1);
          
          fixed4 albedo = tex2D (_MainTex, IN.uv_MainTex);
          albedo *= convert_mask;
          
          fixed4 convert = tex2D (_Conversion, IN.uv_Conversion);
          convert *= 1.0 - convert_mask;
          
          o.Albedo = albedo.rgb + convert.rgb;
          o.Emission = convert.rgb * _ConvertEmission;
          o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
          o.Metallic = _Metallic;
		  o.Smoothness = _Glossiness;
		  o.Alpha = albedo.a + convert.a;
          
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }