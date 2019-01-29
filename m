From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 1/3] KVM: x86: Move mmu_memory_cache functions to common
 code
Date: Tue, 29 Jan 2019 15:25:29 +0100
Message-ID: <20190129142529.GC13482@e113682-lin.lund.arm.com>
References: <20190128144843.11635-1-christoffer.dall@arm.com>
 <20190128144843.11635-2-christoffer.dall@arm.com>
 <20190128161956.GB24792@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F9704A380
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 09:25:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9nXcBu7bzZk9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 09:25:32 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 137CE4A200
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 09:25:32 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190128161956.GB24792@linux.intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>, Paul Mackerras <paulus@ozlabs.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 28, 2019 at 08:19:56AM -0800, Sean Christopherson wrote:
> On Mon, Jan 28, 2019 at 03:48:41PM +0100, Christoffer Dall wrote:
> > We are currently duplicating the mmu memory cache functionality quite
> > heavily between the architectures that support KVM.  As a first step,
> > move the x86 implementation (which seems to have the most recently
> > maintained version of the mmu memory cache) to common code.
> > 
> > We rename the functions and data types to have a kvm_ prefix for
> > anything exported as a symbol to the rest of the kernel and take the
> > chance to rename memory_cache to memcache to avoid overly long lines.
> 
> It'd be helpful to do the rename it a separate patch so that the move
> really is a straight move of code.
> 
> > This is a bit tedious on the callsites but ends up looking more
> > palatable.
> > 
> > We also introduce an arch-specific kvm_types.h which can be used to
> > define the architecture-specific GFP flags for allocating memory to the
> > memory cache, and to specify how many objects are required in the memory
> > cache.  These are the two points where the current implementations
> > diverge across architectures.  Since kvm_host.h defines structures with
> > fields of the memcache object, we define the memcache structure in
> > kvm_types.h, and we include the architecture-specific kvm_types.h to
> > know the size of object in kvm_host.h.
> > 
> > This patch currently only defines the structure and requires valid
> > defines in the architecture-specific kvm_types.h when KVM_NR_MEM_OBJS is
> > defined.  As we move each architecture to the common implementation,
> > this condition will eventually go away.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  arch/arm/include/asm/kvm_types.h     |  5 ++
> >  arch/arm64/include/asm/kvm_types.h   |  6 ++
> >  arch/mips/include/asm/kvm_types.h    |  5 ++
> >  arch/powerpc/include/asm/kvm_types.h |  5 ++
> >  arch/s390/include/asm/kvm_types.h    |  5 ++
> >  arch/x86/include/asm/kvm_host.h      | 17 +----
> >  arch/x86/include/asm/kvm_types.h     | 10 +++
> >  arch/x86/kvm/mmu.c                   | 97 ++++++----------------------
> >  arch/x86/kvm/paging_tmpl.h           |  4 +-
> >  include/linux/kvm_host.h             |  9 +++
> >  include/linux/kvm_types.h            | 12 ++++
> >  virt/kvm/kvm_main.c                  | 58 +++++++++++++++++
> >  12 files changed, 139 insertions(+), 94 deletions(-)
> >  create mode 100644 arch/arm/include/asm/kvm_types.h
> >  create mode 100644 arch/arm64/include/asm/kvm_types.h
> >  create mode 100644 arch/mips/include/asm/kvm_types.h
> >  create mode 100644 arch/powerpc/include/asm/kvm_types.h
> >  create mode 100644 arch/s390/include/asm/kvm_types.h
> >  create mode 100644 arch/x86/include/asm/kvm_types.h
> > 
> > diff --git a/arch/arm/include/asm/kvm_types.h b/arch/arm/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..bc389f82e88d
> > --- /dev/null
> > +++ b/arch/arm/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_ARM_KVM_TYPES_H
> > +#define _ASM_ARM_KVM_TYPES_H
> > +
> > +#endif /* _ASM_ARM_KVM_TYPES_H */
> > diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..d0987007d581
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_types.h
> > @@ -0,0 +1,6 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_ARM64_KVM_TYPES_H
> > +#define _ASM_ARM64_KVM_TYPES_H
> > +
> > +#endif /* _ASM_ARM64_KVM_TYPES_H */
> > +
> > diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..5efeb32a5926
> > --- /dev/null
> > +++ b/arch/mips/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_MIPS_KVM_TYPES_H
> > +#define _ASM_MIPS_KVM_TYPES_H
> > +
> > +#endif /* _ASM_MIPS_KVM_TYPES_H */
> > diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..f627eceaa314
> > --- /dev/null
> > +++ b/arch/powerpc/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_POWERPC_KVM_TYPES_H
> > +#define _ASM_POWERPC_KVM_TYPES_H
> > +
> > +#endif /* _ASM_POWERPC_KVM_TYPES_H */
> > diff --git a/arch/s390/include/asm/kvm_types.h b/arch/s390/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..b66a81f8a354
> > --- /dev/null
> > +++ b/arch/s390/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_S390_KVM_TYPES_H
> > +#define _ASM_S390_KVM_TYPES_H
> > +
> > +#endif /* _ASM_S390_KVM_TYPES_H */
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 4660ce90de7f..5c12cba8c2b1 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -179,8 +179,6 @@ enum {
> >  
> >  #include <asm/kvm_emulate.h>
> >  
> > -#define KVM_NR_MEM_OBJS 40
> > -
> >  #define KVM_NR_DB_REGS	4
> >  
> >  #define DR6_BD		(1 << 13)
> > @@ -238,15 +236,6 @@ enum {
> >  
> >  struct kvm_kernel_irq_routing_entry;
> >  
> > -/*
> > - * We don't want allocation failures within the mmu code, so we preallocate
> > - * enough memory for a single page fault in a cache.
> > - */
> > -struct kvm_mmu_memory_cache {
> > -	int nobjs;
> > -	void *objects[KVM_NR_MEM_OBJS];
> > -};
> > -
> >  /*
> >   * the pages used as guest page table on soft mmu are tracked by
> >   * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
> > @@ -600,9 +589,9 @@ struct kvm_vcpu_arch {
> >  	 */
> >  	struct kvm_mmu *walk_mmu;
> >  
> > -	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> > -	struct kvm_mmu_memory_cache mmu_page_cache;
> > -	struct kvm_mmu_memory_cache mmu_page_header_cache;
> > +	struct kvm_mmu_memcache mmu_pte_list_desc_cache;
> > +	struct kvm_mmu_memcache mmu_page_cache;
> > +	struct kvm_mmu_memcache mmu_page_header_cache;
> >  
> >  	/*
> >  	 * QEMU userspace and the guest each have their own FPU state.
> > diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..f71fe5556b6f
> > --- /dev/null
> > +++ b/arch/x86/include/asm/kvm_types.h
> > @@ -0,0 +1,10 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_X86_KVM_TYPES_H
> > +#define _ASM_X86_KVM_TYPES_H
> > +
> > +#define KVM_NR_MEM_OBJS 40
> > +
> > +#define KVM_MMU_CACHE_GFP	GFP_KERNEL
> > +#define KVM_MMU_CACHE_PAGE_GFP	GFP_KERNEL_ACCOUNT
> > +
> > +#endif /* _ASM_X86_KVM_TYPES_H */
> > diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> > index ce770b446238..cf0024849404 100644
> > --- a/arch/x86/kvm/mmu.c
> > +++ b/arch/x86/kvm/mmu.c
> > @@ -951,94 +951,35 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> >  	local_irq_enable();
> >  }
> >  
> > -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> > -				  struct kmem_cache *base_cache, int min)
> > -{
> > -	void *obj;
> > -
> > -	if (cache->nobjs >= min)
> > -		return 0;
> > -	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> > -		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
> > -		if (!obj)
> > -			return cache->nobjs >= min ? 0 : -ENOMEM;
> > -		cache->objects[cache->nobjs++] = obj;
> > -	}
> > -	return 0;
> > -}
> > -
> > -static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
> > -{
> > -	return cache->nobjs;
> > -}
> > -
> > -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
> > -				  struct kmem_cache *cache)
> > -{
> > -	while (mc->nobjs)
> > -		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
> > -}
> > -
> > -static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
> > -				       int min)
> > -{
> > -	void *page;
> > -
> > -	if (cache->nobjs >= min)
> > -		return 0;
> > -	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> > -		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> > -		if (!page)
> > -			return cache->nobjs >= min ? 0 : -ENOMEM;
> > -		cache->objects[cache->nobjs++] = page;
> > -	}
> > -	return 0;
> > -}
> > -
> > -static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
> > -{
> > -	while (mc->nobjs)
> > -		free_page((unsigned long)mc->objects[--mc->nobjs]);
> > -}
> > -
> > -static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
> > +static int mmu_topup_memcaches(struct kvm_vcpu *vcpu)
> >  {
> >  	int r;
> >  
> > -	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> > +	r = kvm_mmu_topup_memcache(&vcpu->arch.mmu_pte_list_desc_cache,
> >  				   pte_list_desc_cache, 8 + PTE_PREFETCH_NUM);
> >  	if (r)
> >  		goto out;
> > -	r = mmu_topup_memory_cache_page(&vcpu->arch.mmu_page_cache, 8);
> > +	r = kvm_mmu_topup_memcache_page(&vcpu->arch.mmu_page_cache, 8);
> >  	if (r)
> >  		goto out;
> > -	r = mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> > +	r = kvm_mmu_topup_memcache(&vcpu->arch.mmu_page_header_cache,
> >  				   mmu_page_header_cache, 4);
> >  out:
> >  	return r;
> >  }
> >  
> > -static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> > +static void mmu_free_memcaches(struct kvm_vcpu *vcpu)
> >  {
> > -	mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> > +	kvm_mmu_free_memcache(&vcpu->arch.mmu_pte_list_desc_cache,
> >  				pte_list_desc_cache);
> > -	mmu_free_memory_cache_page(&vcpu->arch.mmu_page_cache);
> > -	mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache,
> > +	kvm_mmu_free_memcache_page(&vcpu->arch.mmu_page_cache);
> > +	kvm_mmu_free_memcache(&vcpu->arch.mmu_page_header_cache,
> >  				mmu_page_header_cache);
> >  }
> >  
> > -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> > -{
> > -	void *p;
> > -
> > -	BUG_ON(!mc->nobjs);
> > -	p = mc->objects[--mc->nobjs];
> > -	return p;
> > -}
> > -
> >  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
> >  {
> > -	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> > +	return kvm_mmu_memcache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> >  }
> >  
> >  static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
> > @@ -1358,10 +1299,10 @@ static struct kvm_rmap_head *gfn_to_rmap(struct kvm *kvm, gfn_t gfn,
> >  
> >  static bool rmap_can_add(struct kvm_vcpu *vcpu)
> >  {
> > -	struct kvm_mmu_memory_cache *cache;
> > +	struct kvm_mmu_memcache *cache;
> >  
> >  	cache = &vcpu->arch.mmu_pte_list_desc_cache;
> > -	return mmu_memory_cache_free_objects(cache);
> > +	return kvm_mmu_memcache_free_objects(cache);
> >  }
> >  
> >  static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
> > @@ -2044,10 +1985,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
> >  {
> >  	struct kvm_mmu_page *sp;
> >  
> > -	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > -	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
> > +	sp = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_header_cache);
> > +	sp->spt = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_cache);
> >  	if (!direct)
> > -		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
> > +		sp->gfns = kvm_mmu_memcache_alloc(&vcpu->arch.mmu_page_cache);
> >  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> >  
> >  	/*
> > @@ -3961,7 +3902,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
> >  	if (page_fault_handle_page_track(vcpu, error_code, gfn))
> >  		return RET_PF_EMULATE;
> >  
> > -	r = mmu_topup_memory_caches(vcpu);
> > +	r = mmu_topup_memcaches(vcpu);
> >  	if (r)
> >  		return r;
> >  
> > @@ -4090,7 +4031,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
> >  	if (page_fault_handle_page_track(vcpu, error_code, gfn))
> >  		return RET_PF_EMULATE;
> >  
> > -	r = mmu_topup_memory_caches(vcpu);
> > +	r = mmu_topup_memcaches(vcpu);
> >  	if (r)
> >  		return r;
> >  
> > @@ -5062,7 +5003,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
> >  {
> >  	int r;
> >  
> > -	r = mmu_topup_memory_caches(vcpu);
> > +	r = mmu_topup_memcaches(vcpu);
> >  	if (r)
> >  		goto out;
> >  	r = mmu_alloc_roots(vcpu);
> > @@ -5240,7 +5181,7 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> >  	 * or not since pte prefetch is skiped if it does not have
> >  	 * enough objects in the cache.
> >  	 */
> > -	mmu_topup_memory_caches(vcpu);
> > +	mmu_topup_memcaches(vcpu);
> >  
> >  	spin_lock(&vcpu->kvm->mmu_lock);
> >  
> > @@ -6052,7 +5993,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> >  {
> >  	kvm_mmu_unload(vcpu);
> >  	free_mmu_pages(vcpu);
> > -	mmu_free_memory_caches(vcpu);
> > +	mmu_free_memcaches(vcpu);
> >  }
> >  
> >  void kvm_mmu_module_exit(void)
> > diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> > index 6bdca39829bc..c32b603639a9 100644
> > --- a/arch/x86/kvm/paging_tmpl.h
> > +++ b/arch/x86/kvm/paging_tmpl.h
> > @@ -747,7 +747,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
> >  
> >  	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
> >  
> > -	r = mmu_topup_memory_caches(vcpu);
> > +	r = mmu_topup_memcaches(vcpu);
> >  	if (r)
> >  		return r;
> >  
> > @@ -870,7 +870,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
> >  	 * No need to check return value here, rmap_can_add() can
> >  	 * help us to skip pte prefetch later.
> >  	 */
> > -	mmu_topup_memory_caches(vcpu);
> > +	mmu_topup_memcaches(vcpu);
> >  
> >  	if (!VALID_PAGE(root_hpa)) {
> >  		WARN_ON(1);
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index c38cc5eb7e73..f5768e5d33f7 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -739,6 +739,15 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
> >  void kvm_flush_remote_tlbs(struct kvm *kvm);
> >  void kvm_reload_remote_mmus(struct kvm *kvm);
> >  
> > +int kvm_mmu_topup_memcache(struct kvm_mmu_memcache *cache,
> > +			   struct kmem_cache *base_cache, int min);
> > +int kvm_mmu_memcache_free_objects(struct kvm_mmu_memcache *cache);
> > +void kvm_mmu_free_memcache(struct kvm_mmu_memcache *mc,
> > +			   struct kmem_cache *cache);
> > +int kvm_mmu_topup_memcache_page(struct kvm_mmu_memcache *cache, int min);
> > +void kvm_mmu_free_memcache_page(struct kvm_mmu_memcache *mc);
> > +void *kvm_mmu_memcache_alloc(struct kvm_mmu_memcache *mc);
> > +
> >  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
> >  				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
> >  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 8bf259dae9f6..a314f0f08e22 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -32,6 +32,7 @@ struct kvm_memslots;
> >  
> >  enum kvm_mr_change;
> >  
> > +#include <asm/kvm_types.h>
> >  #include <asm/types.h>
> >  
> >  /*
> > @@ -63,4 +64,15 @@ struct gfn_to_hva_cache {
> >  	struct kvm_memory_slot *memslot;
> >  };
> >  
> > +#ifdef KVM_NR_MEM_OBJS
> 
> While you're renaming the functions, would it make sense to also rename
> the define, e.g. KVM_MMU_NR_MEMCACHE_OBJS, or maybe something a little
> less verbose.
> 
> > +/*
> > + * We don't want allocation failures within the mmu code, so we preallocate
> > + * enough memory for a single page fault in a cache.
> > + */
> > +struct kvm_mmu_memcache {
> 
> Wrapping the kvm_mmu_memcache definition in KVM_NR_MEM_OBJS will break
> compilation on any arch that doesn't define KVM_NR_MEM_OBJS.
> 

Yes, this is obviously broken.

I'll respin with your comments addressed.

Thanks,

    Christoffer
