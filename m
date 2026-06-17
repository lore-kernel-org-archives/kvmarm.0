Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4F13BE178
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 21:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781731265; cv=none; b=WQ9vFmZ0WbdyZHKxcyPiJVc9wHgVhR2g8vqoHspMlYsrnFCKS0WROrzYPe+UosVa/cwLw7qC9WYJqOBqD5CC4KEec4EnlNmcUOFjNmtstTDq7OldVNBF/fucNX9vCnkLhA7fLBV6jPjVlj+sgeWOoHHBlhkOPsUbwOvR5jt8Z+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781731265; c=relaxed/simple;
	bh=atB3bgHAvDtmY92Rap1LsxpecyU+4Ejr8Mpz7VCogVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OqIUc8WCNCfZYLOMEBEbNLpU4eWG6951IJUYhmpaD5XbM7nr48Jby4xQT93EltPZCKM7cZ3DYldeANS9gy+eia3GjLyAgdSO165TFfWWsMtdRCz6gsug4C7XXnuLz9WGzMhfNI/EGXYDX2tKl6nAw1kqrzMpfs95YAq2bG2XSik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wbH/f4He; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wbH/f4He"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-37c64f7ff48so200549a91.2
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781731263; x=1782336063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQ9Yqm4tffKg4e29hqMAX+T2CRy/ICARHYsUqtEuY7U=;
        b=wbH/f4HetVdlmCATRVMN9xDSIJRO8mWcXXKfzAnw6liq0JK674su55JdMTlaRcS0/f
         wwkmS5lhQJGlWds7NufEZsHgaKlgHAhpT43SmCptpW58xHukRYeR1qYjg7gseFvDSQEc
         88aa/XJJHY7vbBH0dLsq5uxcZBTRwlN2SvwFc0KUYpceQxUzmoaTJshaNDGCcR+iH3/J
         5jVce+eGOrhnMaZUb92Wr9K0K30QQaWPqzlHgtq6QMxJLOK1u2ppiNx0OphYrHJqiEil
         MzYBfdDgm6rBu/5S6AUu55NNdjn+gxI66RVJ8b2Wy3r9jGCBj/zSnYvBGxXc2jD6rrBV
         hgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781731263; x=1782336063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PQ9Yqm4tffKg4e29hqMAX+T2CRy/ICARHYsUqtEuY7U=;
        b=Osa/tO0O4Twk9X9/nAI++3I9ozs5+eyXKuMsEATROm6Cpf/y3+h8qjtfkzcR8ncB0Y
         7VhDNRS1OnP8NavdDFbyfyfcgQmMKq/y8Gr12gEnN/Iui/NgJZSHRVnQM6kv27I/X/RQ
         GQ2Zi0cbKlDwdmc0IXShLKS0lsn+MTHVfBW0zCfONi1WA5TihGQPt9kSO6oFCVOeBXtW
         GofOF1q10F0s1+TcBa94qNPYdWUBdqzQrx+Mn7PhJS1TfciOszOi+O9A2o6MTMufZ4CE
         AjjsRAmD+fo8LaCcB7x2YjlNVu2TWUQX6dtfp9fC/w8l3mW41RVwtsjZUuhQS8Tdpoo+
         CYgw==
X-Forwarded-Encrypted: i=1; AFNElJ9VX7JQP5rgYIvCKl5ZdcuNsNFGaTT+b94VCO9twb/u1q26G+0puP6sqUnqosfFTt/0AwDnTFc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqLai1E8k8wq/UfXcVrxPeCcFWoZ8VxnZPxp/7S5aZ4U51Yzmv
	f2qrIgT8Z1LA0+5MXAfGDf6JWL9hLbmn4uyV6vbTqdDoXQA73rTlMP68MIv3IepmEjm1UssitHn
	B32ENQg==
X-Received: from pjbpc8.prod.google.com ([2002:a17:90b:3b88:b0:37c:a479:69f5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:558c:b0:369:73a:326a
 with SMTP id 98e67ed59e1d1-37c9e9c8c91mr4984736a91.13.1781731262980; Wed, 17
 Jun 2026 14:21:02 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:21:02 -0700
In-Reply-To: <ajKcDRqT5m069PXK@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260615155244.183044-1-alexandru.elisei@arm.com>
 <20260615160901.9A1A61F000E9@smtp.kernel.org> <ajA6ogaNiI3KDv5i@google.com> <ajKcDRqT5m069PXK@raptor>
Message-ID: <ajMPvgA2eHQCj-B0@google.com>
Subject: Re: [RFC PATCH] KVM: Ignore MMU notifiers for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: sashiko-reviews@lists.linux.dev, Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 17, 2026, Alexandru Elisei wrote:
> Hi Sean,
> 
> Thanks for the reply. Just to make sure, once the bugs have been iron out,
> you're ok with this idea?
> 
> On Mon, Jun 15, 2026 at 10:47:14AM -0700, Sean Christopherson wrote:
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
> I've been trying to wrap my head around this, and I just can't seem to
> figure it out.
> 
> kvm_mmu_notifier_invalidate_range_start(), before handle_hva_range(), calls
> gfn_to_pfn_cache_invalidate_start() for the MMU notifier range, and that
> marks all caches that overlap the range as invalid. kvm_gpc_check() returns
> false for an invalid cache, so how can the memory still be accessed via the
> pfncache?

That just forces gpcs to be refreshed, mmu_notifier_retry_cache() still relies
on mmu_invalidate_seq being bumped to avoid consuming stale state.

> > > By unmapping the anonymous memory, the host would trigger MMU notifiers, but
> > > this new check skips the memslot. As a result, kvm->mmu_invalidate_seq
> > > wouldn't increment, and KVM might retain a kernel mapping to a freed physical
> > > page.
> 
> kvm->mmu_invalidate_seq is incremented in kvm_mmu_invalidate_end(), I don't see
> how that is affected by skipping a memslot in handle_hva_range().

handle_hva_range() only invokes on_lock() if a memslot is found.  By skipping the
memslot entirely, kvm_mmu_invalidate_{start,end}() won't be called and so
mmu_invalidate_seq won't be bumped.

> > > Could this allow the guest to read or write arbitrary host physical memory?
> 
> The KVM_MEMSLOT_GMEM_ONLY flag is set if the backing guest_memfd has been
> created with GUEST_MEMFD_FLAG_MMAP. The documentation for the flag says
> that '[..] the fault will always be consumed from guest_memfd, regardless
> of whether it is a shared or private fault'.  As far as I can tell, this
> means that, absent a fallocate(FALLOC_FL_PUNCH_HOLE) call, the page is
> still in the page cache for the guest_memfd file after userspace has
> unmapped it, so the guest will not be accessing a freed page.

KVM_MEMSLOT_GMEM_ONLY is somewhat misleading, it only applies to the KVM's MMU.
For other cases where KVM accesses guest memory, KVM still follows the host virtual
address, e.g. so that copy_{to,from}_user() Just Works.  But userspace isn't
strictly *required* to keep the userspace mapping coherent with guest_memfd, nor
is userspace required to make the userspace mapping fully RWX.  And so if
userspace modifies the VMA, KVM needs to react accordingly.

When in-place conversion comes along, KVM will also rely on userspace mappings
being torn down before allow a SHARED page to become PRIVATE (for all intents
and purposes, we're conceptually treating conversions as free()+re-alloc().  So
while the page might still be in the page cache, it's effectively been "freed".
So in that case, KVM really does need to ensure it handles mmu_notifier events
correctly to avoid UAF.
