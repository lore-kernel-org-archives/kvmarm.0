Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708520;
	b=Gf0xgmrCLtGkJ/1e+er6HwelyTUw7ShubRiOxHfVm5xHxiVmzAx0QXJp5niQyT/GoVAD
	 bmgcUi8wapk/SLRsN2sID7ChGs4NRQoLK61krb5JrT7gHm6nG+SewvZJTOttkEqPEYW/k
	 68rIxFfiVQp/EHy+dgRQkBRuCu414n+C9SxRVCDBzqth7e2O7ch2HwJYoroJ+JZrLod/t
	 Td1RVHO5j7kBOF7eF0jcWVzU1zgDXxhZhItMcfdluDu2UTcC1NyQIv14e7pAcblDG9AKG
	 Tm5Omc3SSFRcy7d8mU5/FhUlMke373a3uXzOz/m0Ehuygph13aK7/8xKboMCkTBT1FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708520;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=GWUKzQOK5TMyRFajMGCLMgpr+ANo1hrXcxfeGfWdrNo=;
	b=XehIstsuHVVmP67sFiXf8PwRFK579iXLM81jUFsOrTkTNehVMi0ylFu19c0pk9WeYi5d
	 4J2ApXVqinQAH1NDaQid9SIW5SsS/n80lDLaThQhNy3LnNQSOSJI1PYd6OpkY/YBNg27R
	 J2HGp5/nL1nnNyNGsm91ZoFYdyVfmTYSLi8i111f7DX/nWCQl7MK3q2kvI2xrgMKzMhTF
	 YD6mfYM1mE5YGk1YI4Y/Wy/fUIec5p/4rV6ML1wk642zvRTnuHKif79xQlcsB1w2eLdTX
	 LsxJyTljWJVU7Imb13sRyDLbGDrqDMrEZoEzw2WEAQyMvXhyPzHkd/P9iq/YdcbIvRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z1EsWO6A;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38621606A323
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 15:55:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38621606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Z1EsWO6A
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB7961BA8;
	Thu, 26 Nov 2026 07:55:16 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CC153F632;
	Thu, 26 Nov 2026 07:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795708519; bh=W3j5bTkpiQ5xyMVgEBbFFifoyYnABJf1hwDRohAf4B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1EsWO6A8CnkdOnaCV32+CRdvuEWM9h6nXvinWH9WhTKmixvP+R/wcLiSNCIgQIte
	 KoQ9diaAmbY30+PONFKwnKzJWw5uu1l+VPp4fnSF3tn2WAJUEaS/PE/YDLO+GeM8ex
	 aX+rUoWjVgXlHtnI7PETBlVzGgqbpyS054EFVesA=
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
Date: Thu, 26 Nov 2026 15:55:13 +0000
Message-ID: <awhWYdZVkESY9eJs@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <klnyvfxwhpw73wo55y5aq3qliglnf7xkfkmfj6cgzje7z3n2fq@aqjxshyjnldu>
References: <20261124152842.2634495-1-usama.arif@linux.dev> <awcXhk885lqDRAHy@LeoBrasDK> <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev> <awcoCklLOKeuXPhh@LeoBrasDK> <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev> <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq> <awhODYKXnsBi_s_B@LeoBrasDK> <klnyvfxwhpw73wo55y5aq3qliglnf7xkfkmfj6cgzje7z3n2fq@aqjxshyjnldu>
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

On Thu, Nov 26, 2026 at 03:34:19PM +0000, Wei-Lin Chang wrote:
> On Thu, Nov 26, 2026 at 03:19:41PM +0000, Leonardo Bras wrote:
> > On Thu, Nov 26, 2026 at 08:06:41AM +0000, Wei-Lin Chang wrote:
> > > On Wed, Nov 25, 2026 at 09:42:33PM +0000, Usama Arif wrote:
> > > > 
> > > > 
> > > > On 25/11/2026 10:25, Leonardo Bras wrote:
> > > > > On Wed, Nov 25, 2026 at 05:55:29PM +0000, Usama Arif wrote:
> > > > >>
> > > > >>
> > > > >> On 25/11/2026 09:14, Leonardo Bras wrote:
> > > > >>> On Tue, Nov 24, 2026 at 07:28:42AM -0800, Usama Arif wrote:
> > > > >>>> When a stage-2 fault may need new page tables, KVM first tops up the
> > > > >>>> vCPU's page cache: if it holds fewer pages than the fault might need, it
> > > > >>>> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> > > > >>>> 40. Unused pages stay in the cache until the vCPU is destroyed.
> > > > >>>>
> > > > >>>> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
> > > > >>>> used. Stage-2 has at most three levels and the root is preallocated, so
> > > > >>>> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
> > > > >>>> As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
> > > > >>>> table pages to map all of its memory, while its four vCPU caches get
> > > > >>>> filled with 160.
> > > > >>>>
> > > > >>>> On a production host with 64 KiB pages running 101 VMs with four vCPUs
> > > > >>>> each, the caches were still 86% full. The memory used:
> > > > >>>>
> > > > >>>>                         before      after
> > > > >>>>   per-vCPU capacity     2.5 MB     512 KB
> > > > >>>>   all 404 vCPUs         869 MB     <= 202 MB
> > > > >>>>
> > > > >>>> Let's lower the capacity to 8 with 64 KiB pages, In the production
> > > > >>>> usecase above, it frees at least 667 MB. That still covers the two-page
> > > > >>>> minimum and leaves room for several table allocations per refill. 4 KB
> > > > >>>> and 16 KB pages keep 40.
> > > > >>>>
> > > > >>>> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
> > > > >>>> but it is topped up before every page it maps, so 8 is sufficient there
> > > > >>>> as well. The pKVM hypervisor memcache and the eager split cache don't
> > > > >>>> use this capacity.
> > > > >>>>
> > > > >>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > > > >>>> ---
> > > > >>>>  arch/arm64/include/asm/kvm_types.h | 5 +++++
> > > > >>>>  1 file changed, 5 insertions(+)
> > > > >>>>
> > > > >>>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > > > >>>> index 9a126b9e2d7c99..28568da9ea4a7b 100644
> > > > >>>> --- a/arch/arm64/include/asm/kvm_types.h
> > > > >>>> +++ b/arch/arm64/include/asm/kvm_types.h
> > > > >>>> @@ -2,7 +2,12 @@
> > > > >>>>  #ifndef _ASM_ARM64_KVM_TYPES_H
> > > > >>>>  #define _ASM_ARM64_KVM_TYPES_H
> > > > >>>>  
> > > > >>>> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
> > > > >>>> +#ifdef CONFIG_ARM64_64K_PAGES
> > > > >>>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
> > > > >>>> +#else
> > > > >>>>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > > > >>>> +#endif
> > > > >>>>  
> > > > >>>>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> > > > >>>>  
> > > > >>>> -- 
> > > > >>>> 2.53.1-Meta
> > > > >>>>
> > > > >>>
> > > > >>> Hi Usama,
> > > > >>>
> > > > >>
> > > > >> Hello Leonardo,
> > > > >>
> > > > >>> Have you tried to reproduce this issue in v7.4-rc1 or newer?
> > > > >>
> > > > >> Yes. The patch is against kvmarm/next (v7.4-rc3), which includes
> > > > >> Lorenzo's pre-fault series, and I A/B tested it there.
> > > > >>
> > > > >> On unpatched v7.4-rc3 with 64 KiB pages, a VM whose 16 vCPUs each fault
> > > > >> in one page needs a single stage-2 table page, yet the vCPU caches hold
> > > > >> 640 pages (40 MiB). With the patch they hold 127 pages.
> > > > >>
> > > > >>>
> > > > >>> IIUC Lorenzo Stoakes introduced a change that would cause the memcache to 
> > > > >>> skip topup if the cache contains a minimum of ~4 pages, so it can possibly 
> > > > >>> improve that issue.
> > > > >>
> > > > >> I don't think that part is new. __kvm_mmu_topup_memory_cache() has
> > > > >> returned early when mc->nobjs >= min since commit 6926f95accee ("KVM:
> > > > >> Move x86's MMU memory cache helpers to common KVM code"). Lorenzo's
> > > > >> commit d27acc152c62 ("KVM: arm64: Size the stage-2 memcache from the
> > > > >> fault MMU") takes min from s2fd->mmu instead of vcpu->arch.hw_mmu. For a
> > > > >> guest abort that is the same MMU, so nothing changes here.
> > > > >>
> > > > >> With 64 KiB pages, min is kvm_mmu_cache_min_pages(), which is at most 2.
> > > > >>
> > > > >>>
> > > > >>> Although I can see that when it's below that minimum it fills the whole 
> > > > >>> capacity (40) of the cache.
> > > > >>>
> > > > >>
> > > > >> Right, and that is the problem. Skipping the top-up avoids refilling
> > > > >> the cache, but nothing ever drains it. A vCPU's first fault fills its
> > > > >> cache to 40. Each last-level table covers 512 MiB, so a guest needs very
> > > > >> few table pages, and most vCPUs never drop below min. The remaining
> > > > >> pages stay allocated until the vCPU is destroyed, which is why the
> > > > >> production caches were still 86% full.
> > > > >>
> > > > >> The patch keeps the early return and only lowers how far a refill goes.
> > > > > 
> > > > > Right,
> > > > > 
> > > > > I took a look in the cache workings, and it does not seem to receive freed 
> > > > > pages back in. It gets filled by topup and used by map, so IIUC it is used 
> > > > > only to avoid failing an allocation during the mapping walk.
> > > > > 
> > > > > Maybe it could be the case to simplify this cache to have the capacity 
> > > > > about the same as the minimum (since it always topup before mapping) and 
> > > > > avoid the waste altogether.
> > > 
> > > Well the more you reserve the less frequent you'd need to actually allocate at
> > > topup, which saves time, so there's this trade-off to consider.
> > > 
> > > Thanks,
> > > Wei-Lin Chang
> > > 
> > 
> > Hi Wei-Lin,
> > 
> > IIUC, every time we topup, we call a mmu_memory_cache_alloc_obj() for every 
> > one of the objects in the array. So as it is today it runs it 40 times, and 
> 
> Not necessarily, I meant with 40,
> 
> if (mc->nobjs >= min)
> 	return 0;
> 
> happens way more often.

That's what I meant with 'waits until it runs down'. Basically we have

if (mc->nobjs >= min)
	return 0;

while (mc->nobjs < mc->capacity) {
	obj = mmu_memory_cache_alloc_obj(mc, gfp);
	...

So, first use it allocates mc->capacity entries, and every further topup
will return early unless it goes below min, when it populates again. The 
only reason for a larger cache being more performant would be to use 
that cache locality, which could indeed have a large impact, if we use this 
cache a lot.

Thanks!
Leo
