Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11F374E74
	for <kvmarm@lists.linux.dev>; Fri, 14 Aug 2026 10:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786704525; cv=none; b=DVt0soiCVm7rDTU4guSbDRyoMZyiIF08b/ljnhcwXFFba3VgceRTUn2ylSMeUR/GS0EvB4dbhT5XC7dEptljAnhxQZ33WH23rqI9Kjbl3g+loWr79efg2OU2kXr2eFGYygacyxgCDymiyWkuIMxvtbS/9i3fUYGAyEDByYspmWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786704525; c=relaxed/simple;
	bh=JPP4SJl07N4HQX7Kg+uFNNbE56UZZ4axHQJnqplVxEY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p7Z60+MSbry8LFCjal7SirQwlyNsC0JcKcy4ps59zQr9YlOlMYYR4K0Om8v1+Usx2zksIdu4ssGXO8MnKhd6pJW5UJTyQ5Z4NMx8ialWOi9vfx/Q0lfL35Rk6D/fS8CaoCy/cKvUDu3Tkej61ZJ8s2BZlEKAvbS+3gL/MKRdg60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ply9PH2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ply9PH2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642B81F00A3A;
	Fri, 14 Aug 2026 10:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786704515;
	bh=koI8QVP7AFb24m90wuPTkBqn3ihiRss4huP6Xd4CHaI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ply9PH2DpozgM53zXWEvp/CBCse41i2pITNkzXZHntKq8zI3W/Qsqp8H+LoMe7k+E
	 z7m/ZoqFr5B2kRMWzk0h+bSYKruFBf+06Zu7nmSczg9gNpvpF7X/vxgvfaD5rry69L
	 WLEe9J8cLUZ30j/0Q1bgjaAtNMO4i5Lh62R8iBcNCSpgufDtaySzy/yDzkw7eRP7CH
	 QcZlao2WR0tmar/n39ah5yh3e1x1OCBi2rxgI5vBDBGOHQ/c5rAMwMrjKjSTaeyjOf
	 2vasvhXEZ5nw7nhkkH752Tajg4zdQgiC8w7AQrdkBDTtlalJjlC8Q0uW1AmY2W4HpX
	 q+4VhfnamBFog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] KVM: arm64: nv: Delay freeing of shadow S2
 structures until VM destruction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260814103230.858578-3-maz@kernel.org>
References: <20260814103230.858578-1-maz@kernel.org>
 <20260814103230.858578-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:48:34 +0000
Message-Id: <20260814104835.642B81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Reading KVM stage-2 debugfs files after `mmu_notifier_release` cau=
ses a NULL pointer dereference or Use-After-Free (UAF).
--

--- Patch [2]: [PATCH v2 2/2] KVM: arm64: nv: Delay freeing of shadow S2 st=
ructures until VM destruction ---
commit 0e0fd6e2861a90f62fede091e967d2714a276ba0
Author: Marc Zyngier <maz@kernel.org>
Subject: KVM: arm64: nv: Delay freeing of shadow S2 structures until VM des=
truction

This commit prevents the early freeing of the shadow stage-2 MMU container
structures from kvm_arch_flush_shadow_all(). It introduces a separate
destructor invoked during VM teardown, while keeping the page table freeing
in the original flush callback.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 99cd2ea61a220..db1824067dbdf 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
[ ... ]
> @@ -56,6 +56,27 @@ int kvm_init_nested(struct kvm *kvm)
>  	return kvm->arch.nested_mmus ? 0 : -ENOMEM;
>  }
> =20
> +static void kvm_uninit_shadow_stage2_mmu(struct kvm *kvm)
> +{
> +	for (int i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu =3D kvm->arch.nested_mmus[i];
> +
> +		if (!WARN_ON(atomic_read(&mmu->refcnt)))
> +			kvm_free_stage2_pgd(mmu);

[Severity: High]
This is a pre-existing issue, but does reading the KVM stage-2 debugfs files
after mmu_notifier_release cause a NULL pointer dereference or use-after-fr=
ee?

While this patch prevents the use-after-free of the mmu container itself, it
appears mmu->pgt is still vulnerable. When a process exits,
mmu_notifier_release triggers kvm_arch_flush_shadow_all(), which calls down
to kvm_free_stage2_pgd().

kvm_free_stage2_pgd() sets mmu->pgt to NULL and frees the page table
structure:

arch/arm64/kvm/mmu.c:kvm_free_stage2_pgd() {
    write_lock(&kvm->mmu_lock);
    pgt =3D mmu->pgt;
    if (pgt) {
        mmu->pgd_phys =3D 0;
        mmu->pgt =3D NULL;
        ...
    }
    ...
    write_unlock(&kvm->mmu_lock);
    if (pgt) {
        kvm_stage2_destroy(pgt);
        kfree(pgt);
    }
}

However, the KVM VM file descriptor and its debugfs dentries can remain ali=
ve.
If a process holding the VM fd reads debugfs files like ipa_range or
stage2_levels, functions like kvm_pgtable_debugfs_open() or
kvm_ptdump_parser_create() will read mmu->pgt without holding kvm->mmu_lock:

arch/arm64/kvm/ptdump.c:kvm_ptdump_parser_create() {
    struct kvm_pgtable *pgtable =3D mmu->pgt;
    ...
    ret =3D kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
    ...
}

Could a concurrent read of mmu->pgt either dereference a NULL pointer, or
pass a soon-to-be-freed page table pointer to the seq_file show callbacks
such as kvm_pgtable_range_show()?

> +	}
> +}
> +
> +void kvm_destroy_nested(struct kvm *kvm)
> +{
> +	kvm_uninit_shadow_stage2_mmu(kvm);
> +
> +	for (int i =3D 0; i < kvm->arch.nested_mmus_size; i+=3D S2_MMU_PER_VCPU)
> +		kvfree(kvm->arch.nested_mmus[i]);
> +
> +	kvm->arch.nested_mmus_size =3D 0;
> +	kvfree(kvm->arch.nested_mmus);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814103230.8585=
78-1-maz@kernel.org?part=3D2
