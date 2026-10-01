Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96502345EB8
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 12:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859296; cv=none; b=F7hT08XAxiL+IO+waxGxPLhWqcZNBh53wGnjByha8oWtU8/LwqPypnP4Sy/lMD5yrYsORF/hMupgekPv4Pnvi5TarsQnmbNJM5skYhkb6OO8uZc07O2FVDQ1H6IRJyQsAOqWBX0ZMuqgDCa+nsqgNNpnNkv5DNSNEVbHH+Ez5m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859296; c=relaxed/simple;
	bh=VeDpyDnHOJsUWSbGq7hDUr32xyN76eftlTp/29Frbqs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lqa5irKjiO4A8/YI63D0frCMv+yRdYYzximhi6uWbdzL9tSY9PwKyIIfJItQ4Ye3IEs1OHbwxkX3XjS1dazsAbuSL3MT9sVLxBN8zQfIBM9P4CAH58Z52MPEwpwxTLE+rpIAH8TY0wbVKrDKj/hD8rBWZa1OqejDuuBnfNq64iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jnmHS/m5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jnmHS/m5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD291F000FF;
	Thu,  1 Oct 2026 12:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790859294;
	bh=NkB5Nco+d7wI5keabosTo03tt6TSLZd0NA9Oau/KVE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jnmHS/m5ksBkSjuwvKYlIM7pEtihuLCjO+3t0HFjJ4t1yqkSE/sT00XRImaqVx3Cp
	 e1ZoWYIb/7hJqI0eg9YMjq07lwodibw3gAAR/5OtIgPn0b36yIoqinzHjop3/3ClBT
	 14DTNoU+GDzr4LEhLYRtDdPl34gCsy24i6N0AGjP+W6Ed3XbbMvWp7NBHNwyEn8230
	 DGrkOPKhfEADjad42C/5UUCzgRqnANGVHatxeHx/sUdG320JH+xpsXEOGDYRshAn4w
	 AJPiPwWdmafI2S11rTSEzw81gaD5Fwt9KZrUedvzXrbgbI0fex1dIgRI/gSnTPoi0Y
	 vytm1VF4Nj25A==
From: sashiko-bot@kernel.org
Subject: Re: [RFC 11/12] arm64: tlbid: Pass domain to TLBI instructions
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S3Jpc3RpbmEgTWFydMWhZW5rbw==?= <kristina.martsenko@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20261001110655.461473-12-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-12-kristina.martsenko@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:54:52 +0000
Message-Id: <20261001125453.BBD291F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] arm64: mm: Dekker's algorithm for TLBID domains lacks Store-Load b=
arriers
- [High] kvm: arm64: __tlbi macro incorrectly used for tlbip in ipas2e1is t=
runcating IPA
--

commit f40d982ccca120afa0d082b4e36973eaef03f653
Author: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>
Subject: arm64: tlbid: Pass domain to TLBI instructions

This patch updates the TLB invalidation interfaces to pass a TLBI domain
to TLBI instructions when available, which may improve performance by
sending invalidations only to the necessary subset of CPUs. It uses the
mm domain bitmap to determine the domain and uses TLBIP instructions for
all shareable invalidations.

> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/t=
lbflush.h
> index dac35568570ff..864d7459d5be7 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h

[ ... ]

> @@ -219,22 +222,38 @@ static __always_inline void ipas2e1is(bool tlbip, u=
128 arg)
>  }

[Severity: High]
Does this code incorrectly invoke the 64-bit __tlbi macro instead of the
128-bit __tlbip macro for a TLBIP-formatted argument?

In ipas2e1is(), when tlbip is true, the code calls __tlbi(ipas2e1is, arg)
instead of __tlbip(ipas2e1is, arg). The __tlbi macro expands to a tlbi
assembly instruction which takes a single 64-bit register parameter. The
128-bit arg, which contains the target physical address (IPA) in its upper
64 bits, is silently truncated to 64 bits by the compiler when passed to
the inline assembly constraint.

Could this truncation cause the upper 64 bits containing the IPA to be lost,
resulting in the invalidation of IPA 0 instead of the requested address and
completely breaking stage-2 (guest) TLB invalidation?

[ ... ]

> @@ -418,12 +437,13 @@ static inline void flush_tlb_all(void)
> =20
>  static inline void flush_tlb_mm(struct mm_struct *mm)
>  {
> -	unsigned long asid;
> +	unsigned long arg;
> =20
>  	dsb(ishst);
> -	asid =3D __TLBI_VADDR(0, ASID(mm));
> -	__tlbi(aside1is, asid);
> -	__tlbi_user(aside1is, asid);
> +	arg =3D __TLBI_VADDR(0, ASID(mm));
> +	arg |=3D get_tlbid_domain(mm);

[Severity: High]
Is this barrier sufficient to prevent subsequent MMU Loads from reordering
before the domain Store?

The implementation of TLB invalidation domain tracking relies on a Dekker-l=
ike
synchronization between PTE updates and CPU context switches. The dsb(ishst)
used here acts as a Store-Store barrier.

Since ARM64's weakly ordered memory model allows subsequent Loads (like rea=
ding
the tlbid_domains bitmap) to be reordered before preceding Stores (like the
PTE update), could both threads miss each other's updates?

This might cause a TLB invalidation to skip a CPU that subsequently caches a
stale page table entry, potentially leading to memory corruption or
use-after-free in user space. Would a Store-Load barrier like dsb(ish) be
required here?

[ ... ]

> @@ -626,6 +661,7 @@ static __always_inline void __do_flush_tlb_range(stru=
ct vm_area_struct *vma,
>  {
>  	struct mm_struct *mm =3D vma->vm_mm;
>  	unsigned long asid, pages;
> +	int domain;
> =20
>  	pages =3D (end - start) >> PAGE_SHIFT;
> =20
> @@ -634,21 +670,23 @@ static __always_inline void __do_flush_tlb_range(st=
ruct vm_area_struct *vma,
>  		return;
>  	}
> =20
> -	if (!(flags & TLBF_NOBROADCAST))
> +	if (!(flags & TLBF_NOBROADCAST)) {
>  		dsb(ishst);
> -	else
> +		domain =3D get_tlbid_domain(mm);

[Severity: High]
Similarly, is the dsb(ishst) barrier here sufficient for range TLB
invalidations?

Just as in flush_tlb_mm(), this Store-Store barrier may fail to prevent the
Load of tlbid_domains from reordering before the PTE Store.

> diff --git a/arch/arm64/mm/tlbid.c b/arch/arm64/mm/tlbid.c
> index b44fab2dca20d..c748e710e2ee9 100644
> --- a/arch/arm64/mm/tlbid.c
> +++ b/arch/arm64/mm/tlbid.c

[ ... ]

> @@ -31,6 +59,14 @@ void update_tlbid_domains(struct mm_struct *mm, unsign=
ed int cpu)
> =20
>  	for (int i =3D 0; i < BITS_TO_U64(domain_count); i++)
>  		atomic64_and(cpu_domains[cpu][i], &mm->context.tlbid_domains[i]);
> +
> +	/*
> +	 * Pairs with the DSB before reading tlbid_domains in the TLBI paths.
> +	 * Either a concurrent PTE update is visible to this CPU before it uses
> +	 * the mm, or the PTE updater observes the reduced domain bitmap and
> +	 * includes this CPU in its TLBI.
> +	 */
> +	dsb(ishst);
>  }

[Severity: High]
Is this barrier sufficient on the domain-update side of the Dekker-like
synchronization?

As with the PTE-update side, dsb(ishst) is a Store-Store barrier. Could this
allow subsequent Loads (like executing a speculative page table walk) to
reorder before the preceding domain bitmap Store?

If both the PTE updater and the domain updater use Store-Store barriers, the
Dekker-like synchronization lacks the necessary Store-Load ordering,
potentially leading to missed TLB invalidations.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001110655.4614=
73-1-kristina.martsenko@arm.com?part=3D11
