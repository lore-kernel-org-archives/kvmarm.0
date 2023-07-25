Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DD1200D0
	for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690303198;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3FB+h5e6YkucqbOoiJ2ViB15WtEhvgZyklX5r4J3N4=;
	b=gYD8Y/l9np95Eo6luSxBTXjZKDK+sQrApvfb9PKfa7LK2YbFJUvgnk2MAFwl5KKTCTYTFj
	GGjtC81mkmbOonEzWrAMjsHzmvafLOIfmt5kVR7SaCmTCEVLWPXV2MDlmlWr2jGAk5iXYs
	BkPmWh6niFbM3UM88Y3X5GRZG6uwbbs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-rEEX1yjQM92GHWv5ysFd0Q-1; Tue, 25 Jul 2023 12:39:57 -0400
X-MC-Unique: rEEX1yjQM92GHWv5ysFd0Q-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4fb76659d37so5045902e87.2
        for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 09:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690303195; x=1690907995;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S3FB+h5e6YkucqbOoiJ2ViB15WtEhvgZyklX5r4J3N4=;
        b=SFYFLqebaNetGMU4K+dusIoVoQPf2GxwC1oOOe8+qaeFJJXdoNvW4RdNRQ7BcJ+xfZ
         o7aYcNHhvAHVOg5UrkGhtz/L4QiDWOW4JZn303FVKlwOdeNL8WhlBcvPu8shZce5quOr
         ZFKvGb6TQ2XdQJ56ZwEwnSvG7kcBreQHk0rj2mr9MZTTVYDTm2QWSFBscqSt/WwafWOm
         ByXiildvPVf2DJSifyah23bNzX0W5e9b+KlqqKo+ZULGqDqq3Ge7m9g28ZkZMvBMjAnl
         UNr6pLldSFnglSSjSREeDAL4McfGXNWoBfy89LvQxlVwYXmPhdFaQN3u6WyS40pnHE89
         dMhA==
X-Gm-Message-State: ABy/qLZ0seJV5s432XpXjcUKf9JVTG4Rcwl6ugZUohC9Vh7dcNcn0kE5
	Ff5hAkM4J9TLroZiAEwYvIoENghcv0MxPlcCHvXJlTVwuBo6CNVDbvvliAfxJn7Qyw8GpN+kVdK
	s8W85h4yy0hdLnj3dozqYvuSN
X-Received: by 2002:a05:6512:3485:b0:4fb:7b2a:78de with SMTP id v5-20020a056512348500b004fb7b2a78demr7178150lfr.45.1690303195349;
        Tue, 25 Jul 2023 09:39:55 -0700 (PDT)
X-Google-Smtp-Source: APBJJlExor7KJajuF8KTAn615TMs/hCytqwWsIogzEkYtv64N79qqXVWIRu2F3xRAtwJjk/ilmu6dg==
X-Received: by 2002:a05:6512:3485:b0:4fb:7b2a:78de with SMTP id v5-20020a056512348500b004fb7b2a78demr7178117lfr.45.1690303194950;
        Tue, 25 Jul 2023 09:39:54 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:368:50e0:e390:42c6:ce16:9d04? ([2a01:e0a:368:50e0:e390:42c6:ce16:9d04])
        by smtp.gmail.com with ESMTPSA id m9-20020a5d56c9000000b00313e2abfb8dsm17118254wrw.92.2023.07.25.09.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 09:39:54 -0700 (PDT)
Message-ID: <fd0d93ae-1ae5-b53e-ccb7-04d78f7c31d9@redhat.com>
Date: Tue, 25 Jul 2023 18:39:52 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 14/27] KVM: arm64: Restructure FGT register switching
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
 <20230712145810.3864793-15-maz@kernel.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230712145810.3864793-15-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Marc,

On 7/12/23 16:57, Marc Zyngier wrote:
> As we're about to majorly extend the handling of FGT registers,
> restructure the code to actually save/restore the registers
> as required. This is made easy thanks to the previous addition
> of the EL2 registers, allowing us to use the host context for
> this purpose.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_arm.h        | 21 ++++++++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 55 +++++++++++++------------
>  2 files changed, 49 insertions(+), 27 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 028049b147df..85908aa18908 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -333,6 +333,27 @@
>  				 BIT(18) |		\
>  				 GENMASK(16, 15))
>  
> +/*
> + * FGT register definitions
> + *
> + * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
> + * We're not using the generated masks as they are usually ahead of
> + * the published ARM ARM, which we use as a reference.
> + *
> + * Once we get to a point where the two describe the same thing, we'll
> + * merge the definitions. One day.
> + */
> +#define __HFGRTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51))
> +#define __HFGRTR_EL2_MASK	GENMASK(49, 0)
> +#define __HFGRTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
> +
> +#define __HFGWTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51) |	\
> +				 BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
> +				 GENMASK(26, 25) | BIT(21) | BIT(18) |	\
> +				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
> +#define __HFGWTR_EL2_MASK	GENMASK(49, 0)
> +#define __HFGWTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
> +
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
>  /*
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 4bddb8541bec..9781e79a5127 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -70,20 +70,19 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static inline bool __hfgxtr_traps_required(void)
> -{
> -	if (cpus_have_final_cap(ARM64_SME))
> -		return true;
> -
> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -		return true;
>  
> -	return false;
> -}
>  
> -static inline void __activate_traps_hfgxtr(void)
> +static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
> +	u64 r_val, w_val;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +		return;
> +
> +	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
> +	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
>  
>  	if (cpus_have_final_cap(ARM64_SME)) {
>  		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> @@ -98,26 +97,30 @@ static inline void __activate_traps_hfgxtr(void)
>  	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>  		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
>  
> -	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> -	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
> +
> +	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
I don't get why you do

& ~HFGxTR_EL2_nACCDATA_EL1 as this latter also has a negative polarity. 

Please could you explain what is special with this bit/add a comment?

Thanks

Eric

> +	r_val |= r_set;
> +	r_val &= ~r_clr;
> +
> +	w_val = __HFGWTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
> +	w_val |= w_set;
> +	w_val &= ~w_clr;
> +
> +	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
> +	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
>  }
>  
> -static inline void __deactivate_traps_hfgxtr(void)
> +static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
>  {
> -	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
> +	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
>  
> -	if (cpus_have_final_cap(ARM64_SME)) {
> -		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +		return;
>  
> -		r_set |= tmp;
> -		w_set |= tmp;
> -	}
> +	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
> +	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
>  
> -	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -		w_clr |= HFGxTR_EL2_TCR_EL1_MASK;
>  
> -	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
> -	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
>  }
>  
>  static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> @@ -145,8 +148,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
>  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>  
> -	if (__hfgxtr_traps_required())
> -		__activate_traps_hfgxtr();
> +	__activate_traps_hfgxtr(vcpu);
>  }
>  
>  static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> @@ -162,8 +164,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
>  		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
>  	}
>  
> -	if (__hfgxtr_traps_required())
> -		__deactivate_traps_hfgxtr();
> +	__deactivate_traps_hfgxtr(vcpu);
>  }
>  
>  static inline void ___activate_traps(struct kvm_vcpu *vcpu)

