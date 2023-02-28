Shader "Unlit/Glass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" { }
        _BumpMap("BunpMap", 2D) = "while" { }
        _BumpScale("BumpScale", Range(0, 2)) = 0.5
        _Diffuse("Diffuse", Color) = (1, 1, 1, 1)
        _CubeMap("CubeMap", Cube) = "_Skybox" { }
        _DisturbionInstensity("DisturbionInstensity", Range(0, 100)) = 0.5  //扰乱程度
        _RefrationAmount("RefrationAmount", range(0, 1)) = 0.5//折射扰动程度
    }
        SubShader
        {
            //设置渲染顺序为最后渲染，这样抓到的屏幕图形则是在所有物体渲染完成后的图像
            Tags { "RenderType" = "Opaque" "Queue" = "Overlay" }
            LOD 100

            //定义抓屏通道  {"_GrabPassTexture"}  表示抓屏的名称，如果声明的抓屏的名称，只需在shader中在声明一下，Unity会自动把抓屏的图形填充到我们声明的_GradaPss中
            //如果不填写抓屏的名称，那么Unity就会默认使用_GrabTexture进行保存
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
                //抓屏Texture属性
                sampler2D _GrabPassTexture;

                fixed4 GrabPass_TexelSize;
                v2f vert(appdata_full v)
                {
                    //o.uv = TRANSFORM_TEX(v.uv, _GrabPassTexture);
                    //因为采样得到的图片是反的所以我们这里翻转X轴
                    //o.uv.x=1-o.uv.x;
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);//获取主贴图UV
                    o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);//获取法线贴图UV
                    //计算屏幕空间
                    o.srcPos = ComputeGrabScreenPos(o.vertex);

                    float3 WorldPos = mul(unity_ObjectToWorld, v.vertex).xyz;//获取世界坐标
                    float3 worldNormal = UnityObjectToWorldNormal(v.normal);//获取世界法线
                    float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz); //获取切线
                    float3 WorldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;//获取副切线

                    //按列摆放得到从切线空间到世界空间的旋转矩阵
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
                    //采样主贴图
                    float3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Diffuse.rgb;

                    //解析 参数
                    float3 WorldPos = float3(i.temp1.w, i.temp2.w, i.temp3.w);//获取世界坐标

                    float3 ViewDir = normalize(UnityWorldSpaceViewDir(WorldPos));//获取视角向量

                    //采样法线贴图
                    float4 normalPack = tex2D(_BumpMap, i.uv.zw);
                    float3 tangentNormal = UnpackNormal(normalPack); //解压法线贴图
                    tangentNormal.xy *= _BumpScale;//关联xy
                    //切线空间转换到世界坐标
                    float3 worldTangentNormal = normalize(float3(dot(i.temp1.xyz, tangentNormal), dot(i.temp2.xyz, tangentNormal), dot(i.temp3.xyz, tangentNormal)));

                    //计算扰动偏移值
                    fixed2 offest = tangentNormal.xy * _DisturbionInstensity * GrabPass_TexelSize.xy;
                    i.srcPos.xy = offest * i.srcPos.z + i.srcPos.xy;
                    //采样GrabPass并进行其次除法 因为裁剪空间并没有进行其次除法，我们要手动算出，不然得到的画面会很怪
                    fixed3 refraColor = tex2D(_GrabPassTexture, i.srcPos.xy / i.srcPos.w);

                    //fixed3 refraColor2 = texCUBE(_CubeMap,refract(-ViewDir,worldTangentNormal,_DisturbionInstensity)).rgb; 

                    //采样CubeMap  反射
                    fixed3 refColor = texCUBE(_CubeMap, reflect(-ViewDir, worldTangentNormal)).rgb;
                    //混合颜色  当折射为0 时显示反射+环境反射
                    fixed3 color = ((1 - _RefrationAmount) * refColor + refraColor * _RefrationAmount) * albedo;
                    //这个公式可以增加玻璃的厚度，让玻璃更加明显，但弊端会有一些不该有的折射的东西，所以如果只追求折射扰动，可以使用，算是额外效果。
                    //fixed3 color = ((1-_RefrationAmount)*refColor   +refraColor*_RefrationAmount +(1-_RefrationAmount*refraColor) )*albedo ; 
                    return fixed4(color, 1);
                }
                ENDCG

            }
        }
}