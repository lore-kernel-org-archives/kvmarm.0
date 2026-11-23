Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432367;
	b=qhXQXqgmpXW85RU5uaTv3q8/REMgAPpPh5ppXNXvcwWsnGKoEHi98P86xuuMKwT0arxc
	 4ckJTqDhuFykqZDyKfm3xCLZt1j/4JxgQ/FiOLDlOqSsvrnj3naSnjKSABHSX4koZfHlq
	 mrLt1HHpiWsaJQks0rDHv3octVvyGRqzjTvcnyh7b8bkgB4Z4bNSzztNpn2Z1PWDR6DIX
	 s4iWZC5Wo1oCglsouOrrrxvudh9UzlkjSy6fM7E06p6vv7xLB5g33bLz17f5h0/PnFOgP
	 of6WsrFLEXWQ6mxd72p3XQm5b68CwDhnVIutWErYXmcE0J3XEaYhtu3ySv0DG6TraJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432367;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qrX5Yr120rUTLIH3qjzb7/7MgZS9LyjgbpraPB20evs=;
	b=HeDm873GCsMR4I5lahEjrNNrAFqNip4sc0ZyK/qZvEbZ0kl0SRa1jXg/yKK3YsH72X98
	 lN0dhcLtxp2Iw3p9NA4HjfC8kkq8SQ/D7xewIOD1m5cjMckOAzLdmT1hC5ePmc4Nk0t2y
	 8hkmR9+SlDVBaO3sj4ioumIh20DWTgqHoA3wkAbiQivbrb12x6tO0W1X4Ck1raLFBCefM
	 eICFyXbzweQCquZQhR1QachyYZZYxLz6jz0oB5yvRaSW0/4Zsv1jJcJ+RRma16xECExc3
	 1bpMMftjKgjuimF5QJNFLJQsv8nLjXa3fFvdblQ/nqcbOwoP2Q3lca0WFVXN4jvxyNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FXCeMz+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8091B606A31A;
	Mon, 23 Nov 2026 11:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FXCeMz+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C221F00A19;
	Mon, 23 Nov 2026 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795432367;
	bh=qrX5Yr120rUTLIH3qjzb7/7MgZS9LyjgbpraPB20evs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FXCeMz+eZQMM2docDa31NKFyzTxyqZVzLaTc3GTul11qsB+2BCebdpLJyTBKaL6KX
	 HXtE1nXl77aMs+LOELK8Rj1dAn1vjBle7iQtxdP+NF912rGD82uRNWqFWd4F36OwE3
	 i6kVNHIyZKH+vSxhavncDRDLJBtYKnp+AHrddG8OwLhEov4BIN3hitDCggAMHXU5B6
	 5WaK5ZzDKK1vdPPxrBEr1Q/p37kPXzEbc029eXTvHfwpIyjX8dgGxHPFEUYhr1V8ls
	 hqPM7olb/fRZaoEtU4hbeb/J5Mis+Q84lGlSSgiiFgjb4lOAcZ03W5EchFdSnlW9ZK
	 nAdtLXLM7iayQ==
Message-ID: <sashiko-outbox-229102@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/11] KVM: arm64: CCA: Add Realm RTT mapping and
 invalidation helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261123104233.95710-8-steven.price@arm.com>
References: <20261123104233.95710-1-steven.price@arm.com>
 <20261123104233.95710-8-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 11:12:46 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] KVM: arm64: cca: direct-reclaim allocation in
  realm_unmap_cache_topup()
- [Medium] KVM: arm64: cca: stale err_level used after
  realm_unmap_cache_topup() failure
- [Low] KVM: arm64: cca: possible RTT creation for unmapped entry in
  realm_unmap_*()
--

commit 4c7e030072ac67c12f0f2603fad3d39821c47426
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Add Realm RTT mapping and invalidation helpers

This commit adds RMI Realm Translation Table creation, folding, and stage-2
unmapping helpers for CCA Realms, including filtered range unmapping for
shared and private memory.

> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 435174ac3d87f..b34f5320b50b6 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c

[ ... ]

> @@ -172,6 +391,208 @@ void kvm_realm_unmap_stage2_all(struct kvm *kvm)
>  	realm->stage2_unmapped =3D true;
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

[Severity: Medium]
When __kvm_mmu_topup_memory_cache() fails, does returning false cause
realm_unmap_shared_range() and realm_unmap_private_range() to pass a stale
err_level to realm_create_rtt_levels()?

Because kvm->mmu_lock was dropped and re-acquired, another thread can fold
the RTT at err_level before the lock is retaken.  The callers only retry
from addr when realm_unmap_cache_topup() returns true; on failure they fall
through to realm_create_rtt_levels(realm, addr, err_level, level, mc).
alloc_rtt() can still succeed from a partially topped-up cache or via
alloc_delegated_granule()'s GFP_ATOMIC fallback (which sets __GFP_HIGH and
force-charges memcg), causing realm_rtt_create() at err_level + 1 to fail
with RMI_ERROR_RTT at an ancestor level < err_level.  That triggers the
WARN() in realm_create_rtt_levels() and returns -ENXIO, hitting
WARN_ON(ret !=3D -ENOMEM) in realm_unmap_shared_range() or KVM_BUG_ON(1, kv=
m)
in realm_unmap_private_range().

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
> +			if (WARN_ON(err_level < realm->start_level ||
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
This question rests on an RMM architectural detail that could not be
confirmed from the kernel source: can SMC_RMI_RTT_UNPROT_UNMAP or
SMC_RMI_RTT_DATA_UNMAP return RMI_ERROR_RTT with err_level < level when the
RTT walk stops at an unassigned ancestor entry (where neither a child RTT
nor a block mapping is present at err_level), rather than advancing
next_addr and returning RMI_SUCCESS?

If so, when unmapping a sub-block range (such as a single page, where
find_map_level() returns KVM_PGTABLE_LAST_LEVEL) across an unmapped ancestor
entry, both realm_unmap_shared_range() and realm_unmap_private_range() only
skip when err_level >=3D level.  For err_level < level, they treat the entry
as a block mapping to split, allocating and delegating intermediate RTTs via
realm_create_rtt_levels() only to fold them back at the end of the function,
and if that allocation fails in realm_unmap_private_range() (for example
under GFP_ATOMIC when may_block is false), it hits KVM_BUG_ON(1, kvm) even
though nothing was mapped.

[ ... ]

> +void kvm_realm_unmap_range_filter(struct kvm *kvm, unsigned long start,
> +				  unsigned long size, bool may_block,
> +				  enum kvm_gfn_range_filter attr_filter)
> +{
> +	/*
> +	 * MMU notifier callbacks cannot take slots_lock, which protects the
> +	 * eager split cache. Use a cache owned by this invalidation instead.
> +	 */
> +	struct kvm_mmu_memory_cache cache =3D { .gfp_zero =3D __GFP_ZERO };

[Severity: Medium]
Can topping up this cache from an MMU notifier callback enter direct reclaim
and trigger a lockdep splat on __mmu_notifier_invalidate_range_start_map?

When mmu_notifier_invalidate_range_start() invokes
kvm_mmu_notifier_invalidate_range_start() -> ... ->
kvm_realm_unmap_range_filter() with may_block set, it holds
__mmu_notifier_invalidate_range_start_map.  Because cache.gfp_custom is left
at 0, realm_unmap_cache_topup() -> __kvm_mmu_topup_memory_cache() allocates
with GFP_KERNEL_ACCOUNT (__GFP_DIRECT_RECLAIM | __GFP_FS), which enters
fs_reclaim_acquire() and acquires __mmu_notifier_invalidate_range_start_map
recursively (and risks reclaim recursion deadlock under memory pressure).
Setting cache.gfp_custom to GFP_NOWAIT | __GFP_ACCOUNT avoids direct reclaim
in the notifier path.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123104233.9571=
0-1-steven.price@arm.com?part=3D7
