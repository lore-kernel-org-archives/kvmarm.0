Return-Path: <SRS0=QgbO=ID=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC067C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 19:29:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1899E650A0
	for <kvmarm@archiver.kernel.org>; Fri,  5 Mar 2021 19:29:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1899E650A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9482F4B634;
	Fri,  5 Mar 2021 14:29:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bgzMdvB+-N1Z; Fri,  5 Mar 2021 14:29:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB7F4B675;
	Fri,  5 Mar 2021 14:29:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 841584B634
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 14:29:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l7Eu9J87ABCo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Mar 2021 14:29:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D35574B5C9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Mar 2021 14:29:13 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC9B56509A;
 Fri,  5 Mar 2021 19:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1614972552;
 bh=2WBMDTvXQtzlI7ywRD6GsmWHjJN+guwzXMlKa+9gnc8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=lC9uhofo4z+yqXaJLcEjoukEaY9eJa6EZ5c7ZtcvtUyys9JwMFUOVFlqpS/UAiFJ4
 1B7V2FGbEaGnCvsI8XUi3vzZpqi/7xoRZl850PqGoGzPor0g0LDrIgwUT9JnJ4OyHw
 okrdmaw6MqUOHCgP+pY2UtKjJoI+XKj17+HjGKd2W7Ph0lHHicehPrEyHDccX5G8BD
 hotYWL/bt2zRsvuT4su1VhSc9vTSaoucggBzHPQsod4uqNvWYc1sKlUCb8XyUaKkNK
 NdncBhpEWYLYiz4ODvSZSyRdI0DIdz2BsjLaCGVoYDe/zR8bdVbMCt+2o70J8dmrq4
 7wY/EyZD7wkGw==
Date: Fri, 5 Mar 2021 19:29:06 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 29/32] KVM: arm64: Wrap the host with a stage 2
Message-ID: <20210305192905.GE23633@willie-the-truck>
References: <20210302150002.3685113-1-qperret@google.com>
 <20210302150002.3685113-30-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210302150002.3685113-30-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Tue, Mar 02, 2021 at 02:59:59PM +0000, Quentin Perret wrote:
> When KVM runs in protected nVHE mode, make use of a stage 2 page-table
> to give the hypervisor some control over the host memory accesses. The
> host stage 2 is created lazily using large block mappings if possible,
> and will default to page mappings in absence of a better solution.
> 
> From this point on, memory accesses from the host to protected memory
> regions (e.g. marked PROT_NONE) are fatal and lead to hyp_panic().
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |   1 +
>  arch/arm64/include/asm/kvm_cpufeature.h       |   2 +
>  arch/arm64/kernel/image-vars.h                |   3 +
>  arch/arm64/kvm/arm.c                          |  10 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  34 +++
>  arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S            |   1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  11 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 213 ++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/setup.c               |   5 +
>  arch/arm64/kvm/hyp/nvhe/switch.c              |   7 +-
>  arch/arm64/kvm/hyp/nvhe/tlb.c                 |   4 +-
>  12 files changed, 286 insertions(+), 7 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/mem_protect.c

[...]

> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> new file mode 100644
> index 000000000000..d293cb328cc4
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2020 Google LLC
> + * Author: Quentin Perret <qperret@google.com>
> + */
> +
> +#ifndef __KVM_NVHE_MEM_PROTECT__
> +#define __KVM_NVHE_MEM_PROTECT__
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_hyp.h>
> +#include <asm/kvm_pgtable.h>
> +#include <asm/virt.h>
> +#include <nvhe/spinlock.h>
> +
> +struct host_kvm {
> +	struct kvm_arch arch;
> +	struct kvm_pgtable pgt;
> +	struct kvm_pgtable_mm_ops mm_ops;
> +	hyp_spinlock_t lock;
> +};
> +extern struct host_kvm host_kvm;
> +
> +int __pkvm_prot_finalize(void);
> +int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool);
> +void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
> +
> +static __always_inline void __load_host_stage2(void)
> +{
> +	if (static_branch_likely(&kvm_protected_mode_initialized))
> +		__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);
> +	else
> +		write_sysreg(0, vttbr_el2);

I realise you've just moved the code, but why is this needed? All we've
done is point the stage-2 ttb at 0x0 (i.e. we haven't disabled anything).

> +#endif /* __KVM_NVHE_MEM_PROTECT__ */
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index e204ea77ab27..ce49795324a7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -14,7 +14,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
>  
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
>  	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
> -	 cache.o cpufeature.o setup.o mm.o
> +	 cache.o cpufeature.o setup.o mm.o mem_protect.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
>  obj-y += $(lib-objs)
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index f312672d895e..6fa01b04954f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -119,6 +119,7 @@ alternative_else_nop_endif
>  
>  	/* Invalidate the stale TLBs from Bootloader */
>  	tlbi	alle2
> +	tlbi	vmalls12e1
>  	dsb	sy
>  
>  	/*
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index ae6503c9be15..f47028d3fd0a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -13,6 +13,7 @@
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
>  
> +#include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
>  #include <nvhe/trap_handler.h>
>  
> @@ -151,6 +152,10 @@ static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ct
>  	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
>  }
>  
> +static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
> +{
> +	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
> +}
>  typedef void (*hcall_t)(struct kvm_cpu_context *);
>  
>  #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
> @@ -174,6 +179,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__pkvm_cpu_set_vector),
>  	HANDLE_FUNC(__pkvm_create_mappings),
>  	HANDLE_FUNC(__pkvm_create_private_mapping),
> +	HANDLE_FUNC(__pkvm_prot_finalize),
>  };
>  
>  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> @@ -226,6 +232,11 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
>  	case ESR_ELx_EC_SMC64:
>  		handle_host_smc(host_ctxt);
>  		break;
> +	case ESR_ELx_EC_IABT_LOW:
> +		fallthrough;
> +	case ESR_ELx_EC_DABT_LOW:
> +		handle_host_mem_abort(host_ctxt);
> +		break;
>  	default:
>  		hyp_panic();
>  	}
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> new file mode 100644
> index 000000000000..2252ad1a8945
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -0,0 +1,213 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 Google LLC
> + * Author: Quentin Perret <qperret@google.com>
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_cpufeature.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_hyp.h>
> +#include <asm/kvm_mmu.h>
> +#include <asm/kvm_pgtable.h>
> +#include <asm/stage2_pgtable.h>
> +
> +#include <hyp/switch.h>
> +
> +#include <nvhe/gfp.h>
> +#include <nvhe/memory.h>
> +#include <nvhe/mem_protect.h>
> +#include <nvhe/mm.h>
> +
> +extern unsigned long hyp_nr_cpus;
> +struct host_kvm host_kvm;
> +
> +struct hyp_pool host_s2_mem;
> +struct hyp_pool host_s2_dev;
> +
> +static void *host_s2_zalloc_pages_exact(size_t size)
> +{
> +	return hyp_alloc_pages(&host_s2_mem, get_order(size));
> +}
> +
> +static void *host_s2_zalloc_page(void *pool)
> +{
> +	return hyp_alloc_pages(pool, 0);
> +}
> +
> +static int prepare_s2_pools(void *mem_pgt_pool, void *dev_pgt_pool)
> +{
> +	unsigned long nr_pages, pfn;
> +	int ret;
> +
> +	pfn = hyp_virt_to_pfn(mem_pgt_pool);
> +	nr_pages = host_s2_mem_pgtable_pages();
> +	ret = hyp_pool_init(&host_s2_mem, pfn, nr_pages, 0);
> +	if (ret)
> +		return ret;
> +
> +	pfn = hyp_virt_to_pfn(dev_pgt_pool);
> +	nr_pages = host_s2_dev_pgtable_pages();
> +	ret = hyp_pool_init(&host_s2_dev, pfn, nr_pages, 0);
> +	if (ret)
> +		return ret;
> +
> +	host_kvm.mm_ops.zalloc_pages_exact = host_s2_zalloc_pages_exact;
> +	host_kvm.mm_ops.zalloc_page = host_s2_zalloc_page;
> +	host_kvm.mm_ops.phys_to_virt = hyp_phys_to_virt;
> +	host_kvm.mm_ops.virt_to_phys = hyp_virt_to_phys;
> +	host_kvm.mm_ops.page_count = hyp_page_count;
> +	host_kvm.mm_ops.get_page = hyp_get_page;
> +	host_kvm.mm_ops.put_page = hyp_put_page;

Same comment I had earlier on about struct initialisation -- I think you
can use the same trict here for the host_kvm.mm_ops.

> +
> +	return 0;
> +}
> +
> +static void prepare_host_vtcr(void)
> +{
> +	u32 parange, phys_shift;
> +	u64 mmfr0, mmfr1;
> +
> +	mmfr0 = arm64_ftr_reg_id_aa64mmfr0_el1.sys_val;
> +	mmfr1 = arm64_ftr_reg_id_aa64mmfr1_el1.sys_val;
> +
> +	/* The host stage 2 is id-mapped, so use parange for T0SZ */
> +	parange = kvm_get_parange(mmfr0);
> +	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
> +
> +	host_kvm.arch.vtcr = kvm_get_vtcr(mmfr0, mmfr1, phys_shift);
> +}
> +
> +int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
> +{
> +	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
> +	int ret;
> +
> +	prepare_host_vtcr();
> +	hyp_spin_lock_init(&host_kvm.lock);
> +
> +	ret = prepare_s2_pools(mem_pgt_pool, dev_pgt_pool);
> +	if (ret)
> +		return ret;
> +
> +	ret = kvm_pgtable_stage2_init(&host_kvm.pgt, &host_kvm.arch,
> +				      &host_kvm.mm_ops);
> +	if (ret)
> +		return ret;
> +
> +	mmu->pgd_phys = __hyp_pa(host_kvm.pgt.pgd);
> +	mmu->arch = &host_kvm.arch;
> +	mmu->pgt = &host_kvm.pgt;
> +	mmu->vmid.vmid_gen = 0;
> +	mmu->vmid.vmid = 0;
> +
> +	return 0;
> +}
> +
> +int __pkvm_prot_finalize(void)
> +{
> +	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
> +	struct kvm_nvhe_init_params *params = this_cpu_ptr(&kvm_init_params);
> +
> +	params->vttbr = kvm_get_vttbr(mmu);
> +	params->vtcr = host_kvm.arch.vtcr;
> +	params->hcr_el2 |= HCR_VM;
> +	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
> +		params->hcr_el2 |= HCR_FWB;
> +	kvm_flush_dcache_to_poc(params, sizeof(*params));
> +
> +	write_sysreg(params->hcr_el2, hcr_el2);
> +	__load_stage2(&host_kvm.arch.mmu, host_kvm.arch.vtcr);

AFAICT, there's no ISB here. Do we need one before the TLB invalidation?

> +	__tlbi(vmalls12e1is);
> +	dsb(ish);

Given that the TLB is invalidated on the boot path, please can you add
a comment here about the stale entries which you need to invalidate?

Also, does this need to be inner-shareable? I thought this function ran on
each CPU.

> +	isb();
> +
> +	return 0;
> +}
> +
> +static void host_stage2_unmap_dev_all(void)
> +{
> +	struct kvm_pgtable *pgt = &host_kvm.pgt;
> +	struct memblock_region *reg;
> +	u64 addr = 0;
> +	int i;
> +
> +	/* Unmap all non-memory regions to recycle the pages */
> +	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
> +		reg = &hyp_memory[i];
> +		kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
> +	}
> +	kvm_pgtable_stage2_unmap(pgt, addr, ULONG_MAX);

Is this just going to return -ERANGE?

> +static int host_stage2_idmap(u64 addr)
> +{
> +	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
> +	struct kvm_mem_range range;
> +	bool is_memory = find_mem_range(addr, &range);
> +	struct hyp_pool *pool = is_memory ? &host_s2_mem : &host_s2_dev;
> +	int ret;
> +
> +	if (is_memory)
> +		prot |= KVM_PGTABLE_PROT_X;
> +
> +	hyp_spin_lock(&host_kvm.lock);
> +	ret = kvm_pgtable_stage2_idmap_greedy(&host_kvm.pgt, addr, prot,
> +					      &range, pool);
> +	if (is_memory || ret != -ENOMEM)
> +		goto unlock;
> +	host_stage2_unmap_dev_all();
> +	ret = kvm_pgtable_stage2_idmap_greedy(&host_kvm.pgt, addr, prot,
> +					      &range, pool);

I find this _really_ hard to reason about, as range is passed by reference
and we don't reset it after the first call returns -ENOMEM for an MMIO
mapping. Maybe some commentary on why it's still valid here?

Other than that, this is looking really good to me.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
