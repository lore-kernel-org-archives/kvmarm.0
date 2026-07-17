Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127C73BFAE8
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784294139; cv=none; b=IU/dTsFNIXilm1vfNTW86KNCQvgQH+r/Yo75uOlbztT3CErnydeEkuFEFjbjxcHUu/19KCZDSfUwpC+3xT1SFrZtUG8zT9JgCgO/9T7URlU+r7O4yMfvWgZvUjHHmK0cQNvkD36m1GxEKcWcJeCi4AC2mcQuFtBwHPge9q6buCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784294139; c=relaxed/simple;
	bh=1kmxQLfeGjYL+3vEnHaKyxl8f1n+8QMmywryUbdgv0o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cRqHPsw5/NfBcVYByqLdTMI8LLWb4TlbhMx/2SsS+Gh3SXQ9ajiy1reiDyMxicXJQhv7OXTHYIv+pN2ie2b7RKoTqq8d0+5nURAaHxhWoOdVaXyd28n/V1HkqllNTZoShoH6DjR/DwDQlBaAqbfgjeth7uT0BubutEcGtxo+/rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTD+s6kW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTD+s6kW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F531F000E9;
	Fri, 17 Jul 2026 13:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784294137;
	bh=JH7j/oFn9Zuc5/GOG4swBwaMuviuktwDHCn+Nw9zQaI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hTD+s6kWGZ80vFwx69V9hyvDRR6Lnde93ugoLlzECR5i558mDfNV1Dqz/1HbUZq2o
	 mYQqtua6Kf4IvJclUolrxRRgsbWgGGky/YzZVVFov/He/yVwXK+Rbl4wKFCcQ14XJN
	 yIpcUCo9XUZsDay8WGNKtBicYRLVw32mcH47qxa9XOoKzDzcpCpUgx7oAS4t+j88pL
	 rQpe7m+qUxIFjffD4eQa7/2IHhfmP2aiHIX3n9oUHGasPlLBNwKWbH8cczh341mKGV
	 P6IB+XiVuPdhWgiIemQTJUYxYWD+VPpD/Y550SLREOIj5Q0C7K7Nyr90Xy+L8+1/OT
	 AVXfpiWlLw77Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/7] KVM: arm64: Top up stage-2 memcache for dirty
 logging faults
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260717130317.1953574-4-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
 <20260717130317.1953574-4-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 13:15:37 +0000
Message-Id: <20260717131537.71F531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A malicious nested (L1) guest can crash the KVM host via a Break-B=
efore-Make (BBM) violation that triggers a BUG_ON() due to an empty memory =
cache during a permission fault.
--

--- Patch [3]: [PATCH v5 3/7] KVM: arm64: Top up stage-2 memcache for dirty=
 logging faults ---
commit bac5488834df4c0a16b08356c8263e8eb67e0fe4
Author: Bradley Morgan <include@grrlz.net>

KVM: arm64: Top up stage-2 memcache for dirty logging faults

Dirty logging forces new stage-2 mappings to page size but does not always
split an existing block first. A non-write permission fault on such a block
still needs a page-table page to split it, but the top-up was previously
gated on write faults. This patch tops up the memcache for any permission
fault while dirty logging is active.

Link: https://lore.kernel.org/all/20260623165634.699011F000E9@smtp.kernel.o=
rg/

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 4d7c9bdcef004..74e7e7f7564c8 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2113,14 +2113,13 @@ static int user_mem_abort(const struct kvm_s2_fau=
lt_desc *s2fd)
>  	 * Permission faults just need to update the existing leaf entry,
>  	 * and so normally don't require allocations from the memcache. The
>  	 * only exception to this is when dirty logging is enabled at runtime
> -	 * and a write fault needs to collapse a block entry into a table.
> +	 * and a fault needs to collapse a block entry into a table.
>  	 * Under pKVM a permission fault can also collapse pages into a block,
>  	 * which needs a fresh mapping object, and the hypervisor requires the
>  	 * min-pages memcache even when the install allocates nothing.
>  	 */
>  	memcache =3D get_mmu_memcache(s2fd->vcpu);
> -	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
> -			    kvm_is_write_fault(s2fd->vcpu)) ||
> +	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
>  	    is_protected_kvm_enabled()) {

[Severity: High]
This is a pre-existing issue, but does skipping the memcache top-up here
leave the host vulnerable to a crash from a malicious nested L1 guest?

If a nested L1 guest establishes a 2MB stage-2 block mapping, and then
maliciously overwrites it with a 4KB page table descriptor without issuing
a TLBI (an architectural Break-Before-Make violation), an L2 guest can
trigger a permission fault on the stale 2MB shadow mapping.

Since KVM optimizes permission faults by assuming they only relax
permissions, the memcache top-up is skipped here.

However, in kvm_s2_fault_map(), if the mapping size and fault granule
don't match:

arch/arm64/kvm/mmu.c:kvm_s2_fault_map()
    ...
	} else {
		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_=
size,
							 __pfn_to_phys(pfn), prot,
							 memcache, flags);
	}
    ...

kvm_pgtable_stage2_map() will attempt to split the block, which requires
a new page table allocation. Because the cache wasn't topped up,
kvm_mmu_memory_cache_alloc() will hit WARN_ON(!mc->nobjs) and fall back
to a GFP_ATOMIC allocation. If this atomic allocation fails under memory
pressure, it hits BUG_ON(!p) and crashes the host.

>  		ret =3D topup_mmu_memcache(s2fd->vcpu, memcache);
>  		if (ret)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717130317.1953=
574-1-fuad.tabba@linux.dev?part=3D3
