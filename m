Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634639;
	b=pVdOsnLewMWkBG6aepaw9OdPt4KMATzXcIXIR7el7X5JgMU/l2EL3OBs2gBimfNuyD73
	 YQ/qsRHLr2h4RA69pfcZqF5K9tiAYvYgT18fA/Ai1I4ogiM24OvRW+JtlxJXaNf3ltaMX
	 CGnKkxPwbYsFBHFSBQGePrsJflT8gi8Gr/BnZHwd2J3VEOAGF5a2iVAvN673Jp960qgaG
	 4U+lmtw/HSy7rp2yVhlGltYx+daQJWh6O0bju4eaXEvwBmZuQSmytbj906shNTVIzL4r/
	 PzjX4UNMXEJyMQyex3cXce6tCsUDYJ7e/OxWPgLCDiugjHwUJlOZvGiq0iG6524Mw9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634639;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oJOlbfrbq+QWTTG2303HNnGFWzN3n3+4lbjaPeEbYCM=;
	b=GFQHATz6QDAU5hg4VD25jyJNpY2OBLF6dgVACJ8Sae+IUkYs5a1Kfkn3ke/gklN69Ky5
	 dkOrM/M2tRaTNiuMyjoqzpJWLZOs4k2x4xBAaq7muJ63YV4ESui8xcbkrbTJMNENIzGvM
	 XB7phl4Gxa9hcGNJiImRMryPbVN3UVZG7DvLZKuriQT8Vxhqy7g46XJKGFZKswvJCKq55
	 Y2AwVKx8Ibjkx3O5dxDS1XJYegpU0qgqCq7HUvzEImRjXOzObAEvYsFd9wwolXj4pOYhH
	 UB0XFoifK7WN4q+XcIM7vWGCoVmSTpGM09ZHQT32oULd7mUewaYWlocsHH+WI0BXCgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCFNvtb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698E7607991C;
	Mon,  2 Nov 2026 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PCFNvtb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFF41F00A16;
	Mon,  2 Nov 2026 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793634639;
	bh=oJOlbfrbq+QWTTG2303HNnGFWzN3n3+4lbjaPeEbYCM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PCFNvtb7ZVvwG/E1wyuDeo3kJBLodo8FVaM6FZEyp+4jgdeyc+DmL0QtgHaEjL5bL
	 zPJjFZHGT7wlQnGAgd6CFkRKT3R7qEmT5IYAYNHwHYyFUZxtT1oFMBwblWZ7fBjPZ1
	 wlHBj56CmyrqPpehcSgHhec1/guodkBbH0KABs30iCMOKNOGsyiIn8WmHNkKumYFrs
	 SzZF4ImiJXYxud+hab5gA3sTCMxFhaanLxdps9SQ/9ji4Gm75h2MPMIo41xg+vt5E9
	 Jvp/6dfCWlwtkRpBroE425M2+D0u605indvgNkcHVwH4T5JwZDWl/mM4vDzw3oUtY1
	 r59qVCLpZg3og==
Message-ID: <sashiko-outbox-193708@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/11] KVM: arm64: CCA: Prevent memslot modifications
 after Realm creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102141304.126883-10-steven.price@arm.com>
References: <20261102141304.126883-1-steven.price@arm.com>
 <20261102141304.126883-10-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 15:50:38 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM: arm64: CCA: guest_memfd memslot delete rejected after Stage-2=
 unmap
--

commit 5106402397c36eec1e5fa59a5bb2c5adf4ee2aa8
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: CCA: Prevent memslot modifications after Realm creation

This commit updates kvm_arch_prepare_memory_region() to disallow creating,
modifying, or deleting guest_memfd-backed memslots once a Realm has been
created.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 51fda7b2ff7f3..eb8c5f9e9791d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2862,13 +2862,28 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
>  	    (new->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)))
>  		return -EPERM;
> =20
> -	if (kvm->arch.vm_flavor =3D=3D VM_PROTECTED_PKVM) {
> +	switch (kvm->arch.vm_flavor) {
> +	case VM_PROTECTED_PKVM:
>  		/* Cannot modify memslots once a pVM has run. */
>  		if (pkvm_hyp_vm_is_created(kvm) &&
> -		    (change =3D=3D KVM_MR_DELETE || change =3D=3D KVM_MR_MOVE)) {
> +		    (change =3D=3D KVM_MR_DELETE || change =3D=3D KVM_MR_MOVE))
>  			return -EPERM;
> -		}
> +		break;
> +	case VM_REALM:
> +		/*
> +		 * Once the Realm is created, we cannot modify any slots that
> +		 * could be providing private memory. i.e., guest_memfd backed
> +		 * slots.
> +		 * TODO: Handle trusted device private memory slots
> +		 */
> +		if (!kvm_realm_is_created(kvm))
> +			break;
> =20
> +		if (kvm_slot_has_gmem(old) || kvm_slot_has_gmem(new))
> +			return -EPERM;

[Severity: High]
Does checking kvm_slot_has_gmem(old) in kvm_arch_prepare_memory_region() run
too late to prevent Stage-2 unmapping when deleting a guest_memfd-backed
memslot on a created Realm?

In virt/kvm/kvm_main.c:kvm_set_memory_region(), non-delete changes
(KVM_MR_MOVE and KVM_MR_FLAGS_ONLY) on KVM_MEM_GUEST_MEMFD memslots are
already rejected upfront with -EINVAL, so kvm_slot_has_gmem(old) is reached
here when change =3D=3D KVM_MR_DELETE.

However, in virt/kvm/kvm_main.c:kvm_set_memslot(), KVM invalidates and
flushes the old memslot before calling kvm_prepare_memory_region():

virt/kvm/kvm_main.c:kvm_set_memslot() {
	if (change =3D=3D KVM_MR_DELETE || change =3D=3D KVM_MR_MOVE) {
		invalid_slot =3D kzalloc_obj(*invalid_slot, GFP_KERNEL_ACCOUNT);
		if (!invalid_slot) {
			mutex_unlock(&kvm->slots_arch_lock);
			return -ENOMEM;
		}
		kvm_invalidate_memslot(kvm, old, invalid_slot);
	}

	r =3D kvm_prepare_memory_region(kvm, old, new, change);
	if (r)
		goto err;
}

kvm_invalidate_memslot() marks the active slot as KVM_MEMSLOT_INVALID and
calls arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot():

arch/arm64/kvm/mmu.c:kvm_arch_flush_shadow_memslot() {
	write_lock(&kvm->mmu_lock);
	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
	kvm_nested_unmap_cipa_range(kvm, gpa, size, true);
	write_unlock(&kvm->mmu_lock);
}

For a Realm VM, kvm_stage2_unmap_range() invokes
arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() with
KVM_FILTER_PRIVATE | KVM_FILTER_SHARED:

arch/arm64/kvm/rmi.c:kvm_realm_unmap_range_filter() {
	if (attr_filter & KVM_FILTER_SHARED)
		realm_unmap_shared_range(kvm, start, end, may_block);
	if (attr_filter & KVM_FILTER_PRIVATE)
		realm_unmap_private_range(kvm, start, end, may_block);
}

By the time kvm_arch_prepare_memory_region() returns -EPERM and
kvm_set_memslot() restores the old memslot in the error path, hasn't
realm_unmap_private_range() already unmapped and undelegated the Realm's
private Stage-2 DATA granules across the memslot's GPA range?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102141304.1268=
83-1-steven.price@arm.com?part=3D9
