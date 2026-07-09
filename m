Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091E739903B;
	Thu,  9 Jul 2026 11:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783595031; cv=none; b=cFwsv7yvQNYkGmsavlf3ZI5BUtr2McjPq0UbFVRTTE4Kz320rGKl9LBiJnOa54VAbd6Zh18hpsvAotuWQOM+QqWY0+BcpYwy5tlZ4BmqRcUkkDWuMFinGIK+Cd0UqJTPlOPW88n3xKQUbk/vYgyjO/9TV3ILTv+GLPq1AYFGzdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783595031; c=relaxed/simple;
	bh=9lLEQQCHT9JiVKo0bVMYV1AdfA8TC1/xGWRG6R48IAY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GuJeGusEiavhB5RHBNx6RVHif+pxt7SHmGF94Hgm3lUU09e0l8ZTwUZNgd7hTU4iQZd7Fnrth1fClqv6nR+m2BxAk5LayudaWPo7o3pD0KNWKOFe16HS76Sw5ed0vnSu4e64BVVUeob9abjNcabZh6d73cbSeM8doSZKpsgG2ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lp+9Cnsw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lp+9Cnsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4590F1F00A3A;
	Thu,  9 Jul 2026 11:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783595029;
	bh=p8O9SDEsL1nRzUv/xpfs+3EbRQc7MnIZV1aLu/u/OLc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lp+9CnswKWRVUgKywROkL1IIxFHMbuqFZDJNHnJ6Ls5X6q3iiNRv7YVAG9BByctlL
	 EkvoK5Bv0ybKEcRtAY+1JmrvuCs74RTSD9+VK4IW/K6rPra1QYDEm7ZxxjMxHDF3uX
	 ViYvlC+JfNBi+aFc7538pcwKoqpxHsTU86pQeVlAb1yfE4eDXBHqcHs/1cOPZX0vhn
	 x4OpsqGBXnGxdv8X9z2zqV/D51wSVuhdJmvoRbsp4l7uJGhbsapmJuXvObej3VLvva
	 ZyIEMLQVmbadSKLfoH4Bl3/t0y3EaFAAnZpn2zGgtsRIq6ab0wd6HNT5lwiDkCfe2k
	 20XlC2Cu++Auw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/6] KVM: arm64: Enable eager hugepage splitting if
 HDBSS is available
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260709104026.2612599-2-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-2-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 11:03:48 +0000
Message-Id: <20260709110349.4590F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The default eager page splitting chunk size evaluates to an archit=
ecturally invalid block size on 16KB and 64KB page systems and suffers from=
 integer truncation in KVM_CHECK_EXTENSION.
- [Medium] The global capability query for eager page splitting chunk size =
incorrectly reports the default as 0 (disabled) when HDBSS is present.
--

--- Patch [1]: [PATCH v4 1/6] KVM: arm64: Enable eager hugepage splitting i=
f HDBSS is available ---
commit 382048a591b4a06f749e61447083eb8630f1bad5
Author: Leonardo Bras <leo.bras@arm.com>
Subject: KVM: arm64: Enable eager hugepage splitting if HDBSS is available

This commit enables eager hugepage splitting by default at stage2
initialization when the system supports HDBSS. It sets the chunk size
to 256K * PAGE_SIZE.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c63..e086c01a9325e 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kv=
m_s2_mmu *mmu, unsigned long t
>  	for_each_possible_cpu(cpu)
>  		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) =3D -1;
> =20
> -	 /* The eager page splitting is disabled by default */
> -	mmu->split_page_chunk_size =3D KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +	 /* The eager page splitting is disabled by default if system has no HD=
BSS */
> +	if (system_supports_hdbss())
> +		mmu->split_page_chunk_size =3D 256 * 1024 * PAGE_SIZE;

[Severity: High]
Does this chunk size assignment create architecturally invalid block sizes
on 16KB and 64KB page systems?

On 16KB and 64KB systems, 256 * 1024 * PAGE_SIZE evaluates to 4GB and
16GB respectively. Since level 1 blocks are not supported for these
page sizes on ARM64, this exceeds the valid maximums (32MB and 512MB).
If a VMM attempts to restore this configuration, kvm_vm_ioctl_enable_cap()
in arch/arm64/kvm/arm.c will reject it via kvm_is_block_size_supported(),
which breaks live migration.

Additionally, can this cause integer truncation during capability queries?

In arch/arm64/kvm/arm.c:kvm_vm_ioctl_check_extension(), the 64-bit chunk
size is assigned to a 32-bit signed integer. The values 4GB (0x100000000)
and 16GB (0x400000000) will truncate to 0. A VMM querying this capability
would read 0 and restore 0 on the destination, silently disabling the
feature.

[Severity: Medium]
Does this new dynamic default desync with the global capability query?

When userspace queries /dev/kvm via KVM_CHECK_EXTENSION for
KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE without a VM instance,
arch/arm64/kvm/arm.c:kvm_vm_ioctl_check_extension() unconditionally returns
KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT (0).

Since this patch changes the default dynamically for new VMs based on
system_supports_hdbss(), the global API query now misleads userspace about
the default capability.

> +	else
> +		mmu->split_page_chunk_size =3D KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +
>  	mmu->split_page_cache.gfp_zero =3D __GFP_ZERO;
> =20
>  	mmu->pgd_phys =3D __pa(pgt->pgd);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709104026.2612=
599-1-zhengtian10@huawei.com?part=3D1
