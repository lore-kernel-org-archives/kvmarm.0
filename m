Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426023090C4;
	Fri,  3 Jul 2026 16:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096576; cv=none; b=GZZIDrVgZ4pmih0O0wv/+2GD9KZluIU2oAEqU+lbTwaeGQczZ3poCPSaVf6vFPJkmXtYA2734o9ZkfPFymUtnh0pUo+KGExqSVUHsy99t/RAeaMqw9UZ6f/eacLYGd2qQ4zApCuvM2+TM3IdRKkpoA+IEhtDROCWt6geVyaHvUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096576; c=relaxed/simple;
	bh=KHHG8EMNn090gB4Y+gloj+Bq7+vIlro9Ydytj+QF2zA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EZzA+jGakFBsQO9wh2Mo+zwPLHxbxyFoPeHqsTrMOJCP0QpWRg2k+gJfj+a3KzYTbTyIP5c2igC4D/atNI7570KMeSST4mII6lf3LzHvXEm/kNZLf2GEtte7CyT6Rahsq9YCGdV+UP2CflsKuXYbytG0Bgb5Mps1Z1E4pG1XlpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KU+IJOcD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KU+IJOcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A19A1F000E9;
	Fri,  3 Jul 2026 16:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096575;
	bh=ckc/i2gLOl3ycPqJ6KqNbceZj2Y3K0P++Vf8htj+kJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KU+IJOcDwo05JbAKuI3WZjekOha74ytUHt9CAXDBNLWs5Hno8mqV2IDV3LJgy+3zY
	 Nf9I/1ylpK1VR2w9BSxXr6HivRy/oOTp0U8/fW2pDI6o+EtaJr30vaGf/VuB+hdgz4
	 R0tqjKtvHd3qE8NS1GA3IL4oGe1dLpZ0/yFglxdwo6MRIvEIPKf06xRyxr22p3jNFK
	 7dhv+OuwhDaoTJJ3bfjDqppUkVSBro3Ir6R9jtI1KO0F6GHxTE2i2O4R41UjuGfSZ9
	 ds/2PHEY0jdI0oQt1wu/AP8qD+KR4jcG26yb54FzNsm+20hK5Mlk/ebP4rs0BmiIkZ
	 VhXtcOnBkfYxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 31/40] KVM: arm64: gic-v5: Add GICv5 SPI injection to
 irqfd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260703154811.3355680-32-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-32-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:36:13 +0000
Message-Id: <20260703163614.9A19A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] The irqchip pin validation uses the dynamically configurable `=
nr_spis` without capping it to `KVM_IRQCHIP_NUM_PINS`, allowing userspace t=
o trigger a heap buffer overflow in `setup_routing_entry()`.
--

commit d433fac30bf4700a907f87295b758ddff1f36b7c
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd

This commit updates vgic_irqfd_set_irq() to translate irqchip pins into
GICv5 SPI IntIDs before injection. It also modifies the IRQCHIP route
validation to use the configured SPI count for GICv5.

> Also adjust IRQCHIP route validation for GICv5: use the configured SPI
> count, fall back to the default SPI count before VGIC init, and cap
> the accepted pin range to the generic irq routing table size.

The commit message states that the code caps the accepted pin range to the
generic irq routing table size, but it appears to use the configured SPI co=
unt
directly instead of capping it.

> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-=
irqfd.c
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c

[ ... ]

> @@ -45,15 +50,21 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			  struct kvm_kernel_irq_routing_entry *e,
>  			  const struct kvm_irq_routing_entry *ue)
>  {
> +	unsigned int nr_pins;
>  	int r =3D -EINVAL;
> =20
> +	if (vgic_is_v5(kvm))
> +		nr_pins =3D kvm->arch.vgic.nr_spis;
> +	else
> +		nr_pins =3D KVM_IRQCHIP_NUM_PINS;
> +
>  	switch (ue->type) {
>  	case KVM_IRQ_ROUTING_IRQCHIP:
>  		e->set =3D vgic_irqfd_set_irq;
>  		e->irqchip.irqchip =3D ue->u.irqchip.irqchip;
>  		e->irqchip.pin =3D ue->u.irqchip.pin;
> -		if ((e->irqchip.pin >=3D KVM_IRQCHIP_NUM_PINS) ||
> -		    (e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS))
> +		if (e->irqchip.pin >=3D nr_pins ||
> +		    e->irqchip.irqchip >=3D KVM_NR_IRQCHIPS)

[Severity: Critical]
Does this allow an out-of-bounds array write if userspace configures a
GICv5 VM with an nr_spis value larger than KVM_IRQCHIP_NUM_PINS?

If nr_pins can exceed KVM_IRQCHIP_NUM_PINS, the relaxed bounds check
here allows e->irqchip.pin to be larger than the size of the routing
table array.

The caller setup_routing_entry() uses this pin value to index directly
into the rt->chip array:

virt/kvm/irqchip.c:setup_routing_entry() {
    ...
    r =3D kvm_set_routing_entry(kvm, e, ue);
    if (r)
        goto out;
    ...
    rt->chip[e->irqchip.irqchip][e->irqchip.pin] =3D e->gsi;
    ...
}

Since KVM_IRQCHIP_NUM_PINS defines the size of the second dimension of
rt->chip, will a large e->irqchip.pin write the attacker-controlled e->gsi
value past the end of the array and corrupt the kernel heap?

>  			goto out;
>  		break;
>  	case KVM_IRQ_ROUTING_MSI:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D31
