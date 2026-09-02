Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD85146F4AD;
	Wed,  2 Sep 2026 11:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788348645; cv=none; b=cp1VM3tf1HXk7VXqwlg3Q4gePoRrQVl6PmwfFF9Y5PrwfgR+BjjOu3HhX3ycmzYpx/0MtMAAZNJZVyswUmm2RQnAAw+oYu+DGR9O/67Q7Tl6iAa0y0/Ha5vctR85yQLj69SKph26SwA2a3xZ+esBztEzjaa+UMxWIwnGlmM2EUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788348645; c=relaxed/simple;
	bh=rsiPb+N3NBg42jR8oIV7SEKwZHQQaAyFyFV6MMqxWdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=a5hRKZVvODVafQyrqdaKyvwpseXGVaDrS+6fP35HPuXHXomS3EfGpenAvDEvF32vi/diECSyk2yAhwtuIf+dq9kgepaCScXuBd0UV8P2ZVgDldtprxpIdt+CNowzeGbK1aC7l3U31FgGa2C651mJ3yfeEfTHAOM8MzCfUJ7E374=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hweE4dzD; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hweE4dzD"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16EE72F;
	Wed,  2 Sep 2026 04:30:35 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AAAB3F85F;
	Wed,  2 Sep 2026 04:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788348638; bh=rsiPb+N3NBg42jR8oIV7SEKwZHQQaAyFyFV6MMqxWdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hweE4dzD7xK1qCxh/+uOl5ZdIsajcvREw9IFsj3T2/PKYOhQcKwLRyEK5cV4CQlnp
	 /PeVsjc9FyOPt8GrzSAK9kySvbt3aEAPHD3ZU4EhCsJCOTAiDF/WXDX4ASUC6sN1m+
	 vShxw2HLrxVt1RA3iwVLkifwnqnt9zSQnC1LMkR8=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH 2/5] KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
Date: Wed,  2 Sep 2026 12:30:35 +0100
Message-ID: <apgI27i_huhue2iP@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260901173453.038E01F000E9@smtp.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-3-leo.bras@arm.com> <20260901173453.038E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 01, 2026 at 05:34:52PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Silent data corruption and loss of guest memory due to missing host folio dirty tracking with hardware Dirty Bit Management (HW DBM).
> --
> 
> commit c5bf76c3d6bf3edf785c54c123328d74e2186585
> Author: Leonardo Bras <leo.bras@arm.com>
> KVM: arm64: Add KVM_PGTABLE_PROT_DIRTY
> 
> This commit introduces KVM_PGTABLE_PROT_DIRTY to distinguish between writable
> but not dirty pages and writable and dirty pages in the Stage2 PTE descriptor.
> It evaluates these concepts on a per-case basis across KVM ARM64 page tables.
> 
> > diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> [ ... ]
> > @@ -731,8 +731,12 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
> >  	if (prot & KVM_PGTABLE_PROT_R)
> >  		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
> >  
> > -	if (prot & KVM_PGTABLE_PROT_W)
> > -		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM | KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	if (prot & KVM_PGTABLE_PROT_W) {
> > +		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > +
> > +		if (prot & KVM_PGTABLE_PROT_DIRTY)
> > +			attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +	}
> 
> [Severity: Critical]
> Could this translation enable hardware DBM bypass for pages not marked
> PROT_DIRTY? This translates the software PROT_W without PROT_DIRTY into
> the hardware PTE state (DBM=1, S2AP_W=0), setting up the HW DBM bypass.

That's the desired effect, as we can use HAFDBS/HDBSS to automatically 
update and track them.

> 
> [ ... ]
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> [ ... ]
> > @@ -1681,10 +1683,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
> >  	}
> >  
> >  out_unlock:
> > -	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
> > +	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_DIRTY);
> 
> [Severity: Critical]
> Does limiting the dirty tracking here to PROT_DIRTY instead of the mapping
> writability (PROT_W) cause host folio dirty tracking to be missed when HAFDBS
> is enabled?
> 

Yes, that's why for dirty-tracking host should either disable HAFDBS or 
enable HDBSS if available.

> [ ... ]
> > @@ -1984,11 +1986,14 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
> >  
> >  	*prot = KVM_PGTABLE_PROT_R;
> >  
> > -	if (s2vi->map_writable && (s2vi->device ||
> > -				   !memslot_is_logging(s2fd->memslot) ||
> > -				   kvm_is_write_fault(s2fd->vcpu)))
> > +	if (s2vi->map_writable) {
> >  		*prot |= KVM_PGTABLE_PROT_W;
> >  
> > +		if (s2vi->device || !memslot_is_logging(s2fd->memslot) ||
> > +		    kvm_is_write_fault(s2fd->vcpu))
> > +			*prot |= KVM_PGTABLE_PROT_DIRTY;
> > +	}
> 
> [Severity: Critical]
> On a read fault when HAFDBS is enabled, this leaves KVM_PGTABLE_PROT_DIRTY
> unset while KVM_PGTABLE_PROT_W is set. Can this allow the hardware to
> locklessly dirty the page later without KVM knowing?

That's the desired behavior. If we need tracking, see above comment.

> 
> [ ... ]
> > @@ -2019,7 +2024,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> >  			    void *memcache)
> >  {
> >  	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
> > -	bool writable = prot & KVM_PGTABLE_PROT_W;
> > +	bool dirty = prot & KVM_PGTABLE_PROT_DIRTY;
> 
> [Severity: Critical]
> By deriving the dirty status for host folio tracking strictly from PROT_DIRTY
> instead of PROT_W, are we setting up the host MM to track the folio as clean
> on read faults?
> 

Yes. The main idea is that a read fault does _not_ dirty a folio, just as 
it already happens when dirty-tracking is enabled.

> [ ... ]
> > @@ -2082,7 +2087,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
> >  	}
> >  
> >  out_unlock:
> > -	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
> > +	kvm_release_faultin_page(kvm, s2vi->page, !!ret, dirty);
> 
> [Severity: Critical]
> Releasing the folio to the host MM as clean on read faults could break host
> folio dirty tracking.
> 
> If a guest later writes to this page and the CPU locklessly sets S2AP_W=1
> without trapping, KVM won't be aware. Since KVM ARM64 does not harvest this
> dirty bit during MMU notifier invalidations, the host Linux MM never learns
> the folio was dirtied. When the host reclaims the folio under memory
> pressure, does this result in data corruption and loss of guest memory by
> discarding the modified data instead of writing it to swap?

Ah, good catch. IIUC:
CPU0					CPU1
kvm_s2_fault_map - WC - pageA
	sets dirty=false
	...				HAFDBS sets pageA dirty
	kvm_release_faultin_page
		kvm_release_page_clean

So, in this case, I think it would be better to use writable instead of 
clean, as IIUC there should be no issue marking a clean page as dirty other 
than a bit of overhead on calling kvm_set_page_dirty().

Does it work?

Thanks!
Leo


