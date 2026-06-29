Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3623E1D0B;
	Mon, 29 Jun 2026 11:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733763; cv=none; b=NxCrV9Zqzho4FGxep3qUevdabpwLm2bIaWqHNoX++DAZd89XjNGPP/4EJf03RcXkb1BXtqsS/MZBkQ9K1t5ndxwtlppGxAiR4gLP+DqUbqGA2DbnWczBSbqO3JU+3krIXcnBXQrDrxOS6bujEArYgaFYrNqMxtTD8+0fQTrIkPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733763; c=relaxed/simple;
	bh=A21ccRC6m7Co3oBio3Reg/12kqd0QEz7BMQhWKSFzds=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lMhQsomxmF0h+RTXO6xFhZQBxXkUjqoAQaCOl2SmxMxbD/f1JD+b6ThL6ysqhzAWAkumVR9U3GgpmIwdJ2ijKRlJmrdW3F4W2Z9itnDsvNGO1quzb2X30V8jMpyLbEWcOCF4al7UBiAsB4p40j6RHtjc90yJkp418x+HGBE1qc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5rrf6H/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5rrf6H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E78C1F000E9;
	Mon, 29 Jun 2026 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733761;
	bh=5Trope4IGwjScKPvt7Su2B8x0tz6hLrkM8ce6AH0KNo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K5rrf6H/21WX+BZY0Ie8ikWc94H8SZhdnP18H5zsyzzO7iaygP0Pl2h4CKUitARSD
	 FEzGeVZPnD8PjQsKatyJ/09NSjhbMicsuXXnPD0DFvosuaD8+Gr1DuQrswIF4jfHQw
	 BJQgiASSaJLyzC6npK1nZrLElusx0mjqBPm4n2NBZtpmFKxeuwcUfW/sgxjRBrG85F
	 xLdL5d2unCxRn6QODRy2ANWkm7p5XC39V3+ZNEnqDLFNrR7qFjYWOFJAd4jioP8qkt
	 2wa6By2wvNz8RkFyDrHFa8gH5m7SGKLWsbHil1vGqH8d7xwPiDJwutTXkUQ6hIYHli
	 ipFZ6sSd67fLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/13] KVM: arm64: Add hardware-accelerated
 dirty-ring cleaning routine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260629111820.1873540-13-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-13-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:49:20 +0000
Message-Id: <20260629114921.2E78C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [Critical] Unvalidated userspace memory accesses in dirty ring clearing l=
ead to host DoS and memory corruption.
- [High] Missing TLB invalidation and DSB in dirty ring hardware path.
- [High] Hardware buffer allocation lacks strict physical alignment guarant=
ees.

Pre-existing issues:
- [High] Missing architecturally required context synchronization (ISB) aft=
er control register writes.
- [High] Unsafe wfi() polling loop causes lost wakeups and CPU lockups.
- [Medium] Hardware dirty log clearing erroneously falls back to software d=
ue to incorrect return value processing.
--

commit 9f463875fd0f7eddcaa7053b557d7a2cc21e83c1
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Add hardware-accelerated dirty-ring cleaning routine

This commit implements an arm64 version of kvm_arch_dirty_ring_clear using
FEAT_HACDBS. It translates dirty-ring entries into HDBSS entries and uses
the hardware mechanism to mark writable-dirty pages as clean. Invalid
entries are then cleared, falling back to software cleaning on error.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
[ ... ]
> static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> {
> 	u64 hcr_el2;
> 	int ret;
>=20
> 	preempt_disable();
>=20
> 	hcr_el2 =3D read_sysreg(HCR_EL2);
> 	write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
> 	__load_stage2(&kvm->arch.mmu);

[Severity: High]
This is a pre-existing issue, but does this missing ISB after control regis=
ter
writes expose the pipeline to undefined architectural states?

Writing to HCR_EL2 requires an immediate context synchronization event.
Executing __load_stage2 immediately after without an isb means it might
operate under a stale configuration.

>=20
> 	hacdbs_start(hw_entries, size);
>=20
> 	do {
> 		wfi();
> 	} while (this_cpu_read(hacdbs_pcp.status) =3D=3D HACDBS_RUNNING);

[Severity: High]
This is a pre-existing issue, but can this unprotected wfi wait loop cause
a lost wakeup and an indefinite CPU stall?

Because local interrupts are not masked around this check and wait, a timely
interrupt could satisfy the condition prematurely before wfi executes.

[ ... ]
> 	if (idx !=3D 0) {
> 		ret =3D dirty_bit_clear(kvm, hw_entries, idx);
> 		*flush =3D *flush || ret > 0;
> 	}
> out_err:
> 	if (unlikely(ret !=3D idx)) {

[Severity: Medium]
This is a pre-existing issue, but does this logic incorrectly evaluate a
successful batch outcome as an error?

If the loop finishes exactly on a batch boundary, idx is reset to 0, but ret
holds the success count of the previous batch. This causes the mismatch che=
ck
to evaluate to true, forcing a -EAGAIN return and triggering an unnecessary
software fallback.

[ ... ]
> @@ -256,6 +256,72 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
>  	return ret;
>  }
> =20
> +int __kvm_arch_dirty_ring_clear(struct kvm *kvm, struct kvm_dirty_ring *=
ring,
> +				int *nr_entries_reset)
> +{
> +	u64 *hw_entries;
> +	u64 slot_offset =3D 0;
> +	u64 ttwl;
> +	int i, ret;
> +	u32 slot =3D -1;
> +
> +	if (signal_pending(current))
> +		return -EINTR;
> +
> +	ttwl =3D HDBSS_ENTRY_TTWL(KVM_PGTABLE_LAST_LEVEL);
> +
> +	hw_entries =3D kmalloc(max(ring->size * sizeof(u64), PAGE_SIZE), GFP_KE=
RNEL);

[Severity: High]
Does this kmalloc call lack the strict physical alignment guarantees requir=
ed
by the hardware accelerator?

Since kmalloc does not guarantee natural physical alignment for large buffe=
rs,
is it possible for physical address truncation to occur? This could cause t=
he
hardware accelerator to parse unaligned memory and corrupt arbitrary page D=
BM
bits.

> +	if (!hw_entries)
> +		return -ENOMEM;
> +
> +	for (i =3D 0; i < ring->size; i++) {
> +		struct kvm_dirty_gfn *entry;
> +		gfn_t gfn;
> +
> +		entry =3D &ring->dirty_gfns[(ring->reset_index + i) &
> +					  (ring->size - 1)];
> +
> +		if (!kvm_dirty_gfn_harvested(entry))
> +			break;
> +
> +		if (entry->slot !=3D slot) {
> +			struct kvm_memory_slot *memslot;
> +
> +			memslot =3D kvm_dirty_ring_get_memslot(kvm, entry->slot);
> +			slot =3D entry->slot;
> +			slot_offset =3D memslot->base_gfn;

[Severity: Critical]
Can an invalid, user-provided entry->slot lead to a NULL pointer dereference
here?

The memslot pointer is dereferenced directly to read base_gfn without a NULL
check.

> +		}
> +
> +		gfn =3D slot_offset + entry->offset;

[Severity: Critical]
Is entry->offset validated against the memslot bounds?

Using an unvalidated user-provided offset here allows arbitrary Stage-2 GPA
computation. This could enable Stage-2 memory corruption or privilege
escalation.

> +
> +		hw_entries[i] =3D (gfn_to_gpa(gfn) & HDBSS_ENTRY_IPA) |
> +				ttwl | HDBSS_ENTRY_VALID;
> +	}
> +
> +	ret =3D dirty_bit_clear(kvm, hw_entries, i);

[Severity: High]
Does this path miss an architecturally required TLB invalidation and DSB?

dirty_bit_clear relies on the caller to handle the TLBI (as noted in its
internal comments for the log clearing path), but this ring clearing routine
appears to jump directly to invalidating the entries and returning.

This could leave stale writable TLB entries in the guest.

> +
> +	/* Set as invalid all successfully cleaned entries */
> +	for (int j =3D 0; j < ret; j++) {
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D12
