Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5394306D3F;
	Mon,  3 Aug 2026 15:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785771315; cv=none; b=BbAPc7Ya8e2xf+LnCmebrKhpNAySy9d4rUonPSZdujKxm3VF/aHcRQaVHrKiHGlI3SLtPtR0ObkRNp1EKnq1WXhnjlL79jwN/4J/dyeCfPCxCJ/efDsNcQ/XrTug1M4OirjG/yByzShmaUnWBJ5Cqy1u2Vdj5CXPNbQ/EyFJnus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785771315; c=relaxed/simple;
	bh=85BJQamw9y2FdRKTLjDiCJlerS286kBb4dwb2zM9+gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Et9Dxo4nPAY3JAyP0ndYubTTThE6+rZRE7aHB2kDyKT1rPQRQQwOEk3BOIc7KGEK8o7w9AHYmDtJ3NDhHBjLc4gqZ8dtZfl3SDU6uJgM4C1uNC8Lz32z3/5gLgGCPyTIvpBOvWFgoPHQ1lnN+iNw5dKHgVG9Z0XZ2abgc18gjvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Jj5mCLP5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Jj5mCLP5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58CD2143D;
	Mon,  3 Aug 2026 08:35:09 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CA033F66F;
	Mon,  3 Aug 2026 08:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785771313; bh=85BJQamw9y2FdRKTLjDiCJlerS286kBb4dwb2zM9+gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jj5mCLP5Utf5mXkxCe6B15rcWGW7+tpjZixJddGr6QZSlNbmV3D+m70it9KzpUm28
	 ocDKGe5vY39Dl3k1XwMn7n0LNyoJZFBckBw6bkGIBhkGu6Og+myPuWN4PParg0d655
	 D4BZJDo3MFDiuok35J1dUMs05OzNFkk4tQZUlJSc=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v3 06/11] KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine
Date: Mon,  3 Aug 2026 16:35:09 +0100
Message-ID: <anC1LcuANek6moBb@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729111841.B3A501F000E9@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-7-leo.bras@arm.com> <20260729111841.B3A501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:18:41AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Critical] Dropping `mmu_lock` during eager page splitting allows concurrent guest writes to be permanently lost.
> - [Critical] Direct EL2 system register access from EL1 host kernel triggers an UNDEFINED exception on nVHE/pKVM systems.
> - [High] Infinite hardware polling loop with preemption disabled risks hard lockups and renders the preempt notifier dead code.
> --
> 
> --- Patch [6]: [PATCH v3 06/11] KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine ---
> commit 67bd2745169abaea5a656577d6b7add50b3e09f1
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine
> 
> Implement arm64 version of kvm_arch_dirty_log_clear() making use of FEAT_HACDBS.
> It converts dirty bitmap entries into HDBSS entries in 64-page blocks and feeds
> them to the HACDBS mechanism to clear dirty states. It also supports hugepage
> splitting.
> 
> > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > index dd16438f06518..d368a23a84b30 100644
> > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> [ ... ]
> > +static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
> > +{
> > +	return system_supports_hacdbs() &&  kvm->arch.mmu.pgt &&
> > +	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
> > +}
> 
> [Severity: Critical]
> Does this check need to verify if the kernel is running in VHE mode?

kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM will only be true when HDBSS 
is enabled, and that only happens in VHE=1.

> 
> If this executes on an nVHE or pKVM system (where the host runs at EL1), 
> and the hardware supports HACDBS, the ioctl will proceed and call 
> dirty_bit_clear(). That function directly accesses EL2 system registers 
> like SYS_HACDBSCONS_EL2, which will trap or UNDEF when accessed from EL1.
> 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > index 33826bbd16d91..5a6266205295e 100644
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> [ ... ]
> > +int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> > +			       struct kvm_memory_slot *memslot,
> > +			       struct kvm_clear_dirty_log *log,
> > +			       unsigned long *bitmap,
> > +			       bool *flush)
> > +{
> [ ... ]
> > +	write_lock(&kvm->mmu_lock);
> > +
> > +	for (unsigned long i = start; i < end; i++) {
> > +		unsigned long mask;
> > +		gfn_t offset;
> > +		atomic_long_t *p;
> > +
> > +		if (log) { /* Clean only what is in the input bitmap */
> > +			mask = bitmap[i - start];
> > +			if (!mask)
> > +				continue;
> > +
> > +			p = (atomic_long_t *)&dirty_bitmap[i];
> > +			mask &= atomic_long_fetch_andnot(mask, p);
> > +		} else { /* Clean everything, save to output bitmap */
> [ ... ]
> > +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > +			kvm_mmu_split_huge_pages(kvm,
> > +						 gfn_to_gpa(offset + __ffs(mask)),
> > +						 gfn_to_gpa(offset + __fls(mask) + 1));
> 
> [Severity: Critical]
> Could this lead to silent memory corruption due to dropped locks?
> 
> The software dirty bit is cleared above via atomic_long_fetch_andnot(). 
> Then we call kvm_mmu_split_huge_pages(), which drops mmu_lock internally:
> 
> kvm_mmu_split_huge_pages()
>   need_split_memcache_topup_or_resched()
>   write_unlock(&kvm->mmu_lock);
>   cond_resched();
> 
> While the lock is dropped, a vCPU can write to the page without trapping
> because the hardware DBM bit is still set. Once the lock is reacquired, 
> dirty_bit_clear() clears the hardware DBM bit. The write gets lost because
> both software and hardware bits are now clean.

If the new bit is set before the atomic read, it will be cleaned and 
reported as dirty to user. If it's manual cleaning, it will be available 
for cleaning in the next round.

If the new bit is set after the atomic read, it will be there for the next 
iteration, so no problem. 

> 
> > +		do {
> > +			idx = mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_sz);
> > +			if (idx >= entries_sz) {
> > +				ret = dirty_bit_clear(kvm, hw_entries, idx);
> 
> [Severity: High]
> Is there a risk of a hard lockup here during hardware polling?
> 
> Looking at dirty_bit_clear(), it polls SYS_HACDBSCONS_EL2 in a while (true)
> loop without a timeout fallback. 
> 
> Since __kvm_arch_dirty_log_clear() takes write_lock(&kvm->mmu_lock) before 
> calling dirty_bit_clear(), preemption is disabled on non-RT kernels. This 
> makes the preempt_notifier registered inside dirty_bit_clear() dead code 
> and guarantees the CPU will spin forever if the hardware hangs.

Good catch!
So on non-RT kernels we need no preempt_notifiers.
OTOH, we will need them on RT kernels, so I suppose we need to find a way 
of using them seemlessly.

Thanks!
Leo
