Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4033EDAAE;
	Fri, 24 Jul 2026 11:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893561; cv=none; b=MFgKXSvUMly2gG9MHGm/4g3/+dmETGDnA0rdf/k71naPyMJ9Wwyv4E+8S9/QASDx9lb1v0F4a4Qb9FjwCx1Kfp3WtV2AfIf7KJk8K6wyilLBIE/crohWNX7EendK+TDdJoTI0Wm9iKmnetpybVWHoEnpla5dzF9FwiRi8rq4cQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893561; c=relaxed/simple;
	bh=iVNzNZDkG4vQFhcCBX6DnxEUCZe1q8BK0lwWfSfNcGE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qq/rI3vnt53/duUcKs/3IL5MfqmiFpmJMg0siNi82c/jpm7nd5eJSp9RJW0RwqYrfCqNvoKkH47JNPuwXev3Y/5ps/Q6erzwoZqUUPfZlJ/pdfJjmtJ5fkoU6Eptpfa2biyG+JDOb3Y8NEINTyXoQ/pNlj466bbW2RUIwwkmu+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iS2dl50C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iS2dl50C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C961F000E9;
	Fri, 24 Jul 2026 11:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893559;
	bh=c3StroRQtNe+X/+kYFdvJWZ4hdY+JVMXb9IqClhuvF8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iS2dl50CZPj0pbQ17yCbpBKQ6bj45pZ9f++8CNjDJt4UmZKYPIkgMI1IMu4hgA9rA
	 D/0c/IrTvFMRQrPX2CkBc226xjFKyElmdkP253OuGg8OClVezph4vF/Yj4H/5GugI2
	 UC73Qg2Sg/bUmV/jGYMkExlCFZBFe58lsoWREpJVosYkDn6QnXc3QK+ojFRud0/NGb
	 efaK712kMGyVS5lyRenH6RbiRCDHYV4ximDadbohem1aKTRYnvTb2Z8Lo1dFfXLw/R
	 nty3zkpIuQRN+/kI8ZxJ0NE/rFplMiytSsfqhpEgm5daG61lFrL6gdVBAfyMGX2e7L
	 ZWo7mvuQ9tmdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 20/48] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and
 MMIO emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-21-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-21-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:45:58 +0000
Message-Id: <20260724114559.17C961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:
- [High] Unallocated `vgic_v5_irs_data` leads to a NULL pointer dereference=
 on initialization.
- [High] Bumping `nr_spis` locally in `kvm_vgic_v5_irs_init()` without upda=
ting `kvm->arch.vgic.nr_spis` leads to inaccessible SPIs.
- [High] Missing RCU read lock around `xa_load` in `vgic_v5_vmte_vpe_id_bit=
s()`.
- [High] Unconditional IPI storm triggered by guest writes to GICV5_IRS_CR0.
- [High] 64-bit IRS registers cannot be accessed via 32-bit UAPI or guest M=
MIO.
- [Medium] Unratelimited host kernel log spam via invalid IRS_IST_CFGR allo=
ws a malicious guest to flood the host log.
- [Medium] Data races and torn reads on shared VM-wide IRS MMIO registers (=
`ist_baser`, `ist_cfgr`, `cr1`, `pe_selr.iaffid`).
- [Medium] Underflow in `IAFFID_BITS` calculation exposes bogus IDR1 values=
 before first vCPU run.
- [Medium] IST valid state desynchronizes from hardware on free failure.
--

--- Patch [20]: [PATCH v4 20/48] KVM: arm64: gic-v5: Add GICv5 IRS IODEV an=
d MMIO emulation ---
commit 89cd01e35340acb046b6ed1ef9d6c28883308945
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation

This commit introduces an IODEV for the GICv5 IRS and an associated
initialization function to set up SPIs and initial state. The MMIO emulation
tracks selector state and configures LPI ISTs on behalf of the guest.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> new file mode 100644
> index 0000000000000..da8914dd682fc
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
> @@ -62,4 +62,5 @@ static unsigned long vgic_v5_mmio_read_irs_misc(struct =
kvm_vcpu *vcpu,
> +		/*
> +		 * IRS_IDR1 encodes IAFFID_BITS as N - 1.
> +		 */
> +		vpe_id_bits =3D vgic_v5_vmte_vpe_id_bits(vcpu);
> +		value |=3D FIELD_PREP(GICV5_IRS_IDR1_IAFFID_BITS, vpe_id_bits - 1);

[Severity: Medium]
If userspace reads GICV5_IRS_IDR1 before the VM runs,
vgic_v5_vmte_vpe_id_bits() returns 0 because the VMTE is not yet allocated.

Does vpe_id_bits - 1 underflow here, exposing an incorrect IAFFID_BITS
value before it is properly initialized?

[ ... ]
> @@ -174,4 +174,5 @@ static void vgic_v5_mmio_write_irs_misc(struct kvm_vc=
pu *vcpu, gpa_t addr,
> +	case GICV5_IRS_CR0:
> +		mutex_lock(&vcpu->kvm->arch.config_lock);
> +		WRITE_ONCE(vgic->enabled, !!(val & GICV5_IRS_CR0_IRSEN));
> +		kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv5);

[Severity: High]
Does this unconditional kick allow a guest to overload physical CPUs with
IPIs?=20

Should this verify if the IRSEN bit actually changed before making
the all-cpus request?

> +		mutex_unlock(&vcpu->kvm->arch.config_lock);
> +
> +		return;
[ ... ]
> +	case GICV5_IRS_PE_SELR:
> +		irs->pe_selr.iaffid =3D FIELD_GET(GICV5_IRS_PE_SELR_IAFFID, val);

[Severity: Medium]
Are atomic primitives or locks required when accessing this VM-wide state?

If multiple vCPUs concurrently write irs->pe_selr.iaffid locklessly, can it
lead to torn writes and corrupted hardware emulation state?

> +		return;
[ ... ]
> @@ -367,5 +367,6 @@ static unsigned long vgic_v5_mmio_read_irs_ist(struct=
 kvm_vcpu *vcpu,
> +	case GICV5_IRS_IST_BASER:
> +		value =3D FIELD_PREP(GICV5_IRS_IST_BASER_ADDR_MASK,
> +				   irs->ist_baser.addr >> GICV5_IRS_IST_BASER_ADDR_SHIFT);
> +		if (irs->ist_baser.valid)
> +			value |=3D GICV5_IRS_IST_BASER_VALID;

[Severity: Medium]
Similarly to pe_selr, does reading the 64-bit ist_baser locklessly risk
torn reads if another vCPU is concurrently modifying it?

> +		break;
[ ... ]
> @@ -414,3 +414,4 @@ static void vgic_v5_mmio_write_irs_ist(struct kvm_vcp=
u *vcpu, gpa_t addr,
> +	switch (offset) {
> +	case GICV5_IRS_IST_CFGR:

[Severity: High]
The switch statement checks the base offset, but lacks handling for the
upper 32-bit offset (offset + 4) for 64-bit registers like
GICV5_IRS_IST_BASER.=20

Will 32-bit guest writes to the upper half hit the default case and be
ignored?

> +		scoped_guard(mutex, &vcpu->kvm->arch.config_lock) {
> +			if (irs->ist_baser.valid)
[ ... ]
> +		/* Valid -> Invalid */
> +		if (irs->ist_baser.valid && !valid) {
> +			/* Make the LPI IST invalid and then ... */
> +			if (irq_set_vcpu_affinity(vgic_v5_vpe_db(vcpu), &cmd))
> +				break;
> +
> +			/*
> +			 * ... free the host IST if we successfully marked the
> +			 * IST as invalid. Frankly, if we failed to make the
> +			 * guest's IST as invalid, we're cooked because it means
> +			 * that the IRS may still be using the memory that we
> +			 * want to free. Hence, we leave it allocated and skip
> +			 * the clearing of valid bit in the baser.
> +			 */
> +			if (vgic_v5_lpi_ist_free(vcpu->kvm))
> +				break;

[Severity: Medium]
If vgic_v5_lpi_ist_free() fails after successfully issuing
LPI_VIST_MAKE_INVALID, the code breaks out of the switch statement early.

Does this leave the guest-visible irs->ist_baser.valid bit out of sync with
the actual hardware state?

> +		} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
> +			if (!vgic_v5_ist_cfgr_valid(irs)) {
> +				kvm_err("Guest programmed invalid IRS_IST_CFGR\n");

[Severity: Medium]
Can a malicious guest flood the host kernel log by repeatedly writing an
invalid configuration to GICV5_IRS_IST_BASER?=20

Should this use a ratelimited printk to prevent a denial of service?

> +				break;
> +			}
[ ... ]
> @@ -490,4 +490,5 @@ static const struct vgic_register_region vgic_v5_irs_=
registers[] =3D {
> +	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_BASER, vgic_v5_mmio_read_irs_is=
t,
> +				  vgic_v5_mmio_write_irs_ist, 8,
> +				  VGIC_ACCESS_64bit),

[Severity: High]
Since GICV5_IRS_IST_BASER is defined exclusively with VGIC_ACCESS_64bit,
how does the 32-bit KVM UAPI access it during VM save and restore?=20

Will those accesses be rejected?

> +	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_IST_CFGR, vgic_v5_mmio_read_irs_ist,
[ ... ]
> @@ -603,3 +603,4 @@ int vgic_v5_register_irs_iodev(struct kvm *kvm, gpa_t=
 irs_base_address)
> +{
> +	struct vgic_io_device *io_device =3D &kvm->arch.vgic.vgic_v5_irs_data->=
iodev;

[Severity: High]
Is vgic_v5_irs_data allocated anywhere before it is dereferenced here?

Since it doesn't appear to be allocated via kzalloc or kcalloc in this
patch, does this lead to a NULL pointer dereference when accessed?

The same dereference appears to occur in kvm_vgic_v5_irs_init() as well:

kvm_vgic_v5_irs_init() {
	struct vgic_v5_irs *irs =3D dist->vgic_v5_irs_data;
    ...
    irs->idr0.domain =3D GICV5_IRS_IDR0_INT_DOM_NON_SECURE;

> +	unsigned int len;
[ ... ]
> @@ -642,4 +642,4 @@ int kvm_vgic_v5_irs_init(struct kvm *kvm, unsigned in=
t nr_spis)
> +	if (nr_spis && nr_spis < VGIC_V5_DEFAULT_NR_SPIS)
> +		nr_spis =3D VGIC_V5_DEFAULT_NR_SPIS;

[Severity: High]
If the requested nr_spis is bumped locally to VGIC_V5_DEFAULT_NR_SPIS here,
how does core KVM know about the updated count?=20

Could this prevent the guest from accessing the newly padded SPIs since
kvm->arch.vgic.nr_spis remains un-bumped?

> +
> +	if (nr_spis) {

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
> @@ -656,3 +656,4 @@ u8 vgic_v5_vmte_vpe_id_bits(struct kvm_vcpu *vcpu)
> +
> +	vmi =3D xa_load(&vm_info, vm_id);

[Severity: High]
Does this XArray lookup need RCU protection?=20

Since this is called from the MMIO read handler which runs under kvm->srcu
but not rcu_read_lock(), could this violate the XArray API contracts and
cause a use-after-free?

> +	if (!vmi)
> +		return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D20
