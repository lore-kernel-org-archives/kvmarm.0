Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1BB4908C0;
	Fri,  4 Sep 2026 12:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526789; cv=none; b=BDMDNK0tx1xucpMS+KU2OWp2lCNGWNhJfn7FIAXC8sYu2q5bqp1QAmAZjgNGaqB8horWcAB0aauCaXkxU94D30MPrrMnh0implGMZjiiQb7ROqqRfIi4WOok8DhcqsbkDDkWVgsgBaEKvEBe/3mgMEpBhl0dJX+M5YsR01GebGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526789; c=relaxed/simple;
	bh=3VKXSot73052se9xaSvk717mS8+M7hRh5ECMRclQzIg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aZ39nv5T6p53Llv61UeujDVV9V7C93iCGSsdIu9kQ3S30eelUd8F/my6Nq3Ri5VkPQSMiTHHduxIGy3WDA4P0Sf07LzSSrUDPTBo80mPwJyCS9PuLRiofsPaGj26UzpGiKocN3wkeV77y2ClTsZ1xy56BLxyXw/R1pvKhyKqdhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gjNkXkZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gjNkXkZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6B31F00A3D;
	Fri,  4 Sep 2026 12:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788526787;
	bh=nla1aYeco31bhUzwa+Q67xU8QuD02qI+S77nQZYHrkM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gjNkXkZ1abc4zzcmfwIeHCQ6sPPhRPyp8F9AYghVe6MPH/Iwzjs0XbUuiPWB0rCsG
	 FML/O7hIM+CJmucuUe1ZrBSLcOerDIM8vd/PHVKq/wFwLKS70rYaVGfvBxnn89LEdX
	 hKTxtu0p8bU+AcG6cIsJSLCqvFoB+76sRCYERAKWz4drgTXuhz6Dv1owK27rsitIRE
	 dmJmrT0GGqt9mG7afZPei6akbSFOvVqOk395FINcFFgfOpe/N36E2g8+J2AyhxvIUI
	 l0Kn72EfFM1kadg8RiBQQHgUDlkupk4LMx2SqCQ5TpcayBRLhELkm0+Q2SrOZZNDEJ
	 bYNU7giNbYnIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260904113404.4051341-21-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-21-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 12:59:47 +0000
Message-Id: <20260904125947.8C6B31F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing `vgic_irq_is_mapped_level()` check when changing SPI trigg=
er mode allows a guest to reconfigure a hardware-mapped level interrupt to =
edge-triggered.
- [Medium] Unconditional allocation of `dist->spis` in `kvm_vgic_v5_irs_ini=
t` leaks memory if VGIC initialization fails and is retried.
--

commit 7fdccc0d6d5320405b4f8a3add8b9e063ba810fc
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation

This commit introduces an IODEV for the GICv5 IRS and its associated MMIO
emulation to handle guest accesses. It adds support for querying and
manipulating IRS registers, tracking selector states, and allocating or fre=
eing
host ISTs based on guest IST lifecycle.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> new file mode 100644
> index 0000000000000..76f5f40ecc1ce
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
[ ... ]
> +static void vgic_v5_mmio_write_irs_spi(struct kvm_vcpu *vcpu, gpa_t addr,
> +				       unsigned int len, unsigned long val)
> +{
> +	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
> +	const size_t offset =3D addr & (SZ_64K - 1);
> +	struct vgic_irq *irq;
> +
> +	switch (offset) {
> +	case GICV5_IRS_SPI_SELR:
> +		WRITE_ONCE(irs->spi_selr.id,
> +			   FIELD_GET(GICV5_IRS_SPI_SELR_ID, val));
> +		return;
> +	case GICV5_IRS_SPI_CFGR: {
> +		u32 id =3D READ_ONCE(irs->spi_selr.id);
> +
> +		if (!vgic_v5_is_spi_selr_valid(irs, id))
> +			return;
> +
> +		/*
> +		 * Find KVM's representation of the interrupt - we need to make
> +		 * sure that KVM's view agrees with the guest's, else interrupt
> +		 * injection won't work properly for level-triggered interrupts
> +		 * (we fail to handle the clearing of the pending state if KVM
> +		 * thinks that the interrupt is edge-triggered, which is the
> +		 * default.)
> +		 */
> +		irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(id));
> +		if (!irq)
> +			return;
> +
> +		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
> +			if (val & GICV5_IRS_SPI_CFGR_TM)
> +				irq->config =3D VGIC_CONFIG_LEVEL;
> +			else
> +				irq->config =3D VGIC_CONFIG_EDGE;
> +		}

[Severity: High]
Could this assignment allow a guest to reconfigure a hardware-mapped level
interrupt to edge-triggered?

By omitting a check against vgic_irq_is_mapped_level(irq) in
vgic_v5_mmio_write_irs_spi() within arch/arm64/kvm/vgic/vgic-irs-v5.c, this
update unconditionally modifies irq->config when the guest writes to the
GICV5_IRS_SPI_CFGR MMIO register.

For physical interrupts mapped into the guest (e.g., via VFIO), KVM requires
the virtual trigger mode to remain level-triggered to properly manage physi=
cal
interrupt deactivation upon guest EOI. In GICv2/v3, vgic_mmio_write_icfgr()
explicitly guards against this.

This could lead to desynchronization of virtual and physical interrupt state
machines, resulting in physical interrupt storms that can lock up the host.

> +
> +		vgic_put_irq(vcpu->kvm, irq);
> +
> +		return;
> +	}
[ ... ]
> +int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned int nr_spis)
> +{
> +	struct vgic_dist *dist =3D &kvm->arch.vgic;
> +	struct vgic_v5_irs *irs =3D dist->vgic_v5_irs_data;
> +	struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
> +	size_t nr_spi_bits;
> +	u64 mmfr0;
> +	int ret, i;
> +
> +	/*
> +	 * We (KVM) allocate an Interrupt State Table (IST) for SPIs. The
> +	 * hardware mandates that lower 6 bits of the address are 0. Each ISTE
> +	 * is 4 bytes in size (or larger if metadata storage is required), so 16
> +	 * entries would be enough for alignment. We require userspace to
> +	 * provide at least 32 SPIs, so we always meet alignment requirements.
> +	 */
> +	if (nr_spis) {
> +		dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
> +				     GFP_KERNEL_ACCOUNT);
> +		if (!dist->spis)
> +			return -ENOMEM;

[Severity: Medium]
Is it possible for this allocation to permanently leak memory if VGIC
initialization fails and is retried?

In kvm_vgic_v5_irs_init() within arch/arm64/kvm/vgic/vgic-irs-v5.c, the
dist->spis pointer is unconditionally overwritten here. If a failure occurs
later in the initialization sequence (for example, during
kvm_vgic_setup_default_irq_routing()), dist->initialized remains false, whi=
ch
allows host userspace to retry the KVM_DEV_ARM_VGIC_CTRL_INIT ioctl.

If userspace retries the ioctl, kvm_vgic_v5_irs_init() will be called again=
 and
overwrite the dist->spis pointer without freeing the previous allocation.

> +
> +		/*
> +		 * In the following code we do not take the irq struct lock since
> +		 * no other action on irq structs can happen while the VGIC is
> +		 * not initialized yet.
> +		 */
> +		for (i =3D 0; i < nr_spis; i++) {
> +			struct vgic_irq *irq =3D &dist->spis[i];
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D20
