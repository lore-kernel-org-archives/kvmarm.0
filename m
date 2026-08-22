Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3263F13FEE
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787421959; cv=none; b=lqADQho5cTlJWDd9aa1Vk6gwu8Ag9sp0URw4jjAwsVFOroWUS8FMGMdLIJhsmBfSopxwXZw41my1MM4AJz/S37JoOSgWV5se01vnQX6lsV2Pgp4uuiER6KP66zVoCbZb0rFRQ7uQfQItZToznX2Y0lpUZ0OWy+ZwcQ1rYWbudyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787421959; c=relaxed/simple;
	bh=y1j4qPrluxEJvol0cdNHaCvOmrJrs51L8OSd9mm31/Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RSeqOpSRcWwa/CYwDWW8GzP0eB+LeOfCdFjNJDzw4INX5RiJAfriG4KmmDBu3fcTYlIE7ddXq474rw+TXBcpwKTeWxI+MU8On+wN9tb6oCwH1XGHK6poDg5xnCXbkG4i5lil1s0qGq+VMMxZobEc/aTBx2TzhvErqW98bIIrQzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hPbFdmXg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hPbFdmXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762691F000E9;
	Sat, 22 Aug 2026 18:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787421957;
	bh=5jrs9/RbwrK1svYvQQwxIQ2Jo2/cfDeBhmZKdKYyHpw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hPbFdmXgOd9qig5I25jiVR7IKTk1CBSNfF/14wJ6RgA9otNJ9NrtVdIWa4kXkD0Jz
	 cBUztpjyXLB4MoWgvhhGoE0WwUACJl0QV3+I05rFVdsLd5G0uxmORVBUcABiRKU5yF
	 M02cKG7idLhlGLZDFlQYiOwBuGQm2kcMEK21faCa+4uB5NCPk3h1g8qL+WzFfUKlsX
	 tpD4E48U/87kewiHTW0GuHhohjhy1dE/a9t9qRHBcsWWfOJLrtBEHNFMjDgH6XJFPN
	 N3OntQLJ2LmDyZ1p9rDsqqwX02F6Ty2kKFfrNgp1tFrdJyYunpj4W7f8gLp2csH0KS
	 jHNFP/fPZK3cg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Fix null ptr deref on nested
 wp/unmap, teardown race
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260822-kvm-arm-nested-virt-fix-v2-2-ac4059a0eaa6@kernel.org>
References: <20260822-kvm-arm-nested-virt-fix-v2-0-ac4059a0eaa6@kernel.org>
 <20260822-kvm-arm-nested-virt-fix-v2-2-ac4059a0eaa6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 22 Aug 2026 18:05:56 +0000
Message-Id: <20260822180557.762691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free of `kvm->arch.nested_mmus` array during nested page=
 table walks
- [High] Memory Leak of `kvm->arch.nested_mmus` on VM teardown via fd closu=
re
--

--- Patch [2]: [PATCH v2 2/2] KVM: arm64: nv: Fix null ptr deref on nested =
wp/unmap, teardown race ---
commit 82456f58d55471e0202bc28188ae985c14d4be0a
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

KVM: arm64: nv: Fix null ptr deref on nested wp/unmap, teardown race

This commit fixes a NULL pointer dereference in the nested page table walk
paths. It resolves a race condition where concurrent stage 2 teardown can s=
et
the page table pointer to NULL while the MMU lock is temporarily dropped.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 17123f0b6daba..f69722e1592a5 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -1295,7 +1306,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_=
block)
>  			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);

[Severity: High]
This isn't a bug introduced by this patch, but can this lead to a
use-after-free of the mmu pointer?

When we pass the array element pointer down the call chain:

kvm_nested_s2_unmap()
  -> kvm_stage2_unmap_range()
    -> __unmap_stage2_range()
      -> stage2_apply_range()

stage2_apply_range() can drop kvm->mmu_lock by calling
cond_resched_rwlock_write().

Concurrently, kvm_vcpu_init_nested() can reallocate and free the
kvm->arch.nested_mmus array, or kvm_arch_flush_shadow_all() can free it
locklessly. When stage2_apply_range() reacquires the lock, could it
dereference the dangling mmu pointer?

[Severity: High]
This is a pre-existing issue, but does kvm->arch.nested_mmus leak during VM
teardown via fd closure?

It looks like the array is currently only freed in kvm_arch_flush_shadow_al=
l(),
which is triggered exclusively by the MMU notifier's release hook.

If a VM is closed via file descriptor, mmu_notifier_unregister() is called
which does not invoke the release callback. Since kvm_arch_destroy_vm() doe=
sn't
appear to clean up the nested_mmus array, is this memory permanently orphan=
ed?

>  	}
> =20
> -	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> +	kvm_invalidate_vncr_ipa_all(kvm);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260822-kvm-arm-ne=
sted-virt-fix-v2-0-ac4059a0eaa6@kernel.org?part=3D2
