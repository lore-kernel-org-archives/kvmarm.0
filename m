Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B777143C7BF
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784568682; cv=none; b=lDyTtK/g4NS2NfeBLfG+JNenJAThsXlyFSCbC+hYfkJvRdaHR/iUZigvlQkNKJjZ6V6T2z1+cR3r08s/6Y27S9WjLjlp9hLMcbCRSxf64Ji4eEln5zAxCo69LseiwmLQZo86BCgf/vLDUyKlNgg7HD7qYmzt/v909/83i63mHO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784568682; c=relaxed/simple;
	bh=tTD7A7jElPBV6UI465kdtP53Nw0FGwDNdCtC1BODHr4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JioNG+fiGId+d/ieQBu7Geb3dFmFKxYUXloOBvZwePaeNEIuvS4IhX302FsrKsEZWKTPtw4sZedAiFmvKT/sHjTOhD4OBkFB5rDwVhE/Bu0PNJxn9bcJqSuBJkpFkeKoA/GyP6zrpwUpDED26/HIFEE5SYe3TDal+nyPwEmnh7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWH+I4dU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWH+I4dU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9101F000E9;
	Mon, 20 Jul 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784568673;
	bh=aafJL6u+MyWawaBp369TCpqAtvMTuJS31h8j4n0O0io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MWH+I4dU89BLJsV6jBB2mGadFcdLt0Dt63g9qSvpLAABSC/mfvxZ96eJJq+U6sDYS
	 U7Nyh7NIqogl4N7675oyq+PHhVi2sEh9jHtAxzzohj1khwBSdqzx1KFzdm1GeN0BoE
	 oA9fOACqYVy3aC4HlM7uLTXajBC+Xp4gMxT1nFCdcL0DvTbCx4s2HweTSnwneXZ4tx
	 fFBBlXhrvd19p06RARUVdy3sZorjAT393WzuWMsk16MYQjSFVY1DGLUuA8yUb0KSGQ
	 V1yMub+Pp8EXTDb4Qqe3LDsnsufV3n+a4SMgxHOzfckbL4GkNTdgH1Q3e62dn8Fb/e
	 B0ujZ+Pr1VQLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/17] KVM: arm64: Add selftests for the pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260720171513.1415357-10-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-10-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:31:12 +0000
Message-Id: <20260720173112.EA9101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The `__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_selftest` hypercall =
is incorrectly placed in the always-on band rather than the init-only band.
- [Medium] Physical pages are permanently leaked in the hypervisor if the a=
llocator selftest encounters an error.
--

--- Patch [9]: [PATCH v3 09/17] KVM: arm64: Add selftests for the pKVM heap=
 allocator ---
commit db8b74b081ab779ef5c70d80095da5b5809ca9d3
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add selftests for the pKVM heap allocator

Introduce a comprehensive runtime selftest for the pKVM hypervisor heap
allocator, executed during init when CONFIG_NVHE_EL2_DEBUG is enabled.

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kv=
m_asm.h
> index 0c3126179704f..08466f608d1f5 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -92,6 +92,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_selftest,
> =20
>  	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),

[Severity: Medium]
Does this place the initialization-only test hypercall in the always-on ban=
d?

If __pkvm_hyp_alloc_selftest is only intended to run during initialization,
placing it here (before PKVM_ONLY) exposes it to the untrusted host
post-deprivilege. This allows the host to drive synchronous EL2 execution at
runtime. Should it be placed in the init-only band instead?

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/al=
loc.c
> index 32c923d83f78b..49d7560ad150e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c

[ ... ]

> +	/* Test reclaiming the last chunk of the list */
> +	selftest_free(addr4);
> +	hyp_allocator_reclaim(allocator, &host_mc, SELFTEST_MAX_PAGES);
> +	if (host_mc.nr_pages !=3D SELFTEST_MAX_PAGES - 3)
> +		return -EINVAL;
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

[Severity: Medium]
Are these early return paths in hyp_allocator_selftest() leaking the physic=
al
pages accumulated in the local host_mc variable?

If an error is encountered during the selftest and the function returns
early, host_mc goes out of scope. Because the physical pages populated
during the previous hyp_allocator_reclaim() calls are not returned to the
host or freed, they appear to be permanently leaked in EL2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D9
