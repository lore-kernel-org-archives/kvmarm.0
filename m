Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4958CC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 12:55:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B96D460F46
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 12:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B96D460F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 438C540839;
	Mon, 26 Jul 2021 08:55:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VVMPDKVrNbXv; Mon, 26 Jul 2021 08:55:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C88B649F83;
	Mon, 26 Jul 2021 08:55:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 32FF740CC5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 08:55:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgxEnVa78Pxh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 08:55:45 -0400 (EDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com
 [209.85.128.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAAA640839
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 08:55:45 -0400 (EDT)
Received: by mail-wm1-f54.google.com with SMTP id m19so1415681wms.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fkUG+iAt+zuCxT26kDkl0WV6E/FteQoKv8U8VM3QTBg=;
 b=j7tPw8qGbY4QpKheFdpqb7ALH2NQGpyAvOIiHaRfa9BpgneUoA/IUIxx6xzGgikntK
 qgWAjkvvnPunpWZVU2u8z1d9bAHBqQbyPrjn7WVR943PaozM6915IM+Xa/+m5Vc3Z0gA
 6x0wQGJ29coOSE7e7xBPCB5w8M7K4S/17hUJLRmqFH1hyIux8p8+Z0s39mqbeJ+ZXr4/
 wt6LIOWFyp/Jpr2bXOVclLqWbolz2QJc1LrXrMhpfIey/NaH+zrVsPR5Ccz4nwkKOk06
 ZIL2OqjkLUkXng13Gz2LxcA3AAS28LkWRQyahR8W1Bt7eMzPRgPJdApG/SfaiGGlmUda
 Kqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fkUG+iAt+zuCxT26kDkl0WV6E/FteQoKv8U8VM3QTBg=;
 b=dcoyWIlYDwsM9Wy7lEzKnzEHMnf0Hw24DLCz+Qq2lp5ii9kjqXgYXQWhJ2286omPXr
 XxGrHvmQmCWJF6dMhL2W3Vh23spxrblZCqkgjrStjdWmqp1+AlyeRRzXtN2urkDWONJD
 7mGemMC2+Dm2arHv34dVEVR/H9SCODRGZJ/TiR4Vev2I/O1a/06SwDAxK0Kryqs9+heO
 +0hbmo/UnxrCLn5+vNx/zCs+H1KZZ9kZg+1qm+0MQTZETTvV181acYIssfPXhANp25dz
 sdDUBDSvAgKIf7yGk36OdBfY4E2jjnd6D5EM2Z8wlFgXxDOTJs2F1XNimIl+QebUbCD3
 u/Zw==
X-Gm-Message-State: AOAM532MjMjavGf2vI8KrAN/rPI+mXVeEqrkUi1UWFuTmAnWsXpuR1ac
 FZ/Rhac8VMqlAueRgacvOjm49w==
X-Google-Smtp-Source: ABdhPJzRjwbFI8w9H/LdYOboSNiGgyVn8q0LaZ4z28ZHHfB43EnAHJUFpDFkZ6+kBJzf0OGfKuzxUA==
X-Received: by 2002:a05:600c:4f48:: with SMTP id
 m8mr9896882wmq.22.1627304144226; 
 Mon, 26 Jul 2021 05:55:44 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:c468:e033:fa2b:3a6])
 by smtp.gmail.com with ESMTPSA id z11sm42186759wru.65.2021.07.26.05.55.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Jul 2021 05:55:43 -0700 (PDT)
Date: Mon, 26 Jul 2021 13:55:41 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 15/16] KVM: arm64: Restrict EL2 stage-1 changes in
 protected mode
Message-ID: <YP6wzW+6q5minnix@google.com>
References: <20210726092905.2198501-1-qperret@google.com>
 <20210726092905.2198501-16-qperret@google.com>
 <87o8ape2nj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87o8ape2nj.wl-maz@kernel.org>
Cc: kernel-team@android.com, qwandor@google.com, will@kernel.org,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Monday 26 Jul 2021 at 12:27:12 (+0100), Marc Zyngier wrote:
> On Mon, 26 Jul 2021 10:29:04 +0100,
> Quentin Perret <qperret@google.com> wrote:
> > 
> > The host kernel is currently able to change EL2 stage-1 mappings without
> > restrictions thanks to the __pkvm_create_mappings() hypercall. But in a
> > world where the host is no longer part of the TCB, this clearly poses a
> > problem.
> > 
> > To fix this, introduce a new hypercall to allow the host to share a
> > physical memory page with the hypervisor, and remove the
> > __pkvm_create_mappings() variant. The new hypercall implements
> > ownership and permission checks before allowing the sharing operation,
> > and it annotates the shared page in the hypervisor stage-1 and host
> > stage-2 page-tables.
> > 
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h              |  2 +-
> >  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 11 +--
> >  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 90 +++++++++++++++++++
> >  arch/arm64/kvm/mmu.c                          | 28 +++++-
> >  5 files changed, 120 insertions(+), 12 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index 9f0bf2109be7..78db818ae2c9 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -59,7 +59,7 @@
> >  #define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
> >  #define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
> >  #define __KVM_HOST_SMCCC_FUNC___pkvm_init			15
> > -#define __KVM_HOST_SMCCC_FUNC___pkvm_create_mappings		16
> > +#define __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp		16
> >  #define __KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping	17
> >  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
> >  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > index 8e5725d032b2..1b8e59a9d065 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> > @@ -49,6 +49,7 @@ extern struct host_kvm host_kvm;
> >  
> >  int __pkvm_prot_finalize(void);
> >  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
> > +int __pkvm_host_share_hyp(u64 pfn);
> >  
> >  int host_stage2_idmap_locked(u64 start, u64 end, enum kvm_pgtable_prot prot);
> >  int kvm_host_prepare_stage2(void *pgt_pool_base);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 1632f001f4ed..dd155646ec86 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -140,14 +140,11 @@ static void handle___pkvm_cpu_set_vector(struct kvm_cpu_context *host_ctxt)
> >  	cpu_reg(host_ctxt, 1) = pkvm_cpu_set_vector(slot);
> >  }
> >  
> > -static void handle___pkvm_create_mappings(struct kvm_cpu_context *host_ctxt)
> > +static void handle___pkvm_host_share_hyp(struct kvm_cpu_context *host_ctxt)
> >  {
> > -	DECLARE_REG(unsigned long, start, host_ctxt, 1);
> > -	DECLARE_REG(unsigned long, size, host_ctxt, 2);
> > -	DECLARE_REG(unsigned long, phys, host_ctxt, 3);
> > -	DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 4);
> > +	DECLARE_REG(u64, pfn, host_ctxt, 1);
> >  
> > -	cpu_reg(host_ctxt, 1) = __pkvm_create_mappings(start, size, phys, prot);
> > +	cpu_reg(host_ctxt, 1) = __pkvm_host_share_hyp(pfn);
> >  }
> >  
> >  static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
> > @@ -193,7 +190,7 @@ static const hcall_t host_hcall[] = {
> >  	HANDLE_FUNC(__vgic_v3_restore_aprs),
> >  	HANDLE_FUNC(__pkvm_init),
> >  	HANDLE_FUNC(__pkvm_cpu_set_vector),
> > -	HANDLE_FUNC(__pkvm_create_mappings),
> > +	HANDLE_FUNC(__pkvm_host_share_hyp),
> >  	HANDLE_FUNC(__pkvm_create_private_mapping),
> >  	HANDLE_FUNC(__pkvm_prot_finalize),
> >  	HANDLE_FUNC(__pkvm_mark_hyp),
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > index 223c541a7051..75273166d2c5 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> > @@ -315,6 +315,96 @@ static int host_stage2_idmap(u64 addr)
> >  	return ret;
> >  }
> >  
> > +static inline bool check_prot(enum kvm_pgtable_prot prot,
> > +			      enum kvm_pgtable_prot required,
> > +			      enum kvm_pgtable_prot denied)
> > +{
> > +	return (prot & (required | denied)) == required;
> > +}
> > +
> > +int __pkvm_host_share_hyp(u64 pfn)
> > +{
> > +	phys_addr_t addr = hyp_pfn_to_phys(pfn);
> > +	enum kvm_pgtable_prot prot, cur;
> > +	void * virt = __hyp_va(addr);
> > +	enum pkvm_page_state state;
> > +	kvm_pte_t pte;
> > +	u32 level;
> > +	int ret;
> > +
> > +	if (!range_is_memory(addr, addr + PAGE_SIZE))
> > +		return -EINVAL;
> > +
> > +	hyp_spin_lock(&host_kvm.lock);
> > +	hyp_spin_lock(&pkvm_pgd_lock);
> > +
> > +	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, &level);
> > +	if (ret)
> > +		goto unlock;
> > +	if (!pte)
> > +		goto map_shared;
> > +
> > +	/*
> > +	 * Check attributes in the host stage-2 PTE. We need the page to be:
> > +	 *  - mapped RWX as we're sharing memory;
> > +	 *  - not borrowed, as that implies absence of ownership.
> > +	 * Otherwise, we can't let it got through
> > +	 */
> > +	cur = kvm_pgtable_stage2_pte_prot(pte);
> > +	prot = pkvm_mkstate(0, PKVM_PAGE_SHARED_BORROWED);
> > +	if (!check_prot(cur, KVM_PGTABLE_PROT_RWX, prot)) {
> > +		ret = -EPERM;
> > +		goto unlock;
> > +	}
> > +
> > +	state = pkvm_getstate(cur);
> > +	if (state == PKVM_PAGE_OWNED)
> > +		goto map_shared;
> > +
> > +	/*
> > +	 * Tolerate double-sharing the same page, but this requires
> > +	 * cross-checking the hypervisor stage-1.
> > +	 */
> > +	if (state != PKVM_PAGE_SHARED_OWNED) {
> > +		ret = -EPERM;
> > +		goto unlock;
> > +	}
> > +
> > +	ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, &level);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	/*
> > +	 * If the page has been shared with the hypervisor, it must be
> > +	 * SHARED_BORROWED already.
> > +	 */
> > +	cur = kvm_pgtable_hyp_pte_prot(pte);
> > +	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
> > +	if (!check_prot(cur, prot, ~prot))
> > +		ret = EPERM;
> > +	goto unlock;
> > +
> > +map_shared:
> > +	/*
> > +	 * If the page is not yet shared, adjust mappings in both page-tables
> > +	 * while both locks are held.
> > +	 */
> > +	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
> > +	ret = pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, prot);
> > +	if (ret)
> > +		goto unlock;
> > +
> > +	prot = pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED);
> > +	ret = host_stage2_idmap_locked(addr, addr + PAGE_SIZE, prot);
> > +	BUG_ON(ret);
> 
> Why the different treatment here? If we couldn't map the page in EL2
> Stage-1, surely that's also a big problem, isn't it?

Right, the reasoning was, if the EL2 stage-1 map failed for any reason,
it will hopefully leave the page-table unmodified, which means there is
a chance we can bail out without a corrupted state. But if it succeeded
and the host stage-2 map didn't, we're in trouble since we can't unmap
anything from the EL2 stage-1 (yet) to clean things up on the error path.

But yes, failing either of them is sign of a major problem, so I can
surely simplify and just BUG() on both. Alternatively, mapping the host
stage-2 first would actually be preferable, since I should be able to
unmap things from there if I need too ...

> > +
> > +unlock:
> > +	hyp_spin_unlock(&pkvm_pgd_lock);
> > +	hyp_spin_unlock(&host_kvm.lock);
> > +
> > +	return ret;
> > +}
> > +
> >  int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
> >  {
> >  	int ret;
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 0625bf2353c2..cbab146cda6a 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -259,10 +259,8 @@ static int __create_hyp_mappings(unsigned long start, unsigned long size,
> >  {
> >  	int err;
> >  
> > -	if (!kvm_host_owns_hyp_mappings()) {
> > -		return kvm_call_hyp_nvhe(__pkvm_create_mappings,
> > -					 start, size, phys, prot);
> > -	}
> > +	if (WARN_ON(!kvm_host_owns_hyp_mappings()))
> > +		return -EINVAL;
> 
> How comes that this doesn't generate a warning on a GICv2 system when
> we try and map the CPU interface via create_hyp_io_mappings()?

Aha, so that's an interesting one. In short, because we have a separate
hypercall in __create_hyp_private_mapping() to handle mapping things in
the 'private' range of the hypervisor, so we should be covered.

But note that we should consider this other hypercall privileged, and we
should allow the host to call it only while the pkvm static key is not
set. Same thing for a bunch of other calls (__pkvm_init and friends),
so this is something we should fix/consolidate at some point in the
future.

I guess it would make sense conceptually to mark those IO pages shared
as well, but given that this share operation must never happen when
we no longer trust the host, and since so far we're under the assumption
that non-memory pages cannot be shared with e.g. guests, I figured there
was no real benefit to it _yet_. And it would make
host_stage2_unmap_dev_all() and friends a bit harder to implement. We
currently assume that pages in the MMIO range cannot be 'pinned' as per
the comment above host_stage2_try().

Thanks,
Quentin

> >  
> >  	mutex_lock(&kvm_hyp_pgd_mutex);
> >  	err = kvm_pgtable_hyp_map(hyp_pgtable, start, size, phys, prot);
> > @@ -282,6 +280,21 @@ static phys_addr_t kvm_kaddr_to_phys(void *kaddr)
> >  	}
> >  }
> >  
> > +static int pkvm_share_hyp(phys_addr_t start, phys_addr_t end)
> > +{
> > +	phys_addr_t addr;
> > +	int ret;
> > +
> > +	for (addr = ALIGN_DOWN(start, PAGE_SIZE); addr < end; addr += PAGE_SIZE) {
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp,
> > +					__phys_to_pfn(addr));
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
> >   * @from:	The virtual kernel start address of the range
> > @@ -302,6 +315,13 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> >  	if (is_kernel_in_hyp_mode())
> >  		return 0;
> >  
> > +	if (!kvm_host_owns_hyp_mappings()) {
> > +		if (WARN_ON(prot != PAGE_HYP))
> > +			return -EPERM;
> > +		return pkvm_share_hyp(kvm_kaddr_to_phys(from),
> > +				      kvm_kaddr_to_phys(to));
> > +	}
> > +
> >  	start = start & PAGE_MASK;
> >  	end = PAGE_ALIGN(end);
> >  
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
