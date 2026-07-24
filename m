Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE11427F89;
	Fri, 24 Jul 2026 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892649; cv=none; b=H2NNCBTSOf0V9NmCGe2D8o8vxV1SbMvletM2tJh+TX5NAFZ50igcohX6F7GMfV123njXkgeaDwR7zDw8JOEylXgep9Q/cMQOYjjjJLM4f8EcemfW4aP+VIcQRRsdLSmnFHrwrTxVsjdB8zcrwbIcN/MyYBWF0zbPzrglESx+w2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892649; c=relaxed/simple;
	bh=pxyXX4yJ2Mr3Doa4vsdkw5uESIZDSsePBVkz1zFR09o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZHyTnpc/1MbJjG0sU4xuwK6f+c3CS5/R/AtaQ+qloxtnJlMyoeqj8Ta8W6mdBtU5OBmVIePfPCctcj8EiDxkzmJ2149CQPAcV/avkyFzxcLdFKCFwwHtpexEOUAZhyT9PsEhhlNPEJ7HuHhkjjv3nc3qOo2DckKjmrb3A0e34V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GaeFYo+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GaeFYo+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3021F000E9;
	Fri, 24 Jul 2026 11:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892647;
	bh=Cuu0u1YAAWUhG9VNpX7O06y8QcMoIMlw5xN1nn+83mI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GaeFYo+sAM2PWAhsI4hBssBJ0RhsrOGKBrQJ5iuF1ZN1R6ZILYuneZlI2rDPgXBku
	 5e3x6aP5nQPEDdUsNkdCM0GFEOKkOWoqzP8x8jvznYZTnrKn6zBSfaZ9DYCDE44gzY
	 D10Vre1NIPQHqxy7Td6S8amqT0INnPaOvijaHFthj9f2xgGWpUegJSyliv7jEbN6t0
	 j/YaZquUvWGMGHJtKBtnMEOEsHkZ3YJQfWTZrc2eBovv2xkDfto0dRE8Xc6305QqS7
	 qW4xxLnaVL0gp8VEGkMWkMLeW9K+5ojgUcW0h+GU7RSD3MVJU43wXZbIStUV6F1uc0
	 /uyhWpWZ8/CVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 19/48] KVM: arm64: gic-v5: Add
 KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260724104819.1296803-20-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-20-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:30:46 +0000
Message-Id: <20260724113047.2B3021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The patch defines a new UAPI constant for configuring the GICv5 IR=
S address but provides no kernel implementation to handle it.
- [Low] UAPI macro KVM_VGIC_V5_IRS_SIZE uses the kernel-internal SZ_64K mac=
ro, causing compilation errors in userspace.
--

--- Patch [19]: [PATCH v4 19/48] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_T=
YPE_IRS to UAPI ---
commit 58ea54e3d864bdb3fe8fc046f0912b0e710377f8
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI

Define the UAPI address type used by userspace to describe the
location of the emulated IRS in guest physical address space, together
with the size reserved for that region.

As per the GICv5 specification, the IRS has one CONFIG_FRAME and
optionally one SETLPI_FRAME per interrupt domain. Within a KVM VM we
are only concerned with one interrupt domain. Each of these frames is
64kB in size, so reserve 2x64kB of contiguous memory in the GPA space
for a GICv5 IRS.

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 1c13bfa2d38aa..d1b2ca317f586 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -97,6 +97,11 @@ struct kvm_regs {
>  #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
>  #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
> =20
> +/* Supported VGICv5 address types  */
> +#define KVM_VGIC_V5_ADDR_TYPE_IRS	6

[Severity: High]
Is this new UAPI attribute handled by the kernel?

Looking at vgic_v5_set_attr() in arch/arm64/kvm/vgic/vgic-kvm-device.c,
it currently returns -ENXIO for the KVM_DEV_ARM_VGIC_GRP_ADDR group:

arch/arm64/kvm/vgic/vgic-kvm-device.c:vgic_v5_set_attr() {
    ...
    case KVM_DEV_ARM_VGIC_GRP_ADDR:
    case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
    case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
        return -ENXIO;
    ...
}

Will userspace callers attempting to configure the IRS address via this
constant fail because the KVM_SET_DEVICE_ATTR ioctl path is unimplemented?

> +
> +#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)

[Severity: Low]
Does this break userspace compilation?

The SZ_64K macro is a kernel-internal definition. If a userspace
application includes <asm/kvm.h> and references KVM_VGIC_V5_IRS_SIZE,
will it fail to compile due to an undeclared identifier?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D19
