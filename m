Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554D56FB1
	for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 14:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689257187;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hmJDfzniq78z/syhqYqv1t2fog9OG8SmxSLLjJ9y5kc=;
	b=NIAVpVhyIHbBHbHpKzN8Np2H4BF50IxuvOK4aKFRcsTdQ5+aM/p5qBnh0sMZvU/yy6zF0u
	3M7+qs+VpV+1QKgEA+x5z2xwvPbV5dMV4UVzVNZbLgTimOcubMv+ATNGGCTpz6X5YZpAjh
	+iXwR4OR9/nq9MvMIgg2smQ3toYZ8hc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-0Y8gQ_urM6iMLPXTn0y5sQ-1; Thu, 13 Jul 2023 10:06:03 -0400
X-MC-Unique: 0Y8gQ_urM6iMLPXTn0y5sQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-403c1294d95so9301691cf.0
        for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 07:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689257139; x=1689861939;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hmJDfzniq78z/syhqYqv1t2fog9OG8SmxSLLjJ9y5kc=;
        b=Kns+65lBdqNXMjHCxo4Js+KyXbks2LgOkWY5N1Ylnb1kSZifyKc5PKiccjBgghdXZ2
         wb88+SeNUIhA9AQCBaLnqjUVvcuiUrvM8dWHsmgFODw4A9vISAIsyH9Cd7aq/ma+7EZW
         tQ0AawyFTDSKy+KC9I+bWhvYmem/qOaTfYBTVmrHpXE4FBPN7GYGNjRI1j5+ypL4jLI8
         W+ipwbNzDc9gjoKot5R4FGlOrzchOAQm7o/N4V0pqG3/beUeVORGtmCmRosxVElOCYJD
         wtdc/+cDd6svGVG9GrRfBLZ5nCmle8M2V5W5v4kEyK0bsydouBDhvuw+UQ2UHLqQ9vbW
         WuaA==
X-Gm-Message-State: ABy/qLYU1cIL5HkAje1u2TvmUDHnR4SiEsPCrgdXaqVRwx8fGNVit8qR
	OBcIg4zxrCdkTdexAFpstCMZTD1E2BgOXKUrzuK1WclMqQsVKoKz0fpG6b9anKz86yWql2fmcJC
	EpB4VIM3An+sOS5hu
X-Received: by 2002:a0c:eb4c:0:b0:626:31ad:f873 with SMTP id c12-20020a0ceb4c000000b0062631adf873mr1418004qvq.24.1689257139421;
        Thu, 13 Jul 2023 07:05:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlErGTtXtOMNhui1V083e4Pzi4yfWXwTO7hwRcu/kNSSOUOwT+GI2RlE74NOZ7a7SMiG+q0HTQ==
X-Received: by 2002:a0c:eb4c:0:b0:626:31ad:f873 with SMTP id c12-20020a0ceb4c000000b0062631adf873mr1417966qvq.24.1689257138918;
        Thu, 13 Jul 2023 07:05:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id y3-20020a0cd983000000b0062df126ca11sm3078629qvj.21.2023.07.13.07.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 07:05:38 -0700 (PDT)
Message-ID: <8c32ebdc-a3bc-aabe-5098-3754159d22cd@redhat.com>
Date: Thu, 13 Jul 2023 16:05:33 +0200
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
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-17-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-17-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 7/12/23 16:57, Marc Zyngier wrote:
> Describe the HCR_EL2 register, and associate it with all the sysregs
> it allows to trap.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/emulate-nested.c | 475 ++++++++++++++++++++++++++++++++
>  1 file changed, 475 insertions(+)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 5bab2e85d70c..51901e85e43d 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -37,12 +37,47 @@ enum coarse_grain_trap_id {
>  	 * on their own instead of being part of a combination of
>  	 * trap controls.
>  	 */
> +	CGT_HCR_TID1,
> +	CGT_HCR_TID2,
> +	CGT_HCR_TID3,
> +	CGT_HCR_IMO,
> +	CGT_HCR_FMO,
> +	CGT_HCR_TIDCP,
> +	CGT_HCR_TACR,
> +	CGT_HCR_TSW,
> +	CGT_HCR_TPC,
> +	CGT_HCR_TPU,
> +	CGT_HCR_TTLB,
> +	CGT_HCR_TVM,
> +	CGT_HCR_TDZ,
> +	CGT_HCR_TRVM,
> +	CGT_HCR_TLOR,
> +	CGT_HCR_TERR,
> +	CGT_HCR_APK,
> +	CGT_HCR_NV,
> +	CGT_HCR_NV1,
> +	CGT_HCR_AT,
> +	CGT_HCR_FIEN,
> +	CGT_HCR_TID4,
> +	CGT_HCR_TICAB,
> +	CGT_HCR_TOCU,
> +	CGT_HCR_ENSCXT,
> +	CGT_HCR_TTLBIS,
> +	CGT_HCR_TTLBOS,
>  
>  	/*
>  	 * Anything after this point is a combination of trap controls,
>  	 * which all must be evaluated to decide what to do.
>  	 */
>  	__MULTIPLE_CONTROL_BITS__,
> +	CGT_HCR_IMO_FMO = __MULTIPLE_CONTROL_BITS__,
> +	CGT_HCR_TID2_TID4,
> +	CGT_HCR_TTLB_TTLBIS,
> +	CGT_HCR_TTLB_TTLBOS,
> +	CGT_HCR_TVM_TRVM,
> +	CGT_HCR_TPU_TICAB,
> +	CGT_HCR_TPU_TOCU,
> +	CGT_HCR_NV1_ENSCXT,
>  
>  	/*
>  	 * Anything after this point requires a callback evaluating a
> @@ -52,6 +87,168 @@ enum coarse_grain_trap_id {
>  };
>  
>  static const struct trap_bits coarse_trap_bits[] = {
> +	[CGT_HCR_TID1] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_TID1,
> +		.mask		= HCR_TID1,
> +		.behaviour	= BEHAVE_FORWARD_READ,
> +	},
> +	[CGT_HCR_TID2] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_TID2,
> +		.mask		= HCR_TID2,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TID3] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_TID3,
> +		.mask		= HCR_TID3,
> +		.behaviour	= BEHAVE_FORWARD_READ,
> +	},
> +	[CGT_HCR_IMO] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_IMO,
> +		.mask		= HCR_IMO,
> +		.behaviour	= BEHAVE_FORWARD_WRITE,
> +	},
> +	[CGT_HCR_FMO] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_FMO,
> +		.mask		= HCR_FMO,
> +		.behaviour	= BEHAVE_FORWARD_WRITE,
> +	},
> +	[CGT_HCR_TIDCP] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TIDCP,
> +		.mask		= HCR_TIDCP,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TACR] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TACR,
> +		.mask		= HCR_TACR,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TSW] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TSW,
> +		.mask		= HCR_TSW,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TPC] = {
modern revisions now refer to TPCP, maybe worth a comment?
> +		.index		= HCR_EL2,
> +		.value		= HCR_TPC,
> +		.mask		= HCR_TPC,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TPU] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TPU,
> +		.mask		= HCR_TPU,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TTLB] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TTLB,
> +		.mask		= HCR_TTLB,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TVM] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TVM,
> +		.mask		= HCR_TVM,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TDZ] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TDZ,
> +		.mask		= HCR_TDZ,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TRVM] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TRVM,
> +		.mask		= HCR_TRVM,
> +		.behaviour	= BEHAVE_FORWARD_READ,
> +	},
> +	[CGT_HCR_TLOR] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TLOR,
> +		.mask		= HCR_TLOR,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TERR] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TERR,
> +		.mask		= HCR_TERR,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_APK] = {
> +		.index		= HCR_EL2,
> +		.value		= 0,
> +		.mask		= HCR_APK,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_NV] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_NV,
> +		.mask		= HCR_NV | HCR_NV2,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_NV1] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_NV | HCR_NV1,
> +		.mask		= HCR_NV | HCR_NV1 | HCR_NV2,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_AT] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_AT,
> +		.mask		= HCR_AT,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_FIEN] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_FIEN,
> +		.mask		= HCR_FIEN,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TID4] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_TID4,
> +		.mask		= HCR_TID4,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TICAB] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_TICAB,
> +		.mask		= HCR_TICAB,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TOCU] = {
> +		.index		= HCR_EL2,
> +		.value 		= HCR_TOCU,
> +		.mask		= HCR_TOCU,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_ENSCXT] = {
> +		.index		= HCR_EL2,
> +		.value 		= 0,
> +		.mask		= HCR_ENSCXT,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TTLBIS] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TTLBIS,
> +		.mask		= HCR_TTLBIS,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
> +	[CGT_HCR_TTLBOS] = {
> +		.index		= HCR_EL2,
> +		.value		= HCR_TTLBOS,
> +		.mask		= HCR_TTLBOS,
> +		.behaviour	= BEHAVE_FORWARD_ANY,
> +	},
>  };
>  
>  #define MCB(id, ...)					\
> @@ -61,6 +258,14 @@ static const struct trap_bits coarse_trap_bits[] = {
>  		}
>  
>  static const enum coarse_grain_trap_id *coarse_control_combo[] = {
> +	MCB(CGT_HCR_IMO_FMO,		CGT_HCR_IMO, CGT_HCR_FMO),
> +	MCB(CGT_HCR_TID2_TID4,		CGT_HCR_TID2, CGT_HCR_TID4),
> +	MCB(CGT_HCR_TTLB_TTLBIS,	CGT_HCR_TTLB, CGT_HCR_TTLBIS),
> +	MCB(CGT_HCR_TTLB_TTLBOS,	CGT_HCR_TTLB, CGT_HCR_TTLBOS),
> +	MCB(CGT_HCR_TVM_TRVM,		CGT_HCR_TVM, CGT_HCR_TRVM),
> +	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
> +	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
> +	MCB(CGT_HCR_NV1_ENSCXT,		CGT_HCR_NV1, CGT_HCR_ENSCXT),
>  };
>  
>  typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
> @@ -118,6 +323,276 @@ struct encoding_to_trap_config {
>   * re-injected in the nested hypervisor.
>   */
>  static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
> +	SR_TRAP(SYS_REVIDR_EL1,		CGT_HCR_TID1),
> +	SR_TRAP(SYS_AIDR_EL1,		CGT_HCR_TID1),
> +	SR_TRAP(SYS_SMIDR_EL1,		CGT_HCR_TID1),
> +	SR_TRAP(SYS_CTR_EL0,		CGT_HCR_TID2),
> +	SR_TRAP(SYS_CCSIDR_EL1,		CGT_HCR_TID2_TID4),
> +	SR_TRAP(SYS_CCSIDR2_EL1,	CGT_HCR_TID2_TID4),
> +	SR_TRAP(SYS_CLIDR_EL1,		CGT_HCR_TID2_TID4),
> +	SR_TRAP(SYS_CSSELR_EL1,		CGT_HCR_TID2_TID4),
> +	SR_RANGE_TRAP(SYS_ID_PFR0_EL1,
> +		      sys_reg(3, 0, 0, 7, 7), CGT_HCR_TID3),
in the spec I see this upper limit in the FEAT_FGT section. Out of
curiosity how were you able to convert the sys reg names into this Op0,
Op1, CRn, CRm, Op2. Is there any ordering logic documented somewhere for
those group3 regs?

I checked Table D18-2 and this looks good but I wonder if there isn't
any more efficient way to review this.
> +	SR_TRAP(SYS_ICC_SGI0R_EL1,	CGT_HCR_IMO_FMO),
> +	SR_TRAP(SYS_ICC_ASGI1R_EL1,	CGT_HCR_IMO_FMO),
> +	SR_TRAP(SYS_ICC_SGI1R_EL1,	CGT_HCR_IMO_FMO),
> +	SR_RANGE_TRAP(sys_reg(3, 0, 11, 0, 0),
> +		      sys_reg(3, 0, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 1, 11, 0, 0),
> +		      sys_reg(3, 1, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 2, 11, 0, 0),
> +		      sys_reg(3, 2, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 3, 11, 0, 0),
> +		      sys_reg(3, 3, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 4, 11, 0, 0),
> +		      sys_reg(3, 4, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 5, 11, 0, 0),
> +		      sys_reg(3, 5, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 6, 11, 0, 0),
> +		      sys_reg(3, 6, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 7, 11, 0, 0),
> +		      sys_reg(3, 7, 11, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 0, 15, 0, 0),
> +		      sys_reg(3, 0, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 1, 15, 0, 0),
> +		      sys_reg(3, 1, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 2, 15, 0, 0),
> +		      sys_reg(3, 2, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 3, 15, 0, 0),
> +		      sys_reg(3, 3, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 4, 15, 0, 0),
> +		      sys_reg(3, 4, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 5, 15, 0, 0),
> +		      sys_reg(3, 5, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 6, 15, 0, 0),
> +		      sys_reg(3, 6, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_RANGE_TRAP(sys_reg(3, 7, 15, 0, 0),
> +		      sys_reg(3, 7, 15, 15, 7), CGT_HCR_TIDCP),
> +	SR_TRAP(SYS_ACTLR_EL1,		CGT_HCR_TACR),
> +	SR_TRAP(SYS_DC_ISW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_CSW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_CISW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_IGSW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_IGDSW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_CGSW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_CGDSW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_CIGSW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_CIGDSW,		CGT_HCR_TSW),
> +	SR_TRAP(SYS_DC_CIVAC,		CGT_HCR_TPC),
I don't see CVADP?
> +	SR_TRAP(SYS_DC_CVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CVAP,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_IVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CIGVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CIGDVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_IGVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_IGDVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CGVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CGDVAC,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CGVAP,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CGDVAP,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CGVADP,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_DC_CGDVADP,		CGT_HCR_TPC),
> +	SR_TRAP(SYS_IC_IVAU,		CGT_HCR_TPU_TOCU),
> +	SR_TRAP(SYS_IC_IALLU,		CGT_HCR_TPU_TOCU),
> +	SR_TRAP(SYS_IC_IALLUIS,		CGT_HCR_TPU_TICAB),
> +	SR_TRAP(SYS_DC_CVAU,		CGT_HCR_TPU_TOCU),
> +	SR_TRAP(OP_TLBI_RVAE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVAAE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVALE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVAALE1,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VMALLE1,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VAE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_ASIDE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VAAE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VALE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VAALE1,		CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVAE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVAAE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVALE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVAALE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VMALLE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VAE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_ASIDE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VAAE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VALE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_VAALE1NXS,	CGT_HCR_TTLB),*
> +	SR_TRAP(OP_TLBI_RVAE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_RVAAE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_RVALE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_RVAALE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VMALLE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VAE1IS,		CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_ASIDE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VAAE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VALE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VAALE1IS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_RVAE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_RVAAE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_RVALE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_RVAALE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VMALLE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VAE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_ASIDE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VAAE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VALE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VAALE1ISNXS,	CGT_HCR_TTLB_TTLBIS),*
> +	SR_TRAP(OP_TLBI_VMALLE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VAE1OS,		CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_ASIDE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VAAE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VALE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VAALE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVAE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVAAE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVALE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVAALE1OS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VMALLE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VAE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_ASIDE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VAAE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VALE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_VAALE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVAE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVAAE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVALE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(OP_TLBI_RVAALE1OSNXS,	CGT_HCR_TTLB_TTLBOS),*
> +	SR_TRAP(SYS_SCTLR_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_TTBR0_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_TTBR1_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_TCR_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_ESR_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_FAR_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_AFSR0_EL1,		CGT_HCR_TVM_TRVM),*
Looking at the SFSR0_EL1 MRS/MSR pseudo code I understand TRVM is tested
on read and
TVM is tested on write. However CGT_HCR_TVM has FORWARD_ANY behaviour
while TRVM looks good as FORWARD_READ? Do I miss something.

> +	SR_TRAP(SYS_AFSR1_EL1,		CGT_HCR_TVM_TRVM),*
same here and below
> +	SR_TRAP(SYS_MAIR_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_AMAIR_EL1,		CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_CONTEXTIDR_EL1,	CGT_HCR_TVM_TRVM),
> +	SR_TRAP(SYS_DC_ZVA,		CGT_HCR_TDZ),*
> +	SR_TRAP(SYS_DC_GVA,		CGT_HCR_TDZ),*
> +	SR_TRAP(SYS_DC_GZVA,		CGT_HCR_TDZ),*
> +	SR_TRAP(SYS_LORSA_EL1,		CGT_HCR_TLOR),*
> +	SR_TRAP(SYS_LOREA_EL1, 		CGT_HCR_TLOR),*
> +	SR_TRAP(SYS_LORN_EL1, 		CGT_HCR_TLOR),*
> +	SR_TRAP(SYS_LORC_EL1, 		CGT_HCR_TLOR),*
> +	SR_TRAP(SYS_LORID_EL1,		CGT_HCR_TLOR),*
> +	SR_TRAP(SYS_ERRIDR_EL1,		CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERRSELR_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXADDR_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXCTLR_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXFR_EL1,		CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXMISC0_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXMISC1_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXMISC2_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXMISC3_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_ERXSTATUS_EL1,	CGT_HCR_TERR),*
> +	SR_TRAP(SYS_APIAKEYLO_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APIAKEYHI_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APIBKEYLO_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APIBKEYHI_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APDAKEYLO_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APDAKEYHI_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APDBKEYLO_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APDBKEYHI_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APGAKEYLO_EL1,	CGT_HCR_APK),*
> +	SR_TRAP(SYS_APGAKEYHI_EL1,	CGT_HCR_APK),*
> +	/* All _EL2 registers */
> +	SR_RANGE_TRAP(sys_reg(3, 4, 0, 0, 0),
> +		      sys_reg(3, 4, 10, 15, 7), CGT_HCR_NV),
> +	SR_RANGE_TRAP(sys_reg(3, 4, 12, 0, 0),
> +		      sys_reg(3, 4, 14, 15, 7), CGT_HCR_NV),
> +	/* All _EL02, _EL12 registers */
> +	SR_RANGE_TRAP(sys_reg(3, 5, 0, 0, 0),
> +		      sys_reg(3, 5, 10, 15, 7), CGT_HCR_NV),
> +	SR_RANGE_TRAP(sys_reg(3, 5, 12, 0, 0),
> +		      sys_reg(3, 5, 14, 15, 7), CGT_HCR_NV),
same question as bove, where in the ARM ARM do you find those ranges?
> +	SR_TRAP(SYS_SP_EL1,		CGT_HCR_NV),*
> +	SR_TRAP(OP_AT_S1E2R,		CGT_HCR_NV),*
> +	SR_TRAP(OP_AT_S1E2W,		CGT_HCR_NV),*
> +	SR_TRAP(OP_AT_S12E1R,		CGT_HCR_NV),*
> +	SR_TRAP(OP_AT_S12E1W,		CGT_HCR_NV),*
> +	SR_TRAP(OP_AT_S12E0R,		CGT_HCR_NV),*
according to the pseudo code NV2 is not checked
shouldn't we have a separate CGT? Question also valid for a bunch of ops
below
> +	SR_TRAP(OP_AT_S12E0W,		CGT_HCR_NV),*
> +	SR_TRAP(OP_TLBI_IPAS2E1,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2E1,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2LE1,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2LE1,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVAE2,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVALE2,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE2,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VAE2,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE1,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VALE2,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VMALLS12E1,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2E1NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2E1NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2LE1NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2LE1NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVAE2NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVALE2NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE2NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VAE2NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE1NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VALE2NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VMALLS12E1NXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2E1IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2E1IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2LE1IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2LE1IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVAE2IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVALE2IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE2IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VAE2IS,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE1IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VALE2IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VMALLS12E1IS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2E1ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2E1ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2LE1ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2LE1ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVAE2ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVALE2ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE2ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VAE2ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE1ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VALE2ISNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VMALLS12E1ISNXS,CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE2OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VAE2OS,		CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE1OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VALE2OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VMALLS12E1OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2E1OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2E1OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2LE1OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2LE1OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVAE2OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVALE2OS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE2OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VAE2OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_ALLE1OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VALE2OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_VMALLS12E1OSNXS,CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2E1OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2E1OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_IPAS2LE1OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RIPAS2LE1OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVAE2OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(OP_TLBI_RVALE2OSNXS,	CGT_HCR_NV),
> +	SR_TRAP(SYS_VBAR_EL1,		CGT_HCR_NV1),
> +	SR_TRAP(SYS_ELR_EL1,		CGT_HCR_NV1),

CIGDPAE?
CIPAE?
CFP/CPP/DVP RCTX?
> +	SR_TRAP(SYS_SPSR_EL1,		CGT_HCR_NV1),*
> +	SR_TRAP(SYS_SCXTNUM_EL1,	CGT_HCR_NV1_ENSCXT),
> +	SR_TRAP(SYS_SCXTNUM_EL0,	CGT_HCR_ENSCXT),
> +	SR_TRAP(OP_AT_S1E1R, 		CGT_HCR_AT),
> +	SR_TRAP(OP_AT_S1E1W, 		CGT_HCR_AT),
> +	SR_TRAP(OP_AT_S1E0R, 		CGT_HCR_AT),
> +	SR_TRAP(OP_AT_S1E0W, 		CGT_HCR_AT),
> +	SR_TRAP(OP_AT_S1E1RP, 		CGT_HCR_AT),
> +	SR_TRAP(OP_AT_S1E1WP, 		CGT_HCR_AT),
> +	SR_TRAP(SYS_ERXPFGF_EL1,	CGT_HCR_FIEN),
> +	SR_TRAP(SYS_ERXPFGCTL_EL1,	CGT_HCR_FIEN),
> +	SR_TRAP(SYS_ERXPFGCDN_EL1,	CGT_HCR_FIEN),
> +	SR_TRAP(SYS_SCXTNUM_EL0,	CGT_HCR_ENSCXT),
>  };
>  
>  static DEFINE_XARRAY(sr_forward_xa);
Thanks

Eric

