Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D63370D6E
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241050; cv=none; b=XW/M7yQtEhRz3JgZOjym4ci1b5CQxRLNmru9iJ8CElfYvfkSKtQEYtef8V8p4Gao1NZxEuf/oA0g0+Fnvy5am1MIvc16RAjW3s6xVtQB5sLqfR0K8TT/d9/huAhVL/S6RcDQdEzB9TgtyfLMPCLnvJ1lvNVe79DXh9foP0IlHBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241050; c=relaxed/simple;
	bh=9FjFCk2hVUIQxvlTlj2BER1f5C6sUJ/ZEr7I/Meeo6s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=odCX9T4Tc/TyE3Z1q96DBEBhs/mXH8A79BoUTga0UTjDY9i/EA5XMwfyjcqpgext7b7m6QtlgdJDy0LtHDhIAwNAwp+VLbzmwd2oiCNKt0spTNeAiyyFaa/vNlWqMTjDwqguPf+42XDl8LLOAmTfshwCsSjzVOoi9eFLqcGEgPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcTPZTAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcTPZTAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DED21F00A3A;
	Tue, 23 Jun 2026 18:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241049;
	bh=iHUvFo2ev5BD+N8sZBLKGpERrbQ5ojPczq/viaOqHMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mcTPZTAdpFwyIFT/PX8j1CVnfFlSxbAs90O8UynCY46X98/LQfINDNRCyWaJI5/j7
	 iR20S0+51WmL2k3eBUJAK3XG2AcZmFHMG6nHD2oNXf/pSQMgMCYeNoBxJlF60LFbg8
	 Sd5iQfav1IqTvJNOdw8reF5zxuNtX60+nUCiYdwkHkIolCuKrpH4Y1r6VWHPMzQBui
	 kavGt05JjD+eg4L+5jh5dc+CSRK/a8LKBQQUmndoB+8B/cUJmTkW9K//vL5SREJ78U
	 uP76FPPmfM/9BYfnzTvW0gCkGUpHuNinWz/9iR4uPgwLxQ+JcgYJFF7u6EbsEr3yDb
	 7gHmsODS7Xdww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/22] KVM: arm64: Grant write permission when DBM is
 set at S1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260623184201.1518871-15-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-15-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 18:57:28 +0000
Message-Id: <20260623185729.1DED21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The patch incorrectly grants write permissions based on DBM when h=
ardware dirty state management is architecturally disabled due to HA=3D0.
- [High] Hardware dirty state management (FEAT_HAFDBS) is incorrectly emula=
ted when the Permission Indirection Extension (FEAT_S1PIE) is enabled, lead=
ing to spurious permission faults and incorrect descriptor updates.
--

commit 7f44240a7dbcb830d02ca9b76f878070fdff7b00
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Grant write permission when DBM is set at S1

The DBM bit effectively behaves as a permission bit when using direct
permissions, especially so in the context of accesses that do not update
the dirty state (like AT).

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index bfba31b270a95..faffb69c2eef5 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -1077,11 +1077,23 @@ static void compute_s1_direct_permissions(struct =
kvm_vcpu *vcpu,
>  					  struct s1_walk_info *wi,
>  					  struct s1_walk_result *wr)
>  {
> +	u8 ap =3D FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc);
>  	bool wxn;
> =20
> +	/*
> +	 * Descriptors with the DBM bit set while hardware dirty state are
> +	 * considered writable, even though certain accesses (like AT instructi=
ons)
> +	 * don't actually update the dirty state.
> +	 *
> +	 * Assume that walk_s1() made the necessary descriptor updates for the
> +	 * access and just treat DBM as writable here.
> +	 */
> +	if (wi->hd && (wr->desc & PTE_DBM))
> +		ap &=3D ~BIT(1);

[Severity: High]
Does this incorrectly grant write permissions when hardware management of t=
he
Access Flag is disabled?

According to the ARM Architecture Reference Manual, hardware management of =
the
dirty state (TCR_ELx.HD =3D 1) is ignored if hardware management of the Acc=
ess
Flag is disabled (TCR_ELx.HA =3D 0).

In setup_s1_walk(), we compute wi->hd directly from TCR.HD without enforcing
this requirement:

arch/arm64/kvm/at.c:setup_s1_walk() {
        ...
        wi->hd  =3D kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, DBM);
        wi->hd &=3D (wi->regime =3D=3D TR_EL2 ?
                  FIELD_GET(TCR_EL2_HD, tcr) :
                  FIELD_GET(TCR_HD, tcr));
        ...
}

If a guest OS configures TCR_ELx.HA =3D 0 and TCR_ELx.HD =3D 1, and creates=
 a
stage-1 descriptor with RDONLY=3D1 and DBM=3D1, it should remain strictly
read-only and generate a Permission Fault on a write. By relying on the
ungated wi->hd here, does KVM bypass the Permission Fault and allow a
guest-visible privilege escalation?

[Severity: High]
Is hardware dirty state management incorrectly emulated when the Permission
Indirection Extension (FEAT_S1PIE) is enabled?

When FEAT_S1PIE is enabled, the DBM bit (bit 51) acts as Index[1] in the PI
index. If a write occurs to a "clean" page (DBM=3D1) and HD=3D1, the hardwa=
re
checks if clearing bit 51 would grant write access.

It looks like compute_s1_indirect_permissions() evaluates permissions using
the current PI index without simulating this dirty bit transition, which co=
uld
cause a spurious permission fault instead of updating the dirty state:

arch/arm64/kvm/at.c:compute_s1_indirect_permissions() {
        ...
        idx =3D pte_pi_index(wr->desc);
        ...
        set_perms(priv, wr, pp);
        ...
}

Additionally, if the dirty state needs to be updated, it appears we
unconditionally clear bit 7 (PTE_RDONLY) instead of bit 51 (PTE_DBM):

arch/arm64/kvm/at.c:handle_desc_update() {
        ...
        if (should_set_dirty_state(wi, ws, wr, access))
                new &=3D ~PTE_RDONLY;
        ...
}

For PIE, bit 7 is unrelated to the dirty state. Could this corrupt the
guest's PIE descriptor?

> =20
>  	/* Non-hierarchical part of AArch64.S1DirectBasePermissions() */
>  	if (wi->regime !=3D TR_EL2) {
> -		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc)) {
> +		switch (ap) {
>  		case 0b00:
>  			wr->pr =3D wr->pw =3D true;
>  			wr->ur =3D wr->uw =3D false;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D14
