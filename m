Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4715449365B
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 16:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787330721; cv=none; b=kbgEsk1bzH8JJTcdZOYCt76UhvnbjGADtTwN1U4FN/tBK0b6koKBEec/ePiSeHp6IQ4MpW3VozsAgwQav1gnMhV1YgfVS0uBBZln4bLllPF6ST/B9lIcGUITSP/SNPkn8XuVxQqnTQSt9IsYsv8CP6WHyoezrJHz4v+Y9rCRsd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787330721; c=relaxed/simple;
	bh=aKWVI94s8+wqi8uucHGr7KgSczvEWGrXXqsW5iwTHzM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WMmVz7HtZqkyqS4WZ268Gec52W8Xt9w8vxhfmLyDiqvjqUZmgZDdKcWOV2/E9l5hSaxfhJvzRGPWwtgcvHXEiyC//l/oiPp7AI/fTy80jZ5t3wliGgr2cWWQOwOsnXsyX1PiYj5fPRI0ZAFOmyP9KXO9BPlmP1foCRu2D5DCLM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OyY2nXJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OyY2nXJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF34A1F00A3A;
	Fri, 21 Aug 2026 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787330717;
	bh=zFDGPRVTEj7rtIbYu1og+0Izfs7VzrzRkxoA1MEqSfE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OyY2nXJ//0rb/6+QtDo4X4zp4E4snEgcg+7t7EJSzLujYAWgcHgs7WBXXNOmfqBW4
	 oiS5GR2PyWkonKPClZGlCy9cABL9ly4+3CWLZBX/VUM62AFoTR+BAQw5hAN949k84R
	 mL0mNFAytB6V0sKRpvC2H2ylFB9gEzXIEAZScgFI2KGBBKfa42j5x+2kSJ9gFLyNGD
	 1IxYlg3yg03AgF0/fzmHHZU4FsxTyEFmrMqYorJmkKMZoP6zYIS0Pc8wyd9+dabeJI
	 wA6+yIl5drD59rNgC04V+I0xfgsUgH5qXt00+hmLaKAYSGmNTTBmzU7aEy+ONQrRh1
	 GZANm5TU7exDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: nv: Delay freeing of shadow S2
 structures until VM destruction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260821161829.1032561-3-maz@kernel.org>
References: <20260821161829.1032561-1-maz@kernel.org>
 <20260821161829.1032561-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 16:45:17 +0000
Message-Id: <20260821164517.BF34A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Preserving nested MMU containers with freed page tables leads to N=
ULL pointer dereference.

Pre-existing issues:
- [High] Permanent memory leak of nested stage-2 page tables and per-CPU st=
ate on VM destruction.
- [High] Data race between lockless array iteration and array population ca=
uses uninitialized pointer dereference.
--

--- Patch [2]: [PATCH v3 2/2] KVM: arm64: nv: Delay freeing of shadow S2 st=
ructures until VM destruction ---
commit 46c2225152ae78e4009a13ad7c3bcc3e69fbab04
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: nv: Delay freeing of shadow S2 structures until VM destruction

We free the shadow S2 structures from kvm_arch_flush_shadow_all(), which
is a Bad Idea(tm). Freeing the page tables is fair game (this is what
this callback is for), but freeing the container that could still be
referenced by another part of the system is not great.

Instead, grow separate destructors that gets called when we tear the VM
down for good. From there, we can nuke both the individual MMUs as well
as the global array that points to them, safe in the knowledge that the
vcpus themselves have been destroyed already.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 9070d5bc5af03..bc2b58e583b52 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -56,6 +56,15 @@ int kvm_init_nested(struct kvm *kvm)
>  	return kvm->arch.nested_mmus ? 0 : -ENOMEM;
>  }
> =20
> +void kvm_destroy_nested(struct kvm *kvm)
> +{
> +	for (int i =3D 0; i < kvm->arch.nested_mmus_size; i+=3D S2_MMU_PER_VCPU)
> +		kvfree(kvm->arch.nested_mmus[i]);

[Severity: High]
This is a pre-existing issue, but does this loop permanently leak the nested
stage-2 page tables? The loop blindly calls kvfree() without first calling
kvm_free_stage2_pgd() to recursively free the page tables and per-CPU
allocations.

If a user creates a KVM VM, runs nested vCPUs to allocate stage-2 page tabl=
es,
and then closes the KVM file descriptor, the KVM VM teardown calls
kvm_destroy_nested(). Because it frees the container structures but forgets=
 to
call kvm_free_stage2_pgd(), the pgt and last_vcpu_ran allocations are
permanently leaked.

> +
> +	kvm->arch.nested_mmus_size =3D 0;
> +	kvfree(kvm->arch.nested_mmus);
> +}
> +
>  static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>  {

[ ... ]

> @@ -1311,16 +1320,12 @@ void kvm_nested_s2_flush(struct kvm *kvm)
> =20
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> -	for (int i =3D kvm->arch.nested_mmus_size - 1; i >=3D 0; i--) {
> +	for (int i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
>  		struct kvm_s2_mmu *mmu =3D kvm->arch.nested_mmus[i];
> =20
>  		if (!WARN_ON(atomic_read(&mmu->refcnt)))

[Severity: High]
This isn't a bug introduced by this patch, but can this lockless array
iteration race with array population and cause an uninitialized pointer
dereference?

While one thread executes KVM_ARM_VCPU_INIT and appends newly allocated MMU
pointers to the nested_mmus array under mmu_lock in kvm_vcpu_init_nested():

	for (i =3D 0; i < S2_MMU_PER_VCPU; i++)
		kvm->arch.nested_mmus[i + kvm->arch.nested_mmus_size] =3D &tmp[i];

	kvm->arch.nested_mmus_size +=3D S2_MMU_PER_VCPU;

Another process context (like OOM killer or thread exit) can trigger
mmu_notifier_release -> kvm_arch_flush_shadow_all().

kvm_arch_flush_shadow_all() iterates over nested_mmus reading
nested_mmus_size without mmu_lock or memory barriers. Because kvmalloc_objs
does not zero memory, the lockless reader can observe an incremented size b=
ut
a garbage pointer, causing a crash on atomic_read(&mmu->refcnt).

>  			kvm_free_stage2_pgd(mmu);

[Severity: High]
Since this patch now preserves the nested MMU containers, does this lead to=
 a
NULL pointer dereference?

The array elements are kept, but kvm_free_stage2_pgd(mmu) frees their page
tables and sets mmu->pgt to NULL. If an application shares a KVM VM file
descriptor across processes and the process holding the mm_struct exits, it
fires mmu_notifier_release -> kvm_arch_flush_shadow_all().

If the surviving process calls KVM_RUN, get_s2_mmu_nested() can reuse the
container since its refcnt is 0:

	s2_mmu =3D kvm->arch.nested_mmus[i % kvm->arch.nested_mmus_size];

	if (atomic_read(&s2_mmu->refcnt) =3D=3D 0)
		break;

However, because there is no logic to reallocate the missing page table tre=
e,
a subsequent stage-2 fault will dereference mmu->pgt, panicking the kernel.

> -
> -		if ((i % S2_MMU_PER_VCPU) =3D=3D 0)
> -			kvfree(mmu);
>  	}
> -	kvm->arch.nested_mmus_size =3D 0;
>  	kvm_uninit_stage2_mmu(kvm);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821161829.1032=
561-1-maz@kernel.org?part=3D2
