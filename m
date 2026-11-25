Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795631132;
	b=qbOrhJOGw549FNATVV+xcBq0gALx6RsOdE+lycKTtGyhmjRwuPFh/qCJDqoloN8VU6xq
	 FwgR80g3ELtiu7dYv//hL3clX4PXUXpA4f15wtz2MPyP0mgxqvPumujoBLGFCKO6M8Vdm
	 Tb+j7ktD3W3pRfPA6B+ZUc1nSPXVu9yfqtp7rUlZpvvtUQ1WR/2hj5ArLyzLj0gPW3K3/
	 QIci4MYMFh0t/lbcrdQbW1qS5KPSThPy7kkX6FTfqVkoxq1fznSQN7EAJXHz2UsdY2iml
	 spXEOootrU+hf67dCcyjDq2IkIHx32l5i1rrLCKTANwhYEYIYRPZDh9AhtHnPz4H+KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795631132;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=CffRpKjZWBIdmV8KBtWcyKWTbdLZZPBEyXOHv2Hi+wI=;
	b=qXvjxGvCUyuuR4wNnIBsUgoFQ9hexm2p2v05vJF+0xt4csAneZV/LRAVvgfrsAyPb2V1
	 71Z7o84Q6eG4A3Qboaast8eUIVpNzVLUji0HBKjKqRaM5BqMhfMUUbta7hnqnJxi7/Dh4
	 FjBcFW/1HVh7459MKIMnlFb6LeNOLOQZlr/CUXX6VpG7vWL9WuuJddAuHU/FfDayEqYfK
	 pCKC9vVLSOwOJ6wuduCEz64nDmjfjTvDfubNwX1QDwr1kQ4RGM4VSdGK+5yy6SWMbZnxO
	 ioy0B3hi8DILWW2neBrEl/meeqXadLTjinNZZTIUsz/IRdtWxnbFMZMbK/RvXIPtGpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EivW0L61;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7AA9606A326
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 18:25:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7AA9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EivW0L61
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2453B339;
	Wed, 25 Nov 2026 10:25:26 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4DDB23F632;
	Wed, 25 Nov 2026 10:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795631129; bh=S3knkYPZy3TQVIujmwNlME+cfr9l2bAHL5wt5WJaEJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EivW0L61HkBPUbKSFXxmUB49FJ1LDQ0/F2c0mxN6sykMcNyTJYKSs9OtmR3HwHvT0
	 hx+U0N4UI7pKVA1Eur9PSl+lHxGmllUK7bbcsblWRQEVlLL5qO6WW342Q6CoDGTws7
	 fPqHCNMiUjxdbSNkZago6SiMRu7I/Cuk6sea1dmc=
From: Leonardo Bras <leo.bras@arm.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Leonardo Bras <leo.bras@arm.com>,
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
Date: Wed, 25 Nov 2026 18:25:15 +0000
Message-ID: <awcoCklLOKeuXPhh@LeoBrasDK>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
References: <20261124152842.2634495-1-usama.arif@linux.dev> <awcXhk885lqDRAHy@LeoBrasDK> <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
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

On Wed, Nov 25, 2026 at 05:55:29PM +0000, Usama Arif wrote:
> 
> 
> On 25/11/2026 09:14, Leonardo Bras wrote:
> > On Tue, Nov 24, 2026 at 07:28:42AM -0800, Usama Arif wrote:
> >> When a stage-2 fault may need new page tables, KVM first tops up the
> >> vCPU's page cache: if it holds fewer pages than the fault might need, it
> >> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> >> 40. Unused pages stay in the cache until the vCPU is destroyed.
> >>
> >> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
> >> used. Stage-2 has at most three levels and the root is preallocated, so
> >> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()).
> >> As every last-level table covers 512 MiB, an 8 GiB guest needs just 17
> >> table pages to map all of its memory, while its four vCPU caches get
> >> filled with 160.
> >>
> >> On a production host with 64 KiB pages running 101 VMs with four vCPUs
> >> each, the caches were still 86% full. The memory used:
> >>
> >>                         before      after
> >>   per-vCPU capacity     2.5 MB     512 KB
> >>   all 404 vCPUs         869 MB     <= 202 MB
> >>
> >> Let's lower the capacity to 8 with 64 KiB pages, In the production
> >> usecase above, it frees at least 667 MB. That still covers the two-page
> >> minimum and leaves room for several table allocations per refill. 4 KB
> >> and 16 KB pages keep 40.
> >>
> >> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
> >> but it is topped up before every page it maps, so 8 is sufficient there
> >> as well. The pKVM hypervisor memcache and the eager split cache don't
> >> use this capacity.
> >>
> >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >> ---
> >>  arch/arm64/include/asm/kvm_types.h | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> >> index 9a126b9e2d7c99..28568da9ea4a7b 100644
> >> --- a/arch/arm64/include/asm/kvm_types.h
> >> +++ b/arch/arm64/include/asm/kvm_types.h
> >> @@ -2,7 +2,12 @@
> >>  #ifndef _ASM_ARM64_KVM_TYPES_H
> >>  #define _ASM_ARM64_KVM_TYPES_H
> >>  
> >> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB pages. */
> >> +#ifdef CONFIG_ARM64_64K_PAGES
> >> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
> >> +#else
> >>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> >> +#endif
> >>  
> >>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> >>  
> >> -- 
> >> 2.53.1-Meta
> >>
> > 
> > Hi Usama,
> > 
> 
> Hello Leonardo,
> 
> > Have you tried to reproduce this issue in v7.4-rc1 or newer?
> 
> Yes. The patch is against kvmarm/next (v7.4-rc3), which includes
> Lorenzo's pre-fault series, and I A/B tested it there.
> 
> On unpatched v7.4-rc3 with 64 KiB pages, a VM whose 16 vCPUs each fault
> in one page needs a single stage-2 table page, yet the vCPU caches hold
> 640 pages (40 MiB). With the patch they hold 127 pages.
> 
> > 
> > IIUC Lorenzo Stoakes introduced a change that would cause the memcache to 
> > skip topup if the cache contains a minimum of ~4 pages, so it can possibly 
> > improve that issue.
> 
> I don't think that part is new. __kvm_mmu_topup_memory_cache() has
> returned early when mc->nobjs >= min since commit 6926f95accee ("KVM:
> Move x86's MMU memory cache helpers to common KVM code"). Lorenzo's
> commit d27acc152c62 ("KVM: arm64: Size the stage-2 memcache from the
> fault MMU") takes min from s2fd->mmu instead of vcpu->arch.hw_mmu. For a
> guest abort that is the same MMU, so nothing changes here.
> 
> With 64 KiB pages, min is kvm_mmu_cache_min_pages(), which is at most 2.
> 
> > 
> > Although I can see that when it's below that minimum it fills the whole 
> > capacity (40) of the cache.
> > 
> 
> Right, and that is the problem. Skipping the top-up avoids refilling
> the cache, but nothing ever drains it. A vCPU's first fault fills its
> cache to 40. Each last-level table covers 512 MiB, so a guest needs very
> few table pages, and most vCPUs never drop below min. The remaining
> pages stay allocated until the vCPU is destroyed, which is why the
> production caches were still 86% full.
> 
> The patch keeps the early return and only lowers how far a refill goes.

Right,

I took a look in the cache workings, and it does not seem to receive freed 
pages back in. It gets filled by topup and used by map, so IIUC it is used 
only to avoid failing an allocation during the mapping walk.

Maybe it could be the case to simplify this cache to have the capacity 
about the same as the minimum (since it always topup before mapping) and 
avoid the waste altogether.

Maymbe having something like this should be enough?
 
#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE (KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL)

Thanks!
Leo
