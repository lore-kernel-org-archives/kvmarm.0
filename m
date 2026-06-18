Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289883F0761;
	Thu, 18 Jun 2026 11:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781780988; cv=none; b=s+WGo/L+bj/q9No9eaHsEg3sqXiX+LvvX8rb83BnndxG10iZnpJH01Ahd9gkUVKx+SzTE/hQM0FliSyfhIlKVvvE9atNikJ+VZh4LGVrjWAD3bTA9pplJq3Hwxoss5kVeoijpubhvBWIXpIF5OpqqNNRDWSj/GWMXNQGEXazRvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781780988; c=relaxed/simple;
	bh=auYCEoZcbA6tsdM4hZRjaybb0BxVtZogmGDcWnQ2xH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dC/SHHPhmTpo549673z8Q585G529iveIDWaaWKqrprRJdnGlZ/kvyRY747+UgOt32vid0cATHS7QDXD0SzOgGKnBsHNlx5l2qSiYZwyq+KKW0Lqa2NI0+ejfHt71jv6my7PRQu28lFE4D65OxfsjyNSEpCFm2OP1WKad51KGjo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hvmrsFIv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hvmrsFIv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A5252A6B;
	Thu, 18 Jun 2026 04:09:40 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BFAA3F915;
	Thu, 18 Jun 2026 04:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781780985; bh=auYCEoZcbA6tsdM4hZRjaybb0BxVtZogmGDcWnQ2xH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hvmrsFIv7NwX7MC2b/nUOBdiT4YtYeuiO15zs1v436ZR06mIIyRKoZuzIXev4Ehv2
	 KKrl+p7B+bF6TupXCW9wHNe5R2XZYW8jd/Pp5Fni4eTpdMWbINm+lCkcSa76OciRbO
	 wXQwV2Nvmn/SfmhudwTO6A0Ewh1mkaIL6RJauuQ0=
Date: Thu, 18 Jun 2026 12:09:40 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only
 memslots
Message-ID: <ajPR9PrmNN3y8EC7@raptor>
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <20260615160901.9A1A61F000E9@smtp.kernel.org>
 <ajA6ogaNiI3KDv5i@google.com>
 <ajA_0TQCQLSz7qcU@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajA_0TQCQLSz7qcU@google.com>

Hi Sean,

On Mon, Jun 15, 2026 at 11:09:21AM -0700, Sean Christopherson wrote:
> On Mon, Jun 15, 2026, Sean Christopherson wrote:
> > On Mon, Jun 15, 2026, sashiko-bot@kernel.org wrote:
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > [ ... ]
> > > > @@ -592,6 +592,10 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
> > > >  			unsigned long hva_start, hva_end;
> > > >  
> > > >  			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> > > > +
> > > > +			if (kvm_slot_has_gmem(slot) && kvm_memslot_is_gmem_only(slot))
> > > > +				continue;
> > > > +
> > > 
> > > [Severity: Critical]
> > > Does this change inadvertently introduce a regression in the pfncache retry
> > > protocol?
> > > 
> > > Looking at the pfncache framework, it maps guest memory into kernel space and
> > > explicitly drops the page reference after mapping it:
> > > 
> > > virt/kvm/pfncache.c:hva_to_pfn_retry() {
> > >     ...
> > >     kvm_release_page_clean(page);
> > >     ...
> > > }
> > > 
> > > It appears to rely entirely on KVM's MMU notifiers (kvm->mmu_invalidate_seq)
> > > to invalidate the cache when the page is unmapped by the host.
> > > 
> > > If a VMM defines a guest_memfd-backed memslot with KVM_MEMSLOT_GMEM_ONLY
> > > but still provides a valid anonymous user mapping as its userspace_addr,
> > > could this regression lead to a use-after-free?
> > 
> > Sadly, yes.  To land this, we would need to first teach the gfn_to_pfn_cache code
> > to be able to pull directly from guest_memfd.  I forget if anyone is working on
> > that.
> 
> Actually, we just need to ensure the invalidation tracking is updated, the MMU
> itself can be left as-is.
> 
> Compile tested only, but this?
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 27498e990dff..690ab707816b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -260,6 +260,7 @@ union kvm_mmu_notifier_arg {
>  enum kvm_gfn_range_filter {
>         KVM_FILTER_SHARED               = BIT(0),
>         KVM_FILTER_PRIVATE              = BIT(1),
> +       KVM_FILTER_USERSPACE_MAPPINGS   = BIT(2),
>  };
>  
>  struct kvm_gfn_range {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e44c20c04961..84b693de7e35 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -608,7 +608,8 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
>                          * HVA-based notifications aren't relevant to private
>                          * mappings as they don't have a userspace mapping.
>                          */
> -                       gfn_range.attr_filter = KVM_FILTER_SHARED;
> +                       gfn_range.attr_filter = KVM_FILTER_SHARED |
> +                                               KVM_FILTER_USERSPACE_MAPPINGS;
>  
>                         /*
>                          * {gfn(page) | page intersects with [hva_start, hva_end)} =
> @@ -715,6 +716,21 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
>  bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>  {
>         kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
> +
> +       /*
> +        * When reacting to changes in userspace mappings, don't unmap memslots
> +        * that are guest_memfd-only, in which case KVM's MMU mappings are
> +        * pulled directly from guest_memfd, i.e. don't depend on the userspace
> +        * mappings.
> +        *
> +        * TODO: Skip gmem-only memslots on mmu_notifier events entirely, once
> +        * gfn_to_pfn_cache is also wired up to directly pull from guest_memfd.
> +        */
> +       if (range->attr_filter & KVM_FILTER_USERSPACE_MAPPINGS &&
> +           kvm_slot_has_gmem(range->slot) &&
> +           kvm_memslot_is_gmem_only(range->slot))
> +               return false;
> +
>         return kvm_unmap_gfn_range(kvm, range);
>  }

Looks correct to me, this way we also make sure we don't hit the
WARN_ON_ONCE() from mmu_invalidate_retry_pfn().

How about the ->{clear_flush,clear,test}_young() MMU notifier callbacks?
Shouldn't they receive the same treatment?

Thanks,
Alex
