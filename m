Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710632;
	b=w3ztftdgH+67SlTBJrKTjByjOubNTvi+4W21NvGD40hUHAQy8qB9dx88lEQeK1pGViTw
	 mHnoOflu1pVN4iYcInJTA5aKRcgBYvevwZ0XUVYtFXJkORiFflBbksFDsOIli+nOGdpLp
	 L4BEJ5NcT1DtDbOg7jsH4RvBEeBeGEJ2/Pjr8KrkYbqJKnYMBcGL4MtxHZuWQskB2IjFl
	 aF/nOlqaXhvY/q1Gy5vt63saeDjaUe3EFRzk/YEHW4465dpzhuTbwTocNMq+G2i2REsEa
	 uOlaOcVS8Si54mHOujuxTna70GWmAQE4FuoKx5PJ8rNa/2ljeApM/mcfqJjblH+gw5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710632;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=T0wFVo5HP+kKmIiyxIKEaBNiT66/ZZt4C71Y6HjPI5k=;
	b=LvoxgPRIksqIHx0axYbYXMzDTBW8kezS8tTbtq1OtCbDxv4fou1JhuB7WDRNsxKHYzD6
	 9WWwKZywDI1iAl1ATDKIUhcLWkI7qPOaWg/B7w/5bLqDsNNaBwWupILsNyV51P/YFuL3S
	 OKqutgRKuaLI6OdP6fKtfXdyvClLgd32ca0wHd8QQG3WYHBR0D0CemIutwNFRz36L0OXV
	 fiuJUSHNozoYmz8DznEO0++BYPMK8dVx2dXX5hibo1kzv9Fh9xAZrTP0BBPKb6dt150xA
	 Ls/G+Jlx10T1mIYaO1bVhz5lMo9RSa8lwLSmys8aLTkOxVwASsiiXuilFYG1cSEZi3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIqA08ND;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F1606A31E;
	Thu, 26 Nov 2026 16:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIqA08ND
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0AD1F000C4;
	Thu, 26 Nov 2026 16:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795710632;
	bh=T0wFVo5HP+kKmIiyxIKEaBNiT66/ZZt4C71Y6HjPI5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIqA08ND/GEPfKc42Hr2J/1lGFxdtFn/XQ9pA0PcLrkOeaAhJQw9H1oTPWc6SdeLs
	 Ypn/2r1bepO4+iJ6+zlEa+0AvywxSq+4bg/mUm7wpmfkUBHpxZXdDyWYJslu3Q8B/U
	 vbtaDAdOLS55I0IxxGS958Jw5Av62mLYsLxnXOrRek1xz04b+tdAzFjzZxHWqnwp8N
	 NM5E2/l5yJbiE9tJPoGv4/ftCjUaaPhL7vRq/gjOVT/Mzf0A5FEoG+8xxHunV2hzw+
	 +9d8SaZOQVeFQcdjwMFKjFGC2gI0Nt2lrxPSSJv5+Yg8plTIs1UOOl1w5pVj9kT1L5
	 gflejva/fjeog==
Date: Thu, 26 Nov 2026 16:30:24 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>, Leonardo Bras <leo.bras@arm.com>, 
	maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, riel@surriel.com, 
	shakeel.butt@linux.dev, kernel-team@meta.com, rkeilty@meta.com, atish.patra@linux.dev, 
	dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Message-ID: <awhH1Dpu0uIwP6ea@gremlin>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK>
 <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK>
 <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
 <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>

On Thu, Nov 26, 2026 at 08:06:41AM +0000, Wei-Lin Chang wrote:
> On Wed, Nov 25, 2026 at 09:42:33PM +0000, Usama Arif wrote:
> > On 25/11/2026 10:25, Leonardo Bras wrote:
> > > On Wed, Nov 25, 2026 at 05:55:29PM +0000, Usama Arif wrote:
> > >> Right, and that is the problem. Skipping the top-up avoids refilling
> > >> the cache, but nothing ever drains it. A vCPU's first fault fills its
> > >> cache to 40. Each last-level table covers 512 MiB, so a guest needs very
> > >> few table pages, and most vCPUs never drop below min. The remaining
> > >> pages stay allocated until the vCPU is destroyed, which is why the
> > >> production caches were still 86% full.
> > >>
> > >> The patch keeps the early return and only lowers how far a refill goes.
> > >
> > > Right,
> > >
> > > I took a look in the cache workings, and it does not seem to receive freed
> > > pages back in. It gets filled by topup and used by map, so IIUC it is used
> > > only to avoid failing an allocation during the mapping walk.
> > >
> > > Maybe it could be the case to simplify this cache to have the capacity
> > > about the same as the minimum (since it always topup before mapping) and
> > > avoid the waste altogether.

Yeah, I really feel this 40 number (derived from x86 as double some other magic
number :) is bogus here and a historic artifact.

I think this is all a great chance to simplify here :) we can address Usama's
concerns at the same time as making all this actually make sense.

>
> Well the more you reserve the less frequent you'd need to actually allocate at
> topup, which saves time, so there's this trade-off to consider.

Hmm, but the topup is allocating anyway either way no matter the reserve right?

kvm_mmu_memory_cache_alloc() grabs from mc->objects and decrements mc->nobjs for
every allocation (N objects in total), and __kvm_mmu_topup_memory_cache() tops
up N objects back up to the reserve, wherever that should be.

So the only question really is what can the maximum N be? And right now this is
guesstimated at by a magic number.

Also, if it turns out it does:

[ topup X pages ] [ use X pages ] [ topup X pages ]

And you have X + Y pages in the cache, that actually means you have uselessly
allocated Y pages sat around doing nothing that are leaked until the vCPU is
destroyed AFAICT.

I think though as per Leo, we should avoid using a magic number.

And as per Marc, we should calculate what this number should be sensibly.

So something like what Leo suggested is the right way to go!

> > >
> > > Maymbe having something like this should be enough?
> > >
> > > #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE (KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL)
> > >

I think this is definitely the right approach!

> >
> > That sounds good to me. I tested and it works (and releases even more memory :))
> >
> > I had to move #defines around to make it work, the current patch sits
> > like below. If this seems acceptable, I can send it as v2 for review.
> >
> >
> > >From 9b044379f470625adb031a0ee7529e054d9ec219 Mon Sep 17 00:00:00 2001
> > From: Usama Arif <usama.arif@linux.dev>
> > Date: Wed, 25 Nov 2026 12:55:15 -0800
> > Subject: [PATCH] KVM: arm64: Shrink the stage-2 memcache to the page-table
> >  depth
> >
> > When a stage-2 fault may need new page tables, KVM first tops up the
> > vCPU's memcache: if it holds fewer pages than the fault might need, it
> > is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> > 40. Pages never return to the cache, and unused ones stay there until
> > the vCPU is destroyed.
> >
> > The cache only has to cover a single map: every fault that can allocate
> > tables tops it up first, and a map allocates at most one table per
> > level below the preallocated root (kvm_mmu_cache_min_pages()). That is
> > at most three pages with 4 KiB and 16 KiB pages, and two with 64 KiB
> > pages.

Yes this seems correct.

> >
> > With 64 KiB pages, the 40-page cache is 2.5 MiB per vCPU. As every
> > last-level table covers 512 MiB, an 8 GiB guest needs just 17 table
> > pages to map all of its memory, while its four vCPU caches get filled
> > with 160. On a production host with 64 KiB pages running 101 VMs with
> > four vCPUs each, the caches were still 86% full. The memory used:
> >
> >                         before      after
> >   per-vCPU capacity     2.5 MiB     256 KiB
> >   all 404 vCPUs         869 MiB     <= 101 MiB
> >
> > Let's size the cache to KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL,
> > which is 4 pages and covers the deepest walk with one page to spare. On

Hmm why would you need 1 page to spare?

> > the host above, it frees at least 768 MiB. Refills get more frequent,
> > but no more than four pages per vCPU ever sit unused. With 4 KiB pages,
> > the cache shrinks from 160 KiB to 16 KiB per vCPU.
> >
> > Move the two level definitions to asm/kvm_types.h, so that the generic
> > top-up code in kvm_main.c can see them. kvm_pgtable.h still gets them
> > through linux/kvm_types.h.
> >
> > The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
> > but it is topped up before every page it maps. The pKVM hypervisor
> > memcache and the eager split cache don't use this capacity.
> >
> > Suggested-by: Leonardo Bras <leo.bras@arm.com>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 3 ---
> >  arch/arm64/include/asm/kvm_types.h   | 7 ++++++-
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> > index eda440354a55ec..691e2eb63939f5 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -19,9 +19,6 @@
> >
> >  struct kvm_s2_mmu;
> >
> > -#define KVM_PGTABLE_FIRST_LEVEL		-1
> > -#define KVM_PGTABLE_LAST_LEVEL		3
> > -
> >  /*
> >   * The largest supported block sizes for KVM (no 52-bit PA support):
> >   *  - 4K (level 1):	1GB
> > diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > index 9a126b9e2d7c99..5b61285d317e28 100644
> > --- a/arch/arm64/include/asm/kvm_types.h
> > +++ b/arch/arm64/include/asm/kvm_types.h
> > @@ -2,7 +2,12 @@
> >  #ifndef _ASM_ARM64_KVM_TYPES_H
> >  #define _ASM_ARM64_KVM_TYPES_H
> >
> > -#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > +#define KVM_PGTABLE_FIRST_LEVEL		-1
> > +#define KVM_PGTABLE_LAST_LEVEL		3
> > +

The -1 isn't needed here at all right? So why not just import
KVM_PGTABLE_LAST_LEVEL and do:

#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE       KVM_PGTABLE_LAST_LEVEL

?

> > +/* One page per level below the root covers kvm_mmu_cache_min_pages(). */
> > +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE	\
> > +	(KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL)
> >
> >  #endif /* _ASM_ARM64_KVM_TYPES_H */
> >
> > --
> > 2.53.1-Meta
> >
> >
> >
> > > Thanks!
> > > Leo
> >
>

I also think actually there's an existing problem with the top-up right now in
user_mem_abort() that needs addressing too, actually, that this change exposes
and will cause bugs if done as above.

So right now top-up is conditional there:

	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
	    is_protected_kvm_enabled()) {
		ret = topup_mmu_memcache(s2fd->mmu, memcache);
		if (ret)
			return ret;
	}

Inverted is 'permission fault && !dirty-logging && !pKVM'. So the question is
whether a permission fault not needing a new page table is correct.

So working through, the actual decision about a page table allocation is done
in:

user_mem_abort()
  -> kvm_s2_fault_map()
    -> kvm_pgtable_stage2_map()
      -> ... -> stage2_map_walk_leaf()
        -> stage2_map_walker_try_leaf()
	  -> stage2_leaf_mapping_allowed()
	    -> kvm_block_mapping_supported() [ if false, allocate a page table ]

static bool kvm_block_mapping_supported(const struct kvm_pgtable_visit_ctx *ctx, u64 phys)
{
	u64 granule = kvm_granule_size(ctx->level);

	...

	if (granule > (ctx->end - ctx->addr))
		return false;

	...
}

But page table size can vary in NV between host and guest (guest must be >=
host) and it gets clamped to the smaller of the two in kvm_s2_resolve_vma_size():

static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
				     struct kvm_s2_fault_vma_info *s2vi,
				     struct vm_area_struct *vma)
{
	...
	if (s2fd->nested) {
		...
		/*
		 * If we're about to create a shadow stage 2 entry, then we
		 * can only create a block mapping if the guest stage 2 page
		 * table uses at least as big a mapping.
		 */
		max_map_size = min(kvm_s2_trans_size(s2fd->nested), max_map_size);
		...
	}
}

This sets s2vi->vma_pagesize based on this value:

static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
				     struct kvm_s2_fault_vma_info *s2vi)
{
	...
	s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, s2vi, vma));
	...
}

And the fault map uses this in the mapping size, which defines ctx->addr, end
above in kvm_block_mapping_supported():

static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
			    const struct kvm_s2_fault_vma_info *s2vi,
			    enum kvm_pgtable_prot prot,
			    void *memcache,
			    struct kvm_s2_fault_result *result)
{
	...
	mapping_size = s2vi->vma_pagesize;
	...
			ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
							 __pfn_to_phys(pfn), prot,
							 memcache, flags);
	...
}

So basically, if the host has smaller page table size than the guest, you need
an extra page table level.

So simple solution is to add nested to the check:

        if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
            is_protected_kvm_enabled() || s2fd->nested) {
                ret = topup_mmu_memcache(s2fd->mmu, memcache);
                if (ret)
                        return ret;
        }

But honestly I wonder at this point if it's truly worth doing all these checks?
Maybe safer to just topup unconditionally.

It'll only top up once before the cache is full anyway, so it's low cost. And
would make more consistent with other fault paths too.

--
Cheers, Lorenzo
