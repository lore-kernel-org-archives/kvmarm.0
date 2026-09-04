Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63184493637;
	Fri,  4 Sep 2026 13:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528315; cv=none; b=lljDiwCqmju/6SsS94bwrUwqXx/d0AxvEBt34ErTdS7upHevS8es2CZcH3YVtTbxmEZWyPhmn6Zb6vW56+eWEJELKjRXEnYXxq3Dd6DnVtE4/alH+jy+0ZfJDUayMEm3JtSsnW06rvy7RfwjXFqV3g4t0SBSiiZLVByJECk2zps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528315; c=relaxed/simple;
	bh=+x0ZADvFDyX6bEK7tqHxXeYBregC92koTtjI+WtQxm8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ChHcmhJjQag9plAn/i9UBAdnEEWAbqI8mBYWBvLpY1zSufUQ25/KgNdtUrG2vs4znz1Oizjlv3H8hy1J86AJM6Hv3CF3KgnNEWBu/kIkZdDk+e1YgETEbG6CIZvFV9hwB4e0YAOyTULtK9kF30usn4dAcYNAjX0kdqAEuEHq3xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZ8Yq9df; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZ8Yq9df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D111F00A3D;
	Fri,  4 Sep 2026 13:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788528310;
	bh=4GGptH93lF25+JKTnAxykwT95pAsEY7BIIhCj6MkqFw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EZ8Yq9dfQLLR1dUhikShlk1/vpO9oKumhE9KtKbRAtStRsRdG3qBLRf/6VOAb8DZA
	 kwyUvsZUfCebyNZgJL3mY5Bd4Cyu9D2Iknvwqpmw6zfJU4T/piGCUeHM7A4WSZvcQE
	 QutIxjg9b2owEKRBMo0AF7LwfM4gTlQRsOfvY/Fj4QvcQ/7c1rXKPuQ4XfpvsnZ9t5
	 57R+woVyELN/tLli0Niki30GLgUndAbwJctZq9E2CD5OmpXuXjapeI2rpQGySX3mYZ
	 UqvZKm+Xlzl1Up1P8iWJW1tAb50U1TqY81reUCrwn9m6GqXN0Ti3Y1zPWOApHtClxM
	 dV25kGHA54OgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 28/49] Documentation: KVM: Extend VGICv5 device
 attribute docs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260904113404.4051341-29-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-29-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:25:09 +0000
Message-Id: <20260904132510.16D111F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] The GICv5 IRS address is now mandatory and SPIs are enabled by=
 default, breaking existing userspace that creates PPI-only VGICv5 instance=
s.
- [Critical] KVM_DEV_ARM_VGIC_GRP_NR_IRQS is redefined for VGICv5 to mean o=
nly the number of SPIs, breaking generic VMM logic.
--

commit 09cdbd6c9f58457f6d769b06163f573cb425aea3
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

Documentation: KVM: Extend VGICv5 device attribute docs

This commit updates the VGICv5 documentation to cover PPI, SPI, and LPI
interrupts, detailing how their pending state is injected. It also documents
the mandatory GICv5 IRS address attribute and its GPA layout requirements.
Finally, it explains the GICv5-specific interpretation of
KVM_DEV_ARM_VGIC_GRP_NR_IRQS, which only counts SPIs instead of the total
number of interrupts.

> diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentati=
on/virt/kvm/devices/arm-vgic-v5.rst
> index 70b9162755c7e..c782ea4d4609c 100644
> --- a/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> +++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
> @@ -12,12 +12,39 @@ Only one VGIC instance may be instantiated through th=
is API.  The created VGIC

[ ... ]

> +      Setting the address of the IRS in GPA space is mandatory before VG=
IC
> +      resources are mapped, as the IRS is responsible for handling SPIs =
and
> +      LPIs. Failure to set the IRS address before the first vCPU run res=
ults in
> +      an error.

[Severity: Critical]
Does making the IRS address mandatory introduce a regression for existing
userspace that creates PPI-only VGICv5 instances?

If a VMM creates a VGICv5 without setting KVM_VGIC_V5_ADDR_TYPE_IRS, it loo=
ks
like it will now fail to boot:

arch/arm64/kvm/vgic/vgic-init.c:kvm_vgic_map_resources() {
	...
	if (IS_VGIC_ADDR_UNDEF(irs_base)) {
		ret =3D -ENXIO;
		goto out_slots;
	}
	...
}

It appears it also rejects configuring 0 SPIs, which forces the mandatory
use of the IRS:

arch/arm64/kvm/vgic/vgic-kvm-device.c:vgic_set_common_attr() {
	...
	if (val < VGIC_V5_DEFAULT_NR_SPIS ||
	...
}

Could this cause an ABI regression for legacy VMs that only use PPIs?

> +
> +  KVM_DEV_ARM_VGIC_GRP_NR_IRQS
> +   Attributes:
> +
> +    A value describing the number of SPIs for this GIC instance. This is
> +    GICv5-specific: unlike GICv2/v3, the value does not include SGIs or =
PPIs.
> +    The value ranges from 32 to KVM's VGICv5 maximum of 1024 SPIs, in
> +    increments of 32. If userspace does not set this attribute, KVM uses=
 32
> +    SPIs by default.

[Severity: Critical]
Does redefining KVM_DEV_ARM_VGIC_GRP_NR_IRQS to only represent the number of
SPIs introduce a regression for generic VMM logic?

For GICv2/v3, this attribute represents the total number of interrupts
(32 + SPIs). However, for VGICv5, it seems the requested value is assigned
directly to nr_spis without subtracting VGIC_NR_PRIVATE_IRQS:

arch/arm64/kvm/vgic/vgic-kvm-device.c:vgic_set_common_attr() {
	...
	dev->kvm->arch.vgic.nr_spis =3D val;
	...
}

If a generic VMM passes 32 + N (expecting N SPIs), won't it inadvertently
allocate 32 additional SPIs? Could this inconsistency in the UAPI cause an
ABI regression?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D28
