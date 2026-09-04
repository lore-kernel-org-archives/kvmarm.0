Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D842271450;
	Fri,  4 Sep 2026 13:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526825; cv=none; b=mJfn8CuX3zD8BH2V7LTBmyhTBobAqq4FBUGGorXRkF90My53uZvMWecG66zCwMFr6i861Z3HqlLbhx5WHF/efM/PQ+RjgtbePRGPHqkJUhCl2xXidhNgMxng4XZ0m92M8Hr75kG+khWrq3dbJN36gpVck/WVPo8KIOX9kemJ4jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526825; c=relaxed/simple;
	bh=qMPxDXl8XswbWoVyvM2qtuaeRgT+hpd0hbJtDkX/6M4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ojgbJDKMk51MC+05MMMTvca6ntxRqBhIoVbWn94WnbEBdZiaGwS3lH5S/RzmC3O0E/5DhWx4b3DxcrwUzAOEpLwS8UUnBl0PvKa9LHFxnJoyXGUSoxrdmtRR42ijF0PP95ZkI7Xg7fw3Mp2HF7ButQAemWMESmO1i60uONZ+5mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0bEgo9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0bEgo9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63291F00A3D;
	Fri,  4 Sep 2026 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788526824;
	bh=5/CS0wcncUNX4qbevwTJ+1tLbDjwJRipOJK4Z9N8oqo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e0bEgo9sMmvX9TUMfo0z5AlOyYhScb4e0+fiuqK0R45m4peZht52iU5J3PvF3VEdH
	 AuYHnzBRbRLerkIsyGVMZdpGNUD0YMV1UasvCm+S5kY18fNGx3MEH/u5WWWUZ+REU6
	 2feRrSKCF0zUdBaUVKxz/8P5AwnqEYry3U204Z8SRa9xsHE5SP0gS9REz3jPgRtuOU
	 JDr8dgT4mKTpui3Xk80aY8Gomebj8QwVdh5VdYby6GDo6BVrp4WewVZhgW1CO/QrOD
	 WisK6S/Fw1t4v0/+INzq/8vMnnW0txvRQ7glZ/f6UMmdV/H+SGskfTkT/Ce3uggxtU
	 K3+uipznHn62w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260904113404.4051341-22-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-22-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:00:23 +0000
Message-Id: <20260904130023.A63291F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Memory leak of the `dist->spis` array across retries of `vgic_in=
it()` on error paths.
--

commit 13674819963e3cb02a4360c21cc165dd2bbdc227
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Initialise per-VM IRS state

This commit allocates the per-VM emulated IRS state when creating a virtual
GICv5 and initializes it. It establishes the IRS backing required for SPIs
and LPIs during GICv5 initialization.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 5a058ef8fe701..bdf06dbff4231 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -747,6 +748,11 @@ int vgic_v5_init(struct kvm *kvm)
>  			goto err;
>  	}
> =20
> +	/* Init IRS (and alloc SPI IST) */
> +	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);

[Severity: Medium]
Does this leak the dist->spis array (up to ~106KB) if userspace retries
initialization?

When kvm_vgic_v5_irs_init() is called here, it unconditionally allocates
dist->spis without checking if it is already allocated:

arch/arm64/kvm/vgic/vgic-irs-v5.c:kvm_vgic_v5_irs_init() {
    ...
    dist->spis =3D kcalloc(nr_spis, sizeof(struct vgic_irq),
                         GFP_KERNEL_ACCOUNT);
    ...
}

If a downstream step in vgic_init() fails (such as=20
kvm_vgic_setup_default_irq_routing() returning an error), the error path
calls vgic_v5_teardown(), which deliberately does not free dist->spis.

If userspace retries the failed KVM_DEV_ARM_VGIC_CTRL_INIT ioctl, we will
hit kvm_vgic_v5_irs_init() again and overwrite the old dist->spis pointer,
leaking the previous allocation.

Should kvm_vgic_v5_irs_init() check if dist->spis is already allocated, or
should vgic_v5_teardown() free it on failure?

> +	if (ret)
> +		goto err;
> +
>  	return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D21
