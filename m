Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CB52D12ED;
	Fri,  7 Aug 2026 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116203; cv=none; b=NcwD2YOTBRCcr0ZcO9uuqUfKdqujUpmQDRSmUTjqUn1dv7YXl1X3f1xJHWRz08lUXW7ynkX/lYpoAXcvepx5vMQL0LZqjuwTONlRvnSWFCrdQWT8jJVRYXT30Y6ypi5+/b8WdwDWHmP1cFaHTtstylSBPrNZ8Hs6D6qJ2U9+3DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116203; c=relaxed/simple;
	bh=iUjRlGxqAfYWQ0lt+0/CnxJ8mHAHS+muqmBKAC00qQQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qiYkMpwYitBfwqI2nmHL7VfIfORC+xSRp4L3u8a7Wlr55t2GDqs2mklwPB5hDEfioEROPYga5ypznkFPSWTVDFFFuajmqeTYHZ5epXJxMO6bOqo8I2xbPTLlKrSUEH6ejJFtxlduZe5oSOxGQJpveRC5mU+DbtVdQYR0up12wis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=la3kYiid; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="la3kYiid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5061F000E9;
	Fri,  7 Aug 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786116202;
	bh=+BsYEP45AmJZZjZf+8yWu6DGNmsLYDC9IbdVjgNQeSo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=la3kYiidhvmor4PBQTZ12rTWOyoQrZz/Tv/vKqpJrG3qkfVPMekIjqNkP3qs06VlT
	 v4bHDifRr7MTnD3Ul65KeN4XewmDHIWwKzAKueyQLU9I9wyHikvUjJL96UghRL4Y0Z
	 mzVZevD51C387vDePgEqS9HZjbdzk0T8t77Z75f54SbWwmEVgx1vhHCEmXUuUh9pjk
	 +Wj+IEcBaIDXuHBi3vOy/tePKgHBQHopxiuvjPQ/oiAGbDLvYvdaIJy5RbYBzYpf2x
	 +tcCpoo4uUtWg/qOj4jdkArlRzDevHMG1NszscCGHnZtgms2GgFSHZXSRavAcNOx4z
	 FFeNWujtN1giw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 27/49] KVM: arm64: gic-v5: Support SPI injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260807111159.429128-28-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-28-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 15:23:21 +0000
Message-Id: <20260807152322.3E5061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Spectre v1 gadget in `vgic_get_irq` for GICv2/GICv3 SPIs due to im=
proper use of `array_index_nospec`.
--

--- Patch [27]: [PATCH v5 27/49] KVM: arm64: gic-v5: Support SPI injection =
---
commit 33e91ef5257fc1901a945d6c3b84eddc64cc9e09
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Support SPI injection

This commit adds support for injecting GICv5 SPIs to the core VGIC code.
It updates vgic_get_irq() to allow GICv5 SPI lookups by ID and introduces
specific irq_ops for handling their pending state without AP list queueing.

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 023792c28fc5c..d571fafb07f32 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c

[ ... ]

> @@ -86,19 +86,31 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm,=
 u32 intid)
>   */
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
>  {
> -	/* Non-private IRQs are not yet implemented for GICv5 */
> -	if (vgic_is_v5(kvm))
> -		return NULL;
> +	enum kvm_device_type type =3D kvm->arch.vgic.vgic_model;
> =20
>  	/* SPIs */
> -	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
> -	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
> -		intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_P=
RIVATE_IRQS);
> -		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
> +	if (__irq_is_spi(type, intid)) {
> +		switch (type) {

[ ... ]

> +		default: {
> +			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +
> +			if (intid < max_intid) {
> +				intid =3D array_index_nospec(intid, max_intid);
> +				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];

[Severity: High]
This is a pre-existing issue, but does this array_index_nospec() usage leave
the kernel open to speculative out-of-bounds reads?

Since array_index_nospec() only bounds the upper limit, if a guest or
userspace ioctl triggers this path speculatively with an intid less than
VGIC_NR_PRIVATE_IRQS (e.g., 0 to 31), the value is passed through unchanged.

When the code then subtracts VGIC_NR_PRIVATE_IRQS, it underflows to a
negative index, allowing speculative access to the memory immediately
preceding the spis array. Additionally, if the CPU speculatively bypasses
the bounds check with a large intid, array_index_nospec() clamps it to 0,
which again underflows when the subtraction occurs.

Should the array_index_nospec() instead be applied to the computed array
index after the subtraction?

> +			}
> +		}}
>  	}
> =20
>  	/* LPIs */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D27
