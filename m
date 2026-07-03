Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074E1301486;
	Fri,  3 Jul 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096924; cv=none; b=WUb3Nn/mk2k7HAux0gsYBO7uVrbUn9vGfT/45cbT9JlKkE2yJ0wmeFfGAwxObr/mWGO0SpH3OEb2Z1KMaGgQT6vD0XVeKaTrLGr0jTYHqHrBz4SUQR4u/lQ2EEdJ+g52tk89FhbJskTrszxoGKgDOTp2s5t0mXJ4XXX6CQoFd/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096924; c=relaxed/simple;
	bh=8CC4QjHJ6/lSlBZWAokgxgbuH730hI/5gsW8yCYqKDc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D6t+I+Ksgpi36QvJb0M8uTEs4vD+5jQ7u7mXycYMkt0dWnbY+O3fXZPeJybxGBs3aBekAvLeWQxH8/9BOf9PR2L776zBbJ9189krUmSxsfb8wJLVrNe5uCt6KMk62qfpDrRpZ5rYknRWak3OGpXTdi+YgARHt9878NnzixyOwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JD6V8ME/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JD6V8ME/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4041F000E9;
	Fri,  3 Jul 2026 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096922;
	bh=X6rvoL/O6X7K3/HOeb7FqBHldfAObvQHlm3tXAxmDag=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JD6V8ME/7JCStv9Z9fC7CV9kMtYISdx9RzlumBE3MewAJQ3X6nNo0uplwPUHrdHlc
	 NsSY/8Zb8+/O4/AXOOcrNYcYC3heSn1HILcTXhVOoEk0kqL6XxpYNwxnhoNcJWl9v3
	 bIbDKYvm6Ff9/YfpEYA5LWxIXJe1jvht3NYDoGW8xS/pZsZgLEgsZCfIu2Neu3h79f
	 ouYHaMJRXZYwqmLs64DN2lJMULxftSKzNSUQf0BYegcj2TrMKqzr5Fi6YWdz1/hBSh
	 n69ixm7BQHZ2xvEtJ5Lx1oFxTmHxXT/5aoVfnsSN5zlFYS9IX0OXb4IMbF02yZ5mmZ
	 faMEDh4/4jxBQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 34/40] KVM: arm64: gic-v5: Handle userspace accesses
 to IRS MMIO region
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260703154811.3355680-35-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-35-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:42:02 +0000
Message-Id: <20260703164202.7C4041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Exact match requirement for `IAFFID_BITS` against the destination =
host's maximum capacity breaks live migration.
- [High] `vgic_v5_has_attr_regs` returns `-ENXIO` if the IRS base address i=
s not set, breaking KVM_HAS_DEVICE_ATTR capability probing.
- [High] Userspace writes to `GICV5_IRS_SPI_CFGR` are silently ignored, pre=
venting the restoration of SPI configurations during live migration.
- [High] Userspace is permitted to dynamically modify immutable IRS capabil=
ity registers (e.g., `GICV5_IRS_IDR*`) after VM execution has started.

Pre-existing issues:
- [Critical] Concurrent guest MMIO writes to `GICV5_IRS_IST_CFGR` and `GICV=
5_IRS_IST_BASER` cause data races and TOCTOU vulnerabilities due to missing=
 locking.
- [Critical] Concurrent guest MMIO writes to `GICV5_IRS_SPI_SELR` and `GICV=
5_IRS_SPI_CFGR` allow a TOCTOU race leading to type confusion and LPI confi=
guration corruption.
--

commit d06c61fba41ef2677d01b3a366326baadeba3b68
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region

This commit introduces accessors to allow userspace to read and write IRS
MMIO state. This ensures consistent state presentation to the guest and
enables save/restore of GICv5-based systems. It reuses existing access
mechanisms where possible while handling specific registers differently to
enforce sanitization.

> diff --git a/arch/arm64/kvm/vgic/vgic-irs-v5.c b/arch/arm64/kvm/vgic/vgic=
-irs-v5.c
> index 96bf02170caa7..1d63cfe704fda 100644
> --- a/arch/arm64/kvm/vgic/vgic-irs-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-irs-v5.c
[ ... ]
> +static int vgic_v5_write_irs_ist_baser(struct kvm_vcpu *vcpu, unsigned l=
ong val)
> +{
> +	struct vgic_v5_irs *irs =3D vgic_v5_get_irs(vcpu);
> +	enum gicv5_vcpu_cmd cmd =3D LPI_VIST_MAKE_INVALID;
> +	bool valid =3D !!(val & GICV5_IRS_IST_BASER_VALID);
> +	int rc;
> +
> +	/* Valid -> Invalid */
> +	if (irs->ist_baser.valid && !valid) {
[ ... ]
> +	} else if (!irs->ist_baser.valid && valid) { /* Invalid -> Valid */
> +		if (!vgic_v5_ist_cfgr_valid(irs)) {
> +			kvm_err("Guest programmed invalid IRS_IST_CFGR\n");
> +			return -EINVAL;
> +		}
> +
> +		rc =3D vgic_v5_lpi_ist_alloc(vcpu->kvm, irs->ist_cfgr.lpi_id_bits);

[Severity: Critical]
This is a pre-existing issue, but does this sequence create a TOCTOU
vulnerability between GICV5_IRS_IST_CFGR and GICV5_IRS_IST_BASER?

In vgic_v5_mmio_write_irs_ist(), concurrent guest MMIO writes to
GICV5_IRS_IST_CFGR mutate irs->ist_cfgr without holding config_lock.
Meanwhile, vgic_v5_write_irs_ist_baser() holds config_lock, validates
irs->ist_cfgr, and then calls vgic_v5_lpi_ist_alloc().

An unprivileged guest could concurrently modify IST_CFGR from another vCPU
immediately after the validation check passes but before the allocation
function is called. This bypasses the structural bounds checks and allows an
unvalidated lpi_id_bits value to trigger arbitrary out-of-bounds hypervisor
memory allocations.

[ ... ]
> +static int vgic_v5_mmio_uaccess_write_irs(struct kvm_vcpu *vcpu, gpa_t a=
ddr,
> +					  unsigned int len, unsigned long val)
> +{
[ ... ]
> +	case GICV5_IRS_IDR1: {
> +		unsigned int iaffid_bits, priority_bits;
> +		u8 vpe_id_bits;
> +
> +		/* Ignore writes to PE_CNT as this is populated from num vcpus */
> +		iaffid_bits =3D FIELD_GET(GICV5_IRS_IDR1_IAFFID_BITS, val);
> +		priority_bits =3D FIELD_GET(GICV5_IRS_IDR1_PRIORITY_BITS, val);
> +
> +		/*
> +		 * IAFFID_BITS is derived from the host IRS VPE ID capacity and
> +		 * is encoded as N - 1.
> +		 */
> +		vpe_id_bits =3D fls(kvm_vgic_global_state.vgic_v5_irs_caps.max_vpes) -=
 1;
> +		if (iaffid_bits !=3D vpe_id_bits - 1)
> +			return -EINVAL;

[Severity: High]
Does this exact equality check break live migration if the destination host
has a larger VPE capacity?

Live migration expects that saved state from a source host is valid on a
destination host that is at least as capable. Here, the restore operation
strictly requires iaffid_bits to exactly match vpe_id_bits - 1. If migrating
to a host with more VPEs, this check will fail with -EINVAL and break the
migration.

[ ... ]
> +	case GICV5_IRS_SPI_CFGR:
> +		break;

[Severity: High]
Are we silently ignoring the userspace payload for SPI configurations here?

When userspace attempts to restore SPI configurations (edge vs level trigge=
rs)
by writing to GICV5_IRS_SPI_CFGR via the KVM device attribute interface, the
write hits this empty case block. This drops the payload and returns succes=
s,
which prevents the SPI configurations from being restored on the destination
host, leading to data loss and corrupted interrupt state machines after
live migration.

[ ... ]
>  static const struct vgic_register_region vgic_v5_irs_registers[] =3D {
[ ... ]
> -	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_CFGR, vgic_v5_mmio_read_irs_spi,
> -				  vgic_v5_mmio_write_irs_spi, 4,
> -				  VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_SPI_STATUSR,
> -				  vgic_v5_mmio_read_irs_spi, vgic_mmio_write_wi,
> -				  4, VGIC_ACCESS_32bit),
> -	REGISTER_DESC_WITH_LENGTH(GICV5_IRS_PE_SELR, vgic_v5_mmio_read_irs_misc,
> +	REGISTER_DESC_WITH_LENGTH_UACCESS(GICV5_IRS_SPI_CFGR,
> +					  vgic_v5_mmio_read_irs_spi,
> +					  vgic_v5_mmio_write_irs_spi, NULL,
> +					  vgic_v5_mmio_uaccess_write_irs, 4,
> +					  VGIC_ACCESS_32bit),

[Severity: Critical]
This is a pre-existing issue, but is there a TOCTOU race between guest
writes to GICV5_IRS_SPI_SELR and GICV5_IRS_SPI_CFGR?

The SPI_SELR write handler updates irs->spi_selr.id non-atomically and
without locks. The SPI_CFGR handler validates the ID, then fetches the IRQ
struct and updates its configuration:

    if (!vgic_v5_is_spi_selr_valid(irs))
        return;
    irq =3D vgic_get_irq(vcpu->kvm, vgic_v5_make_spi(irs->spi_selr.id));

An unprivileged guest can concurrently overwrite irs->spi_selr.id between
validation and lookup. By injecting an LPI ID, vgic_get_irq() will fetch an
LPI struct instead of an SPI, allowing the guest to modify the irq->config =
of
an LPI to be level-triggered. Since LPIs are architecturally strictly
edge-triggered, this corrupts the internal state machine.

[ ... ]
> +int vgic_v5_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr=
 *attr)
> +{
> +	const struct vgic_register_region *region;
> +	struct vgic_reg_attr reg_attr;
> +	struct kvm_vcpu *vcpu;
> +	gpa_t addr, offset;
> +	int ret, align;
> +
> +	ret =3D vgic_v5_parse_attr(dev, attr, &reg_attr);
> +	if (ret)
> +		return ret;
> +
> +	vcpu =3D reg_attr.vcpu;
> +	addr =3D reg_attr.addr;
> +
> +	if (attr->group =3D=3D KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS)
> +		return vgic_v5_has_cpu_sysregs_attr(vcpu, attr);
> +
> +	offset =3D attr->attr;
> +
> +	if (IS_VGIC_ADDR_UNDEF(dev->kvm->arch.vgic.vgic_v5_irs_data->vgic_v5_ir=
s_base))
> +		return -ENXIO;

[Severity: High]
Could this base address check break the KVM_HAS_DEVICE_ATTR capability
probing?

Userspace tools often probe for supported VGIC attributes immediately after
device creation, before configuring memory layouts like the IRS base addres=
s.
By explicitly failing with -ENXIO if the base address is UNDEF, the kernel
falsely reports that IRS registers are unsupported during the standard prob=
ing
phase, which breaks the API contract.

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> index 075e4c1326754..cab3d6db070ac 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
[ ... ]
>  	if (kvm_trylock_all_vcpus(dev->kvm)) {
>  		mutex_unlock(&dev->kvm->lock);
>  		return -EBUSY;
>  	}
> =20
>  	mutex_lock(&dev->kvm->arch.config_lock);
> =20
>  	if (!(vgic_initialized(dev->kvm) || v5_reg_allowed_pre_init(attr))) {
>  		ret =3D -EBUSY;
>  		goto out;
>  	}

[Severity: High]
Does this UAPI gate allow userspace to dynamically modify immutable IRS
capability registers after the VM has started executing?

The gate checks vgic_initialized(dev->kvm), but it lacks the
vcpu_has_run_once() check required by KVM guidelines to freeze architectural
features. This allows a process to mutate structural capability limits
(like IDR0, IDR1, IDR2) dynamically while the VM is active, causing KVM's
internal validation to desync from allocated hardware structures.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D34
