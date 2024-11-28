Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56969AD4B
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732822514; cv=none; b=g16uDpBsxQjAt1ftLnbNgKglxOBPumbTvIOqvyKqEt5HPqYgsSgriaeqn0GtWBmdUE88fAueBAljU3pH4SQ+EAoNqQsKJ2T6fAjyh06yD2MB9SIxZH6M6c5Kj6tbHb0xXFxIp5AcbWXlJljueTWXu04yDREe1QooLF2wwtfczFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732822514; c=relaxed/simple;
	bh=OpPeuKnPwPxDTroGPWBlNI1tJ8AYH1pSfyB6hBgd4I4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=AVT0s5KG9NsNQPY34ilABdEMTjLesiZAMLJBkQVK6KyXI2vB+t4xFqadG8InELGEfy+YX+YEQHN682g6kdN4hj7JtdxRSYroqYQVAUlCP+M6rT9v6L3Z6QSiKbo+0QlNpRshNLtQeSmcKdZHnQ3ByuxWwXJwrUp+PAVArGHphpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3mINTif; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3mINTif"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-841a6e28b52so104032539f.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 11:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732822511; x=1733427311; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pHav4+3FrDV0YxlXaVUKtcvDWZpFWCCuNQlocr5uBVc=;
        b=t3mINTifgQ0eYP89kJeNF2QC4t5upVtt4DrSk3jScHz1agtdK70qRq/SEmAu06TsZ4
         c3yF8yqk84A00ZFMK7aQmBQmhzc5rCVfy2F4UG0s3GDcpfAtKbNtlEb2TqqPT6x4M29f
         Qgbj1/tpYA6AgWGfQ3QzhgY0mgSvquVjVSHOYT4A0wcCoHElh0h7eOmbxzCVVce3oFgV
         zFg8Q4BoZYUvWV+tsiBUtCDfQm1vprAFNVWd3VrZekPNszpsMkCHJep2xnjfhAPdQ5e/
         PETS+ONIjZtj2NxnNqApxRzKqgRcG2Knm+1antywtb3Vr+Uwvah8N9eUwoaFEEoFvH6H
         9Arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732822511; x=1733427311;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pHav4+3FrDV0YxlXaVUKtcvDWZpFWCCuNQlocr5uBVc=;
        b=f3JYiyCaF9Jrywraa8Uy95HYCHQMWpIoOc4HkWaNhRFXEF8FmJAiK/CpyzjFHHUc/k
         fw0HOuHj6NdJEmU8DDIIitvQlwb8K1sjdMu03QifxUvr/z6jOAPEkuwUZ2M1Ujhzbk0G
         vKh92iXJ/Z62WlhHDF1gH0TX0FJT1XI2drFPIFzHElcwApqONmJY8M2kYG+oa0pbkdsM
         UkDKQLPH3OBCPspkGIuI7DCzVrIEZzR/jQk8tsP1MY+5WF9+XR/FPhIJzE4B8WBK/mjq
         J3PCehsdPnOIaMvNVQjqCbJ7hNcwMgCTXROmphHFNG/vwQHzyWQ44+l/uADoDS+TEGs/
         oJ7Q==
X-Gm-Message-State: AOJu0YziZsZehQJy1kEv3hmLZYYpzB/fP3Elgd7dcAMu8uBDD+RAYDYb
	gNAMFb+MZIf6ibk1UEtlVFCuVfc2AXnIlkeuT8V02PDDdaN7NTtlg+Mhkx+LAFu2JoDdcG1MyLK
	BT9KTa3XVkLhgV1RTHkr8jg==
X-Google-Smtp-Source: AGHT+IEZ97yIepjU8jU7qhBvHGo+5ylOwR5GRPXbDGnyqrxJsaXH344g7b1rnjcI9YUqe/qgk/LbB7LrEDeAUIKQyA==
X-Received: from jaqy17.prod.google.com ([2002:a02:ce91:0:b0:4e2:691:b69c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:6d0b:b0:83a:b188:7a4d with SMTP id ca18e2360f4ac-843ecdacaa6mr1065174539f.0.1732822511428;
 Thu, 28 Nov 2024 11:35:11 -0800 (PST)
Date: Thu, 28 Nov 2024 19:35:10 +0000
In-Reply-To: <20241115224924.2132364-3-oliver.upton@linux.dev> (message from
 Oliver Upton on Fri, 15 Nov 2024 14:49:10 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntcyif179t.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 02/16] KVM: arm64: Get rid of __kvm_get_mdcr_el2() and
 related warts
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mizhang@google.com, 
	alexandru.elisei@arm.com, oliver.upton@linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hey Oliver,

Oliver Upton <oliver.upton@linux.dev> writes:

> KVM caches MDCR_EL2 on a per-CPU basis in order to preserve the
> configuration of MDCR_EL2.HPMN while running a guest. This is a bit
> gross, since we're relying on some baked configuration rather than the
> hardware definition of implemented counters.

> Discover the number of implemented counters by reading PMCR_EL0.N
> instead. This works because:

>   - In VHE the kernel runs at EL2, and N always returns the number of
>     counters implemented in hardware

>   - In {n,h}VHE, the EL2 setup code programs MDCR_EL2.HPMN with the EL2
>     view of PMCR_EL0.N for the host

> Lastly, avoid traps under nested virtualization by saving PMCR_EL0.N in
> host data.

> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_asm.h   |  5 +----
>   arch/arm64/include/asm/kvm_host.h  |  7 +++++--
>   arch/arm64/kvm/arm.c               |  2 +-
>   arch/arm64/kvm/debug.c             | 29 +++++++++++------------------
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c |  5 -----
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 ------
>   arch/arm64/kvm/hyp/vhe/debug-sr.c  |  5 -----
>   7 files changed, 18 insertions(+), 41 deletions(-)

> diff --git a/arch/arm64/include/asm/kvm_asm.h  
> b/arch/arm64/include/asm/kvm_asm.h
> index ca2590344313..063185c202ce 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -53,8 +53,7 @@
>   enum __kvm_host_smccc_func {
>   	/* Hypercalls available only prior to pKVM finalisation */
>   	/* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
> -	__KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2 =  
> __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
> -	__KVM_HOST_SMCCC_FUNC___pkvm_init,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_init =  
> __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
>   	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
>   	__KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector,
>   	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
> @@ -247,8 +246,6 @@ extern void __kvm_adjust_pc(struct kvm_vcpu *vcpu);
>   extern u64 __vgic_v3_get_gic_config(void);
>   extern void __vgic_v3_init_lrs(void);

> -extern u64 __kvm_get_mdcr_el2(void);
> -
>   #define __KVM_EXTABLE(from, to)						\
>   	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
>   	"	.align		3\n"					\
> diff --git a/arch/arm64/include/asm/kvm_host.h  
> b/arch/arm64/include/asm/kvm_host.h
> index f333b189fb43..ad514434f3fe 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -642,7 +642,7 @@ struct kvm_host_data {
>   	 * host_debug_state contains the host registers which are
>   	 * saved and restored during world switches.
>   	 */
> -	 struct {
> +	struct {
>   		/* {Break,watch}point registers */
>   		struct kvm_guest_debug_arch regs;
>   		/* Statistical profiling extension */
> @@ -652,6 +652,9 @@ struct kvm_host_data {
>   		/* Values of trap registers for the host before guest entry. */
>   		u64 mdcr_el2;
>   	} host_debug_state;
> +
> +	/* Number of programmable event counters (PMCR_EL0.N) for this CPU */
> +	unsigned int nr_event_counters;
>   };

>   struct kvm_host_psci_config {
> @@ -1332,7 +1335,7 @@ static inline bool  
> kvm_system_needs_idmapped_vectors(void)

>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}

> -void kvm_arm_init_debug(void);
> +void kvm_init_host_debug_data(void);
>   void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
>   void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>   void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a102c3aebdbc..ab1bf9ccf385 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2109,6 +2109,7 @@ static void cpu_set_hyp_vector(void)
>   static void cpu_hyp_init_context(void)
>   {
>   	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
> +	kvm_init_host_debug_data();

>   	if (!is_kernel_in_hyp_mode())
>   		cpu_init_hyp_mode();
> @@ -2117,7 +2118,6 @@ static void cpu_hyp_init_context(void)
>   static void cpu_hyp_init_features(void)
>   {
>   	cpu_set_hyp_vector();
> -	kvm_arm_init_debug();

>   	if (is_kernel_in_hyp_mode())
>   		kvm_timer_init_vhe();
> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
> index 587e9eb4372e..d8ea6fe6a2a2 100644
> --- a/arch/arm64/kvm/debug.c
> +++ b/arch/arm64/kvm/debug.c
> @@ -16,8 +16,6 @@

>   #include "trace.h"

> -static DEFINE_PER_CPU(u64, mdcr_el2);
> -
>   /*
>    * save/restore_guest_debug_regs
>    *
> @@ -60,21 +58,6 @@ static void restore_guest_debug_regs(struct kvm_vcpu  
> *vcpu)
>   		*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
>   }

> -/**
> - * kvm_arm_init_debug - grab what we need for debug
> - *
> - * Currently the sole task of this function is to retrieve the initial
> - * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
> - * presumably been set-up by some knowledgeable bootcode.
> - *
> - * It is called once per-cpu during CPU hyp initialisation.
> - */
> -
> -void kvm_arm_init_debug(void)
> -{
> -	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
> -}
> -
>   /**
>    * kvm_arm_setup_mdcr_el2 - configure vcpu mdcr_el2 value
>    *
> @@ -94,7 +77,8 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu  
> *vcpu)
>   	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
>   	 * to disable guest access to the profiling and trace buffers
>   	 */
> -	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
> +	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,

MDCR_EL2_HPMN is not defined

> +					 *host_data_ptr(nr_event_counters));
>   	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>   				MDCR_EL2_TPMS |
>   				MDCR_EL2_TTRF |
> @@ -338,3 +322,12 @@ void kvm_arch_vcpu_put_debug_state_flags(struct  
> kvm_vcpu *vcpu)
>   	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
>   	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
>   }
> +
> +void kvm_init_host_debug_data(void)
> +{
> +	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
> +
> +	if (cpuid_feature_extract_signed_field(dfr0,  
> ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
> +		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
> +							      read_sysreg(pmcr_el0));
> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c  
> b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> index 53efda0235cf..1e2a26d0196e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
> @@ -106,8 +106,3 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
>   {
>   	__debug_switch_to_host_common(vcpu);
>   }
> -
> -u64 __kvm_get_mdcr_el2(void)
> -{
> -	return read_sysreg(mdcr_el2);
> -}
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c  
> b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 6aa0b13d86e5..16f5da3a884a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -264,11 +264,6 @@ static void handle___vgic_v3_init_lrs(struct  
> kvm_cpu_context *host_ctxt)
>   	__vgic_v3_init_lrs();
>   }

> -static void handle___kvm_get_mdcr_el2(struct kvm_cpu_context *host_ctxt)
> -{
> -	cpu_reg(host_ctxt, 1) = __kvm_get_mdcr_el2();
> -}
> -
>   static void handle___vgic_v3_save_vmcr_aprs(struct kvm_cpu_context  
> *host_ctxt)
>   {
>   	DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> @@ -384,7 +379,6 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);

>   static const hcall_t host_hcall[] = {
>   	/* ___kvm_hyp_init */
> -	HANDLE_FUNC(__kvm_get_mdcr_el2),
>   	HANDLE_FUNC(__pkvm_init),
>   	HANDLE_FUNC(__pkvm_create_private_mapping),
>   	HANDLE_FUNC(__pkvm_cpu_set_vector),
> diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c  
> b/arch/arm64/kvm/hyp/vhe/debug-sr.c
> index 289689b2682d..0100339b09e0 100644
> --- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
> @@ -19,8 +19,3 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
>   {
>   	__debug_switch_to_host_common(vcpu);
>   }
> -
> -u64 __kvm_get_mdcr_el2(void)
> -{
> -	return read_sysreg(mdcr_el2);
> -}
