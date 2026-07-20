Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBA43BF660
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568432; cv=none; b=lZ88m+yD1X+tDAhb6Z5pOKyR3InDUBnsTjUNExwYvdbmDIdUQGue8crObiEhR7UkxG92M+jYdxVFlmWq9NMSXTim2Z1lG2m/3UU6DiDB/LPRxQm7ViVZaVYoPzyMKVYUOfxUEFLOW34xDBxCBlYxFZj8ZjIq44S1yV3sts6HgKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568432; c=relaxed/simple;
	bh=HrfSc50n+RKrv/xcfY1WSc86lQExZo2kmBW10ErMIAI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=izVQxbE/Z+9/n1L3FjIEC8kx1CI9u93BIUcz8R4v2BqBneHGQsGFOWk6hnpmLFL14jQc+xB/jtY5RY/P9A/UvvYLfepkaZlJmAbRtGW8rW6FLAsJZhm6SBH+hXahGDFvzNSZpNdNdDJ4lm1K6jOC3BpSFaHE/21IvA0wi8JX6ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCoGZBf0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCoGZBf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6521F000E9;
	Mon, 20 Jul 2026 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568428;
	bh=YpuI9BADy8usDUG/l4/q/5dX16WB0oUvc2tdDhZeNPg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QCoGZBf0cQ0yQF/aPAK0LYHpexfE92iUDnWe8bNE30DIgsPiNHpz96czvW5RaJ6qn
	 L5SraiC5L/trobFJnqCeQbfyW1xuGzBiJXtkFUEfVOcFSp8EHP9rRj5JBBJP0QZYE4
	 ndsE/mfQNqn89DngZ4L2GyiB4wcesNcyR2SXNqRV9YPVVCeMxP1d1Q9Xxn1d5aC2GK
	 OUHEzZ8ubivLNZYh0PXQVr3UKOjgxM0OS8xojyVzUuydI+qTOLyBdE78duTUV3CHjW
	 f6SjUO8BlR8fVfa7iAHI0Jp1UT2uQSdK/lnn9ybKTFA0xxWWw1n/d5HMLyp5xh1V87
	 pONtHwaeZq54A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/17] KVM: arm64: Add pkvm_remove_mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260720171513.1415357-3-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-3-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:27:07 +0000
Message-Id: <20260720172707.BA6521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Bounds checking `WARN_ON(from > to)` is evaluated after pointer =
page-alignment, silently masking inverted address ranges and unmapping unin=
tended memory.
--

--- Patch [2]: [PATCH v3 02/17] KVM: arm64: Add pkvm_remove_mappings ---
commit baa2f13b846b3ed54bd502767e4372648ba03b42
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add pkvm_remove_mappings

This commit adds pkvm_remove_mappings() as a counterpart to
pkvm_create_mappings(). It allows previously mapped ranges to be removed,
which will be used by the upcoming pKVM heap allocator.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 8b8c9d3dc82ad..5cd2f1fe51e4c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -157,6 +157,19 @@ int pkvm_create_mappings(void *from, void *to, enum =
kvm_pgtable_prot prot)
>  	return ret;
>  }
> =20
> +void pkvm_remove_mappings(void *from, void *to)
> +{
> +	u64 size;
> +
> +	to =3D PTR_ALIGN(to, PAGE_SIZE);
> +	from =3D PTR_ALIGN_DOWN(from, PAGE_SIZE);
> +	size =3D (u64)to - (u64)from;
> +	WARN_ON(from > to);
[Severity: Medium]
Does checking from > to after page-alignment mask inverted bounds?

If a caller provides inverted address bounds that are close enough (e.g.,
from =3D 0x1050, to =3D 0x1040), the page-alignment operations will transfo=
rm
them into a valid range (from =3D 0x1000, to =3D 0x2000).

The WARN_ON(from > to) check would then evaluate to false, bypassing the
warning and silently unmapping unintended hypervisor memory.

Could the WARN_ON(from > to) check be moved before the pointers are
modified by PTR_ALIGN and PTR_ALIGN_DOWN?

> +
> +	guard(hyp_spinlock)(&pkvm_pgd_lock);
> +	WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)from, size) !=3D size=
);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D2
