Return-Path: <SRS0=QomF=6E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A38C3815B
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 13:37:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEF2720857
	for <kvmarm@archiver.kernel.org>; Mon, 20 Apr 2020 13:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="kPj7agkm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEF2720857
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FBF14B135;
	Mon, 20 Apr 2020 09:37:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id as1U3A6imW4a; Mon, 20 Apr 2020 09:37:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E06D74B12C;
	Mon, 20 Apr 2020 09:37:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBCA44B129
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 09:37:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q4p4ztaoXeWE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Apr 2020 09:37:21 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 637E64B0FC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 09:37:21 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id r26so11452507wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Apr 2020 06:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:date:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=BLAHTYVLykyAFNf8wRqZjn2QntSGVk3ZjCApuPikmyY=;
 b=kPj7agkmsJbRTEhY9gZECvzMUnVjow/pHLabt5Rz4A4gvBD/3+WxgH4FaTYlNQwAiV
 APgeY+cHsV5Vss6ilHxA2xmU5WGBPAkYE409yFcJSegDhyi0rggFUlyCquJezz69HznN
 2vcUmThUbTW6cdAen1D/LxK2hqVjHs/kQ06W/vbqgZXhIQ17MTR0wghyX9iZvoZs7tia
 YJfRA6+StGUxa/E81bZGo5ZwaOBeGVfyESQAv1XNGQnzo3jVsTaZJHbjVJ1vOdaiaX+1
 VuYqCKdST4I9OSW/tNaHhbV0JtNL8E57/CyWJYsUrQ9Ydr2VaZe6NTZEjHs6Wm1A9rne
 3xOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:date:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=BLAHTYVLykyAFNf8wRqZjn2QntSGVk3ZjCApuPikmyY=;
 b=aqzDmFV4qc3VjdLC/xFXqOdAMVCYXq8jMfgcrF4FwjHtexlvv7hpdbKjcxfThvSrVS
 MK84D0NaZJ8wzF3kK/AIBGEn1ZouR0nsU/so0Lebzma4LwsDeTLNr3AZXZG8iKpS0B5u
 VCVCt+Cfk9hdHxWkvQM6KrSuPzeDFkHsmAMyIEbq0wb5LekNlA+m18HsOVyPgtECsQ+h
 Gqq1jVJHpGLq8WkftVzz7eafTj7XhBmwR6vGE+rGn5rD4ezVlMy5o8wbr/SAN/EaJazQ
 /dhisc8j/q+USyXqztY4zfIGuLAacpbFWxIjqk7oSlEKUn0K+Hr7fqNF9Hz8dHfRexhJ
 3cUw==
X-Gm-Message-State: AGi0Puah4gyC1f23hgiFUc1UxPf44dqWUVg29AP2eUc4A4+u3GyCDjq5
 ySvnDdDJJzdNfFo/Ky8UB4XgEQ==
X-Google-Smtp-Source: APiQypLPIANe9CN7y6tqsUYix8muuLwwoeqZmtOfhmQp7V7bhrUxE1q24ur/wJFsDhFEJCYfp0TKtg==
X-Received: by 2002:a1c:4ca:: with SMTP id 193mr17995360wme.18.1587389839900; 
 Mon, 20 Apr 2020 06:37:19 -0700 (PDT)
Received: from dbrazdil-macbookpro.roam.corp.google.com
 ([2a01:4b00:8523:2d03:3d2b:8fad:27b3:46fc])
 by smtp.gmail.com with ESMTPSA id a67sm1475822wmc.30.2020.04.20.06.37.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 20 Apr 2020 06:37:19 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
X-Google-Original-From: David Brazdil
 <dbrazdil@dbrazdil-macbookpro.roam.corp.google.com>
Date: Mon, 20 Apr 2020 14:37:18 +0100
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 1/4] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
Message-ID: <20200420133718.wbpspunss6gawi5m@dbrazdil-macbookpro.roam.corp.google.com>
References: <20200417140821.89974-1-tabba@google.com>
 <20200417140821.89974-2-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200417140821.89974-2-tabba@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

CONFIG_KVM_ARM_HOST has one more use in arch/arm64/kernel/cpu_errata.c.

-David

On Fri, Apr 17, 2020 at 03:08:18PM +0100, Fuad Tabba wrote:
> From: Will Deacon <will@kernel.org>
> 
> CONFIG_KVM_ARM_HOST is just a proxy for CONFIG_KVM, so remove it in favour
> of the latter.
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kernel/asm-offsets.c |  2 +-
>  arch/arm64/kernel/smp.c         |  2 +-
>  arch/arm64/kvm/Kconfig          |  6 ----
>  arch/arm64/kvm/Makefile         | 54 ++++++++++++++++-----------------
>  arch/arm64/kvm/hyp/Makefile     | 22 +++++++-------
>  5 files changed, 40 insertions(+), 46 deletions(-)
> 
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 9981a0a5a87f..a27e0cd731e9 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -96,7 +96,7 @@ int main(void)
>    DEFINE(CPU_BOOT_PTRAUTH_KEY,	offsetof(struct secondary_data, ptrauth_key));
>  #endif
>    BLANK();
> -#ifdef CONFIG_KVM_ARM_HOST
> +#ifdef CONFIG_KVM
>    DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
>    DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
>    DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index 061f60fe452f..0a3045d9f33f 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -430,7 +430,7 @@ static void __init hyp_mode_check(void)
>  			   "CPU: CPUs started in inconsistent modes");
>  	else
>  		pr_info("CPU: All CPU(s) started at EL1\n");
> -	if (IS_ENABLED(CONFIG_KVM_ARM_HOST))
> +	if (IS_ENABLED(CONFIG_KVM))
>  		kvm_compute_layout();
>  }
>  
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 449386d76441..ce724e526689 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -28,7 +28,6 @@ config KVM
>  	select HAVE_KVM_CPU_RELAX_INTERCEPT
>  	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
>  	select KVM_MMIO
> -	select KVM_ARM_HOST
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select SRCU
>  	select KVM_VFIO
> @@ -50,11 +49,6 @@ config KVM
>  
>  	  If unsure, say N.
>  
> -config KVM_ARM_HOST
> -	bool
> -	---help---
> -	  Provides host support for ARM processors.
> -
>  config KVM_ARM_PMU
>  	bool
>  	---help---
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 7a3768538343..a5334b91729a 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -7,33 +7,33 @@ ccflags-y += -I $(srctree)/$(src)
>  
>  KVM=../../../virt/kvm
>  
> -obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
> -obj-$(CONFIG_KVM_ARM_HOST) += hyp/
> +obj-$(CONFIG_KVM) += kvm.o
> +obj-$(CONFIG_KVM) += hyp/
>  
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += arm.o mmu.o mmio.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += psci.o perf.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += hypercalls.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += pvtime.o
> +kvm-$(CONFIG_KVM) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> +kvm-$(CONFIG_KVM) += $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
> +kvm-$(CONFIG_KVM) += arm.o mmu.o mmio.o
> +kvm-$(CONFIG_KVM) += psci.o perf.o
> +kvm-$(CONFIG_KVM) += hypercalls.o
> +kvm-$(CONFIG_KVM) += pvtime.o
>  
> -kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o fpsimd.o pmu.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += aarch32.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += arch_timer.o
> -kvm-$(CONFIG_KVM_ARM_PMU)  += pmu-emul.o
> +kvm-$(CONFIG_KVM) += inject_fault.o regmap.o va_layout.o
> +kvm-$(CONFIG_KVM) += hyp.o hyp-init.o handle_exit.o
> +kvm-$(CONFIG_KVM) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
> +kvm-$(CONFIG_KVM) += vgic-sys-reg-v3.o fpsimd.o pmu.o
> +kvm-$(CONFIG_KVM) += aarch32.o
> +kvm-$(CONFIG_KVM) += arch_timer.o
> +kvm-$(CONFIG_KVM)  += pmu-emul.o
>  
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-init.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-irqfd.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v2.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v3.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-v4.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v2.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-mmio-v3.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-kvm-device.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-its.o
> -kvm-$(CONFIG_KVM_ARM_HOST) += vgic/vgic-debug.o
> +kvm-$(CONFIG_KVM) += vgic/vgic.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-init.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-irqfd.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-v2.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-v3.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-v4.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-mmio.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v2.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-mmio-v3.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-kvm-device.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-its.o
> +kvm-$(CONFIG_KVM) += vgic/vgic-debug.o
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index dc18274a6826..8229e47ba870 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -6,17 +6,17 @@
>  ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
>  		$(DISABLE_STACKLEAK_PLUGIN)
>  
> -obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
> -obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
> -obj-$(CONFIG_KVM_ARM_HOST) += aarch32.o
> -obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-cpuif-proxy.o
> -obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
> -obj-$(CONFIG_KVM_ARM_HOST) += debug-sr.o
> -obj-$(CONFIG_KVM_ARM_HOST) += entry.o
> -obj-$(CONFIG_KVM_ARM_HOST) += switch.o
> -obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
> -obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
> -obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
> +obj-$(CONFIG_KVM) += vgic-v3-sr.o
> +obj-$(CONFIG_KVM) += timer-sr.o
> +obj-$(CONFIG_KVM) += aarch32.o
> +obj-$(CONFIG_KVM) += vgic-v2-cpuif-proxy.o
> +obj-$(CONFIG_KVM) += sysreg-sr.o
> +obj-$(CONFIG_KVM) += debug-sr.o
> +obj-$(CONFIG_KVM) += entry.o
> +obj-$(CONFIG_KVM) += switch.o
> +obj-$(CONFIG_KVM) += fpsimd.o
> +obj-$(CONFIG_KVM) += tlb.o
> +obj-$(CONFIG_KVM) += hyp-entry.o
>  
>  # KVM code is run at a different exception code with a different map, so
>  # compiler instrumentation that inserts callbacks or checks into the code may
> -- 
> 2.26.1.301.g55bc3eb7cb9-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
