Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794849690;
	b=206aATvquxj/W/uU3+tgUUtbj9byoGcnYBS33zhr4YKl/2dbEJ3ylwnrk5pmbFx90YX+
	 GPZnNtiUh1nOX6CDPJR72U4tN9I+c9slimtUeSd3/KUW78BRllCvZqRKlfmm+50ga4PPS
	 liQxi9J056f1o17U/OIyJkSPkBGpdvmD+iQwK5b/G1FRY/8Na+0inHhX79lqXMquItb7Z
	 V9Tgglh+Sj11YfQiSDfKNzZrsHjeuiVtn2CEosxWLC5k8doFP9UzPPxUn2rcc2fdw1Qsd
	 q4ah5NXz/auV2ErwbLUg7Pwz20lhD4MIC2eDnFrNDrRNiUoAaWzcRd03nnTs0F/psGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794849690;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=j75at18rCjR96SJm5d4KHznyj5t/r0fXhk3Lw/fMLh8=;
	b=r9pYo0ER5y/kmCmmzYFpKnh0TiB7ieCJPvIkeRMJv1PeWcOc0sHMo4uKTWmjGv+m6lxN
	 aBsr620RclZI4efvKhdcO2kG9jKuUl5RvyHfm+VtIEIyT9Fk2BmrL1F316TxIWwX5q3FC
	 u3tA6ftEUbG07YJ3j8SKNLh24ooFBfKxcBtRK+ZX1BzocoFFIG5CuZHYcU1z25Ma1UZrG
	 CO4QxZTfRbM+iSENNX74zMEHHfbmsxoay0ABc2/MM++xA2kdq0pZvTfdahifhOWr5oyZE
	 LDOJxWkGy0VVB2UJBVfy7YDsW4jE4WyjZ0O55zWJ2XUqO+vnS80MFql7OIYBlN8bipw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eX8oP2W+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C832606A31C;
	Mon, 16 Nov 2026 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eX8oP2W+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131151F000C4;
	Mon, 16 Nov 2026 17:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794849690;
	bh=j75at18rCjR96SJm5d4KHznyj5t/r0fXhk3Lw/fMLh8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eX8oP2W+F332i1P26+DtZOmXhN8NJyQeiJugMvewK1aF6AbovyU8Hzs9RLCboNtEI
	 7wGeFNRugxncotu0nqtxbXMsVRENoyFT0IgCiMLZmomeKXvVyjTrEXAzmfFXjpBKBt
	 W0v8bk7d04t7GwmmO2tLCbRtGOsGTXhkFYH2tgpMnxxaQPQ7BFtfByK2E222evCu/o
	 CQOTS+yyWMtkSGr1fD0PmMd8EOudn9onDs84ZeP0EQt5hjNQsjJL/9NBrQ5TsSJuxa
	 5Xfy/4MQRh5pGhWG5O0gDH3IcK8vDIRWXrb1SZ/3BOj8EYwaHMlew3ncuqjbukM1wX
	 VDbGTiXujD0Tw==
Message-ID: <sashiko-outbox-217428@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261116164358.142785-7-steven.price@arm.com>
References: <20261116164358.142785-1-steven.price@arm.com>
 <20261116164358.142785-7-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 17:21:29 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [Medium] KVM: arm64: cca: broken split-failure fallback in
  realm_unmap_*_range()
- [Medium] KVM: arm64: cca: stale err_level after
  realm_unmap_cache_topup() failure
- [Medium] KVM: arm64: cca: get_start_level() misses 2-level minimum on
  64K pages
- [Medium] KVM: arm64: KVM_BUG_ON() on -ENOMEM in
  realm_unmap_private_range()
- [Low] KVM: arm64: cca: possible RTT creation for unmapped entry in
  realm_unmap_*()
--

commit 453fd020abf481912e2fee6d2f403740b481af92
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers

This commit adds RMI RTT creation, folding, and unmap helpers for CCA
Realm stage-2 shared and private address ranges.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 74b89da4e8015..838f95c201ada 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c

[ ... ]

> @@ -154,12 +291,94 @@ static int realm_tear_down_rtt_range(struct realm *=
realm,
>  					 start, end);
>  }
> =20
> +/*
> + * Returns 0 on successful fold, a negative value on error, a positive v=
alue if
> + * we were not able to fold all tables at this level.
> + */
> +static int realm_fold_rtt_level(struct realm *realm, int level,
> +				unsigned long start, unsigned long end)
> +{
> +	int not_folded =3D 0;
> +	ssize_t map_size;
> +	unsigned long addr, next_addr;
> +
> +	if (WARN_ON(level > KVM_PGTABLE_LAST_LEVEL))
> +		return -EINVAL;

[Severity: Medium]
On a CONFIG_ARM64_64K_PAGES kernel, can realm_fold_rtt_level() be called
with level =3D=3D 4 and trigger this WARN_ON()?

For a 32-bit or 33-bit IPA, stage2_pgtable_levels(realm->ia_bits) returns
1 on 64K pages, so get_start_level() returns 4 - 1 =3D 3
(KVM_PGTABLE_LAST_LEVEL) even though kvm_get_vtcr() clamps stage-2 tables
to at least 2 levels (start_level =3D 2).  When realm_unmap_shared_range()
or realm_unmap_private_range() then calls realm_fold_rtt_level(realm,
get_start_level(realm) + 1, start, end), level is 4, triggering the
warning and skipping RTT folding (and similarly in
realm_tear_down_rtt_range()).

[ ... ]

> @@ -189,6 +408,208 @@ int kvm_realm_teardown_stage2(struct kvm *kvm)
>  	return 0;
>  }
> =20
> +static bool realm_unmap_cache_topup(struct kvm *kvm,
> +				    struct kvm_mmu_memory_cache *mc, int needed)
> +{
> +	int ret;
> +
> +	if (!mc || kvm_mmu_memory_cache_nr_free_objects(mc) >=3D needed)
> +		return false;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +	write_unlock(&kvm->mmu_lock);
> +	ret =3D __kvm_mmu_topup_memory_cache(mc, KVM_PGTABLE_LAST_LEVEL, needed=
);
> +	write_lock(&kvm->mmu_lock);
> +
> +	return !ret;
> +}
> +
> +static void realm_unmap_shared_range(struct kvm *kvm,
> +				     unsigned long start,
> +				     unsigned long end,
> +				     bool may_block,
> +				     struct kvm_mmu_memory_cache *mc)
> +{
> +	struct realm *realm =3D &kvm->arch.realm;
> +	unsigned long rd =3D realm->rd_phys;
> +	unsigned long next_addr, addr;
> +	unsigned long shared_bit =3D BIT(realm->ia_bits - 1);
> +
> +	if (start >=3D end)
> +		return;
> +
> +	/*
> +	 * Callers may pass either an IPA range or its shared alias. Add the
> +	 * shared bit only for the former. Use addition so an exclusive end at
> +	 * shared_bit advances to the end of the IPA space.
> +	 */
> +	if (start < shared_bit) {
> +		start +=3D shared_bit;
> +		end +=3D shared_bit;
> +	}
> +
> +	for (addr =3D start; addr < end; addr =3D next_addr) {
> +		long ret;
> +
> +		ret =3D rmi_rtt_unprot_unmap(rd, addr, end, RMI_ADDR_TYPE_NONE,
> +					   0, &next_addr, NULL, NULL);
> +		if (WARN_ON(ret < 0))
> +			return;
> +
> +		switch (RMI_RESULT_STATUS(ret)) {
> +		case RMI_SUCCESS:
> +			break;
> +		case RMI_ERROR_RTT: {
> +			int err_level =3D RMI_RESULT_DATA_LEVEL(ret);
> +			int level =3D find_map_level(realm, addr, end);
> +
> +			if (WARN_ON(err_level < get_start_level(realm) ||
> +				    err_level > KVM_PGTABLE_LAST_LEVEL))
> +				return;
> +
> +			if (err_level >=3D level) {
> +				/* Nothing present, so skip */
> +				next_addr =3D ALIGN(addr + 1,
> +						  kvm_granule_size(err_level));
> +				break;
> +			}

[Severity: Low]
This question rests on an RMM architecture detail that could not be
confirmed from the kernel source: can SMC_RMI_RTT_UNPROT_UNMAP or
SMC_RMI_RTT_DATA_UNMAP return RMI_ERROR_RTT with err_level < level when
the RTT walk stops at an unassigned ancestor entry (where neither a child
RTT nor a block mapping exists), rather than advancing next_addr across
the unmapped ancestor and returning RMI_SUCCESS?

If yes, unmapping a sub-block range (such as a single page where level is
KVM_PGTABLE_LAST_LEVEL) in an unpopulated region will fall through to
realm_create_rtt_levels() in both realm_unmap_shared_range() and
realm_unmap_private_range(), allocating and delegating intermediate RTTs
only to fold them again at the end of the function, and hitting
KVM_BUG_ON(1, kvm) in realm_unmap_private_range() if that allocation
fails.

> +
> +			if (may_block && realm_unmap_cache_topup(kvm, mc,
> +								 level - err_level)) {
> +				next_addr =3D addr;
> +				break;
> +			}
> +
> +			ret =3D realm_create_rtt_levels(realm, addr, err_level,
> +						      level, mc);

[Severity: Medium]
Can realm_create_rtt_levels() run with a stale err_level if
__kvm_mmu_topup_memory_cache() fails inside realm_unmap_cache_topup()?

When the cache has fewer than needed objects and topup fails with
-ENOMEM, realm_unmap_cache_topup() still drops and re-acquires
kvm->mmu_lock before returning false.  If another thread folds or modifies
the RTTs while mmu_lock is dropped, continuing into
realm_create_rtt_levels() with the pre-unlock err_level (in both
realm_unmap_shared_range() and realm_unmap_private_range()) can fail with
RMI_ERROR_RTT at an ancestor level and trigger the WARN() in
realm_create_rtt_levels().

> +			if (!ret) {
> +				/* Retry with the RTT levels in place. */
> +				next_addr =3D addr;
> +				break;
> +			}
> +			WARN_ON(ret !=3D -ENOMEM);
> +
> +			/* Splitting failed; unmap the entire existing block. */
> +			next_addr =3D ALIGN_DOWN(addr, kvm_granule_size(err_level));
> +			end =3D max(end, next_addr + kvm_granule_size(err_level));
> +			break;

[Severity: Medium]
If realm_create_rtt_levels() fails partway through a multi-level split
(for example, after creating a level-2 RTT to split a 1 GiB level-1 block,
then failing with -ENOMEM at level 3), doesn't this fallback use the
initial err_level and widen the unmap to the full 1 GiB block instead of
the 2 MiB block at the last level created?

Also, when next_addr is aligned down below start, start is not updated, so
the realm_fold_rtt_level() call after the loop starts at the original
start and skips folding RTTs in [next_addr, start).  Both issues also
apply to the fallback in realm_unmap_private_range().

[ ... ]

> +static void realm_unmap_private_range(struct kvm *kvm,
> +				      unsigned long start,
> +				      unsigned long end,
> +				      bool may_block,
> +				      struct kvm_mmu_memory_cache *mc)
> +{

[ ... ]

> +			ret =3D realm_create_rtt_levels(realm, addr, err_level,
> +						      level, mc);
> +			if (!ret) {
> +				next_addr =3D addr;
> +				break;
> +			}
> +
> +			/* A failed split cannot leave the backing pages mapped. */\n> +			KV=
M_BUG_ON(1, kvm);

[Severity: Medium]
Can an RTT allocation failure (-ENOMEM) in realm_create_rtt_levels()
trigger a host WARN_ON_ONCE() via KVM_BUG_ON()?

Both __kvm_mmu_topup_memory_cache() and alloc_delegated_granule() use
__GFP_ACCOUNT, so a host VMM hitting its memcg limit or host memory
pressure can cause realm_create_rtt_levels() to return -ENOMEM.  Unlike
realm_unmap_shared_range(), which guards its warning with WARN_ON(ret !=3D
-ENOMEM), KVM_BUG_ON(1, kvm) unconditionally warns even on -ENOMEM; using
WARN_ON(ret !=3D -ENOMEM) and marking the VM dead or bugged without warning
on allocation failure would avoid a user-triggerable kernel warning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116164358.1427=
85-1-steven.price@arm.com?part=3D6
