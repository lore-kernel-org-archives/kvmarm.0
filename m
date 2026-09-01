Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F69486BA2
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284801; cv=none; b=kzDNKTr8DBnTYTPUMUVbY5Lk+z6ZQkVdUJhOCIu/ZJ6CLyF8h5Rdbp3LsvUuVcJ+k3tdEKPgmx62+dDXIo0H80vT1yuODRQtNI3Cek6l0qyFuLx6GqKZdUKl9IB50C2XTyVU7+Suqkik2RTQQn9Nga1YyO0gVQGrC+ecnUD/wKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284801; c=relaxed/simple;
	bh=ReTixL2eDck/tJKgNZOhRnbk/zgSAQwSRJAjotXlmO8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qMzPNQlO47KsaQp67yTfr7zQOQhukVSWyDijnORrJ+v3R5ec08nPDg+N6HYiGqZHYTPKIAk3eVMDfp9BKOsHPkjDdDC78w+jwBzVz/ngqedlVP7kTLhu6NsY/NsMj4F2AO45jQvBkerOTWJbk1McOa87qlMaMXqNERqj1ewULdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOZPEik1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOZPEik1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9A21F000E9;
	Tue,  1 Sep 2026 17:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788284800;
	bh=ODM5MB0mTeDg0SDruVHv8nUWPwLS1UB5v/PlYGUSvTQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SOZPEik1zdhGccD4AL1Gd2ItpcSwNF/PruioLHFb/6pm9YwCYIo9y/4/LDRMwLc2t
	 gMaY6OyfzDflSW9XfKjlfrOgBWKOZyy3QzkVCzTrdJDib6+lVxJ+Klu+EGhmQDkrxR
	 o5L70LUyFdT7kbgKBIptAPyFJT9Rje5RIpgpBxiZmbXV+QFxYmU+6ImJ/QTcTNo8oo
	 XUSUyvoMxWDKqZ24qMHTY6G9ZQBK72dAXqrMwZPtmHxW1bMrt5ENHqzwnAYq4sZeHf
	 3iW4bKBBaa0svLWaKsfw4cBz44LR+lli2Owce42gKk1a6gYW0yGEOqwJxjDqNkd1MW
	 ZYIp8iDO4mbCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: nv: Fix null ptr deref on nested
 wp/unmap, teardown race
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260901-kvm-arm-nested-virt-fix-v3-2-b154676f7e4c@kernel.org>
References: <20260901-kvm-arm-nested-virt-fix-v3-0-b154676f7e4c@kernel.org>
 <20260901-kvm-arm-nested-virt-fix-v3-2-b154676f7e4c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 17:46:39 +0000
Message-Id: <20260901174639.CE9A21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Concurrent VM teardown frees the `kvm->arch.nested_mmus` array wit=
hout holding `kvm->mmu_lock`, causing a Use-After-Free when `kvm_nested_s2_=
unmap`, `kvm_nested_s2_wp`, or `kvm_nested_s2_flush` iterate over the array.
--

commit 6d817ae312afc7a3c0a4cae55f93ea78c14d26e1
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
KVM: arm64: nv: Fix null ptr deref on nested wp/unmap, teardown race

This commit fixes a NULL pointer dereference caused by concurrent stage 2
teardown racing with MMU notifiers by wrapping VNCR IPA invalidation in a
new helper that checks for a NULL page table pointer.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 17123f0b6daba..f69722e1592a5 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c

[ ... ]

> @@ -1295,7 +1306,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_=
block)
>  			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);

[Severity: High]
This is a pre-existing issue, but since this patch explicitly deals with the
race between kvm_arch_flush_shadow_all() and MMU notifiers dropping the
mmu_lock, is there a Use-After-Free risk with kvm->arch.nested_mmus here?

If kvm_stage2_unmap_range() ends up calling stage2_apply_range() which
drops kvm->mmu_lock, kvm_arch_flush_shadow_all() can proceed to tear
down the nested MMUs.

In arch/arm64/kvm/nested.c:kvm_arch_flush_shadow_all():
    kvfree(kvm->arch.nested_mmus);
    kvm->arch.nested_mmus =3D NULL;
    kvm->arch.nested_mmus_size =3D 0;

This kvfree() happens without holding kvm->mmu_lock.

When the MMU notifier path in kvm_nested_s2_unmap() reacquires the lock
and continues, the mmu pointer (which points into the now-freed
kvm->arch.nested_mmus array) is completely dangling.

For example, in arch/arm64/kvm/mmu.c:stage2_apply_range():
    do {
        struct kvm_pgtable *pgt =3D mmu->pgt;
        ...

Can this dereference of mmu->pgt cause memory corruption or crashes if the
underlying array has been freed by a concurrent VM teardown?

>  	}
> =20
> -	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> +	kvm_invalidate_vncr_ipa_all(kvm);
>  }
> =20
>  void kvm_nested_s2_flush(struct kvm *kvm)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-kvm-arm-ne=
sted-virt-fix-v3-0-b154676f7e4c@kernel.org?part=3D2
