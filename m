Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CE9412276
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 16:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145077; cv=none; b=eDe2CdxQYpIA+Gns46cDze4eSkDVeurIyNkoL2HouiGm3//IYYAUuObYE7EYxsSaqxMa3OjlVz3BO39Ifec8ZXCAUptFjuqxE/MdLl/X/x5Mwl0OQzfBqeO1fV9MO89EeMElM05ASpfbL3Ql3HYj6I6jt6Ccmmb7WOzGXLVdbAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145077; c=relaxed/simple;
	bh=GG+gENUehx7lVq77d77dljTyol9fcXFYdOX/hdIgCQc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hCUnPotq6bvPjJ7wfqfjTMa0PpNz67EQxM49LNLMfZyLiyBb00e1vNw3s273h2ECrCauNLZHc9aN36sYyiScyZlUcRgPjYohsganVPqXumtAvjwLJM+p/PFD4/4BvQ748Bb+MTZ7nnVEvv6TSJUhwxCh6UqV6/ZR/fE+V5qSLoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxVfQZWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxVfQZWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F2D1F00893;
	Fri, 11 Sep 2026 16:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789145075;
	bh=ZpL804/XyJJQ4oNEzf5aqTvhDPDVi/tS9LB/+zZ4T00=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UxVfQZWgNZpRm+D9g2n7AcFhf35W9noiW0u+di8YCDujg3b5OuesihrdbqrVFPsq2
	 hu/ovJsjaiLSHCK6pdRgwo/NwrAiz8YTvZ67PD+A03rbpMG4FCxQhvfBpWWVHSHxzg
	 rHRHRs8sfTEaTh8HctBYchAnfhQl+0XI46wz5zBTKLQguclZoSVJooLDp7/Id85Hup
	 P/R6XyZ36KtOEx4gGigIMEjHyuRi/D8m+9K91RmavNcgPHV+MPcODmr7X9Z2RTA5dj
	 OpLF8dtngYcAPzgZSzzIHdBoGG4qBLsqf+dB/sFKbxn4gU2vAt5Jw7mJC4g4oZMNFI
	 KTsUCT0Ndr5qA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] KVM: arm64: nv: Fix life cycle of the
 nested_mmus array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260911162203.1919330-2-maz@kernel.org>
References: <20260911162203.1919330-1-maz@kernel.org>
 <20260911162203.1919330-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 16:44:34 +0000
Message-Id: <20260911164435.38F2D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Data race in `kvm_arch_flush_shadow_all()` leads to garbage pointe=
r dereference and kernel panic
--

commit 87dd1db0613c9f0d7e10bf7593d998a853fa1c02
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: nv: Fix life cycle of the nested_mmus array
   =20
This commit alters the life cycle of the nested_mmus array to allocate
an array of pointers at VM creation time. It avoids reallocation during
VCPU_INIT by sizing the array to the absolute maximum KVM can handle.

Link: https://lore.kernel.org/r/20260803224405.41468-1-kmehltretter@gmail.c=
om

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 3c4fc566eafc6..0a32d6bd3f6c6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -45,11 +45,15 @@ struct vncr_tlb {
>   */
>  #define S2_MMU_PER_VCPU		2
> =20
> -void kvm_init_nested(struct kvm *kvm)
> +int kvm_init_nested(struct kvm *kvm)
>  {
> -	kvm->arch.nested_mmus =3D NULL;
> +	kvm->arch.nested_mmus =3D kvmalloc_objs(struct kvm_s2_mmu *,
> +					      KVM_MAX_VCPUS * S2_MMU_PER_VCPU,
> +					      GFP_KERNEL_ACCOUNT);

[Severity: High]
Does this allocation leave the pointer array filled with uninitialized memo=
ry?
Using kvmalloc_objs() without GFP_ZERO or __GFP_ZERO (or instead of
kvzalloc_objs()) means the array might contain garbage pointers rather than
being safely zeroed out.

[ ... ]
> +		guard(write_lock)(&kvm->mmu_lock);
> =20
> -		for (int i =3D 0; i < kvm->arch.nested_mmus_size; i++)
> -			tmp[i].pgt->mmu =3D &tmp[i];
> +		for (i =3D 0; i < S2_MMU_PER_VCPU; i++)
> +			kvm->arch.nested_mmus[i + kvm->arch.nested_mmus_size] =3D &tmp[i];
> =20
> -		swap(kvm->arch.nested_mmus, tmp);
> -
> -		write_unlock(&kvm->mmu_lock);
> -
> -		kvfree(tmp);
> -	}
> +		kvm->arch.nested_mmus_size +=3D S2_MMU_PER_VCPU;

[Severity: High]
Could a CPU or compiler reorder this size increment to be visible before
the pointer stores are complete? This block updates the array and size
without memory barriers to order them.

[ ... ]
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> -	int i;
> -
> -	for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
> -		struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
> +	for (int i =3D kvm->arch.nested_mmus_size - 1; i >=3D 0; i--) {
> +		struct kvm_s2_mmu *mmu =3D kvm->arch.nested_mmus[i];
> =20
>  		if (!WARN_ON(atomic_read(&mmu->refcnt)))

[Severity: High]
Can this lockless read of the array encounter a garbage pointer?

If kvm_arch_flush_shadow_all() is called concurrently with
kvm_vcpu_init_nested() (for example, if userspace calls KVM_ARM_VCPU_INIT
while concurrently terminating the process and triggering
mmu_notifier_release()), it might read the newly incremented
nested_mmus_size before the actual pointers are stored.

Because the initial array allocation in kvm_init_nested() used
kvmalloc_objs() without zeroing, the unwritten slots contain uninitialized
memory. Reading a garbage pointer and dereferencing it here in
atomic_read() could allow an unprivileged userspace process to cause a
kernel panic. Pre-patch, the array elements were safely zero-initialized.

I notice a later patch in this series (Patch 2) removes the
kvm->arch.nested_mmus_size =3D 0 assignment but retains this same lockless
loop in kvm_arch_flush_shadow_all(), which appears to leave this garbage
pointer dereference risk unfixed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911162203.1919=
330-1-maz@kernel.org?part=3D1
