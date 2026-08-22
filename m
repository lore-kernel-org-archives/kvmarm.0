Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D8D345ED0
	for <kvmarm@lists.linux.dev>; Sat, 22 Aug 2026 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787421773; cv=none; b=rVgzcJs/MFAFOtLoqQ0TyvHsmmKVoFuT5hIbiTo5Q+dLpXhxm0PhGqDLqc7t6rBDwqN8/DvkmGhKkA8OyV7RVU1blls4z6xxBRl/8VzkLQ8aFWgh32pXv7/A8gDuzjCN9uvNm/XcwtJdVRlYgQ++VhGVzevmlKQEWGNTzUjzPjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787421773; c=relaxed/simple;
	bh=qpshX6SrJC6k0O2jUp+9iMjbSV49RpHw0sqbXVddswI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fZWg7B1i2SgLqLWBpgCmAT0++gbRPN+4/ba4kTptwdQ1GC9GATY2jO8jxidhzlHKmq6aWIfBPCLruLM6RQJ2xZZnmZjEr6iibBJ1zz64vO17YG22V0lL128vkLHp00mnyz0NGHEQsTu/kZ6S15o0Djbgk9suDv26nMmYtzKFouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drLdOJQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drLdOJQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21B81F000E9;
	Sat, 22 Aug 2026 18:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787421771;
	bh=FJfn7cz72m2NSlVw1sVZ+wx4mlM5Q+T+qWSSHA9lbZo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=drLdOJQxTZQdDrX6Jg/oqtyCUX++VY++2sD2EdQ3Au1wWac2IG8999F+GbJYhm745
	 UnGWhOct9X5C/G6spxK/bOijHOk2DdcyyAxWjvsfgg/kfQf6ouUSz1J58/0o0Q9Q+t
	 qQI8XauanMIUGPlwMzj2SzpcHxoAtg9L+fx99h/d0KQWsmQ6ml9brnU072RgBnon/T
	 qz7yyKWdexSkoCEZ/+lJUToNp1scBC12v1SXODqxaa97UTkGmduWtc1MZKVjDX3SUH
	 qtN/OfEMLEbQTnClc2gMmyPnsOO26k/AFAnggpJ5teVdeREyTy3RyZU1yFQPj6Hpc8
	 xVkIwkwG0fJ/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: arm64: Fix spurious warning for benign
 stage 2 teardown race
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260822-kvm-arm-nested-virt-fix-v2-1-ac4059a0eaa6@kernel.org>
References: <20260822-kvm-arm-nested-virt-fix-v2-0-ac4059a0eaa6@kernel.org>
 <20260822-kvm-arm-nested-virt-fix-v2-1-ac4059a0eaa6@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 22 Aug 2026 18:02:50 +0000
Message-Id: <20260822180250.F21B81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The patch masks a severe Use-After-Free (UAF) vulnerability by=
 assuming the NULL pointer read is a benign race, while failing to realize =
the `mmu` pointer itself points into freed memory (`kvm->arch.nested_mmus`).
--

--- Patch [1]: [PATCH v2 1/2] KVM: arm64: Fix spurious warning for benign s=
tage 2 teardown race ---
commit 720eac2d4e746b3335443e77837000d086115449
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

KVM: arm64: Fix spurious warning for benign stage 2 teardown race

This commit attempts to fix a warning triggered during nested VM teardown
by ignoring cases where mmu->pgt is NULL after reacquiring the MMU lock.
It changes stage2_apply_range() to return 0 instead of -EINVAL when the
page table is no longer present due to concurrent teardown.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 74e7e7f7564c8..31e049ded0932 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -59,19 +59,25 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t =
addr, phys_addr_t end)
[ ... ]
> -static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
> +static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
>  			      phys_addr_t end,
>  			      int (*fn)(struct kvm_pgtable *, u64, u64),
>  			      bool resched)
>  {
>  	struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
> +	phys_addr_t addr =3D start;
>  	int ret;
>  	u64 next;
> =20
>  	do {
>  		struct kvm_pgtable *pgt =3D mmu->pgt;

[Severity: Critical]
This is a pre-existing issue, but does this dereference of mmu->pgt result
in a use-after-free if the nested_mmus array is reallocated or freed while
the lock is dropped?

Looking at stage2_apply_range(), the kvm->mmu_lock can be dropped via
cond_resched_rwlock_write() at the end of this loop.

During this window, the mmu pointer (which points into the
kvm->arch.nested_mmus array) can be invalidated. For example,
kvm_arch_flush_shadow_all() can free the array locklessly:

arch/arm64/kvm/nested.c:kvm_arch_flush_shadow_all() {
    ...
    kvfree(kvm->arch.nested_mmus);
    ...
}

Or it can be reallocated in kvm_vcpu_init_nested():

arch/arm64/kvm/nested.c:kvm_vcpu_init_nested() {
    ...
    tmp =3D kvm->arch.nested_mmus;
    ...
    kvfree(tmp);
    ...
}

When the loop in stage2_apply_range() resumes after reacquiring the lock,
accessing mmu->pgt would read from freed memory. By treating a NULL pgt as
a benign race, does this patch mask the underlying object lifecycle bug and
leave the use-after-free unaddressed if the freed memory is modified?

> +		/*
> +		 * We may be raced on PGT teardown when we release the
> +		 * kvm->mmu_lock. That's fine as the PGT is legitimately no
> +		 * longer present.
> +		 */
>  		if (!pgt)
> -			return -EINVAL;
> +			return resched && addr > start ? 0 : -EINVAL;
> =20
>  		next =3D stage2_range_addr_end(addr, end);
>  		ret =3D fn(pgt, addr, next - addr);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260822-kvm-arm-ne=
sted-virt-fix-v2-0-ac4059a0eaa6@kernel.org?part=3D1
