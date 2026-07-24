Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B275241DDE0;
	Fri, 24 Jul 2026 12:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784895549; cv=none; b=fR4T2oDaQDPgrzMVho2KoDixAnT4e9MgCV4O6oUruPBAzB5xFLpN112o5JGr2iFbxJyOXHVA7Uj+PGBexQEs52Irzd8uzQ+2EfDkKb82J+w36SttE7dcZF4WLFOqHQE8JNA/bpZmyrmzERUpMioh9ZAK8X/v8vXHHFqSS3ht6SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784895549; c=relaxed/simple;
	bh=1ogo+sE4LT097R5p91v99lyJwrFApLuOeXPI/NuU8+k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NlWzGmF2tBHmlEmfL8LT8mA1qzyZOoCy7JPFeH49XNC/MLVJj75nl0LhFQyKgV4NrgMLcimpgvYDyfyYBr9ebNxnjUoaKfSk3xl81SZbBH0wIubYhVctGjqMLD55IKGoKP7du5TE1+q/ZA8XzNkKloO18Vyft0vIbKGWvXdtacA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m8z7qgJd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8z7qgJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1D71F000E9;
	Fri, 24 Jul 2026 12:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784895547;
	bh=yCSWVO3fg5/xgVI51v/QXz0dNn5lssACMVm5VFz5nQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m8z7qgJdY5Rbsussa4keEBJ34zCOu61/PfY/HHnK7yepzWvwYhPTuObkIjUrkca7O
	 T1uAcBNL4cv+57URPFGNG1xV52Ig2/nL9fTPK0SJS97uYy+zP5oJ6OqCyrzMoacuCz
	 yK9rZlqg8llBF+OMQDDWtN3+pm8xpWJWKwBvA+oAyYceuwD08RcVGWRnzTD54FQFma
	 Elfcaqihym/dL1vXmVPwV/hZFRaUEj7kcwEX99obgEv4CUxRNlXUVPG0EHIekqKCI0
	 mhn69feklSk/0aKgZqn2ANkl4b6oeSEKXRwycKmilN5T9uEwLK+uzr0tst3RxLYRRQ
	 dCss2zlev/VeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 37/48] Documentation: KVM: Add
 KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260724104819.1296803-38-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-38-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 12:19:06 +0000
Message-Id: <20260724121906.BC1D71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] The documentation for KVM_DEV_ARM_VGIC_GRP_IRS_REGS omits that writ=
es will return -EBUSY if a VCPU has run.

Pre-existing issues:
- [High] SPI configuration (edge/level) is permanently lost during VM migra=
tion because KVM ignores userspace writes to `GICV5_IRS_SPI_CFGR` and fails=
 to serialize the configuration into the Interrupt State Table (IST).
--

--- Patch [37]: [PATCH v4 37/48] Documentation: KVM: Add KVM_DEV_ARM_VGIC_G=
RP_IRS_REGS to VGICv5 docs ---
commit 6c9776f9e0496eb6c3e26fe3876764cc1148cc8a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs

Document the KVM_DEV_ARM_VGIC_GRP_IRS_REGS attribute group used to
read and write the virtual IRS's MMIO register state. This provides a
GICv5-specific interface for state that is conceptually similar to the
VGICv3 ITS register interface, but uses IRS terminology instead of ITS.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index 50d8030e2c804..c411d2195c6a0 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> @@ -149,3 +149,41 @@ Groups:

[ ... ]

> +      For registers without dedicated userspace accessors, getting or se=
tting a
> +      register uses the same emulated MMIO handlers as guest reads/write=
s.
> +      Dedicated userspace accessors may instead save or restore migratio=
n state
> +      without triggering guest-visible side effects. For example, restor=
ing
> +      IRS_IST_BASER only restores the emulated register state; any host =
LPI IST
> +      allocation based on the restored IRS_IST_CFGR and IRS_IST_BASER st=
ate
> +      happens when KVM_DEV_ARM_VGIC_GRP_IST is restored.

[Severity: High]
This is a pre-existing issue, but does VM migration permanently lose the
edge/level configuration for all SPIs because of how GICV5_IRS_SPI_CFGR is
handled?

The userspace write accessor explicitly ignores writes to the SPI
configuration register, making manual restoration impossible:

arch/arm64/kvm/vgic/vgic-irs-v5.c:vgic_v5_mmio_uaccess_write_irs() {
    ...
	case GICV5_IRS_SPI_CFGR:
		break;
    ...
}

Additionally, the IST is copied to userspace directly from hardware memory
without synthesizing KVM's software-tracked irq->config into the HM bit:

arch/arm64/kvm/vgic/vgic-v5-tables.c:vgic_v5_save_linear_ist() {
    ...
		h_iste =3D READ_ONCE(*h_iste_addr);
		ret =3D put_user(h_iste, uaddr);
    ...
}

Since the configuration is lost during the IST save and cannot be restored
via GICV5_IRS_SPI_CFGR, are level-triggered interrupts restored incorrectly
as edge-triggered?

> +
> +  Errors:
> +
> +    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +    -ENXIO   Offset does not correspond to any supported register
> +    -EFAULT  Invalid user pointer for attr->addr
> +    -EINVAL  Offset is not 32-bit aligned for 32-bit MMIO registers, not
> +             64-bit aligned for 64-bit registers, or the supplied regist=
er
> +             value is not compatible with the configured VGICv5 IRS state
> +    -EBUSY   VGIC is not initialized, or one or more VCPUs are running
> +    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[Severity: Low]
Does this error description miss the case where a VCPU has already run?

Looking at vgic_v5_attr_regs_access() in arch/arm64/kvm/vgic/vgic-kvm-devic=
e.c:

	if (is_write && vgic_v5_vm_has_run_once(dev->kvm)) {
		ret =3D -EBUSY;
		goto out;
	}

Should the documentation also mention that writes are rejected with -EBUSY
if attempted after a VCPU has run?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D37
