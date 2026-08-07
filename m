Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFF539A807;
	Fri,  7 Aug 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114167; cv=none; b=InfeDCNIoz/fIwugpvG71tmlGTyCRDNbMUw7NRvu9M7xtIi0ZfiJFd4WQQ91kiIQAlCWTYyqaFmXj0SOMLY8vaXapsdYC2z2BOpAxx6MQ6zFC48qNi44NpViLGWbTo6SUbqrJ4k7BM0p+4a9rQLjTUpDKhtsdmKSvSZo/imbjTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114167; c=relaxed/simple;
	bh=Kmz+ktCCxkCI5IxUSqpyA1uK5AJgxFgksw0HDufx/Lk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Hbsfh/I2qZ0r0WAWoP1CuHohvocHeIhVa3oV+TKBgoGe2Q1fQq4z4XODilCHYA+bQzlj3asab3KAB5hNMkwUDmBY5VC4hSsrZnPw/RuR6ItMUqCsd4vcNzyUEXZ1mHGXaj6JhYEtQs+Snw1PEC8/jwrZTmG45ZwPqWpzUD0LLOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ljSGJDLU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ljSGJDLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A8B1F00A3D;
	Fri,  7 Aug 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786114164;
	bh=ljTWdI+qOoDB9RaA2hmAMESgajEj+Q5FzNE5/shRckU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ljSGJDLUslFmpjq6bRhm4NicxIGl1U62DEm0clClV6e6R3EUONU5M22z1cBtur3ZD
	 aysCV8osBdRoVrT3m50zljQ3E7bonhq1ufHlHBS4dPtlaW4dEqixOU0KHX/tL1GWVK
	 Z2uiQD2QFiRM3nq+nHkareRlMj8as5FnIZmKG1+bfsIc+HCdPte4pbvIBHxRX4PNK7
	 yRd9B+hUHTlswho1jpiXC0KMkioi/YKF/qAx8O+Mk3fGQHRErPzpNTnGDlgReZ2LOn
	 n5Cy764thTEx/KQnvaDYP/UtwqO/fWWbl3kI/f1B9t5aDemwVQ7HEjannu95YmXbNN
	 rScBR0KAxr9cQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260807111159.429128-22-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-22-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 14:49:23 +0000
Message-Id: <20260807144924.42A8B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Unprivileged userspace can flood the kernel log (dmesg) by repea=
tedly triggering a `pr_warn` in `kvm_vgic_v5_irs_init()`.
--

--- Patch [21]: [PATCH v5 21/49] KVM: arm64: gic-v5: Initialise per-VM IRS =
state ---
commit 1471593eea3e98c7d1747cf0894424955cddde44
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Initialise per-VM IRS state

A virtual GICv5 needs an emulated IRS in addition to the host IRS
state used to back VMTEs, VPEs, and ISTs. This patch allocates the
per-VM emulated IRS state when creating a virtual GICv5, and initialises
it from vgic_v5_init(). It also handles the teardown and cleanup of the
IRS state during VGIC destruction.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 2932f3cfbe8f4..6a7dabf90dd1b 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -751,6 +752,11 @@ int vgic_v5_init(struct kvm *kvm)
>  			goto err;
>  	}
> =20
> +	/* Init IRS (and alloc SPI IST) */
> +	ret =3D kvm_vgic_v5_irs_init(kvm, kvm->arch.vgic.nr_spis);

[Severity: Medium]
Does this new call path allow userspace to flood the kernel log?

When userspace initializes a GICv5 via ioctl, this path calls
kvm_vgic_v5_irs_init(). If the host IRS hardware supports fewer than 16 ID
bits for ISTs, kvm_vgic_v5_irs_init() emits an unconditional warning:

arch/arm64/kvm/vgic/vgic-irs-v5.c:kvm_vgic_v5_irs_init() {
    ...
    if (vgic_v5_irs_ist_id_bits(&irs_caps) < 16)
        pr_warn("Host IRS supports fewer than 16 ID bits for ISTs (%u)\n",
                vgic_v5_irs_ist_id_bits(&irs_caps));
    ...
}

Since an unprivileged user can repeatedly create and destroy a VM in a tight
loop, can this be used to spam dmesg and degrade system performance? Should
this warning be converted to pr_warn_once() or be rate-limited?

> +	if (ret)
> +		goto err;
> +
>  	return 0;
> =20
>  err:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D21
