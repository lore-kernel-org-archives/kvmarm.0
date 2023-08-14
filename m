Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BCEBA58
	for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692015477;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aXChxHQ1/Bi6hu4HBpoNe1d5uOB9c+b+DjWb1LSg1rU=;
	b=D1Tv3ERbXNn2OaFLHWU1nPe9H4qoWxfebR1uzG97KRAZqHTMF3hVuwbC+EUXg12edpEe3b
	lfA0kAhQRlHv6aUnR3n68ERKOkR/3/jGv0Wj/LqGnHPnSfX/IXRwhprcsMCbuPZMl0oo5W
	s4Qqidc1ACENsOAAaDoI/LdUsJCX2LI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-NIi2pKaMN8q4cRnxYr2mWw-1; Mon, 14 Aug 2023 08:17:53 -0400
X-MC-Unique: NIi2pKaMN8q4cRnxYr2mWw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3178532c6c8so2486800f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Aug 2023 05:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692015472; x=1692620272;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aXChxHQ1/Bi6hu4HBpoNe1d5uOB9c+b+DjWb1LSg1rU=;
        b=MAPnCuLwRrVwyVRj6EkpUNfACG39ekh3wh+K6pDPiJR5CsiQVp1ytH/nEPGXR7zV7O
         EyiCUj0yMd6/FizaFnvi5/unnEJpSB+qZSDEMgEehX90yxDmTIlSY/zr7Xdcw4+d2Oqm
         hq+7AE0tEHaX787S+OINUVrG9OaWhvMnB/CjLK/qofAg6ZAK/3fzI4LKmgV1qMpotMtg
         XgkrfUuSWsHXwMFKtDKGnJiIOXBCgvAJqHKlPLBBZyB1FkCZU6nmednQ7Kl0v4dANNL0
         GNPfXcGXzLtmo54MogvKwCYyD3BiKiMK/4VK/CtK//9y9YfHKeJnhN8OWxHYlJ3bfrFk
         qtgw==
X-Gm-Message-State: AOJu0YxT2Au1RQ+mGHYQL8vo3ObmTHnYjcIus4pcekds8cDPuI//FntP
	p1LvVvrlWuh9Kj65wkB6Icg2NiBxmlG6NfssZcFDpsA0I1ql3Vj2QxkcQ+bo0OCkrHHysLSJzGk
	wPAkN+vtYYvM3b1zN
X-Received: by 2002:adf:dcc3:0:b0:319:735c:73e1 with SMTP id x3-20020adfdcc3000000b00319735c73e1mr3249037wrm.4.1692015472621;
        Mon, 14 Aug 2023 05:17:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/IKihKd7BxzA/CCF3CBxVyGLYCDXKh91VoCNk14O4oY/rxNI9ShzAU/QZmZzWvgneSWo+pA==
X-Received: by 2002:adf:dcc3:0:b0:319:735c:73e1 with SMTP id x3-20020adfdcc3000000b00319735c73e1mr3249009wrm.4.1692015472254;
        Mon, 14 Aug 2023 05:17:52 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id k13-20020a5d428d000000b0030ada01ca78sm14327977wrq.10.2023.08.14.05.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 05:17:51 -0700 (PDT)
Message-ID: <1324af1b-f8ca-c316-4a7c-2ea75a602ffb@redhat.com>
Date: Mon, 14 Aug 2023 14:17:49 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 27/27] KVM: arm64: nv: Add support for HCRX_EL2
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown
 <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Will Deacon <will@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20230808114711.2013842-1-maz@kernel.org>
 <20230808114711.2013842-28-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230808114711.2013842-28-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 8/8/23 13:47, Marc Zyngier wrote:
> HCRX_EL2 has an interesting effect on HFGITR_EL2, as it conditions
> the traps of TLBI*nXS.
>
> Expand the FGT support to add a new Fine Grained Filter that will
> get checked when the instruction gets trapped, allowing the shadow
> register to override the trap as needed.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h        |  5 ++
>  arch/arm64/include/asm/kvm_host.h       |  1 +
>  arch/arm64/kvm/emulate-nested.c         | 94 ++++++++++++++++---------
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++-
>  arch/arm64/kvm/nested.c                 |  3 +-
>  arch/arm64/kvm/sys_regs.c               |  2 +
>  6 files changed, 83 insertions(+), 37 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index d229f238c3b6..137f732789c9 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -369,6 +369,11 @@
>  #define __HDFGWTR_EL2_MASK	~__HDFGWTR_EL2_nMASK
>  #define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
>  
> +/* Similar definitions for HCRX_EL2 */
> +#define __HCRX_EL2_RES0		(GENMASK(63, 16) | GENMASK(13, 12))
> +#define __HCRX_EL2_MASK		(0)
> +#define __HCRX_EL2_nMASK	(GENMASK(15, 14) | GENMASK(4, 0))
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
>  /*
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index cb1c5c54cedd..93c541111dea 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -380,6 +380,7 @@ enum vcpu_sysreg {
>  	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
>  	HSTR_EL2,	/* Hypervisor System Trap Register */
>  	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
> +	HCRX_EL2,	/* Extended Hypervisor Configuration Register */
>  	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
>  	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
>  	TCR_EL2,	/* Translation Control Register (EL2) */
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 4497666db45d..35f2f051af97 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -425,11 +425,13 @@ static const complex_condition_check ccc[] = {
>   * [13:10]	enum fgt_group_id (4 bits)
>   * [19:14]	bit number in the FGT register (6 bits)
>   * [20]		trap polarity (1 bit)
> - * [62:21]	Unused (42 bits)
> + * [25:21]	FG filter (5 bits)
> + * [62:26]	Unused (37 bits)
>   * [63]		RES0 - Must be zero, as lost on insertion in the xarray
>   */
>  #define TC_CGT_BITS	10
>  #define TC_FGT_BITS	4
> +#define TC_FGF_BITS	5
>  
>  union trap_config {
>  	u64	val;
> @@ -438,7 +440,8 @@ union trap_config {
>  		unsigned long	fgt:TC_FGT_BITS; /* Fing Grained Trap id */
>  		unsigned long	bit:6;		 /* Bit number */
>  		unsigned long	pol:1;		 /* Polarity */
> -		unsigned long	unk:42;		 /* Unknown */
> +		unsigned long	fgf:TC_FGF_BITS; /* Fine Grained Filter */
> +		unsigned long	unk:37;		 /* Unknown */
>  		unsigned long	mbz:1;		 /* Must Be Zero */
>  	};
>  };
> @@ -939,7 +942,15 @@ enum fgt_group_id {
>  	__NR_FGT_GROUP_IDS__
>  };
>  
> -#define SR_FGT(sr, g, b, p)					\
> +enum fg_filter_id {
> +	__NO_FGF__,
> +	HCRX_FGTnXS,
> +
> +	/* Must be last */
> +	__NR_FG_FILTER_IDS__
> +};
> +
> +#define SR_FGF(sr, g, b, p, f)					\
>  	{							\
>  		.encoding	= sr,				\
>  		.end		= sr,				\
> @@ -947,9 +958,12 @@ enum fgt_group_id {
>  			.fgt = g ## _GROUP,			\
>  			.bit = g ## _EL2_ ## b ## _SHIFT,	\
>  			.pol = p,				\
> +			.fgf = f,				\
>  		},						\
>  	}
>  
> +#define SR_FGT(sr, g, b, p)	SR_FGF(sr, g, b, p, __NO_FGF__)
> +
>  static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>  	/* HFGRTR_EL2, HFGWTR_EL2 */
>  	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
> @@ -1053,37 +1067,37 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>  	SR_FGT(OP_TLBI_ASIDE1OS, 	HFGITR, TLBIASIDE1OS, 1),
>  	SR_FGT(OP_TLBI_VAE1OS, 		HFGITR, TLBIVAE1OS, 1),
>  	SR_FGT(OP_TLBI_VMALLE1OS, 	HFGITR, TLBIVMALLE1OS, 1),
> -	/* FIXME: nXS variants must be checked against HCRX_EL2.FGTnXS */
> -	SR_FGT(OP_TLBI_VAALE1NXS, 	HFGITR, TLBIVAALE1, 1),
> -	SR_FGT(OP_TLBI_VALE1NXS, 	HFGITR, TLBIVALE1, 1),
> -	SR_FGT(OP_TLBI_VAAE1NXS, 	HFGITR, TLBIVAAE1, 1),
> -	SR_FGT(OP_TLBI_ASIDE1NXS, 	HFGITR, TLBIASIDE1, 1),
> -	SR_FGT(OP_TLBI_VAE1NXS, 	HFGITR, TLBIVAE1, 1),
> -	SR_FGT(OP_TLBI_VMALLE1NXS, 	HFGITR, TLBIVMALLE1, 1),
> -	SR_FGT(OP_TLBI_RVAALE1NXS, 	HFGITR, TLBIRVAALE1, 1),
> -	SR_FGT(OP_TLBI_RVALE1NXS, 	HFGITR, TLBIRVALE1, 1),
> -	SR_FGT(OP_TLBI_RVAAE1NXS, 	HFGITR, TLBIRVAAE1, 1),
> -	SR_FGT(OP_TLBI_RVAE1NXS, 	HFGITR, TLBIRVAE1, 1),
> -	SR_FGT(OP_TLBI_RVAALE1ISNXS, 	HFGITR, TLBIRVAALE1IS, 1),
> -	SR_FGT(OP_TLBI_RVALE1ISNXS, 	HFGITR, TLBIRVALE1IS, 1),
> -	SR_FGT(OP_TLBI_RVAAE1ISNXS, 	HFGITR, TLBIRVAAE1IS, 1),
> -	SR_FGT(OP_TLBI_RVAE1ISNXS, 	HFGITR, TLBIRVAE1IS, 1),
> -	SR_FGT(OP_TLBI_VAALE1ISNXS, 	HFGITR, TLBIVAALE1IS, 1),
> -	SR_FGT(OP_TLBI_VALE1ISNXS, 	HFGITR, TLBIVALE1IS, 1),
> -	SR_FGT(OP_TLBI_VAAE1ISNXS, 	HFGITR, TLBIVAAE1IS, 1),
> -	SR_FGT(OP_TLBI_ASIDE1ISNXS, 	HFGITR, TLBIASIDE1IS, 1),
> -	SR_FGT(OP_TLBI_VAE1ISNXS, 	HFGITR, TLBIVAE1IS, 1),
> -	SR_FGT(OP_TLBI_VMALLE1ISNXS, 	HFGITR, TLBIVMALLE1IS, 1),
> -	SR_FGT(OP_TLBI_RVAALE1OSNXS, 	HFGITR, TLBIRVAALE1OS, 1),
> -	SR_FGT(OP_TLBI_RVALE1OSNXS, 	HFGITR, TLBIRVALE1OS, 1),
> -	SR_FGT(OP_TLBI_RVAAE1OSNXS, 	HFGITR, TLBIRVAAE1OS, 1),
> -	SR_FGT(OP_TLBI_RVAE1OSNXS, 	HFGITR, TLBIRVAE1OS, 1),
> -	SR_FGT(OP_TLBI_VAALE1OSNXS, 	HFGITR, TLBIVAALE1OS, 1),
> -	SR_FGT(OP_TLBI_VALE1OSNXS, 	HFGITR, TLBIVALE1OS, 1),
> -	SR_FGT(OP_TLBI_VAAE1OSNXS, 	HFGITR, TLBIVAAE1OS, 1),
> -	SR_FGT(OP_TLBI_ASIDE1OSNXS, 	HFGITR, TLBIASIDE1OS, 1),
> -	SR_FGT(OP_TLBI_VAE1OSNXS, 	HFGITR, TLBIVAE1OS, 1),
> -	SR_FGT(OP_TLBI_VMALLE1OSNXS, 	HFGITR, TLBIVMALLE1OS, 1),
> +	/* nXS variants must be checked against HCRX_EL2.FGTnXS */
> +	SR_FGF(OP_TLBI_VAALE1NXS, 	HFGITR, TLBIVAALE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VALE1NXS, 	HFGITR, TLBIVALE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAAE1NXS, 	HFGITR, TLBIVAAE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_ASIDE1NXS, 	HFGITR, TLBIASIDE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAE1NXS, 	HFGITR, TLBIVAE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VMALLE1NXS, 	HFGITR, TLBIVMALLE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAALE1NXS, 	HFGITR, TLBIRVAALE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVALE1NXS, 	HFGITR, TLBIRVALE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAAE1NXS, 	HFGITR, TLBIRVAAE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAE1NXS, 	HFGITR, TLBIRVAE1, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAALE1ISNXS, 	HFGITR, TLBIRVAALE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVALE1ISNXS, 	HFGITR, TLBIRVALE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAAE1ISNXS, 	HFGITR, TLBIRVAAE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAE1ISNXS, 	HFGITR, TLBIRVAE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAALE1ISNXS, 	HFGITR, TLBIVAALE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VALE1ISNXS, 	HFGITR, TLBIVALE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAAE1ISNXS, 	HFGITR, TLBIVAAE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_ASIDE1ISNXS, 	HFGITR, TLBIASIDE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAE1ISNXS, 	HFGITR, TLBIVAE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VMALLE1ISNXS, 	HFGITR, TLBIVMALLE1IS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAALE1OSNXS, 	HFGITR, TLBIRVAALE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVALE1OSNXS, 	HFGITR, TLBIRVALE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAAE1OSNXS, 	HFGITR, TLBIRVAAE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_RVAE1OSNXS, 	HFGITR, TLBIRVAE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAALE1OSNXS, 	HFGITR, TLBIVAALE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VALE1OSNXS, 	HFGITR, TLBIVALE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAAE1OSNXS, 	HFGITR, TLBIVAAE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_ASIDE1OSNXS, 	HFGITR, TLBIASIDE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VAE1OSNXS, 	HFGITR, TLBIVAE1OS, 1, HCRX_FGTnXS),
> +	SR_FGF(OP_TLBI_VMALLE1OSNXS, 	HFGITR, TLBIVMALLE1OS, 1, HCRX_FGTnXS),
>  	SR_FGT(OP_AT_S1E1WP, 		HFGITR, ATS1E1WP, 1),
>  	SR_FGT(OP_AT_S1E1RP, 		HFGITR, ATS1E1RP, 1),
>  	SR_FGT(OP_AT_S1E0W, 		HFGITR, ATS1E0W, 1),
> @@ -1598,6 +1612,7 @@ int __init populate_nv_trap_config(void)
>  	BUILD_BUG_ON(sizeof(union trap_config) != sizeof(void *));
>  	BUILD_BUG_ON(__NR_TRAP_GROUP_IDS__ > BIT(TC_CGT_BITS));
>  	BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
> +	BUILD_BUG_ON(__NR_FG_FILTER_IDS__ > BIT(TC_FGF_BITS));
>  
>  	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
>  		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
> @@ -1779,6 +1794,17 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
>  
>  	case HFGITR_GROUP:
>  		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
> +		switch (tc.fgf) {
> +			u64 tmp;
> +
> +		case __NO_FGF__:
> +			break;
> +
> +		case HCRX_FGTnXS:
> +			tmp = sanitised_sys_reg(vcpu, HCRX_EL2);
> +			if (tmp & HCRX_EL2_FGTnXS)
> +				tc.fgt = __NO_FGT_GROUP__;
> +		}
>  		break;
>  
>  	case __NR_FGT_GROUP_IDS__:
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 060c5a0409e5..3acf6d77e324 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -197,8 +197,19 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  
> -	if (cpus_have_final_cap(ARM64_HAS_HCX))
> -		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
> +	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
> +		u64 hcrx = HCRX_GUEST_FLAGS;
> +		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
> +			u64 clr = 0, set = 0;
> +
> +			compute_clr_set(vcpu, HCRX_EL2, clr, set);
> +
> +			hcrx |= set;
> +			hcrx &= ~clr;
> +		}
> +
> +		write_sysreg_s(hcrx, SYS_HCRX_EL2);
> +	}
>  
>  	__activate_traps_hfgxtr(vcpu);
>  }
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 3facd8918ae3..042695a210ce 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -117,7 +117,8 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
>  		break;
>  
>  	case SYS_ID_AA64MMFR1_EL1:
> -		val &= (NV_FTR(MMFR1, PAN)	|
> +		val &= (NV_FTR(MMFR1, HCX)	|
> +			NV_FTR(MMFR1, PAN)	|
>  			NV_FTR(MMFR1, LO)	|
>  			NV_FTR(MMFR1, HPDS)	|
>  			NV_FTR(MMFR1, VH)	|
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index dfd72b3a625f..374b21f08fc3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2372,6 +2372,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
>  	EL2_REG(HACR_EL2, access_rw, reset_val, 0),
>  
> +	EL2_REG(HCRX_EL2, access_rw, reset_val, 0),
> +
>  	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
>  	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
>  	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

