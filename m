Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A3FEEA8
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689347186;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NhAdzRqVaDVvjuIFyaXtqr2FeclLRFcObYE4UtowWCU=;
	b=U+0VuvfxoT3S8ST/l7iAG75TmlEBk0DoTbAMulGfBBi29UviFa1D8AlSuc4a6FGonL2FRG
	v73h4mAwpkqzf7Eh9x8cgCWgXjhUwCu9IvBoZKMI1jKGcjGGZ3BblhWjuqAov8ScZyV1ma
	0Xi3DAGERtfch54tSL1BYq9ulvPDVWo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-F1ByRj6MMmeLIZhPDOBEMA-1; Fri, 14 Jul 2023 11:06:24 -0400
X-MC-Unique: F1ByRj6MMmeLIZhPDOBEMA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7623d5cb0caso266527885a.3
        for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 08:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689347184; x=1689951984;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NhAdzRqVaDVvjuIFyaXtqr2FeclLRFcObYE4UtowWCU=;
        b=iJClbwkhZmkWpqpcvF7PxHEfvzgUEyegUNP5T3drbpyn4utXJ7WMGjMSxV2hMvRcVj
         nClVL06u56VD28gX1fmHAZqdwBD1brdWRQOTk6qCFJnEcjBdLpUcHCiCfIOmeGayTace
         kYGLJLSg7HSuPaKBIDT5bRRi3wwJ1PcezbwEjVRYHJHAKs0teratXpjKrfi07hNF0epZ
         u7OBTGymzbp0KkkgDa2JXKOFER1E0Gr16k4pVr3T+hIoc4W+EPAkEtx3XFPV1Vq5oe4M
         7HUSSHhp/LA+ZXhh21auhhVH2+JKev6mOk8hSkHq2pjG5UeXgQTr/oYvEEtUu3pcJ7Oa
         h+kQ==
X-Gm-Message-State: ABy/qLYJCUECZXOnehR8yX1+8mmsg+pHtQd9CtiuE9QexHvrPXt+u0TN
	OqCyV0UDHhfShonChrtSqHQVkLgfyC/4UrPGRkmXT/8dRHBL+AVyGzjA/VNXHhBEOMnOU7SUqhn
	n9OkQ28iH+bJtagWI
X-Received: by 2002:a05:620a:1a1a:b0:765:87e1:f60b with SMTP id bk26-20020a05620a1a1a00b0076587e1f60bmr6306965qkb.64.1689347184298;
        Fri, 14 Jul 2023 08:06:24 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG5wd7LauXlPfX7A79ukkFzMX+DaIH+H6LmRPp7woUZKMmgdgcjGaSdEv63FDRt/trlBlzgMA==
X-Received: by 2002:a05:620a:1a1a:b0:765:87e1:f60b with SMTP id bk26-20020a05620a1a1a00b0076587e1f60bmr6306938qkb.64.1689347183951;
        Fri, 14 Jul 2023 08:06:23 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id oq25-20020a05620a611900b00767db6f47bbsm3863390qkn.73.2023.07.14.08.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 08:06:23 -0700 (PDT)
Message-ID: <669c82dc-44c1-ef3f-1285-87369c4d7276@redhat.com>
Date: Fri, 14 Jul 2023 17:06:18 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 16/27] KVM: arm64: nv: Add trap forwarding for HCR_EL2
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-17-maz@kernel.org>
 <8c32ebdc-a3bc-aabe-5098-3754159d22cd@redhat.com>
 <86sf9rvmd7.wl-maz@kernel.org> <86ilamvm4y.wl-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <86ilamvm4y.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 7/14/23 12:10, Marc Zyngier wrote:
> On Thu, 13 Jul 2023 16:53:40 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
>> Hey Eric,
>>
>> Thanks for looking into this, much appreciated given how tedious it
>> is.
> FWIW, here are the changes I'm going to squash in that patch. Shout if
> you spot something that looks odd...
>
> Thanks,
>
> 	M.
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index c4057f4ff72d..f5978b463aca 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -55,7 +55,8 @@ enum coarse_grain_trap_id {
>  	CGT_HCR_TERR,
>  	CGT_HCR_APK,
>  	CGT_HCR_NV,
> -	CGT_HCR_NV1,
> +	CGT_HCR_NV_nNV2,
> +	CGT_HCR_NV1_nNV2,
>  	CGT_HCR_AT,
>  	CGT_HCR_FIEN,
>  	CGT_HCR_TID4,
> @@ -89,7 +90,7 @@ enum coarse_grain_trap_id {
>  	CGT_HCR_TVM_TRVM,
>  	CGT_HCR_TPU_TICAB,
>  	CGT_HCR_TPU_TOCU,
> -	CGT_HCR_NV1_ENSCXT,
> +	CGT_HCR_NV1_nNV2_ENSCXT,
>  	CGT_MDCR_TPM_TPMCR,
>  	CGT_MDCR_TDE_TDA,
>  	CGT_MDCR_TDE_TDOSA,
> @@ -154,7 +155,7 @@ static const struct trap_bits coarse_trap_bits[] = {
>  		.mask		= HCR_TSW,
>  		.behaviour	= BEHAVE_FORWARD_ANY,
>  	},
> -	[CGT_HCR_TPC] = {
> +	[CGT_HCR_TPC] = { /* Also called TCPC when FEAT_DPB is implemented */
>  		.index		= HCR_EL2,
>  		.value		= HCR_TPC,
>  		.mask		= HCR_TPC,
> @@ -176,7 +177,7 @@ static const struct trap_bits coarse_trap_bits[] = {
>  		.index		= HCR_EL2,
>  		.value		= HCR_TVM,
>  		.mask		= HCR_TVM,
> -		.behaviour	= BEHAVE_FORWARD_ANY,
> +		.behaviour	= BEHAVE_FORWARD_WRITE,
>  	},
>  	[CGT_HCR_TDZ] = {
>  		.index		= HCR_EL2,
> @@ -209,12 +210,18 @@ static const struct trap_bits coarse_trap_bits[] = {
>  		.behaviour	= BEHAVE_FORWARD_ANY,
>  	},
>  	[CGT_HCR_NV] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_NV,
> +		.mask		= HCR_NV,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_NV_nNV2] = {
>  		.index		= HCR_EL2,
>  		.value		= HCR_NV,
>  		.mask		= HCR_NV | HCR_NV2,
>  		.behaviour	= BEHAVE_FORWARD_ANY,
>  	},
> -	[CGT_HCR_NV1] = {
> +	[CGT_HCR_NV1_nNV2] = {
>  		.index		= HCR_EL2,
>  		.value		= HCR_NV | HCR_NV1,
>  		.mask		= HCR_NV | HCR_NV1 | HCR_NV2,
> @@ -350,7 +357,7 @@ static const enum coarse_grain_trap_id *coarse_control_combo[] = {
>  	MCB(CGT_HCR_TVM_TRVM,		CGT_HCR_TVM, CGT_HCR_TRVM),
>  	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
>  	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
> -	MCB(CGT_HCR_NV1_ENSCXT,		CGT_HCR_NV1, CGT_HCR_ENSCXT),
> +	MCB(CGT_HCR_NV1_nNV2_ENSCXT,	CGT_HCR_NV1_nNV2, CGT_HCR_ENSCXT),
>  	MCB(CGT_MDCR_TPM_TPMCR,		CGT_MDCR_TPM, CGT_MDCR_TPMCR),
>  	MCB(CGT_MDCR_TDE_TDA,		CGT_MDCR_TDE, CGT_MDCR_TDA),
>  	MCB(CGT_MDCR_TDE_TDOSA,		CGT_MDCR_TDE, CGT_MDCR_TDOSA),
> @@ -501,6 +508,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
>  	SR_TRAP(SYS_DC_CIVAC,		CGT_HCR_TPC),
>  	SR_TRAP(SYS_DC_CVAC,		CGT_HCR_TPC),
>  	SR_TRAP(SYS_DC_CVAP,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CVADP,		CGT_HCR_TPC),
>  	SR_TRAP(SYS_DC_IVAC,		CGT_HCR_TPC),
>  	SR_TRAP(SYS_DC_CIGVAC,		CGT_HCR_TPC),
>  	SR_TRAP(SYS_DC_CIGDVAC,		CGT_HCR_TPC),
> @@ -625,7 +633,6 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
>  		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
>  	SR_RANGE_TRAP(sys_reg(3, 5, 12, 0, 0),
>  		      sys_reg(3, 5, 14, 15, 7), CGT_HCR_NV),
> -	SR_TRAP(SYS_SP_EL1,		CGT_HCR_NV),
>  	SR_TRAP(OP_AT_S1E2R,		CGT_HCR_NV),
>  	SR_TRAP(OP_AT_S1E2W,		CGT_HCR_NV),
>  	SR_TRAP(OP_AT_S12E1R,		CGT_HCR_NV),
> @@ -698,10 +705,14 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
>  	SR_TRAP(OP_TLBI_RIPAS2LE1OSNXS,	CGT_HCR_NV),
>  	SR_TRAP(OP_TLBI_RVAE2OSNXS,	CGT_HCR_NV),
>  	SR_TRAP(OP_TLBI_RVALE2OSNXS,	CGT_HCR_NV),
> -	SR_TRAP(SYS_VBAR_EL1,		CGT_HCR_NV1),
> -	SR_TRAP(SYS_ELR_EL1,		CGT_HCR_NV1),
> -	SR_TRAP(SYS_SPSR_EL1,		CGT_HCR_NV1),
> -	SR_TRAP(SYS_SCXTNUM_EL1,	CGT_HCR_NV1_ENSCXT),
> +	SR_TRAP(OP_CPP_RCTX, 		CGT_HCR_NV),
> +	SR_TRAP(OP_DVP_RCTX, 		CGT_HCR_NV),
> +	SR_TRAP(OP_CFP_RCTX, 		CGT_HCR_NV),
> +	SR_TRAP(SYS_SP_EL1,		CGT_HCR_NV_nNV2),
> +	SR_TRAP(SYS_VBAR_EL1,		CGT_HCR_NV1_nNV2),
> +	SR_TRAP(SYS_ELR_EL1,		CGT_HCR_NV1_nNV2),
> +	SR_TRAP(SYS_SPSR_EL1,		CGT_HCR_NV1_nNV2),
> +	SR_TRAP(SYS_SCXTNUM_EL1,	CGT_HCR_NV1_nNV2_ENSCXT),
>  	SR_TRAP(SYS_SCXTNUM_EL0,	CGT_HCR_ENSCXT),
>  	SR_TRAP(OP_AT_S1E1R, 		CGT_HCR_AT),
>  	SR_TRAP(OP_AT_S1E1W, 		CGT_HCR_AT),
>
Looks good to me. Feel free to add my
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

