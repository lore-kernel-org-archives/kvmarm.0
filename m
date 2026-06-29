Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83E25411667;
	Mon, 29 Jun 2026 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782751795; cv=none; b=L9Vks5FJlXvsMI7yF5o+WCIjdNx2jMAI/2y4Qkz1JUoKWL+IMt9pBipK1P6sf0Vf2amP+qIIycBXGug4nt5SB0a5Clf06WkpK8wzzJBKYPlG+TUm5m/+phccZcXEf1Pv3nLrmzliLMUZVswRuFxHDyl4qT2XXfrdCYNW3C4kFVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782751795; c=relaxed/simple;
	bh=mLOsB+P60LUG2dPjtk80SiibmEGV1O8Y2owloSkyZzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=o22fofx3AvQqvws5BzJPwRTrpIaTuQXf8VBitBuSDFJH1GsA4qHMTENaBA6W2MmpIgyjXXdkKcfawODUu6AO5uSWcMEr1Th9i+ESmVnJIB7D99pDq/PynCxoPi0SnlwZvo+2cr/zhST3Wjwd4y4yuk46jvFKDc74JFciPhYYTb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cmuVubFX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cmuVubFX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C7AA355A;
	Mon, 29 Jun 2026 09:49:48 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10EE53F905;
	Mon, 29 Jun 2026 09:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782751792; bh=mLOsB+P60LUG2dPjtk80SiibmEGV1O8Y2owloSkyZzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmuVubFX5J5Xhh3myMv/yHXLOGxL7rWW2GHHmuTUMlZ0XeKF+Yh9BMkrX06/Mc0pu
	 IDrt1Nkr6aQdhWYDwIsfSp4d4peooEP/hvwyMSimDEWCBRP/ZxC3hECkoXJeE8zOj6
	 2BUn5Pd5elBwCrKRZxGVZxzMvGGZAeZ/mWNwpug0=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 08/13] KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine
Date: Mon, 29 Jun 2026 17:49:50 +0100
Message-ID: <akKiLnm-PTyy5X_g@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629114501.A6A801F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-9-leo.bras@arm.com> <20260629114501.A6A801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:45:01AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 10 potential issue(s) to consider:
> - [High] Missing `isb()` context synchronization event after writing to the `HCR_EL2` control-plane system register.
> - [High] Host kernel directly accesses EL2 system registers, which will crash nVHE configurations.
> - [High] Incorrect indexing of the userspace-provided `bitmap` buffer leads to out-of-bounds memory reads.
> - [High] Dropping `kvm->mmu_lock` before pending HACDBS entries are flushed creates a TOCTOU race window that permanently loses guest writes.
> - [High] Off-by-one error in calculating `split_end` causes KVM to mistakenly skip huge page splitting for subsequent PMDs, leading to data loss.
> - [High] Flawed return value logic in `__kvm_arch_dirty_log_clear()` incorrectly returns `-EAGAIN` on exact-multiple success or a positive integer on general success.
> - [High] The `wfi()` loop waits indefinitely with `preempt_disable()` and `kvm->mmu_lock` held in write mode without masking local interrupts, risking lost wakeups and hard lockups.
> - [High] Ignoring the return value of `kvm_mmu_split_huge_pages()` can permanently break dirty logging for huge pages.
> - [High] Dereferencing `kvm->arch.mmu.pgt` without checking if it is NULL leads to a kernel panic.
> - [Low] A variable declaration immediately follows a `case` label, resulting in a build failure.
> --
> 
> commit 8c1efc438f0d50c036b9548bfa7efea74d90a446
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine
> 
> This patch implements an arm64-specific kvm_arch_dirty_log_clear() using the
> FEAT_HACDBS hardware feature. It converts dirty bitmap entries into HDBSS
> structures and feeds them to the hardware to clean the page tables. It also
> splits huge pages in chunks if manual protect and init set options are
> enabled.
> 
> > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> 
> [ ... ]
> 
> > +static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
> > +{
> > +	return this_cpu_read(hacdbs_pcp.status) == HACDBS_IDLE &&
> > +	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
> > +}
> 
> [Severity: High]
> Can this cause a kernel panic if invoked before the MMU is fully initialized?
> The stage-2 page tables (pgt) are allocated lazily, so if userspace calls
> the clear dirty log ioctl before initialization, kvm->arch.mmu.pgt could be
> NULL.
>

It should only be cleaned after dirtied, which happens after dirty_log is 
enabled, which happens way after initalization.
 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> 
> [ ... ]
> 
> > +int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> > +			       struct kvm_memory_slot *memslot,
> > +			       struct kvm_clear_dirty_log *log,
> > +			       unsigned long *bitmap,
> > +			       bool *flush)
> > +{
> 
> [ ... ]
> 
> > +	for (unsigned long i = start; i < end; i++) {
> > +		unsigned long mask;
> > +		gfn_t offset;
> > +		atomic_long_t *p;
> > +
> > +		if (log) { /* Clean only what is in the input bitmap */
> > +			mask = bitmap[i];
> 
> [Severity: High]
> Does this code read out of bounds of the userspace-provided bitmap?
> When a dirty log is provided, the bitmap is sized relative to log->num_pages.
> Since i is an absolute index into the guest's memory slot (starting at
> log->first_page / BITS_PER_LONG), accessing bitmap[i] uses the absolute 
> offset instead of a 0-based relative offset.

It is the same algorithm as the generic sw cleaning. Those verifications 
already happen in the caller function.

> 
> > +			if (!mask)
> > +				continue;
> 
> [ ... ]
> 
> > +		offset = base_gfn + i * BITS_PER_LONG;
> > +
> > +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > +			kvm_mmu_split_huge_pages(kvm,
> > +						 gfn_to_gpa(offset + __ffs(mask)),
> > +						 gfn_to_gpa(offset + __fls(mask) + 1));
> 
> [Severity: High]
> Does this create a race condition that loses guest writes?
> The software dirty bitmap is cleared at the start of this loop. If
> kvm_mmu_split_huge_pages() is called here, it drops and reacquires
> kvm->mmu_lock to top up the memory cache. Any guest write that occurs
> while the lock is dropped is recorded in the hardware PTE, but because
> the software bit was already cleared, the subsequent hardware execution
> clears the PTE's dirty bit, erasing the concurrent write.
> 

The write is already captured, and will be reported to the user at the 
end of this syscall. If it gets dirty before the bit is actually clean, 
there is no issue, as the user already knows the page is dirty.


> [Severity: High]
> Can this permanently break dirty logging for huge pages if splitting fails?
> The return value of kvm_mmu_split_huge_pages() is ignored. If it fails
> (e.g., returning -ENOMEM), the block is not split, but the IPAs are
> still fed to the hardware. The hardware will then clear the dirty bit on
> the 2MB block descriptor, losing dirty tracking for the entire region.
> 

It will not. 
HACDBS will fail because the block level is not the same as reported.

So it falls back to software.

Interestingly enough, no code actually checks if the splitting actually 
succeeded before proceeding.


> [Severity: High]
> Is there an off-by-one error in the split_end calculation?
> Looking at the split_end assignment in the full context:
> 
> __kvm_arch_dirty_log_clear() {
>     ...
>     split_end = gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);
>     ...
> }
> 
> Since end is an exclusive upper bound, if the dirty region perfectly aligns
> with a PMD boundary, this calculates a split_end that spans to the end of
> the next PMD. This would cause the next PMD to skip splitting, leading to
> data loss when the hardware clears the dirty bit on the unsplit block.
> 

Its the other way around, split_end is used to skip splitting if the value 
is smaller than it. 

Say the block addr and size are 0x1000, it splits from 0x1000 to 
0x2000. split_end will be 0x1FFF, and any value above that (starting at 
0x2000) will trigger a new split. That's why the '-1' is at the end of its 
calculation.
 

> > +		do {
> > +			idx = mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_sz);
> > +			if (idx >= entries_sz) {
> > +				ret = dirty_bit_clear(kvm, hw_entries, idx);
> 
> [Severity: High]
> Is there a missing context synchronization event in dirty_bit_clear()?
> When this calls dirty_bit_clear(), that function writes to the HCR_EL2
> control-plane system register and immediately calls __load_stage2():
> 
> dirty_bit_clear() {
>     ...
>     hcr_el2 = read_sysreg(HCR_EL2);
>     write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
>     __load_stage2(&kvm->arch.mmu);
>     ...
> }
> 
> The architecture requires an isb() as the very next instruction after
> writing a control-plane system register. Without it, the CPU executes
> subsequent instructions in an architecturally undefined pipeline state.
> 

Look previous patches.


> [Severity: High]
> Does this code access EL2 system registers directly from the host kernel?
> In nVHE configurations, the host kernel runs at EL1. The dirty_bit_clear()
> function directly reads and writes HCR_EL2. This will trigger an Undefined 
> Instruction exception and panic the host kernel on nVHE systems. KVM must 
> use EL2-private hyp code or hypercalls to access EL2 state outside of VHE 
> mode.
> 

This is a VHE exclusive feature, as seen in the first patch.

> [Severity: High]
> Does the wait loop in dirty_bit_clear() risk a lost wakeup and hard lockup?
> The code disables preemption but fails to disable local interrupts before
> calling wfi():
> 
> dirty_bit_clear() {
>     preempt_disable();
>     ...
>     do {
>         wfi();
>     } while (this_cpu_read(hacdbs_pcp.status) == HACDBS_RUNNING);
>     ...
> }
> 
> If the hardware interrupt fires and sets the status to idle after the
> condition is checked but before the wfi() instruction executes, the CPU
> will sleep indefinitely.
> 

Yes, see previous patches.

> > +				*flush = *flush || ret > 0;
> > +				if (ret != idx) {
> > +					/* Save bits not converted back to bitmap */
> > +					atomic_long_or(mask, (atomic_long_t *)&dirty_bitmap[i]);
> > +					goto out_err;
> > +				}
> > +				idx = 0;
> > +			}
> > +		} while (mask);
> > +	}
> 
> [ ... ]
> 
> > +out_err:
> > +	if (unlikely(ret != idx)) {
> > +		/*
> > +		 * In case there is an error and not all entries in HACDBS get
> > +		 * cleaned, we have to mark the dirty bits back in the bitmap,
> > +		 * as that will be used by the software routine.
> > +		 *
> > +		 * Entries should be in order, since they were extraxed from
> > +		 * the dirty-bitmap, so batching the atomic writes is efficient.
> > +		 */
> > +
> > +		if (ret < idx)
> > +			hdbss_to_bitmap(hw_entries, ret, idx, dirty_bitmap, memslot->base_gfn);
> > +
> > +		ret = -EAGAIN;
> > +	}
> > +
> > +	write_unlock(&kvm->mmu_lock);
> > +	kfree(hw_entries);
> > +
> > +	return ret;
> > +}
> 
> [Severity: High]
> Does this error handling block incorrectly treat exact-multiple success states
> as failures?
> If the processed entries perfectly divide by entries_sz, the loop resets
> idx = 0 and sets ret = entries_sz. The check if (unlikely(ret != idx))
> then evaluates to true, falsely triggering this error path and returning
> -EAGAIN.

Looks like so. But the software routine would just scan the dirty-bitmap 
and do nothing but flush the TLBs as it's needed. We can avoid this by 
adding and ret=0; after idx=0; so they will be always equal in this case.


> 
> Additionally, if it is not an exact multiple, the function exits with
> ret = idx (a positive integer), which the generic KVM ioctl layer treats
> as a failure code.

It does exit with a positive integer, but that is not returned by generic 
code. It will only cause a goto: out, which will return 0;

> 
> >  static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
> >  {
> >  	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
> 
> [Severity: High]
> Does this handler also directly access an EL2-only register from the host?
> Just like dirty_bit_clear(), calling read_sysreg_s(SYS_HACDBSCONS_EL2)
> from the host IRQ handler running at EL1 will crash nVHE configurations
> with an Undefined Instruction exception.
> 

VHE-only feature.

> [Severity: Low]
> Is there a syntax error in this IRQ handler's switch statement?
> Looking at the rest of hacdbsirq_handler():
> 
> hacdbsirq_handler() {
>     ...
>     case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
>         int index = ...;
>     ...
> }
> 
> A variable declaration immediately following a case label is a syntax
> error in C, which will cause a build failure.

It can be put in a block, it can be declared before.
I have no issue dealing with this, but does not currently cause any build 
error.

