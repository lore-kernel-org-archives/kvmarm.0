Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF46048D862;
	Thu, 13 Aug 2026 15:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786635387; cv=none; b=pQpt3PGtpDn4yQZuZVFoObovppizFAfvJqpWxAPZLvW8SL40OjJtA9Ah+0LGVt1fPTwdlli69L6nFiZK7SNUBSDBwceFCXdBrZfhcQdurHVCN6o0FU74P4AJ8ZaO0RA28Kl36rEEhYgEImwTKlXaPol4m8YMyxOPUDjRB9sTtFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786635387; c=relaxed/simple;
	bh=bDq/VpZLsWkV+WY8dorsu8XzvYizhx1dAcvkf6wKpkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INLhAW+4TDsxpvW+pKhOjnizlyHElk71lbbu4Oqtd3KbGAnSEuMB1LFUJtpbaUenvzwj3cOeYhKWBShRlD/xz7oKCLxE/J6+ssMn87HyAK05pR9RvY2NXa8F3IF7Ypf0l8NFFr2B3BmZvOUHuT7u8f202+qnECFhsYEhgfre8GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pc6USizA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pc6USizA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D872E1F000E9;
	Thu, 13 Aug 2026 15:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786635374;
	bh=Jr8DnVEse/w2rPkJNtzp0dK+qPNR39FkLGyVNFDoQxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pc6USizAbfaLoN1wOStVGd4CSaxAmssXcjLPQJVwrBoge64P2hqmlcPBYdtdSMOGd
	 od9gD5n7+LmGYe4YttnkpyLZYrqpV7LNp6jGX5Pwls/QlpfbOxXhNcu7er28dgkgq0
	 I6P/BVfojls05GzbpLq7ofYrg5oQeDBRqg36injWbzKVLZnWty7qmu7z4/pONwy767
	 WfkpXhPzRdl8s/RlEsUe0BBNRbpldsWBmUBuwN63HrKcaPNQ2BGeFqTddQJ92Py7Fd
	 UXZqW+zTy5pfhKn8mXXTO2SWDcSiWi6BmvmpfMS8DYUH4T6uRaDnC4KYNWU3vR+Abn
	 HAhbklCCnufoQ==
Date: Thu, 13 Aug 2026 16:35:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix spurious warning for benign stage 2
 teardown race
Message-ID: <an3iN22IAIv1i_nR@lucifer>
References: <20260812-kvm-arm-nested-virt-fix-v1-0-4ad883f1b6a5@kernel.org>
 <20260812-kvm-arm-nested-virt-fix-v1-1-4ad883f1b6a5@kernel.org>
 <20260812135429.DF04E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260812135429.DF04E1F00A3A@smtp.kernel.org>

On Wed, Aug 12, 2026 at 01:54:29PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> Pre-existing issues:
> - [Critical] Use-After-Free of the dynamically allocated `kvm->arch.nested_mmus` array when the MMU lock is dropped during stage-2 unmap operations.
> - [High] NULL Pointer Dereference in `kvm_vcpu_init_nested()` during concurrent VM teardown.
> --
>
> --- Patch [1]: [PATCH 1/2] KVM: arm64: Fix spurious warning for benign stage 2 teardown race ---
> commit ffda2ec0115c7506d269acccba8c1f4511410e87
> Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> KVM: arm64: Fix spurious warning for benign stage 2 teardown race
>
> This patch suppresses a warning in stage2_apply_range() when the page table
> pointer is found to be NULL after reacquiring the MMU lock. It assumes that
> the NULL page table is a benign result of a concurrent teardown.
>
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 74e7e7f7564c8..31e049ded0932 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -59,19 +59,25 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> >   * long will also starve other vCPUs. We have to also make sure that the page
> >   * tables are not freed while we released the lock.
> >   */
> > -static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
> > +static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
> >  			      phys_addr_t end,
> >  			      int (*fn)(struct kvm_pgtable *, u64, u64),
> >  			      bool resched)
> >  {
> >  	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
> > +	phys_addr_t addr = start;
> >  	int ret;
> >  	u64 next;
> >
> >  	do {
> >  		struct kvm_pgtable *pgt = mmu->pgt;
> > +		/*
> > +		 * We may be raced on PGT teardown when we release the
> > +		 * kvm->mmu_lock. That's fine as the PGT is legitimately no
> > +		 * longer present.
> > +		 */
> >  		if (!pgt)
> > -			return -EINVAL;
> > +			return resched && addr > start ? 0 : -EINVAL;
>
> [Severity: Critical]
> This is a pre-existing issue, but does suppressing this warning mask a
> regression where the mmu pointer itself is used after being freed?
>
> When kvm_nested_s2_unmap() passes an mmu pointer to stage2_apply_range(),
> that pointer references a dynamically allocated array:
>
> arch/arm64/kvm/nested.c:kvm_nested_s2_unmap() {
>     ...
>     struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
>     if (kvm_s2_mmu_valid(mmu))
>         kvm_stage2_unmap_range(mmu, ...);
> }
>
> If cond_resched_rwlock_write() drops the lock inside stage2_apply_range(),
> a concurrent VM teardown or VCPU initialization can completely free this
> array:
>
> arch/arm64/kvm/nested.c:kvm_arch_flush_shadow_all() {
>     ...
>     kvfree(kvm->arch.nested_mmus);
>     kvm->arch.nested_mmus = NULL;
> }
>
> When the lock is reacquired, the loop continues and accesses mmu->pgt
> from the now-freed memory. Is it possible that the warning was actually
> firing because we were reading a freed mmu structure?

All stuff being handled elsewhere with Marc's series AFAICT.

>
>
> [Severity: High]
> This is also a pre-existing issue, but looking at the concurrent VM teardown
> path, does kvm_vcpu_init_nested() have a NULL pointer dereference?
>
> When kvm_vcpu_init_nested() reallocates the array, it unconditionally
> updates the mmu pointer for each entry:
>
> arch/arm64/kvm/nested.c:kvm_vcpu_init_nested() {
>     ...
>     for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
>         tmp[i].pgt->mmu = &tmp[i];
>     ...
> }
>
> If kvm_arch_flush_shadow_all() concurrently calls kvm_free_stage2_pgd()
> and sets pgt to NULL before the lock is acquired here, wouldn't this crash
> when dereferencing tmp[i].pgt?

This seems like what my 2nd patch handles :)

>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20260812-kvm-arm-nested-virt-fix-v1-0-4ad883f1b6a5@kernel.org?part=1

--
Cheers, Lorenzo
