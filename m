Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E745208D0
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 19:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782241536; cv=none; b=eAFZz7p6CktktPIeOT1bF5y9s61iQarlJ5Scfe38+XCTMHm7mON4YKVpho9J8s7tzOI2yYeBH/3I4KpkP+br9XVn9/LtJylJjT6atJP2meZP6vJGE1K3wygTN5yikMLcwxcut59SRZ8rYCKJLsLtnWjX5sZSjQ7qUe/G/Gvx1ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782241536; c=relaxed/simple;
	bh=1G1nf0IgdkF8tmoF850+aArc+2nc7vaHTfbyqCyOTcA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bkuewdN1CgQrixqctZEpWQlkv5WJmDWuJtVKdrS+pH+Th/XuCE03Zs8ds9Rl+zW4LlCXJ2mW4fudI1xPtWuFYc3N3qGBypPnNIJb5KaJmYun8pApmAnT5yBjzUBE7xUo8QE55ZlFlLUvk1W2UJlLXKsxzOjAXX0ZGgRhC2EDqTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTqvuIeZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTqvuIeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE9E1F000E9;
	Tue, 23 Jun 2026 19:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241535;
	bh=eNmu062UGIi49WmkZQ7G/QjyKiF8IpgKBkJGXxjVJeQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JTqvuIeZUmWkbVqlNiB6XDtwA4P4FSO0YzETAfcrkmg+LpTVEAlrqUJufbthwntNM
	 7V7E+J7sHTJc4xMvOj7BHDGSb8oGj2YJomkPrEmKMLYtp87cSlubD6zkA4XVFG6YvM
	 Lvd6800NPR7GU4KpNXmACTHD1WuOQ9m4cmlCWBW7DOhvFFGI9J1LW5qXE+yDWsgpMI
	 ll+ctFEj1feTqLuFaqO3P56SghcNn9TwCAGhVwmD+Tu6mETZj7S6J+Y/jbmWayaFEs
	 pMoA8V0EHwPe4Zcn9kf7FoIvB0r6rkwCpsYfAdj0Y6VBkKYZOWgdVlKgkIDhlGmZ/V
	 UkCSF8XcPxZHw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/22] KVM: arm64: nv: Expose FEAT_HAFT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260623184201.1518871-20-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-20-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 19:05:34 +0000
Message-Id: <20260623190535.0BE9E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM's AT instruction emulation incorrectly evaluates HD and HAFT=
 without ensuring the Hardware Access Flag (HA) is enabled, leading to unau=
thorized hardware updates of the Access flag on table descriptors.
--

commit e646aa23aa5bcaa5e6bc04545e6c0d319fc3a058
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: nv: Expose FEAT_HAFT

Both stages of translation now support the access flag on table descriptors,
advertise the feature.

> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 6f540d3481d5a..dc2a8b6483c2a 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1799,7 +1799,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 v=
al)
>  		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
>  			val &=3D ~ID_AA64MMFR1_EL1_VH;
> =20
> -		val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, DBM);
> +		val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, HAFT);

[Severity: Medium]
Does exposing HAFT here uncover an issue in AT instruction emulation where
hardware updates are authorized even when the hardware access flag is
disabled?

Looking at setup_s1_walk() in arch/arm64/kvm/at.c, wi->hd and wi->haft
are evaluated without checking if the hardware access flag (HA) is enabled:

arch/arm64/kvm/at.c:setup_s1_walk() {
        ...
        wi->haft  =3D kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, HAFDBS, HAF=
T) &&
                    FIELD_GET(TCR2_EL1_HAFT, effective_tcr2(vcpu, wi->regim=
e));
        ...
}

Then in should_set_access_flag(), this could return wi->haft for table
descriptors, inadvertently authorizing hardware updates even when HA =3D=3D=
 0:

arch/arm64/kvm/at.c:should_set_access_flag() {
        ...
        return kvm_pte_table(ws->desc, ws->level) ? wi->haft : wi->ha;
}

If a nested guest sets TCR_ELx.HD =3D 1 or TCR2_ELx.HAFT =3D 1 but leaves
TCR_ELx.HA =3D 0, and then executes an AT instruction, could KVM incorrectly
evaluate the guest's page table permissions as writable or perform an
unauthorized hardware update of the Access flag on table descriptors?

>  		break;
> =20
>  	case SYS_ID_AA64MMFR2_EL1:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623184201.1518=
871-1-oupton@kernel.org?part=3D19
