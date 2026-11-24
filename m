Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795489709;
	b=XAK7/FgEdaqiO8XLE45lhCTJTlFWGqi5lyPxCKFptedmWCdzFLMO1GoQIjbYyQFUMvGn
	 XsiKrhg1iOTKTipodaWZkRJI07+DOuVF2z1LWutWP3xruwjOydRtQbLYCxK9f6WCEl0dX
	 mliRGYQy5xqYZPOacz5jnmy58j2Yjw5a2qkgPBEtJm42kODsTfQi4LlJl6LkQ/KsX4fya
	 oygLDuRIJmd+FlmgCUs5sUf3R46IiIaHgFQP3R0OO62okgudtZDnYmh1YDEWWoYwlsOHm
	 POfvvjyg8+mRYULwEi2mOqwhMm9qEsI6qmYKo2Jr/EXmHXgVTwBXUL9Dg7rbU6Vt8Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489709;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=O4IE7yAwwVBkJp/nfXVC6lFyH44O2sFZ3ZBiR3r14Ic=;
	b=h+32Zg0iLlXhHQNbiWjFbhO42i16QizsekZQks17lqhmLknAGpI1KiHVS4otisilbRXa
	 8REbQdFwV+ULCecrYC0GrtWbQ8XOBm1w7Cc4tn1G4xsM7l3KjDVefeR3RRyKtNdWPhJyA
	 nkGQKJYxjmJHPM99+WCJnJ6I4Ro+ng1ssEaTtb/eF9l3x1WSiOfhrr+kwgzgrSkBKteaV
	 aBkD3V+rvCTtReaHIjQAp4E3xVfKbSmup4F/wgCt4ZcA1H0oH/KjGfthBHIITBE2tcigX
	 ocXzgHlbhZ5wwgXQ/aZ1mm8FB8ftXVIxEwJ29GKls80h4flnLzBF95IpNaJd4rlNe3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D32Fm58N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529DC606A31E
	for <kvmarm@lists.linux.dev>; Tue, 24 Nov 2026 03:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D32Fm58N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FB21F000CA;
	Tue, 24 Nov 2026 03:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795489709;
	bh=O4IE7yAwwVBkJp/nfXVC6lFyH44O2sFZ3ZBiR3r14Ic=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D32Fm58N2kgXSM5D4+92rJus2iLfuRWv2g8g1INYjFaLh56PsTVGCjMk5NzsrCT1J
	 aSNh99SUu7mzr4IdL02iDR/ZJXHw5tOOadGX7j6+eWzIgXYmdNaRCTlxQ+Jb7PKuhu
	 +j6glcBnZ+NJfFANgf7mc9P2CJGKGZ3SvD31YJ8ew24jz+2l4RxL5qSqL/hBf77lIr
	 BktkOc4kHFdsYeZGQlwnxKfJ/VuCaA5Mg1c59tlclyjaHHo4xY1We3BnhQuqJge5Yu
	 Afc8MKA6fNPiYvRSds6ETDM5mFHsfLyRkNzvFB6Pga18KvoST2zXMb4K7LZJQhI86m
	 F8n0HQ8XyK9+w==
Message-ID: <sashiko-outbox-230439@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: nv: Allow the L1 VNCR page in cacheable
 PFNMAP memory
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jia He" <justin.he@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261124025336.4107575-1-justin.he@arm.com>
References: <20261124025336.4107575-1-justin.he@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 03:08:28 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: nv: vncr_pfn_is_cacheable() rejects read-only
  memslots
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] KVM: arm64: nv: unhandled -EPERM in kvm_handle_vncr_abort() [1]
--

commit 9fdd9f2ca0f89e14eb8d6921a8424af26dfde3e6
Author: Jia He <justin.he@arm.com>

KVM: arm64: nv: Allow the L1 VNCR page in cacheable PFNMAP memory

This commit allows the L1 VNCR page to reside in a cacheable VM_PFNMAP or
VM_MIXEDMAP VMA when the system supports cacheable PFNMAP mappings at
stage-2, matching the stage-2 fault path.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 78d5b18dbd2d6..85b97a888d71d 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1561,6 +1561,36 @@ static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
>  	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
>  }
> =20
> +/*
> + * Allow a non-memory PFN only if it comes from a cacheable VM_PFNMAP or
> + * VM_MIXEDMAP VMA, as for a stage-2 mapping. The VMA is looked up after=
 the
> + * PFN has been faulted in: the caller must check mmu_invalidate_retry()
> + * against a sequence count sampled before the fault-in.
> + */
> +static bool vncr_pfn_is_cacheable(struct kvm_memory_slot *memslot, gfn_t=
 gfn,
> +				  kvm_pfn_t pfn)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned long hva;
> +	bool ret =3D false;
> +
> +	if (pfn_is_map_memory(pfn))
> +		return true;
> +
> +	if (!kvm_supports_cacheable_pfnmap())
> +		return false;
> +
> +	hva =3D gfn_to_hva_memslot(memslot, gfn);
> +
> +	mmap_read_lock(current->mm);
> +	vma =3D vma_lookup(current->mm, hva);
> +	if (vma && (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
> +		ret =3D kvm_vma_is_cacheable(vma);
> +	mmap_read_unlock(current->mm);
> +
> +	return ret;
> +}

[Severity: Medium]
Does gfn_to_hva_memslot() reject a KVM_MEM_READONLY memslot here?

gfn_to_hva_memslot() assumes a write access and returns KVM_HVA_ERR_RO_BAD
when the memslot is read-only.  On a read access to an L1 VNCR page in a
read-only memslot backed by a cacheable VM_PFNMAP or VM_MIXEDMAP VMA,
__kvm_faultin_pfn() faults in the PFN with writable =3D false, but
vma_lookup() then looks up KVM_HVA_ERR_RO_BAD and returns NULL, causing
kvm_translate_vncr() to inject an SEA instead of installing a read-only
VNCR mapping as supported since 2684e02bac41 ("KVM: arm64: nv: Respect
read-only PFN when mapping L1 VNCR").  Using __gfn_to_hva_memslot() (or
gfn_to_hva_memslot_prot() as in kvm_handle_guest_abort()) would avoid
failing on read-only memslots.

> @@ -1633,12 +1663,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcp=
u, bool *is_gmem)
>  		writable =3D !(memslot->flags & KVM_MEM_READONLY);
>  	}
> =20
> -	/*
> -	 * FIXME: This check is too restrictive as KVM allows cacheable memory
> -	 * attributes for PFNMAP VMAs that have cacheable attributes in host
> -	 * stage-1.
> -	 */
> -	if (!pfn_is_map_memory(pfn)) {
> +	if (!vncr_pfn_is_cacheable(memslot, gfn, pfn)) {
>  		kvm_release_faultin_page(vcpu->kvm, page, true, false);
>  		fail_s1_walk(&vt->wr, ESR_ELx_FSC_EXTABT, false);
>  		return -EINVAL;

[Severity: High]
This problem wasn't introduced by this patch, but can
kvm_handle_vncr_abort() drop a pending SEA and loop forever when
kvm_translate_vncr() returns -EPERM [1]?

When hardware Access Flag updates (TCR_EL2.HA) are enabled for guest
EL2&0 and a stage-1 descriptor with PTE_AF =3D=3D 0 resides in a read-only
memslot, walk_s1() -> kvm_swap_s1_desc() -> __kvm_at_swap_desc() fails
with -EPERM and records ESR_ELx_FSC_SEA_TTW(level) in vt->wr.fst.
Because the switch statement in kvm_handle_vncr_abort() does not include
-EPERM in its fault-injection cases:

arch/arm64/kvm/nested.c:kvm_handle_vncr_abort() {
	...
	case -EFAULT:
	case -EIO:
	case -EHWPOISON:
		if (is_gmem)
			return 0;
		fallthrough;
	case -EINVAL:
	case -ENOENT:
	case -EACCES:
		/*
		 * Translation failed, inject the corresponding
		 * exception back to EL2.
		 */
		esr &=3D ~ESR_ELx_FSC;
		esr |=3D FIELD_PREP(ESR_ELx_FSC, vt->wr.fst);

		kvm_inject_nested_sync(vcpu, esr);
		break;
	...
}

KVM returns 1 without injecting the abort or mapping the VNCR page,
trapping the vCPU in an infinite VNCR abort loop.

[1] https://sashiko.dev/#/bug/linux-5a55db9b-f840-4142-8a1e-110e2882e8fa

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124025336.4107=
575-1-justin.he@arm.com?part=3D1
