Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD460481A94
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284770; cv=none; b=q5Jn4DnGyZybLOPaza3KI1EqepAsU34WfzfBBhBJRwkGB8N/3T5hlnc9QiaII2dcBL4FqsKUpesk1W6eKqB/VVsnK/iqECVCLEOqOi/YGf11Fi53qUxVBfQazlFqoEtle0uVftpfKVaozWKI89R6VK0gKVisoHVEW9CzZmPfgf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284770; c=relaxed/simple;
	bh=Ve2MzOvdv5Bd9TTrSaAfhwzLklPLTwho+iXDAZhh5Yc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NJfT3G+AHoN6ymMndQrJ3IxaI8JOS/RUbWqUcPEj4W0spQnDOmiQXMPsU11wEZ95tE8mWW/HQ0u+5X/EqY/TXTQruonK9eeZH//ET4Z8uEQ0L7NGHPPnk5Y6TUJgpR8wvFMhRfdiHvjKw2NRuC6LGAugr+Fe/+VO822F/BhhiaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6D/4ixh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6D/4ixh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E041F000E9;
	Tue,  1 Sep 2026 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788284769;
	bh=BgcFAM8bh+yympj6Q9U1y66jaM3mPOMOwuWxmWxLSjo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f6D/4ixhA7OTJFAxZueMLT65M+T0AXwp3xmgNUnAl6Vk1/ABcmCQyJ0jRuFpWTY9A
	 FqTBGMkF1YwPRniZnTzIuzWL3L+pn7vuSmMxMXSG2czvSFTrMClC+tHeS95w7RNjy9
	 ulUUYQmqPvU4px5StsacWThE7bYErH2P4zGEtC677mKMd3soKnDIhlSKw6lOO1yKmc
	 z7EZsK+wu6atlhhshdO3riqZ38Higj2/DFMuOBrYbxCrVnHHg86eDQlOib5vm849vp
	 CH+nB/JAxgCTgwjtAPFEGoq8IvIUaa0U2QO9EreCetS3+T7sOaEclHu2noiv6s4tHv
	 MiK4TNhtPc2qg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] KVM: arm64: Fix spurious warning for benign
 stage 2 teardown race
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260901-kvm-arm-nested-virt-fix-v3-1-b154676f7e4c@kernel.org>
References: <20260901-kvm-arm-nested-virt-fix-v3-0-b154676f7e4c@kernel.org>
 <20260901-kvm-arm-nested-virt-fix-v3-1-b154676f7e4c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 17:46:08 +0000
Message-Id: <20260901174609.14E041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Use-After-Free of nested_mmus array in stage2_apply_range due =
to concurrent kvfree
--

commit 2cabe3fbde6089df082f059c9d4b617266797a8f
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

KVM: arm64: Fix spurious warning for benign stage 2 teardown race

This commit addresses a spurious warning observed during stage 2 page table
teardown by preventing concurrent PGT teardown from being treated as an err=
or
when the mmu_lock has been dropped and re-acquired.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4af..2d44cd6a5aed9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -59,27 +59,36 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t =
addr, phys_addr_t end)
> -static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
> +static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>  			      phys_addr_t end,
>  			      int (*fn)(struct kvm_pgtable *, u64, u64),
>  			      bool resched)
>  {
>  	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> +	bool lock_dropped =3D false;
> +	phys_addr_t addr =3D start;
>  	int ret;
>  	u64 next;
> =20
>  	do {
>  		struct kvm_pgtable *pgt =3D mmu->pgt;

[Severity: Critical]
This isn't a bug introduced by this patch, but while this change correctly
avoids the warning when pgt is NULL, does the lock-dropping behavior here
expose a Use-After-Free on the mmu pointer itself?

Looking at the teardown paths, it appears stage2_apply_range() can race with
concurrent freeing of the kvm->arch.nested_mmus array.

If Thread A (e.g., kcompactd) is iterating over the array in
kvm_nested_s2_unmap() and yields kvm->mmu_lock inside this loop via
cond_resched_rwlock_write(), Thread B (such as exit_mmap ->
mmu_notifier_release) could concurrently call kvm_arch_flush_shadow_all().
Thread B acquires mmu_lock to clear the PGDs, and then locklessly calls
kvfree(kvm->arch.nested_mmus) after dropping the lock.

When Thread A wakes up and re-acquires mmu_lock to resume the loop, its
local mmu pointer would point into the freed nested_mmus array, leading to a
Use-After-Free right here when it accesses mmu->pgt.

A similar concurrent kvfree() appears to exist in kvm_vcpu_init_nested(),
which reallocates and frees the array (kvfree(tmp)) while readers might be
yielding here.

Is there a need to defer these kvfree() calls or better protect the yielding
readers in stage2_apply_range() to prevent this race?

> +		/*
> +		 * We may be raced on PGT teardown when we release the
> +		 * kvm->mmu_lock. That's fine as the PGT is legitimately no
> +		 * longer present.
> +		 */
>  		if (!pgt)
> -			return -EINVAL;
> +			return lock_dropped ? 0 : -EINVAL;
> =20
>  		next =3D stage2_range_addr_end(addr, end);
>  		ret =3D fn(pgt, addr, next - addr);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-kvm-arm-ne=
sted-virt-fix-v3-0-b154676f7e4c@kernel.org?part=3D1
