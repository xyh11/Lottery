Shader "Unlit/Glass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" { }
        _BumpMap("BunpMap", 2D) = "while" { }
        _BumpScale("BumpScale", Range(0, 2)) = 0.5
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
        _CubeMap("CubeMap", Cube) = "_Skybox" { }
        _DisturbionInstensity("DisturbionInstensity", Range(0, 100)) = 0.5  //���ҳ̶�
        _RefrationAmount("RefrationAmount", range(0, 1)) = 0.5//�����Ŷ��̶�
    }
        SubShader
        {
            //������Ⱦ˳��Ϊ�����Ⱦ������ץ������Ļͼ������������������Ⱦ��ɺ��ͼ��
            Tags { "RenderType" = "Opaque" "Queue" = "Overlay" }
            LOD 100

            //����ץ��ͨ��  {"_GrabPassTexture"}  ��ʾץ�������ƣ����������ץ�������ƣ�ֻ����shader��������һ�£�Unity���Զ���ץ����ͼ����䵽����������_GradaPss��
            //�������дץ�������ƣ���ôUnity�ͻ�Ĭ��ʹ��_GrabTexture���б���
            GrabPass
            {
                "_GrabPassTexture"
            }

            Pass
            {
                CGPROGRAM

                #pragma vertex vert
                #pragma fragment frag


                #include "UnityCG.cginc"
                #include "Lighting.cginc"

                struct v2f
                {
                    float4 vertex: SV_POSITION;
                    float4 uv: TEXCOORD0;
                    float4 temp1: TEXCOORD1;
                    float4 temp2: TEXCOORD2;
                    float4 temp3: TEXCOORD3;
                    float4 srcPos: TEXCOORD4;
                };

                sampler2D _MainTex;
                fixed4 _MainTex_ST;
                sampler2D _BumpMap;

                fixed4 _BumpMap_ST;
                float _BumpScale;
                float4 _Diffuse;
                samplerCUBE _CubeMap;
                fixed _DisturbionInstensity;
                fixed _RefrationAmount;
                //ץ��Texture����
                sampler2D _GrabPassTexture;

                fixed4 GrabPass_TexelSize;
                v2f vert(appdata_full v)
                {
                    //o.uv = TRANSFORM_TEX(v.uv, _GrabPassTexture);
                    //��Ϊ�����õ���ͼƬ�Ƿ��������������﷭תX��
                    //o.uv.x=1-o.uv.x;
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);//��ȡ����ͼUV
                    o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);//��ȡ������ͼUV
                    //������Ļ�ռ�
                    o.srcPos = ComputeGrabScreenPos(o.vertex);

                    float3 WorldPos = mul(unity_ObjectToWorld, v.vertex).xyz;//��ȡ��������
                    float3 worldNormal = UnityObjectToWorldNormal(v.normal);//��ȡ���編��
                    float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz); //��ȡ����
                    float3 WorldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;//��ȡ������

                    //���аڷŵõ������߿ռ䵽����ռ����ת����
                    o.temp1 = float4(worldTangent.x, WorldBinormal.x, worldNormal.x, WorldPos.x);
                    o.temp2 = float4(worldTangent.y, WorldBinormal.y, worldNormal.y, WorldPos.y);
                    o.temp3 = float4(worldTangent.z, WorldBinormal.z, worldNormal.z, WorldPos.z);
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    // sample the texture
                    //fixed4 col = tex2D(_GrabPassTexture, i.uv);
                    //return col;
                    //��������ͼ
                    float3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Diffuse.rgb;

                    //���� ����
                    float3 WorldPos = float3(i.temp1.w, i.temp2.w, i.temp3.w);//��ȡ��������

                    float3 ViewDir = normalize(UnityWorldSpaceViewDir(WorldPos));//��ȡ�ӽ�����

                    //����������ͼ
                    float4 normalPack = tex2D(_BumpMap, i.uv.zw);
                    float3 tangentNormal = UnpackNormal(normalPack); //��ѹ������ͼ
                    tangentNormal.xy *= _BumpScale;//����xy
                    //���߿ռ�ת������������
                    float3 worldTangentNormal = normalize(float3(dot(i.temp1.xyz, tangentNormal), dot(i.temp2.xyz, tangentNormal), dot(i.temp3.xyz, tangentNormal)));

                    //�����Ŷ�ƫ��ֵ
                    fixed2 offest = tangentNormal.xy * _DisturbionInstensity * GrabPass_TexelSize.xy;
                    i.srcPos.xy = offest * i.srcPos.z + i.srcPos.xy;
                    //����GrabPass��������γ��� ��Ϊ�ü��ռ䲢û�н�����γ���������Ҫ�ֶ��������Ȼ�õ��Ļ����ܹ�
                    fixed3 refraColor = tex2D(_GrabPassTexture, i.srcPos.xy / i.srcPos.w);

                    //fixed3 refraColor2 = texCUBE(_CubeMap,refract(-ViewDir,worldTangentNormal,_DisturbionInstensity)).rgb; 

                    //����CubeMap  ����
                    fixed3 refColor = texCUBE(_CubeMap, reflect(-ViewDir, worldTangentNormal)).rgb;
                    //�����ɫ  ������Ϊ0 ʱ��ʾ����+��������
                    fixed3 color = ((1 - _RefrationAmount) * refColor + refraColor * _RefrationAmount) * albedo;
                    //�����ʽ�������Ӳ����ĺ�ȣ��ò����������ԣ����׶˻���һЩ�����е�����Ķ������������ֻ׷�������Ŷ�������ʹ�ã����Ƕ���Ч����
                    //fixed3 color = ((1-_RefrationAmount)*refColor   +refraColor*_RefrationAmount +(1-_RefrationAmount*refraColor) )*albedo ; 
                    return fixed4(color, 1);
                }
                ENDCG

            }
        }
}