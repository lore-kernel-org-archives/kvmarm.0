Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573D32E7389;
	Tue, 23 Jun 2026 08:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782203438; cv=none; b=TI3zcVjti9bIoghCSSkQB9rovbvHlOxMTFidWUiXmMLX2MXagy9ZI6OXSmW/BFDF9F4Fl43mXbwpiSFAiivhH6uoKj6T7D5Go0rxJSSqw3Qw4vPKmtAMFuqo+HIHBdMt7f8qmCENjmHB0PXyRotzlJ4tKiVT4AIcvqD41cXrq9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782203438; c=relaxed/simple;
	bh=zHy/4SDm4gevy9Nrqn/DmaomIgQ1NNEIfBIp1uG5s/E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nPVs8KYitWe9oDHu4Qx0B0+aDFMkW5Xu/GBqe/vEVgONfxMLM50UN3DAUYghd+czM1Qp45+IkiUj07k08OqrKeN4A+USMX4ltohCWP8zFYnhY0RKkGzYGqQELj5Cdxbx/n2p9L9SjiylMhvhctO8/Zp1u8J8WtA0zcCdGk0+c9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0lkuPzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0lkuPzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC6F1F000E9;
	Tue, 23 Jun 2026 08:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782203437;
	bh=TYs+oCmAlfzBmfvYUmiGUyoWok0/0BBwKASHaksLMqw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L0lkuPzZM/aLIPhL8SYkCjijb1QtkhcQ9UDhCv5w8t7qQYGatOwsnCJ8bJkDqORNl
	 sWd97IkirrBJlJpLsahuX/J9x/avKOttkQuAMARDmmWcOsoCjlyWeT4kKaQ0mu8FXY
	 4UZabAPn0f0uwnQtFoI3fwre/F6ceAgoxbLkk3hD7OSYLXtZcHVS4QfKKNO38mZSQ3
	 9iITmm9BRlo1Xs/TgVqfkgmmBmni3bi/MUb3buC9B7fa8ZHtlPSgisYAqnQspwG/Hi
	 vyej1QECcOf7qQWpCo+Hn+rdmGDsC8Bb1optVh9O6G+S3tMIiZHxQAM1kzga94h4St
	 94rTpYQTFxgKQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] KVM: arm64: Set irqfd->producer to enable vLPI
 routing updates
Reply-To: sashiko-reviews@lists.linux.dev
To: leixiang <leixiang@kylinos.cn>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260623081433.21250-1-leixiang@kylinos.cn>
References: <20260622075103.35164-1-leixiang@kylinos.cn>
 <20260623081433.21250-1-leixiang@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 08:30:36 +0000
Message-Id: <20260623083036.BCC6F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Critical] Early return in `kvm_arch_irq_bypass_del_producer` skips clear=
ing `irqfd->producer`, leaving a dangling pointer that leads to a Use-After=
-Free.
- [High] Late assignment of `irqfd->producer` allows concurrent routing upd=
ates to silently skip hardware unmapping, leaking vLPI mappings.

Pre-existing issues:
- [High] Lockless and non-seqcount-protected access to `irqfd->irq_entry` c=
auses torn reads of MSI routing fields.
--

commit 6730fdc5cdf162e59409e000dad54d0460124435
Author: leixiang <leixiang@kylinos.cn>

KVM: arm64: Set irqfd->producer to enable vLPI routing updates

ARM64's kvm_arch_irq_bypass_add_producer() never sets irqfd->producer,
so kvm_irq_routing_update() never calls the ARM64 routing hook. That
hook unmaps the vLPI and falls back to software injection when an
irqfd's MSI routing changes. Set irqfd->producer once
kvm_vgic_v4_set_forwarding() succeeds and clear it in del_producer().

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index d84e80b2ce546..54d4bb5d01899 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2891,6 +2891,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_byp=
ass_consumer *cons,
>  	struct kvm_kernel_irqfd *irqfd =3D
>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>  	struct kvm_kernel_irq_routing_entry *irq_entry =3D &irqfd->irq_entry;
> +	int ret;
> =20
>  	/*
>  	 * The only thing we have a chance of directly-injecting is LPIs. Maybe
>  	 * one day...
>  	 */
>  	if (irq_entry->type !=3D KVM_IRQ_ROUTING_MSI)
>  		return 0;

[Severity: High]
This isn't a bug introduced by this patch, but does this lockless access to
irqfd->irq_entry cause torn reads of MSI routing fields?

KVM_SET_GSI_ROUTING updates this struct under irqfds.lock and
irqfd->irq_entry_sc seqcount. The lockless read here can observe a torn
state (e.g., mismatched MSI devid and data), causing
vgic_its_resolve_lpi() to resolve an arbitrary, unintended LPI.

> -	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
> -					  &irqfd->irq_entry);
> +	ret =3D kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
> +					 &irqfd->irq_entry);
> +	if (ret)
> +		return ret;
> +
> +	spin_lock_irq(&irqfd->kvm->irqfds.lock);
> +	irqfd->producer =3D prod;

[Severity: High]
Does this late assignment of irqfd->producer allow concurrent routing updat=
es
to silently skip hardware unmapping, leaking vLPI mappings?

kvm_vgic_v4_set_forwarding() maps the vLPI, but irqfd->producer is published
afterward. A concurrent routing update will see irqfd->producer =3D=3D NULL=
 and
skip unmapping the vLPI, which relies on irqfd->producer being set to invoke
kvm_arch_update_irqfd_routing().

Once add_producer() completes, it unconditionally publishes irqfd->producer.
The vLPI is now permanently bound in hardware despite KVM treating the
routing as non-MSI.

> +	spin_unlock_irq(&irqfd->kvm->irqfds.lock);
> +
> +	return 0;
>  }
> =20
>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> @@ -2913,6 +2922,10 @@ void kvm_arch_irq_bypass_del_producer(struct irq_b=
ypass_consumer *cons,
>  	struct kvm_kernel_irqfd *irqfd =3D
>  		container_of(cons, struct kvm_kernel_irqfd, consumer);
>  	struct kvm_kernel_irq_routing_entry *irq_entry =3D &irqfd->irq_entry;
> =20
>  	if (irq_entry->type !=3D KVM_IRQ_ROUTING_MSI)
>  		return;

[Severity: Critical]
Does this early return based on the current routing type skip clearing
irqfd->producer, leaving a dangling pointer?

When an irqfd's routing is updated from MSI to non-MSI,
kvm_arch_update_irqfd_routing() unmaps the vLPI but intentionally leaves
irqfd->producer populated.

If the producer is later unregistered, kvm_arch_irq_bypass_del_producer()
hits this early return because the routing is now non-MSI. This completely
skips the newly added irqfd->producer =3D NULL assignment.

The KVM irqfd retains a dangling pointer to the freed producer. A subsequent
routing update will dereference the freed pointer via irqfd->producer->irq =
in
kvm_arch_update_irqfd_routing(), leading to a use-after-free.

> +	spin_lock_irq(&irqfd->kvm->irqfds.lock);
> +	irqfd->producer =3D NULL;
> +	spin_unlock_irq(&irqfd->kvm->irqfds.lock);
> +
>  	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623081433.2125=
0-1-leixiang@kylinos.cn?part=3D1
