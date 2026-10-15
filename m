Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F307B599A46
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096256; cv=none; b=V7Fcs1R+jLx8alwxbfYmpL7QvnCRKiTpnm7x+8iiG/wwb6IuYG+YfJfmBle+PLI98ivjktLqOa/cI/ycF7pzlD3oVNKd6y9E+gQklVGPkbt+IdV23kjHJzGtCVIHLW1hl3bvq5BUCEXX7qKxvb/S2u/okbCLrIhM2hOApY3c06U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096256; c=relaxed/simple;
	bh=LRDZ2+tqApiVbcjEjis4hz0cCJX00O1r2nVuMSuNL24=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Y4G1ec/R5o9QlCa3LBdO7YDPc3uhXT+8pDZtPXhcUCap1Br+JGR1B3WwWX1lh1XAbgfyQzqjOcowrKadOP40N7oYlbnCzgzT+GaBrPo7JwULBBL7HRbgQ7rUXr7IZuKmYXym1mYzQIkC4lkWXga+zVZvQ3bGWgq25qSjwkmNI+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6Gs1MfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6Gs1MfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981501F000C5;
	Thu, 15 Oct 2026 20:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096254;
	bh=7U7LjZGwt8Da4vo9SOPbEhZXiovgwldPWIF4S2+ie5s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i6Gs1MfG0p4U9yFA52k3VHPAX3er4VVy2s7KTw/wbuWwMicL75WUsGzj7cV9bk/rk
	 GPhqLE3TDbfHUI4ppMrpmYZZeoM8Av2pexkLk8103AzDzzdOmJR4Ttkjb2+spy2sB0
	 KP+5RCuDn6A94TNp4N9Gd+HaWl+kENa1ul/xqgT8nE2MR9bMN7wYLEnn0uasuBh8o6
	 EA/Xt8/RupgI2qPRFoot+rMp8PQC9oGbtCS2KO7PeVpJ6wlDUnq293aXc1udD3ZMAw
	 pR025F+1sG4RWi4KTdTNr5SLQc1j3ZTnJkv1InRGIdXOm/ZwmisujevP9Y5NlSqogb
	 sTVH6q2gvEviw==
Message-ID: <sashiko-outbox-173398@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 17/25] iommu/arm-smmu-v3-kvm: Shadow stream table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-18-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-18-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:30:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] iommu/arm-smmu: missing length check for STRTAB_BASE corrupts hyp =
state
- [Low] iommu/arm-smmu-v3-kvm: Incorrect WARN_ON usage panics hypervisor on=
 invalid host config
--

commit 9c237aa634fe8fc969bb3e8a3f07ec53bd303b77
Author: Mostafa Saleh <smostafa@google.com>

iommu/arm-smmu-v3-kvm: Shadow stream table

This commit allocates the shadow stream table per SMMU, sized up to 1MB
for the 2-level host table case. Host writes remain passthrough for now,
and the stream table is shared/unshared on SMMU enable/disable.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drive=
rs/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> --- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
[ ... ]
> @@ -441,6 +502,46 @@ static int smmu_emulate_cmdq_insert(struct hyp_arm_s=
mmu_v3_device *smmu)
[ ... ]
> +static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
> +{
> +	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
> +	if (WARN_ON(!is_cmdq_enabled(smmu)))
> +		return;
> +
> +	WARN_ON(smmu_update_ste_shadow(smmu, true));
> +}

[Severity: Low]
Does this panic the hypervisor on invalid host configuration?  These
assertions evaluate host-supplied states and configurations, which causes a
fatal EL2 BUG() when the host makes an invalid transition.

According to the pKVM Threat Model, host availability against itself is not
guaranteed, making this a hardening improvement rather than a security bug.
However, per the pKVM WARN_ON semantics guide, WARN_ON must only be used
for EL2 internal invariant violations.  Validating host-supplied inputs with
WARN_ON is a correctness violation, as the hypervisor should gracefully
handle or ignore invalid state transitions rather than panicking.

[ ... ]
> @@ -528,7 +629,23 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_=
device *smmu,
>  		}
>  	/* Passthrough the register access for bisectability, handled later */
>  	case ARM_SMMU_STRTAB_BASE:
> +		if (is_write) {
> +			/* Must only be written when SMMU_CR0.SMMUEN =3D=3D 0. */
> +			if (is_smmu_enabled(smmu))
> +				break;
> +			smmu->host_ste_base =3D val;
> +		}
> +		mask =3D read_write;
> +		break;

[Severity: High]
Is a length check missing here?  The missing len =3D=3D sizeof(u64) check
allows a 32-bit access to capture the full 64-bit CPU register, corrupting
host_ste_base.

A 32-bit write to STRTAB_BASE will assign the entire 64-bit
regs->regs[rd] (including uninitialized upper 32 bits) to
smmu->host_ste_base.  Unlike the ARM_SMMU_CMDQ_BASE trap handler which
explicitly ensures the access is the correct width (if (len !=3D
sizeof(u64)) break;), this handler omits the validation.

>  	case ARM_SMMU_STRTAB_BASE_CFG:
> +		if (is_write) {
> +			/* Must only be written when SMMU_CR0.SMMUEN =3D=3D 0. */
> +			if (is_smmu_enabled(smmu))
> +				break;
> +			smmu->host_ste_cfg =3D val;
> +		}
> +		mask =3D read_write;
> +		break;

[Severity: High]
Similarly, is a length check missing for this 32-bit register?  The missing
len =3D=3D sizeof(u32) check allows 64-bit writes to pass through to a 32-b=
it
register offset.

A 64-bit write to STRTAB_BASE_CFG will invoke writeq_relaxed() on a
32-bit register offset (0x88), causing an unaligned or oversized write to
Device memory which triggers a fatal EL2 alignment fault.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D17
