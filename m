Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB965CFA33;
	Mon, 19 Oct 2026 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418483; cv=none; b=bnrtv7bp/hsNQWKXqbkGKz0juz5FJbVKnUzOU41seco5Z4dk1AlXV+FLzaf2U9rvo/Q7Mlgv0p10bNqQZH3fyTMhCZYYVdfnoqqLAGz4ALceX81GB8ct1b/yPgK2JBZfSe0SliX0D/4R39/k+Z9sCuhMuYWF6sPtlJUbG7s5toY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418483; c=relaxed/simple;
	bh=QN1JVvvcU8tCJIUBuHRPCvDcAoldkEB3YpGvN0zpHLc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oh/9B0qYDe1JpnxvpgO5w0fckDAZLCa+62zBjrA0SGfBQRzSleTpkyHfsRYEFxY712Yo9iGr7SAMPBVfhR69ijGTPAzcpcDzAAEq9mTG6Ff8XgmgaTvdt2qBWV+OayNHENJ2AvtWTTSMOJrCveRhrQbXdBvu5UomxP0wQ5YUcT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asW3LIOC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asW3LIOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2137F1F000C8;
	Mon, 19 Oct 2026 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418481;
	bh=vOzMu9yXDXjpNHsxshh5zV/Cvva5ZmdoG5eGo37cSQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=asW3LIOC5kxu1ONl9gDGJsqDbV3phdOB3QBWQw+miqk1Lm+mG6lbLDqivJ4F0Sv8C
	 hhpH/jI0ypdJv5xjM45JQAC3R2pvFCplcGlOwo2u88OCVJ8EBeTu9OMKNRfjkskUN5
	 /tcaiQPmN6AMx9vXjcUlb8pKnBkn10Z+KRKfLMOmfO/BHDsfZUp5GnGAi8UEZbCVMJ
	 aDZF8ogKe/0qZUiNT3QZ72sOTJ4IsQAnrH/WG0atrAuYZVBfQrx0JUuCSIxzXE/uJd
	 uPavnxc8yD637x+pV9LkOrX/984DwexMYNSF5uXEq3zbwU+W2yEC1z5HnDfuWHSM7C
	 Fl3oERhbWJwjg==
Message-ID: <sashiko-outbox-177254@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: vgic: Require matching VGIC model
 for GICv3 ITS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261019134242.1289002-2-sascha.bischoff@arm.com>
References: <20261019134242.1289002-1-sascha.bischoff@arm.com>
 <20261019134242.1289002-2-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:01:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: arm64: vgic: vgic_has_its() returns true without an in-kern=
el VGIC
--

commit 06339a92609918e3caedb4339d3324ff581b8fee
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: vgic: Require matching VGIC model for GICv3 ITS

This commit records the VGIC model required by an ITS device in
struct vgic_dist and checks model compatibility during both VGIC and ITS
creation so that incompatible devices are rejected regardless of creation
order. It also replaces dist->has_its with a check on dist->its_model in
vgic_has_its() and changes dist->vgic_model to enum kvm_device_type.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index e5657cb603567..7df5869cff990 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -1875,6 +1875,19 @@ static int vgic_its_create(struct kvm_device *dev,=
 u32 type)
> =20
>  	mutex_lock(&dev->kvm->arch.config_lock);
> =20
> +	/*
> +	 * Reject creation of a GICv3 ITS if:
> +	 * - The VM already has a VGIC other than GICv3.
> +	 * - An existing ITS requires a VGIC model other than GICv3.
> +	 */
> +	if ((irqchip_in_kernel(dev->kvm) && !vgic_is_v3(dev->kvm)) ||
> +	    (dev->kvm->arch.vgic.its_model &&
> +	     dev->kvm->arch.vgic.its_model !=3D KVM_DEV_TYPE_ARM_VGIC_V3)) {
> +		mutex_unlock(&dev->kvm->arch.config_lock);
> +		kfree(its);
> +		return -ENODEV;
> +	}
> +
>  	if (vgic_initialized(dev->kvm)) {
>  		ret =3D vgic_v4_init(dev->kvm);
>  		if (ret < 0) {
> @@ -1902,7 +1915,7 @@ static int vgic_its_create(struct kvm_device *dev, =
u32 type)
>  	xa_init(&its->translation_cache);
> =20
>  	dev->kvm->arch.vgic.msis_require_devid =3D true;
> -	dev->kvm->arch.vgic.has_its =3D true;
> +	dev->kvm->arch.vgic.its_model =3D KVM_DEV_TYPE_ARM_VGIC_V3;
>  	its->enabled =3D false;
>  	its->dev =3D dev;
> =20
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index 5ab789accc9d4..5f0a5b12e338f 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -42,10 +42,7 @@ bool vgic_has_its(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist =3D &kvm->arch.vgic;
> =20
> -	if (dist->vgic_model !=3D KVM_DEV_TYPE_ARM_VGIC_V3)
> -		return false;
> -
> -	return dist->has_its;
> +	return !!dist->its_model;
>  }
> =20
>  bool vgic_supports_direct_msis(struct kvm *kvm)

[Severity: Medium]
Can vgic_has_its() now return true when a VM has created an ITS device
without creating an in-kernel VGIC (dist->vgic_model =3D=3D 0)?

Previously, vgic_has_its() returned false when dist->vgic_model was 0.
With this change, vgic_its_create() sets dist->its_model even when
!irqchip_in_kernel(dev->kvm), while skipping vgic_v4_init() because
vgic_initialized(dev->kvm) is false.

If userspace creates a KVM_DEV_TYPE_ARM_VGIC_ITS device and runs a vCPU
without creating an in-kernel VGIC (which kvm_vgic_map_resources() permits
when !irqchip_in_kernel(kvm)), vgic_supports_direct_msis() evaluates to
true on GICv4.0 hosts:

arch/arm64/kvm/vgic/vgic-mmio-v3.c:vgic_supports_direct_msis() {
	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
		return false;

	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
}

In the vCPU run loop, kvm_arch_vcpu_ioctl_run() calls
kvm_vgic_flush_hwstate() unconditionally:

arch/arm64/kvm/vgic/vgic.c:kvm_vgic_flush_hwstate() {
	if (vgic_supports_direct_irqs(vcpu->kvm) && kvm_vgic_global_state.has_gicv=
4)
		vgic_v4_commit(vcpu);

	if (!kvm_vgic_vcpu_pending_irq(vcpu))
		return;
}

Wouldn't this call vgic_v4_commit() -> its_commit_vpe() ->
irq_set_vcpu_affinity(0, &info) on an uninitialized its_vpe where
vpe->irq =3D=3D 0, as well as allowing MSI entry points such as kvm_set_msi=
(),
kvm_arch_set_irq_inatomic(), vgic_msi_to_its(), and
kvm_vgic_v4_set_forwarding() to proceed without an in-kernel VGIC?

Should vgic_has_its() still check irqchip_in_kernel(kvm) (or
dist->vgic_model =3D=3D dist->its_model)?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019134242.1289=
002-1-sascha.bischoff@arm.com?part=3D1
