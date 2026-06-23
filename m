Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A272B2DF15C
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240868; cv=none; b=HW4qcLjOf/Kgo1l5HRuh4sVhR/8MPshIl9dileww2FHhDry1jtQfoDFQDinrId/CFATJz0da30hmhptimYQZCN9Q//IrKQ1Ed0UtFNN1PlHsh1PTP86yCvMCokFh0JAeV8Hk4F2zLFwRzLCfbkxdR+soGvD+IzI4gbi7+dseWjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240868; c=relaxed/simple;
	bh=amtTfpLexUy1yn9E3Im266v1A72/PmLteUIj1vBLj0w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RkIWCPbs+XiPno5uLt2mlFbBg54oc1UcFN9XWhUO6Z+lM3GG4EUhibe6S032avWS321oVQPLJnl/FSvN2kKun2Wlb9JO+T4oU78qql3YrRF6CkelOFkW4rX6CehvevO5bxwsdn3j38fNtylEg2/v7fcwBoLBAON69O/UVflb1EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wc0WGitz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wc0WGitz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001CC1F000E9;
	Tue, 23 Jun 2026 18:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240867;
	bh=jIIvQ+weuqIlbizOOUsP6M+ewUKhLGvDTu2U0++LDQE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wc0WGitzYwUSOFnjJxK5GYZrX1nm9drnXfHPzlpgVeQVnewyGRoIyon2X+qF4tb5m
	 WlcNArRTj6f7bSfjpauzs8lAa2e7YrDaH6P9/5JVIKLO7dl0XJYCSQ24D/rZnDLs06
	 CuFNGbrTnIBcXS4pifWYQD3EEx/QLfjp7sxK41oGlAzC7Usfk+ZhVJGanMGqhLuT9A
	 +zSFH8y1BaBkphl6ueP1Hy0Fafuitjafymo9otPXNay/QLv6IMlU4shQCRxzSF9IS3
	 nXkrHKfAnyBM4YcTRbGqXulqh74+2qU+71ZcUYQKd/iklR6vVlnN/4cAl8+a7/olaR
	 kZdZv/wpQ172g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/22] KVM: arm64: Set dirty state at stage-1
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-14-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-14-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 18:54:26 +0000
Message-Id: <20260623185427.001CC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Hardware management of the dirty state (wi->hd) is incorrectly ena=
bled for stage-1 even if hardware management of the access flag (wi->ha) is=
 disabled.
- [Medium] The walk result's descriptor and dirty state are not updated aft=
er a successful hardware update, leading to spurious secondary faults.
--

commit bfdb5faf043bd9330372f7cd1a89affe2bb61b35
Author: Oliver Upton <oupton@kernel.org>
KVM: arm64: Set dirty state at stage-1

This commit updates the KVM ARM64 software page table walker to clear
the PTE_RDONLY bit in guest page tables when write access is permitted
and DBM (Dirty Bit Management) is enabled. This simulates hardware
management of the dirty state during stage-1 translation walks.

> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 0218176107b52..bfba31b270a95 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -412,6 +412,10 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, stru=
ct s1_walk_info *wi,
>  	wi->ha &=3D (wi->regime =3D=3D TR_EL2 ?
>  		  FIELD_GET(TCR_EL2_HA, tcr) :
>  		  FIELD_GET(TCR_HA, tcr));
> +	wi->hd  =3D kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, DBM);
> +	wi->hd &=3D (wi->regime =3D=3D TR_EL2 ?
> +		  FIELD_GET(TCR_EL2_HD, tcr) :
> +		  FIELD_GET(TCR_HD, tcr));

[Severity: High]
Does this code incorrectly enable hardware management of the dirty state (w=
i->hd)
when hardware management of the access flag (wi->ha) is disabled?

The ARM Architecture Reference Manual (D8.2.7) states that if HA is 0, HD is
effectively 0 and no hardware updates are permitted.

If a guest enables TCR_ELx.HD but leaves TCR_ELx.HA disabled, wi->hd evalua=
tes
to true while wi->ha is false in setup_s1_walk(). Upon a write fault,
handle_desc_update() would clear PTE_RDONLY but skip setting PTE_AF, causin=
g KVM
to inject an Access Flag fault despite having already modified the guest pa=
ge
table to clear PTE_RDONLY.

> =20
>  	return 0;

[ ... ]

> @@ -467,6 +487,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, =
struct s1_walk_info *wi,
>  	if (wi->ha)
>  		new |=3D PTE_AF;
> =20
> +	if (should_set_dirty_state(wi, ws, wr, access))
> +		new &=3D ~PTE_RDONLY;
> +
>  	if (new =3D=3D old)
>  		return 0;

[Severity: Medium]
Are we failing to update the walk result (wr) after a successful hardware u=
pdate?

When handle_desc_update() successfully clears PTE_RDONLY, it updates the
descriptor in guest memory and ws->desc, but wr->desc and wr->dirty are not
updated to reflect this change for walk_s1().

If kvm_translate_vncr() subsequently uses the stale wr.dirty =3D=3D false, =
it maps
the VNCR page as PAGE_KERNEL_RO. When the guest retries the write, it trigg=
ers
a permission fault, forcing a second translation walk which then sees the u=
pdated
descriptor and maps it RW. Does this omission cause spurious secondary page
faults?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D13
