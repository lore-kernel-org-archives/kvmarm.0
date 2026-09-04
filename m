Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9073E3DB1;
	Fri,  4 Sep 2026 13:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527435; cv=none; b=ksdfMMLHmwqyq+AQ/nv71LuudYuqPaBwOeVQZiaaeTF3yKayjLfma3Xyt2rRReucAG4rujp0QV9nIXxMJiZbev8ld0OXL3lUAgRmHRnJzkN76ebs5oR93Od9EQsa2HNS+fK/pUlrY16sC4GmdCVp+bLhOt7WNEyngbEj+RQKSXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527435; c=relaxed/simple;
	bh=75LS+TRovCCu8zvP/Cp7jlHYolIsh5dwL4K8IPtUw0Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pOIuz484UPvQLXUI3yR+g1SR1YBtAwYxpLCZ0Vzx8EA4mbyyMD9Dhb3R01Cz416lMAUnow49tPsBWfs4JkmsvJaf6ikATjPikmalfbITSBVIrbJbuRtLYR7N/e52n6XcZsKHjOCNVVgShETI2PvfyceBcONkaqOYNsKl0a3acV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YW7+aO0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YW7+aO0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8832D1F00A3E;
	Fri,  4 Sep 2026 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788527433;
	bh=rRAmPYVehCEpJw4yQXulyrjK8qQpZasZaX7qAA3pJKA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YW7+aO0rFw06vtmcjO5jVZ8TkPDWY99Cx/2vhfmk/6k39GRQveS961bBVjt4mEBeD
	 2Sfhy6t7QMxWlkJV7EhsL00d6sDJH4iRwe7DFd2XYHRCBXigZmfrI5y29mKS99WsQJ
	 sf6dqAYPSb23jc0PdjvrvjQvR9SxIBwfyK6G85ky7NO6q5XNM9asc8BuPHJL7Fs0Ge
	 U4nUgQkBVn4oIIqGZNpn3V6KaC1eLR3WxAW99gICZ44EblrAcIKN/+EwVIWsbPF3xa
	 vjhWbbvjxXw9e7uF+4XPdVlr5Hi2Fu5euD7Qoi2RVIFAePUXa1zWbRrs100ZFarS0/
	 oW6JFYmMDOdTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 22/49] KVM: arm64: gic-v5: Register the IRS IODEV
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260904113404.4051341-23-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-23-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:10:33 +0000
Message-Id: <20260904131033.8832D1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Memory leak of the `dist->spis` array if GICv5 initialization is=
 retried after a failure.
--

commit 67a160bda61ea35d934ec550a4467b5c6ecad827
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Register the IRS IODEV

Now that we have an emulated IRS, it needs to be registered, which
ensures that guest accesses to the MMIO regions handled by the device
are handled appropriately in KVM. Therefore, as part of
vgic_map_resources, the GICv5 IRS IODEV is registered. If the address
for the IRS is not provided, bail out reporting an error - this is not
a supported config.

> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/=
vgic-kvm-device.c
> index 90be99443df3b..8c2c6886af4e3 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c

[ ... ]

> @@ -748,21 +778,25 @@ static int vgic_v5_set_attr(struct kvm_device *dev,
>  {
>  	switch (attr->group) {
>  	case KVM_DEV_ARM_VGIC_GRP_ADDR:
> +		break;
>  	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> -	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return -ENXIO;
> +	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
> +		break;
>  	case KVM_DEV_ARM_VGIC_GRP_CTRL:
>  		switch (attr->attr) {
>  		case KVM_DEV_ARM_VGIC_CTRL_INIT:
> -			return vgic_set_common_attr(dev, attr);
> +			break;

[Severity: Medium]
If userspace calls KVM_DEV_ARM_VGIC_CTRL_INIT and the routing setup fails in
vgic_init(), does this leave dist->spis leaking if userspace retries the
initialization?

When vgic_init() aborts due to a failure in
kvm_vgic_setup_default_irq_routing(), it calls vgic_v5_teardown():

arch/arm64/kvm/vgic/vgic-init.c:vgic_init() {
        ...
        if (vgic_is_v5(kvm))
                vgic_v5_teardown(kvm);

        return ret;
}

However, it appears vgic_v5_teardown() does not free the dist->spis array.

If userspace retries the init call, kvm_vgic_v5_irs_init() unconditionally
allocates a new array over the old one:

arch/arm64/kvm/vgic/vgic-irs-v5.c:kvm_vgic_v5_irs_init() {
        ...
        dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL=
_ACCOUNT);
        ...
}

Can this allow a misconfigured or malicious userspace to repeatedly leak
memory (up to ~200KB per call) by retrying the initialization after a failu=
re?

>  		case KVM_DEV_ARM_VGIC_USERSPACE_PPIS:
>  		default:
>  			return -ENXIO;
>  		}
> +		break;
>  	default:
>  		return -ENXIO;
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D22
