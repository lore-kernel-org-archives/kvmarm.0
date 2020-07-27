Return-Path: <SRS0=4Xsg=BG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6708DC433E0
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 15:52:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D50A720672
	for <kvmarm@archiver.kernel.org>; Mon, 27 Jul 2020 15:52:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="EvzXLf+B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D50A720672
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36EDB4B740;
	Mon, 27 Jul 2020 11:52:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oAQ0x5A7Q6nN; Mon, 27 Jul 2020 11:52:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E0A44B7B4;
	Mon, 27 Jul 2020 11:52:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 332AB4B6F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 11:52:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SDf-XGSC2m0c for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Jul 2020 11:52:30 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60B924B6DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 11:52:30 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id x5so14050712wmi.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Jul 2020 08:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Mn0Urz92UU9LVjuFdfizc6ddLvolCgKVoWLXE4zwaYM=;
 b=EvzXLf+Brx8EXEZssEwtI32mCtWkfEY9ZvEfBHtKmYVgnH0JuIXZj82lAjTvM/91A7
 yAixwbJueHh654t9bEfDZ+M8HvVxDUrPDeRUq/52Ejj1visQaySiVJ73HkVhhcKkNZYJ
 4m99zN0VWcBwy6B3H/XZ1V5agDRr7pPXDzNpUz5AD7UNLLKQwghL73/UD4MMPO0E+OSB
 6Wc4BU5Qz130yyzyHookCjwwt9uejGBZgj7cBZsCMWbUAmsh+iiu0GsSKuKvjZJWqInf
 J47kC75L3EJAYaxpdy/lYVg/bxFYsg4G8r5fH6SOABpRH2jH7BspTjM/1BefAm/gEc4L
 X48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Mn0Urz92UU9LVjuFdfizc6ddLvolCgKVoWLXE4zwaYM=;
 b=W8p6ocwtEAj86TP7C86QXz4Z+lrHRfpWXoGwk0emeJUL1V38OLS8M5/k2R4cSPHCe+
 VXGhQkIqERYcNTdwpUH6bGnOz+YouuikBYy+fE1h0BaMb19XN2YevT+nzGBJnUMxjoHl
 QxBF4r+VjP12qXc0qR5bDtjzQzFhYOF/2ylgHb3Pm5UPLRT9B+H6G9QFyIFKuw4vJ2/E
 gegcGjaeoiOcqDv9jhbipXTgcLbPbvWe+xgn3FIJIEcc+hnW6QyXyPkaaE9Xkj0drIGt
 BUVCr5HH+BZGLttoec1ANEroegBWPDqA45cMc0z6cwX+rz6oVH+KPEqMTfPZsyEieiSI
 3aGw==
X-Gm-Message-State: AOAM532/+fOtpYhfNto/OJmaO343H0UWV0EMMtSEnYbmD4hWbfFGQrJX
 csjgyWR8e7TBPVE2Fwslw0Q2iA==
X-Google-Smtp-Source: ABdhPJwvL8HLv6LPTvCz8owMoACj90tYuB4FL7OPlDP1ypP8suVUlSyJ+LYTDZi5A7SiwBx96LTGnQ==
X-Received: by 2002:a1c:5453:: with SMTP id p19mr20417847wmi.41.1595865149046; 
 Mon, 27 Jul 2020 08:52:29 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 by smtp.gmail.com with ESMTPSA id v11sm11098386wrr.10.2020.07.27.08.52.27
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Jul 2020 08:52:28 -0700 (PDT)
Date: Mon, 27 Jul 2020 16:52:23 +0100
From: Andrew Scull <ascull@google.com>
To: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 3/3] arm64: Add workaround for Arm Cortex-A77 erratum
 1508412
Message-ID: <20200727155223.GA4105970@google.com>
References: <20200717205233.903344-1-robh@kernel.org>
 <20200717205233.903344-4-robh@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200717205233.903344-4-robh@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Rob, a couple of suggestions for way this erratum is gated, but I
haven't delved into the details of the errata itself.

On Fri, Jul 17, 2020 at 02:52:33PM -0600, Rob Herring wrote:
> On Cortex-A77 r0p0 and r1p0, a sequence of a non-cacheable or device load
> and a store exclusive or PAR_EL1 read can cause a deadlock.
> 
> The workaround requires a DMB SY before and after a PAR_EL1 register read.
> A deadlock is still possible with the workaround as KVM guests must also
> have the workaround. IOW, a malicious guest can deadlock an affected
> systems.
> 
> This workaround also depends on a firmware counterpart to enable the h/w
> to insert DMB SY after load and store exclusive instructions. See the
> errata document SDEN-1152370 v10 [1] for more information.
> 
> [1] https://static.docs.arm.com/101992/0010/Arm_Cortex_A77_MP074_Software_Developer_Errata_Notice_v10.pdf
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> v3:
> - Add dmbs around PAR reads in KVM code
> - Clean-up 'work-around' and 'errata'
> 
> v2:
> - Don't disable KVM, just print warning
> ---
>  Documentation/arm64/silicon-errata.rst |  2 ++
>  arch/arm64/Kconfig                     | 19 +++++++++++++++++++
>  arch/arm64/include/asm/cpucaps.h       |  3 ++-
>  arch/arm64/include/asm/kvm_hyp.h       | 11 +++++++++++
>  arch/arm64/kernel/cpu_errata.c         | 10 ++++++++++
>  arch/arm64/kvm/arm.c                   |  3 ++-
>  arch/arm64/kvm/hyp/switch.c            |  7 ++++---
>  arch/arm64/kvm/hyp/sysreg-sr.c         |  2 +-
>  arch/arm64/kvm/sys_regs.c              |  8 +++++++-
>  arch/arm64/mm/fault.c                  | 10 ++++++++++
>  10 files changed, 68 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
> index 936cf2a59ca4..716b279e3b33 100644
> --- a/Documentation/arm64/silicon-errata.rst
> +++ b/Documentation/arm64/silicon-errata.rst
> @@ -90,6 +90,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
>  +----------------+-----------------+-----------------+-----------------------------+
> +| ARM            | Cortex-A77      | #1508412        | ARM64_ERRATUM_1508412       |
> ++----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | Neoverse-N1     | #1349291        | N/A                         |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index a4a094bedcb2..6638444ce0d8 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -626,6 +626,25 @@ config ARM64_ERRATUM_1542419
>  
>  	  If unsure, say Y.
>  
> +config ARM64_ERRATUM_1508412
> +	bool "Cortex-A77: 1508412: workaround deadlock on sequence of NC/Device load and store exclusive or PAR read"
> +	default y
> +	help
> +	  This option adds a workaround for Arm Cortex-A77 erratum 1508412.
> +
> +	  Affected Cortex-A77 cores (r0p0, r1p0) could deadlock on a sequence
> +	  of a store-exclusive or read of PAR_EL1 and a load with device or
> +	  non-cacheable memory attributes. The workaround depends on a firmware
> +	  counterpart.
> +
> +	  KVM guests must also have the workaround implemented or they can
> +	  deadlock the system.
> +
> +	  Work around the issue by inserting DMB SY barriers around PAR_EL1
> +	  register reads and warning KVM users.
> +
> +	  If unsure, say Y.
> +
>  config CAVIUM_ERRATUM_22375
>  	bool "Cavium erratum 22375, 24313"
>  	default y
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index d7b3bb0cb180..2a2cdb4ced8b 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -62,7 +62,8 @@
>  #define ARM64_HAS_GENERIC_AUTH			52
>  #define ARM64_HAS_32BIT_EL1			53
>  #define ARM64_BTI				54
> +#define ARM64_WORKAROUND_1508412		55
>  
> -#define ARM64_NCAPS				55
> +#define ARM64_NCAPS				56
>  
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index ce3080834bfa..ce5b0d9b12bf 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -46,6 +46,17 @@
>  #define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
>  #define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
>  
> +static inline u64 __hyp_text read_sysreg_par(void)
> +{
> +	u64 par;
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +		dmb(sy);
> +	par = read_sysreg(par_el1);
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +		dmb(sy);
> +	return par;
> +}
> +
>  /*
>   * Without an __arch_swab32(), we fall back to ___constant_swab32(), but the
>   * static inline can allow the compiler to out-of-line this. KVM always wants
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index ad06d6802d2e..5eee8a75540c 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -938,6 +938,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		.matches = has_neoverse_n1_erratum_1542419,
>  		.cpu_enable = cpu_enable_trap_ctr_access,
>  	},
> +#endif
> +#ifdef CONFIG_ARM64_ERRATUM_1508412
> +	{
> +		/* we depend on the firmware portion for correctness */
> +		.desc = "ARM erratum 1508412 (kernel portion)",
> +		.capability = ARM64_WORKAROUND_1508412,
> +		ERRATA_MIDR_RANGE(MIDR_CORTEX_A77,
> +				  0, 0,
> +				  1, 0),
> +	},
>  #endif
>  	{
>  	}
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 9b070b5e212b..21d8b3ca5bd7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1653,7 +1653,8 @@ int kvm_arch_init(void *opaque)
>  		return -ENODEV;
>  	}
>  
> -	if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE))
> +	if (cpus_have_const_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
> +	    cpus_have_const_cap(ARM64_WORKAROUND_1508412))

By the time KVM is initialized, it's safe to use cpus_have_final_cap
rather than cpus_have_const_cap as the capabilities will have been
finalized.

It looks as though the other places that the capabilities are checked
happen after this point so they can also use cpus_have_final_cap.

>  		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
>  			 "Only trusted guests should be used on this system.\n");
>  
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index db1c4487d95d..d76b6638b705 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -298,11 +298,12 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  	 * We do need to save/restore PAR_EL1 though, as we haven't
>  	 * saved the guest context yet, and we may return early...
>  	 */
> -	par = read_sysreg(par_el1);
> +	par = read_sysreg_par();
> +
>  	asm volatile("at s1e1r, %0" : : "r" (far));
>  	isb();
>  
> -	tmp = read_sysreg(par_el1);
> +	tmp = read_sysreg_par();
>  	write_sysreg(par, par_el1);
>  
>  	if (unlikely(tmp & SYS_PAR_EL1_F))
> @@ -925,7 +926,7 @@ void __hyp_text __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
>  {
>  	u64 spsr = read_sysreg_el2(SYS_SPSR);
>  	u64 elr = read_sysreg_el2(SYS_ELR);
> -	u64 par = read_sysreg(par_el1);
> +	u64 par = read_sysreg_par();
>  
>  	if (!has_vhe())
>  		__hyp_call_panic_nvhe(spsr, elr, par, host_ctxt);
> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
> index cc7e957f5b2c..f522cbff291d 100644
> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
> @@ -52,7 +52,7 @@ static void __hyp_text __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  	ctxt->sys_regs[CONTEXTIDR_EL1]	= read_sysreg_el1(SYS_CONTEXTIDR);
>  	ctxt->sys_regs[AMAIR_EL1]	= read_sysreg_el1(SYS_AMAIR);
>  	ctxt->sys_regs[CNTKCTL_EL1]	= read_sysreg_el1(SYS_CNTKCTL);
> -	ctxt->sys_regs[PAR_EL1]		= read_sysreg(par_el1);
> +	ctxt->sys_regs[PAR_EL1]		= read_sysreg_par();
>  	ctxt->sys_regs[TPIDR_EL1]	= read_sysreg(tpidr_el1);
>  
>  	ctxt->gp_regs.sp_el1		= read_sysreg(sp_el1);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index baf5ce9225ce..3f798e0f1419 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -94,10 +94,16 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
>  	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
>  	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
>  	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
> -	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
>  	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
>  	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
>  	case DBGVCR32_EL2:	*val = read_sysreg_s(SYS_DBGVCR32_EL2);	break;
> +	case PAR_EL1:
> +		if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +			dmb(sy);
> +		*val = read_sysreg_s(SYS_PAR_EL1);
> +		if (cpus_have_const_cap(ARM64_WORKAROUND_1508412))
> +			dmb(sy);
> +		break;
>  	default:		return false;
>  	}
>  
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 8afb238ff335..98609532e61a 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -260,7 +260,17 @@ static bool __kprobes is_spurious_el1_translation_fault(unsigned long addr,
>  	local_irq_save(flags);
>  	asm volatile("at s1e1r, %0" :: "r" (addr));
>  	isb();
> +	/*
> +	 * Arm Erratum 1508412 requires dmb(sy) before and after reads of
> +	 * PAR_EL1.
> +	 * As this location is not a hot path, just condition it on the config
> +	 * option.
> +	 */
> +	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
> +		dmb(sy);
>  	par = read_sysreg(par_el1);
> +	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_1508412))
> +		dmb(sy);

Having the condition simply based on the config can bring the additional
DMBs even if the CPU isn't affected by this erratum. The config is
default y so this doesn't seem like an unlikely situation.

The comment mentions that this is a hot path so would an alternative be
applicable? That's the approach taken for the speculative AT errata.

  asm(ALTERNATIVE("nop", "dmb sy", ARM64_ERRATUM_1508412));

>  	local_irq_restore(flags);
>  
>  	/*
> -- 
> 2.25.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
