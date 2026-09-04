Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140F35DA64;
	Fri,  4 Sep 2026 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528859; cv=none; b=K/l1WpHm8CJNLpA7aK87RLgb9rxjtD2xsBfZaQWB5vX0S76wPiI1juvoglgRcPdZc8zqji2pr+3qF4cC2ePB8SLif3j9UabDbQqTQJekMubbXHqLdog0u7cr19pRp7/z83Kf6b9hcbBOT4b6r1UD0pY6x7VR24H827kj3/u6OyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528859; c=relaxed/simple;
	bh=/dm5FD6Qj4yIoOSXM98Aslc4UW7+h3TiJOG9Z39+9ck=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lj5dcLOKvE6l0TCEogynbWTEOxJluq8omiYfxAVIMKHjQnsdyiO7SPY8/qgmQAkUbKd9KSUY+WtWnN1VwCwT5953FUd8eomz3yVCSdUWN8e7XppmBcDeYP9D4kuGCyLQhJ3azbWOKL+Z3+tbUvDj2mIX/Qq22NygBmSbva5cTfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRXNywYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRXNywYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEC21F00A3D;
	Fri,  4 Sep 2026 13:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788528857;
	bh=u9HDguz8GZOQD5/ELmJwG1FyHCO8FBv55xEDPINhapU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QRXNywYAOrRxFpIl+Wi5WIPY3kqxCilUu+X5hYRG85J3tLmr8LpHXxwR+C5IJTnsg
	 3Mnn8jxVlsyaYvXefpzNkrZrQQkyYew/CXDa6A0JZ+x4polfnq5BoyTxFDhG5oqJWe
	 duT6Yu9xxpZEwpFkYQl54jRnpamW80MYI7GdsLNAbeaobFi/PkHP8fUtZTVdoVWrRt
	 8RlWVPSSEdY5pXuExb8pVMfAmqqIgwN4zNp5w2lvrbxEXyLgPD8xHgWgnvFcJQV+nC
	 AIYgShXxlKcVdjCyfKEYzZlqsRC6zus9TCqZ2rXekZErDaVLGtZ+KQay2kiUpjdRQX
	 eWkbSfE7utQcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 32/49] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904113404.4051341-33-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-33-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:34:16 +0000
Message-Id: <20260904133417.6BEC21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Failure to clear lpi_ist_restore_pending when IST_BASER.Valid is c=
leared by userspace, permanently preventing VM execution.
- [Medium] KVM_HAS_DEVICE_ATTR fails with -EINVAL for KVM_DEV_ARM_VGIC_GRP_=
IRS_REGS if no VCPUs are created yet.
- [Medium] Userspace can bypass KVM's intentional 16-bit limit for GICV5_IR=
S_IDR2.ID_BITS, potentially causing oversized memory allocations.
--

commit 114e2a53a8a49611a9a0cdd053417985c38f2cd2
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region

As part of saving and restoring the state of a GICv5-based system,
userspace must save and restore the IRS MMIO registers. These include
important information such as the guest IST configuration, and KVM
must present consistent state to the guest after migration.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> index 06d2deb770a6d..9e9853b88ce2a 100644
> --- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
[ ... ]
> @@ -431,90 +489,231 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_=
vcpu *vcpu, gpa_t addr,
[ ... ]
> +static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t a=
ddr,
> +					  unsigned int len, unsigned long val)
> +{
[ ... ]
> +	case GICV5_IRS_IDR2:
> +		/* We always support LPIs */
> +		if (!(val & GICV5_IRS_IDR2_LPI))
> +			return -EINVAL;
[ ... ]
> +		/* We can't present more bits than we have support for in HW */
> +		if (FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val) >
> +		    vgic_v5_irs_ist_id_bits(&irs_caps))
> +			return -EINVAL;

[Severity: Medium]
Can userspace bypass KVM's intentional 16-bit limit for
GICV5_IRS_IDR2.ID_BITS here?

KVM caps this to 16 during initialization, but this check appears to allow
userspace to restore a value up to the hardware maximum. This could
potentially cause architecturally inconsistent state and oversized host mem=
ory
allocations.

> +
> +		/* Min LPI ID bits must be greater than or equal to the HW */
> +		if (FIELD_GET(GICV5_IRS_IDR2_MIN_LPI_ID_BITS, val) <
> +		    vgic_v5_irs_min_lpi_id_bits(&irs_caps))
> +			return -EINVAL;
[ ... ]
> +		irs_data->idr2.id_bits =3D FIELD_GET(GICV5_IRS_IDR2_ID_BITS, val);
> +		break;
[ ... ]
> +	case GICV5_IRS_IST_BASER:
> +		if (irs_data->ist_baser.valid &&
> +		    !vgic_v5_ist_baser_matches(irs_data, val))
> +			return -EINVAL;
> +
> +		if (!irs_data->ist_baser.valid &&
> +		    (val & GICV5_IRS_IST_BASER_VALID))
> +			irs_data->lpi_ist_restore_pending =3D true;
> +
> +		vgic_v5_update_irs_ist_baser(irs_data, val);
> +		break;

[Severity: High]
If userspace sets GICV5_IRS_IST_BASER with Valid=3D1 (setting
lpi_ist_restore_pending=3Dtrue) and later clears it by setting Valid=3D0, d=
oes
lpi_ist_restore_pending remain true?

If the state machine fails to clear this pending flag, it appears this would
cause vgic_v5_map_resources() to fail unconditionally and permanently preve=
nt
VM execution.

> +	case GICV5_IRS_IST_CFGR:
[ ... ]
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> index 599ab4efc1db5..f1f1fcb08161f 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -786,6 +786,9 @@ int vgic_v5_parse_attr(struct kvm_device *dev, struct=
 kvm_device_attr *attr,
>  		mpidr_reg =3D VGIC_TO_MPIDR(vgic_mpidr);
>  		reg_attr->vcpu =3D kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
>  		break;
> +	case KVM_DEV_ARM_VGIC_GRP_IRS_REGS:
> +		reg_attr->vcpu =3D kvm_get_vcpu(dev->kvm, 0);
> +		break;
>  	default:
>  		return -EINVAL;
>  	}

[Severity: Medium]
If userspace probes for the KVM_DEV_ARM_VGIC_GRP_IRS_REGS capability before
creating any VCPUs, does this unconditionally fetch VCPU 0 and subsequently
fail the attribute parsing with -EINVAL?

It looks like this breaks the standard KVM capability probing sequence where
userspace calls KVM_HAS_DEVICE_ATTR on a newly created VGIC device before
calling KVM_CREATE_VCPU.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D32
