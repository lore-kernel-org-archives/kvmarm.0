Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FAB3B5850;
	Fri, 24 Jul 2026 11:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893718; cv=none; b=dExLzo8SYsulR1niQhV9NhZulnv45CXm6Z3NFXWqJm4ASzScQeRDeZyTUswV5vpH5fCjYmflll60V4DLVgk3YcMPDxHxjrDtaHxNIYXEPuB6hFZBJgOf/nUneva7X4tsBwHWH7OV4UrpULyk9A0QPFDmuJOgZuYELwb/KQwxrrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893718; c=relaxed/simple;
	bh=3Pf91BWCExraZepA+O71r1JEC/gZkvQ4xXsy2lb0wIg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dteaMyQn5HpJvxLR1AC58qdcjKQfwHm3H9rHgaQy2M5mB5lZLc2DsJxcOiPtNxwWzQjafU4V/9K5ydCV3wiTAmq3ltpwpT/K73OKfov8P2fXibgPfSTgBLSTgZwdqYAKYSMngOIAo3u6LqE2h8jKtyiv7KlN226RkCXt16INHIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgR0gXc/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgR0gXc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E488C1F000E9;
	Fri, 24 Jul 2026 11:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893717;
	bh=nMUT8LIGgxsXBJtfKLSZw6BhaAXI1fyjwc0uckPxS3w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HgR0gXc/gNf4bak9eK/rAGpMxAQhZSV8ilPZYipK+7QthOSAfF3qSbHji4mW4mJzx
	 QL5L0ajZ4YgvVxdvgZPJ4upMs2ZJuEZgwlTxOlBr4A/X2uH+kGkP9zuyFz8Axmgr8O
	 U0Vt2ZcHy7vOeh0ny+MB6cKEL5J86MeZfr50R/8REEIh7mhxTD3Y7faMa+AmN08DXi
	 2Qkl6rHLou0wcDxsN6IVoRuDD4P9hMomboT6uXNGZK2SQJbGTOoOtasDmf0RM1m9vo
	 ZLLGQEH7EoFYqNZwRHuEeArNYM37DbxxfpQYgKJudFu0J6fdMNBGn9wRuS9oXCj15m
	 b3J+JV2WqlokA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 27/48] KVM: arm64: gic-v5: Support SPI injection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260724104819.1296803-28-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-28-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:48:36 +0000
Message-Id: <20260724114836.E488C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [Critical] `vgic_v5_set_irq_pend` dereferences `vcpu->kvm` without checki=
ng for NULL, causing a host kernel panic during SPI or LPI injection.
- [High] GICv5 SPIs silently break `KVM_IRQFD_FLAG_RESAMPLE` because KVM by=
passes AP list queueing and never observes guest EOIs.
- [High] GICv5 SPI injection is broken for generic KVM callers because `vgi=
c_get_irq` expects a GICv5-encoded INTID, but external callers pass raw INT=
IDs.

Pre-existing issues:
- [High] Pre-existing Spectre v1 vulnerability in `vgic_get_irq()` when han=
dling GICv2/GICv3 SPIs. Speculative execution with `intid < VGIC_NR_PRIVATE=
_IRQS` bypasses bounds checks and leads to negative indexing on the `spis` =
array.
- [High] Invalid GICv5 PPI IDs silently alias to PPI 0 (SGI 0) in `vgic_get=
_vcpu_irq()` due to a missing architectural bounds check.
--

--- Patch [27]: [PATCH v4 27/48] KVM: arm64: gic-v5: Support SPI injection =
---
commit 416f67edd52d537473f18e3ac4c5b905a4c03f05
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Support SPI injection

GICv5 SPI lifecycle is handled by the GICv5 hardware once the pending
state has been injected. This change adds support for injecting SPIs to
the core VGIC code and GICv5 code.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 7957b9da95e7c..04392b686c2e2 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
> @@ -1064,6 +1064,47 @@ void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu)

[ ... ]

> +static bool vgic_v5_spi_queue_irq_unlock(struct kvm *kvm,
> +					 struct vgic_irq *irq,
> +					 unsigned long flags)
> +	__releases(&irq->irq_lock)
> +{
> +	lockdep_assert_held(&irq->irq_lock);
> +
> +	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
> +	return true;
> +}

[Severity: High]
Does skipping the AP list queueing here break KVM_IRQFD_FLAG_RESAMPLE?

Since this function overrides the default queueing logic and prevents the S=
PI
from being added to the vCPU's AP list, the lifecycle becomes fully hardware
managed.

Because KVM won't fold the SPI state back, it seems we'll never observe gue=
st
EOIs, meaning kvm_notify_acked_irq() won't be called to trigger the resample
eventfd.

Could this lead to silently hanging devices if userspace (like QEMU virtio-=
mmio
or VFIO) attaches an eventfd using the resample flag?

[ ... ]

> +/* Set the pending state for GICv5 SPIs and LPIs */
> +void vgic_v5_set_irq_pend(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
> +{
> +	if (WARN_ON(__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, irq->intid)))
> +		return;
> +
> +	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, irq_is_pending(irq),
> +		     vcpu->kvm->arch.vgic.gicv5_vm.vm_id);
> +}

[Severity: Critical]
Is it possible for vcpu to be NULL here?

If userspace configures the IRS and injects an SPI or unmapped LPI (e.g., v=
ia
KVM_IRQ_LINE) before any vCPUs are created, irq->target_vcpu could be NULL.

This would unconditionally dereference vcpu->kvm, potentially causing a host
kernel panic.

Should we add a NULL check for vcpu before dereferencing it?

> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 023792c28fc5c..d571fafb07f32 100644
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

[Severity: High]
Does this break SPI injection for generic KVM callers on GICv5?

The __irq_is_spi() helper expects a GICv5-encoded INTID when type is
KVM_DEV_TYPE_ARM_VGIC_V5.

However, standard in-kernel device emulations (like the PMU) and userspace
injections via KVM_IRQ_LINE or irqfd pass raw integer INTIDs (e.g., 32).

Without the GICv5 type bits, __irq_is_spi() will return false, causing the
injection to abort with -EINVAL.

> +		switch (type) {
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:
> +			intid =3D vgic_v5_get_hwirq_id(intid);
> +
> +			if (intid >=3D kvm->arch.vgic.nr_spis)
> +				return NULL;
> +
> +			intid =3D array_index_nospec(intid, kvm->arch.vgic.nr_spis);
> +			return &kvm->arch.vgic.spis[intid];
> +		default: {
> +			u32 max_intid =3D kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
> +
> +			if (intid < max_intid) {
> +				intid =3D array_index_nospec(intid, max_intid);
> +				return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
> +			}

[Severity: High]
This is a pre-existing issue, but does this speculative bounds checking log=
ic
have a Spectre v1 vulnerability?

The array_index_nospec() clamp is applied to intid before subtracting
VGIC_NR_PRIVATE_IRQS (32).

If intid is speculatively less than 32, the check (intid < max_intid) will
speculatively evaluate to true, and array_index_nospec will preserve the
value.

Subtracting 32 then results in a negative index, allowing speculative
out-of-bounds reads on the spis array.

> +		}}
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but looking at vgic_get_vcpu_irq=
()
just below this function, it appears there is a missing bounds check for GI=
Cv5
PPI IDs:

struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
{
    ...
    if (__irq_is_sgi(type, intid) || __irq_is_ppi(type, intid)) {
        switch (type) {
        case KVM_DEV_TYPE_ARM_VGIC_V5:
            intid =3D vgic_v5_get_hwirq_id(intid);
            intid =3D array_index_nospec(intid, VGIC_V5_NR_PRIVATE_IRQS);
            break;

Unlike the SPI path, this extracts the hardware ID and directly applies
array_index_nospec() without an explicit bounds check (e.g. checking if
intid >=3D VGIC_V5_NR_PRIVATE_IRQS).

Since __irq_is_ppi() only checks the GICv5 type bits and not the ID range, =
an
invalid out-of-bounds PPI ID will silently alias to index 0.

Can this lead to silent corruption of SGI 0 state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D27
