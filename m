Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792652981;
	b=dCVPNwFbE98xJQ+PHQ6uumLuZRP8XDVOgy5tCwKiZbggEcJ5IGSzu+iVI//d2jhHaDPg
	 2bm8tX69B6xrmpNmCc5AgnGYNt0O8XN4s7ID7dld1nguoJGLqn7HG80vEIWs2qSZ5ab9Z
	 7dK6+7TrdCku0S1EjomG+w4i9EJe9br9+xLTIIio9l2lUcMurFJ71EjluWeUe9kBwng2x
	 UtOn9VxcNW9uFycCevXMcYxIdiYzuA9G1h6SgurOi6FtzF+T77uWhIWRwhQkPTXfoncWg
	 RXPnOFqrDL1fYHMdlSI1i9OuA5S2oSqwpaLwjlmtJEzYUZKObHdHiYjaNJMjFmzVcaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792652981;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qaaOleomERGZ2ShG2SazR0MfP70bjjcAJQTWOSGLHkc=;
	b=S3fIk+WuIIOgjc2VVFQCBj3TVFAqy02dCXnhyIZP/zZlhF7wbcr2MfEOMdpKPotxztP+
	 L6BMK2KCmY0GzJ8rV2E3Pi+b7KDhW6Kv+HVR7ATZpCKZj6zAASGl00ZFiOk9pbshKaln2
	 QWht7v3rvCTC2AB+zGc0aaEH8tsLE88iqBNwDSTXEZI0f44pdy6stLfsRW8IVeyORyGah
	 XH46KZ21UEOXP1hfewmOIG3YfRdLdepgO8EPyk4/n0P/Zi+FcPPCdiGtcL0pRpbqVG2Nq
	 72BJk9vWS5f7pb2KIJhtjt5nrHUNknbqMa5hNyr9ixu4uRd4JrWUcloA3/S7NnXohaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2JplZFB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7583D606A31F;
	Thu, 22 Oct 2026 07:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G2JplZFB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98DA1F000C1;
	Thu, 22 Oct 2026 07:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792652981;
	bh=qaaOleomERGZ2ShG2SazR0MfP70bjjcAJQTWOSGLHkc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G2JplZFBgYRklu8fsjD6Ff5fIwA/cf+xIUJyo5njE5OnZrZNAD28+u0JL7ZLWKVS6
	 lk0o30nXUOY5ZCYprhDFi+udWGnI6yFzenvjOwmi3fvjraWd5peeJQ1FkZ0KwfVlPV
	 CY/0kSqqq/sSctaLQkRNm1j35RIObqIM6EeTvK6snk7wJoyjD7G1Av2mLF4chaaKfz
	 MKKMbznVmEGBigGPdTwoSL4jVYeXD1jeR61WfhGdjxcZK2TmTaDfHrJnXW9ttq3Jek
	 jSjyA4bh5a7YqI0v2ePJ+568ZgIM4lRvrksqW0/qm1TvGPA0uKL/o2dxuDMeH369np
	 VwlJJBZPw9ShQ==
Message-ID: <sashiko-outbox-181111@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/3] KVM: arm64: vgic-v3: Don't drop pending writes
 to active level IRQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261022064628.4206-3-kmehltretter@gmail.com>
References: <20261022064628.4206-1-kmehltretter@gmail.com>
 <20261022064628.4206-3-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 07:09:40 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM: arm64: vgic-v3: vgic_v3_fold_lr() preserves latch on deactiva=
ted HW IRQ
--

commit 0c743aae5548587f04c81ee3dc502841f4713aff
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: vgic-v3: Don't drop pending writes to active level IRQs

This commit updates vgic_v3_fold_lr() so that a soft-pending latch written
while a level-triggered interrupt is active or present in a list register is
preserved across deactivation.

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 726e20a1da6e7..8009dc6df00db 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -75,7 +75,7 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 =
val)
>  {
>  	struct vgic_irq *irq;
>  	bool is_v2_sgi =3D false;
> -	bool deactivated;
> +	bool deactivated, was_active;
>  	u32 intid;
> =20
>  	if (vcpu->kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
> @@ -93,7 +93,8 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u64 =
val)
>  		/* Always preserve the active bit for !LPIs, note deactivation */
>  		if (irq->intid >=3D VGIC_MIN_LPI)
>  			val &=3D ~ICH_LR_ACTIVE_BIT;
> -		deactivated =3D irq->active && !(val & ICH_LR_ACTIVE_BIT);
> +		was_active =3D irq->active;
> +		deactivated =3D was_active && !(val & ICH_LR_ACTIVE_BIT);
>  		irq->active =3D !!(val & ICH_LR_ACTIVE_BIT);
> =20
>  		/* Edge is the only case where we preserve the pending bit */
> @@ -103,9 +104,15 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u=
64 val)
> =20
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> +		 * A latch written while the irq was active is a new pending
> +		 * state. A write while the irq was in the LR may also have
> +		 * followed the ack, so preserve it too.
>  		 */
> -		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
> +		if (irq->config =3D=3D VGIC_CONFIG_LEVEL &&
> +		    !(val & ICH_LR_PENDING_BIT) &&
> +		    !was_active && !irq->latch_written)
>  			irq->pending_latch =3D false;
> +		irq->latch_written =3D false;

[Severity: High]
What happens here when a mapped level-triggered interrupt (irq->hw is true,
irq->config =3D=3D VGIC_CONFIG_LEVEL, and !vgic_irq_needs_resampling(irq), =
such
as the architected timer) has its pending latch set via
vgic_mmio_write_spending() while the interrupt is already active or in a li=
st
register?

In arch/arm64/kvm/vgic/vgic-mmio.c:__set_pending(), writing the set-pending
register sets irq->pending_latch =3D true (and irq->latch_written =3D true =
if
irq->on_lr) and calls vgic_irq_set_phys_active(irq, true):

arch/arm64/kvm/vgic/vgic-mmio.c:__set_pending() {
    ...
		if (irq->on_lr)
			irq->latch_written =3D true;

		irq->pending_latch =3D true;
		if (irq->hw && !is_user)
			vgic_irq_set_phys_active(irq, true);
    ...
}

Because the physical interrupt is already active in the host distributor or
redistributor for the in-flight virtual interrupt, there is only a single
physical active state bit. When the guest then deactivates the virtual
interrupt, hardware deactivation (or vgic_v3_deactivate_phys() when
deactivated outside the list registers) clears the physical active state in
the host.

When vgic_v3_fold_lr() runs on exit, was_active or irq->latch_written is tr=
ue,
so irq->pending_latch remains true while irq->active becomes false. Neither
vgic_v3_fold_lr() nor vgic_irq_handle_resampling() re-activates the physical
interrupt, and if irq->line_level was true and the physical line is now low,
vgic_irq_handle_resampling() explicitly clears the physical active state:

arch/arm64/kvm/vgic/vgic.c:vgic_irq_handle_resampling() {
	if (vgic_irq_is_mapped_level(irq)) {
		bool resample =3D false;

		if (unlikely(vgic_irq_needs_resampling(irq))) {
			resample =3D !(irq->active || irq->pending_latch);
		} else if (lr_pending || (lr_deactivated && irq->line_level)) {
			irq->line_level =3D vgic_get_phys_line_level(irq);
			resample =3D !irq->line_level;
		}

		if (resample)
			vgic_irq_set_phys_active(irq, false);
	}
}

On the next guest entry, irq->active is false and irq_is_pending(irq) is tr=
ue
via the preserved irq->pending_latch, so vgic_v3_compute_lr() populates the
list register with ICH_LR_HW | ICH_LR_PENDING_BIT while the physical interr=
upt
is inactive in the host:

arch/arm64/kvm/vgic/vgic-v3.c:vgic_v3_compute_lr() {
    ...
	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
		val |=3D ICH_LR_HW;
		val |=3D ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
		if (irq->active)
			allow_pending =3D false;
	}
    ...
	if (allow_pending && irq_is_pending(irq)) {
		val |=3D ICH_LR_PENDING_BIT;
    ...
}

Doesn't placing a list register entry with ICH_LR_HW set in the pending sta=
te
while the corresponding physical interrupt is not active in the distributor
or redistributor violate the hardware-bit consistency requirement (resulting
in unpredictable cpu interface behavior and a duplicate physical deactivati=
on
of an inactive physical interrupt)?

[ ... ]

>
>=20
>  		if (is_v2_sgi) {
>  			u8 cpuid =3D FIELD_GET(GICH_LR_PHYSID_CPUID, val);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022064628.4206=
-1-kmehltretter@gmail.com?part=3D2
