Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58ED1E7C18;
	Fri, 16 Oct 2026 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792164921; cv=none; b=tZ0n66DXLfyj8BU8aV2H/oRZVuOnv9HgmBoLR62Y5k4IxBXKjBlLtKDygBtF3jyjStNBBRpf9JB0X2yTnoRDZzHsJDFqY++qeKWT2uYXuQx5v91nQxshLcFa9oPO+a7K5DmORU2ravvTc0GMGjyijlEVrKJLGkyhSNpu2WiPfs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792164921; c=relaxed/simple;
	bh=zXyT3AJYkCSB+ZLYhNrAcu/KJFOBSTYpMgOiZdh3MPg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UrDkCaXCKi5EI+u/A7RlCbYas4Q17arFizUOmSkN1pez41JYBLJ5sNkKm2rmeFVGkAUGq+Tsvs+oyqK3/jtrkKcZFL8a6FgkqfvpAY+zsnJL/VK22fQY1PYdGA9SXdUFolx6FsBJnpoDlNp+Svjni9xeFlL6zSqpqj2rVPQyAYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPUJ2n1X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPUJ2n1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB861F000C4;
	Fri, 16 Oct 2026 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792164920;
	bh=snipG64uLjyBMSd8KHgV/DsoAJFRQzWXPdGo2+o645o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GPUJ2n1XTJX6JQ7ZDHRs6ujOQp2eJ58Pj+hB9AANGlES9N71bNAcyPI1PK7Xad/Ci
	 2yZkuakiUIJM8l7TV3ZSq2CaBtpcMhQb60vBxQG9qotI/sJRd99es7XwC6HrQ43BWs
	 HZVAqiCZWfljCSeWXcHTdNf+7JxMftMO83do2y+z1LQLUPQdf6Bkr0Fru5G7ZXhyQG
	 JYMFlQzTVYtsSnYmdQ8WDfUnPnOs+XwUNQr2IYG4/WnJXFMPYw5Dk14qg2/hfTLnAp
	 yhBavGlgfL3GlZeHUcPFrCQXw3y+HurmXmMwdRm8Y96GlwAa5p1wervFmU5nqCS19w
	 RHqP5v9tShM2w==
Message-ID: <sashiko-outbox-174566@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: Require matching VGIC model for
 GICv3 ITS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <sascha.bischoff@arm.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261016152225.898761-2-sascha.bischoff@arm.com>
References: <20261016152225.898761-1-sascha.bischoff@arm.com>
 <20261016152225.898761-2-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 15:35:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] kvm: vgic: its_model state leak on ITS creation failure prevents=
 VGIC fallback
--

commit 1db9490bd1d4f94f4d1c1d3aee70dca948f96eb7
Author: Sascha Bischoff <sascha.bischoff@arm.com>

KVM: arm64: vgic: Require matching VGIC model for GICv3 ITS

On a GICv5 host with legacy support, KVM registers both VGICv3 and
VGICv5 devices. A VM can create a GICv3 ITS with another VGIC model,
setting has_its even though that model cannot use the GICv3 ITS.

> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-it=
s.c
> index e5657cb603567..bf901626ea6df 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c

[ ... ]

> @@ -1903,6 +1911,7 @@ static int vgic_its_create(struct kvm_device *dev, =
u32 type)
> =20
>  	dev->kvm->arch.vgic.msis_require_devid =3D true;
>  	dev->kvm->arch.vgic.has_its =3D true;
> +	dev->kvm->arch.vgic.its_model =3D KVM_DEV_TYPE_ARM_VGIC_V3;
>  	its->enabled =3D false;
>  	its->dev =3D dev;

[Severity: Medium]
When vgic_its_create() successfully executes, it updates the VM-wide state
(its_model, has_its, msis_require_devid) to reflect the ITS device. If the
generic kvm_ioctl_create_device() subsequently fails at anon_inode_getfd()
due to process FD exhaustion, it aborts the device creation and calls the
vgic_its_destroy() cleanup callback.

However, vgic_its_destroy() does not roll back the its_model VM-wide proper=
ty:

arch/arm64/kvm/vgic/vgic-its.c:vgic_its_destroy() {
    ...
	vgic_its_free_device_list(kvm, its);
	vgic_its_free_collection_list(kvm, its);
	vgic_its_invalidate_cache(its);
	xa_destroy(&its->translation_cache);

	mutex_unlock(&its->its_lock);
	kfree(its);
	kfree(kvm_dev);
}

Consequently, the VM permanently records that it requires a GICv3 VGIC mode=
l.

Does this state inconsistency prevent userspace from recovering and falling
back to a different VGIC model (such as VGICv5) after an ephemeral FD
allocation error, or if userspace intentionally closes the ITS file descrip=
tor
before creating the VGIC?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016152225.8987=
61-1-sascha.bischoff@arm.com?part=3D1
