Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D4E34E766;
	Fri,  7 Aug 2026 13:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786109458; cv=none; b=TzcmnKnnka+ruHTL23l98vJjCY+HdaZRcRNj+GjGxocWliTSYLW2gY0r3U+/xU2+lDp+IUU1B638XH2B4COYKGTqJRDWntrolZBR9dH25f38JigIpsatPCQXdThqQSMa3+5GMz00jpRO1a0pByiJeNN59eER7Q6xl5RvDqX2qL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786109458; c=relaxed/simple;
	bh=TXyta2+4BaAyfM8RWGg3omSc2y8TLfbvfye/HSEKj1k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JBVh1nN0mI4yAJyAvPIEXdMzXsS51nAYSAOatGox83+nDo1R+VI7emPRGCfpkx7AiZhd95UtQmTEUGnihgDUtJ0ZBBX/DT66ipW28nRw1z0KWdIT2Ri21No1rJOrrAArxhLpWdFY+dDU0RRU6P9BWOd9KTo4qDo0RxywrZsQJN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNjUWx6b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNjUWx6b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D381F000E9;
	Fri,  7 Aug 2026 13:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786109451;
	bh=sAEBCx1gkKh+x5pzSOLdbjMt5YDw2Mdgaus8pqrXb7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nNjUWx6b/MlnHb2khGc1bbw49Ck8q9DcKznSAEX+McA5UuwjtkC+woMKfIJF3bljl
	 5Rb7A+oaGd28cUf05HWwd7k/49Hrh30ytuDD56gzrCrkEfv+lgHSbLn0Q7BeV2AFNp
	 fvvYWZzzxnwBrNoI9sqsPAZOn+HEue40Yf+8Fn1UIVl3DKIGuAV4ZMK241igMhFJp7
	 r/AqakK2+Wh5U6ylWSaS7WxvDZG/Fa10+QDhy2L0/ZF5JQVYNVA443IWujx/U7UwoK
	 YYw0fhrI7bMBXCQxYUW91qwBoONHKIG8uVUTwz/tc6kcezAsbdElsM0dVs2Xv9kd0t
	 hFWU09NCpkT5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/49] KVM: arm64: gic-v5: Keep GICv5 vCPU limit
 model-specific
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260807111159.429128-13-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-13-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 13:30:49 +0000
Message-Id: <20260807133051.15D381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] kvm_vgic_create() fails to validate that previously created VCPUs =
have IDs within the newly selected VGIC model's limits (for GICv2 and GICv3=
), leading to undefined behavior in GICv2 SGI routing.
--

--- Patch [12]: [PATCH v5 12/49] KVM: arm64: gic-v5: Keep GICv5 vCPU limit =
model-specific ---
commit 42bacf6540695fc12a35eee006d5382303176971
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Keep GICv5 vCPU limit model-specific

This patch separates the IRS-derived vCPU limit for GICv5 from the generic
KVM maximum limit. It adds validation to reject GICv5 device creation if
existing VCPU IDs exceed the GICv5 model-specific limit.

> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-i=
nit.c
> index 079a57c2b18f6..8e1e844ed6e93 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c

[ ... ]

> @@ -129,13 +129,34 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  	}
>  	ret =3D 0;
> =20
> -	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2)
> +	switch (type) {
> +	case KVM_DEV_TYPE_ARM_VGIC_V2:
>  		kvm->max_vcpus =3D VGIC_V2_MAX_CPUS;
> -	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
> +		break;
> +	case KVM_DEV_TYPE_ARM_VGIC_V3:
>  		kvm->max_vcpus =3D VGIC_V3_MAX_CPUS;
> -	else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
> -		kvm->max_vcpus =3D min(VGIC_V5_MAX_CPUS,
> -				     kvm_vgic_global_state.max_gic_vcpus);
> +		break;
> +	case KVM_DEV_TYPE_ARM_VGIC_V5:
> +		kvm->max_vcpus =3D kvm_vgic_global_state.max_gicv5_vcpus;
> +
> +		/*
> +		 * We use the userspace-allocated vcpu_id as the index into the
> +		 * GICv5 VPE table. This ensures that userspace's view and the
> +		 * guest's view of IAFFIDs remains consistent - GICv5's virtual
> +		 * IAFFID is the VPE ID in that VM's VPET.
> +		 *
> +		 * Reject vGICv5 creation if we have already got any vCPUs that
> +		 * we cannot back with a GICv5 VPE in the VPET.
> +		 */
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			if (vcpu->vcpu_id >=3D kvm->max_vcpus) {
> +				ret =3D -E2BIG;
> +				goto out_unlock;
> +			}
> +		}
> +
> +		break;
> +	}

[Severity: High]
This is a pre-existing issue, but does restricting this validation loop to=
=20
only GICv5 leave the older models vulnerable to an out-of-bounds vcpu_id?

If userspace creates a VCPU with a large ID (for example, 500) before creat=
ing=20
the VGIC device, it succeeds because the pre-VGIC limit defaults to the=20
maximum supported by the system. If userspace then selects a GICv2 device,=
=20
kvm_vgic_create() drops max_vcpus to 8.=20

Because the vcpu_id check above is inside the GICv5 switch block, we skip=20
validating the existing VCPUs against the new GICv2 limit.

When configuring private IRQs later during initialization,=20
vgic_setup_private_irq() does this:

arch/arm64/kvm/vgic/vgic-init.c:vgic_setup_private_irq() {
    ...
    irq->targets =3D BIT(vcpu->vcpu_id);
    ...
}

Evaluating BIT(500) shifts a 64-bit integer by 500, which results in undefi=
ned
behavior in the kernel. A similar shift happens for SGI routing in=20
vgic_mmio_write_sgir().

Should this validation loop be moved outside the switch statement so it run=
s=20
for all VGIC models and prevents these out-of-bounds shifts across the boar=
d?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D12
