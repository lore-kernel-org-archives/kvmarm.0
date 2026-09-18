Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63246304BB3
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 08:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720062; cv=none; b=WjYPxaiFfwL+arodKIwU5XqsK1tGPp3ju4uxAGFQQt+bhL7wxrPYbkZCS174V1YTWk8hnrPmAp7fXGfRXlWsV+88cLkQVOF+gZRxN4j0R5BGua/L7SQ5BrMMbafw7C1f40ldsQ5E4AyWFHUNF/W3+r+e8fNIlcLU8iaj6NCljaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720062; c=relaxed/simple;
	bh=sRrVzQuYWEK5SUSgnOiE86xyNP0zEx5c8lEAxiGLwT8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XokwKMpiyY3LY1MjJmmj3s1m7DMfz2WMzlfAmHAHPWU7paWTef1BywtZ97OxEKmFvz2ht0XcMXLmoEKKqmV0W36nVr0aSg1ffdXC80tkrGe90dRfci3sLk5Qpnw0a22ybFOe2A9oHG9MxiujcqmmMwq56cpYFE7M/7deI1oxJfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChPp0Ru0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChPp0Ru0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2A51F00893;
	Fri, 18 Sep 2026 08:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789720060;
	bh=pGv4yLNOYH2eefYxcHwsKqIS4vw4ylM4340sPyGGhGI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ChPp0Ru0vy9NaCWeTdQMxin7k1RazrgOQa1n4v+AbQdOy0jP+/Iq64IQx+GoGXSXa
	 Tjewi7rzwtau/MvwRy2LJsNpgE67tHZ5whHUnGSVHerxgdXX1eHliHm2l/tTfE2v+S
	 DiMV1+q50Qbigt2vXl2LOJtDEsGSI55MtzShIsa/+A2cLosQYaOov6/d1lqYc5sIgn
	 muY1IJna5my9iS3ew9LDUJAwXsRly299FjzPPjvur4CR6ZQOKZDQQ/LWJjxrpFRKLx
	 gDmoGlOSbvRD0biryHuTj1sUe2bmep/G0zhwt8KyoWOzr9S/bx56GzcJe/7KenPMjK
	 chfcOmakX+IGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Add batch group constant and data
 structure to UAPI header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yize Wang" <wangyize7@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260918081930.4014735-2-wangyize7@huawei.com>
References: <20260918081930.4014735-1-wangyize7@huawei.com>
 <20260918081930.4014735-2-wangyize7@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 08:27:40 +0000
Message-Id: <20260918082740.9E2A51F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] kvm: arm64: implicit padding hole in UAPI struct kvm_dev_arm_vgic_b=
atch_entry
--

commit 54edd6d460b56fe24bcc0c18ebb7ce4904b10a69
Author: Yize Wang <wangyize7@huawei.com>

KVM: arm64: Add batch group constant and data structure to UAPI header

Add KVM_DEV_ARM_VGIC_GRP_BATCH_REGS group ID, KVM_DEV_ARM_VGIC_BATCH_MAX
limit, and struct kvm_dev_arm_vgic_batch_entry for batch VGIC register
access. These UAPI definitions allow userspace to read/write multiple
VGIC registers in a single ioctl call.

> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/=
asm/kvm.h
> index 019e5e3d892e6..f84530274edd4 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
[ ... ]
> @@ -418,12 +418,22 @@ enum {
>  #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>  #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
>  #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
> +#define KVM_DEV_ARM_VGIC_GRP_BATCH_REGS 10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>  			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
>  #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x3ff
>  #define VGIC_LEVEL_INFO_LINE_LEVEL	0
> =20
> +#define KVM_DEV_ARM_VGIC_BATCH_MAX	4096
> +#define KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED 12
> +struct kvm_dev_arm_vgic_batch_entry {
> +	__u32 group;
> +	__u64 attr;

[Severity: Low]
Does this struct layout introduce a 4-byte implicit padding hole between
the group and attr fields?

This layout appears to violate UAPI design guidelines, which strictly forbid
implicit padding to prevent ABI sizing mismatches and potential information
leaks.

While the kernel currently never copies the structure array back to userspa=
ce
(it only writes to val directly via put_user), and 64-bit integers are alig=
ned
to 8 bytes on ARM32 compat (avoiding an immediate sizing mismatch), defining
this structure permanently exposes the flawed layout to userspace.

Could explicit padding be added or the fields reordered to ensure the
layout is perfectly packed without implicit holes?

> +	__u32 val;
> +	__s32 error;
> +};
> +
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT		0
>  #define   KVM_DEV_ARM_ITS_SAVE_TABLES           1
>  #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918081930.4014=
735-1-wangyize7@huawei.com?part=3D1
