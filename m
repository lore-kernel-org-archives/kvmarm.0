Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7961D4B1293;
	Fri,  4 Sep 2026 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788532896; cv=none; b=oS3XyHQ2Zk1q6ukYmJZ2BDWGPQfRW48ZRxGgg0kI7R5/CaX+5unExHWWdES7cg/3Rba+gBAx7SxMaMCo/vRm2zJ4axcqxr4VXT0WFIKjnyppF8fO4A02imqp1TvDvltUQ9mXp6QvqtdQwx7BWwD9HjJ1zEFs5UyaHeSTcEct70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788532896; c=relaxed/simple;
	bh=0k52Y1vM+IgwMS98+VcRwHGCRVVRYfyijHlxJur9Vjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGTwJ8rdT8/6JGR4Bn5cDXVrMeMtUEdAHHIbWU7IpmbLpXknj/H5DbmLLw5Yqfd5HqSPcCXO6d49IM5ddu+jpXOJIK9IlzNpAKQUtFIopBlgMCes0uR8hChYORWTOd3GWS2A7xy21z2IPDU4sW+Ri2RrrogMGxaE7SapcIBjJOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ju6VTxbD; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ju6VTxbD"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 084A5152B;
	Fri,  4 Sep 2026 07:41:29 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.57.70.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED32C3F673;
	Fri,  4 Sep 2026 07:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788532892; bh=0k52Y1vM+IgwMS98+VcRwHGCRVVRYfyijHlxJur9Vjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ju6VTxbDF12jd9rRNJe7axjute/06tk2hIszChv4gimtWp3iQ3COZJJmv1lCWEuce
	 GZuC9KibJ9npzB1qySVCzhNVO9khOXS3s6PTVFJ1cwki1UO6ygNAqUzmhPVtGn4cRx
	 ZOYDOMUxV5cGMiozxV4rHRUNrdWLy6w2XZKfrhQs=
Date: Fri, 4 Sep 2026 15:41:00 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH v7 27/28] KVM: arm64: Handle dirty page logging when
 SPE feature is set
Message-ID: <aprYfLsndfR5SbLh@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-28-alexandru.elisei@arm.com>
 <20260903170613.671FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903170613.671FC1F000E9@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 05:06:12PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Memory Protection Bypass / Privilege Escalation via Unconditional Stage-2 Write-Enable
> - [High] Logic Error and EL2 Hypercall Argument Corruption due to flawed `nr_pages` calculation
> - [High] Logical Inconsistency / State Desynchronization causing missed VCPU kicks and unexpected guest exits
> - [Medium] Kernel preemption bug via `smp_processor_id()` in a preemptible context
> --
> 
> commit 45c89e608abbd3e8f9c8b944b7e7d74478d5db12
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> Subject: KVM: arm64: Handle dirty page logging when SPE feature is set
> 
> This commit aims to avoid profiling blackout windows by preventing VCPU
> execution when the SPE buffer is enabled and dirty page logging is active.
> It introduces dirty logging synchronization constraints and automatic guest
> exits for the KVM/ARM64 SPE implementation.
> 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 7c7d0616db53a..73f321b3ed2dc 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1172,6 +1172,15 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
> >  	return 1;
> >  }
> >  
> > +static void kvm_vcpu_prepare_exit_fail_entry(struct kvm_vcpu *vcpu, u64 reason)
> > +{
> > +	struct kvm_run *run = vcpu->run;
> > +
> > +	run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> > +	run->fail_entry.hardware_entry_failure_reason = reason;
> > +	run->fail_entry.cpu = smp_processor_id();
> 
> [Severity: Medium]
> Is it safe to use smp_processor_id() here? This function is newly invoked by
> check_vcpu_requests() when handling KVM_REQ_SPE_EXIT_DIRTY_LOGGING. Because
> check_vcpu_requests() executes in the KVM run loop before preempt_disable()
> is called, the context remains preemptible. This will trigger a kernel
> warning if CONFIG_DEBUG_PREEMPT is enabled, and records an unreliable CPU ID
> since the thread can migrate immediately afterward.

That's true. For the SPE case, it doesn't matter, because the failure reason is
dirty page logging being enabled for a memslot. For the unsupported CPU case it
might matter, but in that case it's called with preemption disabled so the cpu
ID is stable. I can call smp_processor_id() with preemption disabled, or have
the caller supply a cpu id and an argument.

I'll also update my testing configuration, to include CONFIG_DEBUG_PREEMPT. I
think at some point I disabled the debug options because it was making Linux too
slow and forgot to re-enable all of them.

> 
> [ ... ]
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > index b74dd5ce1efd3..07e43f607eae7 100644
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> > @@ -1293,6 +1293,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >  					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> >  }
> >  
> > +int kvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr, u64 size)
> > +{
> > +	return stage2_update_leaf_attrs(pgt, addr, size,
> > +					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, 0,
> > +					NULL, NULL,
> > +					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> > +}
> 
> [Severity: High]
> Can this lead to a memory protection bypass? By unconditionally adding the
> KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W bit to all valid leaf PTEs, this doesn't
> appear to validate if the underlying host memory mapping actually permits
> writes. If a guest reads unallocated shared memory while dirty logging is on,
> KVM maps the host's zero page as read-only at stage 2. Once dirty logging is
> disabled, this blindly grants write access to it.

This is called from kvm_arch_commit_memory_region() ->
kvm_spe_remove_dirty_logging() only if the memslot is backed by guest_memfd and
the memslot is not read-only. guest_memfd is a memory provider independent of
the host mapping, and guest_memfd backed memory is always mapped as writable at
stage 2.

Also worth point out the check that kvm_remove_dirty_logging() performs:

        if (!kvm_slot_has_gmem(slot) || (slot->flags & KVM_MEM_READONLY))
                return;

The read-only check is done for consistency with gmem_abort(), because KVM
rejects the KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD combination of flags for a
memslot.

> 
> [ ... ]
> > diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> > index 8e4c6e4bec123..5ba2fa8010cc9 100644
> > --- a/arch/arm64/kvm/pkvm.c
> > +++ b/arch/arm64/kvm/pkvm.c
> > @@ -488,6 +488,33 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
> >  	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
> >  }
> >  
> > +int pkvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr, u64 size)
> > +{
> [ ... ]
> > +	lockdep_assert_held(&kvm->mmu_lock);
> > +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> > +		gfn = max(addr >> PAGE_SHIFT, mapping->gfn);
> > +		nr_pages = min_t(u64, end_gfn - gfn, mapping->nr_pages);
> 
> [Severity: High]
> Does this calculation span past the end of the mapping? If the requested
> address starts in the middle of an existing mapping, gfn is offset from
> mapping->gfn. Because the offset isn't subtracted from mapping->nr_pages,
> the EL1 host passes an out-of-bounds nr_pages to the EL2 hypervisor. This
> could cause the hypercall to fail or inadvertently write-enable pages beyond
> the intended mapping.

Did I get the math wrong? Yes, I did.

> 
> > +		ret = kvm_call_hyp_nvhe(__pkvm_host_write_enable_guest, handle, gfn,
> > +					nr_pages);
> > +		if (WARN_ON(ret))
> > +			break;
> > +	}
> > +
> > +	return ret;
> > +}
> 
> [ ... ]
> > diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> > index e5f3d0dea7c54..f3310465f40eb 100644
> > --- a/arch/arm64/kvm/spe.c
> > +++ b/arch/arm64/kvm/spe.c
> [ ... ]
> > +void kvm_spe_add_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *slot)
> > +{
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long i;
> > +
> > +	lockdep_assert_held(&kvm->slots_lock);
> > +
> > +	/*
> > +	 * No point in handling a regular memslot, because they cannot guarantee
> > +	 * that memory remains mapped at stage 2.
> > +	 *
> > +	 * Memory described by a read-only memslot is always read-only, so SPE
> > +	 * cannot write to it anyway.
> > +	 */
> > +	if (!kvm_slot_has_gmem(slot) || (slot->flags & KVM_MEM_READONLY))
> > +		return;
> 
> [Severity: High]
> Does this cause unexpected guest exits and missed VCPU kicks for regular
> memslots? Here in kvm_spe_add_dirty_logging(), regular memslots are skipped,
> so running VCPUs aren't kicked when dirty logging starts.

The comment says it all.

> 
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		if (!vcpu_has_spe(vcpu))
> > +			continue;
> > +		kvm_make_request(KVM_REQ_SPE_HANDLE_DIRTY_LOGGING, vcpu);
> > +		if (vcpu_has_run_once(vcpu))
> > +			__kvm_vcpu_kick(vcpu, true);
> > +	}
> > +}
> > +
> > +void kvm_spe_remove_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *slot)
> > +{
> > +	phys_addr_t start, end;
> > +	struct kvm_vcpu *vcpu;
> > +	unsigned long i;
> > +
> > +	lockdep_assert_held(&kvm->slots_lock);
> > +
> > +	if (!kvm_slot_has_gmem(slot) || (slot->flags & KVM_MEM_READONLY))
> > +		return;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		/*
> > +		 * Write-enabling an entire memslot can be expensive, do it only
> > +		 * if the VM has SPE.
> > +		 */
> > +		if (vcpu_has_spe(vcpu)) {
> > +			start = slot->base_gfn << PAGE_SHIFT;
> > +			end = (slot->base_gfn + slot->npages) << PAGE_SHIFT;
> > +
> > +			write_lock(&kvm->mmu_lock);
> > +			kvm_stage2_write_enable_range(&kvm->arch.mmu, start, end);
> 
> [Severity: High]
> Does this blindly write-enable the entire shared stage-2 memslot? Combined
> with the unconditional KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W addition in
> kvm_pgtable_stage2_write_enable(), this allows a malicious guest to gain write
> access to read-only host memory (like the global shared zero page) if it
> was previously mapped as read-only.

See above.

> 
> > +			write_unlock(&kvm->mmu_lock);
> > +			kvm_flush_remote_tlbs_memslot(kvm, slot);
> > +			return;
> > +		}
> > +	}
> > +}
> > +
> > +static bool kvm_spe_should_exit_dirty_logging(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	u64 pmblimitr, pmbsr;
> > +
> > +	if (!atomic_read(&kvm->nr_memslots_dirty_logging))
> > +		return false;
> 
> [Severity: High]
> Because regular memslots were skipped in kvm_spe_add_dirty_logging(), they
> weren't protected. However, this check relies on the global
> nr_memslots_dirty_logging counter, which increments for all memslots.
> Could this mismatch cause unexpected guest exits when a VM enables standard
> dirty logging (e.g., VGA framebuffers) while utilizing SPE?

Yes, it can. On the other hand, why would anyone enable dirty page logging for a
memslot if they are not planning to do migration, which requires all memslots to
have dirty page logging enabled?

I would rather know first if dirty page logging for SPE enabled VMs is actually
worth enabling before thinking of such edge cases.

Thanks,
Alex

> 
> > +
> > +	pmblimitr = __vcpu_sys_reg(vcpu, PMBLIMITR_EL1);
> > +	pmbsr = __vcpu_sys_reg(vcpu, PMBSR_EL1);
> > +
> > +	return FIELD_GET(PMBLIMITR_EL1_E, pmblimitr) && !FIELD_GET(PMBSR_EL1_S, pmbsr);
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=27
