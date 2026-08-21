Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11CC493643
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 16:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787330890; cv=none; b=SqwolrxmTHP+A2WAGJKGf5h1A2jUhMoGWo4iZQEZ4FzYhqubb7sMcNk03GHshUV5o4x6u3lgCICi1ne8YCZCW3IroNYIhUa0J7gMDg84siwapwhjJwvxhWFTqiecIuUOSDljMlGB2JhJW/P0pt6f2MaRoSSSRaDDhoWAWF3Gt64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787330890; c=relaxed/simple;
	bh=l+/JZM6YlY80lsf3XCYiacBbrEwSMhPzqhN12S08cq8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=THfGFuBKTMFHSD5brF+2H+ZDNWIoJ8AVaa5IbIJ85iKb16QkZGrO1rypr9tDKhMMZLRoIlayHyB0HUkqr/1qSN7kJIyZIBJtorZfJeP6tKpJpy41+G380US4Mg2ydFelKyIhWsHmQd/wli9/72sMM0/LZ+hv7Kg9QuSx0n9ayXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+H1c3hz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+H1c3hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A591F00AC4;
	Fri, 21 Aug 2026 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787330888;
	bh=ZQ+lRE9P7H7U822iD51CvsdQSs1Y1PVZLTVpBZ/kjuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I+H1c3hzTLqMYTd1N4n17Ahff7UXHpyqux8hbC4SXa8yP5043jG5LmyVq20msmn95
	 8InbxxQ55jfOBsjnOR6LtU78iXjrIlSbAfFO+LL8++fDXI/3SM+oaPv1Pc74Kpljpp
	 iU88xYDrfvh7EB1AH6WYDAbsuHZfPXBEDNNzYBztxFAr8uEZBe1jCciPCLIPlYc7PZ
	 TMJ3EH65ovFdTEy4/uhUV4ex1blI6OLhz/LaqvM4+0Fs2K30GhBxoiL4N7EanRz8Kw
	 w6JLkSj6b3ov8/Y/BA6iczxIGWTxxFZ/mYydGLNAzq0fA5OSKvgextQU4qbAH6oykq
	 b83jYEFExihVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: nv: Fix life cycle of the
 nested_mmus array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260821161829.1032561-2-maz@kernel.org>
References: <20260821161829.1032561-1-maz@kernel.org>
 <20260821161829.1032561-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 16:48:08 +0000
Message-Id: <20260821164808.78A591F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Lockless iteration in `kvm_arch_flush_shadow_all` races with `kvm_=
vcpu_init_nested`, causing a garbage/NULL pointer dereference.

Pre-existing issues:
- [High] Memory leak of nested MMU stage-2 page tables (`mmu->pgt`) and per=
-CPU data when VM is destroyed after `mmu_notifier_release` has been bypass=
ed.
--

--- Patch [1]: [PATCH v3 1/2] KVM: arm64: nv: Fix life cycle of the nested_=
mmus array ---
commit 2f4c64e5fe4ce7a7346ea83c7e69ecaa68ee9290
Author: Marc Zyngier <maz@kernel.org>
Date:   Fri Aug 21 16:18:28 2026 +0000

    KVM: arm64: nv: Fix life cycle of the nested_mmus array
   =20
This commit modifies the life cycle of the nested_mmus array by turning it=
=20
from an array of structures into an array of pointers allocated at VM creat=
ion.=20
It prevents issues where reallocation during VCPU_INIT could leave running=
=20
vCPUs with freed pointers, ensuring S2 MMUs are incrementally allocated wit=
hout=20
reallocation.

Link: https://lore.kernel.org/r/20260803224405.41468-1-kmehltretter@gmail.c=
om

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 8b080804bc90b..b53219e048bdf 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> @@ -337,6 +340,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
> =20
>  	kvm_unshare_hyp(kvm, kvm + 1);
> =20
> +	kvfree(kvm->arch.nested_mmus);

[Severity: High]
This is a pre-existing issue, but does this teardown path leak the nested M=
MU=20
stage-2 page tables?

When a VM file descriptor is shared with a child process and the parent exi=
ts,
the parent's exit_mmap() calls mmu_notifier_release() which unhashes the
notifier. If the child process then initializes vCPUs, it allocates new nes=
ted
MMU PGDs via init_nested_s2_mmu().

When the child exits, kvm_arch_destroy_vm() is called. Because the notifier=
 is
already unhashed, it bypasses the release callback, skipping
kvm_arch_flush_shadow_all().

Since the cleanup path fails to call kvm_free_stage2_pgd() for the MMUs bef=
ore
freeing the nested_mmus array, the page tables (mmu->pgt) and per-CPU
allocations (mmu->last_vcpu_ran) appear to be permanently leaked.

>  	kvm_arm_teardown_hypercalls(kvm);
>  }
> =20
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 17123f0b6daba..9070d5bc5af03 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -84,51 +89,40 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
[ ... ]
> +		guard(write_lock)(&kvm->mmu_lock);
> =20
> -		for (int i =3D kvm->arch.nested_mmus_size; i < num_mmus; i++)
> -			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
> +		for (i =3D 0; i < S2_MMU_PER_VCPU; i++)
> -		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
> -		vcpu->arch.ctxt.vncr_array =3D NULL;
> +			kvm->arch.nested_mmus[i + kvm->arch.nested_mmus_size] =3D &tmp[i];
> =20
> -		return ret;
> +		kvm->arch.nested_mmus_size +=3D S2_MMU_PER_VCPU;

[Severity: High]
Could this result in a data race on weakly ordered architectures?

Here in kvm_vcpu_init_nested(), nested_mmus_size is incremented immediately
after storing the new MMU pointers in the array. Since there are no memory
barriers between the pointer stores and the size increment, the CPU could
reorder the size increment to be visible before the array elements.

If kvm_arch_flush_shadow_all() concurrently iterates over the array lockles=
sly
(for example, during process exit via mmu_notifier_release), it could read =
the
updated size but observe uninitialized array memory. This would result in
reading a garbage pointer, leading to a kernel panic when it dereferences it
in atomic_read(&mmu->refcnt).

>  	}
> =20
> -	kvm->arch.nested_mmus_size =3D num_mmus;
> -
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821161829.1032=
561-1-maz@kernel.org?part=3D1
