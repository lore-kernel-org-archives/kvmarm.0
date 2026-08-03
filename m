Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84513672BF
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753631; cv=none; b=VrSyy+/8T1P55RlCrWn2y8mqiM0k4SjDRxWn3RY5SMZQcSqW7iuWOzVbAzAEJH5UWnr+KRYUOIAYJDVmxIWFLIxDRlzCUOqYZtTfrUc1HUnIiX+j4wbhSfIGqv5Sd3fJfraAOAYQwE/ORMqBdCu4JwGvZPJcNA1vgbG/jrG8Wno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753631; c=relaxed/simple;
	bh=2dqRuwcaLEis4+w3PArXZ12uJ0CzJ3Cc2vbxJa06dOc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TnZeLIJOKOSrWiLcaGVqtJzbxjXLuYkzUu9mfP7P58/ZA88DVkBjK7qxEytbncCad+GaJVLazQpZHDPt4S0ZvEWMt64lWd1/j0TCxAgjQKRf1ogVKmE+jdF94yeF9dod2g4mEo1nvdH9gHLoPG3nL7P4Tu7ERLhEhlp0DiNT1LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=borPrPVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="borPrPVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402C91F000E9;
	Mon,  3 Aug 2026 10:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785753629;
	bh=dWuE4B9w1Nm8kdW27/ze27zW1kYhOuyYNyEviiguCow=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=borPrPVt/hSZHRgAIrK34kftVmX8YhZDWWv3XcA8ijmMMTq5vtrzrYZCixa7tS4/R
	 hb4MyEUmrXVQvPXFaqWQowpxEmLZDaaGnC+DRjwP4klTBEmjdhk5OEYz3sHJdnMeG9
	 ArkO4wZgNsxKaq+eVIS6WZDRqSAKlL9SURuTOgI+4yYkFP4SD/AaYFXzPKRoRVMydK
	 Y6HWzBdyh7SHOd1ZEL8ujic78zY1S5ceOVfWs0+/IuQjn4fAJw16+XxIBFzExHu6Qr
	 QNYShRNCKsg9nS6lwjz6hzDE/QixQSnSeMllbpmH6lgQzumgUcADVYAdusXa4MnQ4F
	 EL6NyKGx0PeIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/20] KVM: arm64: Allow block-level stage-2 annotation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260803100904.3563942-4-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-4-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:40:28 +0000
Message-Id: <20260803104029.402C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Splitting a block-level annotation PTE clones the base GFN to =
all sub-pages, corrupting metadata for trailing pages. Additionally, multi-=
page annotations that fallback to page-level entries duplicate the base GFN.
- [High] Allowing block-level stage-2 annotations causes a hypervisor panic=
 during page reclaim due to an unhandled `WARN_ON` at EL2 that expects page=
-level annotations.
- [Medium] Uninitialized `data->phys` in `kvm_pgtable_stage2_annotate()` ca=
uses artificial fragmentation into 4KB pages for unaligned annotation regio=
ns.
--

--- Patch [3]: [PATCH 03/20] KVM: arm64: Allow block-level stage-2 annotati=
on ---
commit fa0abe8958af15457c75292a24fd1c05d6574ec0
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Allow block-level stage-2 annotation

On host to guest donation, pKVM annotates the host stage-2 invalid
entries with the GFN. Now that the host stage-2 preserves annotations on
block split, we can allow these annotations at block-level. This enables
safe support for guest stage-2 huge mappings.

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 0ca157ecee641..c4ebae0544d4e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -1178,7 +1175,6 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable =
*pgt, u64 addr, u64 size,
>  	struct stage2_map_data map_data =3D {
>  		.mmu		=3D pgt->mmu,
>  		.memcache	=3D mc,

[Severity: Medium]
Does leaving data->phys uninitialized here cause artificial fragmentation
for unaligned annotation regions?

Since map_data is zero-initialized, map_data.phys defaults to 0. Later,
when stage2_leaf_mapping_allowed() checks if a block mapping is supported,
it calculates:

arch/arm64/kvm/hyp/pgtable.c:stage2_leaf_mapping_allowed() {
    ...
    u64 phys =3D stage2_map_walker_phys_addr(ctx, data);
    ...
    return kvm_block_mapping_supported(ctx, phys);
}

This evaluates to (0 + (ctx->addr - ctx->start)). The check then verifies
IS_ALIGNED(phys, granule). Because ctx->addr must already be block-aligned,
this effectively forces ctx->start to also be block-aligned.

If a huge annotation request starts at an unaligned address but spans
complete blocks internally, could this cause those internal blocks to be
forcibly mapped at page-granularity, using excess host memory?

> -		.force_pte	=3D true,

[Severity: High]
By removing the .force_pte assignment, this allows host-to-guest donations
to be mapped as block-level annotations. Does this conflict with
host_stage2_get_guest_info() in arch/arm64/kvm/hyp/nvhe/mem_protect.c?

That function appears to strictly assume annotations are mapped at page
granularity:

arch/arm64/kvm/hyp/nvhe/mem_protect.c:host_stage2_get_guest_info() {
    ...
    if (WARN_ON(level !=3D KVM_PGTABLE_LAST_LEVEL))
    ...
}

Since WARN_ON() expands to a fatal BRK instruction at EL2 in pKVM, if
userspace triggers a stage-2 fault on a donated trailing page (e.g., by
passing it to a syscall), the fault handler invokes
pkvm_force_reclaim_guest_page() which eventually hits this WARN_ON.
Could this allow userspace to crash the hypervisor?

[Severity: Critical]
Also, when a block-level annotation is allowed, does this cause metadata
corruption if the block is later split?

When the generic split logic in stage2_map_prefault_idmap() splits a block,
it copies the block PTE verbatim into all child PTEs:

arch/arm64/kvm/hyp/pgtable.c:stage2_map_prefault_idmap() {
    ...
    kvm_pte_t pte =3D valid ? kvm_init_valid_leaf_pte(pa, block_pte, ctx->l=
evel + 1) : block_pte;
    ...
}

Since pKVM encodes the base GFN in the extra meta bits of the annotation,
this clones the base GFN into all 512 sub-pages without advancing it.

Similarly, if a multi-page annotation falls back to page-level entries in
stage2_map_walker_try_leaf(), it assigns the exact same GFN to all entries:

arch/arm64/kvm/hyp/pgtable.c:stage2_map_walker_try_leaf() {
    ...
    new =3D data->pte_annot;
    ...
}

If the host later reclaims a trailing page, EL2 might read the duplicated
base GFN, retrieve the wrong base physical address, and hit the
WARN_ON(pa !=3D phys) panic in __pkvm_host_force_reclaim_page_guest().

>  		.annotation	=3D true,
>  		.pte_annot	=3D pte_annot |
>  				  FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK, type),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D3
