Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73201355055;
	Fri, 24 Jul 2026 12:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895559; cv=none; b=iqPAKRVecpSxiMbVXbXnfJb4dPeaTGLaT6wEWlE8fWFdPSQiUi4Qtnq5xsNtgaJlt6fQrEHEoUORh5xLXM757wIabkVhHtLSeNLnukCIG35k6G3z2eLInuf82QPtqw7ItekX8m/a3o6KzvlGxODRigX4npnvoZBF1dPKA3d6Qks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895559; c=relaxed/simple;
	bh=IwA2hn0lcj/wifJQHt3WaaLAlTWt9eYsOfuO8hHzqgI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iuR9PhiylLL0MObE7RO6+kALetsfPdEJlaNpewWnWnXoRkcs1MKRXm29BOXiTBYmtBAe8+Ldd4Ui6Tckwl0imEGlXKRBKsJ4EdmFpAhjzv9sjRb4zY3CicDFDCehhKdpmeD707c25UzEioz59VRqox7cslpQ8lr4uKTgHBkhEu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOA4Xhjt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOA4Xhjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C241F000E9;
	Fri, 24 Jul 2026 12:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784895558;
	bh=wYi7Vdq3p+6Mwlt+PiWZy4MBrY6UMiI8c14pgvw4Mtw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BOA4XhjtBNwnCRmIfHWEAm+6/QAB4EzUrLN9PHRJUzy0eVmSjm5DFKItpJVBPTFnx
	 n6vbL74S/D6mfxSeZVKHS81K0q9yTQe+5+eeoBkYSfNzAQatPvJU05PO4kxYMn1BpV
	 WCdTbuSE2jE3ysjsXKq7U9P1xM+lCPXKTiWCvGwp4kVkeyhO+7xDdbxoZU+ptJ778B
	 qxvt3PoyKuIjhC1U7sln0xSDBvdK+FLg/cuy7GY0jFpa3FMhs52yecpkGVixe/OKsJ
	 ji3jzeGfa7nmWV5TO75Hu4sj+9G8X+4xl7+mzhqsCKm55FYuZaHVmoBSoioA5F+c/d
	 Ch9rxQ62FV/FA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 29/48] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-30-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-30-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:19:17 +0000
Message-Id: <20260724121917.A6C241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] GICv5 VMs configured with more than 988 SPIs will unconditionally =
fail to initialize because the default IRQ routing setup generates routing =
entries that exceed KVM_IRQCHIP_NUM_PINS.
--

--- Patch [29]: [PATCH v4 29/48] KVM: arm64: gic-v5: Add GICv5 SPI injectio=
n to irqfd ---
commit a9da966fc7b449adaa92917185e2770d6d012f6f
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
   =20
Now that there is support for GICv5 SPIs in KVM, update
vgic_irqfd_set_irq() to translate irqchip pins into GICv5 SPI IntIDs
before injecting them.

> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-=
irqfd.c
> index 19a1094536e6a..83e84151d7aa2 100644
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c

[ ... ]

> @@ -52,8 +57,8 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  		e->set =3D vgic_irqfd_set_irq;
>  		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
>  		e->irqchip.pin =3D ue->u.irqchip.pin;
> -		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
> -		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
> +		if (e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS ||
> +		    e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS)
[Severity: High]
This isn't a bug introduced by this patch, but does this check cause VM
initialization to fail if a GICv5 VM is configured with more than 988 SPIs?

When userspace configures a VM with nr_spis > 988,
kvm_vgic_setup_default_irq_routing() attempts to set up a 1:1 default routi=
ng
for all SPIs:

arch/arm64/kvm/vgic/vgic-irqfd.c:kvm_vgic_setup_default_irq_routing() {
	for (i =3D 0; i < nr; i++) {
		entries[i].gsi =3D i;
		entries[i].type =3D KVM_IRQ_ROUTING_IRQCHIP;
		entries[i].u.irqchip.irqchip =3D 0;
		entries[i].u.irqchip.pin =3D i;
	}
	ret =3D kvm_set_irq_routing(kvm, entries, nr, 0);
	...
}

Because kvm_set_routing_entry() caps e->irqchip.pin at KVM_IRQCHIP_NUM_PINS
(which is 988), any entries beyond 988 will be rejected here with -EINVAL,
causing VM initialization to abort.

>  			goto out;
>  		break;
>  	case KVM_IRQ_ROUTING_MSI:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D29
