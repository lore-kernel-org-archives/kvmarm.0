Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ED658E2AD
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792096012; cv=none; b=B5BAowSDySJGJElyx3nAvWhES5XDrkdWIe2QrE+YmsoeBpjYWOdaeD71+X57CxsAdUsDnkP1nlzMANRTqpNtkPfjyzjNN6gdrB/E291Oe7uTevF8iAbMMY0s1m6BRvF08s9fkozOf2YPWnvUEwFKss6iw+k7drich9Qzo7q+zCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792096012; c=relaxed/simple;
	bh=xpN+F6SXRpE95rSJnrzVWJ7pELanZYZnzMA0sZ1UJMw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=TvkljSIjE610EIDT5y1JIaHafi6qthlAHwwy9GjA2A6v94jfi7ZaWyctaE6U4r75meO5NTR+9XcP77xD7/YrXz8GC4e/nmlyBKzwoqrsMpJxz+NpDVNkXTOm1vFKsuSgAZReSFqBELVU7hpohNe9oGrhFFjBPpsie7+nr3DKKfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1hMwoTy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1hMwoTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFCD1F000C4;
	Thu, 15 Oct 2026 20:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792096006;
	bh=meFQ045NceF6XkiAhA4Q8eiO7+V8ffE/Gg/+Bk/tviM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O1hMwoTyZ/oBsEx6wN8axZtrVeMVJybSLvdbM6iGki1GwPCJhKYkGToBWCRpZcUGL
	 sPyT6xF74MjDGU/NxOK9wtuH9K9ahT/jYdMvW2xAHYP48O+6EqzjILVHNwwXmQp5hc
	 e5LVDhlh7tdD71KYVjqb3ymfxq22usM6rwg/fwvxls4R2rVudprqhvroMDRGngshgx
	 gEhrC5xCeRRe7DDfHV+KPI9jgKykQbiuboVn2hjYUFcC5aVIIkPf5k0ySos7Z5adzM
	 cnnH84KdBEi/G9iC77m1WMLFhHW9ljh2aBW9ZWNZ9xhNQOoXpdQdAEKCAnU4OCDDD2
	 i96YDoL15azoA==
Message-ID: <sashiko-outbox-173386@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 21/25] iommu/io-pgtable-arm: Support io-pgtable-arm
 in the hypervisor
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261015200903.2735565-22-smostafa@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-22-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:26:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] arch: layering violation by including SMMUv3 header in generic io-p=
gtable-arm.h
--

commit 251567dd4618edfaa4984ef7282b71a0da331297
Author: Mostafa Saleh <smostafa@google.com>

iommu/io-pgtable-arm: Support io-pgtable-arm in the hypervisor

To be able to populate the shadow stage-2 in the hypervisor, compile
io-pgtable-arm object for the hypervisor. This requires the hypervisor
to provide the iommu-pages allocator, redefine the address conversion
helpers, and stub out the DMA API.

[ ... ]

> diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-ar=
m.h
> index ba7cfdf7afa03..4278da41e406d 100644
> --- a/drivers/iommu/io-pgtable-arm.h
> +++ b/drivers/iommu/io-pgtable-arm.h
> @@ -27,4 +27,13 @@
>  #define ARM_LPAE_TCR_PS_48_BIT		0x5ULL
>  #define ARM_LPAE_TCR_PS_52_BIT		0x6ULL
> =20
> +#ifndef __KVM_NVHE_HYPERVISOR__
> +#include "iommu-pages.h"
> +#define arm_lpae_alloc_data(obj)	kmalloc_obj(obj)
> +#define arm_lpae_free_data(p)		kfree(p)
> +
> +#else
> +#include "arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h"

[Severity: Low]
Is this an intended architecture layering violation? The generic ARM LPAE p=
age
table header drivers/iommu/io-pgtable-arm.h explicitly includes the
driver-specific header arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h when
compiled for the hypervisor. This tightly couples generic IOMMU framework c=
ode
directly to the SMMUv3 driver path.

Should the hypervisor stubs be placed in a generic NVHE include directory
(e.g., arch/arm64/kvm/hyp/include/nvhe/) to maintain subsystem independence,
even if SMMUv3 is currently the only user?

> +#endif
> +
>  #endif /* IO_PGTABLE_ARM_H_ */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015200903.2735=
565-1-smostafa@google.com?part=3D21
