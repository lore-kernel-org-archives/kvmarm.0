Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959152EEE6D
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783345557; cv=none; b=QrxpwzWFE40edjSUou9qWc8IUDPEmU+4GE0vnFGvhVOJzuIj09cn4PsUHL2mRbby9JxZ3t/qPZjuye0YvCwv2ieOqXQcBED4FVbWBhFgbpyVFVwt6foO2Oha1ClXna87QOewbgJVnzVhaDQH4XOYwlllZ8w24Ybjqv+Y4m673mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783345557; c=relaxed/simple;
	bh=th5EeEUXoKQ4TR+tt8Q4dRhijquxd6smyNGP3zo6QQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OIG+rlfLYAWLyPZLoz5koQ/kicpY8Xw+ZmPdubVluTOrn+ynK6y/zXs/H56pWY9ILvz5yinTbh+qwPcEvv/fDcIz++Y79nHs8OAUJA1Jc8ofl5OWfVx+ud0gFxZTQEDGi+RnCjMwVuuOQsAeygRtFkMa4Zt4guzXiUf0P9youDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=W2GppfMX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="W2GppfMX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF27A2BCB;
	Mon,  6 Jul 2026 06:45:50 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC5143F7B4;
	Mon,  6 Jul 2026 06:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783345555; bh=th5EeEUXoKQ4TR+tt8Q4dRhijquxd6smyNGP3zo6QQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W2GppfMXasQ5lro8a8fcRVZt6AaeV3Kv1GyrpwouxSCIkurP5XyZ5uM1j5Mv4LcZ0
	 uJyqjvtz6yhrlYwU06Ed30KbDASihPN65fQLvfrApSb6ShTvM3uJax/A0+nN+Ht/Lu
	 mHi79WNThvdn+2afPlBMLscumLB8yTFp0FBYagGY=
Date: Mon, 6 Jul 2026 14:45:49 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: David Hildenbrand <david.hildenbrand@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, seanjc@google.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev, mark.rutland@arm.com
Subject: Re: [RFC PATCH 1/3] KVM: guest_memfd: Use memslot id to keep track
 of associated memslots
Message-ID: <akuxjY-VRrmcybjZ@raptor>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-2-alexandru.elisei@arm.com>
 <8a24f016-6f0f-4322-b646-d843f6fa481e@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a24f016-6f0f-4322-b646-d843f6fa481e@arm.com>

Hi David,

Thanks for having a look.

On Mon, Jul 06, 2026 at 09:14:59AM +0200, David Hildenbrand wrote:
> On 7/2/26 16:29, Alexandru Elisei wrote:
> > To enable memslot operations, KVM maintains two arrays of memslots, and an
> > RCU pointer to the active (in use) array. Changes are made first to the
> > inactive array, and the RCU pointer is updated to point to the inactive
> > array, which becomes active.
> > 
> > The guest_memfd file maintains an xarray of pointers to memslots that use
> > it as the memory provider. After the RCU pointer to the active memslots is
> > updated and until SRCU is synchronized, readers can observe the old or the
> > new value for the active array, and therefore the old or the new pointer
> > for a given memslot.  For memslot creation or deletion that is not an issue
> > for guest_memfd, as readers will either read the same memslot pointer saved
> > by the guest_memfd file, or a non-existing memslot.
> > 
> > But when changing the flags for a memslot, readers can read two different
> > and non-NULL memslot pointers. Since there is no easy way to ensure that
> > the memslot pointer that the guest_memfd stores is consistent with both
> > views at the same time, modify how the guest_memfd file keeps track of the
> > associated memslots: instead of storing the pointer directly, store the
> > memslot id and address space id (as_id), and use that to reach the memslot
> > in the active list of memslots.
> > 
> > This only changes how guest_memfd keeps track of memslots, userspace is not
> > allowed to make changes to a memslot yet.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  virt/kvm/guest_memfd.c | 95 +++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 80 insertions(+), 15 deletions(-)
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index db57c5766ab6..43ef8e908aaf 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -25,6 +25,7 @@ struct gmem_file {
> >  	struct kvm *kvm;
> >  	struct xarray bindings;
> >  	struct list_head entry;
> > +	bool found_memslot;	/* Used for balancing invalidations when punching a hole */
> 
> Probabably best to document what it means, not only what it is used for (and
> maybe document above the member if you end up with more text).

Sure, this is how I changed it:

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 210bdd76f0aa..3cee64047bce 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -25,7 +25,13 @@ struct gmem_file {
        struct kvm *kvm;
        struct xarray bindings;
        struct list_head entry;
-       bool found_memslot;     /* Used for balancing invalidations when punching a hole */
+       /*
+        * Keeps track of whether memory has been unmapped during secondary MMU
+        * invalidation, to keep the invalidate start and end calls balanced.
+        *
+        * Accessed while holding the inode->i_mapping lock in exclusive mode.
+        */
+       bool memslot_invalidated;
 };

Hopefully the new name is better.

> 
> >  };
> >  
> >  struct gmem_inode {
> > @@ -43,6 +44,29 @@ static __always_inline struct gmem_inode *GMEM_I(struct inode *inode)
> >  #define kvm_gmem_for_each_file(f, inode) \
> >  	list_for_each_entry(f, &GMEM_I(inode)->gmem_file_list, entry)
> >  
> > +static void *memslot_to_xa_value(struct kvm_memory_slot *slot)
> > +{
> > +	WARN_ON_ONCE(sizeof(slot->as_id) > 16);
> > +	WARN_ON_ONCE(sizeof(slot->id) > 16);
> > +	WARN_ON_ONCE(sizeof(slot->as_id) + sizeof(slot->id) > sizeof(unsigned long));
> 
> These can just be BUILD_BUG_ON() I suppose.

That's a good idea, will do.

> 
> > +
> > +	return xa_mk_value(((unsigned long)slot->as_id) << 16 | (unsigned long)slot->id);
> 
> The latter "(unsigned long)" should not be required.

Indeed.

> 
> > +}
> > +
> > +static struct kvm_memory_slot *xa_value_to_memslot(struct kvm *kvm, const void *entry)
> > +{
> 
> The following can all be const.
> 
> > +	unsigned long full_id = xa_to_value(entry);
> > +	u16 as_id = (full_id >> 16) & U16_MAX;
> 
> Why the "& U16_MAX" here?
> 
> (1) It's an u16
> 
> (2) memslot_to_xa_value() never stores anything in there.
> 
> > +	short id = full_id & U16_MAX;
> 
> Same here. And I wonder why you are not also using an u16 here.

I wanted to make it clear that everything should fit in a u16, I think I
wrote this code before the WARN_ON_ONCE in memslot_to_xa_value() above and
I forgot to change it.

I will clean it up.

> 
> > +
> > +	/*
> > +	 * Do not ignore KVM_MEMSLOT_INVALID memslots, as we want
> > +	 * ->error_remove_folio(), when it races with memslot deletion, to have
> > +	 *  unmapped the memory upon completion.
> > +	 */
> > +	return id_to_memslot(__kvm_memslots(kvm, as_id), id);
> > +}
> > +
> >  /**
> >   * folio_file_pfn - like folio_file_page, but return a pfn.
> >   * @folio: The folio which contains this index.
> > @@ -157,7 +181,7 @@ static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *in
> >  	return KVM_FILTER_PRIVATE;
> >  }
> >  
> > -static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
> > +static bool __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
> >  					pgoff_t end,
> >  					enum kvm_gfn_range_filter attr_filter)
> >  {
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
> 
> That now gets more expensive. id_to_memslot() uses a hashtable, but there is
> certainly more pointer chasing going on now.

Yes, a hashtable search, plus a few more pointer dereferences and an
srcu_read_lock()/unlock() pair is more expensive than accessing the memslot
pointer directly from f->bindings.

Depending on the range, kvm_mmu_unmap_gfn_range() can be quite expensive.
gfn_range->may_block is set, this communicates to the arch code that they
can resched periodically if the range is too big (at least, that's what it
means on arm64, which sleeps every THP sized address range, chosen
empirically as to stop RCU from complaining). Plus, there's also the TLB
flush at the end. My gut feeling is that the extra overhead from how the
memslot is found is insignificant in this case, but I don't have the
numbers to back it up. I can try to get some numbers, if you think that
would be useful?

But that's when there's actually a range to unmap from the secondary MMU.
Let's say there's no range. The invalidations are performed when:

1. The file is closed.
2. Userspace punches a hole in the file.
3. Memory error.

I'm going to assume that the memory error happens very rarely, so it's not
worth to optimize for it.

Userspace closes the file when the VM is being destroyed, does it matter if
it's slightly slower, considering how many other things are usually
unmapped and/or freed during VM teardown? I don't know the answer to that.

As for userspace punching a hole. Two situations here:

(a) No memslots are using the file. I think it's unlikely for userspace to
punch a hole in a file when it's not being used by any VMs (am I wrong?)

(b) There are memslots using the file, but the memory hasn't been mapped
yet by a secondary MMU. In that case, the arch code will still walk the
secondary MMU page tables. Considering that punching a hole also requires a
transition from userspace to the kernel and back, I don't think that the
overhead will be noticeable.

What do you think? Do you think my analysis is correct or have I missed
something?

I'm very willing to consider another approach if you think we can do it
better.

Thanks,
Alex
