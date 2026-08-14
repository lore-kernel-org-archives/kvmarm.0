Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4EC33F5BF
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 11:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786707299; cv=none; b=VC+1bMS8kmANP8XqG34GCm8PO+/jgGBm0Fobq2E1zlzz6y+C/k+n0h29UHDnuhqssHQ3vOCR2jkprlyMAX+2Z2qbYbt2LVDAOStptaZzEUJePbkXEHK791mAh8BRlrRpi6u1UlDmDTs9aV26dpElGwvERZg6GWhsA5V5SBfL15g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786707299; c=relaxed/simple;
	bh=5OZAxMaI6Fd4IW5TIco3ZsR+RxUNfRmXsdWDoJQfDhA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=X6z/aPcAG4vyPRRaUAbawsAS54hyraZaGtss2AFmCcY+t8JSjcrsE2ZxzCMVauwHyqTIpl4khG1s2YjqwTbLvrC9GuayMbpjIuaTB88L5qDCuutCYFfoisxkeiSC5+drcl8rEVwe7kJgEJz8jcAtfTEE93vxndZiGorP7PojGFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e1ZMMwl7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e1ZMMwl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF761F000E9;
	Fri, 14 Aug 2026 11:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786707295;
	bh=w6KdmCvA7dCNLO8bs7T27wC2iXtLMq391QHT8mkTjzc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e1ZMMwl7esDoS//GKDTm6e1Oz7vFhLl3lNcEAUEBeKXGsjoguIDT/MEMSsfdOuwXf
	 fSnCuS5lnGNLuvKU/DzLTYbEmT1VFydBjlD12HtHlIeDUHRnZD4FmimCsR9/irA+Xn
	 vlzAi5KX2gLLmZltJaX3kp5OTQu3xIhbfR2jAVWsnpKdZdcGzOf9ze1cCasU4iCaSh
	 65Xn4MW2EGTI7No+rg4LY7CTEwp2jpaqEnK86l804kVZVVPeDb1+UiurpdUHO8VbyU
	 RF0YGxFipJqCosGy30Mpdi60FIXntGlCsGBfe6Lfzfcqu7prCFhl/kW3FiWR0fjIxQ
	 d0yvDOEu8htjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: nv: Fix life cycle of the
 nested_mmus array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260814103230.858578-2-maz@kernel.org>
References: <20260814103230.858578-1-maz@kernel.org>
 <20260814103230.858578-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 11:34:55 +0000
Message-Id: <20260814113455.8CF761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Graceful VM teardown permanently leaks dynamically allocated `stru=
ct kvm_s2_mmu` chunks.
- [High] Post-flush nested vCPU initialization enforces constrained allocat=
ions, exhausting MMU slot limits.
- [Low] `kvmalloc_array` utilizes the undefined `struct s2_mmu *`.

Pre-existing issues:
- [High] `kvm_arch_flush_shadow_all` unconditionally frees `s2_mmu` memory =
chunks actively in use by running vCPUs, causing a Use-After-Free.
- [High] Lockless reading of `nested_mmus_size` leads to data races and uni=
nitialized pointer dereferences.
- [High] Uninitialized local pointer dereference in `get_s2_mmu_nested()` i=
f `nested_mmus_size` is 0.
--

--- Patch [1]: [PATCH v2 1/2] KVM: arm64: nv: Fix life cycle of the nested_=
mmus array ---
commit dd101263b02fbf52d5928987d4961bdef4c31086
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: nv: Fix life cycle of the nested_mmus array

This commit changes the nested_mmus array from an array of structures
to an array of pointers allocated at VM creation. It updates the
allocation and freeing lifecycle for nested stage-2 MMU structures to
prevent use-after-free conditions during array resizing.

Link: https://lore.kernel.org/r/20260803224405.41468-1-kmehltretter@gmail.c=
om

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c

[ ... ]

> @@ -337,6 +340,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> =20
>  	kvm_unshare_hyp(kvm, kvm + 1);
> =20
> +	kvfree(kvm->arch.nested_mmus);

[Severity: High]
Does kvm_arch_destroy_vm() permanently leak the MMU chunks dynamically
allocated in kvm_vcpu_init_nested()?

Since kvm_arch_flush_shadow_all() is tied to the MMU notifier release
path and runs upon process exit, a graceful teardown that simply
closes the VM file descriptor wouldn't necessarily trigger it. This
could leave the struct kvm_s2_mmu chunks orphaned because only the
pointer array is being freed here.

>  	kvm_arm_teardown_hypercalls(kvm);
>  }
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
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
> +	kvm->arch.nested_mmus =3D kvmalloc_array(KVM_MAX_VCPUS * S2_MMU_PER_VCP=
U,
> +					       sizeof(struct s2_mmu *),
> +					       GFP_KERNEL_ACCOUNT);

[Severity: Low]
Should this be sizeof(struct kvm_s2_mmu *) instead of
sizeof(struct s2_mmu *)? Even though the pointer size evaluates to the
same number of bytes, it appears to reference an undefined structure name
which might bypass compiler type checking.

>  	kvm->arch.nested_mmus_size =3D 0;
>  	atomic_set(&kvm->arch.vncr_tlb_count, 0);
> +
> +	return kvm->arch.nested_mmus ? 0 : -ENOMEM;
>  }

[ ... ]

> @@ -70,8 +74,9 @@ static int init_nested_s2_mmu(struct kvm *kvm, struct k=
vm_s2_mmu *mmu)
>  int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm =3D vcpu->kvm;
> -	struct kvm_s2_mmu *tmp;
> -	int num_mmus, ret =3D 0;
> +	int num_mmus;
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);

[ ... ]

>  	num_mmus =3D atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
> =20
>  	if (num_mmus > kvm->arch.nested_mmus_size) {
> -		tmp =3D kvcalloc(num_mmus, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
> -		if (!tmp)
> -			return -ENOMEM;
> +		struct kvm_s2_mmu *tmp;
> +		int i, ret =3D 0;
> =20
> -		write_lock(&kvm->mmu_lock);
> -
> -		if (kvm->arch.nested_mmus_size) {
> -			memcpy(tmp, kvm->arch.nested_mmus,
> -			       size_mul(sizeof(*tmp), kvm->arch.nested_mmus_size));
> +		tmp =3D kvcalloc(S2_MMU_PER_VCPU, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
> +		if (!tmp)
> +			ret =3D -ENOMEM;

[Severity: High]
Does this under-provision the nested MMUs if a concurrent flush resets
nested_mmus_size to zero?

If nested_mmus_size is reset out-of-band by a flush, a subsequent vCPU
initialization will detect the deficit but only allocate S2_MMU_PER_VCPU
entries rather than the full num_mmus requirement. This could quickly
exhaust the under-provisioned pool when multiple vCPUs become active,
eventually triggering the fallback BUG_ON in get_s2_mmu_nested().

[ ... ]

> +		guard(write_lock)(&kvm->mmu_lock);
> =20
> -		for (int i =3D kvm->arch.nested_mmus_size; i < num_mmus; i++)
> -			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
> +		for (i =3D 0; i < S2_MMU_PER_VCPU; i++)
> +			kvm->arch.nested_mmus[i + kvm->arch.nested_mmus_size] =3D &tmp[i];
> =20
> -		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
> -		vcpu->arch.ctxt.vncr_array =3D NULL;
> +		kvm->arch.nested_mmus_size +=3D S2_MMU_PER_VCPU;
>  	}

[Severity: High]
This is a pre-existing issue, but does locklessly reading
nested_mmus_size risk dereferencing uninitialized pointers?

Because kvm_arch_flush_shadow_all() reads nested_mmus_size locklessly
(holding only the SRCU read lock) without memory barriers, the reader
could observe the incremented size before the pointer stores into the
nested_mmus array are actually visible. Could this result in a
dereference of uninitialized memory when reading the refcnt during a
flush?

> =20
> -	kvm->arch.nested_mmus_size =3D num_mmus;
> -
>  	return 0;
>  }

[ ... ]

> @@ -823,7 +817,7 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kv=
m_vcpu *vcpu)
>  	for (i =3D kvm->arch.nested_mmus_next;
>  	     i < (kvm->arch.nested_mmus_size + kvm->arch.nested_mmus_next);
>  	     i++) {
> -		s2_mmu =3D &kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> +		s2_mmu =3D kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];
> =20
>  		if (atomic_read(&s2_mmu->refcnt) =3D=3D 0)
>  			break;
>  	}
>  	BUG_ON(atomic_read(&s2_mmu->refcnt)); /* We have struct MMUs to spare */

[Severity: High]
This is a pre-existing issue, but can this dereference an uninitialized
local pointer if nested_mmus_size is zero?

If a vCPU attempts to execute nested code and requests a stage-2 MMU
after kvm_arch_flush_shadow_all() has reset nested_mmus_size to 0, the
search loop evaluates to false immediately. This bypasses the loop
entirely, leaving the local variable s2_mmu uninitialized when it reaches
this BUG_ON() check.

[ ... ]

> @@ -1317,16 +1311,15 @@ void kvm_nested_s2_flush(struct kvm *kvm)
> =20
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
>  			kvm_free_stage2_pgd(mmu);
> +
> +		if ((i % S2_MMU_PER_VCPU) =3D=3D 0)
> +			kvfree(mmu);

[Severity: High]
This is a pre-existing issue, but does unconditionally freeing
the MMU chunk risk a use-after-free?

While the code checks if the refcnt is zero before freeing the stage-2 PGD,
the kvfree(mmu) call happens unconditionally here. If a concurrent vCPU is
actively executing nested context code and holds a reference to the MMU,
freeing the memory backing the struct kvm_s2_mmu could result in a
use-after-free.

>  	}
> -	kvfree(kvm->arch.nested_mmus);
> -	kvm->arch.nested_mmus =3D NULL;
>  	kvm->arch.nested_mmus_size =3D 0;
>  	kvm_uninit_stage2_mmu(kvm);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814103230.8585=
78-1-maz@kernel.org?part=3D1
