Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869C36F8EE
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753073; cv=none; b=ezmK27yx/IprTrqtU/sLf9trDQS5sKDzvoCvR8CoNfmlhx6Jkpw9DiG3xL92xnyrgRo7OVNTayr0gbJwUSTOerShYgZ+RtRMvXd3t4wEyu6pJ9OZPqfeko3gYs7so/18IuuUYVsM++zJX2tWl+/5GVLJAeIi9gFm7A9Fn5pUAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753073; c=relaxed/simple;
	bh=VAvxCc83HuXV3/8rkM9Dre04IlNONlxNdQv2J+Nne7c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NIjhotNh2Xa5XEC5Kq1j0bL17Q9w3yEelOkXby2zhRErccy6pyB76Py1er3/12mgtPbs5XXoaBd38zwsDjTLR80GVItHXj9uAMymIGHDdvEvtA5uP3Vsf1qOYYF4aOb/67DTHpKzzAxTR4Jlqu0oe+0zyInNYB1eUnaS75GTkuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4f4PSb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4f4PSb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6D01F000E9;
	Mon,  3 Aug 2026 10:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785753071;
	bh=PGYQP0Ko+MBwqKHydM4uV8aCpBYe0gLt2fUKQujaLjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T4f4PSb2LgI2ZbVfDJKR+1mo38OqSlYBqVAQu8exhpEHrnFwe8j6KF03FIdqF+OHe
	 LoKv4QS5IRs7mOBv+xwrGkm2a2hh9dfJ4vr3/f0ECKWNla7ClxU6fw6c7USPLHqAet
	 Tl50EvGNfkFRbv5cjeVyGea8AhMI2YV7SpbT8eBkGsAiyMVYMp5DrklWF2yEdMyAVQ
	 8LxuHYpBc8j3xg1jpAteVB8gXr9Tl6zS9mJt6QhocDbJUKTyXpg1VKDF/3Cij62Koz
	 U2TB5yeUKl+QBw4AZAxn4veyHMRXgXtXe/MvqykgdSivQisBcrhxsEX9B9AMXX4tLF
	 nFX0oARqq6lwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/20] KVM: arm64: Prefault host stage-2 entries on
 block split
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260803100904.3563942-2-vdonnefort@google.com>
References: <20260803100904.3563942-1-vdonnefort@google.com>
 <20260803100904.3563942-2-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 10:31:11 +0000
Message-Id: <20260803103111.9B6D01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Missing page table reference count increments for prefaulted P=
TEs leads to a Use-After-Free of the page table and hypervisor panics.
- [Critical] Early return on invalid PTEs silently drops pKVM page ownershi=
p metadata, reverting guest memory to host ownership.
--

--- Patch [1]: [PATCH 01/20] KVM: arm64: Prefault host stage-2 entries on b=
lock split ---
commit ddbd017ec6a553952eac0f275c98da410f8a6cdb
Author: Keir Fraser <keirf@google.com>

KVM: arm64: Prefault host stage-2 entries on block split

For the host stage-2 that is idmap, we can avoid lazy-mapping on block
splitting by propagate existing valid mappings to neighbouring entries
of the new table.

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b74dd5ce1efd3..34f78a58cded0 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1030,10 +1030,39 @@ static int stage2_map_walk_table_pre(const struct=
 kvm_pgtable_visit_ctx *ctx,
>  	return 0;
>  }
> =20
> +static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx=
 *ctx, kvm_pte_t *ptep)
> +{
> +	kvm_pte_t block_pte =3D ctx->old;
> +	u64 pa;
> +	int i;
> +
> +	if (!kvm_pte_valid(block_pte))
> +		return;

[Severity: Critical]
Does this early return risk dropping pKVM page ownership metadata?

In pKVM, host stage-2 page tables encode page ownership and sharing metadata
using invalid but "counted" PTEs. If a block mapping containing such metada=
ta
needs to be split, returning early here skips populating the child table for
these PTEs. The child table entries would remain zero-filled, which in pKVM
denotes unannotated host-owned memory, potentially allowing the host to
re-acquire guest memory.

> +
> +	pa =3D ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
> +	for (i =3D 0; i < PTRS_PER_PTE; ++i, ++ptep, pa +=3D kvm_granule_size(c=
tx->level + 1)) {
> +		kvm_pte_t pte =3D kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + =
1);
> +
> +		/*
> +		 * Skip ptes in the range being modified by the caller if we're
> +		 * installing last level entries. Otherwise, we need to
> +		 * temporarily put in a valid mapping to make sure the
> +		 * prefaulting logic is triggered on the next
> +		 * stage2_map_walk_leaf(). This adds an unnecessary TLBI as
> +		 * we'll presumably re-break the freshly installed block, but
> +		 * that should happen very infrequently.
> +		 */
> +		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
> +		    (pa < ctx->addr) || (pa >=3D ctx->end))
> +			*ptep =3D pte;

[Severity: Critical]
Could this lead to a premature freeing of the child page table?

When pre-populating the new child table with valid (and therefore "counted")
PTEs, the refcount of the newly allocated child page table is not increment=
ed
via ctx->mm_ops->get_page(ptep).

Since the refcount remains at 1 regardless of the number of valid PTEs
written here, any subsequent unmap or break of one of these PTEs will drop
the refcount to 0. This could cause the EL2 buddy allocator to free the page
table while it is still linked and in use by the hardware MMU.

> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803100904.3563=
942-1-vdonnefort@google.com?part=3D1
