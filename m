Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176E61D88D1
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732274137; cv=none; b=qWYnpFOtLxaXFZ558vEd2OaLnNMzY9/KaV+h3zkpVIE088uhqjdIRt5AVB39LyJBVTuAxSg3pwEJFqsgm/QQzows3B+kneRkfrO+dKIhkFgaHHITCxJs+QlfYxCvVg5w+lt7RqdBv/mSu0f+m2ke0CNQiNR5yIJ+GDkMkMpzy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732274137; c=relaxed/simple;
	bh=DtH/w0STgd5T1I/Z1S1FZcLf/9OOyJGJComwC9PyW/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HJ/S5zUnWm4Z42vBk3Cf6ExGYjWYVr9x0qHVgrvHPe0EDD+FB/ptw3xX9C0w4usAsAOiViYbywL8MxPn9UzWLZ0g02L9IF97MvPW/gWGYM1Jn/e1cK51aLO9MB5B+Ug2ceMYxOEwUxs8s06YgCj9Jm1ZrLis6aEvpG2lG+S/Xhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VA7wB5Me; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VA7wB5Me"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-382378f359dso1331131f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732274133; x=1732878933; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JWVNVQ4kzS/ts7lE3a7NbVFu8TqBhCs/Sk+vmXRa5qI=;
        b=VA7wB5Me2UHrGlYHbO7KX6fqfkKpzSIcGBWkgNfZpR0+4PIpnDUlKtDfEVta593mbq
         h77qaQt7di3cGBv4BzHHXb1+sKzp1DcxjCUtKknwGAWgNSLpmSs4nkRLz0U7okxPZl0+
         wHEKWRAiOQsO2BimLPEN2C9FZGT06IQiz+Z1AMVA3AjkimQp2EdKwl68tK/pAef96rBI
         pkN6C+Oz16kcW5GUmFQapGXs54rV0SLmLROiW1hjzPn9gr9fFBCfCrHTfCCyZ2macJRE
         w4DwpTshDP5CVecLkEbTftBoIW3H2AeJn14x+DVXN4ZYxyH8f4kGZul794OZp+dk/SuQ
         kygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732274133; x=1732878933;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JWVNVQ4kzS/ts7lE3a7NbVFu8TqBhCs/Sk+vmXRa5qI=;
        b=pqrxWVE/xuj1rY5N3zWYDRrs29xNw61/pWTxaML5El1jaXmyQCbP4+hxtIMdLitR7C
         h0vjFmTK+xxzoDJsOJ2B51svwPmxGf35W5DpFkOta5ZP52ZpYcDpTq3uH3SbT/zWjrhS
         J7sHcBf2mx7tLjS2IoMbQon4ooed7fkGuMTkHzCliu54/5O4wBsQn7anyK2zQHuLrMnR
         bymAn2Q/buvKgIVxYAlE2W7Dkwmr3dyMVIbBCa6+kI0D1c7clk/bPZkdXL85CpQrZfxJ
         JjhH96qOAELDHMcUlAjJqGs7GwHXod2ZrhPY6x4zVk/neT6hBfNH6UtT486BUhJr0BeG
         IOYA==
X-Forwarded-Encrypted: i=1; AJvYcCXvq2bQhMQcMS4LH5ySljZUCfU1dBru8zfiG+nKeAX6gDJC+o/Eu8y5yKp7vt4IDVb4drnDX9s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWDxTdZ0YV4MBr0JeAbl3CVjJu4xWQAP88z9WCj2a/zw5PzfDQ
	KGnHP3ztpCN0cjgbz/gLnjDiWmCsmLelLhkkxhzfa8qSG5ROzF1Wyy5XLeY7YhI=
X-Gm-Gg: ASbGncv9pWw+dRxqX26RjGRMHvQBM6RW07KqcwhRGx5hdUYoPzC1HTxZ/dVKTERnBiL
	ttK3yO1Jy16vgmBKQ9INwWfAglILE4Kouya4T4RqtM0RHIOcF4sJP+xyOQEUWMsFz5NTUZ3OQkP
	cgFDIezKAh1Lf7JHDCsnrv4/dxrVLbb1P+3+rZk0LaVwlipWqDgJd8acI2BZewE6FDeH9bImnBA
	helNaitn/6cArB0rxo1SZOcrHrnmKdpJxO5rc29x+6P/jPe4NNZl2Lmw+yl+A==
X-Google-Smtp-Source: AGHT+IFSJ4wO2a0w1DPrxXoz8gPj2njMh2A39ERVEx8bio15Pd5AZV7vVFpKC2yLsTYsmi9Agl7nLw==
X-Received: by 2002:a5d:588f:0:b0:382:485b:363e with SMTP id ffacd0b85a97d-38260b4fb0bmr2223714f8f.6.1732274133368;
        Fri, 22 Nov 2024 03:15:33 -0800 (PST)
Received: from [192.168.68.163] ([209.198.129.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fafe504sm2096431f8f.25.2024.11.22.03.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 03:15:33 -0800 (PST)
Message-ID: <6fc3f86e-5144-43ce-9d36-2c447d033041@linaro.org>
Date: Fri, 22 Nov 2024 11:15:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/16] KVM: arm64: Track presence of SPE/TRBE in
 kvm_host_data instead of vCPU
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>,
 Colton Lewis <coltonlewis@google.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
References: <20241115224924.2132364-1-oliver.upton@linux.dev>
 <20241115224924.2132364-4-oliver.upton@linux.dev>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20241115224924.2132364-4-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 15/11/2024 10:49 pm, Oliver Upton wrote:
> Add flags to kvm_host_data to track if SPE/TRBE is present +
> programmable on a per-CPU basis. Set the flags up at init rather than
> vcpu_load() as the programmability of these buffers is unlikely to
> change.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: James Clark <james.clark@linaro.org>

> ---
>   arch/arm64/include/asm/kvm_host.h  | 19 +++++++++-------
>   arch/arm64/kvm/arm.c               |  3 ---
>   arch/arm64/kvm/debug.c             | 36 ++++++++----------------------
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c |  8 +++----
>   4 files changed, 24 insertions(+), 42 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ad514434f3fe..7e3478386351 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -610,6 +610,10 @@ struct cpu_sve_state {
>    * field.
>    */
>   struct kvm_host_data {
> +#define KVM_HOST_DATA_FLAG_HAS_SPE	0
> +#define KVM_HOST_DATA_FLAG_HAS_TRBE	1
> +	unsigned long flags;
> +
>   	struct kvm_cpu_context host_ctxt;
>   
>   	/*
> @@ -911,10 +915,6 @@ struct kvm_vcpu_arch {
>   #define EXCEPT_AA64_EL2_SERR	__vcpu_except_flags(7)
>   /* Guest debug is live */
>   #define DEBUG_DIRTY		__vcpu_single_flag(iflags, BIT(4))
> -/* Save SPE context if active  */
> -#define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
> -/* Save TRBE context if active  */
> -#define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
>   
>   /* SVE enabled for host EL0 */
>   #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
> @@ -1310,6 +1310,13 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
>   	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
>   #endif
>   
> +#define host_data_test_flag(flag)					\
> +	(test_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags)))
> +#define host_data_set_flag(flag)					\
> +	set_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags))
> +#define host_data_clear_flag(flag)					\
> +	clear_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags))
> +
>   /* Check whether the FP regs are owned by the guest */
>   static inline bool guest_owns_fp_regs(void)
>   {
> @@ -1370,10 +1377,6 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
>   	return (!has_vhe() && attr->exclude_host);
>   }
>   
> -/* Flags for host debug state */
> -void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
> -void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
> -
>   #ifdef CONFIG_KVM
>   void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
>   void kvm_clr_pmu_events(u64 clr);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index ab1bf9ccf385..3822774840e1 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -617,15 +617,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   
>   	vcpu_set_pauth_traps(vcpu);
>   
> -	kvm_arch_vcpu_load_debug_state_flags(vcpu);
> -
>   	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
>   		vcpu_set_on_unsupported_cpu(vcpu);
>   }
>   
>   void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
> -	kvm_arch_vcpu_put_debug_state_flags(vcpu);
>   	kvm_arch_vcpu_put_fp(vcpu);
>   	if (has_vhe())
>   		kvm_vcpu_put_vhe(vcpu);
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index d8ea6fe6a2a2..1ee2fd765b62 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -294,40 +294,22 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> -void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
> +void kvm_init_host_debug_data(void)
>   {
> -	u64 dfr0;
> +	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
> +
> +	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
> +		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
> +							      read_sysreg(pmcr_el0));
>   
> -	/* For VHE, there is nothing to do */
>   	if (has_vhe())
>   		return;
>   
> -	dfr0 = read_sysreg(id_aa64dfr0_el1);
> -	/*
> -	 * If SPE is present on this CPU and is available at current EL,
> -	 * we may need to check if the host state needs to be saved.
> -	 */
>   	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
> -	    !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(PMBIDR_EL1_P_SHIFT)))
> -		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_SPE);
> +	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
> +		host_data_set_flag(HAS_SPE);
>   
> -	/* Check if we have TRBE implemented and available at the host */
>   	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
>   	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
> -		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
> -}
> -
> -void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
> -{
> -	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
> -	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
> -}
> -
> -void kvm_init_host_debug_data(void)
> -{
> -	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
> -
> -	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
> -		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
> -							      read_sysreg(pmcr_el0));
> +		host_data_set_flag(HAS_TRBE);
>   }
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 1e2a26d0196e..858bb38e273f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -82,10 +82,10 @@ static void __debug_restore_trace(u64 trfcr_el1)
>   void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>   {
>   	/* Disable and flush SPE data generation */
> -	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
> +	if (host_data_test_flag(HAS_SPE))
>   		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
>   	/* Disable and flush Self-Hosted Trace generation */
> -	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
> +	if (host_data_test_flag(HAS_TRBE))
>   		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
>   }
>   
> @@ -96,9 +96,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
>   
>   void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
>   {
> -	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
> +	if (host_data_test_flag(HAS_SPE))
>   		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
> -	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
> +	if (host_data_test_flag(HAS_TRBE))
>   		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
>   }
>   

