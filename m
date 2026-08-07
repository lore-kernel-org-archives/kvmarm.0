Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74464314A95;
	Fri,  7 Aug 2026 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114380; cv=none; b=jsSwFRq3G/6p2A1EwjriT7P9p0vHwtX0Op4+XVIAaD84M+OzJD/+tM+TIOamffPLntW+8d3ZRUjaHn/SwH/iYPsOzt9VsjgqNvL7pfl4ubIPqrahiX7qCWo92+ftZXYzHrfGH0s+zI75LeoXuFngLYVDh3ecF3oXM/1Jx8OSUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114380; c=relaxed/simple;
	bh=HbS9WX2rdHfW3UAsc+PiZLcb2+G6+1LYWhnDiMB9kfs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iGpRHjDhw8AxEU19TEBJ+Xn9bLH1b0E/hwRDJf2Qffz/M1GDfvo3sTlu/2d7eH12H9fUAZcvanb/Vr/jNZ1dC9f9dcHU1t1T+TwQQr2JYn8MOLJQ6MKpqq6dvCIW6e5GiuDhmd3dd3SFZPDu/xaGPnkn0RQILoYD4Lw+Jc8AaCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yu+zKdxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yu+zKdxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC71A1F000E9;
	Fri,  7 Aug 2026 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786114379;
	bh=MpjMOa0rpZa0pOs3MVrxoZGJH+58bFuZR4So0VqS34Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yu+zKdxlVmlocbJU2p05zAiRb+JNFDpa8tKsidmeqw2jsIZ1AJw1z8+gRJtx6bk9r
	 59vIA8+dPbbg7UQAPOCcqAMB6gSz30IUz83TixCApR83wB701CNoWHPt5xtbzwzlGN
	 aetlfyTD10LYZqlJMFJtIVyRlbik61RpesPRPmrHU2gPdxfUCXFpuouQCrjnzPPfQV
	 6AuxqPtjCcCVKc6D/9yYfs5iA0CDUzUofKDmKzdFbCu7zDN4LeSMl5GPSG0naSDCyE
	 10XI4oegvEJyqO4sCgnnCzWGJuD58f+HnkI+h+E1aNnznkRz9UkJbk77sV3Gidrina
	 jVNdFkAmW6Z9A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260807111159.429128-23-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-23-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 14:52:58 +0000
Message-Id: <20260807145258.AC71A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] GICv5 SPI injection via IRQFD and KVM_IRQ_ROUTING_IRQCHIP is broke=
n due to missing UAPI INTID translation and incomplete vgic_get_irq() suppo=
rt.
- [High] PMU IRQ configuration is broken for GICv5 VMs due to missing UAPI =
INTID translation.
--

--- Patch [22]: [PATCH v5 22/49] KVM: arm64: gic-v5: Register the IRS IODEV=
 ---
commit 1f7c421def2656a75d9f4c6c3c9bc8b90309dbb8
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic-v5: Register the IRS IODEV

This commit registers the GICv5 IRS IODEV during vgic_map_resources. It
also exposes the IRS address configuration to userspace and allows setting
the number of SPIs handled by the GICv5 implementation.

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> index 90be99443df3b..8c2c6886af4e3 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c

[ ... ]

> @@ -224,31 +232,48 @@ static int vgic_set_common_attr(struct kvm_device *=
dev,

[ ... ]

> +		} else {
> +			/*
> +			 * GICv5 reports a number of SPIs, not a total number of
> +			 * interrupts. Require a multiple of 32 SPIs.
> +			 */
> +			if (val < VGIC_V5_DEFAULT_NR_SPIS ||
> +			    val > VGIC_V5_MAX_NR_SPIS ||
> +			    (val & 31))
> +				return -EINVAL;
> +
> +			mutex_lock(&dev->kvm->arch.config_lock);
> +			if (vgic_initialized(dev->kvm) || dev->kvm->arch.vgic.nr_spis)
> +				ret =3D -EBUSY;
> +			else
> +				dev->kvm->arch.vgic.nr_spis =3D val;
> +			mutex_unlock(&dev->kvm->arch.config_lock);
> +		}
> =20
>  		return ret;
>  	}

[Severity: High]
Does this leave PMU IRQ configuration broken for GICv5 VMs?

Since the UAPI INTID lacks the GICv5 internal hardware type bits, the
PMU configuration fails unconditionally during validation. When userspace
configures the PMU IRQ using the KVM_ARM_VCPU_PMU_V3_IRQ attribute (passing
a standard PPI), the check fails:

arch/arm64/kvm/pmu-emul.c:kvm_arm_pmu_v3_set_attr() {
    ...
    if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
        return -EINVAL;
    ...
}

Because irq_is_ppi() and irq_is_spi() require the GICV5_HWIRQ_TYPE bits
that are missing from the raw integer, will this cause PMU setup to fail
with -EINVAL for GICv5 VMs?

> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 59c6e6e766166..e03e820e43ff0 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -31,7 +31,12 @@
>  #define VGIC_MAX_SPI		1019
>  #define VGIC_MAX_RESERVED	1023
>  #define VGIC_MIN_LPI		8192
> -#define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
> +
> +/*
> + * The common IRQ routing table must accommodate all GIC types. GICv2 and
> + * GICv3 need 988 pins, while GICv5 needs 1024 pins.
> + */
> +#define KVM_IRQCHIP_NUM_PINS	1024

[Severity: High]
Does expanding the IRQ routing table to 1024 pins expose a gap in GICv5
SPI injection support?

While this expands the pins for GICv5, the underlying injection mechanisms
do not translate the UAPI INTID. For example, in vgic_irqfd_set_irq():

arch/arm64/kvm/vgic/vgic-irqfd.c:vgic_irqfd_set_irq() {
    ...
    unsigned int spi_id =3D e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
    ...
    if (!vgic_valid_spi(kvm, spi_id))
        return -EINVAL;
    ...
}

This calculates spi_id without the required GICV5_HWIRQ_TYPE_SPI bits,
causing vgic_valid_spi() to fail for GICv5.

Additionally, vgic_get_irq() hardcodes a NULL return for GICv5 SPIs,
which blocks injection entirely:

arch/arm64/kvm/vgic/vgic.c:vgic_get_irq() {
    ...
    if (vgic_is_v5(kvm))
        return NULL;
    ...
}

Will this prevent guests using device pass-through or virtio devices
that rely on SPIs from receiving interrupts via irqfd/eventfd?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D22
