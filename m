Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792653385;
	b=zDr0cwykHXjRyCVufOPDnKnb1+KAKxEuoHqq6nVFe27KC0FDi2ZxvoC/C8Q0r2fE8cPe
	 zSPs9tSrjw9IZjO1kQFSRIlJfq/1/X9BYQ9AiM8Iib6lqpusL3GfA2pd5SCA32RSxaW3Z
	 nUInCaXeMj/UwMf5NHIOVz692w6EqffWzpTcXu/QtmXA9cPcmUu1UWb7j9jBTn7A1arEK
	 d/xrUoWPtfByrAi+FlNOa6HP/8MaybkFjT2/z8PhmGrZdSFJOlY1GoE+W0zLRafVGSCbo
	 xTTVIaXCzL11kT/hCdwq4FQeCGd8rU2wazeBdwpf2zLUJesRMeCxRoDLUVcwshGAo7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792653385;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lJ5fUpweQrhu19h9RLQKpY4El11g5fZEYmI8m1UfYzE=;
	b=LYfwwDK0iTye+qrbd8LYqU7+ML3KvTI0ZvTllt1+GZo7qYUhhIeA+BKLyMiSYRWFHEo4
	 x0i8dlOJvc7NhQ+4krcSS1ETwsMBu0fvXoQJDpd9Ot7hf6QS9fmwejoG5gHFFZx9jsz6J
	 8D8Yu9dw2zdWFmcRfKyQvYtnX2Ghbb47bfs8oHKz0k6K2NB6MtuAeBVa72YeL8//61k1P
	 q4vrF39IMEosmlzO+/+lmhQeTQx+ioWbRtaqzx8NFc5SPuiVMIIkw8sr0G6p5C4NA0u6v
	 mc5TfkZlgqbw7CmkC/VebIOCqfkrZW07c3I/47itrMkme79uM3QrbwkwOEZxmjbRqUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0iq0X7W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02B9606A31B;
	Thu, 22 Oct 2026 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0iq0X7W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0341F000C1;
	Thu, 22 Oct 2026 07:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792653384;
	bh=lJ5fUpweQrhu19h9RLQKpY4El11g5fZEYmI8m1UfYzE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m0iq0X7WOmi/mqiU+pcCpnG2votXZr/8Uchz/R19oEurGI3lp+DRZHOO6D2YYHHgk
	 +wM1eipjxCx2lda79Ixb+mbwdcnea870TmHm6Md9mnJPOmQbzW9XqV50SvTYoImTN9
	 D9KuCGJ/8A8gomACDr5AiX9zYR4KP9B1huPlmmkOBX0PDFaqXgiaSqLFK8iXHqTTW/
	 wiE8Lj/tdNKh7OxxKc5pBXtNiyhvOD/Ji06Y8cACKFIguPYot9+gJbkMEVRRlKn4BX
	 5WT0bOVZ52KQ6uqyg+UuiEU3b2GvvkNKMxbed2zjhljZHGqOAqisMyJUmjvi9aboJN
	 jpLXPcFsG7vtw==
Message-ID: <sashiko-outbox-181122@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/3] KVM: arm64: vgic-v2: Don't drop pending writes
 to active level IRQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261022064628.4206-2-kmehltretter@gmail.com>
References: <20261022064628.4206-1-kmehltretter@gmail.com>
 <20261022064628.4206-2-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 07:16:23 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] KVM: arm64: vgic-v2: unbacked GICH_LR_HW pending state after activ=
e ISPENDR
- [Medium] KVM: arm64: vgic-v2: preserved pending_latch on restore of activ=
e level IRQ
--

commit 559e1b17a5a169279b080f4ac07688f66063cf6a
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: vgic-v2: Don't drop pending writes to active level IRQs

This commit preserves pending_latch in vgic_v2_fold_lr() when a
level-triggered interrupt was already active or had GICD_ISPENDR written wh=
ile
present in a list register. It adds a latch_written flag to struct vgic_irq=
 to
track pending writes that occur while irq->on_lr is set and clears it when
clearing pending state or folding list registers.

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 7182f63fc9382..37474ea2431c5 100644
> --- a/arch/arm64/kvm/vgic/vgic-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-v2.c
> @@ -57,7 +57,7 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 =
val)
>  {
>  	u32 cpuid, intid =3D val & GICH_LR_VIRTUALID;
>  	struct vgic_irq *irq;
> -	bool deactivated;
> +	bool deactivated, was_active;
> =20
>  	/* Extract the source vCPU id from the LR */
>  	cpuid =3D FIELD_GET(GICH_LR_PHYSID_CPUID, val) & 7;
> @@ -71,7 +71,8 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32 =
val)
> =20
>  	scoped_guard(raw_spinlock, &irq->irq_lock) {
>  		/* Always preserve the active bit, note deactivation */
> -		deactivated =3D irq->active && !(val & GICH_LR_ACTIVE_BIT);
> +		was_active =3D irq->active;
> +		deactivated =3D was_active && !(val & GICH_LR_ACTIVE_BIT);
>  		irq->active =3D !!(val & GICH_LR_ACTIVE_BIT);
> =20
>  		if (irq->active && vgic_irq_is_sgi(intid))
> @@ -88,9 +89,15 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32=
 val)
> =20
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> +		 * A latch written while the irq was active is a new pending
> +		 * state. A write while the irq was in the LR may also have
> +		 * followed the ack, so preserve it too.
>  		 */
> -		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
> +		if (irq->config =3D=3D VGIC_CONFIG_LEVEL &&
> +		    !(val & GICH_LR_PENDING_BIT) &&
> +		    !was_active && !irq->latch_written)
>  			irq->pending_latch =3D false;

[Severity: Medium]
Could checking !was_active here cause a spurious second interrupt delivery
after saving and restoring a KVM_DEV_TYPE_ARM_VGIC_V2 guest with an active
level-triggered interrupt?

Unlike KVM_DEV_TYPE_ARM_VGIC_V3, which exposes KVM_DEV_ARM_VGIC_GRP_LEVEL_I=
NFO
and returns only irq->pending_latch to userspace in
arch/arm64/kvm/vgic/vgic-mmio.c:vgic_uaccess_read_pending()->__read_pending=
(),
KVM_DEV_TYPE_ARM_VGIC_V2 returns irq_is_pending(irq):

    switch (vcpu->kvm->arch.vgic.vgic_model) {
    case KVM_DEV_TYPE_ARM_VGIC_V3:
        if (is_user) {
            val =3D irq->pending_latch;
            break;
        }
        fallthrough;
    default:
        val =3D irq_is_pending(irq);
        break;
    }

When a GICv2 guest is saved while a level-triggered interrupt is active
(irq->active =3D=3D true) and its device line is still asserted
(irq->line_level =3D=3D true, irq->pending_latch =3D=3D false), userspace r=
eads 1 from
both GIC_DIST_ACTIVE_SET and GIC_DIST_PENDING_SET.

On restore, userspace writes 1 to GIC_DIST_ACTIVE_SET via
vgic_mmio_uaccess_write_sactive(), setting irq->active =3D true, and writes=
 1 to
GIC_DIST_PENDING_SET via vgic_uaccess_write_spending()->__set_pending(),
setting irq->pending_latch =3D true:

    int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
                                    gpa_t addr, unsigned int len,
                                    unsigned long val)
    {
        __set_pending(vcpu, addr, len, val, true);
        return 0;
    }

Previously, once the guest cleared the device condition (lowering
irq->line_level) and deactivated the interrupt, vgic_v2_fold_lr() saw
!(val & GICH_LR_STATE) and cleared irq->pending_latch =3D false. With the
!was_active check in vgic_v2_fold_lr(), won't irq->pending_latch remain set
across the deactivation of the restored active interrupt and cause the
interrupt to be injected a second time?

> +		irq->latch_written =3D false;
> =20
>  		/* Handle resampling for mapped interrupts if required */
>  		vgic_irq_handle_resampling(irq, deactivated, val & GICH_LR_PENDING_BIT=
);

[Severity: High]
What happens for a mapped level-triggered interrupt (irq->hw =3D=3D true,
irq->config =3D=3D VGIC_CONFIG_LEVEL, and !vgic_irq_needs_resampling(irq), =
such as
the architected timer interrupt) when the guest writes GICD_ISPENDR0 while =
the
interrupt is active?

In arch/arm64/kvm/vgic/vgic-mmio.c:vgic_mmio_write_spending()->__set_pendin=
g():

    if (irq->on_lr)
        irq->latch_written =3D true;

    irq->pending_latch =3D true;
    if (irq->hw && !is_user)
        vgic_irq_set_phys_active(irq, true);

Because the physical interrupt is already active in the host distributor for
the first in-flight delivery, vgic_irq_set_phys_active(irq, true) coalesces
with the existing physical active state. When the guest then deactivates the
first delivery (via GICC_EOIR / GICC_DIR in hardware, or via the EOIcount p=
ath
in vgic_v2_fold_lr_state()->vgic_v2_deactivate() writing GIC_CPU_DEACTIVATE=
),
the physical interrupt is deactivated in the host distributor.

When vgic_v2_fold_lr() runs on exit, was_active or irq->latch_written is tr=
ue,
so irq->pending_latch remains true while irq->active becomes false. However,
neither vgic_v2_fold_lr() nor
arch/arm64/kvm/vgic/vgic.c:vgic_irq_handle_resampling() re-activates the
physical interrupt in the host distributor (and if lr_deactivated &&
irq->line_level holds with the physical line low, vgic_irq_handle_resamplin=
g()
explicitly clears the physical active state):

    if (unlikely(vgic_irq_needs_resampling(irq))) {
        resample =3D !(irq->active || irq->pending_latch);
    } else if (lr_pending || (lr_deactivated && irq->line_level)) {
        irq->line_level =3D vgic_get_phys_line_level(irq);
        resample =3D !irq->line_level;
    }

    if (resample)
        vgic_irq_set_phys_active(irq, false);

On the next guest entry,
arch/arm64/kvm/vgic/vgic-v2.c:vgic_v2_populate_lr()->vgic_v2_compute_lr() s=
ees
irq->active =3D=3D false and irq_is_pending(irq) =3D=3D true from irq->pend=
ing_latch:

    if (irq->hw && !vgic_irq_needs_resampling(irq)) {
        val |=3D GICH_LR_HW;
        val |=3D irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
        if (irq->active)
            allow_pending =3D false;
    }

    if (allow_pending && irq_is_pending(irq)) {
        val |=3D GICH_LR_PENDING_BIT;

Can this populate the list register with GICH_LR_HW | GICH_LR_PENDING_BIT
while the corresponding physical interrupt is inactive in the host
distributor, violating the hardware-bit consistency requirement and trigger=
ing
a second physical deactivation when the guest completes the second delivery?

> =20
>  		irq->on_lr =3D false;
>  	}

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022064628.4206=
-1-kmehltretter@gmail.com?part=3D1
