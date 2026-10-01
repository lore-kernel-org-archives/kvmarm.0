Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2D3530E18
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868176; cv=none; b=lDNAlUdl2Rd3wuls8CRa+PnI/NwTdik3GS38sSQWgubN2BxqFXX7h4J5zitxQoN/Z4Uhn8uanB2Z0crI0WgVkEDvw9I6CIBpVbFkgop2mtUEPHFaALkLLiufw1qSyHoIWOqMTAgbENjfyfeXtfcobtnWfkgEkxU2j9QrMgAQBwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868176; c=relaxed/simple;
	bh=u64na0ydNtkFp5QdpaaE0DTtE00RFQukbal1ZGfnQrk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HDHBkH9mDJXhFPbr1N1ZwsAptwyp9ENnQP5BM6RFB4SUnNW8vwYmC7N2h+6AQcSNocnqEAK++RaVB1j+YSAfbxQBtMjWvSeQ+Q9hqFmBiVPMxfW1KLbzIteg7hiPbMrlZP44hbquNIHz0xEfMJIvddx0FaecrrdYpnxyumflhTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eEZHAPRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEZHAPRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBDF1F000FF;
	Thu,  1 Oct 2026 15:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868174;
	bh=Oy90YfuvvQN912m7xTzCGwgNa+H/Y8H0X5LhYJkT85s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eEZHAPRr6p+59cSCD1NMrVzBX1KSLuxJ/0psZIEFULBBXrOFFM2mzMnZN/imVgUu0
	 ZKv4O/L/TRjyYN/KSdFy5F/yAp2qqwHjNz0+XjyRwjLSrRAqFeiMQWUI5npVEcxbHW
	 QABrxUawbcDTasZDclIZQMP+0XtmJBro5fWYLk91TqaC69tPnWYLBACf1bb6l2nkJ6
	 tsS51z527U0zC2LjX4cSlgjX537fo8G6tAg+xcd2MwQzTTjjp2WKk27pHs1cGotvdn
	 X1EFv38t926tx0F9Grc4eI3fMGnw0egReLFDGYGzxbpEJZRJgXh7mW7oBHRL1Y1GGL
	 8I2Nf0YdG8faA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/18] KVM: arm64: Add selftests for the pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261001142849.3367614-10-vdonnefort@google.com>
References: <20261001142849.3367614-1-vdonnefort@google.com>
 <20261001142849.3367614-10-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:22:53 +0000
Message-Id: <20261001152253.CEBDF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: leak of donated pages in hyp_allocator_selftest() error paths
--

commit e38e9008687b6871455e7ad734e5cd3158568487
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add selftests for the pKVM heap allocator
   =20
Introduce a comprehensive runtime selftest for the pKVM hypervisor heap
allocator, executed during init when CONFIG_NVHE_EL2_DEBUG is enabled.
The selftest runs entirely at EL2 and exercises allocator core mechanisms
including allocation, chunk recycling, splitting, merging, and reclaiming.

> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/al=
loc.c
> index e0104d2dd6c0e..c1881c0011c9e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
[ ... ]
> @@ -1025,3 +1033,179 @@ u32 hyp_alloc_topup_needed(void)
[ ... ]
> +	/* Test reclaiming the last chunk of the list */
> +	selftest_free(addr4);
> +	hyp_allocator_reclaim(allocator, &host_mc, SELFTEST_MAX_PAGES);
> +	if (host_mc.nr_pages !=3D SELFTEST_MAX_PAGES - 3)
> +		return -EINVAL;

[Severity: Medium]
Does this leak the reclaimed pages?

The allocator test reclaims pages into the local host_mc memcache.

If the assertion fails here (or in any of the subsequent checks before the
test completes), the function returns early without passing these pages back
to the host or freeing them.

This results in a permanent physical memory leak of up to 6 pages.

> +
> +	/* Test punching a hole in the middle of a free chunk ... */
> +	selftest_free(addr2);
> +	hyp_allocator_reclaim(allocator, &host_mc, SELFTEST_MAX_PAGES);
> +	if (host_mc.nr_pages !=3D SELFTEST_MAX_PAGES - 2)
> +		return -EINVAL;
> +
> +	if (selftest_alloc(PAGE_SIZE))
> +		return -EINVAL;
> +	if (selftest_errno() !=3D -ENOMEM)
> +		return -EINVAL;
> +
> +	/* ... and to refill this hole */
> +	ret =3D hyp_allocator_topup(allocator, &host_mc);
> +	if (ret)
> +		return ret;
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001142849.3367=
614-1-vdonnefort@google.com?part=3D9
