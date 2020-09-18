Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F377C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 12:22:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5FAEA22208
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 12:22:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ho57Ufnq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FAEA22208
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC8E24B1A0;
	Fri, 18 Sep 2020 08:22:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WkWRV-RTrPTf; Fri, 18 Sep 2020 08:22:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8746A4B19B;
	Fri, 18 Sep 2020 08:22:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 680F24B19B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 08:22:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9wbQp38mUQjr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 08:22:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0227C4B148
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 08:22:26 -0400 (EDT)
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 97B6F20874;
 Fri, 18 Sep 2020 12:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1600431745;
 bh=Hd7XQn/UXrKDXJIU/D9pWYIKR1CmKZZuKET/jaQFL+0=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=Ho57UfnqY8P+1yT8oCZIsDe/Q/7W66xw2EJkWVGVEJAyDuODSFyV9TpnQgwyWzMMl
 AKwTNLsIZtglBDp6uG0BFuypVmjBXEapEVZJ4G/n4h8No8bnsssZCQEhjueDlBsPxC
 1t6ONrexn6uJkKXxmhLEy3WDDjAtswjN7BbMUF7I=
Date: Fri, 18 Sep 2020 13:22:20 +0100
From: Will Deacon <will@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v3 10/11] kvm: arm64: Set up hyp percpu data for nVHE
Message-ID: <20200918122219.GD31096@willie-the-truck>
References: <20200916173439.32265-1-dbrazdil@google.com>
 <20200916173439.32265-11-dbrazdil@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200916173439.32265-11-dbrazdil@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, kernel-team@android.com,
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

On Wed, Sep 16, 2020 at 06:34:38PM +0100, David Brazdil wrote:
> Add hyp percpu section to linker script and rename the corresponding ELF
> sections of hyp/nvhe object files. This moves all nVHE-specific percpu
> variables to the new hyp percpu section.
> 
> Allocate sufficient amount of memory for all percpu hyp regions at global KVM
> init time and create corresponding hyp mappings.
> 
> The base addresses of hyp percpu regions are kept in a dynamically allocated
> array in the kernel.
> 
> Add NULL checks in PMU event-reset code as it may run before KVM memory is
> initialized.
> 
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h  | 19 +++++++++--
>  arch/arm64/include/asm/sections.h |  1 +
>  arch/arm64/kernel/vmlinux.lds.S   |  9 +++++
>  arch/arm64/kvm/arm.c              | 56 +++++++++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/nvhe/hyp.lds.S |  6 ++++
>  arch/arm64/kvm/pmu.c              |  5 ++-
>  6 files changed, 90 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index abc03f386b40..e0e1e404f6eb 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -66,8 +66,23 @@
>  #define CHOOSE_VHE_SYM(sym)	sym
>  #define CHOOSE_NVHE_SYM(sym)	kvm_nvhe_sym(sym)
>  
> -#define this_cpu_ptr_nvhe(sym)		this_cpu_ptr(&kvm_nvhe_sym(sym))
> -#define per_cpu_ptr_nvhe(sym, cpu)	per_cpu_ptr(&kvm_nvhe_sym(sym), cpu)
> +/* Array of percpu base addresses. Length of the array is nr_cpu_ids. */
> +extern unsigned long *kvm_arm_hyp_percpu_base;
> +
> +/*
> + * Compute pointer to a symbol defined in nVHE percpu region.
> + * Returns NULL if percpu memory has not been allocated yet.
> + */
> +#define this_cpu_ptr_nvhe(sym)	per_cpu_ptr_nvhe(sym, smp_processor_id())

Don't you run into similar problems here with the pcpu accessors when
CONFIG_DEBUG_PREEMPT=y? I'm worried we can end up with an unresolved
reference to debug_smp_processor_id().

> +#define per_cpu_ptr_nvhe(sym, cpu)					\
> +	({								\
> +		unsigned long base, off;				\
> +		base = kvm_arm_hyp_percpu_base				\
> +			? kvm_arm_hyp_percpu_base[cpu] : 0;		\
> +		off = (unsigned long)&kvm_nvhe_sym(sym) -		\
> +		      (unsigned long)&kvm_nvhe_sym(__per_cpu_start);	\
> +		base ? (typeof(kvm_nvhe_sym(sym))*)(base + off) : NULL;	\
> +	})
>  
>  #ifndef __KVM_NVHE_HYPERVISOR__
>  /*
> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
> index 3994169985ef..5062553a6847 100644
> --- a/arch/arm64/include/asm/sections.h
> +++ b/arch/arm64/include/asm/sections.h
> @@ -18,5 +18,6 @@ extern char __exittext_begin[], __exittext_end[];
>  extern char __irqentry_text_start[], __irqentry_text_end[];
>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
>  extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
> +extern char __kvm_nvhe___per_cpu_start[], __kvm_nvhe___per_cpu_end[];
>  
>  #endif /* __ASM_SECTIONS_H */
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 0d543570e811..d52e6b5dbfd3 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -9,6 +9,7 @@
>  
>  #include <asm-generic/vmlinux.lds.h>
>  #include <asm/cache.h>
> +#include <asm/hyp_image.h>
>  #include <asm/kernel-pgtable.h>
>  #include <asm/memory.h>
>  #include <asm/page.h>
> @@ -27,8 +28,15 @@ jiffies = jiffies_64;
>  	__start___kvm_ex_table = .;				\
>  	*(__kvm_ex_table)					\
>  	__stop___kvm_ex_table = .;
> +
> +#define HYPERVISOR_PERCPU_SECTION				\
> +	. = ALIGN(PAGE_SIZE);					\
> +	HYP_SECTION_NAME(.data..percpu) : {			\
> +		*(HYP_SECTION_NAME(.data..percpu))		\
> +	}
>  #else /* CONFIG_KVM */
>  #define HYPERVISOR_EXTABLE
> +#define HYPERVISOR_PERCPU_SECTION
>  #endif
>  
>  #define HYPERVISOR_TEXT					\
> @@ -194,6 +202,7 @@ SECTIONS
>  	}
>  
>  	PERCPU_SECTION(L1_CACHE_BYTES)
> +	HYPERVISOR_PERCPU_SECTION
>  
>  	.rela.dyn : ALIGN(8) {
>  		*(.rela .rela*)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 58d7d614519b..8293319a32e7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -47,6 +47,7 @@ __asm__(".arch_extension	virt");
>  #endif
>  
>  static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
> +unsigned long *kvm_arm_hyp_percpu_base;
>  
>  /* The VMID used in the VTTBR */
>  static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
> @@ -1258,6 +1259,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	}
>  }
>  
> +#define kvm_hyp_percpu_base(cpu)	((unsigned long)per_cpu_ptr_nvhe(__per_cpu_start, cpu))

Having both kvm_arm_hyp_percpu_base and kvm_hyp_percpu_base be so
completely different is a recipe for disaster! Please can you rename
one/both of them to make it clearer what they represent?

> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 6d80ffe1ebfc..cd653091f213 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -33,7 +33,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
>  {
>  	struct kvm_host_data *ctx = this_cpu_ptr_hyp(kvm_host_data);
>  
> -	if (!kvm_pmu_switch_needed(attr))
> +	if (!ctx || !kvm_pmu_switch_needed(attr))
>  		return;
>  
>  	if (!attr->exclude_host)
> @@ -49,6 +49,9 @@ void kvm_clr_pmu_events(u32 clr)
>  {
>  	struct kvm_host_data *ctx = this_cpu_ptr_hyp(kvm_host_data);
>  
> +	if (!ctx)
> +		return;

I guess this should only happen if KVM failed to initialise or something,
right? (e.g. if we were booted at EL1). If so, I'm wondering whether it
would be better to do something like:

	if (!is_hyp_mode_available())
		return;

	WARN_ON_ONCE(!ctx);

so that any unexpected NULL pointer there screams loudly, rather than causes
the register switch to be silently ignored. What do you think?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
