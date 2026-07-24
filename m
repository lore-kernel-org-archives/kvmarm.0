Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E4E35A3A4;
	Fri, 24 Jul 2026 11:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893931; cv=none; b=LPLTF+miibmawCGFTrAb3h/KGzc7u4eBx7xU/om9xYSuAO8qnqjbNnSeou7O8C83lLWYtYeHj9jPfW33rBdS71vjxQcYpCZgNwo0Upg7gF/W1IrUGXVTyzOnSVbj83+glfPJJxwsN4BxbmIyYdwnO6+wYmVkubizGr9nVd7BMYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893931; c=relaxed/simple;
	bh=H3KgN6U6g+7LL7Wvv7j2oIvyuHB06Ln2L3iwRGXREvE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MvJv35fEHrKXdDAKE2qrqcj6ZNIfosVyb2OakICgyUAsbBf7Sidw05rrTj0opRh1bU/e0DOB4wCm97/E1IRxF8T0RzXIe5tIpAX7A1iEVyyDJNVTx3MnjY1KSbPFZrA1DPMBYcI1KHwvAM9Pt9gETatFhW5CUpQXpO9cCsTU0y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eDCYSPbZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDCYSPbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AFE1F000E9;
	Fri, 24 Jul 2026 11:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893930;
	bh=rQQG4umk+eRm/+94WpkDS0mhUy5z5julxZeCbc61ZgU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eDCYSPbZ2/cIKSp42gz1U0d3HrXDKx6a2HJ9JM8tmhmZl3DVsiUz7eR1FNduFTrNX
	 cBmA2r4iiRat+S7wwTwOHASGF8ZNtyoxGgl3y3xL0Jpsy+ZRWsLPqxfoBop8oKU6DA
	 aTrOWiWjVkR7UmPsx/MJ3S/5MQA4MINI2cY6cfpwScIgIyqGNV+W3aPopGY2x5i+DO
	 XP4R0wRd8HK7p72ikL4DUQwM9H55g/2zsr9BPfA+tG+DcIMVL2xz3SG1EnOEsrGF78
	 qeCpwc7wQx5d/KREpIlmFIo8XZsHO5NnVnYP5YqNsT3S4kaw5go46C25ecIAJPFiOk
	 nSvKZZslNHZ1w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 30/48] KVM: arm64: gic-v5: Mask per-vcpu PPI state in
 vgic_v5_finalize_ppi_state()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260724104819.1296803-31-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-31-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:52:09 +0000
Message-Id: <20260724115209.F0AFE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Restored active software-managed PPIs are not queued to the ap_lis=
t, leading to lost interrupts on VM restore.

Pre-existing issues:
- [High] Data race on the global `vgic_ppi_mask` when `SW_PPI` is not imple=
mented in hardware, leading to guest state corruption.
--

--- Patch [30]: [PATCH v4 30/48] KVM: arm64: gic-v5: Mask per-vcpu PPI stat=
e in vgic_v5_finalize_ppi_state() ---
commit 04a9407ed3605cc393d7dce45456f17c9e1fc2c3
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Mask per-vcpu PPI state in vgic_v5_finalize_ppi_state()

This commit reworks vgic_v5_finalize_ppi_state() to discover exposed PPIs a=
nd
mask non-exposed PPI state when VCPUs are first run. It clears state for
non-exposed PPIs to ensure only the intended state is exposed to the guest
after userspace restores the state.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 04392b686c2e2..6af1264ed2371 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -795,35 +796,65 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
>  	guard(mutex)(&kvm->arch.config_lock);
> =20
>  	/*
> -	 * If SW_PPI has been advertised, then we know we already
> -	 * initialised the whole thing, and we can return early. Yes,
> -	 * this is pretty hackish as far as state tracking goes...
> +	 * Discover the set of PPIs that are exposed to the guest once per VM.
> +	 * Once known, apply that mask to each VCPU's restored PPI state as the
> +	 * VCPUs are first run.
>  	 */
> -	if (test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_ma=
sk))
> -		return 0;
> -
> -	/* The PPI state for all VCPUs should be the same. Pick the first. */
> -	vcpu0 =3D kvm_get_vcpu(kvm, 0);
> +	if (!test_bit(GICV5_ARCH_PPI_SW_PPI, kvm->arch.vgic.gicv5_vm.vgic_ppi_m=
ask)) {
> +		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_mask,
> +			    VGIC_V5_NR_PRIVATE_IRQS);
> +		bitmap_zero(kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
> +			    VGIC_V5_NR_PRIVATE_IRQS);

[Severity: High]
This is a pre-existing issue, but does this conditional in
vgic_v5_finalize_ppi_state() create a data race on the global vgic_ppi_mask
if the SW_PPI feature is not implemented in hardware?

In a multi-VCPU VM booting on GICv5 hardware without the optional SW_PPI
feature, when a subsequent VCPU runs for the first time, this test will
evaluate to false because the bit was never set.

This seems to cause the global mask to be cleared via bitmap_zero() while
earlier VCPUs might already be running in the guest. Could this lead to a
transiently zeroed vgic_ppi_mask during sysreg accesses and silently dropped
interrupts for emulated devices like timers?

> +
> +		for_each_set_bit(i, ppi_caps.impl_ppi_mask, VGIC_V5_NR_PRIVATE_IRQS) {
[ ... ]
> +	/* Also update the vgic_irqs */
> +	for (i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
> +		bool visible =3D test_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
>  		const u32 intid =3D vgic_v5_make_ppi(i);
>  		struct vgic_irq *irq;
> =20
> -		irq =3D vgic_get_vcpu_irq(vcpu0, intid);
> +		irq =3D vgic_get_vcpu_irq(vcpu, intid);
> =20
> -		/* Expose PPIs with an owner or the SW_PPI, only */
>  		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
> -			if (irq->owner || i =3D=3D GICV5_ARCH_PPI_SW_PPI) {
> -				__set_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_mask);
> -				__assign_bit(i, kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr,
> -					     irq->config =3D=3D VGIC_CONFIG_LEVEL);
> +			if (!visible) {
> +				irq->enabled =3D false;
> +				irq->active =3D false;
> +				irq->pending_latch =3D false;
> +				irq->line_level =3D false;
> +			} else {
> +				irq->enabled =3D test_bit(i, cpu_if->vgic_ppi_enabler);
> +				irq->active =3D test_bit(i, cpu_if->vgic_ppi_activer);
>  			}
>  		}

[Severity: High]
Is it safe to directly set irq->active here without queueing the interrupt?

When restoring a VM with active software-managed PPIs (like the PMU or time=
rs),
we mutate irq->active inside the lock in vgic_v5_finalize_ppi_state(), but =
we
don't seem to invoke the corresponding queueing machinery.

Without enqueuing the IRQ onto the VCPU's ap_list, won't this cause the
interrupt to be invisible to the injection path and get lost on VM restore?

> =20
> -		vgic_put_irq(vcpu0->kvm, irq);
> +		vgic_put_irq(kvm, irq);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D30
