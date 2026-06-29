Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F015744B663;
	Mon, 29 Jun 2026 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782754014; cv=none; b=aAKvOZBitJD8r6IAG7XSu25x/p1tPumMBuzOF4z4MJz6KflCECxayTex0N+3lDHYiISHjJw+kjYNuU/R5uPr1UqqIadPZvs3tOVpP5s6YtKSlEUHP/roLOTQbCfOmrHmdTqPB0MZESuvxq98+I14vsuovAhfLDkciBwHHwv2L6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782754014; c=relaxed/simple;
	bh=twCp3UAdFQ3jI5FFB+ZfFejbSMS6e565YtXepbK/Ub8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=Q0RsrHZlTLBr35rZKoUg3g4S93tCf52YiOdCCL/OUrVvbmSMvES7tUj3/eyJErk6C6tvqkfAiT5ZtFhrVQDmcHdDxN0aJC7qUqwB/rexbTDnPsuZb9NWZHWDku+yjDLt+t6YPuZaBxnHC5hTs09n3MyDYRVXIPZ81C4R0EpshNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=glgu0d7S; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="glgu0d7S"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA9A53565;
	Mon, 29 Jun 2026 10:26:47 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A1B83F673;
	Mon, 29 Jun 2026 10:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782754012; bh=twCp3UAdFQ3jI5FFB+ZfFejbSMS6e565YtXepbK/Ub8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glgu0d7SILxDx/NGXotdnQsRZOirBfCPKxssC6/UbNatYgB6JaljwgLYSXhSAfUX8
	 L66B1yHFz3K2NDiJRJWNVFMEVFjsIzHAyPTPQi6F6sIDLGoeqeItpL63USMlmzKvYv
	 WJq2yAj7VYG97KXsks0edv86g9MEhqUJfvGs37wY=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 12/13] KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
Date: Mon, 29 Jun 2026 18:26:49 +0100
Message-ID: <akKq2fvsUWPxuCHU@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629114921.2E78C1F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-13-leo.bras@arm.com> <20260629114921.2E78C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:49:20AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> 
> New issues:
> - [Critical] Unvalidated userspace memory accesses in dirty ring clearing lead to host DoS and memory corruption.
> - [High] Missing TLB invalidation and DSB in dirty ring hardware path.
> - [High] Hardware buffer allocation lacks strict physical alignment guarantees.
> 
> Pre-existing issues:
> - [High] Missing architecturally required context synchronization (ISB) after control register writes.
> - [High] Unsafe wfi() polling loop causes lost wakeups and CPU lockups.
> - [Medium] Hardware dirty log clearing erroneously falls back to software due to incorrect return value processing.
> --
> 
> commit 9f463875fd0f7eddcaa7053b557d7a2cc21e83c1
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine
> 
> This commit implements an arm64 version of kvm_arch_dirty_ring_clear using
> FEAT_HACDBS. It translates dirty-ring entries into HDBSS entries and uses
> the hardware mechanism to mark writable-dirty pages as clean. Invalid
> entries are then cleared, falling back to software cleaning on error.
> 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> [ ... ]
> > static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> > {
> > 	u64 hcr_el2;
> > 	int ret;
> > 
> > 	preempt_disable();
> > 
> > 	hcr_el2 = read_sysreg(HCR_EL2);
> > 	write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
> > 	__load_stage2(&kvm->arch.mmu);
> 
> [Severity: High]
> This is a pre-existing issue, but does this missing ISB after control register
> writes expose the pipeline to undefined architectural states?
> 
> Writing to HCR_EL2 requires an immediate context synchronization event.
> Executing __load_stage2 immediately after without an isb means it might
> operate under a stale configuration.

See prev patches


> 
> > 
> > 	hacdbs_start(hw_entries, size);
> > 
> > 	do {
> > 		wfi();
> > 	} while (this_cpu_read(hacdbs_pcp.status) == HACDBS_RUNNING);
> 
> [Severity: High]
> This is a pre-existing issue, but can this unprotected wfi wait loop cause
> a lost wakeup and an indefinite CPU stall?
> 
> Because local interrupts are not masked around this check and wait, a timely
> interrupt could satisfy the condition prematurely before wfi executes.
> 

iden

> [ ... ]
> > 	if (idx != 0) {
> > 		ret = dirty_bit_clear(kvm, hw_entries, idx);
> > 		*flush = *flush || ret > 0;
> > 	}
> > out_err:
> > 	if (unlikely(ret != idx)) {
> 
> [Severity: Medium]
> This is a pre-existing issue, but does this logic incorrectly evaluate a
> successful batch outcome as an error?
> 
> If the loop finishes exactly on a batch boundary, idx is reset to 0, but ret
> holds the success count of the previous batch. This causes the mismatch check
> to evaluate to true, forcing a -EAGAIN return and triggering an unnecessary
> software fallback.
> 

iden

> [ ... ]
> > @@ -256,6 +256,72 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> >  	return ret;
> >  }
> >  
> > +int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *ring,
> > +				int *nr_entries_reset)
> > +{
> > +	u64 *hw_entries;
> > +	u64 slot_offset = 0;
> > +	u64 ttwl;
> > +	int i, ret;
> > +	u32 slot = -1;
> > +
> > +	if (signal_pending(current))
> > +		return -EINTR;
> > +
> > +	ttwl = HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
> > +
> > +	hw_entries = kmalloc(max(ring->size * sizeof(u64), PAGE_SIZE), GFP_KERNEL);
> 
> [Severity: High]
> Does this kmalloc call lack the strict physical alignment guarantees required
> by the hardware accelerator?
> 
> Since kmalloc does not guarantee natural physical alignment for large buffers,
> is it possible for physical address truncation to occur? This could cause the
> hardware accelerator to parse unaligned memory and corrupt arbitrary page DBM
> bits.

I recall it had size-alignmen guarantees. Largest buffer size should be 
64k x 8B, so it should be ok.


> 
> > +	if (!hw_entries)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < ring->size; i++) {
> > +		struct kvm_dirty_gfn *entry;
> > +		gfn_t gfn;
> > +
> > +		entry = &ring->dirty_gfns[(ring->reset_index + i) &
> > +					  (ring->size - 1)];
> > +
> > +		if (!kvm_dirty_gfn_harvested(entry))
> > +			break;
> > +
> > +		if (entry->slot != slot) {
> > +			struct kvm_memory_slot *memslot;
> > +
> > +			memslot = kvm_dirty_ring_get_memslot(kvm, entry->slot);
> > +			slot = entry->slot;
> > +			slot_offset = memslot->base_gfn;
> 
> [Severity: Critical]
> Can an invalid, user-provided entry->slot lead to a NULL pointer dereference
> here?
> 
> The memslot pointer is dereferenced directly to read base_gfn without a NULL
> check.
> 
> > +		}
> > +
> > +		gfn = slot_offset + entry->offset;
> 

Correct. I have to verify the return value of get_memslot before using it.
Will do in v3

> [Severity: Critical]
> Is entry->offset validated against the memslot bounds?
> 
> Using an unvalidated user-provided offset here allows arbitrary Stage-2 GPA
> computation. This could enable Stage-2 memory corruption or privilege
> escalation.

Correct. Will verify the offset against memslot size before this.
Will be done in v3.

> 
> > +
> > +		hw_entries[i] = (gfn_to_gpa(gfn) & HDBSS_ENTRY_IPA) |
> > +				ttwl | HDBSS_ENTRY_VALID;
> > +	}
> > +
> > +	ret = dirty_bit_clear(kvm, hw_entries, i);
> 
> [Severity: High]
> Does this path miss an architecturally required TLB invalidation and DSB?
> 
> dirty_bit_clear relies on the caller to handle the TLBI (as noted in its
> internal comments for the log clearing path), but this ring clearing routine
> appears to jump directly to invalidating the entries and returning.

There is a dsb() and then a TLBI before returning to guest.

> 
> This could leave stale writable TLB entries in the guest.
> 
> > +
> > +	/* Set as invalid all successfully cleaned entries */
> > +	for (int j = 0; j < ret; j++) {
> [ ... ]
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260629111820.1873540-1-leo.bras@arm.com?part=12

Thanks!
Leo
