Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793165178;
	b=o8xy76qv7+CwdpedPBRuo8O7XbD6mt1lyp+h/EVH7ZmaB3uvx+0YdaMzHe/z/UAShUFK
	 XpUvuetB3wMFPwhdI48LYM4Q9Sd58D9YYBlTEpBZDaZYTL39c+itwwcj0N28xmP9hi3iP
	 bpdD7SaJ/qEswB13qCXMEXb58fwfPh3d/ZYH/gmCOhgT349QtFULsJPOJSayGgOLIQ+s+
	 CECBHE8Zjry5+zEEmWDdJIz+2EFFPp0zHhiGUDnZJhDopO673cluecDn9F4bOYKJykicP
	 8izScgrJzdJtWc4DFggqEne+hQYIpXhotmGZVuKGj+1BWQ9BoYPd67GzJykWyhbTydw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793165178;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6fnantBdmo10i70EUzwrteTdC5lexHDyXGvAMXlYC4o=;
	b=IRMiX+QswkiDWm500XoPXwFMCWYUosIbjhHynT4W/kEnPOSWUFwhAmr9/JS1bawNR1v+
	 z/Ohvx+h1hWozKM/zMgxhLRC8hT1c6J5WaZlyVX0SRkvaM5OtWsdx9ebysItT/RwazizO
	 GskO+JIZ0v21Nb1Y7TCb3w7VSN5AwqpboqOdkyTQLQfGxIL8LLKkr/t/3iAyIKF+JY27b
	 kTneHYu3Pd6RbpnSDRD/icEBeRFN+o+shr3hHq0owKwfMp2oUHpPfZW+gqip5lDIbfK2v
	 wY7g/jJGWuS1bWpITPwG7sLU5/lmElDlEZTScIaC/K/yK3lc/rtMf+PnlboA4IuMH/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bg1ux7gG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDC8606A31A;
	Wed, 28 Oct 2026 05:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bg1ux7gG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACA71F01825;
	Wed, 28 Oct 2026 05:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793165177;
	bh=6fnantBdmo10i70EUzwrteTdC5lexHDyXGvAMXlYC4o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bg1ux7gGu5cPe0k4fIG1TEcLU6q8We8GIE/fyExuVMdusSf8/a2AFDUSUJEJWPE6i
	 9T0dBqe8dCWgx0Gg2Bzan8TC8dk87UzGoVhgu8mfE2ix3/PK4bLgiw0ss9DI6gOnk7
	 q7gmOBtfkvbj7MsRNdEjsgKIcH2gCHXwsnfvs2y5iP2gz79Pu832Ft3KhfK1jWtLdL
	 80ayDlqBE0fY9DYBnJvpik+Qt5q5EDM67cP/99gLx+ByNj00uHkg/cpztLPoazaV6U
	 fjFwrQ9fjpRz9OPwEPFzeq07+7muiMwIl6lAFx6IdWXevQ4EM157QZb+6RNirLAoA0
	 bgH5DuDYhMxIw==
Message-ID: <sashiko-outbox-187533@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] KVM: arm64: vgic-v3: Don't drop pending writes
 to active level IRQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261028050113.10046-3-kmehltretter@gmail.com>
References: <20261028050113.10046-1-kmehltretter@gmail.com>
 <20261028050113.10046-3-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 05:26:16 +0000
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
- [High] KVM: arm64: vgic-v3: vgic_v3_fold_lr() leaves HW IRQ inactive on r=
epend
--

commit a4fe64a3fc3df5e9a6845ababa512f31987bf69e
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: vgic-v3: Don't drop pending writes to active level IRQs

This commit preserves irq->pending_latch in vgic_v3_fold_lr() when a
level-triggered interrupt was already active, so that a pending state set v=
ia
GICD_ISPENDR or GICR_ISPENDR0 while the interrupt is active is not cleared
upon deactivation.

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 726e20a1da6e7..4d802fc9c6dd5 100644
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
> @@ -103,8 +104,11 @@ static void vgic_v3_fold_lr(struct kvm_vcpu *vcpu, u=
64 val)
> =20
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> +		 * A latch written while the irq was active is a new pending
> +		 * state and was not represented in the LR, so preserve it.
>  		 */
> -		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(val & ICH_LR_STATE))
> +		if (irq->config =3D=3D VGIC_CONFIG_LEVEL &&
> +		    !(val & ICH_LR_PENDING_BIT) && !was_active)
>  			irq->pending_latch =3D false;

[Severity: High]
What happens here for a mapped level-triggered interrupt where irq->hw is
true and !vgic_irq_needs_resampling(irq), such as the architected timer PPI?

When that interrupt is already active in the guest (irq->active is true and
the physical interrupt is active in the host GIC), a guest write to
GICR_ISPENDR0 or GICD_ISPENDR calls:

vgic_mmio_write_spending() -> __set_pending() {
	irq->pending_latch =3D true;
	if (irq->hw && !is_user)
		vgic_irq_set_phys_active(irq, true);
}

Because the physical interrupt is already active in the host GIC for the
in-flight activation, vgic_irq_set_phys_active(irq, true) does not add a
second physical active state.

When the guest then deactivates the interrupt via ICC_EOIR1_EL1 or
ICC_DIR_EL1 (or via vgic_v3_deactivate_phys()), hardware deactivation clears
the physical active state in the host GIC. On the next VM exit,
vgic_v3_fold_lr() sees was_active is true and !(val & ICH_LR_ACTIVE_BIT),
sets irq->active =3D false, and preserves irq->pending_latch =3D true.

Then vgic_irq_handle_resampling() runs:

arch/arm64/kvm/vgic/vgic.c:vgic_irq_handle_resampling() {
	if (unlikely(vgic_irq_needs_resampling(irq))) {
		resample =3D !(irq->active || irq->pending_latch);
	} else if (lr_pending || (lr_deactivated && irq->line_level)) {
		irq->line_level =3D vgic_get_phys_line_level(irq);
		resample =3D !irq->line_level;
	}

	if (resample)
		vgic_irq_set_phys_active(irq, false);
}

This does not re-establish the physical active state in the host GIC when
irq->pending_latch remains true (and if irq->line_level was true while the
timer line is now low, it explicitly clears the physical active state).

On the subsequent guest entry, vgic_v3_populate_lr() -> vgic_v3_compute_lr()
sees irq->active is false and irq_is_pending(irq) is true via
irq->pending_latch:

arch/arm64/kvm/vgic/vgic-v3.c:vgic_v3_compute_lr() {
	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
		val |=3D ICH_LR_HW;
		val |=3D ((u64)irq->hwintid) << ICH_LR_PHYS_ID_SHIFT;
		if (irq->active)
			allow_pending =3D false;
	}
}

Wouldn't this populate the list register with ICH_LR_HW | ICH_LR_PENDING_BIT
while the corresponding physical interrupt is inactive in the host GIC,
violating the GICv3 list register hardware-bit consistency requirement and
causing the subsequent guest deactivation to deactivate an inactive physical
interrupt?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028050113.1004=
6-1-kmehltretter@gmail.com?part=3D2
