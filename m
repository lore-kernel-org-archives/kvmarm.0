Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B5B360EFA;
	Fri, 16 Oct 2026 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167550; cv=none; b=EmUnPIvnjW2M9rw2HO/3Kx0ooy1ROkhlU1N9HlWyE4GBN3+aAui9R/ZNEpWvFM7hIHflLksp99HLQlEiiXNz6TFsdOb4IrDfkputVSBSd8XSeuttRvOPR4Yg3Vd4f3yMmB+jPASWnlWHBTuwPo1jEgQOeQ9uFtdsqbNTFochbqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167550; c=relaxed/simple;
	bh=jVEBIEeM3TvvZf2TDqeleoQ3ZwEXpz8q+7h6U/RgRgU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=anJ44w4QbwBmoA0XZ+fIlas50wsJ85dl5jjBghZrVqnGWYrGshiO2kNey6rdoHPuLNGPWMx6IndQdnKVGwRj2dIkUGJtOUudi8Gz58U4/vBCEXKR+fwroinn98S+WwCvdAX8bp5PHHVlRK4n6UUlg0RLxbj24S5BZzChBoxG35Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WS9JjRjd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WS9JjRjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8031F000C5;
	Fri, 16 Oct 2026 16:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792167545;
	bh=Cg8mw1JIaxzW8OZr4b4hGTEoSgAmFcv8DRMaav4pSPo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WS9JjRjdVEE6JrsasZV3JW3iLUfl0zLZxRjE5ofZPDoo4Lvl1G/QOXHdIbmw8LN79
	 9ggQGjbmTeAR0DMv4E146cpu62pkUoMb/4LHCn/YuLKO2f7ZvrlfFZlhIu/8B7D3Zb
	 TQv22PkEDriNH4YaH3o4vabpJzfot2G69QbWksXI5y4xypFy9tWIdwwIKA6m8/J2bm
	 /O8CKLMGQeY/G9365rMRu8OmBeqdJZCHwukjBvRg7foaZwT+gBDEsgbVIkPjStmEJg
	 ClgR+t6a91vs8IgMOIasS1o89DQ1FI93CM2qESY4TE4ZSePYEtLZewjIJAHTUBB6qJ
	 bNEduUZZRikdw==
Message-ID: <sashiko-outbox-174627@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/16] KVM: arm64: gic-v5: Add ITS userspace register
 access
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016155741.979985-11-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-11-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 16:19:05 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] gic-v5: userspace override omits guest-side guard without post-res=
tore validation
- [High] gic-v5: userspace writes to stateful and capability registers are =
silently discarded
- [Medium] gic-v5: missing state rollback on kvm_io_bus_register_dev failure
- [Medium] kvm: arm64: KVM_HAS_DEVICE_ATTR fails on ITS registers before ba=
se address is set
- [Medium] kvm: arm64: gic-v5: userspace writes to ITS ID registers are sil=
ently discarded
--

commit 2fb8c28d93170f4ea49aeb17c5091f5d920592c9
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS userspace register access

This commit exposes the GICv5 ITS register frame to userspace for inspection
and restoration around VM reset and migration. It applies userspace access
constraints and adds control handling for reset while preserving ITS
defaults.

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> index 5920fa1bcb2cf..62c1ca8004007 100644
> --- a/arch/arm64/kvm/vgic/vgic-its-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -851,6 +851,19 @@ static u64 vgic_v5_read_its_dt_baser(struct vgic_v5_=
its *its)
>  			  its->dt_baser.addr >> GICV5_ITS_DT_BASER_ADDR_SHIFT);
>  }
> =20
> +static int vgic_v5_uaccess_write_its_dt_itt(struct kvm *kvm, void *dev,
> +					    gpa_t addr, unsigned int len,
> +					    unsigned long val)
> +{
> +	struct vgic_v5_its *its =3D dev;
> +	size_t offset =3D addr & (SZ_64K - 1);
> +
> +	guard(mutex)(&its->its_lock);
> +
> +	vgic_v5_write_its_dt_reg(its, offset, val);
> +	return 0;
> +}

[Severity: High]
This userspace override in arch/arm64/kvm/vgic/vgic-its-v5.c intentionally
omits the guest-side !its->enabled guard, which makes sense for permitting
out-of-order restoration. However, when a guest-side refusal is omitted, a
final validation step is required at the end of the restore sequence to
re-establish the invariant.

Because KVM_DEV_ARM_VGIC_CTRL_INIT is handled as a no-op below and there
are no RESTORE_TABLES controls exposed for GICv5, KVM never validates the
final configuration. Could this allow userspace to leave the device in an
illegal state (e.g., base address modified while active) that the guest
could never produce?

[ ... ]
> @@ -1018,6 +1031,13 @@ static void vgic_v5_mmio_write_its_wi(struct kvm *=
kvm, void *dev, gpa_t addr,
>  		.its_read =3D rd, .its_write =3D wr,                       \
>  	}
> =20
> +#define REGISTER_ITS_V5_DESC_UACCESS(off, rd, wr, uwr, length, acc)    \
> +	{                                                              \
> +		.reg_offset =3D off, .len =3D length, .access_flags =3D acc, \
> +		.its_read =3D rd, .its_write =3D wr,                       \
> +		.uaccess_its_write =3D uwr,                              \
> +	}
> +
>  static const struct vgic_register_region vgic_v5_its_registers[] =3D {
>  	REGISTER_ITS_V5_DESC(GICV5_ITS_IDR0, vgic_v5_mmio_read_its_misc,
>  			     vgic_v5_mmio_write_its_wi, 4, VGIC_ACCESS_32bit),

[Severity: Medium]
IDR0 is registered without a userspace write override, falling back to the
guest's write-ignore handler vgic_v5_mmio_write_its_wi(). Because userspace
writes are silently discarded here in arch/arm64/kvm/vgic/vgic-its-v5.c, a
VM migrated to a new host will adopt the destination host's physical ITS
capabilities (like pa_range in vgic_v5_its_reset()) rather than retaining
its original configuration.

Will this break migration for heterogeneous clusters since capability
mismatches are swallowed instead of rejected or applied?

[ ... ]
>  	REGISTER_ITS_V5_DESC(GICV5_ITS_READ_EVENT_DATAR,
>  			     vgic_v5_mmio_read_its_dt_itt,
>  			     vgic_v5_mmio_write_its_wi, 8,
>  			     VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),

[Severity: High]
Stateful registers like READ_EVENT_DATAR also lack a uaccess_its_write
override in vgic_v5_its_registers and use the guest write-ignore handler
vgic_v5_mmio_write_its_wi().

Since the write-ignore handler silently accepts the write and discards the
value, wouldn't pending event data be permanently lost during migration?

[ ... ]
> +static int vgic_v5_its_has_attr_regs(struct kvm_device *dev,
> +				     struct kvm_device_attr *attr)
> +{
> +	struct vgic_v5_its *its =3D dev->private;
> +	const struct vgic_register_region *region;
> +	gpa_t offset =3D attr->attr;
> +	int align;
> +
> +	if (IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base))
> +		return -ENXIO;

[Severity: Medium]
This runtime state check in vgic_v5_its_has_attr_regs() enforces a base
address requirement during a purely capability-probing ioctl.

Userspace VMMs probing for supported GICv5 ITS registers via
KVM_HAS_DEVICE_ATTR will receive -ENXIO if they probe before configuring
the ITS base address. Could this cause the VMM to incorrectly assume the
registers or device capabilities are unsupported, breaking device
initialization or migration setup? Other VGIC implementations explicitly
omit the base address check in their has_attr handlers to permit capability
probing without prior configuration.

[ ... ]
> +static int vgic_v5_its_attr_regs_access(struct kvm_device *dev,
> +					struct kvm_device_attr *attr,
> +					u64 *reg, bool is_write)
> +{
...
> +	if (is_write) {
> +		if (region->uaccess_its_write)
> +			ret =3D region->uaccess_its_write(dev->kvm, its, addr,
> +							len, *reg);
> +		else
> +			region->its_write(dev->kvm, its, addr, len, *reg);
> +	} else {
> +		*reg =3D region->its_read(dev->kvm, its, addr, len);
> +	}

[Severity: High]
As mentioned above, userspace writes to several registers (IDR0, CR1,
SYNCR, READ_EVENT_DATAR) fall back to the guest-side its_write handler in
vgic_v5_its_attr_regs_access() when no override is provided. Because these
guest handlers silently accept the write and discard the value, mutable
guest state is lost across migration and invalid capability settings are
silently ignored instead of being rejected.

[ ... ]
> +static int vgic_v5_its_ctrl(struct kvm *kvm, struct vgic_v5_its *its, u6=
4 attr)
> +{
> +	int ret =3D 0;
> +
> +	if (attr =3D=3D KVM_DEV_ARM_VGIC_CTRL_INIT)
> +		return 0;

[Severity: High]
The initialization/finalization control in vgic_v5_its_ctrl() is a no-op,
meaning no end-of-restore validation is performed to check the invariants
that were bypassed by the userspace overrides (like the !its->enabled
check).

[ ... ]
> +static int vgic_v5_its_set_attr(struct kvm_device *dev,
> +				struct kvm_device_attr *attr)
> +{
...
> +		ret =3D vgic_check_iorange(dev->kvm, its->vgic_v5_its_base,
> +					 addr, SZ_64K, KVM_VGIC_V5_ITS_SIZE);
> +		if (ret)
> +			return ret;
> +
> +		return vgic_v5_register_its_iodev(dev->kvm, its, addr);

[Severity: Medium]
In vgic_v5_register_its_iodev() in arch/arm64/kvm/vgic/vgic-its-v5.c,
its->vgic_v5_its_base is populated with the requested addr before
attempting to register the IO bus device. If kvm_io_bus_register_dev()
fails (e.g. due to ENOMEM), the error path fails to clear
its->vgic_v5_its_base upon failure:

	its->vgic_v5_its_base =3D addr;
	...
	ret =3D kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
				      KVM_VGIC_V5_ITS_SIZE, &iodev->dev);
out:
	mutex_unlock(&kvm->slots_lock);

	return ret;

Will this leave the ITS permanently unusable? Subsequent attempts by
userspace to correctly set the base address will fail with -EBUSY because
IS_VGIC_ADDR_UNDEF() evaluates to false, leaving the ITS permanently
unmapped.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016155741.9799=
85-1-sascha.bischoff@arm.com?part=3D10
