Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795707277;
	b=OOieuZpNz/4q9zU1FB4Ib6HKH25nuWx+t5+NLpsqfCGPjbgylu3BTxGInVCh1GO+Y1PO
	 JELU8/tjvhZSRz6hdZPtWVs53tVXNtq4pFdszfhGstR2k5R4cC0AX5cTLvSDc9Sg3c3GN
	 oszUvG98gJ2QPlnqW1WvrM3FP8gy8RNyvc/jLzqT2z9IdoCgS5QlzcDAN+U5Zyfxm3m2T
	 6oeyhYKBBFzIqslEwt+WxKP9vj8TnqhpJwZdP0wCTXzQMUf8zQsfWe0LNkpCGu14iuCkt
	 pzyIdn98nlvwONjwAB4AvAA8ntEUmroBUr+akcBTDFnVf1TebMdh5MXpNCWOJ36wD3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795707277;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=a9FtnrpxaIAKefnbYYtSZG/5XURLP2+2TW4SlFBwbQw=;
	b=szrnZT6dqUgiiZemxyZLTWuzcNAz6J13pkIaW+6J8Acl8pCFtfa24xKAqwc7BO3Khkhf
	 khxZ0YcYAsAZUiyLvwm0/tHNdhEpvQyEz3Lm2ZkFEKv3z2D6Mpl4KD8tlRceW0MmNRSqr
	 slt1HcKvy0w163se2N4LAL+yGdYN5KBficybdFiZyYTKAKQ7ChNIcPSnbQBNPGpPlEOd8
	 UI/xjAMVyE6onbdnHlYmZcSQpoktVG4f4znURpGwyHD2DG6BEKUJc/9IW1a9d6Cm4VZ8L
	 WfN8yEDaCS2BXsL2PK+RINmsPZ0RRZKNBX98JfKDA3n32geJVrvAuB7Qr496pbaM9uA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=uo8qy9tt;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A736606A31E
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 15:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A736606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=uo8qy9tt
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC2481BA8;
	Thu, 26 Nov 2026 07:34:31 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 777C93F632;
	Thu, 26 Nov 2026 07:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795707274; bh=COJsSm9NqCcxDFb9aLudm4GL9sjUzsTZPKkS4GralMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uo8qy9ttqyfmseiEQZrw1bJLsSxmeADlJQKxYP5v31RAV3gztbVxStVzC63OwPQDd
	 whtUFGngeo8ICHlzjGOD/MrNOSZqveBp3uxYYOL+MX0jnroFMvM1ZnVC1QQVSVomtO
	 W768DmlpA/KtmkvEokdsl1C4MBPM0Mc2PW7tCTCQ=
Date: Thu, 26 Nov 2026 15:34:19 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Leonardo Bras <leo.bras@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, riel@surriel.com, 
	shakeel.butt@linux.dev, kernel-team@meta.com, rkeilty@meta.com, atish.patra@linux.dev, 
	dgreid@meta.com
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
Message-ID: <klnyvfxwhpw73wo55y5aq3qliglnf7xkfkmfj6cgzje7z3n2fq@aqjxshyjnldu>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK>
 <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK>
 <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
 <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
 <awhODYKXnsBi_s_B@LeoBrasDK>
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
In-Reply-To: <awhODYKXnsBi_s_B@LeoBrasDK>

On Thu, Nov 26, 2026 at 03:19:41PM +0000, Leonardo Bras wrote:
> On Thu, Nov 26, 2026 at 08:06:41AM +0000, Wei-Lin Chang wrote:
> > On Wed, Nov 25, 2026 at 09:42:33PM +0000, Usama Arif wrote:
> > > 
> > > 
> > > On 25/11/2026 10:25, Leonardo Bras wrote:
> > > > On Wed, Nov 25, 2026 at 05:55:29PM +0000, Usama Arif wrote:
> > > >>
> > > >>
> > > >> On 25/11/2026 09:14, Leonardo Bras wrote:
> > > >>> On Tue, Nov 24, 2026 at 07:28:42AM -0800, Usama Arif wrote:
> > > >>>> When a stage-2 fault may need new page tables, KVM first tops up the
> > > >>>> vCPU's page cache: if it holds fewer pages than the fault might need, it
> > > >>>> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> > > >>>> 40. Unused pages stay in the cache until the vCPU is destroyed.
> > > >>>>
> > > >>>> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
> > > >>>> used. Stage-2 has at most three levels and the root is preallocated, so
> > > >>>> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
> > > >>>> As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
> > > >>>> table pages to map all of its memory, while its four vCPU caches get
> > > >>>> filled with 160.
> > > >>>>
> > > >>>> On a production host with 64 KiB pages running 101 VMs with four vCPUs
> > > >>>> each, the caches were still 86% full. The memory used:
> > > >>>>
> > > >>>>                         before      after
> > > >>>>   per-vCPU capacity     2.5 MB     512 KB
> > > >>>>   all 404 vCPUs         869 MB     <= 202 MB
> > > >>>>
> > > >>>> Let's lower the capacity to 8 with 64 KiB pages, In the production
> > > >>>> usecase above, it frees at least 667 MB. That still covers the two-page
> > > >>>> minimum and leaves room for several table allocations per refill. 4 KB
> > > >>>> and 16 KB pages keep 40.
> > > >>>>
> > > >>>> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
> > > >>>> but it is topped up before every page it maps, so 8 is sufficient there
> > > >>>> as well. The pKVM hypervisor memcache and the eager split cache don't
> > > >>>> use this capacity.
> > > >>>>
> > > >>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > > >>>> ---
> > > >>>>  arch/arm64/include/asm/kvm_types.h | 5 +++++
> > > >>>>  1 file changed, 5 insertions(+)
> > > >>>>
> > > >>>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > > >>>> index 9a126b9e2d7c99..28568da9ea4a7b 100644
> > > >>>> --- a/arch/arm64/include/asm/kvm_types.h
> > > >>>> +++ b/arch/arm64/include/asm/kvm_types.h
> > > >>>> @@ -2,7 +2,12 @@
> > > >>>>  #ifndef _ASM_ARM64_KVM_TYPES_H
> > > >>>>  #define _ASM_ARM64_KVM_TYPES_H
> > > >>>>  
> > > >>>> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
> > > >>>> +#ifdef CONFIG_ARM64_64K_PAGES
> > > >>>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
> > > >>>> +#else
> > > >>>>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > > >>>> +#endif
> > > >>>>  
> > > >>>>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> > > >>>>  
> > > >>>> -- 
> > > >>>> 2.53.1-Meta
> > > >>>>
> > > >>>
> > > >>> Hi Usama,
> > > >>>
> > > >>
> > > >> Hello Leonardo,
> > > >>
> > > >>> Have you tried to reproduce this issue in v7.4-rc1 or newer?
> > > >>
> > > >> Yes. The patch is against kvmarm/next (v7.4-rc3), which includes
> > > >> Lorenzo's pre-fault series, and I A/B tested it there.
> > > >>
> > > >> On unpatched v7.4-rc3 with 64 KiB pages, a VM whose 16 vCPUs each fault
> > > >> in one page needs a single stage-2 table page, yet the vCPU caches hold
> > > >> 640 pages (40 MiB). With the patch they hold 127 pages.
> > > >>
> > > >>>
> > > >>> IIUC Lorenzo Stoakes introduced a change that would cause the memcache to 
> > > >>> skip topup if the cache contains a minimum of ~4 pages, so it can possibly 
> > > >>> improve that issue.
> > > >>
> > > >> I don't think that part is new. __kvm_mmu_topup_memory_cache() has
> > > >> returned early when mc->nobjs >= min since commit 6926f95accee ("KVM:
> > > >> Move x86's MMU memory cache helpers to common KVM code"). Lorenzo's
> > > >> commit d27acc152c62 ("KVM: arm64: Size the stage-2 memcache from the
> > > >> fault MMU") takes min from s2fd->mmu instead of vcpu->arch.hw_mmu. For a
> > > >> guest abort that is the same MMU, so nothing changes here.
> > > >>
> > > >> With 64 KiB pages, min is kvm_mmu_cache_min_pages(), which is at most 2.
> > > >>
> > > >>>
> > > >>> Although I can see that when it's below that minimum it fills the whole 
> > > >>> capacity (40) of the cache.
> > > >>>
> > > >>
> > > >> Right, and that is the problem. Skipping the top-up avoids refilling
> > > >> the cache, but nothing ever drains it. A vCPU's first fault fills its
> > > >> cache to 40. Each last-level table covers 512 MiB, so a guest needs very
> > > >> few table pages, and most vCPUs never drop below min. The remaining
> > > >> pages stay allocated until the vCPU is destroyed, which is why the
> > > >> production caches were still 86% full.
> > > >>
> > > >> The patch keeps the early return and only lowers how far a refill goes.
> > > > 
> > > > Right,
> > > > 
> > > > I took a look in the cache workings, and it does not seem to receive freed 
> > > > pages back in. It gets filled by topup and used by map, so IIUC it is used 
> > > > only to avoid failing an allocation during the mapping walk.
> > > > 
> > > > Maybe it could be the case to simplify this cache to have the capacity 
> > > > about the same as the minimum (since it always topup before mapping) and 
> > > > avoid the waste altogether.
> > 
> > Well the more you reserve the less frequent you'd need to actually allocate at
> > topup, which saves time, so there's this trade-off to consider.
> > 
> > Thanks,
> > Wei-Lin Chang
> > 
> 
> Hi Wei-Lin,
> 
> IIUC, every time we topup, we call a mmu_memory_cache_alloc_obj() for every 
> one of the objects in the array. So as it is today it runs it 40 times, and 

Not necessarily, I meant with 40,

if (mc->nobjs >= min)
	return 0;

happens way more often.

> waits until it runs down to allocate up to 40 again.
> 
> With the change, it will run 4, then up to 4 how many times are needed.
> 
> So having a smaller cache can potentially save both cputime and memory if 
> the cache is not that oftenly used. That being said, allocating 40 in 
> sequence would be faster than 4 * 10 because the instruction / data cache 
> is hot.

I agree here.

Thanks,
Wei-Lin Chang

> 
> I think the only way to evaluate the performance impact is by running some 
> benchmarks.
> 

[...]
