Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F5486E7C
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 18:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832238; cv=none; b=k0TTINiv/r2HuoBuNc60c6rlfjzQIgN4jWl7+ICd0P89Zv0ZqqtJIu3Ok0D28ecY6035kCwtCitWyheFLOEAW8Wucl+bCnQambGavMt8zIQChL1BH34Edje0mEhVL7MmxVTogvyht2h0VGV6sj77M+nn5YdOp7uPaPaj+SG9QBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832238; c=relaxed/simple;
	bh=xKJI5dgEjvLx7Aq1soVSpWN2rFU71VW3r3OO/jyyhgY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rk55f5LF4RJkSnOeXONTGwTVpV48WW8rkBKhWusFDjnVR3rPVZZ4GIUcJnv5NunKr4ADEuBqULPF5jlbTbkIjvQB1R+S8doe9/LZ3EA4d+PFQDMf59vJBMH5SKDD6UA6ONjkaDWQmVWkryo/rnuQAckyOYOQEvR8+Sh1IOEQhKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE8F1F000E9;
	Thu, 23 Jul 2026 18:43:46 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 2/2] KVM: arm64: Support BBM level 3
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mostafa Saleh" <smostafa@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260723182140.4025575-3-smostafa@google.com>
References: <20260723182140.4025575-1-smostafa@google.com>
 <20260723182140.4025575-3-smostafa@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 18:43:45 +0000
Message-Id: <20260723184346.CAE8F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing DSB between MTE tag stores and the stage-2 PTE update.
--

--- Patch [2]: [RFC PATCH v2 2/2] KVM: arm64: Support BBM level 3 ---
commit be481f0e17bfc16626c7f5b1b8b652be3ec92909
Author: Mostafa Saleh <smostafa@google.com>

KVM: arm64: Support BBM level 3

If the system supports hardware Break-Before-Make (BBM) level 3, use it
to replace stage-2 PTEs directly. Otherwise, fall back to the software
BBM sequence.

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 127b7f9541b16..5e16ed7e9b909 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -873,16 +891,35 @@ static bool stage2_try_break_pte(const struct kvm_p=
gtable_visit_ctx *ctx,
>  	return true;
>  }
> =20
> -static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm=
_pte_t new)
> +static bool stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, str=
uct kvm_s2_mmu *mmu,
> +			    kvm_pte_t new)
>  {
>  	struct kvm_pgtable_mm_ops *mm_ops =3D ctx->mm_ops;
> =20
> -	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
> -
>  	if (stage2_pte_is_counted(new))
>  		mm_ops->get_page(ctx->ptep);
> =20
> +	if (stage2_use_bbml3() && kvm_pte_valid(ctx->old)) {
> +		/*
> +		 * Barrier is required because stage2_try_set_pte() uses
> +		 * WRITE_ONCE for non-shared walks, lacking release semantics
> +		 * used in the software BBM case.
> +		 */
> +		smp_wmb();
> +		if (!stage2_try_set_pte(ctx, new)) {
> +			/* Raced with another core. */
> +			if (stage2_pte_is_counted(new))
> +				mm_ops->put_page(ctx->ptep);
> +			return false;
> +		}
> +
> +		stage2_clean_old_pte(ctx, mmu);
> +		return true;
> +	}
> +
> +	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
>  	smp_store_release(ctx->ptep, new);
> +	return true;
>  }

[Severity: High]
This is a pre-existing issue, but does this sequence lack a required
synchronization barrier for MTE tag stores?

When KVM maps a page with MTE enabled, it clears the tags using STGM:

arch/arm64/kvm/mmu.c:kvm_s2_fault_map() {
        ...
        if (!perm_fault_granule && !s2vi->map_non_cacheable && kvm_has_mte(=
kvm))
                sanitise_mte_tags(kvm, pfn, mapping_size);
        ...
}

The PTE is then updated here in stage2_make_pte(), which uses either
smp_wmb() + cmpxchg() (mapping to DMB ISHST + CASAL) for BBML3, or
smp_store_release() (mapping to STLR) for the software BBM case. Neither
of these provides the architecturally mandated DSB semantics required
after MTE tag stores.

Without a DSB between sanitise_mte_tags() and the stage-2 PTE update, is
it possible for the hardware page table walker to observe the new PTE
before the explicit tag stores are globally visible? Could this result in
the guest observing uninitialized MTE tags, leading to memory permission
corruption or spurious tag check faults?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723182140.4025=
575-1-smostafa@google.com?part=3D2
