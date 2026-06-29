Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07367403AF0
	for <kvmarm@lists.linux.dev>; Mon, 29 Jun 2026 12:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782737875; cv=none; b=Oj0uNIeI3jKMRUCZSHNy1/ySG7O99VKSl/ZGrEyxvnaNrqrMlgoI7PI9lDCk9YBvKUHzgHuXRYbUHpzNQdpLLGltnMRwz+r/uny/X1hhhBKGpJx0kowNRmizKojT5PXFTUPkTFYo6pRtCWS4JQBZEipNpVXKoe9l0Pc5dt7rLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782737875; c=relaxed/simple;
	bh=k+Vi/mZPK5IYdZqmsog4sgr1/S4FaklSXKezSkCwaHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=JkL2fJDU9XRIP/jDGBooj0SWn55mXYwi47//lb/ipJC7oiSnzfsogyWHRuqHGRK0Mc+vuQvc381JQbqDgF/aQgLuHOzn7FKfgMnPUAQclwMVtcuZDUrv30e5+PNHrRq+69ybBubDbY6NeVyIqyZNtftoXUFM8QwGgUZz3YJAeqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vtk/+sw/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vtk/+sw/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2F9F1758;
	Mon, 29 Jun 2026 05:57:47 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84C6C3F905;
	Mon, 29 Jun 2026 05:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782737872; bh=k+Vi/mZPK5IYdZqmsog4sgr1/S4FaklSXKezSkCwaHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vtk/+sw/e6D7LdP1SknlHoHekEB8ljOqJ9TvT7A7VtHy+K5LO41Td//clWk7SOAEm
	 1K7m1dvD4aicA0XZTgTARsxiKs+itS+ndngLMukzF98rE3rEz2WuL2tvX19W4kJdCD
	 4+m+eF0okMGAlmuiRQeMOrM2L6JvRmiyXQ+bzJgw=
From: Leonardo Bras <leo.bras@arm.com>
To: kvmarm@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 01/13] KVM: arm64: HDBSS bits
Date: Mon, 29 Jun 2026 13:57:45 +0100
Message-ID: <akJryexouA8QrCt_@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629113457.0D7B61F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-2-leo.bras@arm.com> <20260629113457.0D7B61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:34:56AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] Mapping writeable pages with both DBM and S2AP_W set causes `kvm_pgtable_stage2_wrprotect` to silently bypass software write-protection.
> - [High] `has_vhe_hdbss` incorrectly uses `is_kernel_in_hyp_mode()` which evaluates to true during early boot for pKVM (nVHE), erroneously enabling VHE-specific features.
> - [Low] Typo in the parameter name for `has_vhe_hdbss`.
> --
> 
> commit 49089779295fae526ba79b7c7e78d31fbe6a9636
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: HDBSS bits
> 
> The commit introduces HDBSS bits from a future patchset to fulfill
> dependencies and allow building.
> 
> > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > index 9a22df0c5120f..aa327eebaf1ca 100644
> > --- a/arch/arm64/kernel/cpufeature.c
> > +++ b/arch/arm64/kernel/cpufeature.c
> 
> [ ... ]
> 
> > @@ -2131,6 +2131,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> >  	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
> >  }
> >  
> > +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
>                                                                              ^^^^
> [Severity: Low]
> This isn't a bug, but there is a typo in the parameter name (cope instead
> of scope).
> 
> > +{
> > +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
> 
> [Severity: High]
> Does using is_kernel_in_hyp_mode() here erroneously enable VHE-specific
> features for pKVM (nVHE)?
> 
> During early boot feature detection, is_kernel_in_hyp_mode() evaluates to
> true because the host kernel boots at EL2 and only drops privileges to
> EL1 later during device_initcall_sync (finalize_pkvm()).
> 
> This early check could force ARM64_HAS_HDBSS to be enabled on pKVM
> systems, propagating the KVM_PGTABLE_S2_DBM flag to hypervisor-managed
> stage-2 page tables.
> 
> Should this use is_vhe_hyp_mode() instead to avoid incorrectly matching
> during the nVHE privileged window?
> 

Copied from HDBSS patchset, so notes for Tian Zheng ^

> > +}
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index 91a7dfad66866..e16729f0b7bd2 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> 
> [ ... ]
> 
> > @@ -731,9 +731,13 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
> >  	if (prot & KVM_PGTABLE_PROT_R)
> >  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> >  
> > -	if (prot & KVM_PGTABLE_PROT_W)
> > +	if (prot & KVM_PGTABLE_PROT_W) {
> >  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> >  
> > +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> > +			attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> 
> [Severity: Critical]
> Can setting KVM_PTE_LEAF_ATTR_HI_S2_DBM here lead to a silent bypass of
> software write-protection?
> 
> When a page is mapped writable, both DBM and S2AP_W are set. If KVM later
> write-protects the page via kvm_pgtable_stage2_wrprotect(), only S2AP_W
> is cleared:
> 
> kvm_pgtable_stage2_wrprotect() {
>     ...
>     return stage2_update_leaf_attrs(pgt, addr, size, 0,
>                                     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>                                     NULL, NULL,
>                                     KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> }
> 
> This leaves DBM intact. Hardware interprets DBM=1, S2AP_W=0 as a clean
> writable page and automatically sets S2AP_W=1 on the next write without
> generating a Permission Fault.
> 
> For pKVM, this allows a guest to bypass memory isolation. For nested
> virtualization, nested guest writes will silently set S2AP_W=1 without
> trapping to the host, resulting in lost dirty pages during live migration.
> 

Is there any case where we want to write protect a page that was marked as 
writeable, but not for dirty-tracking? 
If so, we need to also clear DBM for that, and make sure it is done only 
in those cases. 

The whole idea of HAFDBS / HDBSS is that the page is not actually write 
protected, it just doing dirty-detection, and this is done much much 
faster.

Thanks!
Leo
