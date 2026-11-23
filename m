Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795431895;
	b=STeyg01KMUQ8P1EUZTc5KmRuvXCr0PN5t5pQ2lDUh0bOOk+SuDl8sxp5Hq5GRMoBps1o
	 6WZb4WuDJcy0y895/5v8t239TaIDTtCFxionn5QT5j3egmux3FqZsszFO17pkS64P0n52
	 NwaIMUHF+Z8IM30yOjoxM4OZTrL2khU4xrfQ5HuKKoktgZmUaanycMm2HbShNJin9hnF8
	 ZW7nPYO8/V9ooiNNviw0BoHEOENBOurRNrZUdTDwa+RKxyWHZ1/5oUIvGtvqgrpV3WRWJ
	 U8p7pM0vBNQ6Q55LLxbNiXXpHAGeMG1PG9JVTRh2GRJgNF761ZLgpXoBXNXcakKCDVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795431895;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TWB81LfiguyA0MCEERBvIKta1UPwegd6WSGnEBwsH5k=;
	b=lUiJS/iHRfVjUuV5iuBEy/Jvph/OYBWkOICVDch8leTc1EsxB/vPlVqpnUBugUQayBAZ
	 VsYfxDUdPHsIhxNyaS9zPlYNtp8UWcf7PWC9YfaVbfGO6djTJh1IUxYlrqgjmCZvp2jsD
	 xCjDG1VABaAQs3Qb9M6+LO4h4wxKBMMouNXlAYJvbj0fUISt4WLUlxC1agG3RHidLkn8u
	 CPJ9TnHrD94b6giFrt0i8Zjpztuc1O8tSTM72xKPEsGKF6E4sQlseTnB+j97GWo+tLrcK
	 g4QZBR/6jx+HQErjdgFU2KQK8BJW3lVb2ju1LeewShvg2qns7RNBLAFPu4aH9VD81zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuaZuHr+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B58606A31E;
	Mon, 23 Nov 2026 11:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WuaZuHr+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A1E1F000C0;
	Mon, 23 Nov 2026 11:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795431894;
	bh=TWB81LfiguyA0MCEERBvIKta1UPwegd6WSGnEBwsH5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WuaZuHr+8lnS9d3dJnyNHfnGXJyWwVIpmLKa0fRNmJe1Q/QKMQMWMwFUllGjE6PyF
	 rlD+uT0RgV+zqk6fnpwGtUT5mXuZM/j/LLfiKT81EZJ1rVdzyP2MzRz3oDWTOvWzHQ
	 YhQWaMT4rTyzuiWWLPUdxADjBU3MLLjS1PWkgeTOfvwa7bo2CQkmcdvOxKZBeEuR8Z
	 j751F/lRezDf9BCSbhyXrE+KJ8Y0UGw9qPQk08B0C5lJ+gnLNjgt5iLyDIFtNx3Nal
	 UdfpKcjHeTYysMZgoP7ulzoDY83MIc65Iiqs6/xD/V2AufEb8WDLLJ92bY1XNDhNpW
	 0n7TRfcRKjbVA==
Message-ID: <sashiko-outbox-229096@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/11] KVM: arm64: guest_memfd: Check mmap support
 when preparing memslot
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261123104233.95710-2-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-2-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 11:04:54 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: kvm_arch_prepare_memory_region() rejects non-mmap
  guest_memfd
--

commit a0665f8dc612d05686ef019cc8462841573fe88c
Author: Steven Price <steven.price@arm.com>

KVM: arm64: guest_memfd: Check mmap support when preparing memslot

This commit introduces kvm_gmem_slot_supports_mmap() and uses it in
kvm_arch_prepare_memory_region() to require that all guest_memfd-backed
memslots on arm64 come from files created with GUEST_MEMFD_FLAG_MMAP.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1db10d8d6db73..2825fccd2a197 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2839,10 +2839,10 @@ int kvm_arch_prepare_memory_region(struct kvm *kv=
m,
>  		return -EFAULT;
> =20
>  	/*
> -	 * Only support guest_memfd backed memslots with mappable memory, since
> -	 * there aren't any CoCo VMs that support only private memory on arm64.
> +	 * All VMs need mappable guest_memfd memory, as the memslot's HVA may be
> +	 * used to access shared memory even if guest faults use guest_memfd.
>  	 */
> -	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> +	if (kvm_slot_has_gmem(new) && !kvm_gmem_slot_supports_mmap(new))
>  		return -EINVAL;
> =20
>  	/* guest_memfd is incompatible with MTE. */

[Severity: Medium]
As reported by Suzuki K Poulose on v2 [1], should
kvm_arch_prepare_memory_region() drop this guest_memfd check altogether
rather than rejecting memslots backed by a guest_memfd created without
GUEST_MEMFD_FLAG_MMAP?

Both gmem_abort() and realm_gmem_abort() fault in guest_memfd pages via
kvm_gmem_get_pfn() without using new->userspace_addr, and
kvm_arch_prepare_memory_region() does not verify that new->userspace_addr
maps the guest_memfd or any valid VMA.  Requiring GUEST_MEMFD_FLAG_MMAP
here fails KVM_SET_USER_MEMORY_REGION2 with -EINVAL for VMs (such as
Realms) that bind private-only guest_memfd instances without allowing host
userspace mmap, and on v3 the guest_memfd maintainer noted that this check
is unnecessary and should be removed rather than exposing
kvm_gmem_slot_supports_mmap().

[1] https://lore.kernel.org/r/26a29420-8d27-4069-bbd5-28692c9e8542@arm.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123104233.9571=
0-1-steven.price@arm.com?part=3D1
