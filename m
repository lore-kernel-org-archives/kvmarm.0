Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711543;
	b=GXoPG9+erStDYXNizoMu+GhGqLwZ26anCiSBPGDDcOCtABqsmAZST2i/pCv4wbEu1L5f
	 DWT7UTxKu4o8vDFSWiCo9n2YoSSwGbQJnNBdQUfaaIWQ+GaxbtX4Ken5bDMrj6rXlY6dC
	 E4puIoL8ZaxzmNrvEhbU7O51H6Crb30EvxXc6nId4JO9cKqupAwWhexrphSvKS+TBZWkY
	 hN165SwLz6V6c1hBx6UOWO89i5Z2QZP20ByIpCT5X7hdg2+mriDyOTN6eGiqE0xRr9/Nt
	 SkvItORXlxAqn+zl2uZK2eR3gV0ZdMOa12nixBkdJNxdgzZ9ika4zxGxddLbZ5L2Puw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711543;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ggq5C5EPaN+V5j/mcWxCGkhHXH9eo2C8yHSBGX3RET0=;
	b=FUFcLroWpqj5spgTUl2WfNSsDZGNxl8O6+VTnXj4kKSwya42mciIOKP++vH+PCMGnUqi
	 hd9zrKL3k4lv+cTR4T/dowB90BXD7XDQjceKqOiAJjixdpMGBxQGMOV6sLVsM5N/gvFhg
	 Y+v5si1tzw9VcyAM/2VpErqqibXeekNrXuTeTIA0+ROKryJj+QC8GOREIB8kuJwsE/Xbi
	 Vm+emkvJSK0U/uD5LoJT0MX5FOaxzT1KIGRnBJg/1tlN27Ksfw77mlQ5Ra+7eORsaa2wo
	 ViZx/E9bs2Sr+GNd1kUaeK/+hB/QgAfHWX8Ngkb4wIf4uBENiMEJrmhBR7ikjnYeA/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4mD3Jha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18472606A31E;
	Thu, 26 Nov 2026 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4mD3Jha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB00F1F000C0;
	Thu, 26 Nov 2026 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795711542;
	bh=ggq5C5EPaN+V5j/mcWxCGkhHXH9eo2C8yHSBGX3RET0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T4mD3JhaRXLddV/RvVTcHLTesI5QkpVo1o9mQdfXfFlNtS/1mtAaT4YWgC4W2xahr
	 MZjX5BAA0sFGdToYtvKmbvGwJp+lKyME8Wh6bkO+lD/ons0rIbcOAaMm6DOGLQDIzq
	 qboiSbLlm7TCcpvHhIVnwWPT2JAkt7RAgFo/HMQId+jn9ya+cAujSPSV0y9l+fSJc2
	 iTY0b1Xpd1/J1mo8GWkJQiHZ3UohEaYc0wVt/GMS5XrFH77k4UqmngZREkYHSusIqQ
	 +kvBghEVgkvDg3J69G9rQ4lP2BiIROJM55VY6hVIWSlxMFUGInyVrkZAW8xABOASoQ
	 gQeIJBXv4mFVw==
Date: Thu, 26 Nov 2026 16:45:35 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	rkeilty@meta.com, atish.patra@linux.dev, dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Message-ID: <awhfXrdkHkY-riN3@gremlin>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK>
 <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK>
 <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
 <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
 <awhODYKXnsBi_s_B@LeoBrasDK>
 <klnyvfxwhpw73wo55y5aq3qliglnf7xkfkmfj6cgzje7z3n2fq@aqjxshyjnldu>
 <awhWYdZVkESY9eJs@LeoBrasDK>
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
In-Reply-To: <awhWYdZVkESY9eJs@LeoBrasDK>

On Thu, Nov 26, 2026 at 03:55:13PM +0000, Leonardo Bras wrote:
> On Thu, Nov 26, 2026 at 03:34:19PM +0000, Wei-Lin Chang wrote:
> > On Thu, Nov 26, 2026 at 03:19:41PM +0000, Leonardo Bras wrote:
> > > On Thu, Nov 26, 2026 at 08:06:41AM +0000, Wei-Lin Chang wrote:
> > > > On Wed, Nov 25, 2026 at 09:42:33PM +0000, Usama Arif wrote:
> > > > >
> > > > >
> > > > > On 25/11/2026 10:25, Leonardo Bras wrote:
> > > > > > On Wed, Nov 25, 2026 at 05:55:29PM +0000, Usama Arif wrote:
> > > > > >>
> > > > > >>
> > > > > >> On 25/11/2026 09:14, Leonardo Bras wrote:
> > > > > >>> On Tue, Nov 24, 2026 at 07:28:42AM -0800, Usama Arif wrote:
> > > > > >>>> When a stage-2 fault may need new page tables, KVM first tops up the
> > > > > >>>> vCPU's page cache: if it holds fewer pages than the fault might need, it
> > > > > >>>> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> > > > > >>>> 40. Unused pages stay in the cache until the vCPU is destroyed.
> > > > > >>>>
> > > > > >>>> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
> > > > > >>>> used. Stage-2 has at most three levels and the root is preallocated, so
> > > > > >>>> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
> > > > > >>>> As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
> > > > > >>>> table pages to map all of its memory, while its four vCPU caches get
> > > > > >>>> filled with 160.
> > > > > >>>>
> > > > > >>>> On a production host with 64 KiB pages running 101 VMs with four vCPUs
> > > > > >>>> each, the caches were still 86% full. The memory used:
> > > > > >>>>
> > > > > >>>>                         before      after
> > > > > >>>>   per-vCPU capacity     2.5 MB     512 KB
> > > > > >>>>   all 404 vCPUs         869 MB     <= 202 MB
> > > > > >>>>
> > > > > >>>> Let's lower the capacity to 8 with 64 KiB pages, In the production
> > > > > >>>> usecase above, it frees at least 667 MB. That still covers the two-page
> > > > > >>>> minimum and leaves room for several table allocations per refill. 4 KB
> > > > > >>>> and 16 KB pages keep 40.
> > > > > >>>>
> > > > > >>>> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
> > > > > >>>> but it is topped up before every page it maps, so 8 is sufficient there
> > > > > >>>> as well. The pKVM hypervisor memcache and the eager split cache don't
> > > > > >>>> use this capacity.
> > > > > >>>>
> > > > > >>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > > > > >>>> ---
> > > > > >>>>  arch/arm64/include/asm/kvm_types.h | 5 +++++
> > > > > >>>>  1 file changed, 5 insertions(+)
> > > > > >>>>
> > > > > >>>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > > > > >>>> index 9a126b9e2d7c99..28568da9ea4a7b 100644
> > > > > >>>> --- a/arch/arm64/include/asm/kvm_types.h
> > > > > >>>> +++ b/arch/arm64/include/asm/kvm_types.h
> > > > > >>>> @@ -2,7 +2,12 @@
> > > > > >>>>  #ifndef _ASM_ARM64_KVM_TYPES_H
> > > > > >>>>  #define _ASM_ARM64_KVM_TYPES_H
> > > > > >>>>
> > > > > >>>> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
> > > > > >>>> +#ifdef CONFIG_ARM64_64K_PAGES
> > > > > >>>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
> > > > > >>>> +#else
> > > > > >>>>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > > > > >>>> +#endif
> > > > > >>>>
> > > > > >>>>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> > > > > >>>>
> > > > > >>>> --
> > > > > >>>> 2.53.1-Meta
> > > > > >>>>
> > > > > >>>
> > > > > >>> Hi Usama,
> > > > > >>>
> > > > > >>
> > > > > >> Hello Leonardo,
> > > > > >>
> > > > > >>> Have you tried to reproduce this issue in v7.4-rc1 or newer?
> > > > > >>
> > > > > >> Yes. The patch is against kvmarm/next (v7.4-rc3), which includes
> > > > > >> Lorenzo's pre-fault series, and I A/B tested it there.
> > > > > >>
> > > > > >> On unpatched v7.4-rc3 with 64 KiB pages, a VM whose 16 vCPUs each fault
> > > > > >> in one page needs a single stage-2 table page, yet the vCPU caches hold
> > > > > >> 640 pages (40 MiB). With the patch they hold 127 pages.
> > > > > >>
> > > > > >>>
> > > > > >>> IIUC Lorenzo Stoakes introduced a change that would cause the memcache to
> > > > > >>> skip topup if the cache contains a minimum of ~4 pages, so it can possibly
> > > > > >>> improve that issue.
> > > > > >>
> > > > > >> I don't think that part is new. __kvm_mmu_topup_memory_cache() has
> > > > > >> returned early when mc->nobjs >= min since commit 6926f95accee ("KVM:
> > > > > >> Move x86's MMU memory cache helpers to common KVM code"). Lorenzo's
> > > > > >> commit d27acc152c62 ("KVM: arm64: Size the stage-2 memcache from the
> > > > > >> fault MMU") takes min from s2fd->mmu instead of vcpu->arch.hw_mmu. For a
> > > > > >> guest abort that is the same MMU, so nothing changes here.
> > > > > >>
> > > > > >> With 64 KiB pages, min is kvm_mmu_cache_min_pages(), which is at most 2.
> > > > > >>
> > > > > >>>
> > > > > >>> Although I can see that when it's below that minimum it fills the whole
> > > > > >>> capacity (40) of the cache.
> > > > > >>>
> > > > > >>
> > > > > >> Right, and that is the problem. Skipping the top-up avoids refilling
> > > > > >> the cache, but nothing ever drains it. A vCPU's first fault fills its
> > > > > >> cache to 40. Each last-level table covers 512 MiB, so a guest needs very
> > > > > >> few table pages, and most vCPUs never drop below min. The remaining
> > > > > >> pages stay allocated until the vCPU is destroyed, which is why the
> > > > > >> production caches were still 86% full.
> > > > > >>
> > > > > >> The patch keeps the early return and only lowers how far a refill goes.
> > > > > >
> > > > > > Right,
> > > > > >
> > > > > > I took a look in the cache workings, and it does not seem to receive freed
> > > > > > pages back in. It gets filled by topup and used by map, so IIUC it is used
> > > > > > only to avoid failing an allocation during the mapping walk.
> > > > > >
> > > > > > Maybe it could be the case to simplify this cache to have the capacity
> > > > > > about the same as the minimum (since it always topup before mapping) and
> > > > > > avoid the waste altogether.
> > > >
> > > > Well the more you reserve the less frequent you'd need to actually allocate at
> > > > topup, which saves time, so there's this trade-off to consider.
> > > >
> > > > Thanks,
> > > > Wei-Lin Chang
> > > >
> > >
> > > Hi Wei-Lin,
> > >
> > > IIUC, every time we topup, we call a mmu_memory_cache_alloc_obj() for every
> > > one of the objects in the array. So as it is today it runs it 40 times, and
> >
> > Not necessarily, I meant with 40,
> >
> > if (mc->nobjs >= min)
> > 	return 0;
> >
> > happens way more often.
>
> That's what I meant with 'waits until it runs down'. Basically we have
>
> if (mc->nobjs >= min)
> 	return 0;
>
> while (mc->nobjs < mc->capacity) {
> 	obj = mmu_memory_cache_alloc_obj(mc, gfp);
> 	...
>
> So, first use it allocates mc->capacity entries, and every further topup
> will return early unless it goes below min, when it populates again. The
> only reason for a larger cache being more performant would be to use
> that cache locality, which could indeed have a large impact, if we use this
> cache a lot.

I think there's confusion because of this being called a cache, this is more
pre-allocation than anything it seems. As per the comment above struct
kvm_mmu_memory_cache in include/linux/kvm_types.h:

 * Memory caches are used to preallocate memory ahead of various MMU flows,
 * e.g. page fault handlers.  Gracefully handling allocation failures deep in
 * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
 * holding MMU locks.  Note, these caches act more like prefetch buffers than
 * classical caches, i.e. objects are not returned to the cache on being freed.

The question is would going from 40 to 3 slow things down?

At 40 you do 40 __get_free_page() calls on topup for the _first_ fault that hits
it, which adds latency to a random s2 fault (not great).

(If the fault doesn't in fact use a page table, this is only done once until a
page table is next needed).

And then as 37 page tables are mapped, those ones don't get allocations at 38
you go again...

With 3 in the cache you allocate up to 3 for each fault.

So in both cases you allocate the same amount of pages but in the 40 case it's
all bunched up on one s2 fault with a jump in latency, in the 3 case it's spread
out.

I'd say 3 is therefore the better choice.

Also, as mentioned elsewhere, you end up leaking pages once the S2 page tables
are setup until the vCPU is destroyed, as nothing clears down the cache
AFAICT. With 40 that's way more than with 3.

--
Cheers, Lorenzo
