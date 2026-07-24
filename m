Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96873412C05;
	Fri, 24 Jul 2026 11:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784893616; cv=none; b=aZ49xj0Cy9HXHoE27GNMcpza4Z992cBKm8qVjPuYouWIiG3NxYC5NRBRlHrAv7ayvDu6wJq2aP79MQyIel3S06Qz4FFpGQX01dkcd5DVfBOXRZfpUHbXx7JoywrSnb56wypo+Qw0iHFt1dmBCX4pzMFunQqiVMkaw+u7J4Gc5ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784893616; c=relaxed/simple;
	bh=uq4tCcALc53FGVLUTPidhd09Ltu/FdNEjiaVM/wfT9A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OpL52EtdohERBL+PF5vcTF+MBu5tDbQQ7pvY0oSctQZS7yD7d6fMkbGWs8Esa9Ex/K7QYVkiogImlOePSzUYExuVg3o3tRYXsVUaS8ibdR1G5NYRliUzZSKXH3956NbABJK7tMXjzU7YAXXKKxKMUhthna5J8ryGMcKMBqgSgyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0p5k8lY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0p5k8lY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4381F000E9;
	Fri, 24 Jul 2026 11:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784893611;
	bh=kFjvQcSLpvwyRLjH1Kcg17wpjVDpP8jQCW5hcnhFA6Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j0p5k8lYLu97zDco++57RFcp/RZSEZaP/nEl812hekeBT/3W29KhL5XRCbJJB9W0E
	 e/sQ4Xm5Ks5JO1aIf0NTcpaKLpQhTnH3L9S93NQeSkcpWTb2iyGfGDm5psot86nxZQ
	 rjuguChgVbW8WsBZ2dztn4wVGphKFgQnMrG1QGQ15SNiOtyj4Jsz58y0uyiu3/I9jx
	 uDcAMqcwt5z0B9W1k8SuuBlOtMLi2198IGPCfbi1GeaVhbyd9XW4CP2YJ+BP8mnY/R
	 TgUtv5tjfAcUBrPyZmG9UeyeVBEs3zolF3aN932sK0CuV7p0yUDEThX/DE2L6FjJ3H
	 zBrsqumMo3U4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 34/48] KVM: arm64: gic-v5: Add VGICv5 IST
 save/restore UAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260724104819.1296803-35-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-35-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:46:50 +0000
Message-Id: <20260724114650.CF4381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] The KVM implementation for the newly added VGICv5 IST attribute =
group is entirely missing.
- [Low] The ARM-specific `struct kvm_vgic_v5_ist` is added to the cross-arc=
hitecture `include/uapi/linux/kvm.h` instead of the architecture-specific `=
arch/arm64/include/uapi/asm/kvm.h`, polluting the global UAPI namespace and=
 causing a tools header desync.
- [Low] The new `KVM_DEV_ARM_VGIC_GRP_IST` device attribute group and its d=
escriptor structure are completely undocumented.
--

--- Patch [34]: [PATCH v4 34/48] KVM: arm64: gic-v5: Add VGICv5 IST save/re=
store UAPI ---
commit 18a475f214feec673055a712a5b6d844aa9edb1a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
   =20
Add the VGICv5 IST device attribute group used by userspace to save
and restore the IRS Interrupt State Tables. It introduces the
kvm_vgic_v5_ist descriptor structure for SPI and LPI IST buffers.

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 710a0d267347d..1b9bbeab18a4e 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -423,6 +423,7 @@ enum {
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
>  #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
>  #define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
> +#define KVM_DEV_ARM_VGIC_GRP_IST	11

[Severity: Medium]
The commit message states this attribute group is used by userspace to save
and restore the IRS Interrupt State Tables. Is the backend implementation f=
or
this new UAPI intentionally omitted from this patch?

Without the corresponding KVM VGIC device ops in the codebase to parse the
attribute, this UAPI currently appears unusable.

[Severity: Low]
Is there a missing documentation update for this new guest-visible feature?

Kernel guidelines typically expect new UAPI additions to be explicitly
documented. This patch omits updating the KVM device documentation to expla=
in
the usage semantics, expected alignment, and lifecycle constraints for the
VGICv5 IST attribute.

>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 419011097fa8e..df6356fb45b08 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1191,6 +1191,13 @@ struct kvm_device_attr {
>  	__u64	addr;		/* userspace address of attr data */
>  };
> =20
> +struct kvm_vgic_v5_ist {

[Severity: Low]
Should this ARM-specific structure be placed in the architecture-specific
header arch/arm64/include/uapi/asm/kvm.h instead of the global
cross-architecture include/uapi/linux/kvm.h?=20

Additionally, while the patch updates the tools copy of the arm64 UAPI
header, it appears to miss syncing the tools copy of the global header
(tools/include/uapi/linux/kvm.h). Does this omission lead to a tools header
desync warning?

> +	__u64	spi_ist_addr;
> +	__u64	spi_ist_size;
> +	__u64	lpi_ist_addr;
> +	__u64	lpi_ist_size;
> +};
> +
>  #define  KVM_DEV_VFIO_FILE			1

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D34
