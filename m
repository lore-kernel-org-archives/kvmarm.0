Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7962D3A453E
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 14:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772633215; cv=none; b=sG+/+amfcncERk7vxoVQA4eF7qNTGG1Cw9ATfLv7EJlmFGGpp6UmIZ29LJCV1ZMIyfAcF2GICyOWJTmt6dnIgcF4VqvPuDWemIc2whK/ChQPDNZDmasWwq/neMrcZaTa+D0hDw3TezUXnukmM6kHx4Oh/Qv2lLXabPv+0ZKUCsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772633215; c=relaxed/simple;
	bh=gdTvGR1HAMd/24WUkklJSA4hbg82Mz6vxLyASbCCMXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L84pwZoFTGA8hEoibgI+Cpa8gdpvmyuck7geBQa/1okwyoFulS322woepn6Ntxp88QrFLblK01V/qBZxYOpAC8vUInX+eWZjwgOyNBR2kGW3YsEpVa2hcCon2ZOkeeYmcGUWj/EUplxQijobh4/vqn798PJchIK904KXvKcrewI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWWb/RRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWWb/RRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2A2C4CEF7;
	Wed,  4 Mar 2026 14:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772633215;
	bh=gdTvGR1HAMd/24WUkklJSA4hbg82Mz6vxLyASbCCMXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DWWb/RRBfBLwLwQbLS5nh17ddUUFQWLNr6KxAw89b5/xIMYwGwGjyn30FiOQh7pph
	 DMxIGtMrs6rvgJ+/W9zzB1YTG77TA/ObRGTDOee6pNfi6zokQ+reHp+vpYMP0Zx/9Y
	 OZTkJw7QzkB4w57+0FtW5NqI0yepogsF4NdEIGxW4Eugig3baYlkQmjysRGyTtKZvG
	 /eY8J60Q4SkETWyfpMmGsBPXlSgInpSgyU1KbIoMrvm2c/KgOggUIlMiS0AkN1kPM9
	 QBz0Z8I4rchcao+wJSYsrBdeUCpymaGJFw9DwkGO/agkWEDJpg1oePyhg/plK3OyW3
	 96vHhIKLARSGQ==
Date: Wed, 4 Mar 2026 14:06:49 +0000
From: Will Deacon <will@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
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
Message-ID: <aag8edDkKgfTr_hD@willie-the-truck>
References: <20260119124629.2563-1-will@kernel.org>
 <20260119124629.2563-15-will@kernel.org>
 <aY2tX6V0pCqwGth5@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY2tX6V0pCqwGth5@raptor>

On Thu, Feb 12, 2026 at 10:37:19AM +0000, Alexandru Elisei wrote:
> On Mon, Jan 19, 2026 at 12:46:07PM +0000, Will Deacon wrote:
> > Introduce a new abort handler for resolving stage-2 page faults from
> > protected VMs by pinning and donating anonymous memory. This is
> > considerably simpler than the infamous user_mem_abort() as we only have
> > to deal with translation faults at the pte level.
> > 
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/mmu.c | 89 ++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 81 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index a23a4b7f108c..b21a5bf3d104 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1641,6 +1641,74 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	return ret != -EAGAIN ? ret : 0;
> >  }
> >  
> > +static int pkvm_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +		struct kvm_memory_slot *memslot, unsigned long hva)
> > +{
> > +	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
> > +	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +	struct mm_struct *mm = current->mm;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	void *hyp_memcache;
> > +	struct page *page;
> > +	int ret;
> > +
> > +	ret = prepare_mmu_memcache(vcpu, true, &hyp_memcache);
> > +	if (ret)
> > +		return -ENOMEM;
> > +
> > +	ret = account_locked_vm(mm, 1, true);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mmap_read_lock(mm);
> > +	ret = pin_user_pages(hva, 1, flags, &page);
> > +	mmap_read_unlock(mm);
> 
> If the page is part of a large folio, the entire folio gets pinned here, not
> just the page returned by pin_user_pages(). Do you reckon that should be
> considered when calling account_locked_vm()?

I don't _think_ so.

Since we only ask for a single page when we call pin_user_pages(), the
folio refcount will be adjusted by 1, even for large folios. Trying to
adjust the accounting based on whether the pinned page forms part of a
large folio feels error-prone, not least because the migration triggered
by the longterm pin could actually end up splitting the folio but also
because we'd have to avoid double accounting on subsequent faults to the
same folio. It also feels fragile if the mm code is able to split
partially pinned folios in future (like it appears to be able to for
partially mapped folios).

> > +	if (ret == -EHWPOISON) {
> > +		kvm_send_hwpoison_signal(hva, PAGE_SHIFT);
> > +		ret = 0;
> > +		goto dec_account;
> > +	} else if (ret != 1) {
> > +		ret = -EFAULT;
> > +		goto dec_account;
> > +	} else if (!folio_test_swapbacked(page_folio(page))) {
> > +		/*
> > +		 * We really can't deal with page-cache pages returned by GUP
> > +		 * because (a) we may trigger writeback of a page for which we
> > +		 * no longer have access and (b) page_mkclean() won't find the
> > +		 * stage-2 mapping in the rmap so we can get out-of-whack with
> > +		 * the filesystem when marking the page dirty during unpinning
> > +		 * (see cc5095747edf ("ext4: don't BUG if someone dirty pages
> > +		 * without asking ext4 first")).
> 
> I've been trying to wrap my head around this. Would you mind providing a few
> more hints about what the issue is? I'm sure the approach is correct, it's
> likely just me not being familiar with the code.

The fundamental problem is that unmapping page-cache pages from the host
stage-2 can confuse filesystems who don't know that either the page is
now inaccessible (and so may attempt to access it) or that the page can
be accessed concurrently by the guest without updating the page state.

To fix those issues, we would need to support MMU notifiers for protected
memory but that would allow the host to mess with the guest stage-2
page-table, which breaks the security model that we're trying to uphold.

> > @@ -2190,15 +2258,20 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> >  		goto out_unlock;
> >  	}
> >  
> > -	VM_WARN_ON_ONCE(kvm_vcpu_trap_is_permission_fault(vcpu) &&
> > -			!write_fault && !kvm_vcpu_trap_is_exec_fault(vcpu));
> > +	if (kvm_vm_is_protected(vcpu->kvm)) {
> > +		ret = pkvm_mem_abort(vcpu, fault_ipa, memslot, hva);
> 
> I guess the reason this comes after handling an access fault is because you want
> the WARN_ON() to trigger in pkvm_pgtable_stage2_mkyoung().

Right, we should only ever see translation faults for protected guests
and that's all that pkvm_mem_abort() is prepared to handle, so we call
it last.

Will
