Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3D854A7E2
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083991; cv=none; b=ON0w7FlZMCvBtz5FKeruPAUChQeSGJMJyLHAtoFMOOWI7AkFtrmIjDlbin4/O4zQIewg4eUlnIMwrStRZVTorVRRGyRuxfFig1GcQE4schDVi/uaFGrlkUn6ChjVWIifNF+fU6skpzAYx9kGsUW7qghhLJnfZGf1I3bLZc7ch9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083991; c=relaxed/simple;
	bh=2z9GVycy78R40hBPYIX4H4bBaW0CFj8ZvDeMX4Px29g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VBpP2KFAyj4uTU23xPVpj+F2fOtUN5aB+7wsT2GQ2TLtCDvQ564ABwMh7l5gdx4JjdEx2MAEFkaPkcUH5NmUBNIlbvuNeM1reRpZ2tNc/pBZjSIrZjiHENrhB7OHhx8s5nDiOkKrKMEKW1cDA0MU5cyNTpcvMj2fHRHjUgDb1wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMjc6+HY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMjc6+HY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1F51F000FF;
	Tue, 22 Sep 2026 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083990;
	bh=5BpfNDOO8Z7Vy5X3W37DjYSpzmB8vwHudNhTTrM9czA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eMjc6+HYHLn0qnlcvJqBPVRMsMpeeY0wH/xjJWTt4tk7B3A5sMI8nYSGtyNViptfI
	 tt2NXU+jYs/C6JBMyKwUB8TQrzelKuIHhK4zs/3MIpCjqb3g/mHvLxegOB2Q0z3dPZ
	 b7dNdFnW4dvZeZvJmvJVBV0M/l6cVHhQHo0rDqD7snHts6G0d8FtGZm3y6NcHhbwfw
	 NXB8gBAnFejnUI/VXAoezrxNrYRwGM4x9PNI5rzkljJhYP40KJNYykRjfdjGYCKVTV
	 YLD0QC1wRO08HqjDduGsjl3Kl1NHmECSmhSGT0DxzlA6o73kRSnvC+/cg089Qvqtdi
	 9w1a/eeXl7WLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 17/25] iommu/arm-smmu-v3-kvm: Shadow stream table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260922131259.2975334-18-smostafa@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-18-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 13:33:09 +0000
Message-Id: <20260922133309.CD1F51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] arm-smmu-v3-kvm: unhandled break in switch statement causes EL2 =
panic on STRTAB access
- [Medium] arm-smmu-v3-kvm: improper WARN_ON() usage for host inputs allows=
 trivial EL2 panics
--

commit a05ba1b1951c6df5b35f980e9826eb9d8a4ea188
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Shadow stream table

This patch allocates the shadow stream table per SMMU with a maximum size
of 1MB for 2-level tables. It sets up passthrough for host writes to the
stream table base and configuration registers, laying groundwork for future
CFGI command trapping.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/i=
ommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
[ ... ]
> @@ -438,6 +499,46 @@ static int smmu_emulate_cmdq_insert(struct hyp_arm_s=
mmu_v3_device *smmu)
>  	return ret;
>  }
> =20
> +static int smmu_update_ste_shadow(struct hyp_arm_smmu_v3_device *smmu, b=
ool enabled)
[ ... ]
> +static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
> +	if (WARN_ON(!is_cmdq_enabled(smmu)))
> +		return;

[Severity: Medium]
Could this WARN_ON panic EL2 if the host enables the SMMU without enabling
the CMDQ? Since WARN_ON at EL2 behaves as a fatal panic, using it for
host-controlled inputs converts an invalid host state into a hypervisor DoS.
Would returning an error be safer here?

> +
> +	WARN_ON(smmu_update_ste_shadow(smmu, true));
> +}

[Severity: Medium]
Similarly, does this panic EL2 if the host provides an invalid stream table
configuration? The pKVM guidelines suggest that EL2 should not assert on
contracted host inputs.

[ ... ]
> @@ -525,7 +626,23 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_=
device *smmu,
>  		}
>  	/* Passthrough the register access for bisectability, handled later */
>  	case ARM_SMMU_STRTAB_BASE:
> +		if (is_write) {
> +			/* Must only be written when SMMU_CR0.SMMUEN =3D=3D 0.*/
> +			if (is_smmu_enabled(smmu))
> +				break;

[Severity: Medium]
Does this break statement erroneously exit the entire switch block for
ARM_SMMU_STRTAB_BASE? If the host writes to this register while the SMMU is
enabled, the break bypasses the mask assignment, leaving mask =3D 0. Later =
in
the function, if (WARN_ON(!mask)) evaluates to true, which triggers a fatal
hypervisor panic.

> +			smmu->host_ste_base =3D val;
> +		}
> +		mask =3D read_write;
> +		break;
>  	case ARM_SMMU_STRTAB_BASE_CFG:
> +		if (is_write) {
> +			/* Must only be written when SMMU_CR0.SMMUEN =3D=3D 0.*/
> +			if (is_smmu_enabled(smmu))
> +				break;

[Severity: Medium]
Could this break statement similarly cause an EL2 panic on STRTAB_BASE_CFG
access? Like the case above, this appears to leave mask =3D 0 and panic the
hypervisor.

> +			smmu->host_ste_cfg =3D val;
> +		}
> +		mask =3D read_write;
> +		break;
>  	case ARM_SMMU_GBPA:
[ ... ]

[Severity: Medium]
Are there other instances where WARN_ON is used to validate host inputs?
For example, in smmu_emulate_cmdq_insert():

smmu_emulate_cmdq_insert()
    skip =3D smmu_filter_command(smmu, cmd);
    if (WARN_ON(skip))
        continue;

And at the end of smmu_dabt_device():

smmu_dabt_device()
    if (WARN_ON(!mask))
        goto out_ret;

Since these are directly reachable by the host kernel, they allow a trivial
host self-DoS by inserting an unsupported command or performing an unhandled
access length. Could these assertions be replaced with standard error
handling or abort injection?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922131259.2975=
334-1-smostafa@google.com?part=3D17
