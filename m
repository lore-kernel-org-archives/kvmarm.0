Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652735;
	b=Olmcwy9lRHT2I5ZydEFubGyYJQI8nf7ercZpRPraqzU56lPGO3UNWKd1b/BzgQW5hxmd
	 F0pe0tAR96T+1HK+Bv5Eqg/ygo4GU9aZrowa52q9ynki92o/6gLGjTCB/CDG9OnY3olc4
	 /4uriiJa7rzlPHuPWYAkt2WaRj9bYKcPkOZBl5u9Z5bm9J3o8nCqGLOfZ7RzUy0ljBZ2U
	 fj8Au+SHw6cu6Te200EySi81e2DeNMpTfdIEjzxQB/dasdpGpKr4BFgH8zfO58mZuPHzS
	 PX5CdrJ2vObfx9knq84aVQfD9yARtydAzsEJVTKo/pBh66Uwct7/wgndk3voXOFA2ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652735;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7QugoOt8qgWiYDV7Dx3NZfL/wqwh64z7XX11qwR6NBc=;
	b=hRqAMWbjzf9+sO1e7HdKqYh/0F5YFebjtGD5naIgQQ9XQsAPbqECZAeEC+aNik/V+A8S
	 /Nh1fM9CH9CAwHGtFJJwkLHJSz5twj1XqNii5VUxOsPJLWFYXOe3dGm7loI8w/Z3EBzFJ
	 DP/TyEh5+xeyFePpWck1XV0whIqwYkD7oRX3CG8lEuGglRIxhI6RGFifXVM45BQ+pGSFa
	 l6tbhI/eqCY7LWdTR/+5azCgq8UTKlrsmYJ6Y0rlw/lI2hUt3zh+SsrakpB6GWtsm4j2z
	 gFAl7bS8V90j1T/1O91h4xSqrxgyFUKWtT7oimbjDOgb1o7J7nv1klQ0S6Ml/CTr+5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D+ej4GfQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4FA606A324;
	Mon,  2 Nov 2026 20:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D+ej4GfQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92481F00A16;
	Mon,  2 Nov 2026 20:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793652734;
	bh=7QugoOt8qgWiYDV7Dx3NZfL/wqwh64z7XX11qwR6NBc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D+ej4GfQzUP/+CARDRYaPp7GRBosEDl2nO+ZJ/iVnL0JsPAl9BW7GB0AXDSWZs/2K
	 cQspZPbUHtzLPTSzBfCG2cTGAu7V7b7ekfcNCoMdXjJ88ju1TG3VHRICqiihl2NgAH
	 pZb0WMskSAhv62SofTWYsfcPmW4Xx6WzAPYAwXlzkLfxmSx+LfYO6c5FE9GtC0IGGe
	 RLTakx3xEuV48Usyzxz5vzqhg89N9Clvnir1FFHpp0c8IEudAdunV/4KdCAGZRFqRi
	 ZoSEZikcrrLPvwoVPkEk79MuvIgR/Q49KkTgEXCFDB5cqpuEg2V62FcklZsIWPN6tS
	 v/6oBftKKJVhA==
Message-ID: <sashiko-outbox-194153@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/16] KVM: arm64: gic-v5: Add ITS userspace register
 access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-11-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-11-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 20:52:14 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] KVM: arm64: gic-v5: missing vgic_initialized() check before LPI in=
jection
- [Medium] KVM: arm64: gic-v5: unenforced IDR1/IDR2 limits and stale cache =
on write
- [Medium] KVM: arm64: gic-v5: GICV5_ITS_SYNCR registered as 32-bit instead=
 of 64-bit
- [Low] KVM: arm64: gic-v5: 64-bit attr->attr offset truncated to 32-bit in=
 ITS regs
--

commit 3a58686064e4b9037bb8becf8b235cece1c6b8e0
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS userspace register access

This commit exposes the emulated GICv5 ITS MMIO register frame to userspace
via KVM_DEV_ARM_VGIC_GRP_ITS_REGS and adds support for resetting the ITS via
KVM_DEV_ARM_ITS_CTRL_RESET. It also adds dedicated userspace write handlers
for restoring IDR0-IDR2, DT_BASER, DT_CFGR, and READ_EVENT_DATAR.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index b69a1d107c0ae..638ee47f6e27d 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -688,6 +688,70 @@ static void vgic_v5_mmio_write_its_misc(struct kvm *=
kvm, void *dev, gpa_t addr,
>  	}
>  }
> =20
> +static int vgic_v5_uaccess_write_its_idr(struct kvm *kvm, void *dev,
> +					gpa_t addr, unsigned int len,
> +					unsigned long val)
> +{
> +	struct vgic_v5_its *its =3D dev;
> +	size_t offset =3D addr & (SZ_64K - 1);
> +	u64 mmfr0;
> +
> +	guard(mutex)(&its->its_lock);
> +
> +	switch (offset) {
[ ... ]
> +	case GICV5_ITS_IDR1:
> +		if ((val & ~(GICV5_ITS_IDR1_L2SZ |
> +			     GICV5_ITS_IDR1_ITT_LEVELS |
> +			     GICV5_ITS_IDR1_DT_LEVELS |
> +			     GICV5_ITS_IDR1_DEVICEID_BITS)) ||
> +		    FIELD_GET(GICV5_ITS_IDR1_DEVICEID_BITS, val) >
> +		    VITS_V5_DEVICE_ID_BITS)
> +			return -EINVAL;
> +
> +		/*
> +		 * Userspace can change the DeviceID limit after translations have
> +		 * been cached. Drop them so the old limit cannot remain in effect.
> +		 */
> +		if (its->idr1.device_id_bits !=3D
> +		    FIELD_GET(GICV5_ITS_IDR1_DEVICEID_BITS, val))
> +			its_cache_clear_translations(its);
> +
> +		its->idr1.device_id_bits =3D FIELD_GET(GICV5_ITS_IDR1_DEVICEID_BITS,
> +							 val);
> +		its->idr1.dt_levels =3D !!(val & GICV5_ITS_IDR1_DT_LEVELS);
> +		its->idr1.itt_levels =3D !!(val & GICV5_ITS_IDR1_ITT_LEVELS);
> +		its->idr1.l2sz =3D FIELD_GET(GICV5_ITS_IDR1_L2SZ, val);
> +		return 0;
> +	case GICV5_ITS_IDR2:
> +		if ((val & ~GICV5_ITS_IDR2_EVENTID_BITS) ||
> +		    FIELD_GET(GICV5_ITS_IDR2_EVENTID_BITS, val) >
> +		    VITS_V5_EVENT_ID_BITS)
> +			return -EINVAL;
> +
> +		its->idr2.event_id_bits =3D FIELD_GET(GICV5_ITS_IDR2_EVENTID_BITS,
> +							 val);
> +		return 0;

[Severity: Medium]
When userspace writes GICV5_ITS_IDR1 or GICV5_ITS_IDR2 in
vgic_v5_uaccess_write_its_idr(), changes to its->idr1.device_id_bits clear
the translation cache and are enforced in get_itt() via:

	device_id_bits =3D min(its->dt_cfgr.device_id_bits,
			     its->idr1.device_id_bits);

However, for GICV5_ITS_IDR2, updating its->idr2.event_id_bits does not call
its_cache_clear_translations(its), and __vgic_v5_its_resolve_lpi() checks
event_id against the unclamped event_id_bits read from the guest DTE without
clamping to its->idr2.event_id_bits:

	ret =3D get_itt(kvm, its, device_id, &itt_base, &two_level_itt,
		      &event_id_bits, &itt_l2sz);
	...
	if (event_id >=3D 1UL << event_id_bits) {
		kvm_debug("Event ID out of range\n");
		return VITS_V5_UNMAPPED;
	}

Similarly, in GICV5_ITS_IDR1, updates to its->idr1.dt_levels,
its->idr1.itt_levels, and its->idr1.l2sz do not invalidate cached
translations, and get_itt(), parse_two_level_dt(), get_itte(), and
parse_two_level_itt() do not check whether two-level tables or the selected
L2 sizes are enabled in its->idr1 (and vgic_v5_its_reset() initializes
its->idr1.l2sz to 0 while advertising dt_levels =3D 1 and itt_levels =3D 1).

Should changes to these IDR1 and IDR2 fields also flush the translation cac=
he
and be enforced during DT/ITT translation walks?

[ ... ]
> @@ -1130,64 +1241,226 @@ static int vgic_v5_register_its_iodev(struct kvm=
 *kvm, struct vgic_v5_its *its,
>  	return ret;
>  }
> =20
> +static int vgic_v5_its_has_attr_regs(struct kvm_device *dev,
> +				     struct kvm_device_attr *attr)
> +{
> +	const struct vgic_register_region *region;
> +	gpa_t offset =3D attr->attr;
> +	int align;
> +
> +	region =3D vgic_find_mmio_region(vgic_v5_its_registers,
> +				       ARRAY_SIZE(vgic_v5_its_registers),
> +				       offset);

[Severity: Low]
In both vgic_v5_its_has_attr_regs() and vgic_v5_its_attr_regs_access(),
offset is a 64-bit gpa_t taken from attr->attr, but vgic_find_mmio_region()
takes a 32-bit unsigned int offset parameter:

const struct vgic_register_region *
vgic_find_mmio_region(const struct vgic_register_region *regions,
		      int nr_regions, unsigned int offset)

If userspace passes an attr->attr value with non-zero upper 32 bits and a
valid lower 32-bit register offset, vgic_find_mmio_region() truncates offset
to 32 bits, the alignment check only tests the low bits, and the register
callbacks mask addr with (SZ_64K - 1).

Should vgic_v5_its_has_attr_regs() and vgic_v5_its_attr_regs_access() reject
offsets outside the ITS register frame before calling vgic_find_mmio_region=
()?

> +	if (!region)
> +		return -ENXIO;
> +
> +	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
> +	if (offset & align)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int vgic_v5_its_attr_regs_access(struct kvm_device *dev,
> +					struct kvm_device_attr *attr,
> +					u64 *reg, bool is_write)
> +{
> +	const struct vgic_register_region *region;
> +	struct vgic_v5_its *its =3D dev->private;
> +	gpa_t offset =3D attr->attr;
> +	unsigned int len;
> +	gpa_t addr;
> +	int align;
> +	int ret =3D 0;
> +
> +	mutex_lock(&dev->kvm->lock);
> +
> +	if (kvm_trylock_all_vcpus(dev->kvm)) {
> +		mutex_unlock(&dev->kvm->lock);
> +		return -EBUSY;
> +	}
> +
> +	mutex_lock(&dev->kvm->arch.config_lock);
> +
> +	if (IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base)) {
> +		ret =3D -ENXIO;
> +		goto out;
> +	}
> +
> +	region =3D vgic_find_mmio_region(vgic_v5_its_registers,
> +				       ARRAY_SIZE(vgic_v5_its_registers),
> +				       offset);
> +	if (!region) {
> +		ret =3D -ENXIO;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Although the spec supports upper/lower 32-bit accesses to
> +	 * 64-bit ITS registers, the userspace ABI requires 64-bit
> +	 * accesses to all 64-bit wide registers.
> +	 */
> +	align =3D region->access_flags & VGIC_ACCESS_64bit ? 0x7 : 0x3;
> +	len =3D region->access_flags & VGIC_ACCESS_64bit ? 8 : 4;

[Severity: Medium]
vgic_v5_its_has_attr_regs() and vgic_v5_its_attr_regs_access() determine the
userspace ABI alignment and access width from region->access_flags &
VGIC_ACCESS_64bit.

In vgic_v5_its_registers[], GICV5_ITS_SYNCR is declared with length 4 and
VGIC_ACCESS_32bit:

	REGISTER_ITS_V5_DESC(GICV5_ITS_SYNCR, vgic_v5_mmio_read_its_raz,
			     vgic_v5_mmio_write_its_dt_itt, 4,
			     VGIC_ACCESS_32bit),

However, in include/linux/irqchip/arm-gic-v5.h, GICV5_ITS_SYNCR is a 64-bit
register at offset 0x0140 with GICV5_ITS_SYNCR_SYNC at BIT_ULL(63) and
GICV5_ITS_SYNCR_SYNCALL at BIT_ULL(32), and the host driver in
drivers/irqchip/irq-gic-v5-its.c writes it with a 64-bit access.

Because its descriptor uses length 4 and VGIC_ACCESS_32bit, userspace
accesses treat GICV5_ITS_SYNCR as a 32-bit register (align 0x3, len 4), and
guest 64-bit MMIO writes or 32-bit writes to GICV5_ITS_SYNCR + 4 fail lookup
in vgic_get_mmio_region(). (Conversely, GICV5_ITS_SWERR_STATUSR,
GICV5_ITS_SWERR_SYNDROMER0, GICV5_ITS_SWERR_SYNDROMER1, and
GICV5_ITS_MPAM_PMGR are declared with VGIC_ACCESS_64bit without
VGIC_ACCESS_32bit.)

Should GICV5_ITS_SYNCR be registered with length 8 and
VGIC_ACCESS_64bit | VGIC_ACCESS_32bit?

> +
> +	if (offset & align) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	addr =3D its->vgic_v5_its_base + offset;
> +
> +	if (is_write) {
> +		if (region->uaccess_its_write)
> +			ret =3D region->uaccess_its_write(dev->kvm, its, addr,
> +							len, *reg);
> +		else
> +			region->its_write(dev->kvm, its, addr, len, *reg);

[Severity: High]
Comparing all 32 register descriptors (covering 43 registers, including the
12 CoreSight PIDR/CIDR registers in the 48-byte GICV5_CORESIGHT_PIDR4 regio=
n)
in vgic_v5_its_registers[] between guest MMIO and userspace access in
vgic_v5_its_attr_regs_access():

- 6 descriptors (6 registers: GICV5_ITS_IDR0, GICV5_ITS_IDR1, GICV5_ITS_IDR=
2,
  GICV5_ITS_DT_BASER, GICV5_ITS_DT_CFGR, GICV5_ITS_READ_EVENT_DATAR) use a
  dedicated uaccess_its_write callback.
- 6 descriptors (6 registers: GICV5_ITS_CR0, GICV5_ITS_CR1, GICV5_ITS_DIDR,
  GICV5_ITS_EIDR, GICV5_ITS_GEN_EVENT_DIDR, GICV5_ITS_GEN_EVENT_EIDR) are RW
  state registers whose userspace writes fall back to region->its_write.
- 15 descriptors (26 registers: GICV5_ITS_IIDR, GICV5_ITS_AIDR,
  GICV5_ITS_STATUSR, GICV5_ITS_SYNC_STATUSR, GICV5_ITS_GEN_EVENT_STATUSR,
  GICV5_ITS_MEC_IDR, GICV5_ITS_MEC_MECID_R, GICV5_ITS_MPAM_IDR,
  GICV5_ITS_MPAM_PARTID_R, GICV5_ITS_SWERR_STATUSR,
  GICV5_ITS_SWERR_SYNDROMER0, GICV5_ITS_SWERR_SYNDROMER1,
  GICV5_ITS_MPAM_PMGR, GICV5_CORESIGHT_DEVARCH, and the 12 registers in
  GICV5_CORESIGHT_PIDR4) use vgic_v5_mmio_write_its_wi().
- 5 descriptors (5 registers: GICV5_ITS_INV_EVENTR, GICV5_ITS_INV_DEVICER,
  GICV5_ITS_READ_EVENTR, GICV5_ITS_SYNCR, GICV5_ITS_GEN_EVENTR) are action
  registers that read as zero via vgic_v5_mmio_read_its_raz() and have no
  uaccess_its_write callback, so userspace writes execute
  vgic_v5_mmio_write_its_dt_itt().

In particular, vgic_v5_its_attr_regs_access() only checks that
its->vgic_v5_its_base is defined; neither it nor the LPI translation and
injection paths (vgic_v5_its_handle_gen_event(), __vgic_v5_its_resolve_lpi(=
),
vgic_v5_its_inject_msi(), and vgic_v5_its_inject_lpi()) check
vgic_initialized(kvm) or irqchip_in_kernel(kvm):

static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
{
	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, true,
		     kvm->arch.vgic.gicv5_vm.vm_id);
}

Because vgic_v5_its_create() allows creating the ITS device before
KVM_DEV_TYPE_ARM_VGIC_V5 is created, kvm->arch.vgic.gicv5_vm.vm_id is 0 from
the zero-allocation of struct kvm (since VGIC_V5_VM_ID_INVAL is only assign=
ed
in kvm_vgic_create(), and vgic_v5_allocate_vm_id() allocates hardware VM IDs
starting from 0). If KVM_DEV_TYPE_ARM_VGIC_V5 has been created but not yet
initialized via KVM_DEV_ARM_VGIC_CTRL_INIT, vm_id is VGIC_V5_VM_ID_INVAL (-=
1,
truncated to 0xffff).

If userspace enables GICV5_ITS_CR0 via KVM_DEV_ARM_VGIC_GRP_ITS_REGS and
triggers LPI injection via GICV5_ITS_GEN_EVENTR (with GICV5_ITS_GEN_EVENTR_R
set) or KVM_SIGNAL_MSI before the VGICv5 is created or initialized, can this
execute __vgic_v5_vdpend at EL2 with hardware vm_id 0 (injecting LPIs into
another guest VM owning VM ID 0) or with an uninitialized vm_id of 0xffff?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D10
