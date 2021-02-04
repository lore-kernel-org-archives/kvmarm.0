Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA0A3C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 10:47:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 287CA64D92
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 10:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 287CA64D92
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B16A4B331;
	Thu,  4 Feb 2021 05:47:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lGzjN1v9Kbhq; Thu,  4 Feb 2021 05:47:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FB824B274;
	Thu,  4 Feb 2021 05:47:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 556B84B265
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 05:47:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lRKT++IYvbS2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 05:47:13 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 679714B274
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 05:47:13 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id c127so2559500wmf.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Feb 2021 02:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=NOCj8LvAZfA2IhLGtDyD8aqwcZfCSlKmfqSK6jzKVM8=;
 b=E+ehj9Ixa8BQtYRKSJn2Q+ZzYd8u4hrkEVsvNCGWHcxQ4vHno2guL9w/7catAVN6cY
 XUvFzCU3ZUt88AluDIa583iVDXxvN5iiv44ugr5TkYhzn73wVh4+68fOX/b3jPzPSUOT
 4l6UWT2lMWMbaSZ2eJfvIOjSr5RFUNMZDk4hqty7q0fI4hRMlVHoCpcCTdZFZvUS1XaK
 seHWrkJuN5CCSuQgHoquUl7xLgX1lF/HcNEhItpf6QX1BmqWaxszKHnMZ3iK6AN+ttIO
 2FWu7AT0i9JPlWLabPy7/09QUfVdlGTsyWrDfC26rWvAKnuB9TbwpG2L69PBKFKFDknZ
 J7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=NOCj8LvAZfA2IhLGtDyD8aqwcZfCSlKmfqSK6jzKVM8=;
 b=Ij3HfdBh9KKVNLwAyMXY31Xplf47tYvzF8guAkhSSWJJlPHVsmEmN5dqxkYB8WBrwX
 X1zYpH7xGPVW+7n9Q8aNE+QTJysiiSiakj4UY836stH8y0iTv2fCZbUa7USejVwVaS58
 L5x36sATmjIJ1PMyJjvJPJ9H8HQG2h/cmjfsgTMovg8F+TB7KwXF+IhdUVGN2v54v5nE
 E9fe8r6YvBy/dcj0apUmxX+2QKlhvVNvzXsy0wMGqq6WoemKaCm6CYCPfKFrjaM7gfWc
 2lZp8naKxTKblDEWiAjkca5MP5fXiA7i+1xuJR0D5RADSGh5SittQwRo0s/6lS8LGT5o
 Rwug==
X-Gm-Message-State: AOAM530VeqcuPvsqYMyPfInCcH84IPLb7z3znl0km6ar7hHJ82Yb8BdB
 PhGt4Ef8zL3YXs2iEHroxbKjeg==
X-Google-Smtp-Source: ABdhPJysS1IWOzz0LoC3mlXmYAQ2kma25oyguPhQd/kJOf334eVPIi5qENPQk/5bXfxF7SkcC5/NgQ==
X-Received: by 2002:a1c:6a16:: with SMTP id f22mr6802271wmc.176.1612435631983; 
 Thu, 04 Feb 2021 02:47:11 -0800 (PST)
Received: from google.com (230.69.233.35.bc.googleusercontent.com.
 [35.233.69.230])
 by smtp.gmail.com with ESMTPSA id r15sm7722035wrj.61.2021.02.04.02.47.11
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 04 Feb 2021 02:47:11 -0800 (PST)
Date: Thu, 4 Feb 2021 10:47:08 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH v2 16/26] KVM: arm64: Prepare Hyp memory protection
Message-ID: <YBvQrHdbiNTSLQq6@google.com>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-17-qperret@google.com>
 <20210203143709.GA18907@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210203143709.GA18907@willie-the-truck>
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Wednesday 03 Feb 2021 at 14:37:10 (+0000), Will Deacon wrote:
> On Fri, Jan 08, 2021 at 12:15:14PM +0000, Quentin Perret wrote:
> > +static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
> > +{
> > +	unsigned long total = 0, i;
> > +
> > +	/* Provision the worst case scenario with 4 levels of page-table */
> > +	for (i = 0; i < 4; i++) {
> 
> Looks like you want KVM_PGTABLE_MAX_LEVELS, so maybe move that into a
> header?

Will do.

> 
> > +		nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
> > +		total += nr_pages;
> > +	}
> 
> ... that said, I'm not sure this needs to iterate at all. What exactly are
> you trying to compute?

I'm trying to figure out how many pages I will need to construct a
page-table covering nr_pages contiguous pages. The first iteration tells
me how many level 0 pages I need to cover nr_pages, the second iteration
how many level 1 pages I need to cover the level 0 pages, and so on...

I might be doing this naively though. Got a better idea?

> > +
> > +	return total;
> > +}
> > +
> > +static inline unsigned long hyp_s1_pgtable_size(void)
> > +{
> > +	struct hyp_memblock_region *reg;
> > +	unsigned long nr_pages, res = 0;
> > +	int i;
> > +
> > +	if (kvm_nvhe_sym(hyp_memblock_nr) <= 0)
> > +		return 0;
> 
> It's a bit grotty having this be signed. Why do we need to encode the error
> case differently from the 0 case?

Here specifically we don't, but it is needed in early_init_dt_add_memory_hyp()
to distinguish the overflow case from the first memblock being added.

> 
> > +
> > +	for (i = 0; i < kvm_nvhe_sym(hyp_memblock_nr); i++) {
> > +		reg = &kvm_nvhe_sym(hyp_memory)[i];
> 
> You could declare reg in the loop body.

I found it prettier like that and assumed the compiler would optimize it
anyway, but ok.

> > +		nr_pages = (reg->end - reg->start) >> PAGE_SHIFT;
> > +		nr_pages = __hyp_pgtable_max_pages(nr_pages);
> 
> Maybe it would make more sense for __hyp_pgtable_max_pages to take the
> size in bytes rather than pages, since most callers seem to have to do the
> conversion?

Yes, and it seems I can apply small cleanups in other places, so I'll
fix this throughout the patch.

> > +		res += nr_pages << PAGE_SHIFT;
> > +	}
> > +
> > +	/* Allow 1 GiB for private mappings */
> > +	nr_pages = (1 << 30) >> PAGE_SHIFT;
> 
> SZ_1G >> PAGE_SHIFT

Much nicer, thanks. I was also considering adding a Kconfig option for
that, because 1GiB is totally arbitrary. Toughts?

> > +	nr_pages = __hyp_pgtable_max_pages(nr_pages);
> > +	res += nr_pages << PAGE_SHIFT;
> > +
> > +	return res;
> 
> Might make more sense to keep res in pages until here, then just shift when
> returning.
> 
> > +}
> > +
> > +#endif /* __KVM_HYP_MM_H */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> > index 72cfe53f106f..d7381a503182 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> > +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> > @@ -11,9 +11,9 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
> >  
> >  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> >  	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o \
> > -	 cache.o cpufeature.o
> > +	 cache.o cpufeature.o setup.o mm.o
> >  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
> > -	 ../fpsimd.o ../hyp-entry.o ../exception.o
> > +	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
> >  obj-y += $(lib-objs)
> >  
> >  ##
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index 31b060a44045..ad943966c39f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > @@ -251,4 +251,35 @@ alternative_else_nop_endif
> >  
> >  SYM_CODE_END(__kvm_handle_stub_hvc)
> >  
> > +SYM_FUNC_START(__pkvm_init_switch_pgd)
> > +	/* Turn the MMU off */
> > +	pre_disable_mmu_workaround
> > +	mrs	x2, sctlr_el2
> > +	bic	x3, x2, #SCTLR_ELx_M
> > +	msr	sctlr_el2, x3
> > +	isb
> > +
> > +	tlbi	alle2
> > +
> > +	/* Install the new pgtables */
> > +	ldr	x3, [x0, #NVHE_INIT_PGD_PA]
> > +	phys_to_ttbr x4, x3
> > +alternative_if ARM64_HAS_CNP
> > +	orr	x4, x4, #TTBR_CNP_BIT
> > +alternative_else_nop_endif
> > +	msr	ttbr0_el2, x4
> > +
> > +	/* Set the new stack pointer */
> > +	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]
> > +	mov	sp, x0
> > +
> > +	/* And turn the MMU back on! */
> > +	dsb	nsh
> > +	isb
> > +	msr	sctlr_el2, x2
> > +	ic	iallu
> > +	isb
> > +	ret	x1
> > +SYM_FUNC_END(__pkvm_init_switch_pgd)
> > +
> >  	.popsection
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index a906f9e2ff34..3075f117651c 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -6,12 +6,14 @@
> >  
> >  #include <hyp/switch.h>
> >  
> > +#include <asm/pgtable-types.h>
> >  #include <asm/kvm_asm.h>
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_host.h>
> >  #include <asm/kvm_hyp.h>
> >  #include <asm/kvm_mmu.h>
> >  
> > +#include <nvhe/mm.h>
> >  #include <nvhe/trap_handler.h>
> >  
> >  DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> > @@ -106,6 +108,42 @@ static void handle___vgic_v3_restore_aprs(struct kvm_cpu_context *host_ctxt)
> >  	__vgic_v3_restore_aprs(kern_hyp_va(cpu_if));
> >  }
> >  
> > +static void handle___pkvm_init(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
> > +	DECLARE_REG(unsigned long, size, host_ctxt, 2);
> > +	DECLARE_REG(unsigned long, nr_cpus, host_ctxt, 3);
> > +	DECLARE_REG(unsigned long *, per_cpu_base, host_ctxt, 4);
> > +
> > +	cpu_reg(host_ctxt, 1) = __pkvm_init(phys, size, nr_cpus, per_cpu_base);
> 
> __pkvm_init() doesn't return, so I think this assignment back into host_ctxt
> is confusing.

Very good point, I'll get rid of this.

> 
> Also, I wonder if these bare numbers would be better hidden behind, e.g.
> 
>  #define DECLARE_ARG0(...)	DECLARE_REG(__VA_ARGS__, 1)
>  ...
>  #define DECLARE_RET(...)	DECLARE_REG(__VA_ARGS__, 1)
> 
> but it's cosmetic, so no need to change your patch. Just worried about
> off-by-1s causing interesting behaviour!

Works for me, but I'll leave this with Marc.

> > +
> > +static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	DECLARE_REG(enum arm64_hyp_spectre_vector, slot, host_ctxt, 1);
> > +
> > +	cpu_reg(host_ctxt, 1) = pkvm_cpu_set_vector(slot);
> > +}
> > +
> > +static void handle___pkvm_create_mappings(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	DECLARE_REG(unsigned long, start, host_ctxt, 1);
> > +	DECLARE_REG(unsigned long, size, host_ctxt, 2);
> > +	DECLARE_REG(unsigned long, phys, host_ctxt, 3);
> > +	DECLARE_REG(unsigned long, prot, host_ctxt, 4);
> > +
> > +	cpu_reg(host_ctxt, 1) = __pkvm_create_mappings(start, size, phys, prot);
> > +}
> > +
> > +static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
> > +{
> > +	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
> > +	DECLARE_REG(size_t, size, host_ctxt, 2);
> 
> Why the size_t vs unsigned long discrepancy with pkvm_create_mappings?
> Same with phys_addr_t, although that one probably doesn't matter.
> 
> Also, the pgtable API uses an enum type for the prot bits.

Yes this needs cleaning up.

> > +	DECLARE_REG(unsigned long, prot, host_ctxt, 3);
> > +
> > +	cpu_reg(host_ctxt, 1) = __pkvm_create_private_mapping(phys, size, prot);
> > +}
> > +
> >  typedef void (*hcall_t)(struct kvm_cpu_context *);
> >  
> >  #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = kimg_fn_ptr(handle_##x)
> > @@ -125,6 +163,10 @@ static const hcall_t *host_hcall[] = {
> >  	HANDLE_FUNC(__kvm_get_mdcr_el2),
> >  	HANDLE_FUNC(__vgic_v3_save_aprs),
> >  	HANDLE_FUNC(__vgic_v3_restore_aprs),
> > +	HANDLE_FUNC(__pkvm_init),
> > +	HANDLE_FUNC(__pkvm_cpu_set_vector),
> > +	HANDLE_FUNC(__pkvm_create_mappings),
> > +	HANDLE_FUNC(__pkvm_create_private_mapping),
> >  };
> >  
> >  static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > new file mode 100644
> > index 000000000000..f3481646a94e
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> > @@ -0,0 +1,174 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (C) 2020 Google LLC
> > + * Author: Quentin Perret <qperret@google.com>
> > + */
> > +
> > +#include <linux/kvm_host.h>
> > +#include <asm/kvm_hyp.h>
> > +#include <asm/kvm_mmu.h>
> > +#include <asm/kvm_pgtable.h>
> > +#include <asm/spectre.h>
> > +
> > +#include <nvhe/early_alloc.h>
> > +#include <nvhe/gfp.h>
> > +#include <nvhe/memory.h>
> > +#include <nvhe/mm.h>
> > +#include <nvhe/spinlock.h>
> > +
> > +struct kvm_pgtable pkvm_pgtable;
> > +hyp_spinlock_t pkvm_pgd_lock;
> > +u64 __io_map_base;
> > +
> > +struct hyp_memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
> > +int hyp_memblock_nr;
> > +
> > +int __pkvm_create_mappings(unsigned long start, unsigned long size,
> > +			  unsigned long phys, unsigned long prot)
> > +{
> > +	int err;
> > +
> > +	hyp_spin_lock(&pkvm_pgd_lock);
> > +	err = kvm_pgtable_hyp_map(&pkvm_pgtable, start, size, phys, prot);
> > +	hyp_spin_unlock(&pkvm_pgd_lock);
> > +
> > +	return err;
> > +}
> > +
> > +unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
> > +					   unsigned long prot)
> > +{
> > +	unsigned long addr;
> > +	int ret;
> > +
> > +	hyp_spin_lock(&pkvm_pgd_lock);
> > +
> > +	size = PAGE_ALIGN(size + offset_in_page(phys));
> 
> It might just be simpler to require page-aligned size and phys in the
> caller. At least, for the vectors that should be straightforward because
> I think they're guaranteed not to span a page boundary.

That is done this way for consistency with the host's equivalent
(__create_hyp_private_mapping()), but I can probably factorize the
size-alignment stuff for both.

> > +	addr = __io_map_base;
> > +	__io_map_base += size;
> > +
> > +	/* Are we overflowing on the vmemmap ? */
> > +	if (__io_map_base > __hyp_vmemmap) {
> > +		__io_map_base -= size;
> > +		addr = 0;
> 
> Can we use ERR_PTR(), or does that fail miserably at EL2?

Good question, I'll give it a go.

> > +		goto out;
> > +	}
> > +
> > +	ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, size, phys, prot);
> > +	if (ret) {
> > +		addr = 0;
> > +		goto out;
> > +	}
> > +
> > +	addr = addr + offset_in_page(phys);
> > +out:
> > +	hyp_spin_unlock(&pkvm_pgd_lock);
> > +
> > +	return addr;
> > +}
> 
> [...]
> 
> > +static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
> > +				 unsigned long *per_cpu_base)
> > +{
> > +	void *start, *end, *virt = hyp_phys_to_virt(phys);
> > +	int ret, i;
> > +
> > +	/* Recreate the hyp page-table using the early page allocator */
> > +	hyp_early_alloc_init(hyp_pgt_base, hyp_s1_pgtable_size());
> > +	ret = kvm_pgtable_hyp_init(&pkvm_pgtable, hyp_va_bits,
> > +				   &hyp_early_alloc_mm_ops);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = hyp_create_idmap();
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = hyp_map_vectors();
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = hyp_back_vmemmap(phys, size, hyp_virt_to_phys(vmemmap_base));
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = pkvm_create_mappings(hyp_symbol_addr(__hyp_text_start),
> > +				  hyp_symbol_addr(__hyp_text_end),
> > +				  PAGE_HYP_EXEC);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = pkvm_create_mappings(hyp_symbol_addr(__start_rodata),
> > +				   hyp_symbol_addr(__end_rodata), PAGE_HYP_RO);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = pkvm_create_mappings(hyp_symbol_addr(__hyp_data_ro_after_init_start),
> > +				   hyp_symbol_addr(__hyp_data_ro_after_init_end),
> > +				   PAGE_HYP_RO);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = pkvm_create_mappings(hyp_symbol_addr(__bss_start),
> 
> __hyp_bss_start
>
> > +				   hyp_symbol_addr(__hyp_bss_end), PAGE_HYP);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = pkvm_create_mappings(hyp_symbol_addr(__hyp_bss_end),
> > +				   hyp_symbol_addr(__bss_stop), PAGE_HYP_RO);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = pkvm_create_mappings(virt, virt + size - 1, PAGE_HYP);
> 
> Why is the range inclusive here?

It shouldn't be really, I'll fix it.

> > +	if (ret)
> > +		return ret;
> > +
> > +	for (i = 0; i < hyp_nr_cpus; i++) {
> > +		start = (void *)kern_hyp_va(per_cpu_base[i]);
> > +		end = start + PAGE_ALIGN(hyp_percpu_size);
> > +		ret = pkvm_create_mappings(start, end, PAGE_HYP);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void update_nvhe_init_params(void)
> > +{
> > +	struct kvm_nvhe_init_params *params;
> > +	unsigned long i, stack;
> > +
> > +	for (i = 0; i < hyp_nr_cpus; i++) {
> > +		stack = (unsigned long)stacks_base + (i << PAGE_SHIFT);
> > +		params = per_cpu_ptr(&kvm_init_params, i);
> > +		params->stack_hyp_va = stack + PAGE_SIZE;
> > +		params->pgd_pa = __hyp_pa(pkvm_pgtable.pgd);
> > +		__flush_dcache_area(params, sizeof(*params));
> > +	}
> > +}
> > +
> > +static void *hyp_zalloc_hyp_page(void *arg)
> > +{
> > +	return hyp_alloc_pages(&hpool, HYP_GFP_ZERO, 0);
> > +}
> > +
> > +void __noreturn __pkvm_init_finalise(void)
> > +{
> > +	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
> > +	struct kvm_cpu_context *host_ctxt = &host_data->host_ctxt;
> > +	unsigned long nr_pages, used_pages;
> > +	int ret;
> > +
> > +	/* Now that the vmemmap is backed, install the full-fledged allocator */
> > +	nr_pages = hyp_s1_pgtable_size() >> PAGE_SHIFT;
> > +	used_pages = hyp_early_alloc_nr_pages();
> > +	ret = hyp_pool_init(&hpool, __hyp_pa(hyp_pgt_base), nr_pages, used_pages);
> > +	if (ret)
> > +		goto out;
> > +
> > +	pkvm_pgtable_mm_ops.zalloc_page = hyp_zalloc_hyp_page;
> > +	pkvm_pgtable_mm_ops.phys_to_virt = hyp_phys_to_virt;
> > +	pkvm_pgtable_mm_ops.virt_to_phys = hyp_virt_to_phys;
> > +	pkvm_pgtable_mm_ops.get_page = hyp_get_page;
> > +	pkvm_pgtable_mm_ops.put_page = hyp_put_page;
> > +	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
> > +
> > +out:
> > +	host_ctxt->regs.regs[0] = SMCCC_RET_SUCCESS;
> > +	host_ctxt->regs.regs[1] = ret;
> 
> Use the cpu_reg() helper for these?

+1

> > +
> > +	__host_enter(host_ctxt);
> > +}
> > +
> > +int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpus,
> > +		unsigned long *per_cpu_base)
> > +{
> > +	struct kvm_nvhe_init_params *params;
> > +	void *virt = hyp_phys_to_virt(phys);
> > +	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
> > +	int ret;
> > +
> > +	if (phys % PAGE_SIZE || size % PAGE_SIZE || (u64)virt % PAGE_SIZE)
> > +		return -EINVAL;
> > +
> > +	hyp_spin_lock_init(&pkvm_pgd_lock);
> > +	hyp_nr_cpus = nr_cpus;
> > +
> > +	ret = divide_memory_pool(virt, size);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = recreate_hyp_mappings(phys, size, per_cpu_base);
> > +	if (ret)
> > +		return ret;
> > +
> > +	update_nvhe_init_params();
> > +
> > +	/* Jump in the idmap page to switch to the new page-tables */
> > +	params = this_cpu_ptr(&kvm_init_params);
> > +	fn = (typeof(fn))__hyp_pa(hyp_symbol_addr(__pkvm_init_switch_pgd));
> > +	fn(__hyp_pa(params), hyp_symbol_addr(__pkvm_init_finalise));
> > +
> > +	unreachable();
> > +}
> > diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
> > new file mode 100644
> > index 000000000000..32f648992835
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/reserved_mem.c
> > @@ -0,0 +1,102 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2020 - Google LLC
> > + * Author: Quentin Perret <qperret@google.com>
> > + */
> > +
> > +#include <linux/kvm_host.h>
> > +#include <linux/memblock.h>
> > +#include <linux/sort.h>
> > +
> > +#include <asm/kvm_host.h>
> > +
> > +#include <nvhe/memory.h>
> > +#include <nvhe/mm.h>
> > +
> > +phys_addr_t hyp_mem_base;
> > +phys_addr_t hyp_mem_size;
> > +
> > +int __init early_init_dt_add_memory_hyp(u64 base, u64 size)
> > +{
> > +	struct hyp_memblock_region *reg;
> > +
> > +	if (kvm_nvhe_sym(hyp_memblock_nr) >= HYP_MEMBLOCK_REGIONS)
> > +		kvm_nvhe_sym(hyp_memblock_nr) = -1;
> > +
> > +	if (kvm_nvhe_sym(hyp_memblock_nr) < 0)
> > +		return -ENOMEM;
> > +
> > +	reg = kvm_nvhe_sym(hyp_memory);
> > +	reg[kvm_nvhe_sym(hyp_memblock_nr)].start = base;
> > +	reg[kvm_nvhe_sym(hyp_memblock_nr)].end = base + size;
> > +	kvm_nvhe_sym(hyp_memblock_nr)++;
> > +
> > +	return 0;
> > +}
> 
> This isn't called by anything in this patch afaict, so it's a bit tricky to
> review, especially as I was trying to see how it interacts with
> kvm_hyp_reserve(), which reads hyp_memblock_nr.

It's not obvious by the look of it, but this _is_ called -- see the
previous patch. But note that given the outcome of the discussion
with Rob, this is changing in v3 as I'll be using the memblock API
instead.

> > +
> > +static int cmp_hyp_memblock(const void *p1, const void *p2)
> > +{
> > +	const struct hyp_memblock_region *r1 = p1;
> > +	const struct hyp_memblock_region *r2 = p2;
> > +
> > +	return r1->start < r2->start ? -1 : (r1->start > r2->start);
> > +}
> > +
> > +static void __init sort_memblock_regions(void)
> > +{
> > +	sort(kvm_nvhe_sym(hyp_memory),
> > +	     kvm_nvhe_sym(hyp_memblock_nr),
> > +	     sizeof(struct hyp_memblock_region),
> > +	     cmp_hyp_memblock,
> > +	     NULL);
> > +}
> > +
> > +void __init kvm_hyp_reserve(void)
> > +{
> > +	u64 nr_pages, prev;
> > +
> > +	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
> > +		return;
> > +
> > +	if (kvm_get_mode() != KVM_MODE_PROTECTED)
> > +		return;
> > +
> > +	if (kvm_nvhe_sym(hyp_memblock_nr) < 0) {
> > +		kvm_err("Failed to register hyp memblocks\n");
> > +		return;
> > +	}
> > +
> > +	sort_memblock_regions();
> > +
> > +	/*
> > +	 * We don't know the number of possible CPUs yet, so allocate for the
> > +	 * worst case.
> > +	 */
> > +	hyp_mem_size += NR_CPUS << PAGE_SHIFT;
> 
> There was a recent patch bumping NR_CPUs to 512, so this would be 32MB
> with 64k pages. Is it possible to return memory to the host later on once
> we have a better handle on the number of CPUs in the system?

That's not possible yet, no :/

> 
> > +	hyp_mem_size += hyp_s1_pgtable_size();
> > +
> > +	/*
> > +	 * The hyp_vmemmap needs to be backed by pages, but these pages
> > +	 * themselves need to be present in the vmemmap, so compute the number
> > +	 * of pages needed by looking for a fixed point.
> > +	 */
> > +	nr_pages = 0;
> > +	do {
> > +		prev = nr_pages;
> > +		nr_pages = (hyp_mem_size >> PAGE_SHIFT) + prev;
> > +		nr_pages = DIV_ROUND_UP(nr_pages * sizeof(struct hyp_page), PAGE_SIZE);
> > +		nr_pages += __hyp_pgtable_max_pages(nr_pages);
> > +	} while (nr_pages != prev);
> > +	hyp_mem_size += nr_pages << PAGE_SHIFT;
> > +
> > +	hyp_mem_base = memblock_find_in_range(0, memblock_end_of_DRAM(),
> > +					      hyp_mem_size, SZ_2M);
> 
> Why SZ_2M? Guessing you might mean PMD_SIZE,

Indeed.

> although then we will probably
> want to retry with smaller alignment if the allocation fails as this can
> again be large with e.g. 64k pages.

That can't hurt I guess.

> > +	if (!hyp_mem_base) {
> > +		kvm_err("Failed to reserve hyp memory\n");
> > +		return;
> > +	}
> > +	memblock_reserve(hyp_mem_base, hyp_mem_size);
> > +
> > +	kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
> > +		 hyp_mem_base);
> > +}
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 278e163beda4..3cf9397dabdb 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1264,10 +1264,10 @@ static struct kvm_pgtable_mm_ops kvm_hyp_mm_ops = {
> >  	.virt_to_phys		= kvm_host_pa,
> >  };
> >  
> > +u32 hyp_va_bits;
> 
> Perhaps it would be better to pass this to __pkvm_init() instead of making
> it global?

Sure, I'll have init_hyp_mode() pass a pointer to kvm_mmu_init() to
propagate it back.

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
