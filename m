Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793650112;
	b=SiepblLEdLMn3mAXBoZ7HpGf2QJWQ05bZ7V1/CUQoSELEOgqS+jbtBq0DrSqVKaykOdM
	 9MnwBC9HmIbtKWXucJs6XR+BeHKzReEEUuVk8YDjKxWhAWWDYqySQz+z6+QJTXYCCpL2E
	 Q1l4dNKG8Dndx4I5w3+MGHl9S/SC//lTFrFJQ/jqBPB6NWXpOlQWPs9vUiqsPzU9nUnZP
	 yKPaUGEWf2vKpiKMDZa0LzsQoK1KOJQv5+fiUfpJouICgSBI8tGkV1q9bbtcWgHsSYOJt
	 xBa/TmVYIanPsJdaFkQ70PNfBkfiyydnx7l8Jv2JLl6YfbJnF2ydYKhLy6gQVE3D5UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793650112;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wPiOj6Ramt3ftxK4C2lZHrvYb9x8b9IA7sKO2384dFo=;
	b=05A/kI3/3XfM7TruSPvS2MM9ENIMzcxDKGvIj8GLMNcFtfoGta1vH3xK275ssSLepuqD
	 +ukmAcJZ/NQ35KN7L9D2+OMD6eSGH5eoeFhFj0poU6tMKGWLqKL0lM06/84GK6kmXbgGE
	 XS9ZHLKGmdjRJIQPzJBAFB6B9VLAVmrgeuNP0j2vyBUEZmGjkGPcaDz39rSI624VSHxNZ
	 PMgFNN3k2wyHjC/8fk0pAnuwD2ug5IMzJN/WGcrgkIUeh9790vIMsk6dKXOj3cWZOKoKx
	 5w+Hw5WB/Cblf9IgVzqeG+AfwJT2wOcibALrCBFL322zpKPNqlGAXVEVXaqJrEdri1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CqSoXnRP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2E3606A324;
	Mon,  2 Nov 2026 20:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CqSoXnRP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AF31F00A16;
	Mon,  2 Nov 2026 20:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793650112;
	bh=wPiOj6Ramt3ftxK4C2lZHrvYb9x8b9IA7sKO2384dFo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CqSoXnRPMJgqKQRTji8LJguf4Gk6viJOwdIrrHd+MQeVI6kprG5MOa51HeAcOyYV9
	 9yrH/vUxcG1gEXwjtmctK2AwBziwDlCLFFOFRxfGmQwK2EtZrue9/A26gntIW1Nljy
	 k1xFshYZs3Qui0n+qLNO4BukrWh9+/4BE8fFfqFqAa3uLQvhvNeaVNVDEVdOFHLN2j
	 GZ0NekRLWHAYAEx5lwyhNKUS99IE/9+XqZeXxcFjG7kI9R8Pobb1gqMySz8sj+i5gm
	 4NdvMB8bb4yF4cdkJI8KlMaAzjj082g0qJ5UqUP5fV6F4hAW4LCofZpc4rdIlh59q7
	 RtqC3e2lysM+Q==
Message-ID: <sashiko-outbox-194065@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/16] KVM: arm64: gic-v5: Add ITS device skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261102194454.4086911-6-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
 <20261102194454.4086911-6-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 20:08:31 +0000
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
- [Medium] KVM: arm64: gic-v5: unrestored base address in vgic_v5_register_=
its_iodev()
- [Low] KVM: arm64: gic-v5: missing tools UAPI header sync for GICv5 ITS de=
finitions
- [Low] KVM: arm64: gic-v5: dead code in vgic_v5_register_its_iodev()
- [Low] KVM: arm64: gic-v5: stale GICv3 ITS description in commit message
--

commit bdded985e667a6d1396b4ac9faceeadebc56557f
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: gic-v5: Add ITS device skeleton

This commit introduces the initial KVM device plumbing for a GICv5 ITS,
including the UAPI device type and address attribute, struct vgic_v5_its
state, and a RAZ/WI MMIO region placeholder registered when userspace sets
the ITS base address.

>     KVM: arm64: gic-v5: Add ITS device skeleton
>    =20
>     Introduce the basic KVM device plumbing for a GICv5 ITS. This adds the
>     GICv5 ITS device type and address attribute, registers the device ops,
>     and wires a GICv5 ITS IODEV into the generic VGIC MMIO dispatch path.
>    =20
>     Add struct vgic_v5_its to hold the ITS base address, the IODEV plumbi=
ng,
>     the backing KVM device pointer, and the general ITS mutex. Allocate t=
his
>     state from the KVM device create path, initialise the mutex and base
>     address, and mark the VM as having an ITS. GICv5 MSIs require a Devic=
eID,
>     so set msis_require_devid when the ITS is created.
>    =20
>     Record the VGIC model required by an ITS and reject mismatched device
>     creation in either order. Check GICv3 ITS creation as well, so the two
>     ITS models cannot be combined in one VM.
>    =20
>     The MMIO region is registered once userspace provides the ITS base
>     address through KVM_VGIC_V5_ADDR_TYPE_ITS. For now the IODEV only
>     provides a RAZ/WI placeholder region; the actual ITS register emulati=
on
>     is added separately.
>    =20
>     Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>

[Severity: Low]
This isn't a bug, but is the third paragraph of the commit message stale?
struct vgic_dist::its_model, the check in kvm_vgic_create(), and the GICv3
ITS creation check in vgic_its_create() were already introduced in commit
05620a314219 ("KVM: arm64: vgic: Require matching VGIC and ITS models"),
whereas this commit only checks and sets its_model in vgic_v5_its_create().

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 65ee09bd14636..8c701173a2d88 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -99,8 +99,10 @@ struct kvm_regs {
> =20
>  /* Supported VGICv5 address types  */
>  #define KVM_VGIC_V5_ADDR_TYPE_IRS	6
> +#define KVM_VGIC_V5_ADDR_TYPE_ITS	7
> =20
>  #define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
> +#define KVM_VGIC_V5_ITS_SIZE		(2 * SZ_64K)
> =20
>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */

[Severity: Low]
Should tools/arch/arm64/include/uapi/asm/kvm.h also be updated with
KVM_VGIC_V5_ADDR_TYPE_ITS and KVM_VGIC_V5_ITS_SIZE so that
tools/perf/check-headers.sh does not report an out-of-sync header warning
during tools builds?

[ ... ]

> diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic=
-its-v5.c
> new file mode 100644
> index 0000000000000..5790b029f09b6
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
> @@ -0,0 +1,186 @@

[ ... ]

> +static int vgic_v5_register_its_iodev(struct kvm *kvm, struct vgic_v5_it=
s *its,
> +				      u64 addr)
> +{
> +	struct vgic_io_device *iodev =3D &its->iodev;
> +	int ret;
> +
> +	mutex_lock(&kvm->slots_lock);
> +	if (!IS_VGIC_ADDR_UNDEF(its->vgic_v5_its_base)) {
> +		ret =3D -EBUSY;
> +		goto out;
> +	}
> +
> +	if (!IS_ALIGNED(addr, SZ_64K)) {
> +		kvm_err("ITS Base address is not aligned to 64k\n");
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	its->vgic_v5_its_base =3D addr;
> +	iodev->base_addr =3D addr;
> +	iodev->regions =3D vgic_v5_its_registers;
> +	iodev->nr_regions =3D ARRAY_SIZE(vgic_v5_its_registers);
> +	iodev->iodev_type =3D IODEV_GICV5_ITS;
> +	iodev->redist_vcpu =3D NULL;
> +	iodev->v5its =3D its;

[Severity: Low]
This isn't a bug, but since vgic_v5_its_set_attr() is the only caller of
vgic_v5_register_its_iodev() and already checks SZ_64K alignment in
vgic_check_iorange(), is the !IS_ALIGNED(addr, SZ_64K) check here needed?

Also, redist_vcpu and v5its are members of the same anonymous union in
struct vgic_io_device, so setting iodev->redist_vcpu =3D NULL is immediately
overwritten by iodev->v5its =3D its.

> +	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
> +
> +	ret =3D kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
> +				      KVM_VGIC_V5_ITS_SIZE, &iodev->dev);
> +out:
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	return ret;
> +}

[Severity: Medium]
If kvm_io_bus_register_dev() fails in vgic_v5_register_its_iodev() (for
example with -ENOMEM or -ENOSPC), should its->vgic_v5_its_base be reset to
VGIC_ADDR_UNDEF before returning?

Leaving its->vgic_v5_its_base set to addr on failure causes
vgic_v5_its_get_attr() to report the address as configured even though the
MMIO device was never registered on KVM_MMIO_BUS, and causes any subsequent
retry of KVM_SET_DEVICE_ATTR via vgic_v5_its_set_attr() to fail with
-EEXIST in vgic_check_iorange().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102194454.4086=
911-1-sascha.bischoff@arm.com?part=3D5
