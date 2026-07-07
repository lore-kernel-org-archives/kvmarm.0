Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461B9375ADF
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783443965; cv=none; b=fc8ANl7B6Nw92YYeG1VE7dtZ7ddmlK0DEF2InL+7wwJqLWVev5fbUeMR7QvZ6EJACI76KTEd1jC5gg1dxlHtOBrdQDFSflR5oht9LSZueL34FAzrzAAkvykMcVzqdlNN/jvvUpgoyeW/XanBUd8IqOfzSG7Ov6g+rXXkY18W8V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783443965; c=relaxed/simple;
	bh=ucV5WtJiMT7xqag1YtM9Bd4fTSEWyIp6jpJoT0dTmwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MMLUlj4uKnzw6MCBL/31QUx8cN+xrAv3bzke5dcuU5kPoFGfoN5Z08geFP/VIUrVjD253SAh4POqqj1d8waNzfazDRTqU/qOJiue8C+rk+Fsb3Y3nZaKfRRpcN8S1opKxIJTQVgcRzKDXvRTN56y1ETTmh1KNRZp9UP50q6gx8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C84rZEsy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C84rZEsy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 337B11596;
	Tue,  7 Jul 2026 10:05:59 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 553233F905;
	Tue,  7 Jul 2026 10:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783443963; bh=ucV5WtJiMT7xqag1YtM9Bd4fTSEWyIp6jpJoT0dTmwQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C84rZEsys4yeYqvAbSUL8fd3MIZ++2ZudFn/13049kZO1iLz1txJAkZpqDygBZPI3
	 5WFYjDUMQrPm8BT8qassMRgYevdzAWWHSSnPodHK5sVn3o7R8vl0Cfe3UZzNjAbucM
	 e8ou9pLR/cD7kNKXpca2UpMmfTAY+NzpSqdqD7R0=
Date: Tue, 7 Jul 2026 18:05:57 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: David Hildenbrand <david.hildenbrand@arm.com>, pbonzini@redhat.com,
	kvm@vger.kernel.org, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, fuad.tabba@linux.dev, mark.rutland@arm.com
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track
 of associated memslots
Message-ID: <ak0x9VAWz823HnUk@raptor>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com>
 <8a24f016-6f0f-4322-b646-d843f6fa481e@arm.com>
 <akuxjY-VRrmcybjZ@raptor>
 <akwiG_tDu5Eyyc0-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akwiG_tDu5Eyyc0-@google.com>

Hi Sean,

On Mon, Jul 06, 2026 at 02:46:03PM -0700, Sean Christopherson wrote:
> On Mon, Jul 06, 2026, Alexandru Elisei wrote:
> > On Mon, Jul 06, 2026 at 09:14:59AM +0200, David Hildenbrand wrote:
> > > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > > index db57c5766ab6..43ef8e908aaf 100644
> > > > --- a/virt/kvm/guest_memfd.c
> > > > +++ b/virt/kvm/guest_memfd.c
> > > > @@ -25,6 +25,7 @@ struct gmem_file {
> > > >  	struct kvm *kvm;
> > > >  	struct xarray bindings;
> > > >  	struct list_head entry;
> > > > +	bool found_memslot;	/* Used for balancing invalidations when punching a hole */
> > > 
> > > Probabably best to document what it means, not only what it is used for (and
> > > maybe document above the member if you end up with more text).
> > 
> > Sure, this is how I changed it:
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 210bdd76f0aa..3cee64047bce 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -25,7 +25,13 @@ struct gmem_file {
> >         struct kvm *kvm;
> >         struct xarray bindings;
> >         struct list_head entry;
> > -       bool found_memslot;     /* Used for balancing invalidations when punching a hole */
> > +       /*
> > +        * Keeps track of whether memory has been unmapped during secondary MMU
> > +        * invalidation, to keep the invalidate start and end calls balanced.
> > +        *
> > +        * Accessed while holding the inode->i_mapping lock in exclusive mode.
> > +        */
> > +       bool memslot_invalidated;
> >  };
> > 
> > Hopefully the new name is better.
> 
> Why add a boolean?  It's not _needed_ to balance updates, or rather it shouldn't
> be needed.  filemap_invalidate_lock() prevents modifying bindings while an
> invalidation is in-progress.  It might be a performation optimization, but if so,
> it's a premature one and belongs in a separate patch.

It's not about bindings being modified. This is the race I am trying to avoid:

CPU0:							CPU1:

KVM_SET_USER_MEMORY_REGION(slot, memory_size=0)
kvm_replace_memslot(kvm, slot, invalid_slot)
kvm_swap_active_memslots(kvm)
kvm_replace_memslot(kvm, invalid_slot, NULL)
kvm_swap_active_memslots(kvm)
							fallocate(guest_memfd, FALLOC_FL_PUNCH_HOLE)
							  __kvm_gmem_invalidate_start()
							    slot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
							    if (slot == NULL) {
								    // Early exit, does not call kvm_mmu_invalidate_start(kvm)
								    return;
							    }
							  __kvm_gmem_invalidate_end()
							    // No corresponding kvm_mmu_invalidate_start(kvm) call
							    kvm_mmu_invalidate_end(kvm)
kvm_replace_memslot(kvm, invalid_slot, NULL);
kvm_free_memslot(kvm, slot)
  kvm_gmem_unbind(slot)

Does that make sense?

Thanks,
Alex
