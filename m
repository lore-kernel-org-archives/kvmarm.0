Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97693FB07A;
	Wed,  7 Oct 2026 07:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791359362; cv=none; b=YLVpMJL/BMTvlWkojAAwT+ndYD1VdUw8j+bQ/JVBqDgnFQTeY40bB8bx+PYbgw0cIUtoQvEMqJ9VSnhenYz+CfoBzcQbHon/S59eFWnDRRpl6mo7ihxw994+2jnZavocnx94u+uwzlj+QGWmG5SdABYiPfar+V80j6wuUbfEVVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791359362; c=relaxed/simple;
	bh=/bTHk6OwedrgXRgvFNvjxPcUSPnqNc6K2RtLN4Qzvw0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WDNZ7SDmHv05U+jae7qDsB2r2yf9fu3hidoWyVWoJLgG8WBq1LrweIqYwDg35IdreRLyM3i1yRUOmvj6Dif32QYYcwd9ivF85gxwBo73bRhnaWoclgHqSTk9zGXQoGosPLZ/V7hmEH1SUPVSPyzpdXb1IqHIjKsdEcAfEXDEGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMeHDDhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMeHDDhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8D11F0089B;
	Wed,  7 Oct 2026 07:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791359361;
	bh=YEiM+5fjKTGt6cP8vpnwAtOOrexw9tk8Xbpj8p14kG4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LMeHDDhRCqRRFHF+udBCUCQqgafznQg9tkFEdQtfqI3CzbqnCueSTfg6XaKGE+TEc
	 4aVVD2iMz21XWsnZjv7gBYamWzA8kqrucmlyoQ5w9jWBvb9qWgSR4bKMehMAtgIj/0
	 NHnL0g9IrXNoWuEQdx5oqJPN/Zn4MF0LzPJEWarfSRU1nkRMJEqtYrcLf2Yi2zDC1r
	 Hxl/E2DQuiSHNt/PNUp8SD1TpO8VkQXOfK4yYd/YVz37PZqc4SGfNCBzcktdb6HyYg
	 ihAd7kzOCumpgXlNFZnmsEFstrG76JJCcAYgGQXvgUNZy924DRNuPQ0EgJYke5IukK
	 B/6uzpE5iTF1Q==
Message-ID: <sashiko-outbox-162730@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v23 09/14] KVM: arm64: Consolidate stage2 unmap range
 into kvm_stage2_unmap_range
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20261007073537.2454351-10-suzuki.poulose@arm.com>
References: <20261007073537.2454351-1-suzuki.poulose@arm.com>
 <20261007073537.2454351-10-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 07:49:20 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kvm: arm64: UAF in stage2_apply_range() when nested_mmus is reallo=
cated
--

commit f49216e04631aee4e96534b9604d42f899f085d6
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range

This patch simplifies the stage-2 unmap operations by removing
__unmap_stage2_range() and folding its logic directly into
kvm_stage2_unmap_range(). It also updates callers to use the consolidated
function.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ba86450fe4af..3fef16393f568 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -314,36 +314,30 @@ static void invalidate_icache_guest_page(void *va, =
size_t size)
[ ... ]
> -static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t sta=
rt, u64 size,
> -				 bool may_block)
> +void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> +			    u64 size, bool may_block)
>  {
>  	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> -	phys_addr_t end =3D start + size;
> +
> +	if (kvm_vm_is_protected(kvm))
> +		return;
> =20
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	WARN_ON(size & ~PAGE_MASK);
> -	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stag=
e2_unmap),
> -				   may_block));
> -}
> =20
> -void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> -			    u64 size, bool may_block)
> -{
> -	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
> -		return;
> -
> -	__unmap_stage2_range(mmu, start, size, may_block);
> +	WARN_ON(stage2_apply_range(mmu, start, start + size,
> +				   KVM_PGT_FN(kvm_pgtable_stage2_unmap),
> +				   may_block));

[Severity: High]
Does this allow a use-after-free of the kvm->arch.nested_mmus array if
may_block is true?

If kvm_nested_s2_unmap() is called during a memory reclaim event via
kvm_mmu_notifier_invalidate_range_start(), it caches a pointer to an
element of kvm->arch.nested_mmus (e.g., mmu =3D &kvm->arch.nested_mmus[i])
and passes it here with may_block=3Dtrue.

When stage2_apply_range() iterates, it can drop kvm->mmu_lock via
cond_resched_rwlock_write():

stage2_apply_range() {
	do {
		struct kvm_pgtable *pgt =3D mmu->pgt;
		...
		if (resched && next !=3D end)
			cond_resched_rwlock_write(&kvm->mmu_lock);
	} while (addr =3D next, addr !=3D end);
}

Concurrently, could userspace initializing a new vCPU via KVM_ARM_VCPU_INIT
invoke kvm_vcpu_init_nested(), grab kvm->mmu_lock, reallocate the
kvm->arch.nested_mmus array, and free the old one?

kvm_vcpu_init_nested() {
	...
	swap(kvm->arch.nested_mmus, tmp);
	write_unlock(&kvm->mmu_lock);
	kvfree(tmp);
}

If stage2_apply_range() then reacquires the lock, it would dereference
mmu->pgt using the mmu pointer that still points into the now-freed
nested_mmus array.

Can we ensure the array is not freed while we iterate, or refresh the mmu
pointer after reacquiring the lock?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007073537.2454=
351-1-suzuki.poulose@arm.com?part=3D9
