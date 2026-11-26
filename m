Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795706395;
	b=vBs6GlOz726hZ7YXrz2WoxTuymZoLpqHFboAMzrmeCnNUCWvnMAAo67C6S7E+xnl+cn8
	 Ob/ZMF2YUEQu+V4XQvZJgpOnzqB32MTnasGjglDC1mBNiWztrUVQXjilxzdhZJ6BZP6nd
	 +Fcmj6zwFqlx66BF7BPzX6SpotYD0VElAKRv0/Q/5t16c9KEa8cZr3bA/4TDBkOi2Rzci
	 8EZcr2VOxfGUHpslHKd5Tl/BT23bHZZpSp8DEo1UzB7DWakmc2GVCPwdFmSD/dWfOrEf3
	 /jVMVI0eGs/SeMZPf4al4ENPOR3ahywfoXmypbLnsriMBK4UPLcVi+dT3H7bZs1Q23w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795706395;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=QMgp/2nC28JKrOf09pqR66Rci1DXSwuUKHM1Y1VoSV8=;
	b=M3Nusjm1klRSw8zz0sR3qOgZtXxnc66yGwYa2u+G8T6cRng87cyz98elg1BZ5aSo1Ou3
	 pHVPXOb28Lb2Ju7qV7PbEUHRhToC4xwX07YEOdFPu7qrB9UhtZPGiqmiDYKOL00Id0BuI
	 +EH1VsgLsxx9hBx9rtY+UvFY1gCKl1arsG/TNEhF35GWy7Xk5/CYv5OscrbzuziVRZWRr
	 T4/4YreJL6OH/nYTFfX4Ai4ipg2ASix+AzBBECOWs9vIy+R3+/PezC6QzejqsigNdLwVS
	 D4DqawlTkyPnzdhpZyyCVHwuewUDSS/kj2KvMKh8ShmzsVk0OcuphKrKEFaFwsfl0aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JIT1VOBI;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27EE5606A31E
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 15:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27EE5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JIT1VOBI
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 749361BA8;
	Thu, 26 Nov 2026 07:19:50 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14B373F632;
	Thu, 26 Nov 2026 07:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795706393; bh=LzSnB6wTVBMxdMgDc+IiaVVlmYsD4Sq7sIkJ/D9UVsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JIT1VOBIAcOSUPIh9AVwD23Pee7Cxv3bFiPaf2EDUmMw3RGMcEPrpjKKhAIhveTqb
	 uSqfQqpAXPVme+Vvhsj9rY08Iiutmm3ntTH1FtQc7rwJbcr84+qksyh/VabtekIhjo
	 1nld81pTz8scPbhPsbZmsWdYy2kJzK2zFI680ueQ=
From: Leonardo Bras <leo.bras@arm.com>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	rkeilty@meta.com,
	atish.patra@linux.dev,
	dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Date: Thu, 26 Nov 2026 15:19:41 +0000
Message-ID: <awhODYKXnsBi_s_B@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
References: <20261124152842.2634495-1-usama.arif@linux.dev> <awcXhk885lqDRAHy@LeoBrasDK> <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev> <awcoCklLOKeuXPhh@LeoBrasDK> <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev> <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
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
Content-Transfer-Encoding: 8bit

On Thu, Nov 26, 2026 at 08:06:41AM +0000, Wei-Lin Chang wrote:
> On Wed, Nov 25, 2026 at 09:42:33PM +0000, Usama Arif wrote:
> > 
> > 
> > On 25/11/2026 10:25, Leonardo Bras wrote:
> > > On Wed, Nov 25, 2026 at 05:55:29PM +0000, Usama Arif wrote:
> > >>
> > >>
> > >> On 25/11/2026 09:14, Leonardo Bras wrote:
> > >>> On Tue, Nov 24, 2026 at 07:28:42AM -0800, Usama Arif wrote:
> > >>>> When a stage-2 fault may need new page tables, KVM first tops up the
> > >>>> vCPU's page cache: if it holds fewer pages than the fault might need, it
> > >>>> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> > >>>> 40. Unused pages stay in the cache until the vCPU is destroyed.
> > >>>>
> > >>>> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
> > >>>> used. Stage-2 has at most three levels and the root is preallocated, so
> > >>>> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
> > >>>> As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
> > >>>> table pages to map all of its memory, while its four vCPU caches get
> > >>>> filled with 160.
> > >>>>
> > >>>> On a production host with 64 KiB pages running 101 VMs with four vCPUs
> > >>>> each, the caches were still 86% full. The memory used:
> > >>>>
> > >>>>                         before      after
> > >>>>   per-vCPU capacity     2.5 MB     512 KB
> > >>>>   all 404 vCPUs         869 MB     <= 202 MB
> > >>>>
> > >>>> Let's lower the capacity to 8 with 64 KiB pages, In the production
> > >>>> usecase above, it frees at least 667 MB. That still covers the two-page
> > >>>> minimum and leaves room for several table allocations per refill. 4 KB
> > >>>> and 16 KB pages keep 40.
> > >>>>
> > >>>> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
> > >>>> but it is topped up before every page it maps, so 8 is sufficient there
> > >>>> as well. The pKVM hypervisor memcache and the eager split cache don't
> > >>>> use this capacity.
> > >>>>
> > >>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > >>>> ---
> > >>>>  arch/arm64/include/asm/kvm_types.h | 5 +++++
> > >>>>  1 file changed, 5 insertions(+)
> > >>>>
> > >>>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > >>>> index 9a126b9e2d7c99..28568da9ea4a7b 100644
> > >>>> --- a/arch/arm64/include/asm/kvm_types.h
> > >>>> +++ b/arch/arm64/include/asm/kvm_types.h
> > >>>> @@ -2,7 +2,12 @@
> > >>>>  #ifndef _ASM_ARM64_KVM_TYPES_H
> > >>>>  #define _ASM_ARM64_KVM_TYPES_H
> > >>>>  
> > >>>> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
> > >>>> +#ifdef CONFIG_ARM64_64K_PAGES
> > >>>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
> > >>>> +#else
> > >>>>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > >>>> +#endif
> > >>>>  
> > >>>>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> > >>>>  
> > >>>> -- 
> > >>>> 2.53.1-Meta
> > >>>>
> > >>>
> > >>> Hi Usama,
> > >>>
> > >>
> > >> Hello Leonardo,
> > >>
> > >>> Have you tried to reproduce this issue in v7.4-rc1 or newer?
> > >>
> > >> Yes. The patch is against kvmarm/next (v7.4-rc3), which includes
> > >> Lorenzo's pre-fault series, and I A/B tested it there.
> > >>
> > >> On unpatched v7.4-rc3 with 64 KiB pages, a VM whose 16 vCPUs each fault
> > >> in one page needs a single stage-2 table page, yet the vCPU caches hold
> > >> 640 pages (40 MiB). With the patch they hold 127 pages.
> > >>
> > >>>
> > >>> IIUC Lorenzo Stoakes introduced a change that would cause the memcache to 
> > >>> skip topup if the cache contains a minimum of ~4 pages, so it can possibly 
> > >>> improve that issue.
> > >>
> > >> I don't think that part is new. __kvm_mmu_topup_memory_cache() has
> > >> returned early when mc->nobjs >= min since commit 6926f95accee ("KVM:
> > >> Move x86's MMU memory cache helpers to common KVM code"). Lorenzo's
> > >> commit d27acc152c62 ("KVM: arm64: Size the stage-2 memcache from the
> > >> fault MMU") takes min from s2fd->mmu instead of vcpu->arch.hw_mmu. For a
> > >> guest abort that is the same MMU, so nothing changes here.
> > >>
> > >> With 64 KiB pages, min is kvm_mmu_cache_min_pages(), which is at most 2.
> > >>
> > >>>
> > >>> Although I can see that when it's below that minimum it fills the whole 
> > >>> capacity (40) of the cache.
> > >>>
> > >>
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
> 
> Well the more you reserve the less frequent you'd need to actually allocate at
> topup, which saves time, so there's this trade-off to consider.
> 
> Thanks,
> Wei-Lin Chang
> 

Hi Wei-Lin,

IIUC, every time we topup, we call a mmu_memory_cache_alloc_obj() for every 
one of the objects in the array. So as it is today it runs it 40 times, and 
waits until it runs down to allocate up to 40 again.

With the change, it will run 4, then up to 4 how many times are needed.

So having a smaller cache can potentially save both cputime and memory if 
the cache is not that oftenly used. That being said, allocating 40 in 
sequence would be faster than 4 * 10 because the instruction / data cache 
is hot.

I think the only way to evaluate the performance impact is by running some 
benchmarks.

> > > 
> > > Maymbe having something like this should be enough?
> > >  
> > > #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE (KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL)
> > > 
> > 
> > That sounds good to me. I tested and it works (and releases even more memory :))

Out of curiosity, have you tested it in all pagesize scenarios (4k, 16k, 
64k) in both host and guest?


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
> > the host above, it frees at least 768 MiB. Refills get more frequent,
> > but no more than four pages per vCPU ever sit unused. With 4 KiB pages,
> > the cache shrinks from 160 KiB to 16 KiB per vCPU.
> > 
> > Move the two level definitions to asm/kvm_types.h, so that the generic
> > top-up code in kvm_main.c can see them. kvm_pgtable.h still gets them
> > through linux/kvm_types.h.

It looks odd to have the PGTABLE level defines moved to kvm_types.h, but on 
first glance I could not see a better place to put it.

Thanks!
Leo

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
> > +/* One page per level below the root covers kvm_mmu_cache_min_pages(). */
> > +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE	\
> > +	(KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL)
> >  
> >  #endif /* _ASM_ARM64_KVM_TYPES_H */
> >  
> > -- 
> > 2.53.1-Meta
> > 
