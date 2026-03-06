Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9B82264C0
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 11:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772796886; cv=none; b=MM4iIM54uv08eC4U4wJE9Skwj0Ta/K0O2k/RTsm1O5Ixs7y3GldtdL0smD5FWTxBJfOmHXcBYGBvxKhe23Z2qVjQMCQIT3NCp1V1eBXSxNL71BvJgSNEwIYG+M1LZmjDNDPxEW7WCkLx/9u6W8YTSBrPe83fFnxBX2e3diBu0RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772796886; c=relaxed/simple;
	bh=SEgo0oNm9+EBdDsr7op47y6u/C6FIuuj7ASCZrlSzJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQ5Dah8wTs1ydZtae6+Ceudr4olRt9EKRwAzpUSvY7oVbWNsDWjchY74qH72lw2DgrmsTWjTev5WGNtgXjs5nMbr+j1rETJs0Ugea4208AEhRyH9MH3+Lv1xnzZkIBY93F6mdvfVFTYX8Yz+5GDizWwjQ6lG4Fsz02mECWW+Mjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2ADD497;
	Fri,  6 Mar 2026 03:34:37 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 173053F836;
	Fri,  6 Mar 2026 03:34:40 -0800 (PST)
Date: Fri, 6 Mar 2026 11:34:37 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 14/35] KVM: arm64: Handle aborts from protected VMs
Message-ID: <aaq7zdxyyphiXhRG@raptor>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-15-will@kernel.org>
 <aY2tX6V0pCqwGth5@raptor>
 <aag8edDkKgfTr_hD@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aag8edDkKgfTr_hD@willie-the-truck>

Hi Will,

On Wed, Mar 04, 2026 at 02:06:49PM +0000, Will Deacon wrote:
> On Thu, Feb 12, 2026 at 10:37:19AM +0000, Alexandru Elisei wrote:
> > On Mon, Jan 19, 2026 at 12:46:07PM +0000, Will Deacon wrote:
> > > Introduce a new abort handler for resolving stage-2 page faults from
> > > protected VMs by pinning and donating anonymous memory. This is
> > > considerably simpler than the infamous user_mem_abort() as we only have
> > > to deal with translation faults at the pte level.
> > > 
> > > Signed-off-by: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/kvm/mmu.c | 89 ++++++++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 81 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > index a23a4b7f108c..b21a5bf3d104 100644
> > > --- a/arch/arm64/kvm/mmu.c
> > > +++ b/arch/arm64/kvm/mmu.c
> > > @@ -1641,6 +1641,74 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > >  	return ret != -EAGAIN ? ret : 0;
> > >  }
> > >  
> > > +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > +		struct kvm_memory_slot *memslot, unsigned long hva)
> > > +{
> > > +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> > > +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > > +	struct mm_struct *mm = current->mm;
> > > +	struct kvm *kvm = vcpu->kvm;
> > > +	void *hyp_memcache;
> > > +	struct page *page;
> > > +	int ret;
> > > +
> > > +	ret = prepare_mmu_memcache(vcpu, true, &hyp_memcache);
> > > +	if (ret)
> > > +		return -ENOMEM;
> > > +
> > > +	ret = account_locked_vm(mm, 1, true);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mmap_read_lock(mm);
> > > +	ret = pin_user_pages(hva, 1, flags, &page);
> > > +	mmap_read_unlock(mm);
> > 
> > If the page is part of a large folio, the entire folio gets pinned here, not
> > just the page returned by pin_user_pages(). Do you reckon that should be
> > considered when calling account_locked_vm()?
> 
> I don't _think_ so.
> 
> Since we only ask for a single page when we call pin_user_pages(), the
> folio refcount will be adjusted by 1, even for large folios. Trying to

The large folios, **_pincount** is adjusted by 1 with FOLL_LONGTERM. For
non-large folio, the refcount is increased by GUP_PIN_COUNTING_BIAS == 1024
(try_grab_folio() is where the magic happens).

> adjust the accounting based on whether the pinned page forms part of a
> large folio feels error-prone, not least because the migration triggered
> by the longterm pin could actually end up splitting the folio but also

Hmm.. as far as I can tell pin_user_pages() uses MIGRATE_SYNC to migrate folios
not suitable for longterm pinning, and after migration has completed it attemps
to pin the userspace address again.

Also, split_folio() and friends cannot split folio_maybe_dma_pinned_folio(),
according to the comments for the various functions.

> because we'd have to avoid double accounting on subsequent faults to the
> same folio. It also feels fragile if the mm code is able to split
> partially pinned folios in future (like it appears to be able to for
> partially mapped folios).

I'm not sure why mm would want to split a folio_maybe_dma_pinned_folio(). But
I'm far from being a mm expert, so I do understand why relying on this might
feel fragile.

> 
> > > +	if (ret == -EHWPOISON) {
> > > +		kvm_send_hwpoison_signal(hva, PAGE_SHIFT);
> > > +		ret = 0;
> > > +		goto dec_account;
> > > +	} else if (ret != 1) {
> > > +		ret = -EFAULT;
> > > +		goto dec_account;
> > > +	} else if (!folio_test_swapbacked(page_folio(page))) {
> > > +		/*
> > > +		 * We really can't deal with page-cache pages returned by GUP
> > > +		 * because (a) we may trigger writeback of a page for which we
> > > +		 * no longer have access and (b) page_mkclean() won't find the
> > > +		 * stage-2 mapping in the rmap so we can get out-of-whack with
> > > +		 * the filesystem when marking the page dirty during unpinning
> > > +		 * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
> > > +		 * without asking ext4 first")).
> > 
> > I've been trying to wrap my head around this. Would you mind providing a few
> > more hints about what the issue is? I'm sure the approach is correct, it's
> > likely just me not being familiar with the code.
> 
> The fundamental problem is that unmapping page-cache pages from the host
> stage-2 can confuse filesystems who don't know that either the page is
> now inaccessible (and so may attempt to access it) or that the page can
> be accessed concurrently by the guest without updating the page state.
> 
> To fix those issues, we would need to support MMU notifiers for protected
> memory but that would allow the host to mess with the guest stage-2
> page-table, which breaks the security model that we're trying to uphold.

Aha, got it, thanks for the explanation!

Alex

> 
> > > @@ -2190,15 +2258,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> > >  		goto out_unlock;
> > >  	}
> > >  
> > > -	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> > > -			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> > > +	if (kvm_vm_is_protected(vcpu->kvm)) {
> > > +		ret = pkvm_mem_abort(vcpu, fault_ipa, memslot, hva);
> > 
> > I guess the reason this comes after handling an access fault is because you want
> > the WARN_ON() to trigger in pkvm_pgtable_stage2_mkyoung().
> 
> Right, we should only ever see translation faults for protected guests
> and that's all that pkvm_mem_abort() is prepared to handle, so we call
> it last.
> 
> Will
