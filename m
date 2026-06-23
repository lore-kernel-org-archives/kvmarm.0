Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D738156C6A
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 16:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782231347; cv=none; b=bYZzIMDBK4C3qIBM0rCSFGBUKpQYPrTmd4volOHXUDEaUnVBzV6qSTlbzKYnC7r4ItsplmWvDj4TPxuMFPrxMeaYtHW/ln2RHBXqLlbz2Fpwaq0T3eG0BbOClFKNXvCMZk/2QS3nW67fXisoNoyRxQ/X84694XsKn6CzIEKiqGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782231347; c=relaxed/simple;
	bh=jjIjoSHEX/0eh8PGp7nMQkV5msG84yMUzxSxI9VwJp8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gGs+zwEV18eXz6Xs+fUQkDpjYjimCXeFHZ9sRtGsgCby++XnsODFxk1ioAPbfMNJi7Lr7uGXM7gsH6pWonmSmFy7ksQuKLNpbCM5tZMYS96mBiLwfMhBr4GRhKxRXJTMmXKSunnxKu7z5NW35Bs5/hicUfvphRGPmqJi/ENSUJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8abtb0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8abtb0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA08E1F000E9;
	Tue, 23 Jun 2026 16:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782231346;
	bh=o3t9/lyB8+nda6TE7MmVJSDSErNOOHD9qhJY8xVFXnc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M8abtb0dUJcAvSw5uxUlSYhzDzERUB5UMeyfAb5d9RxbjxEF6MhH4ADhaiVry/Toi
	 Q2JWuNpexKvCRXNOE4jNC5iYqmNzM0pftC3ddAyDdrIGNRAAHsnpOIZhJm1U0lfz9H
	 ROeRT3KTItsPCvNvbc+LLCnWeklnadVaHPlnkUieXokDmnE8bGp+H39DAPawT1Is9k
	 7adMttdVBWcqxG2EmhxausuJK2t4b/x8J01ysU8IwonrUBbdpEZm5+kapgX75yxKxr
	 rxEOybiO/Pw6rb7VTVIpkhQHQsWpOMMFp62pMGBTJfyD2Dm83X7X4k7XVhlp3Fb3wv
	 Pw3A35KeQ92Hg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: skip pKVM cache flushes for non cacheable
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bradley Morgan" <include@grrlz.net>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260623160339.15143-1-include@grrlz.net>
References: <20260623160339.15143-1-include@grrlz.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 16:15:45 +0000
Message-Id: <20260623161545.EA08E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Handling a permission fault that upgrades a mapping to a huge =
page skips memcache top-up, leading to a NULL pointer dereference in `pkvm_=
pgtable_stage2_map()`.
--

commit d1dad1f606a114503ffa8d910f3c79c232636e5c
Author: Bradley Morgan <include@grrlz.net>

KVM: arm64: skip pKVM cache flushes for non cacheable mappings

This patch adds a cacheable flag to pKVM mappings to avoid flushing
non-cacheable stage 2 mappings. It updates pkvm_pgtable_stage2_map to
record this attribute and pkvm_pgtable_stage2_flush to skip flushing.

[ ... ]

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 053e4f733e4be..efede6b5640e0 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -473,6 +473,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, =
u64 addr, u64 size,
>  	mapping->gfn =3D gfn;
>  	mapping->pfn =3D pfn;
>  	mapping->nr_pages =3D size / PAGE_SIZE;

[Severity: Critical]
This is a pre-existing issue, but could this lead to a NULL pointer
dereference if the memcache wasn't topped up?

In arch/arm64/kvm/mmu.c:user_mem_abort(), topup_mmu_memcache() is skipped
for permission faults when dirty logging is not active:

	memcache =3D get_mmu_memcache(s2fd->vcpu);
	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
			    kvm_is_write_fault(s2fd->vcpu))) {
		ret =3D topup_mmu_memcache(s2fd->vcpu, memcache);
		if (ret)
			return ret;
	}

If a guest triggers a permission fault on an address backed by a transparent
huge page (where the existing stage-2 mapping is a page-level mapping),
kvm_s2_fault_map() will upgrade the mapping to a block and call
pkvm_pgtable_stage2_map().

For non-protected VMs on a pKVM host, pkvm_pgtable_stage2_map() then unshar=
es
the old mapping, sets mapping =3D NULL, and swaps it with cache->mapping:

	swap(mapping, cache->mapping);
	mapping->gfn =3D gfn;

Because the top-up was skipped, cache->mapping is NULL, meaning mapping->gfn
dereferences NULL, allowing an untrusted guest to crash the host.

> +	mapping->cacheable =3D !(prot & (KVM_PGTABLE_PROT_DEVICE |
> +				       KVM_PGTABLE_PROT_NORMAL_NC));
>  	pkvm_mapping_insert(mapping, &pgt->pkvm_mappings);
> =20
>  	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623160339.1514=
3-1-include@grrlz.net?part=3D1
