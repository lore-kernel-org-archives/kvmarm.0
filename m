Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793E2380FDD
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 16:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782925004; cv=none; b=CVia3BG3cZRnDiSIuTRtvdBE3MghmAaAOqzM5TRd+moxXoTmMW4H/tknlUqP1xWIMNGF/ELKiwRjicaMiIqPrIDavN9YdecP16kaDJCUztAP0pFs8Xo0HwRS+S70+qjPD8N/OWryJU+TuCrswvOYi3UwtMKh+TJImxhGTV7wRbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782925004; c=relaxed/simple;
	bh=inKJs5VrSJWXmzPFuimreLE5b+JqjaqHPCr/Op1K2IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=RsJ7VvtMBzukRZ4nZfzCc3L63ukrJMA2gOT9cTrrn5kVrWaEb7Xmvuf6e7dqyLkwqSJY8Qf+tUxshXLxZ9azBiZHI5Z7d7aKY+cfp86p9IBA3X4D9wT9x+RVkesc0Td6COH+Vl9zEyHf43RIoRhoQ2G2e7iKJjCD0v1ZM/LNf88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FHBzk19Q; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FHBzk19Q"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83B7E169C;
	Wed,  1 Jul 2026 09:56:37 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62AAF3F673;
	Wed,  1 Jul 2026 09:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782925001; bh=inKJs5VrSJWXmzPFuimreLE5b+JqjaqHPCr/Op1K2IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHBzk19QjtC1loMK8YakU/7+36IERtdX35e15JQ+WwwZ8NjLOW5gxFEZ5HYLeI66z
	 P/nMynqudZ4ela+9Ij8mMk0p4atEgMT0FXN++Z2yTegiHi+BZ8EZHizflRXgtbzQcr
	 gNdzdnmLp46ROJLhAgi6+WPkQSjLrcxaTR/5pjCo=
From: Leonardo Bras <leo.bras@arm.com>
To: Bradley Morgan <include@grrlz.net>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: arm64: skip pKVM cache flushes for non cacheable mappings
Date: Wed,  1 Jul 2026 17:56:37 +0100
Message-ID: <akVGxdakrVYp8kho@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <EB48DA64-1E2E-4D8C-8F8A-ED6257AD93E9@grrlz.net>
References: <20260624160028.15591-1-include@grrlz.net> <20260624160028.15591-2-include@grrlz.net> <akU64YK5dqcWGdCD@LeoBrasDK> <5105C9D2-C708-452E-BA61-F22083A33C74@grrlz.net> <akVGDoI9FltrVduP@LeoBrasDK> <EB48DA64-1E2E-4D8C-8F8A-ED6257AD93E9@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 01, 2026 at 05:54:40PM +0100, Bradley Morgan wrote:
> On July 1, 2026 5:53:34 PM GMT+01:00, Leonardo Bras <leo.bras@arm.com>
> wrote:
> >On Wed, Jul 01, 2026 at 05:40:46PM +0100, Bradley Morgan wrote:
> >> On July 1, 2026 5:05:53 PM GMT+01:00, Leonardo Bras <leo.bras@arm.com>
> >> wrote:
> >> >On Wed, Jun 24, 2026 at 04:00:26PM +0000, Bradley Morgan wrote:
> >> >> pKVM keeps its own mapping list for stage 2 operations. Its flush
> >path
> >> >> uses that list directly, so it lost the PTE attribute check done by
> >the
> >> >> generic stage 2 walker.
> >> >> 
> >> >> Record whether a mapping is cacheable and skip cache maintenance for
> >> >> mappings that are not cacheable.
> >> >> 
> >> >> Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
> >> >> Signed-off-by: Bradley Morgan <include@grrlz.net>
> >> >> ---
> >> >>  arch/arm64/kvm/pkvm.c | 51
> >++++++++++++++++++++++++++++++++++---------
> >> >>  1 file changed, 41 insertions(+), 10 deletions(-)
> >> >> 
> >> >> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> >> >> index 428723b1b0f5..ca6e823028c2 100644
> >> >> --- a/arch/arm64/kvm/pkvm.c
> >> >> +++ b/arch/arm64/kvm/pkvm.c
> >> >> @@ -302,9 +302,32 @@ static u64 __pkvm_mapping_start(struct
> >pkvm_mapping
> >> >*m)
> >> >>  	return m->gfn * PAGE_SIZE;
> >> >>  }
> >> >>  
> >> >> +#define PKVM_MAPPING_NR_PAGES_MASK	GENMASK_ULL(47, 0)
> >> >> +#define PKVM_MAPPING_CACHEABLE		BIT_ULL(48)
> >> >
> >> >Out of curiosity here, why do you choose to use bit 48 here instead of,
> >> >let's say, bit 63?
> >> >
> >> >(I know it makes absolutely no difference to inner working here, as
> >there 
> >> >should probably not be 2^48 pages in one mapping.)
> >> >
> >> >Thanks!
> >> >Leo
> >> 
> >> 
> >> sup Leo, here's a quote from maz 
> >
> >Hi Bradley,
> >
> >> 
> >> "This thing is already big enough, let's not add a bool right in the
> >> middle (use pahole to find out why this is bad).
> >
> >I suppose you proposed to add a bool into a struct, maybe?
> >It would screw the struct alignment.
> 
> yep, crappy old me
> 

Hah, you were probably focused on the big picture.

> 
> >> Given that nr_pages
> >> is for a range, and that the minimum page size uses 12 bits, the
> >> largest number of pages you can have here is 56-12=48 bit wide. That's
> >> another 16 bits worth of flags you can use."
> >
> >Humm, makes sense.
> >And since he mentions 16 bits worth of flags, you start by using the 48th 
> >bit. Ok, got your rationale.
> >
> >(I would possibly start with the 63, though, but that's more on personal 
> >taste)
> 
> 48 won't make the world blow up :)

yeap,

> 
> >> 
> >> this should just clarify things, any questions, feel more than free to
> >ask!
> >> 
> >> (btw V4 is coming soon)
> >
> >Thanks!
> >Leo
> >
> >> 
> >> >> +
> >> >> +static u64 pkvm_mapping_nr_pages(struct pkvm_mapping *m)
> >> >> +{
> >> >> +	return m->nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
> >> >> +}
> >> >> +
> >> >> +static bool pkvm_mapping_is_cacheable(struct pkvm_mapping *m)
> >> >> +{
> >> >> +	return m->nr_pages & PKVM_MAPPING_CACHEABLE;
> >> >> +}
> >> >> +
> >> >> +static void pkvm_mapping_set_nr_pages(struct pkvm_mapping *m, u64
> >> >nr_pages,
> >> >> +				      bool cacheable)
> >> >> +{
> >> >> +	WARN_ON_ONCE(nr_pages & ~PKVM_MAPPING_NR_PAGES_MASK);
> >> >> +
> >> >> +	m->nr_pages = nr_pages & PKVM_MAPPING_NR_PAGES_MASK;
> >> >> +	if (cacheable)
> >> >> +		m->nr_pages |= PKVM_MAPPING_CACHEABLE;
> >> >> +}
> >> >> +
> >> >>  static u64 __pkvm_mapping_end(struct pkvm_mapping *m)
> >> >>  {
> >> >> -	return (m->gfn + m->nr_pages) * PAGE_SIZE - 1;
> >> >> +	return (m->gfn + pkvm_mapping_nr_pages(m)) * PAGE_SIZE - 1;
> >> >>  }
> >> >>  
> >> >>  INTERVAL_TREE_DEFINE(struct pkvm_mapping, node, u64, __subtree_last,
> >> >> @@ -350,7 +373,7 @@ static int __pkvm_pgtable_stage2_reclaim(struct
> >> >kvm_pgtable *pgt, u64 start, u64
> >> >>  			continue;
> >> >>  
> >> >>  		page = pfn_to_page(mapping->pfn);
> >> >> -		WARN_ON_ONCE(mapping->nr_pages != 1);
> >> >> +		WARN_ON_ONCE(pkvm_mapping_nr_pages(mapping) != 1);
> >> >>  		unpin_user_pages_dirty_lock(&page, 1, true);
> >> >>  		account_locked_vm(kvm->mm, 1, false);
> >> >>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> >> >> @@ -369,7 +392,7 @@ static int __pkvm_pgtable_stage2_unshare(struct
> >> >kvm_pgtable *pgt, u64 start, u64
> >> >>  
> >> >>  	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
> >> >>  		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
> >> >> -					mapping->nr_pages);
> >> >> +					pkvm_mapping_nr_pages(mapping));
> >> >>  		if (WARN_ON(ret))
> >> >>  			return ret;
> >> >>  		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
> >> >> @@ -448,7 +471,7 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable
> >*pgt,
> >> >u64 addr, u64 size,
> >> >>  		 * permission faults are handled in the relax_perms() path.
> >> >>  		 */
> >> >>  		if (mapping) {
> >> >> -			if (size == (mapping->nr_pages * PAGE_SIZE))
> >> >> +			if (size == (pkvm_mapping_nr_pages(mapping) * PAGE_SIZE))
> >> >>  				return -EAGAIN;
> >> >>  
> >> >>  			/*
> >> >> @@ -472,7 +495,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable
> >*pgt,
> >> >u64 addr, u64 size,
> >> >>  	swap(mapping, cache->mapping);
> >> >>  	mapping->gfn = gfn;
> >> >>  	mapping->pfn = pfn;
> >> >> -	mapping->nr_pages = size / PAGE_SIZE;
> >> >> +	pkvm_mapping_set_nr_pages(mapping, size / PAGE_SIZE,
> >> >> +				  !(prot & (KVM_PGTABLE_PROT_DEVICE |
> >> >> +					    KVM_PGTABLE_PROT_NORMAL_NC)));
> >> >>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
> >> >>  
> >> >>  	return ret;
> >> >> @@ -503,7 +528,7 @@ int pkvm_pgtable_stage2_wrprotect(struct
> >kvm_pgtable
> >> >*pgt, u64 addr, u64 size)
> >> >>  	lockdep_assert_held(&kvm->mmu_lock);
> >> >>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> >> >>  		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
> >> >> -					mapping->nr_pages);
> >> >> +					pkvm_mapping_nr_pages(mapping));
> >> >>  		if (WARN_ON(ret))
> >> >>  			break;
> >> >>  	}
> >> >> @@ -517,9 +542,13 @@ int pkvm_pgtable_stage2_flush(struct kvm_pgtable
> >> >*pgt, u64 addr, u64 size)
> >> >>  	struct pkvm_mapping *mapping;
> >> >>  
> >> >>  	lockdep_assert_held(&kvm->mmu_lock);
> >> >> -	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> >> >> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> >> >> +		if (!pkvm_mapping_is_cacheable(mapping))
> >> >> +			continue;
> >> >> +
> >> >>  		__clean_dcache_guest_page(pfn_to_kaddr(mapping->pfn),
> >> >> -					  PAGE_SIZE * mapping->nr_pages);
> >> >> +					  PAGE_SIZE * pkvm_mapping_nr_pages(mapping));
> >> >> +	}
> >> >>  
> >> >>  	return 0;
> >> >>  }
> >> >> @@ -536,8 +565,10 @@ bool pkvm_pgtable_stage2_test_clear_young(struct
> >> >kvm_pgtable *pgt, u64 addr, u64
> >> >>  
> >> >>  	lockdep_assert_held(&kvm->mmu_lock);
> >> >>  	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
> >> >> -		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
> >> >> -					   mapping->nr_pages, mkold);
> >> >> +		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest,
> >> >> +					   handle, mapping->gfn,
> >> >> +					   pkvm_mapping_nr_pages(mapping),
> >> >> +					   mkold);
> >> >>  
> >> >>  	return young;
> >> >>  }
> >> >> -- 
> >> >> 2.53.0
> >> >> 
> >> >
> >> 
> >> Thanks!
> >
> 
> Thanks!

Thanks!
