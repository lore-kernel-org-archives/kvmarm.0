Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C433859D7
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284983; cv=none; b=ZhfuMxCOQU+nNpGueeqvYFAI2kUFKqpRXesxps1qTupUE/kVvRr9mZh5Bhl4fCSBZxuLvb3IH5f6QNBIyOD/qCd2H8CXHKcDFIrTbZQcaWhCPPEVPiyijxh7kwf6OxKgNQhjL4b8IQb6e1IncEn07Fsire6YrchsPwvmJKJW0Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284983; c=relaxed/simple;
	bh=uRRWdsj51B820Gczod5sWqyhLrhJ5vHljEkXypJTDP0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JYX9CAf3st/F+PstaxFq3hq1X2Fei3eWXujzGb3C2zNHtKbZs4uHC6Y8e9/Z3gCmaXw2PG12YzEYPzAcQjUaLnE4xb7+H11MAqoKNdac0nFpXczLRbJheN7qOGY7jYwhff2DfUbaa0eZkFdT119M+SvzwtZWQUiCga0XFVsAeSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9THwPp7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9THwPp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C56A1F000E9;
	Tue,  1 Sep 2026 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788284981;
	bh=B1aBo4wXYAeCeFOBAxYYyRjYs7NTs4VWntb21U8qHts=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z9THwPp7aE3Q7pLj9wAPDlOLjlYQC9V/dDXM4lcB9cvywfX2oJJ2gWylBbEZmREzg
	 qO/8z7PrXqCUJlCUJRLAFv9GnLVcgvxHrrtJg34N4EiWuDyjGTG5gd4THY5apLKFX8
	 ROGZW41P/iJKo7dsbz4gTzBVtS+dSdFr+DCMrP70HfqtIFhAFpJ9+LAh8vqcCu+P7C
	 xso6jpWJMwUv3hRpoNb/2twXuI2ic0iovkfgFDDW8OwHTCpYBGwSOcFE9SThRDuOyb
	 cJciyTqKEmmPKm6ppgxunEbTye8C/EDBrhAjBeDfmRSpJWG3RfXMT+KjWDBv8cONM/
	 L5blA3MXbv11A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on
 migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901171558.2674031-6-leo.bras@arm.com>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-6-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 17:49:41 +0000
Message-Id: <20260901174941.7C56A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] Data race and TOCTOU on `kvm->arch.mmu.vtcr` between vCPU setu=
p and memslot updates, breaking dirty logging.
- [High] Missing context-wide TLB invalidation after modifying `VTCR_EL2.HD=
` results in hardware bypassing write-protection.
- [High] Disabling HAFDBS globally for dirty logging causes massive perform=
ance degradation on non-logging memslots due to unnecessary permission faul=
ts.
- [Low] Unreachable `KVM_MR_DELETE` check inside `log_dirty_pages` block.
--

commit 54d7950cd735bc1edc3a9503d03ebffb8e6ca046
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Enable HAFDBS for guests not on migration

This patch enables hardware management of access and dirty bits (HAFDBS)
for KVM guests on arm64 when dirty logging is disabled. It modifies
vCPU setup and memslot commit paths to dynamically toggle VTCR_EL2.HD
based on the presence of dirty-logged memslots.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1e528d53d0931..76aebaa95cdab 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

[ ... ]

> @@ -1683,6 +1683,13 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
>  	if (!ret && vcpu_has_nv(vcpu))
>  		ret =3D kvm_vcpu_init_nested(vcpu);
> =20
> +	/* Enable HAFDBS by default if VHE && !nested  */
> +	if (kvm_supports_hafdbs(kvm) &&
> +	    atomic_read(&kvm->nr_memslots_dirty_logging) =3D=3D 0)
> +		kvm->arch.mmu.vtcr |=3D VTCR_EL2_HD;
> +	else
> +		kvm->arch.mmu.vtcr &=3D ~VTCR_EL2_HD;
> +

[Severity: Critical]
Does this read-modify-write of kvm->arch.mmu.vtcr (holding config_lock)
create a data race against kvm->slots_lock?

In kvm_set_hafdbs() below, this same variable is modified while holding
kvm->slots_lock. If userspace concurrently initializes vCPUs and enables
dirty logging, VTCR_EL2_HD could be incorrectly left at 1. This would cause
the hardware to silently update dirty bits without trapping, bypassing
software dirty logging and resulting in lost dirty pages during migration.

>  	return ret;
>  }

[ ... ]

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9d4f70430bbea..94094ab56d90f 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1989,7 +1989,8 @@ static int kvm_s2_fault_compute_prot(const struct k=
vm_s2_fault_desc *s2fd,
>  	if (s2vi->map_writable) {
>  		*prot |=3D KVM_PGTABLE_PROT_W;
> =20
> -		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
> +		if (s2vi->device ||
> +		    !(memslot_is_logging(s2fd->memslot) || kvm_supports_hafdbs(kvm)) ||
>  		    kvm_is_write_fault(s2fd->vcpu))
>  			*prot |=3D KVM_PGTABLE_PROT_DIRTY;

[Severity: High]
Can checking the static capability kvm_supports_hafdbs() here instead of
the dynamic vtcr state starve non-logging slots of the software fallback?

When dirty logging is enabled on one memslot, kvm_set_hafdbs() disables
VTCR_EL2.HD globally. However, if a guest writes to an unrelated
non-logging slot that was mapped writable-clean, won't the hardware now
generate a stage-2 permission fault?

This could cause performance degradation across the entire VM whenever any
single memslot (like a VGA framebuffer) enables dirty logging.

[ ... ]

> @@ -2577,6 +2578,20 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
>  	return err;
>  }
> =20
> +static void kvm_set_hafdbs(struct kvm *kvm, bool set)
> +{
> +	/* Check if no action required */
> +	if (!!(kvm->arch.mmu.vtcr & VTCR_EL2_HD) =3D=3D set)
> +		return;
> +
> +	if (set)
> +		kvm->arch.mmu.vtcr |=3D VTCR_EL2_HD;
> +	else
> +		kvm->arch.mmu.vtcr &=3D ~VTCR_EL2_HD;

[Severity: Critical]
Does modifying kvm->arch.mmu.vtcr here under kvm->slots_lock race against
the unprotected updates in kvm_setup_vcpu() as noted above?

> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);

[Severity: High]
Is KVM_REQ_RELOAD_STAGE2 sufficient here to ensure the hardware observes
the changed VTCR_EL2 state?

The ARM architecture permits translation regime registers like VTCR_EL2 to
be cached in the TLB (or a context cache). Modifying this register
typically requires a full VMID TLB invalidation (like calling
kvm_flush_remote_tlbs(kvm)) to guarantee global visibility.=20

Without it, the CPU might continue using cached translations with HD=3D1 in
the write-protected memslot, silently bypassing write-protection.

> +}
> +
>  void kvm_arch_commit_memory_region(struct kvm *kvm,
>  				   struct kvm_memory_slot *old,
>  				   const struct kvm_memory_slot *new,
> @@ -2594,6 +2609,10 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  		if (change =3D=3D KVM_MR_DELETE)
>  			return;

[Severity: Low]
Is this KVM_MR_DELETE condition reachable?

The log_dirty_pages variable checked just before this is initialized as
'new && new->flags & KVM_MEM_LOG_DIRTY_PAGES'. During a KVM_MR_DELETE
change, the 'new' parameter passed into kvm_arch_commit_memory_region() is
strictly NULL. Therefore, log_dirty_pages will always be false for
deletes, making this nested check dead code.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901171558.2674=
031-1-leo.bras@arm.com?part=3D5
