Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B4B31AAAA;
	Fri,  7 Aug 2026 14:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112882; cv=none; b=WUt90KFBaU8NHXtepdFGGhe7R6vTMaMrwyATfRbRo7MqUCVxYMHn/YRcouXhqL4t9314E3IUnAENYKgeFD4u9PBGomVQ5DZoMVLupXQj5iiOShzVGS4WoIMaXj2BFE3RVDJoLVBrpWBBuEXCKdgw/rANRo8OrpJVsB02yIRZ9dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112882; c=relaxed/simple;
	bh=Y/E06mQWHNqej8p5Xhll6yfCTgTEXBDIYKIoaX0qAek=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N1ZWyV9lrkgL3gwHqOa6pRt3DdUnpQE9rvgJeQqeqHfgvfVxlUVYBXnpqOz7OLAbkCjkw7aV0vAnsMax7pLn760hHGdhFbzyoa3GSuK39uOaYs1aff9u+S3u6OeIyRgiR2Lrx1+h1YjzF/taXomrDOa0TRYHHxTbaa7kRNA9njk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwuIEP66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwuIEP66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784E41F00A3A;
	Fri,  7 Aug 2026 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786112877;
	bh=Wo4musqEJ3jQvmDVDlxL6FaZ9AEmGBGEH1cTXeUicoc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VwuIEP66/1hx35wyRtNxiWwnKlpiG5Kq9prPhHsCTQlCBvxjNPHFL40z4BNU1X3sP
	 Dwmn+UhWFucWbzkD4ZwkebFhb/wCd2sB/vVGijKQHXp9Xe2+B6ucH8lLr4v+WJDQza
	 mjSf0qbO4xsBewDlzrIe35X2tTSWUC5dkXfNGe2v8vwnzOX9DH01jHLBHybLOSpjJU
	 2H2YGT118HDMmVIqFcWPyxoq4YQTef+EsZ1A2WN/uHQpangB9Z1kCFSCBqI6y1Z8CE
	 fhoLAiSmQn2alQQuCZRLbPNjm5A3fzmfpQUVLlOAUJsVBfdkZY2/En9HLBaM5NYB/N
	 JFO5rDf1bsBdg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 19/49] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-20-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-20-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 14:27:57 +0000
Message-Id: <20260807142757.784E41F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The patch defines the UAPI constant KVM_VGIC_V5_ADDR_TYPE_IRS for =
userspace to specify the IRS location, but provides no corresponding kernel=
 implementation to handle it.
- [Low] The newly added UAPI macro KVM_VGIC_V5_IRS_SIZE uses the kernel-int=
ernal macro SZ_64K, which is not exported to userspace and will cause compi=
lation errors.
--

--- Patch [19]: [PATCH v5 19/49] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_T=
YPE_IRS to UAPI ---
commit 2deebb3b97ce3e2f88f0cdf0452104edbd0a7ea6
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI

This patch adds the UAPI definitions for the GICv5 IRS address type and siz=
e=20
to the arm64 KVM headers. It reserves 2x64kB in the GPA space for the IRS=20
CONFIG_FRAME and SETLPI_FRAME.

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 1c13bfa2d38aa..d1b2ca317f586 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
[ ... ]
> @@ -97,6 +97,11 @@ struct kvm_regs {
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
>  #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
> =20
> +/* Supported VGICv5 address types  */
> +#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
> +

[Severity: High]
Does this patch provide the kernel implementation to handle
KVM_VGIC_V5_ADDR_TYPE_IRS?

If userspace attempts to use this UAPI definition with the
KVM_DEV_ARM_VGIC_GRP_ADDR attribute group, vgic_v5_set_attr() explicitly
returns -ENXIO for that group:

arch/arm64/kvm/vgic/vgic-kvm-device.c:vgic_v5_set_attr() {
	switch (attr->group) {
	case KVM_DEV_ARM_VGIC_GRP_ADDR:
	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
		return -ENXIO;
...
}

Similarly, kvm_vgic_addr() lacks a case for KVM_VGIC_V5_ADDR_TYPE_IRS and
would reject it with -ENODEV:

arch/arm64/kvm/vgic/vgic-kvm-device.c:kvm_vgic_addr() {
...
	default:
		r =3D -ENODEV;
	}
...
}

Without handling in the kernel, userspace cannot configure the base address
of the GICv5 IRS, which renders the GICv5 IRS emulation feature unusable.

> +#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
> +

[Severity: Low]
Does this newly added UAPI definition rely on the kernel-internal macro
SZ_64K?

Since <linux/sizes.h> is not exported to userspace, userspace programs
attempting to use KVM_VGIC_V5_IRS_SIZE will fail to compile with an
undeclared identifier error for SZ_64K.

While this pattern already exists in the file for GICv3 sizes, introducing a
new instance perpetuates the UAPI breakage.

>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
> diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/i=
nclude/uapi/asm/kvm.h
> index 1c13bfa2d38aa..d1b2ca317f586 100644
> --- a/tools/arch/arm64/include/uapi/asm/kvm.h
> +++ b/tools/arch/arm64/include/uapi/asm/kvm.h
[ ... ]
> @@ -97,6 +97,11 @@ struct kvm_regs {
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
>  #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
> =20
> +/* Supported VGICv5 address types  */
> +#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
> +
> +#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
> +

[Severity: Low]
Are the same SZ_64K and missing implementation issues applicable to this
mirrored tools UAPI header?

>  #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D19
