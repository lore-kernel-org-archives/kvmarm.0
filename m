Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB802D238F
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788251236; cv=none; b=KUzdcswaH9lf6Ie7h+QgIkECoT0gFtlYML2rz8p2aEBVeCqVF0yh+6+eIogVnWc/1cfBiAzNgnGBtmJ+d1aMHONTBsCsyxFPhnPdNnn+RJS10BAgFeKrHAXQE6BONKWBhoK7iZ7JCIUXH/AicLADiAdatUSAGf72I24ENjjir90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788251236; c=relaxed/simple;
	bh=LZ7e6Bovhyfiu+vtWlqTRQIx+CPWs/nUVH+z44AutJ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B9JZGFOFfzYO8nrwxJdHDHG4OrZmlYzBs9HYIMnIQQTqS4Y7ZjrgWxlqT7jsSovU/JLpTVew5NLlC2jtVqZjZ4LTo78sm3wnfM62TsGbIntWbZ3hmG4GbUqy7xpw+8pbxInWlf/2GR8E3gBlbu3V2zrAOhJ7kOBhTSDG+nBitBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e2CXlI+9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e2CXlI+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA3D1F00A3F;
	Tue,  1 Sep 2026 08:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788251234;
	bh=pxoYZoUHxGDM03TkRXUND+lqHWjpG1cR1v8ORhCOjOI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e2CXlI+9LnWNp2YheilEYAISq3+uzw/Wrx56qg17I+h9ehqPamzSR4pSRkiPdCFg2
	 +MK07yuLvK+aakEG31Ds7KHUpURFzOcWBubuVVirqUzDP4wPJI+gGG/DcIf9aO4iz5
	 MSx3Du8hgge9RqNQWpY7Qh6xh8voxnGk/mKAqYrcWmfLABskP446ZCnddmTbBviHJV
	 kyyX+cP36G6LtJjjoFuh6cr/mDoRYjinUMm/EsTjeNOoMG6dxb5rCeiFIRMUDEpGWB
	 UTTmyxXUpWx4epwfAiyQOVEEvEhFl4Nt/6ObWxcSSYCcHO9T77V8qUbr8Psq27YdLy
	 Pf5umDfnls6fg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/18] KVM: arm64: Add selftests for the pKVM heap
 allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260901080941.997769-10-vdonnefort@google.com>
References: <20260901080941.997769-1-vdonnefort@google.com>
 <20260901080941.997769-10-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 08:27:13 +0000
Message-Id: <20260901082714.3DA3D1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Improper Trust Boundary: Selftest hypercall is exposed in the al=
ways-on SMCCC band.
- [Medium] Data race and missing mutual exclusion in `hyp_allocator_selftes=
t()` against concurrent reclaim.
--

commit 75aa2a47b5c2aac4b561278263e6a43bfd0479e2
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add selftests for the pKVM heap allocator

This commit introduces a comprehensive runtime selftest for the pKVM
hypervisor heap allocator, executed during init when CONFIG_NVHE_EL2_DEBUG
is enabled.

> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kv=
m_asm.h
> index fc3c52b031541..0a8df74a7b4e6 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h

[ ... ]

> @@ -92,6 +92,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaim,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_reclaimable,
> +	__KVM_HOST_SMCCC_FUNC___pkvm_hyp_alloc_selftest,
> =20
>  	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),

[Severity: Medium]
Does placing the selftest hypercall here expose it to the host kernel
after deprivilege?=20

By placing it before the PKVM_ONLY marker instead of before the MIN_PKVM
marker, this hypercall becomes always available rather than init-only.

This appears to expose boot-only test code and its memory management
operations to the untrusted host kernel at runtime, which expands the
attack surface and violates the pKVM least-privilege security model.

> diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/al=
loc.c
> index 32435782030bc..3b83de90472a8 100644
> --- a/arch/arm64/kvm/hyp/nvhe/alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/alloc.c

[ ... ]

> +int hyp_allocator_selftest(void)
> +{
> +	struct hyp_allocator *allocator =3D &selftest_allocator;
> +	static DEFINE_HYP_SPINLOCK(selftest_lock);
> +	struct kvm_hyp_memcache host_mc =3D { };
> +	void *addr1, *addr2, *addr3, *addr4;
> +	int ret;
> +
> +	guard(hyp_spinlock)(&selftest_lock);
> +
> +	if (allocator->mc.nr_pages < SELFTEST_MAX_PAGES) {

[Severity: Medium]
Could this read of mc.nr_pages race with concurrent reclaim or topup
operations?=20

It looks like this accesses the allocator state locklessly because
allocator->lock is not held here, only the local selftest_lock.

> +		*this_cpu_ptr(allocator->topup_needed) =3D SELFTEST_MAX_PAGES -
> +							 allocator->mc.nr_pages;
> +		return -ENOMEM;
> +	}
> +
> +	selftest_alloc(SELFTEST_MAX_SIZE);
> +	if (selftest_errno() !=3D -E2BIG)
> +		return -EINVAL;
> +
> +	selftest_alloc(SIZE_MAX);
> +	if (selftest_errno() !=3D -E2BIG)
> +		return -EINVAL;
> +
> +	/* Test first chunk */
> +	addr1 =3D selftest_alloc(0);
> +	if (!addr1 || addr1 !=3D (void *)allocator->start + chunk_hdr_size())
> +		return -EINVAL;
> +
> +	/* Test second contiguous chunk with unaligned size */
> +	addr2 =3D selftest_alloc(MIN_ALLOC_SIZE + 1);

[Severity: Medium]
Because the selftest hypercall is exposed post-deprivilege, could a
concurrent host hypercall steal chunks from the selftest allocator while
this test is running?

Since allocator->lock is not held across this sequence of allocations and
frees, a concurrent reclaim operation might mutate the allocator state. This
would break the selftest's deterministic layout sequence and result in
spurious failures.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901080941.9977=
69-1-vdonnefort@google.com?part=3D9
