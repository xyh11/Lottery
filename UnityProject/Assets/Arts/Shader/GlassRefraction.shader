// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "MyUnlit/GlassRefraction"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
    //����ķ�����ͼ���ڼ������������Ť��
    _BumpMap("Normal Map",2D) = "bump"{}
    //����Ļ�����ͼ���ڷ�����Χ�����Ĳ��ֲ�Ӱ
    _Cubemap("Environment Map",cube) = "_Skybox"{}
    _Distortion("Distortion",range(0,100)) = 10
        //һ������ϵ�������ڿ�������ͷ����ռ��
        _RefractAmount("Refract Amount",range(0,1)) = 1
    }
        SubShader
    {
        //��֤��������Ⱦʱ��������͸�����嶼�Ѿ���Ⱦ���
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent"}
        //ץȡ��ǰ��Ļ����Ⱦͼ�񲢴���ָ������
        GrabPass{"_RefractionTex"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
                float4 tangent:TANGENT;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 scrPos : TEXCOORD4;
                float4 TtoW0:TEXCOORD1;
                float4 TtoW1:TEXCOORD2;
                float4 TtoW2:TEXCOORD3;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            samplerCUBE _Cubemap;
            float _Distortion;
            fixed _RefractAmount;
            sampler2D _RefractionTex;
            float4 _RefractionTex_TexelSize;

            v2f vert(appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv, _BumpMap);
                //�õ���Ļ��������
                o.scrPos = ComputeGrabScreenPos(o.pos);

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 worldBinormal = cross(worldTangent, worldNormal) * v.tangent.w;

                o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldPos = float3(i.TtoW0.w,i.TtoW1.w,i.TtoW2.w);
                float3x3 TtoW = float3x3(i.TtoW0.xyz, i.TtoW1.xyz, i.TtoW2.xyz);

                fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

                fixed3 tanNormal = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
                fixed3 worldNormal = mul(TtoW, tanNormal);
                //�Բɼ�����Ļͼ����й��ڷ��߷����ϵ�Ť����ƫ�ƣ�Ҳ����ģ�������Ч��
                float2 offset = tanNormal.xy * _Distortion * _RefractionTex_TexelSize.xy;
                i.scrPos.xy += offset;
                fixed3 refractCol = tex2D(_RefractionTex, i.scrPos.xy / i.scrPos.w).xyz;
                //��һ������ģ�ⷴ���Ч��������Խǿ��Ҳ����͸���Խ�ͣ�Խ�ܿ�������ͼ�����Լ���Χ��������Ĳ�Ӱ
                fixed3 reflectDir = reflect(-worldViewDir, worldNormal);
                fixed4 mainTexCol = tex2D(_MainTex, i.uv.xy);
                fixed4 cubemapCol = texCUBE(_Cubemap, reflectDir);
                fixed3 reflectCol = mainTexCol.rgb * cubemapCol.rgb;
                //�������ͷ������һ���ۺϵ��ӣ�_RefractAmount������Ϊ��͸���ʣ�����Ϊ1ʱ������ȫ͸����û�з��䣬Ϊ0ʱ����ȫ���������һ��
                fixed3 color = refractCol * _RefractAmount + reflectCol * (1 - _RefractAmount);
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
        fallback "Diffuse"
}