From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [RFC/RFT PATCH v2 3/3] arm/arm64: KVM: implement
 'uncached' mem coherency
Date: Thu, 14 May 2015 15:32:13 +0200
Message-ID: <20150514133213.GD12812@localhost.localdomain>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
 <1431516714-25816-4-git-send-email-drjones@redhat.com>
 <20150514105549.GO32765@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87CEB514E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 09:23:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oCLLX5SvcT6O for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 09:23:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C18CA514C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 09:23:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20150514105549.GO32765@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: ard.biesheuvel@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, qemu-devel@nongnu.org, pbonzini@redhat.com, lersek@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 14, 2015 at 12:55:49PM +0200, Christoffer Dall wrote:
> On Wed, May 13, 2015 at 01:31:54PM +0200, Andrew Jones wrote:
> > When S1 and S2 memory attributes combine wrt to caching policy,
> > non-cacheable types take precedence. If a guest maps a region as
> > device memory, which KVM userspace is using to emulate the device
> > using normal, cacheable memory, then we lose coherency. With
> > KVM_MEM_UNCACHED, KVM userspace can now hint to KVM which memory
> > regions are likely to be problematic. With this patch, as pages
> > of these types of regions are faulted into the guest, not only do
> > we flush the page's dcache, but we also change userspace's
> > mapping to NC in order to maintain coherency.
> > 
> > What if the guest doesn't do what we expect? While we can't
> > force a guest to use cacheable memory, we can take advantage of
> > the non-cacheable precedence, and force it to use non-cacheable.
> > So, this patch also introduces PAGE_S2_NORMAL_NC, and uses it on
> > KVM_MEM_UNCACHED regions to force them to NC.
> > 
> > We now have both guest and userspace on the same page (pun intended)
> 
> I'd like to revisit the overall approach here.  Is doing non-cached
> accesses in both the guest and host really the right thing to do here?

I think so, but all ideas/approaches are still on the table. This is
still an RFC.

> 
> The semantics of the device becomes that it is cache coherent (because
> QEMU is), and I think Marc argued that Linux/UEFI should simply be
> adapted to handle whatever emulated devices we have as coherent.  I also
> remember someone arguing that would be wrong (Peter?).

I'm not really for quirking all devices in all guest types (AAVMF, Linux,
other bootloaders, other OSes). Windows is unlikely to apply any quirks.

> 
> Finally, does this address all cache coherency issues with emulated
> devices?  Some VOS guys had seen things still not working with this
> approach, unsure why...  I'd like to avoid us merging this only to merge
> a more complete solution in a few weeks which reverts this solution...

I'm not sure (this is still an RFT too :-) We definitely would need to
scatter some more memory_region_set_uncached() calls around QEMU first.

> 
> More comments/questions below:
> 
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm/include/asm/kvm_mmu.h        |  5 ++++-
> >  arch/arm/include/asm/pgtable-3level.h |  1 +
> >  arch/arm/include/asm/pgtable.h        |  1 +
> >  arch/arm/kvm/mmu.c                    | 37 +++++++++++++++++++++++------------
> >  arch/arm64/include/asm/kvm_mmu.h      |  5 ++++-
> >  arch/arm64/include/asm/memory.h       |  1 +
> >  arch/arm64/include/asm/pgtable.h      |  1 +
> >  7 files changed, 36 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> > index 405aa18833073..e8034a80b12e5 100644
> > --- a/arch/arm/include/asm/kvm_mmu.h
> > +++ b/arch/arm/include/asm/kvm_mmu.h
> > @@ -214,8 +214,11 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
> >  	while (size) {
> >  		void *va = kmap_atomic_pfn(pfn);
> >  
> > -		if (need_flush)
> > +		if (need_flush) {
> >  			kvm_flush_dcache_to_poc(va, PAGE_SIZE);
> > +			if (ipa_uncached)
> > +				set_memory_nc((unsigned long)va, 1);
> 
> nit: consider moving this outside the need_flush
> 
> > +		}
> >  
> >  		if (icache_is_pipt())
> >  			__cpuc_coherent_user_range((unsigned long)va,
> > diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
> > index a745a2a53853c..39b3f7a40e663 100644
> > --- a/arch/arm/include/asm/pgtable-3level.h
> > +++ b/arch/arm/include/asm/pgtable-3level.h
> > @@ -121,6 +121,7 @@
> >   * 2nd stage PTE definitions for LPAE.
> >   */
> >  #define L_PTE_S2_MT_UNCACHED		(_AT(pteval_t, 0x0) << 2) /* strongly ordered */
> > +#define L_PTE_S2_MT_NORMAL_NC		(_AT(pteval_t, 0x5) << 2) /* normal non-cacheable */
> >  #define L_PTE_S2_MT_WRITETHROUGH	(_AT(pteval_t, 0xa) << 2) /* normal inner write-through */
> >  #define L_PTE_S2_MT_WRITEBACK		(_AT(pteval_t, 0xf) << 2) /* normal inner write-back */
> >  #define L_PTE_S2_MT_DEV_SHARED		(_AT(pteval_t, 0x1) << 2) /* device */
> > diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> > index f40354198bad4..ae13ca8b0a23d 100644
> > --- a/arch/arm/include/asm/pgtable.h
> > +++ b/arch/arm/include/asm/pgtable.h
> > @@ -100,6 +100,7 @@ extern pgprot_t		pgprot_s2_device;
> >  #define PAGE_HYP		_MOD_PROT(pgprot_kernel, L_PTE_HYP)
> >  #define PAGE_HYP_DEVICE		_MOD_PROT(pgprot_hyp_device, L_PTE_HYP)
> >  #define PAGE_S2			_MOD_PROT(pgprot_s2, L_PTE_S2_RDONLY)
> > +#define PAGE_S2_NORMAL_NC	__pgprot((pgprot_val(PAGE_S2) & ~L_PTE_S2_MT_MASK) | L_PTE_S2_MT_NORMAL_NC)
> >  #define PAGE_S2_DEVICE		_MOD_PROT(pgprot_s2_device, L_PTE_S2_RDONLY)
> >  
> >  #define __PAGE_NONE		__pgprot(_L_PTE_DEFAULT | L_PTE_RDONLY | L_PTE_XN | L_PTE_NONE)
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index bc1665acd73e7..6b3bd8061bd2a 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -1220,7 +1220,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	struct vm_area_struct *vma;
> >  	pfn_t pfn;
> >  	pgprot_t mem_type = PAGE_S2;
> > -	bool fault_ipa_uncached;
> > +	bool fault_ipa_uncached = false;
> >  	bool logging_active = memslot_is_logging(memslot);
> >  	unsigned long flags = 0;
> >  
> > @@ -1300,6 +1300,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  			writable = false;
> >  	}
> >  
> > +	if (memslot->flags & KVM_MEM_UNCACHED) {
> > +		mem_type = PAGE_S2_NORMAL_NC;
> > +		fault_ipa_uncached = true;
> > +	}
> > +
> >  	spin_lock(&kvm->mmu_lock);
> >  	if (mmu_notifier_retry(kvm, mmu_seq))
> >  		goto out_unlock;
> > @@ -1307,8 +1312,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	if (!hugetlb && !force_pte)
> >  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
> >  
> > -	fault_ipa_uncached = memslot->flags & KVM_MEM_UNCACHED;
> > -
> >  	if (hugetlb) {
> >  		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
> >  		new_pmd = pmd_mkhuge(new_pmd);
> > @@ -1462,6 +1465,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
> >  			     unsigned long start,
> >  			     unsigned long end,
> >  			     int (*handler)(struct kvm *kvm,
> > +					    struct kvm_memory_slot *slot,
> >  					    gpa_t gpa, void *data),
> >  			     void *data)
> >  {
> > @@ -1491,14 +1495,15 @@ static int handle_hva_to_gpa(struct kvm *kvm,
> >  
> >  		for (; gfn < gfn_end; ++gfn) {
> >  			gpa_t gpa = gfn << PAGE_SHIFT;
> > -			ret |= handler(kvm, gpa, data);
> > +			ret |= handler(kvm, memslot, gpa, data);
> >  		}
> >  	}
> >  
> >  	return ret;
> >  }
> >  
> > -static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
> > +static int kvm_unmap_hva_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +				 gpa_t gpa, void *data)
> 
> Maybe we should consider a pointer to a struct with the relevant data to
> pass around to the handler by now, which would allow us to get rid of
> the void * cast as well.  Not sure if it's worth it.
> 
> >  {
> >  	unmap_stage2_range(kvm, gpa, PAGE_SIZE);
> >  	return 0;
> > @@ -1527,9 +1532,15 @@ int kvm_unmap_hva_range(struct kvm *kvm,
> >  	return 0;
> >  }
> >  
> > -static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
> > +static int kvm_set_spte_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +				gpa_t gpa, void *data)
> >  {
> > -	pte_t *pte = (pte_t *)data;
> > +	pte_t pte = *((pte_t *)data);
> > +
> > +	if (slot->flags & KVM_MEM_UNCACHED)
> > +		pte = pfn_pte(pte_pfn(pte), PAGE_S2_NORMAL_NC);
> > +	else
> > +		pte = pfn_pte(pte_pfn(pte), PAGE_S2);
> >  
> >  	/*
> >  	 * We can always call stage2_set_pte with KVM_S2PTE_FLAG_LOGGING_ACTIVE
> > @@ -1538,7 +1549,7 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
> >  	 * therefore stage2_set_pte() never needs to clear out a huge PMD
> >  	 * through this calling path.
> >  	 */
> > -	stage2_set_pte(kvm, NULL, gpa, pte, 0);
> > +	stage2_set_pte(kvm, NULL, gpa, &pte, 0);
> 
> this is making me feel like we should have a separate patch that changes
> stage2_set_pte from taking a pointer to just taking a value for the new
> pte.
> 
> >  	return 0;
> >  }
> >  
> > @@ -1546,17 +1557,16 @@ static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
> >  void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
> >  {
> >  	unsigned long end = hva + PAGE_SIZE;
> > -	pte_t stage2_pte;
> >  
> >  	if (!kvm->arch.pgd)
> >  		return;
> >  
> >  	trace_kvm_set_spte_hva(hva);
> > -	stage2_pte = pfn_pte(pte_pfn(pte), PAGE_S2);
> > -	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
> > +	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pte);
> 
> hooking in here will make sure you catch changes to the page used for
> the mapping, but wouldn't that also mean that the userspace mapping
> would have been change, and where are you updating this?
> 
> Also, is this called if the userspace mapping is zapped without doing
> anything about the underlying page?  (how do we then catch when the
> userspace pte is populated again, and is this even possible?)

I was hoping that I only needed to worry about getting the S2 attributes
right here, and then, since the page will need to be refaulted into
the guest anyway, that the userspace part would get taken care of at
that point (in user_mem_abort). But, to be honest, I forgot to dig into
this deep enough to know if my hope will work or not.

> 
> >  }
> >  
> > -static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
> > +static int kvm_age_hva_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +			       gpa_t gpa, void *data)
> >  {
> >  	pmd_t *pmd;
> >  	pte_t *pte;
> > @@ -1586,7 +1596,8 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
> >  	return 0;
> >  }
> >  
> > -static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
> > +static int kvm_test_age_hva_handler(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +				    gpa_t gpa, void *data)
> >  {
> >  	pmd_t *pmd;
> >  	pte_t *pte;
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 61505676d0853..af5f0f0eccef9 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -236,8 +236,11 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
> >  {
> >  	void *va = page_address(pfn_to_page(pfn));
> >  
> > -	if (!vcpu_has_cache_enabled(vcpu) || ipa_uncached)
> > +	if (!vcpu_has_cache_enabled(vcpu) || ipa_uncached) {
> >  		kvm_flush_dcache_to_poc(va, size);
> > +		if (ipa_uncached)
> > +			set_memory_nc((unsigned long)va, size/PAGE_SIZE);
> 
> are you not setting the kernel mapping of the page to non-cached here,
> which doesn't affect your userspace mappings at all?

Oh crap. I shouldn't have tried to use change_memory_common... I
completely overlooked the fact I'm now using the wrong mm...

> 
> (this would explain why things still break with this series).

yeah, I wonder why it works so well?

> 
> > +	}
> >  
> >  	if (!icache_is_aliasing()) {		/* PIPT */
> >  		flush_icache_range((unsigned long)va,
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index f800d45ea2265..800730f7aa7d9 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -105,6 +105,7 @@
> >   * Memory types for Stage-2 translation
> >   */
> >  #define MT_S2_NORMAL		0xf
> > +#define MT_S2_NORMAL_NC		0x5
> >  #define MT_S2_DEVICE_nGnRE	0x1
> >  
> >  #ifndef __ASSEMBLY__
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 56283f8a675c5..a254925ce1b6b 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -78,6 +78,7 @@ extern void __pgd_error(const char *file, int line, unsigned long val);
> >  #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
> >  
> >  #define PAGE_S2			__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY)
> > +#define PAGE_S2_NORMAL_NC	__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL_NC) | PTE_S2_RDONLY)
> >  #define PAGE_S2_DEVICE		__pgprot(PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_UXN)
> >  
> >  #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_TYPE_MASK) | PTE_PROT_NONE | PTE_PXN | PTE_UXN)
> > -- 
> > 2.1.0
> > 
> 
> 
