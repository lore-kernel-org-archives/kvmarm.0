Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9484A3D4E;
	Thu,  3 Sep 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788455175; cv=none; b=ueNiK4DaTAyTbgikxh2/FlvoquGJYCD2vO8MHU56MC7uMfWf640R06O1mQJXLexmZeydwAMspWMGU4hj4QnOoNrX9B0MOqc9wQcYBokMd2Qvidh0D+8qMLJxYM6b8qWRaB97+GZrbS2SlGZwcvYoI2PYyyfaiVkdReRper65up4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788455175; c=relaxed/simple;
	bh=Jcww6Hw9tz78gTutM+MhJqLP1fdUinAHZVWVhV74A6o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZAWzSh56GcV6FqSByUv+fXxaL8JJd/P/cJFWihAnkK0n8UtzJlpCAnqkoHZ48FvtkcmJFOWKyva5fG9/Wh2hFxyYkl4IB8cykxz9eed+TWAXIHUSPuXyymzG5N7ENyuDNw/lMwaKhwX1mC4ZrSraNn8LB44w89UPuOb4KU9Z7PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePrrbEV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePrrbEV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671FC1F000E9;
	Thu,  3 Sep 2026 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788455173;
	bh=PxFGAouag/0RIM6GolkrJw7+qigEL/fsr9+omTKxoCc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ePrrbEV9PcIgIDqwxjtRWHajSLcmZmNAb8YGAFPFNQ/cFXuLwVp1k3DsLOqZ2jN+5
	 FqEF0vSVRgxUHau33UwO3jg6oWN3JKFNT1M+vvww20mjAcK5U6B+0GfUIj9tfwaStA
	 1tGCkR/eqx9RMMWAF/LrEdujJB4HyGclTyNHav9jJkgBrByojWnhUjkmWKh8qwtjGd
	 IWnLHKW8GUhS98xgRS/NHqfiAVCI/BBLI9OQybreF/AOH8ZfplLhs/nc1TnbI6ti8K
	 +rdYzzXRfAxoPL4R9gZ+aQZeqjRa5bV4Eu+W+1cXpXS8Wh0L8YI/sulJRcLucsTwBg
	 xHMWWlfHv2JnQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 27/28] KVM: arm64: Handle dirty page logging when
 SPE feature is set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandru Elisei" <alexandru.elisei@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260903160623.315525-28-alexandru.elisei@arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-28-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 17:06:12 +0000
Message-Id: <20260903170613.671FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Memory Protection Bypass / Privilege Escalation via Unconditional =
Stage-2 Write-Enable
- [High] Logic Error and EL2 Hypercall Argument Corruption due to flawed `n=
r_pages` calculation
- [High] Logical Inconsistency / State Desynchronization causing missed VCP=
U kicks and unexpected guest exits
- [Medium] Kernel preemption bug via `smp_processor_id()` in a preemptible =
context
--

commit 45c89e608abbd3e8f9c8b944b7e7d74478d5db12
Author: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: KVM: arm64: Handle dirty page logging when SPE feature is set

This commit aims to avoid profiling blackout windows by preventing VCPU
execution when the SPE buffer is enabled and dirty page logging is active.
It introduces dirty logging synchronization constraints and automatic guest
exits for the KVM/ARM64 SPE implementation.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7c7d0616db53a..73f321b3ed2dc 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1172,6 +1172,15 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
> =20
> +static void kvm_vcpu_prepare_exit_fail_entry(struct kvm_vcpu *vcpu, u64 =
reason)
> +{
> +	struct kvm_run *run =3D vcpu->run;
> +
> +	run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
> +	run->fail_entry.hardware_entry_failure_reason =3D reason;
> +	run->fail_entry.cpu =3D smp_processor_id();

[Severity: Medium]
Is it safe to use smp_processor_id() here? This function is newly invoked by
check_vcpu_requests() when handling KVM_REQ_SPE_EXIT_DIRTY_LOGGING. Because
check_vcpu_requests() executes in the KVM run loop before preempt_disable()
is called, the context remains preemptible. This will trigger a kernel
warning if CONFIG_DEBUG_PREEMPT is enabled, and records an unreliable CPU ID
since the thread can migrate immediately afterward.

[ ... ]
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b74dd5ce1efd3..07e43f607eae7 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1293,6 +1293,14 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtabl=
e *pgt, u64 addr, u64 size)
>  					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
>  }
> =20
> +int kvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr, u=
64 size)
> +{
> +	return stage2_update_leaf_attrs(pgt, addr, size,
> +					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W, 0,
> +					NULL, NULL,
> +					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> +}

[Severity: High]
Can this lead to a memory protection bypass? By unconditionally adding the
KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W bit to all valid leaf PTEs, this doesn't
appear to validate if the underlying host memory mapping actually permits
writes. If a guest reads unallocated shared memory while dirty logging is o=
n,
KVM maps the host's zero page as read-only at stage 2. Once dirty logging is
disabled, this blindly grants write access to it.

[ ... ]
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8e4c6e4bec123..5ba2fa8010cc9 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -488,6 +488,33 @@ int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pg=
t, u64 addr, u64 size)
>  	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  }
> =20
> +int pkvm_pgtable_stage2_write_enable(struct kvm_pgtable *pgt, u64 addr, =
u64 size)
> +{
[ ... ]
> +	lockdep_assert_held(&kvm->mmu_lock);
> +	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
> +		gfn =3D max(addr >> PAGE_SHIFT, mapping->gfn);
> +		nr_pages =3D min_t(u64, end_gfn - gfn, mapping->nr_pages);

[Severity: High]
Does this calculation span past the end of the mapping? If the requested
address starts in the middle of an existing mapping, gfn is offset from
mapping->gfn. Because the offset isn't subtracted from mapping->nr_pages,
the EL1 host passes an out-of-bounds nr_pages to the EL2 hypervisor. This
could cause the hypercall to fail or inadvertently write-enable pages beyond
the intended mapping.

> +		ret =3D kvm_call_hyp_nvhe(__pkvm_host_write_enable_guest, handle, gfn,
> +					nr_pages);
> +		if (WARN_ON(ret))
> +			break;
> +	}
> +
> +	return ret;
> +}

[ ... ]
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index e5f3d0dea7c54..f3310465f40eb 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
[ ... ]
> +void kvm_spe_add_dirty_logging(struct kvm *kvm, const struct kvm_memory_=
slot *slot)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	/*
> +	 * No point in handling a regular memslot, because they cannot guarantee
> +	 * that memory remains mapped at stage 2.
> +	 *
> +	 * Memory described by a read-only memslot is always read-only, so SPE
> +	 * cannot write to it anyway.
> +	 */
> +	if (!kvm_slot_has_gmem(slot) || (slot->flags & KVM_MEM_READONLY))
> +		return;

[Severity: High]
Does this cause unexpected guest exits and missed VCPU kicks for regular
memslots? Here in kvm_spe_add_dirty_logging(), regular memslots are skipped,
so running VCPUs aren't kicked when dirty logging starts.

> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vcpu_has_spe(vcpu))
> +			continue;
> +		kvm_make_request(KVM_REQ_SPE_HANDLE_DIRTY_LOGGING, vcpu);
> +		if (vcpu_has_run_once(vcpu))
> +			__kvm_vcpu_kick(vcpu, true);
> +	}
> +}
> +
> +void kvm_spe_remove_dirty_logging(struct kvm *kvm, const struct kvm_memo=
ry_slot *slot)
> +{
> +	phys_addr_t start, end;
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +
> +	lockdep_assert_held(&kvm->slots_lock);
> +
> +	if (!kvm_slot_has_gmem(slot) || (slot->flags & KVM_MEM_READONLY))
> +		return;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		/*
> +		 * Write-enabling an entire memslot can be expensive, do it only
> +		 * if the VM has SPE.
> +		 */
> +		if (vcpu_has_spe(vcpu)) {
> +			start =3D slot->base_gfn << PAGE_SHIFT;
> +			end =3D (slot->base_gfn + slot->npages) << PAGE_SHIFT;
> +
> +			write_lock(&kvm->mmu_lock);
> +			kvm_stage2_write_enable_range(&kvm->arch.mmu, start, end);

[Severity: High]
Does this blindly write-enable the entire shared stage-2 memslot? Combined
with the unconditional KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W addition in
kvm_pgtable_stage2_write_enable(), this allows a malicious guest to gain wr=
ite
access to read-only host memory (like the global shared zero page) if it
was previously mapped as read-only.

> +			write_unlock(&kvm->mmu_lock);
> +			kvm_flush_remote_tlbs_memslot(kvm, slot);
> +			return;
> +		}
> +	}
> +}
> +
> +static bool kvm_spe_should_exit_dirty_logging(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm =3D vcpu->kvm;
> +	u64 pmblimitr, pmbsr;
> +
> +	if (!atomic_read(&kvm->nr_memslots_dirty_logging))
> +		return false;

[Severity: High]
Because regular memslots were skipped in kvm_spe_add_dirty_logging(), they
weren't protected. However, this check relies on the global
nr_memslots_dirty_logging counter, which increments for all memslots.
Could this mismatch cause unexpected guest exits when a VM enables standard
dirty logging (e.g., VGA framebuffers) while utilizing SPE?

> +
> +	pmblimitr =3D __vcpu_sys_reg(vcpu, PMBLIMITR_EL1);
> +	pmbsr =3D __vcpu_sys_reg(vcpu, PMBSR_EL1);
> +
> +	return FIELD_GET(PMBLIMITR_EL1_E, pmblimitr) && !FIELD_GET(PMBSR_EL1_S,=
 pmbsr);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903160623.3155=
25-1-alexandru.elisei@arm.com?part=3D27
