Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60609368299
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785510189; cv=none; b=GIBVS1ulSDC1hiDcerJ7GDyCMKe43OnWQ4zuXqY6XJwnSf5H3SWjVOr6UafUUVMoPNyqzoOBMRnq36laQ1lvPWho24kc3+wUv8w4hnPSDPWb+uhAtyeoQnq7ktN2uzlg6IMZ9HHUgH1e6z/U8SefqQRqWuf0tqAXWy3MXTFzFlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785510189; c=relaxed/simple;
	bh=wkeBixyhVNYNVDFbkNkDflDqhinWDKQBwQ7Z5bePJRs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mejodv2Yd7Ozu8mlSt3APrEn70Lo0f4YoZbrWY2QzixgGf5x4/dtkWH53iZ4Sp7oW3GaHQaXxbZc02wPnIQODpH1B3FSCKNdmaE/S4SLtLIJOVUgdfxu0i8AXDOX2IQZRS9Gu/b6C68+zJRygKIucE31V5cV2Cwb+rYVh1x6Bo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oM/IIsDR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oM/IIsDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB95E1F000E9;
	Fri, 31 Jul 2026 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785510187;
	bh=drRJG6ds69O9LwV6v3ykfptHYlXD3AOi/zrzDj3LKBI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oM/IIsDRo9DntuOBBXMJuP+Gus4ClkO6nBSlBGa38RdeIvDU6ZfQWIbqH0tD5hpAq
	 gMDfbJVvAe6lFJe7yUNUDdKcUBCQtD+LlHzc6RD4K75ULEfM+Mr+5FGMjg8j/wu8iF
	 0Fhe1vyR7YJj4PKkpWI8vV5S44dEEd5+NVcrNIIzC7fCklFFJqGy93QIelxxvyKVhQ
	 rrxxF0YarU2zwx/1+uS4HUVUYDzFeDqAfHLOfHLVvFnOiD0fryqyMs0e68mf0rtBO9
	 Rdc0aV3KlFuoq5TmFuFS9Bko73ymeoltcE4jkByYp9JNuobm4txzi96/0xEIXR2fgh
	 qOQoQ5iclUD6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 09/17] KVM: arm64: Add selftests for the pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260731143541.956291-10-vdonnefort@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-10-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 15:03:07 +0000
Message-Id: <20260731150307.AB95E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The pKVM hyp allocator fails to map backing memory for chunks appe=
nded to a previous chunk that does not explicitly track the unmapped bounda=
ry, leading to a fatal EL2 data abort.
- [Medium] The `__pkvm_hyp_alloc_selftest` hypercall is placed in the alway=
s-on band instead of the init-only band, violating hypervisor lifecycle rul=
es.
- [Medium] Physical pages temporarily held in the local `host_mc` memcache =
are permanently leaked if an assertion fails during the selftest.
--

--- Patch [9]: [PATCH v4 09/17] KVM: arm64: Add selftests for the pKVM heap=
 allocator ---
commit 68a0bf1c1fb29e6fed5c0a59e15840d4a948bd3e
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
Is __pkvm_hyp_alloc_selftest placed in the correct hypercall ID band here?

Placing it before the PKVM_ONLY marker puts the hypercall in the always-on
band rather than the init-only band. Since this is an initialization test
meant to run before pKVM finalization, should it be placed in the init-only
band to ensure it is not exposed to the untrusted host kernel
post-deprivilege?

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/al=
loc.c
> index af4ab53784f7f..de636fdf976bf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
[ ... ]
> +	/* Test reclaiming */
> +	if (addr1 !=3D selftest_alloc(0))
> +		return -EINVAL;
> +	if (addr2 !=3D selftest_alloc(PAGE_SIZE * 2))
> +		return -EINVAL;
> +	addr3 =3D selftest_alloc(0);
> +	addr4 =3D selftest_alloc(PAGE_SIZE);

[Severity: High]
Does allocating addr4 here trigger a data abort due to unmapped memory?

When appending a new chunk, hyp_allocator_map() uses chunk_unmapped(prev) to
find the unmapped boundary. If the previous chunk (addr3) does not track it
(which occurs when the boundary is held by an earlier chunk), it returns 0
and skips mapping.

Because addr4 is allocated after addr3, it crosses the actual unmapped
boundary without mapping new pages. This leaves the new region unmapped,
which leads to a fatal EL2 data abort when the hypervisor initializes and
accesses the memory.

[ ... ]
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
Do these error paths leak the physical pages currently held in host_mc?

The hyp_allocator_selftest() function temporarily stores reclaimed physical
pages in the local host_mc memcache stack variable. If any of these
subsequent assertions fail, the function returns -EINVAL directly without
draining host_mc or returning the pages to the host, resulting in a permane=
nt
memory leak.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.9562=
91-1-vdonnefort@google.com?part=3D9
