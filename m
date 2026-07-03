Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E2B2E2DF2;
	Fri,  3 Jul 2026 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783097605; cv=none; b=mnk0HR+mNzUqMFnYQ+Sro+A8eJmoCs5pqvwMi8uZtXgALeycmI6sFjcI6mRnjqr2mJtpOukQboxRiIHFBfMRnAnnUrzpoYdX46eWKB5FnR6MQez9+S/czu3M8Y5X/AgycB0n/h2zM1CPrfZNWa8RXtgxtLVJbI9JtAssVXGJiwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783097605; c=relaxed/simple;
	bh=SAebFbuPM4m9TZksU3psWkDuunXA+Q4PphyqBqA7nkA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ft/qWBj5Ok4i/4Tj6+qovnEn7ey64hlxYDq88PUZ5eG0k9rxbReh092n8YzHbxukhHPC5vLQ8XUMWMnLEWHWqkrmRS/g1aIOTwUm70ZrVoassxE1iNb0pVEPkxm2j4kKXuSQ3qj+csufsrpSIHe6hlsffCCrd8jdNh8znn3tb+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hApK4PI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hApK4PI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6111F00A3D;
	Fri,  3 Jul 2026 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783097604;
	bh=AVwihI7f8qax8b/qiO2hyqfzjcY1th18qJEXnxJtKOk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hApK4PI45wYfNM/+AlKNHTmx3hEa4X/m96Zod68wttZ49QVXbw/X06v2Uszt4k58M
	 5gXLI+GOYzoMipAEWgVQ6LyncakTojEYbvM2QujENIlfaockX1LsO44wsO8ko/v8rC
	 rKumikP0WdrSb9Nf2+ghSDBrkYmduEm6HnjU3Pv9r3UAlFGrvCjHaGdjPPGxSSNkTK
	 eW2T24JsHxecn/WpHdycrw5iKpe4PD/Vu9qj246cWySjz6xtWAlDThlyuoEWSZw6xN
	 PPouGRrVco4kjOw9BL1sfXP5nXKkpSQh6GNMtT1ndvQ/GSkI1YEka64BU1SgO+eL7t
	 Yo3qrKOO+ecsg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 29/40] KVM: arm64: gic-v5: Support SPI injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260703154811.3355680-30-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-30-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:53:23 +0000
Message-Id: <20260703165323.AC6111F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] O(N^2) hypercalls inside a global raw spinlock on the guest exit p=
ath.
- [High] VFIO level-triggered SPIs are permanently lost because EOI notific=
ations are gated behind `!irq_is_pending()`.
- [Medium] Guest-triggerable host dmesg spam via `nr_spis` clamping mismatc=
h in IRS capability registers.

Pre-existing issues:
- [High] Spectre v1 gadget in `vgic_get_irq()` for GICv2/v3 SPIs due to sub=
traction after `array_index_nospec()`.
--

commit 4f4d623ce71f96a23431e620fddd39282b0000ad
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic-v5: Support SPI injection

This commit adds support for injecting and managing GICv5 SPIs in the VGIC
core. It introduces SPI lookup, irq_ops for state management, and a global
AP list for tracking SPIs during VCPU exits.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 20ae7daf4c451..ceab71c2412bd 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1113,6 +1113,99 @@ void vgic_v5_fold_irq_state(struct kvm_vcpu *vcpu)

[Severity: High]
Will this loop iteration cause soft lockups and VCPU starvation?

Looking at vgic_v5_fold_irq_state(), the host iterates over the global
vgic_v5_spi_ap_list_head while holding a raw spinlock and making hypercalls:

arch/arm64/kvm/vgic/vgic-v5.c:vgic_v5_fold_irq_state() {
retry:
    raw_spin_lock(&vgic_dist->vgic_v5_spi_ap_list_lock);
    list_for_each_entry(irq, &vgic_dist->vgic_v5_spi_ap_list_head, ap_list)=
 {
        ...
        icsr =3D kvm_call_hyp_ret(__vgic_v5_vdrcfg, irq->intid);
        ...
        if (!irq->active && !pending && !irq_is_pending(irq)) {
            ...
            list_del(&irq->ap_list);
            ...
            raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
            ...
            goto retry;
        }
    }
}

If multiple SPIs are deactivated simultaneously, dropping the locks and
restarting the iteration from the beginning of the list requires repeatedly
evaluating already visited active SPIs, resulting in O(N^2) hypercalls
inside a raw spinlock.

[Severity: High]
Does this condition permanently lose VFIO level-triggered SPIs?

In the same loop in vgic_v5_fold_irq_state(), the End Of Interrupt (EOI)
notification is gated behind a check that irq_is_pending() is false:

arch/arm64/kvm/vgic/vgic-v5.c:vgic_v5_fold_irq_state() {
        ...
        if (!irq->active && !pending && !irq_is_pending(irq)) {
            ...
            kvm_notify_acked_irq(vcpu->kvm, 0, intid);
        ...
}

For level-triggered interrupts injected by VFIO via irqfd, KVM sets
irq->line_level =3D 1. The irq_is_pending() function checks this line_level
and returns true, which prevents the EOI notification from being sent.

Without the notification, the irqfd resampler never deasserts the interrupt
and clears line_level, leaving the interrupt permanently blocked.

>  	raw_spin_unlock(&vgic_dist->vgic_v5_spi_ap_list_lock);
>  }
> =20
> +static bool vgic_v5_set_spi_pending_state(struct kvm_vcpu *vcpu,

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index ee7fc0c7104e6..26f9ff7700429 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
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
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:
> +			intid =3D vgic_v5_get_hwirq_id(intid);
> +
> +			if (intid >=3D kvm->arch.vgic.nr_spis)
> +				return NULL;

[Severity: Medium]
Is it possible for a guest to spam the host kernel log by exploiting a
mismatch in the nr_spis values?

In kvm_vgic_v5_irs_init(), the local nr_spis variable is clamped up to
VGIC_V5_DEFAULT_NR_SPIS (32), but the global kvm->arch.vgic.nr_spis is left
unchanged (e.g., at 16).

This clamped value is exposed to the guest in the IRS IDR registers. If the
guest writes an ID between 16 and 31 to IRS_SPI_SELR, it is accepted because
vgic_v5_is_spi_selr_valid() checks against the clamped value.

When vgic_v5_mmio_read_irs_spi() attempts to read it, this check fails and
returns NULL, which then triggers an unratelimited kvm_err():

arch/arm64/kvm/vgic/vgic-irs-v5.c:vgic_v5_mmio_read_irs_spi() {
    ...
    if (!irq) {
        kvm_err("Guest trying to access SPI not backed by KVM\n");
    ...
}

> +
> +			intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
> +			return &kvm->arch.vgic.spis[intid];
> +		default: {
> +			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +
> +			if (intid < max_intid) {
> +				intid =3D array_index_nospec(intid, max_intid);
> +				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];

[Severity: High]
This is a pre-existing issue, but could this allow an out-of-bounds access
under speculative execution?

If an attacker can control intid and speculatively bypass the
__irq_is_spi() bounds check, array_index_nospec() bounds it against the upp=
er
limit. However, a value like 0 subtracts VGIC_NR_PRIVATE_IRQS (32) and
creates a large unsigned underflow, which may allow accessing out of bounds
memory.

> +			}
> +		}}
>  	}
> =20
>  	/* LPIs */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D29
