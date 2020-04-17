Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AD1C2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:03:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2123B207FC
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 14:03:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2123B207FC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AB884B0D6;
	Fri, 17 Apr 2020 10:03:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YX0yE1MLVAAG; Fri, 17 Apr 2020 10:03:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E13C4B0E8;
	Fri, 17 Apr 2020 10:03:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2F5C4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:03:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MnXGx6OupP9m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 10:03:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 605874B0C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 10:03:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F20F0106F;
 Fri, 17 Apr 2020 07:03:37 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CFF53F73D;
 Fri, 17 Apr 2020 07:03:35 -0700 (PDT)
Date: Fri, 17 Apr 2020 15:03:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Kill off CONFIG_KVM_ARM_HOST
Message-ID: <20200417140314.GA53632@C02TD0UTHF1T.local>
References: <20200417135801.82871-1-tabba@google.com>
 <20200417135801.82871-2-tabba@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200417135801.82871-2-tabba@google.com>
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

Hi Fuad,

On Fri, Apr 17, 2020 at 02:57:58PM +0100, Fuad Tabba wrote:
> From: Will Deacon <will@kernel.org>
> 
> CONFIG_KVM_ARM_HOST is just a proxy for CONFIG_KVM, so remove it in favour
> of the latter.
> 
> Signed-off-by: Will Deacon <will@kernel.org>

As a general thing, when sending patches written by others, you must
append your own S-o-B to the chain. Please see:

https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

That pplies to patches 1-3 in this series.

Thanks,
Mark.

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
