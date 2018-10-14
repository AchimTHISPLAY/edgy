//@author: vux
//@help: template for standard shaders
//@tags: template
//@credits: 

Texture2D texture2d <string uiname="Texture";>;
float2 uvOriginal;
float2 uvTarget;
float2 scaleMinMax;
float4 vectorTest;
float2 minMax;

SamplerState linearSampler : IMMUTABLE
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};
 
cbuffer cbPerDraw : register( b0 )
{
	float4x4 tVP : LAYERVIEWPROJECTION;	
};

cbuffer cbPerObj : register( b1 )
{
	float4x4 tW : WORLD;
	float4 cAmb <bool color=true;String uiname="Color";> = { 1.0f,1.0f,1.0f,1.0f };
};

struct VS_IN
{
	float4 PosO : POSITION;
	float4 TexCd : TEXCOORD0;

};

struct vs2ps
{
    float4 PosWVP: SV_Position;
    float4 TexCd: TEXCOORD0;
};

vs2ps VS(VS_IN input)
{
    vs2ps output;
    output.PosWVP  = mul(input.PosO,mul(tW,tVP));
    output.TexCd = input.TexCd;
    return output;
}




float4 PS(vs2ps In): SV_Target
{

    float4 col = texture2d.Sample(linearSampler,In.TexCd.xy) * cAmb;
    /*
	float2 uv = In.TexCd.xy;
	float2 mapCoords =  lerp (uvOriginal, uvTarget, uv);
	float depth =  lerp(scaleMinMax.x, scaleMinMax.y, col.r); 
	
	float4 final = float4(mapCoords, depth, 1);
	*/
	
	/*
	float4 col = texture2d.Sample(linearSampler,In.TexCd.xy) * cAmb;
    float4 a = float4(-0.1022, -0.0219, 1.0310, 1)  ;
	float4 b = float4(0.5941, -0.0229, 1.0832, 1) ;
	float4 x = float4(-9999999, -9999999, -9999999, 1);
	float4 final = lerp( a, b, col);
	if(final.r = 
	*/
	float2 x = float2(0,0);
	float2 y = float2(1,1);
	float2 uv = float2 (In.TexCd.xy);
	float2 gradient = lerp(x, y, uv);
	float2 heigth = lerp(minMax.x, minMax.y, col.r);
	float4 final = float4(gradient, 1, 1);
	if(col.r != 1)
	{
		final = float4(0,0,0,0);
	}
	
	return final;
}





technique10 Constant
{
	pass P0
	{
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetPixelShader( CompileShader( ps_4_0, PS() ) );
	}
}




