Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CF843E488
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 13:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786542873; cv=none; b=YXatuYTzlV5fiyDywqjYpMXM4qW+s/f2oBBIumjwioNZroc0xdlg64c1kimmJxPFA33NtnAGkbYp8LxMRYyTlpJOA5XnqztPMHCyHM0Z3MxSrxeWZryp6XL45Q0n6mXiL2BwhocVF0QJ5b4v1PcsNThambm9Hg3aPwfFSwoKzxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786542873; c=relaxed/simple;
	bh=wfI7mOS0vCpUdVl77KXcL1QKWgs8YY34Ki4bq0rGlS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hbpibA97SJjEv4o5CE1ViLvbtdFsbRUHF7ohELgOMpqD46kKBdcNorZ0SndEloryA/E7H4QadIyamFG18TSUXtbCn6B5pNGBtw5slp/0ny0l2kkKX5caeeb8XcX++81hCj+q/kWblsxoG+AmZEoyNnv3A4kqbaqqGE/sRWvHTl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxEjwQZn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxEjwQZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF04E1F00A3A;
	Wed, 12 Aug 2026 13:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786542870;
	bh=RoXxITx+Tbc7DNp0pETdpxLe+F/hwFw0seVpPNMi8D0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LxEjwQZnkldTKCZpwJEE8L40ion6kzpa8fizIwaZUGWaQ6Z6Q8TgxXlkto8yyPUPk
	 vHxWEwqmVXrr50W3Rs0rmSEhH1pfiJS9uXLZmFmE5QH1/lnmiOXdEsuue03bCCJcqo
	 xxahJlynQBtuAg71z4bOW6gsC76JMU2+vInlfCG4IWh6z4AAGc6H8axtqTTaarQXS1
	 0YNUl9cFfgI8iFK7vjaOzL5mRW095XxTmaRtOeKnq/0qgDCMXklRL0Yrr0pGAn4QSN
	 tEhKlrYdzxcte+dLzx4u74PuL3p1SVzZFz6vC4keGOR2rbLeeFlXYr20ck+6pOIuWk
	 /yciJGMBtruwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Fix spurious warning for benign stage 2
 teardown race
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260812-kvm-arm-nested-virt-fix-v1-1-4ad883f1b6a5@kernel.org>
References: <20260812-kvm-arm-nested-virt-fix-v1-0-4ad883f1b6a5@kernel.org>
 <20260812-kvm-arm-nested-virt-fix-v1-1-4ad883f1b6a5@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 13:54:29 +0000
Message-Id: <20260812135429.DF04E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Use-After-Free of the dynamically allocated `kvm->arch.nested_=
mmus` array when the MMU lock is dropped during stage-2 unmap operations.
- [High] NULL Pointer Dereference in `kvm_vcpu_init_nested()` during concur=
rent VM teardown.
--

--- Patch [1]: [PATCH 1/2] KVM: arm64: Fix spurious warning for benign stag=
e 2 teardown race ---
commit ffda2ec0115c7506d269acccba8c1f4511410e87
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

KVM: arm64: Fix spurious warning for benign stage 2 teardown race

This patch suppresses a warning in stage2_apply_range() when the page table
pointer is found to be NULL after reacquiring the MMU lock. It assumes that
the NULL page table is a benign result of a concurrent teardown.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 74e7e7f7564c8..31e049ded0932 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -59,19 +59,25 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t =
addr, phys_addr_t end)
>   * long will also starve other vCPUs. We have to also make sure that the=
 page
>   * tables are not freed while we released the lock.
>   */
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
> +		/*
> +		 * We may be raced on PGT teardown when we release the
> +		 * kvm->mmu_lock. That's fine as the PGT is legitimately no
> +		 * longer present.
> +		 */
>  		if (!pgt)
> -			return -EINVAL;
> +			return resched && addr > start ? 0 : -EINVAL;

[Severity: Critical]
This is a pre-existing issue, but does suppressing this warning mask a
regression where the mmu pointer itself is used after being freed?

When kvm_nested_s2_unmap() passes an mmu pointer to stage2_apply_range(),
that pointer references a dynamically allocated array:

arch/arm64/kvm/nested.c:kvm_nested_s2_unmap() {
    ...
    struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
    if (kvm_s2_mmu_valid(mmu))
        kvm_stage2_unmap_range(mmu, ...);
}

If cond_resched_rwlock_write() drops the lock inside stage2_apply_range(),
a concurrent VM teardown or VCPU initialization can completely free this
array:

arch/arm64/kvm/nested.c:kvm_arch_flush_shadow_all() {
    ...
    kvfree(kvm->arch.nested_mmus);
    kvm->arch.nested_mmus =3D NULL;
}

When the lock is reacquired, the loop continues and accesses mmu->pgt
from the now-freed memory. Is it possible that the warning was actually
firing because we were reading a freed mmu structure?


[Severity: High]
This is also a pre-existing issue, but looking at the concurrent VM teardown
path, does kvm_vcpu_init_nested() have a NULL pointer dereference?

When kvm_vcpu_init_nested() reallocates the array, it unconditionally
updates the mmu pointer for each entry:

arch/arm64/kvm/nested.c:kvm_vcpu_init_nested() {
    ...
    for (int i =3D 0; i < kvm->arch.nested_mmus_size; i++)
        tmp[i].pgt->mmu =3D &tmp[i];
    ...
}

If kvm_arch_flush_shadow_all() concurrently calls kvm_free_stage2_pgd()
and sets pgt to NULL before the lock is acquired here, wouldn't this crash
when dereferencing tmp[i].pgt?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812-kvm-arm-ne=
sted-virt-fix-v1-0-4ad883f1b6a5@kernel.org?part=3D1
