Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3442D744
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 14:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212005; cv=none; b=nx1pgR1MC0OokIN3cCPotwv6Zwr1KH9ztuR+GmNJ65BkuRQ9sdNTjnnXynAFwNAIlyZrbA8rjYGqCOk310HShsGSACEOyYdJmZaxHpeTQCLJaA0Zzt3d33bcwegROBIpmdO0JgFLoXp3t8cpUNbMm1xjIxgioq1CleAoA9wlxj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212005; c=relaxed/simple;
	bh=id26l5uZn9xXjo+hd39v9p+tPQ6cugZMHPboE37WPwo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lskMCWwqy1slYb3w0yZ9A/QaFlqPx/oNy7cBCUd3ir8yNV11ujNS9AJ6NFINlHkrjW/pBnidM48k42aUyd1i5qJ0jDsljqs0RgCDxsQS0yAesamc/9tgzKqezNcELrIsspAh2FVNyO1TNEi+MKUbUNBFZ75UI8YB9Ev9SuuwzmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4g+rzQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4g+rzQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2D01F00A3A;
	Thu, 16 Jul 2026 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784212004;
	bh=WFZSMnIAK/XMRcMmMf18WtcrXo81ELPyzU8KOvY/Z30=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g4g+rzQuD6NihoEGJv8xjiqscSCqL/+t5dDzPMixWtzM+Yf0dP2uByAMvdMGUV7+/
	 42a2kcMMYK3lGh9JnxBnoa01lAO+TB6ickFcyj7GaMlp4JcnaiFBSYOzuyi0sJvv/6
	 E70D9L7SF2G7rkypKQzfhfkP12gKwjz0o5/eLIj3vCKgJtHjQbw8R4WP+BOH3dR9iz
	 jrKe1tYrpWIzoXZ6V2cvCF8fLzsyIAM0RTwdbAOWkA3LD770BFS0XnBRf/5Kapomn2
	 Zik18f7ZeFxNyONK3/Y1DGXVbZC5nrQEkHEiIVdH5J5kLSdzwYx0Kmsh25JfCUAvJ0
	 7Yki59QSiopGQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/5] KVM: arm64: Split hyp mapping APIs by address
 type
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260716140936.4003182-3-aneesh.kumar@kernel.org>
References: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
 <20260716140936.4003182-3-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 14:26:43 +0000
Message-Id: <20260716142644.2F2D01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it remains prese=
nt: Treating EL2 page table allocation failure as fatal by wrapping `pkvm_c=
reate_linear_mappings_locked()` in `WARN_ON()`. This converts a recoverable=
 `-ENOMEM` condition into a fatal hypervisor panic.
--

--- Patch [2]: [RFC PATCH 2/5] KVM: arm64: Split hyp mapping APIs by addres=
s type ---
commit 7eb3ee309a427de1a370d3d0ea72c38646079ff1
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

KVM: arm64: Split hyp mapping APIs by address type

This commit replaces create_hyp_mappings() and pkvm_create_mappings()
with explicit symbol and linear-map interfaces to distinguish between
kernel-image symbols and linear-map addresses. It updates all callers
to use the appropriate interface for the address type they provide.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 4e329e39a695a..7f815345d6a56 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1109,7 +1109,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
>  		goto unlock;
> =20
>  	__hyp_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
> -	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
> +	WARN_ON(pkvm_create_linear_mappings_locked(virt, virt + size, PAGE_HYP)=
);

[Severity: High]
This is a pre-existing issue, but wrapping pkvm_create_linear_mappings_lock=
ed()
in a WARN_ON() in __pkvm_host_donate_hyp() converts a legitimate EL2 page t=
able
allocation failure into a fatal hypervisor panic. At EL2, WARN_ON() expands=
 to
BRK, taking down the host. Because userspace processes can exhaust the EL2
memory pool by triggering operations like host memory donation, could this
panic be used for a host denial-of-service attack?

[ ... ]

> @@ -1175,12 +1175,18 @@ int hyp_pin_shared_mem(void *from, void *to)
>  		goto unlock;
> =20
>  	for (cur =3D start; cur < end; cur +=3D PAGE_SIZE) {
> +		void *addr =3D (void *)cur;
> +
>  		p =3D hyp_virt_to_page(cur);
>  		hyp_page_ref_inc(p);
> -		if (p->refcount =3D=3D 1)
> -			WARN_ON(pkvm_create_mappings_locked((void *)cur,
> -							    (void *)cur + PAGE_SIZE,
> -							    PAGE_HYP));
> +		if (p->refcount =3D=3D 1) {
> +			int err;
> +
> +			err =3D pkvm_create_linear_mappings_locked(addr,
> +								 addr + PAGE_SIZE,
> +								 PAGE_HYP);
> +			WARN_ON(err);

[Severity: High]
This isn't a bug introduced by this patch, but similar to the above, wrappi=
ng
pkvm_create_linear_mappings_locked() in WARN_ON() in hyp_pin_shared_mem()
treats a legitimate -ENOMEM condition as fatal. If the EL2 buddy allocator
fails when allocating new page table pages, should this path instead return
the error and gracefully fail the hypercall rather than crashing the
hypervisor?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716140936.4003=
182-1-aneesh.kumar@kernel.org?part=3D2
