Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793165228;
	b=KR9uD7I30Ac7S21qqV8u/m6rwYruJP5u//N23xDvYeCyi/DsWMBG79IGXnVJEi8vyKTc
	 4mMmwV9ZIlZSngh02eW5w0Oioi3dhS0qfTM2StsP2E0hd7r/em6VTn2m6CPF0Di4+Pgdl
	 8N5cdf0lOGQpw9Pf9q7irUHapnZmxmagCJbXds0TDMJBCMRK12JmkDX8tp6zH3JNu7Vew
	 lbYAKbrxPcJl5N2E2BY4INPFhddWvsZPlAU0142e5fim2nmWmNkNvKpAn22RnBw2scrQK
	 dqUAKtk31f/YWcELBZ2aegQ/fO2+tCzGv34mp7Ho8sPjMGVsB7Se4EpdyLLUko+S3rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793165228;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1dMUa94rbYTM3Jxj9ixu1FIJ2Q6mGIKPkOTS0Qj2wqA=;
	b=X3Qm2ExvVYixHXf6wy+heMgDn/YFD5s4snX8h2jHmYIaJGpwQN67Rnx3Ho0T6H2pGIAM
	 fec03+pgjC14vGBnhGnNfn4NBhm7zNheSKHlM2RekzJnxilj3NyF3C4JrTjccs21wPluh
	 0SgdVlVIYZvkU0H55iyfChnaso58udSaKAk8XrGx6AFwYtKSwlrSTD2afb7bzQemGA9z1
	 Xm8zo+Hsq32lbs9Fxa4bvzURcMlsOz8s/KOPbANnBD5GcT1HmQ7zL9yASnqTKmpCo4yIH
	 3QcHRDCHinGX7N5DPPK/M4YszQDrxOe2yP7s/9ntSLUY0SpnS1rMtrBkC2h6Lq24EGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKcaMomC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF50606A31A;
	Wed, 28 Oct 2026 05:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CKcaMomC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3151F01825;
	Wed, 28 Oct 2026 05:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793165228;
	bh=1dMUa94rbYTM3Jxj9ixu1FIJ2Q6mGIKPkOTS0Qj2wqA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CKcaMomCjR3C32YjlrkydEQtgtY9sYG4769FxCrMHJDI0L6gFSmRgsLzjm6OGLIMM
	 O5w5E7VHcLtpQau/dq2bmSTNaInft4YpwcHK3m0dDnfUPet4/0uFXVtdDkBd1qrd3f
	 d4UKzFkjeP0vItbyioACVtUfJ7WvuTapYUB2uQqzDdP/ikc0oaVjwoByWXlIiSV0W6
	 ZyrSZroAXGH0wVZ+kWwDPjN4z0xJo3AFT/P8O0WWuXHolFukRoc/zjCjxYcCbXNPBv
	 CN35mIQMMLSXlBePJPIoPDKVeDr1cUgLNq/sQPfqUZu/muMKAy9kxmdf8q1Hr5GT0k
	 vANh76QsmeO3g==
Message-ID: <sashiko-outbox-187535@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] KVM: arm64: vgic-v2: Don't drop pending writes
 to active level IRQs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karl Mehltretter" <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261028050113.10046-2-kmehltretter@gmail.com>
References: <20261028050113.10046-1-kmehltretter@gmail.com>
 <20261028050113.10046-2-kmehltretter@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 05:27:07 +0000
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
- [High] KVM: arm64: vgic-v2: GICH_LR_HW pending LR programmed with inactiv=
e phys IRQ
- [Medium] KVM: arm64: vgic-v2: spurious level IRQ after save/restore in vg=
ic_v2_fold_lr()
--

commit 48710a44e389b45084a926f40b58ded3edf3a4dd
Author: Karl Mehltretter <kmehltretter@gmail.com>

KVM: arm64: vgic-v2: Don't drop pending writes to active level IRQs

This commit synchronizes the target vCPU's LRs in vgic_mmio_write_spending()
and preserves irq->pending_latch in vgic_v2_fold_lr() when a level-triggered
interrupt was already active, so that a pending state written via GICD_ISPE=
NDR
while the interrupt is active is not dropped on deactivation.

> diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
> index 7182f63fc9382..f3ba3177dd97b 100644
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
> @@ -88,8 +89,11 @@ static void vgic_v2_fold_lr(struct kvm_vcpu *vcpu, u32=
 val)
> =20
>  		/*
>  		 * Clear soft pending state when level irqs have been acked.
> +		 * A latch written while the irq was active is a new pending
> +		 * state and was not represented in the LR, so preserve it.
>  		 */
> -		if (irq->config =3D=3D VGIC_CONFIG_LEVEL && !(val & GICH_LR_STATE))
> +		if (irq->config =3D=3D VGIC_CONFIG_LEVEL &&
> +		    !(val & GICH_LR_PENDING_BIT) && !was_active)
>  			irq->pending_latch =3D false;

[Severity: High]
Can preserving irq->pending_latch here in vgic_v2_fold_lr() in
arch/arm64/kvm/vgic/vgic-v2.c cause a GICH_LR_HW list register to be
populated as pending while the physical interrupt is inactive in the host
distributor?

If the guest writes to GICD_ISPENDR0 for a mapped level-triggered interrupt
such as the architected timer PPI (irq->hw is true, irq->config is
VGIC_CONFIG_LEVEL, and !vgic_irq_needs_resampling(irq)) while that interrupt
is already active, vgic_mmio_write_spending() -> __set_pending() in
arch/arm64/kvm/vgic/vgic-mmio.c sets irq->pending_latch and marks the
physical interrupt active while the first instance is already active in
hardware:

arch/arm64/kvm/vgic/vgic-mmio.c:__set_pending() {
    ...
		irq->pending_latch =3D true;
		if (irq->hw && !is_user)
			vgic_irq_set_phys_active(irq, true);
    ...
}

When the guest deactivates that first in-flight instance, the hardware
deactivation clears the physical interrupt's active state in the host GIC
distributor. On the subsequent exit, vgic_v2_fold_lr() sees was_active =3D=
=3D true
and deactivated =3D=3D true, sets irq->active =3D false, and preserves
irq->pending_latch =3D true without re-activating the physical interrupt.

On the next guest entry, vgic_v2_populate_lr() -> vgic_v2_compute_lr() in
arch/arm64/kvm/vgic/vgic-v2.c sees irq->active =3D=3D false and
irq_is_pending(irq) =3D=3D true via irq->pending_latch:

arch/arm64/kvm/vgic/vgic-v2.c:vgic_v2_compute_lr() {
    ...
	if (irq->hw && !vgic_irq_needs_resampling(irq)) {
		val |=3D GICH_LR_HW;
		val |=3D irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
		/*
		 * Never set pending+active on a HW interrupt, as the
		 * pending state is kept at the physical distributor
		 * level.
		 */
		if (irq->active)
			allow_pending =3D false;
	}
    ...
}

Wouldn't this program the list register with GICH_LR_HW | GICH_LR_PENDING_B=
IT
while the corresponding physical interrupt in the host distributor is
inactive?

[Severity: Medium]
Also, what happens across a GICv2 VM save and restore when a level-triggered
device interrupt is active and its input line is still asserted
(irq->active =3D=3D true, irq->line_level =3D=3D true, and irq->pending_lat=
ch =3D=3D
false)?

When userspace saves KVM_DEV_TYPE_ARM_VGIC_V2 distributor state via
vgic_uaccess_read_pending() -> __read_pending() in
arch/arm64/kvm/vgic/vgic-mmio.c, GICv2 reads irq_is_pending(irq):

arch/arm64/kvm/vgic/vgic-mmio.c:__read_pending() {
    ...
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
    ...
}

Because irq->line_level is true, the saved pending state is 1. On restore,
userspace restores the active state via vgic_mmio_uaccess_write_sactive()
(setting irq->active =3D true) and restores the pending state via
vgic_uaccess_write_spending() -> __set_pending() (setting irq->pending_latc=
h =3D
true).

When the guest resumes, clears the interrupt condition at the device (setti=
ng
irq->line_level =3D false), and writes GICC_EOIR to deactivate the interrup=
t,
vgic_v2_fold_lr() runs with was_active =3D=3D true and !(val & GICH_LR_STAT=
E).
With the new !was_active check in vgic_v2_fold_lr(), won't irq->pending_lat=
ch
remain true on deactivation and cause a spurious second delivery of the lev=
el
interrupt?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028050113.1004=
6-1-kmehltretter@gmail.com?part=3D1
