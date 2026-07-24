Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEA7345ED9;
	Fri, 24 Jul 2026 12:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784894754; cv=none; b=JnQ4V6p/Ei4+3OqTzao9fnmS5c51rHnf97t8nXWaRN04ukiS048PIR9DNkt4F8ysSaO95XKv983qq0Klgqyzz836ZajR63uDvj/EL9wU9m2a+hGSBqTarQLMQSBpIhdXNWfsKAGTfS43w/AsDpCwesDsy/2nuxcmQIxlh6Qr7Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784894754; c=relaxed/simple;
	bh=NGyvXZ+G/DWsaeLLfakO/DEcr7jcwzc7uyTW88mAtsI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nRzqyeM2P1iJcv/Ns8x7IT75pkvxx281YZvDGJ8pPCQO/yd1YQfldYJgo/5yMqUKitPBzbT+4BEtM9mfgMQRtstwPd87BNIL15OCQK5Yacoa/OAtEhm5Tt+o17IcDs196yVItC1LNQWG0Kqr1Li81Y3utmgX3LRqdaO00NclQPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V377GNWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V377GNWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDA11F000E9;
	Fri, 24 Jul 2026 12:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784894752;
	bh=mgDtalFkhK6ExeQlrPOTxMbWYYLk/80ALR1aaPpcMTU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V377GNWprMBBIeyAqt3SCLzqV3mkaz0GBL12YWoffVEi4EpBmBKiAjnGi7D3wVFrh
	 eyW64oK0zyPFintLeqPUHcjTQITKKeW+RrWpKlnESJgp6QHJVLHJ966JkhrtsMxIxm
	 TNNxVv8KMpd8RSguGjLs+6SzjJZWF/Tm/9/DV3CFiOZp/FOwIljgIPMLcCJhuYpdv9
	 UGHe6udmi1Bgmg32KS8xcPbzK8BsgnxJTvaR52PP7UGLAjya7JhshEczafZlIHCzQW
	 Q5z6hDusWEySkYpOa0qN73Cp2ToP2Fh4sLSOu50H/KHZB0i+dkreBXtxMBXCvw5VP1
	 A812gWCRxBtZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 32/48] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260724104819.1296803-33-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-33-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:05:51 +0000
Message-Id: <20260724120552.6CDA11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Userspace writes to `GICV5_IRS_SPI_CFGR` are silently ignored with=
out validation, breaking restoration of SPI configurations across live migr=
ations.
- [Medium] The 64-bit registers GICV5_IRS_IST_BASER and GICV5_IRS_SPI_VMR l=
ack support for 32-bit guest MMIO accesses, violating the GIC architecture.
- [Medium] KVM_HAS_DEVICE_ATTR for KVM_DEV_ARM_VGIC_GRP_IRS_REGS incorrectl=
y fails with -EINVAL if VCPU 0 is not yet created, breaking feature enumera=
tion.
--

--- Patch [32]: [PATCH v4 32/48] KVM: arm64: gic-v5: Handle userspace acces=
ses to IRS MMIO region ---
commit 9b79670b7941a4c70c01c7a66f84cbfecafe7755
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region

As part of saving and restoring state of a GICv5-based system, userspace is
required to save/restore the IRS MMIO registers. Provide accessors to read
and write the IRS MMIO state. Where possible, the existing access mechanisms
are used, but for some registers the access is handled a bit differently as
they have wider effects.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> --- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c

[ ... ]

> @@ -455,84 +584,217 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_=
vcpu *vcpu, gpa_t addr,
>  	case GICV5_IRS_CR0:
>  		vgic->enabled =3D !!(val & GICV5_IRS_CR0_IRSEN);
>  		break;
> +	case GICV5_IRS_SPI_CFGR:
> +		break;

[Severity: High]
Does this silently ignore userspace writes to restore SPI configurations?

The commit message mentions blocking userspace from setting anything that
doesn't match what has been set already. However, the uaccess write handler
here just executes a break and returns 0 without validating the write or
applying any updates.

Could this cause SPI configurations (like edge vs level triggered) to be lo=
st
during VM migration, permanently leaving restored SPIs in their default sta=
te?

> +	case GICV5_IRS_IIDR:
> +		fallthrough;
> +	case GICV5_IRS_AIDR:
> +		break;
>  	default:
> -		return;
> +		return -EINVAL;
>  	}
> +
> +	return 0;
>  }

[ ... ]

> @@ -494,35 +673,50 @@ static const struct vgic_register_region vgic_v5_ir=
s_registers[] =3D {
> -	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_is=
t,
> -				  vgic_v5_mmio_write_irs_ist, 8,
> -				  VGIC_ACCESS_64bit),
> +	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_IST_BASER,
> +					  vgic_v5_mmio_read_irs_ist,
> +					  vgic_v5_mmio_write_irs_ist, NULL,
> +					  vgic_v5_mmio_uaccess_write_irs, 8,
> +					  VGIC_ACCESS_64bit),

[Severity: Medium]
Should these 64-bit registers support 32-bit MMIO accesses?

The region descriptor specifies only VGIC_ACCESS_64bit. The GIC architecture
mandates that 64-bit registers must also support 32-bit accesses, so valid
32-bit guest reads or writes might be improperly rejected.

Additionally, if 32-bit accesses were permitted, would the write handler in
vgic_v5_mmio_write_irs_ist() improperly clobber the upper 32 bits? It
appears to lack the update_64bit_reg() wrapper used elsewhere in KVM to
handle partial writes safely.

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c

[ ... ]

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
Does this break KVM_HAS_DEVICE_ATTR feature enumeration before VCPUs are
created?

If a VMM queries KVM_HAS_DEVICE_ATTR for KVM_DEV_ARM_VGIC_GRP_IRS_REGS
immediately after creating the VGIC device, kvm_get_vcpu(dev->kvm, 0) will
return NULL.

Because vgic_v5_parse_attr() returns -EINVAL when reg_attr->vcpu is NULL,
this causes feature probing to yield false negatives. As IRS registers are
VM-wide features, can we avoid this dependency on VCPU 0 during enumeration?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D32
