Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252E340DB37;
	Mon,  3 Aug 2026 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785762853; cv=none; b=DVT3grr5iwmgx56ijMYN2DZT1D2YyQ5NUjAPIHi7QGIs5wl8Mn49rHMmXCkkpzWDMxf56LeOQBJN8RtVocW8MtyMRYPMw/AQg2qNeHzSyz82PnwxhT9gVIj6hPdu4rQt7cdFmrCzry8inEeKSrhEjNzkJkhbsrsI57KrfXp6fLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785762853; c=relaxed/simple;
	bh=wbJugdrkkqPiqfydhiI0PX1m4h32ed2mGP/FAOZPy+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=tvdCFPjVPxEm3q7JTDtCpYJl8hBxlnIh0UXBf8hT+Qm3YRtSJlRNCLG5l9t1Tjv82oh2W0dMNiIj+wdzY5/6NjA9qFR/5S8xGjIYvxWxkFzFljI3RQboGDMRSB/G46j2I3BBMQb1bVhqDRmNt1AGxILwYO93N/YK9teih3UoQFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SACgf6wL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SACgf6wL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57D8A143D;
	Mon,  3 Aug 2026 06:13:57 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67C0A3F66F;
	Mon,  3 Aug 2026 06:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785762841; bh=wbJugdrkkqPiqfydhiI0PX1m4h32ed2mGP/FAOZPy+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SACgf6wLE/+pYkMxKbE3zND4EXSOGuvgw7/dAyYc0CcfUYKrHhVEc2b/KYWrx5Q4P
	 IhaRWhyRXtxn5Ryt6Vr35r78WXzqUSsu/Alc+b35jb7V6rvc2jm1oFU1p1WyjGrTZq
	 CU0ZKjC1KsEyoFy/S1keGyCoPIXj9YaMW8KtU7ak=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 01/11] KVM: arm64: HDBSS bits
Date: Mon,  3 Aug 2026 14:13:52 +0100
Message-ID: <anCUEAKj-AUHWoo3@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729105541.3FECC1F00A3A@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-2-leo.bras@arm.com> <20260729105541.3FECC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 10:55:40AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] The patch is explicitly marked by the author as a test hack that should not be merged upstream.
> - [High] Hardware Dirty Bit Management (DBM) is not cleared when write-protecting pages, allowing guests to bypass software write-protection (such as userfaultfd-wp or software dirty logging).
> - [Medium] Left shifting a negative signed integer is undefined behavior in C.
> - [Medium] The hardcoded split_page_chunk_size is excessively large, causing massive memory allocations under the mmu_lock.
> - [Low] HDBSS entry macros are defined in a `.c` file instead of a header file, making them inaccessible to other subsystems.
> - [Low] Typo in the parameter name of `has_vhe_hdbss`.
> --
> 
> --- Patch [1]: [PATCH v3 01/11] KVM: arm64: HDBSS bits ---
> commit 125f04d66539bf05e0255567036409a407e48004
> Author: Leonardo Bras <leo.bras@arm.com>
> Subject: KVM: arm64: HDBSS bits
> 
> A brief summary:
> This commit introduces preliminary support for the Hardware Dirty state
> tracking structure (HDBSS) feature on ARM64. It adds CPU feature detection,
> sets the DBM stage-2 page table flag when write protection is relaxed, and
> configures eager page splitting chunk sizes for testing purposes.
> 
> > I added them here in order to fulfill the dependencies and be able to
> > easily build and test this patchset, but this particular patch should *not*
> > be merged upstream.
> 
> [Severity: High]
> Since this is explicitly marked as a test hack meant only for local building
> and testing, should this patch be dropped from the series before it gets
> merged upstream?
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> > @@ -2131,6 +2131,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> >  	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
> >  }
> >  
> > +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
>                                                                              ^^^^
> [Severity: Low]
> Is this intended to be named scope? The standard convention for capability
> matching functions in cpufeature.c uses scope for this parameter.
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > new file mode 100644
> > --- /dev/null
> > +++ b/arch/arm64/kvm/dirty_bit.c
> > @@ -0,0 +1,16 @@
> [ ... ]
> > +#include <asm/kvm_dirty_bit.h>
> > +
> > +/* HDBSS entry field definitions */
> > +#define HDBSS_ENTRY_VALID BIT(0)
> > +#define HDBSS_ENTRY_TTWL_SHIFT (1)
> > +#define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
> > +#define HDBSS_ENTRY_TTWL(x) \
> > +	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> > +#define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
> 
> [Severity: Low]
> Because these HDBSS entry macros are defined directly in the .c file rather
> than in the newly created header arch/arm64/include/asm/kvm_dirty_bit.h, they
> are inaccessible to other subsystems. Should they be moved to the header file
> so dependent patches can use them?
> 
> [Severity: Medium]
> Will HDBSS_ENTRY_TTWL_RESV trigger undefined behavior here? The macro expands
> to ((-4) << 1), and left shifting a negative signed integer is undefined
> behavior in C (prior to C23), which can lead to shift-out-of-bounds splats
> at runtime.
> 
> > +#define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1367,9 +1371,13 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
> >  	if (prot & KVM_PGTABLE_PROT_R)
> >  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> >  
> > -	if (prot & KVM_PGTABLE_PROT_W)
> > +	if (prot & KVM_PGTABLE_PROT_W) {
> >  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> >  
> > +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> > +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > +	}
> > +
> 
> [Severity: High]
> Does kvm_pgtable_stage2_wrprotect() also need to be updated to clear the DBM
> bit? 
> 
> Currently, kvm_pgtable_stage2_wrprotect() clears the 
> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W bit to trap writes, but if 
> KVM_PTE_LEAF_ATTR_HI_S2_DBM is left set, the hardware will autonomously update 
> the PTE to allow writes without generating a permission fault. Could this 
> allow guests to bypass software write-protection mechanisms like 
> userfaultfd-wp or KVM software dirty page logging?
> 
> >  	if (prot & KVM_PGTABLE_PROT_X) {
> >  		ret = stage2_set_xn_attr(prot, &xn);
> >  		if (ret)
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
> >  	for_each_possible_cpu(cpu)
> >  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
> >  
> > -	 /* The eager page splitting is disabled by default */
> > -	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > +	 /* The eager page splitting is disabled by default if system has no HDBSS */
> > +	if (system_supports_hdbss())
> > +		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
> 
> [Severity: Medium]
> Is this hardcoded split_page_chunk_size excessively large? This evaluates to
> 1GB on 4KB page systems and 16GB on 64KB page systems. When splitting this
> chunk, kvm_mmu_topup_memory_cache might attempt to allocate a massive amount
> of page tables under the mmu_lock. Could this cause severe latency spikes or
> allocation failures under memory pressure?
> 
> > +	else
> > +		mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> > +
> >  	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
> >  
> >  	mmu->pgd_phys = __pa(pgt->pgd);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260729104548.3439958-1-leo.bras@arm.com?part=1

As previously mentioned, this first patch is just for placing basic 
infrastructure for testing the speedup caused by HACDBS. Of course there 
are a lot of incomplete stuff around, because this does not replace the 
actual patchset.

Thanks
Leo
