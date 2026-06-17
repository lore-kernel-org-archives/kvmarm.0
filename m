Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD6653546CC;
	Wed, 17 Jun 2026 13:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781701651; cv=none; b=PULDLOicdgh8rUXwofqpvIpurJenLrK8TGGmH+J157oqupsw564fOdUYCrCevAEtJiOtvl/1lntft/do5a7pr6WIlNjhsGrQe5RcuP/og3/ktHRYBjppIMrj0EYFXFuWkGA6HSVugMFBn6yWKO1LtUnuLRPHxdS3YpGleiwiNrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781701651; c=relaxed/simple;
	bh=E26IkxFD9DfbeE5HELV5viO8jxbqYwieFPA/wXGFiOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kqg+xySEvxnmhvXHiJBNhGJ2Twwg5qlW6bfg2wYjHYl5R0AUpOHP1l21QcxM/5Ljng4ijcogqr/smYAPJkqABWeo4IHPG5LKdxuHSVi7qE9ylt6N0zKT16OX0QM0Xr3NN/ycjR80ALc5CMf6uo1mp9hLui8vc9IS3RkuBqW86YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RGa5Wtgf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RGa5Wtgf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 866FB4794;
	Wed, 17 Jun 2026 06:07:24 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334053F915;
	Wed, 17 Jun 2026 06:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781701649; bh=E26IkxFD9DfbeE5HELV5viO8jxbqYwieFPA/wXGFiOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RGa5WtgfTIcNohI2nWzVaLeb9z0fDYlZavwWA6cstCz+iuQH3omNhHjBrnGzgLkDs
	 erOucRvsbB2GfMtjEqzWGRB+V3lubViVic/PXKqDjHIsGyWQUhjAgsvWwdV2lrVxRU
	 FNOiW6JDGjFbFaXSPcdLA2JMH6iMeHh7WcLs4AQA=
Date: Wed, 17 Jun 2026 14:07:25 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <ajKcDRqT5m069PXK@raptor>
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <20260615160901.9A1A61F000E9@smtp.kernel.org>
 <ajA6ogaNiI3KDv5i@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajA6ogaNiI3KDv5i@google.com>

Hi Sean,

Thanks for the reply. Just to make sure, once the bugs have been iron out,
you're ok with this idea?

On Mon, Jun 15, 2026 at 10:47:14AM -0700, Sean Christopherson wrote:
> On Mon, Jun 15, 2026, sashiko-bot@kernel.org wrote:
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > [ ... ]
> > > @@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
> > >  			unsigned long hva_start, hva_end;
> > >  
> > >  			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> > > +
> > > +			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
> > > +				continue;
> > > +
> > 
> > [Severity: Critical]
> > Does this change inadvertently introduce a regression in the pfncache retry
> > protocol?
> > 
> > Looking at the pfncache framework, it maps guest memory into kernel space and
> > explicitly drops the page reference after mapping it:
> > 
> > virt/kvm/pfncache.c:hva_to_pfn_retry() {
> >     ...
> >     kvm_release_page_clean(page);
> >     ...
> > }
> > 
> > It appears to rely entirely on KVM's MMU notifiers (kvm->mmu_invalidate_seq)
> > to invalidate the cache when the page is unmapped by the host.
> > 
> > If a VMM defines a guest_memfd-backed memslot with KVM_MEMSLOT_GMEM_ONLY
> > but still provides a valid anonymous user mapping as its userspace_addr,
> > could this regression lead to a use-after-free?
> 
> Sadly, yes.  To land this, we would need to first teach the gfn_to_pfn_cache code
> to be able to pull directly from guest_memfd.  I forget if anyone is working on
> that.

I've been trying to wrap my head around this, and I just can't seem to
figure it out.

kvm_mmu_notifier_invalidate_range_start(), before handle_hva_range(), calls
gfn_to_pfn_cache_invalidate_start() for the MMU notifier range, and that
marks all caches that overlap the range as invalid. kvm_gpc_check() returns
false for an invalid cache, so how can the memory still be accessed via the
pfncache?

> 
> > By unmapping the anonymous memory, the host would trigger MMU notifiers, but
> > this new check skips the memslot. As a result, kvm->mmu_invalidate_seq
> > wouldn't increment, and KVM might retain a kernel mapping to a freed physical
> > page.

kvm->mmu_invalidate_seq is incremented in kvm_mmu_invalidate_end(), I don't see
how that is affected by skipping a memslot in handle_hva_range().

> > 
> > Could this allow the guest to read or write arbitrary host physical memory?

The KVM_MEMSLOT_GMEM_ONLY flag is set if the backing guest_memfd has been
created with GUEST_MEMFD_FLAG_MMAP. The documentation for the flag says
that '[..] the fault will always be consumed from guest_memfd, regardless
of whether it is a shared or private fault'.  As far as I can tell, this
means that, absent a fallocate(FALLOC_FL_PUNCH_HOLE) call, the page is
still in the page cache for the guest_memfd file after userspace has
unmapped it, so the guest will not be accessing a freed page.

Thoughts? Am I missing something obvious?

Thanks,
Alex

> > 
> > >  			hva_start = max_t(unsigned long, range->start, slot->userspace_addr);
> > >  			hva_end = min_t(unsigned long, range->end,
> > >  					slot->userspace_addr + (slot->npages << PAGE_SHIFT));
> > 
> > -- 
> > Sashiko AI review · https://sashiko.dev/#/patchset/20260615155244.183044-1-alexandru.elisei@arm.com?part=1
