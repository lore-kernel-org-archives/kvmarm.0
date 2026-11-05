Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918594;
	b=XJBmA36kfp/EJCod+fyuV6i4+G47hhFMCfGCXGcaN6DJDbKW9Ac+mSjJd6jOXl6moiNj
	 YafCi03vqScQPu4BZYDgz9daUntSOlwcAv2KmAD4U16jg8ZCs4oodcdQavGFBHLFGA1ld
	 WepUFaxG2O+EbN/vBsgbHHP5/8FjWN4wrsLHF0TqaA2XUJ2T+B4IkaVYua13oabhLyXfT
	 eF68X6ISI2IbElMjx3i8bxQd2uw7p5ALHu8apoI/X9U+VpsqPj1of0UoA/l+LzSY6iKBg
	 GKaIOKCA00Bgg2t3vZisMokm5tsMZ5BHj/kAWvFZhGMKP54zTJ/QLJRSzGgHCZntYxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918594;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Yhx6VyLPhH0j8fXdVhyebsHvAdPJDgJ0Qj/nS52jd70=;
	b=0Dj3ZY+AYuEFsBtuWFBPFWhdSj/F7Ou9YGOewYSIhfEPs1UYvBYrh9CtESs2qMooryXt
	 hXUWvQi2nDsMpB7EZbmUTb4CJxcs7me4YX8v+IdxsHZ7RC/lyUcfdN8v+/Dh0uy97x99F
	 b2sOzElzKWroIYdP++Cd+Hhr2tSRGiOx2xv2mS1LeW3KxTSUZgBWMQ+0QMwJFnBzlX8lB
	 3NpwjXbzzD26N8HpjT8zmkPiNf2a3e6TAG+o3t92mFPvbhUKVmgoB2enmSfsTFE6Gh59v
	 1ZAoSxKvKBrK+kUBoS18lm6Yokr46VIm60vSbQhW37aekUK+fy7x6uRYZZm56BrYX3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gOSVrtBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59DC606A31B
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gOSVrtBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121171F0089F;
	Thu,  5 Nov 2026 22:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793918593;
	bh=Yhx6VyLPhH0j8fXdVhyebsHvAdPJDgJ0Qj/nS52jd70=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gOSVrtBD4hNvOhqKIPFk0DL4CbCd9YIcklVU8frpZTY+b7NyOCsJyQ6cZ/EybhkBR
	 PCg17BDdDkeax7c1kSNEC/tMp4iG7kQK2kRS7Fpe1opEESRVVSUeCpnW4akPvX1Jk8
	 G/1uuI6I7TM4kFUFbkDr+6jMHWLTtLdIcLRy3XMHtqM9PbMAiIMkEdoDDoT2+ZPj3W
	 pZOaFjWqAlR7uHfkc7IjwB4suI+N6hsCWZq6uMgrQ898VN0O0Ic/PGTOahZWcNkfjM
	 5DkuaZzX5G62JTMCetlza9vM6eelxd/85Z2DRz2Z8x2bnjRbwuuXrmUd69mq7pGTEI
	 f8ZQ78m+BwGXg==
Message-ID: <sashiko-outbox-200326@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: Compute the hyp pool size in 64 bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xuheng Li" <xuheng@cs.columbia.edu>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261105-hyp-pool-and-map-v1-1-756bb5d8e067@cs.columbia.edu>
References: <20261105-hyp-pool-and-map-v1-0-756bb5d8e067@cs.columbia.edu>
 <20261105-hyp-pool-and-map-v1-1-756bb5d8e067@cs.columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 22:43:12 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM: arm64: 32-bit shift overflow in hyp_early_alloc_contig() for =
4 GiB+ pools
--

commit 72d17cd9f535bf2996e0d4ac086eb07a7f6f29ba
Author: Xuheng Li <xuheng@cs.columbia.edu>

KVM: arm64: Compute the hyp pool size in 64 bits

This commit fixes a 32-bit shift overflow in hyp_pool_init() when computing
the byte size of a hypervisor page pool from nr_pages << PAGE_SHIFT on
systems where pool size reaches 4 GiB or more.

> diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nv=
he/page_alloc.c
> index 57f86aa0f82fc..e7c10d2f7b0bf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> +++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
> @@ -233,16 +233,16 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, u=
nsigned int nr_pages,
>  		  unsigned int reserved_pages)
>  {
>  	phys_addr_t phys =3D hyp_pfn_to_phys(pfn);
> +	u64 size =3D (u64)nr_pages << PAGE_SHIFT;
>  	struct hyp_page *p;
>  	int i;
> =20
>  	hyp_spin_lock_init(&pool->lock);
> -	pool->max_order =3D min(MAX_PAGE_ORDER,
> -			      get_order(nr_pages << PAGE_SHIFT));
> +	pool->max_order =3D min(MAX_PAGE_ORDER, get_order(size));
>  	for (i =3D 0; i <=3D pool->max_order; i++)
>  		INIT_LIST_HEAD(&pool->free_area[i]);
>  	pool->range_start =3D phys;
> -	pool->range_end =3D phys + (nr_pages << PAGE_SHIFT);
> +	pool->range_end =3D phys + size;

[Severity: High]
Does hyp_early_alloc_contig() need the same 64-bit cast when carving out
the backing memory for these pools?

Before hyp_pool_init() is called in __pkvm_init_finalise() and
prepare_s2_pool(), __pkvm_init() -> divide_memory_pool() allocates
vmemmap_base, hyp_pgt_base, and host_s2_pgt_base via
hyp_early_alloc_contig():

arch/arm64/kvm/hyp/nvhe/setup.c:divide_memory_pool() {
	...
	nr_pages =3D hyp_vmemmap_pages(sizeof(struct hyp_page));
	vmemmap_base =3D hyp_early_alloc_contig(nr_pages);
	if (!vmemmap_base)
		return -ENOMEM;
	...
	nr_pages =3D hyp_s1_pgtable_pages();
	hyp_pgt_base =3D hyp_early_alloc_contig(nr_pages);
	if (!hyp_pgt_base)
		return -ENOMEM;

	nr_pages =3D host_s2_pgtable_pages();
	host_s2_pgt_base =3D hyp_early_alloc_contig(nr_pages);
	...
}

In hyp_early_alloc_contig(), nr_pages is also an unsigned int shifted in
32 bits before conversion to unsigned long:

arch/arm64/kvm/hyp/nvhe/early_alloc.c:hyp_early_alloc_contig() {
	unsigned long size =3D (nr_pages << PAGE_SHIFT);
	void *ret =3D (void *)cur;

	if (!nr_pages)
		return NULL;

	if (end - cur < size)
		return NULL;

	cur +=3D size;
	memset(ret, 0, size);

	return ret;
}

When nr_pages reaches 4 GiB worth of pages on systems with around 2 TiB or
more of RAM, size in hyp_early_alloc_contig() overflows in 32 bits and cur
advances by the truncated size, placing vm_table_base, hyp_pgt_base,
host_s2_pgt_base, and ffa_proxy_pages at overlapping physical addresses.
With hyp_pool_init() now initializing hpool and host_s2_pool across the
full 64-bit size, won't the pools overrun their truncated early allocations
and corrupt the adjacent regions during pKVM initialization?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-hyp-pool-a=
nd-map-v1-0-756bb5d8e067@cs.columbia.edu?part=3D1
