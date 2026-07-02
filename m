Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C151208D0
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783008566; cv=none; b=kyKE1RtYnUXKrPqF9FTfHZ61TtyQZr6Q2BrezDTsuclokSH5efam/qnFOzs9LWdJCoSR45lP0MJZzOGh4p2tcdlyTZVvNirWxn9doYWOJRcN8C7L+aQDJ58uGcp2X4W/RRpgu1+agv0gOJC5v+XNgPjoKSJBFdDTIjWUoGmUJn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783008566; c=relaxed/simple;
	bh=S77W9cIR3o9ACy54Ve+uye7dbsSi4rgl5u0tgxy6qIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oc/p+fVg8KRiVkWjne29oAhFrm2APb0cA8r2qH1+JXYe2TeYP/84Wag+USKVsUVj5uAUwMuTp7BQ2DNktCy1p6fQMwFmKDiAXCugy6TA7vEEHeUaf/VZBgM6ftyOn7EopaQWI2JtuDJDdaVNVbbxR+mDY/A1knZhhix34tF1EG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZgFREfHW; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZgFREfHW"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E67C9359D;
	Thu,  2 Jul 2026 09:09:17 -0700 (PDT)
Received: from e140010.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A9B83F673;
	Thu,  2 Jul 2026 09:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783008562; bh=S77W9cIR3o9ACy54Ve+uye7dbsSi4rgl5u0tgxy6qIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZgFREfHW+1GTiT6mhy+ONW8QxS62QijNtA1Zs3XUyLQrr96Qo/ZBSlwUT426osBI6
	 lWBp66hbiWSyK5JYHk9deTiWjg2N9EUO6uUhZivcPmn50WCEG1tRvp1QNcjJZaSOeL
	 XVO0MbTtckCd/vgbYCTOfMx0SwjjKxH7RiynQNV0=
Date: Thu, 2 Jul 2026 17:09:19 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-bot@kernel.org
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track
 of associated memslots
Message-ID: <akaNL9Zvwx-pixXP@e140010.arm.com>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com>
 <20260702144758.9D5821F00ADF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260702144758.9D5821F00ADF@smtp.kernel.org>

On Thu, Jul 02, 2026 at 02:47:57PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Stale SPTEs are left mapped during concurrent memslot deletion, causing a Use-After-Free when backing folios are freed.
> - [Low] Silent suppression of kernel warnings for memslot 0 mismatches.
> --
> 
> commit ca8b0f095e48299dd0d910de62ee16780d361eec
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: guest_memfd: Use memslot id to keep track of associated memslots
>     
> To enable memslot operations, KVM maintains two arrays of memslots, and an
> RCU pointer to the active (in use) array. Changes are made first to the
> inactive array, and the RCU pointer is updated to point to the inactive
> array, which becomes active.
> 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index db57c5766ab60..43ef8e908aaf6 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> 
> [ ... ]
> 
> > @@ -165,9 +189,15 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
> >  	struct kvm_memory_slot *slot;
> >  	struct kvm *kvm = f->kvm;
> >  	unsigned long index;
> > +	void *entry;
> > +
> > +	xa_for_each_range(&f->bindings, index, entry, start, end - 1) {
> > +		pgoff_t pgoff;
> >  
> > -	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
> > -		pgoff_t pgoff = slot->gmem.pgoff;
> > +		slot = xa_value_to_memslot(kvm, entry);
> > +		if (!slot)
> > +			continue;
> > +		pgoff = slot->gmem.pgoff;
> 
> [Severity: Critical]
> Could this leave stale SPTEs mapped during concurrent memslot deletion,
> leading to a Use-After-Free?
> 
> If a guest_memfd hole punch executes concurrently while a KVM_MR_DELETE
> operation is waiting in synchronize_srcu(), xa_value_to_memslot() will return
> the invalid_slot. Because kvm_copy_memslot() does not copy the conditionally
> compiled gmem struct, invalid_slot->gmem.pgoff is 0.
> 
> When __kvm_gmem_invalidate_start() calculates the gfn_range using a 0 pgoff,
> it can result in start >= end, causing kvm_mmu_unmap_gfn_range() to skip
> zapping the SPTEs. When the backing folios are then freed by
> truncate_inode_pages_range(), the guest could access freed host memory.

I think that's a genuine bug. I could teach kvm_copy_memslot() about
guest_memfd, and also copy slot->gmem.

> 
> [ ... ]
> 
> > @@ -765,8 +830,8 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
> >  		return ERR_PTR(-EFAULT);
> >  	}
> >  
> > -	if (xa_load(&f->bindings, index) != slot) {
> > -		WARN_ON_ONCE(xa_load(&f->bindings, index));
> > +	if (xa_load(&f->bindings, index) != memslot_to_xa_value(slot)) {
> > +		WARN_ON_ONCE(xa_to_value(xa_load(&f->bindings, index)));
> 
> [Severity: Low]
> Will this suppress the intended warning when the corruption involves memslot 0?
> 
> If the xarray state erroneously points to memslot 0 (as_id=0, id=0),
> xa_load() returns xa_mk_value(0). xa_to_value() unwraps this to 0, causing
> WARN_ON_ONCE(0) to evaluate to false and fail to warn.
> 
> (This logic would also similarly suppress the warning in kvm_gmem_change_flags()
> when there is a structural state inconsistency involving memslot 0).

I can replace the WARN_ON_ONCE with WARN_ONCE().

Thanks,
Alex

> 
> >  		return ERR_PTR(-EIO);
> >  	}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260702142912.6395-1-alexandru.elisei@arm.com?part=1
