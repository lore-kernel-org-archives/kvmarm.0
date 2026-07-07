Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB89420876
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444347; cv=none; b=fwMINd9ZRpas3EbpHMfuG/1Ypy3l1Y+eSfoCrSc8yuZkCMBrY6S/7+YCzsxnYRhQqrQfrVWPmkKJzh6Z1X7gt0YBHdZtfcsYITGZ4OZmw256R4BJee/0bVlrEkaId0ijXmA1JRNf7z6bYIPBot8qQAB6nhqYIPMEnXEe5BA55Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444347; c=relaxed/simple;
	bh=5Tc7ddqhp21st8vckXa70PpY0lqXJ5LBOVL6j9ItTHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQm//3SPbH1f6bAuG66qq/n8Z9WafYrj+Kggja6AhhbQ4cMuZFMiG1U63yRWJx72s1UpTulrzoReRCSC6b6M4F0fUNCdTcwKfbe/otdoVhi6Xf4VsB5zz0NGmX/4YCbnkR6xdL3hBnbFgNW8tEaxFk3xDmMuEuk97PZ4iCOoC7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sREhjZyG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sREhjZyG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1BCA1596;
	Tue,  7 Jul 2026 10:12:20 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9C803F905;
	Tue,  7 Jul 2026 10:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783444345; bh=5Tc7ddqhp21st8vckXa70PpY0lqXJ5LBOVL6j9ItTHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sREhjZyGPNE0daHy71aKOF2TodUWZY+FJS2qlACj8EciJwpdmYdz7uXDQpMnY806V
	 deNStAnEgFYvHTt0x4HZiITDiZOvh4PodNHqbUj6WWlBxUax116QoFgUWqfPEe9YQw
	 1iwMOHZwtIbR28RNv+yOGei2dwumMYf9sthzvMXA=
Date: Tue, 7 Jul 2026 18:12:20 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, david.hildenbrand@arm.com,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev, mark.rutland@arm.com
Subject: Re: [RFC PATCH 2/3] KVM: Implement dirty page logging for
 guest_memfd-only memslots
Message-ID: <ak0zdNr1LvuF7gvm@raptor>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <20260702142912.6395-3-alexandru.elisei@arm.com>
 <akxWZ1NTX4DHnUzf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akxWZ1NTX4DHnUzf@google.com>

Hi Sean,

On Mon, Jul 06, 2026 at 06:29:11PM -0700, Sean Christopherson wrote:
> On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> > The entire memory represented by guest_memfd-only memslot is shared and
> > accessible by userspace.
> 
> ...
> 
> > +8.48 KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES
> > +---------------------------------------------
> > +
> > +:Architectures: all
> > +
> > +The presence of this capability indicates that memslots backed by a guest_memfd
> > +file descriptor created with the GUEST_MEMFD_FLAG_MMAP flag can have dirty
> > +page logging enabled.
> 
> What does mmap() have to do with anything?  Supporting mmap() doesn't guarantee
> the memory is shared, and I can't think of any dependency on memory actually
> being mapped into userspace.

My bad, it should have been GUEST_MEMFD_FLAG_MMAP +
GUEST_MEMFD_FLAG_INIT_SHARED. I'm not sure what you mean by "dependency on
memory actually being mapped into userspace".

From my point of view, it only makes sense to enable dirty page logging if
the contents of the memory is accessible to userspace, hence I made dirty
page logging depend on userspace having the option to access the memory.
This can only happen if the guest_memfd file is mmap'able and accessible by
userspace. But it doesn't force userspace to actually have the memory
mapped to allow the log dirty pages flag to be set for a guest_memfd backed
memslot. Hm.. now that I think about it, maybe I should have made depend on
guest_memfd also having been created as shared? Though I think that can be
changed with KVM_SET_MEMORY_ATTRIBUTES on x86.

Does that answer your question?

> 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 43ef8e908aaf..210bdd76f0aa 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -622,6 +622,11 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
> >  	return true;
> >  }
> >  
> > +bool __weak kvm_arch_supports_gmem_mmap_dirty_logging(struct kvm *kvm)
> > +{
> > +	return false;
> > +}
> > +
> >  static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
> >  {
> >  	static const char *name = "[kvm-gmem]";
> > @@ -705,6 +710,66 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >  	return __kvm_gmem_create(kvm, size, flags);
> >  }
> >  
> > +static int __kvm_gmem_check_no_change(struct kvm *kvm, struct kvm_memory_slot *old,
> > +				      struct file *old_file, unsigned int fd,
> > +				      loff_t offset)
> > +{
> > +	struct file *new_file;
> > +
> > +	new_file = fget(fd);
> > +	if (!new_file)
> > +		return -EBADF;
> > +	if (new_file != old_file) {
> 
> There's a TOCTOU issue here, no?  Nothing prevents userspace from deleting and
> replacing the old guest_memfd instance between now and when the re-binding
> happens.

When userspace closes a guest_memfd file, for all memslots that use that
file, slot->gmem.file is set to NULL in kvm_gmem_release().
kvm_gmem_release() takes the kvm->slots_lock(), so I don't think changes to
memslots can run concurrently with a guest_memfd instance being closed -
i.e, if a guest_memfd file has been closed then the subsequent memslot
update will see slot->gmem.file = NULL. Or if a memslot update is under
way, slot->gmem.file won't be made NULL until the memslot update completes.

Unless I misunderstood what you were saying.

> Ah, no, because the check in kvm_set_memory_region() is only to check
> for a "nop" update.  I think we should continue to disallow such "updates", I

Sure, I added this here because calling the legacy
KVM_SET_USER_MEMORY_REGION with the same values for the struct
kvm_user_memory_region fields does not return an error.

> can't think of any reasonable use case, and then we can fold this helper into
> its sole remaining caller. 
> 
> > +		fput(new_file);
> > +		return -EBADF;
> > +	}
> > +	fput(new_file);
> > +
> > +	if (old->gmem.pgoff != offset >> PAGE_SHIFT)
> 
> This can and should be handled in common KVM, not in guest_memfd.  It's a
> property of the memslot, not of the gmem instance.

Sure.

> 
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +int kvm_gmem_change_flags(struct kvm *kvm, struct kvm_memory_slot *old,
> 
> Hmm, if we use a separate helper, I think this should be phrased in terms of
> commands to guest_memfd, not in terms of why common KVM is making changes.
> guest_memfd shouldn't have to care *why* it's being asked to re-bind to a
> different memslot.
> 
> Alternatively, provide kvm_gmem_commit_memory_region() and pass in a
> kvm_mr_change param, but that gets weird since the unbind() case needs to be
> handled even without an explicit DELETE.

The way I see it, guest_memfd is not rebinding to a new memslot, since
f->bindings are not changed at any point in the handling of the
KVM_SET_USER_MEMORY_REGION2 call if only the flags are changed.

The function was initially supposed to validate that this indeed is a flag
only change, which means that the guest_memfd fd and file offset are
unchanged.  But then I added the update to new->flags to set the
KVM_MEMSLOT_GMEM_ONLY flag. I guess I could split it into
kvm_gmem_check_flags_update() and kvm_gmem_copy_flags()?

Also, I think the best place for both functions would be in
kvm_set_memory_region():
* That's where the validity of a change to a memslot is checked.
* That's where new->flags is copied from kvm_userspace_memory_region2->flags.

What do you think? Does that make sense?

> 
> > @@ -734,6 +799,11 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
> >  		goto err;
> >  
> > +	if (slot->flags & KVM_MEM_LOG_DIRTY_PAGES &&
> > +	    (!kvm_gmem_supports_mmap(inode) ||
> > +	     !kvm_arch_supports_gmem_mmap_dirty_logging(kvm)))
> 
> I think I would rather handle this in kvm_arch_prepare_memory_region().  AFAIK,
> arm64 and x86 are the only architectures that support using gmem for private
> memory, and so are the only architectures that would need to restrict dirty
> logging (TDX needs additional plumbiong).  It'd mean updating x86 at the same
> time, but that should be relatively straighforward.

Sure, I'll give it a go.

> 
> That would mean we couldn't handle the check in check_memory_region_flags(), but
> that should be a non-issue, e.g. arm64 and RISC-V already put additional
> restrictions on what can regions be dirty-logged.
> 
> > @@ -1739,16 +1739,6 @@ static void kvm_commit_memory_region(struct kvm *kvm,
> >  		 */
> >  		if (old->dirty_bitmap && !new->dirty_bitmap)
> >  			kvm_destroy_dirty_bitmap(old);
> > -
> > -		/*
> > -		 * Unbind the guest_memfd instance as needed; the @new slot has
> > -		 * already created its own binding.  TODO: Drop the WARN when
> > -		 * dirty logging guest_memfd memslots is supported.  Until then,
> > -		 * flags-only changes on guest_memfd slots should be impossible.
> > -		 */
> > -		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
> > -			kvm_gmem_unbind(old);
> > -
> >  		/*
> >  		 * The final quirk.  Free the detached, old slot, but only its
> >  		 * memory, not any metadata.  Metadata, including arch specific
> > @@ -2073,22 +2063,27 @@ static int kvm_set_memory_region(struct kvm *kvm,
> >  		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
> >  			return -EINVAL;
> >  	} else { /* Modify an existing slot. */
> > -		/* Private memslots are immutable, they can only be deleted. */
> > -		if (mem->flags & KVM_MEM_GUEST_MEMFD)
> > -			return -EINVAL;
> >  		if ((mem->userspace_addr != old->userspace_addr) ||
> >  		    (npages != old->npages) ||
> >  		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD)))
> >  			return -EINVAL;
> >  
> > -		if (base_gfn != old->base_gfn)
> > +		if (base_gfn != old->base_gfn) {
> >  			change = KVM_MR_MOVE;
> > -		else if (mem->flags != old->flags)
> > +		} else if (mem->flags != (old->flags & MEMSLOT_USER_FLAGS_MASK)) {
> >  			change = KVM_MR_FLAGS_ONLY;
> > -		else /* Nothing to change. */
> > +		} else if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> > +			return kvm_gmem_check_no_change(kvm, old, mem->guest_memfd,
> > +							mem->guest_memfd_offset);
> 
> As above, just return -EINVAL.

Sure.

> 
> > +		} else {
> >  			return 0;
> > +		}
> >  	}
> >  
> > +	if (mem->flags & KVM_MEM_GUEST_MEMFD &&
> > +	    change != KVM_MR_CREATE && change != KVM_MR_FLAGS_ONLY)
> 
> This is a *very* convoluted way of disallowing MOVE.  Handle this above.  E.g.o
> 
> 		if (base_gfn != old->base_gfn) {
> 			/* KVM doesn't support moving guest_memfd bindings. */
> 			if (mem->flags & KVM_MEM_GUEST_MEMFD)
> 				return -EINVAL;
> 
> 			change = KVM_MR_MOVE;
> 		} else if (mem->flags != (old->flags & MEMSLOT_USER_FLAGS_MASK)) {
> 			if (mem->flags & KVM_MEM_GUEST_MEMFD &&
> 			    old->gmem.pgoff != mem->guest_memfd_offset)
> 			change = KVM_MR_FLAGS_ONLY;
> 		} else if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> 			return -EINVAL;
> 		} else {
> 			return 0;
> 		}

Sure, looks better.

> 
> > +		return -EINVAL;
> > +
> >  	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
> >  	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
> >  		return -EEXIST;
> > @@ -2105,7 +2100,12 @@ static int kvm_set_memory_region(struct kvm *kvm,
> >  	new->flags = mem->flags;
> >  	new->userspace_addr = mem->userspace_addr;
> >  	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> > -		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
> > +		if (change == KVM_MR_CREATE) {
> 
> Curly braces aren't needed.

Sure, I'll remove them, I put them there because the block for
KVM_MR_FLAGS_ONLY, which, even though has only an instruction, spans two
lines.

> 
> > +			r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
> > +		} else if (change == KVM_MR_FLAGS_ONLY) {
> > +			r = kvm_gmem_change_flags(kvm, old, new, mem->guest_memfd,
> > +						  mem->guest_memfd_offset);
> > +		}
> >  		if (r)
> >  			goto out;
> >  	}
> > @@ -2117,7 +2117,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
> >  	return 0;
> >  
> >  out_unbind:
> > -	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> > +	if ((mem->flags & KVM_MEM_GUEST_MEMFD) && change == KVM_MR_CREATE)
> >  		kvm_gmem_unbind(new);
> 
> This is wrong.  If kvm_set_memslot() failed, the old memslot needs to be bound
> back to the guest_memfd instance.  Hmm, but KVM can't guarantee success.  So

The old memslot is still bound to guest_memfd in the sense that f->bindings
still has the same memslot id+as_id assigned to the memslot's gpa range.
There's no rebinding happening when flags are changed because the memslot's
id + as_id are not changed.

I think we might not be on the same page regarding what the previous patch
does, that is where I've changed how guest_memfd keeps track of the
memslots.  Instead of storing a pointer, it now stores the memslot id and
as_id, and uses a search in the active memslots (kvm->memslots) to get the
active memslot by using id and as_id:

  slot = id_to_memslot(__kvm_memslots(kvm, as_id), id)

If userspace punches a hole or kvm_gmem_error_folio() is called while a
memslot flags update is in progress, __kvm_gmem_invalidate_{start,end}()
might observe the old memslot (with the old flags), but I believe that's
ok, because that's also what happens when the MMU notifiers trigger
invalidation during a memslot update.

> unless there's reason why the bind() can't happen under slots_arch_lock, I think
> the way to handle this is to only bind once success is guaranteed.  It'll require
> plumbing the fd+offset into kvm_set_memslot().
> 
> Or I guess add the "fd" to kvm_memory_slot.gmem?  I kinda like that, because then
> we can require that userspace really is just updating flags, and not switching
> the fd (to a the same file).
> 
> 
> E.g. something like this?
> 
> diff --git include/linux/kvm_host.h include/linux/kvm_host.h
> index ab8cfaec82d3..82385eb9a82e 100644
> --- include/linux/kvm_host.h
> +++ include/linux/kvm_host.h
> @@ -610,6 +610,7 @@ struct kvm_memory_slot {
>                  * reference via kvm_gmem_get_file() is protected by
>                  * either kvm->slots_lock or kvm->srcu.
>                  */
> +               int fd;
>                 struct file *file;
>                 pgoff_t pgoff;
>         } gmem;
> diff --git virt/kvm/kvm_main.c virt/kvm/kvm_main.c
> index e44c20c04961..0729e7c94816 100644
> --- virt/kvm/kvm_main.c
> +++ virt/kvm/kvm_main.c
> @@ -1946,6 +1946,20 @@ static int kvm_set_memslot(struct kvm *kvm,
>                 return r;
>         }
>  
> +       if (new->flags & KVM_MEM_GUEST_MEMFD) {
> +               if (change == KVM_MR_CREATE)
> +                       r = kvm_gmem_bind(...);
> +               else if (WARN_ON_ONCE(change == KVM_MR_MOVE))
> +                       r = -EINVAL;
> +               else if (change == KVM_MR_FLAGS_ONLY)
> +                       r = kvm_gmem_rebind(...);
> +
> +               if (r) {
> +                       mutex_unlock(&kvm->slots_arch_lock);
> +                       return r;
> +               }
> +       }
> +
>         /*
>          * For DELETE and MOVE, the working slot is now active as the INVALID
>          * version of the old slot.  MOVE is particularly special as it reuses
> @@ -2104,21 +2118,14 @@ static int kvm_set_memory_region(struct kvm *kvm,
>         new->npages = npages;
>         new->flags = mem->flags;
>         new->userspace_addr = mem->userspace_addr;
> -       if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> -               r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
> -               if (r)
> -                       goto out;
> -       }
> +       new->gmem.fd = mem->guest_memfd;
> +       new->gmem.pgoff = mem->guest_memfd_offset >> PAGE_SHIFT;
>  
>         r = kvm_set_memslot(kvm, old, new, change);
>         if (r)
> -               goto out_unbind;
> +               goto out;
>  
>         return 0;
> -
> -out_unbind:
> -       if (mem->flags & KVM_MEM_GUEST_MEMFD)
> -               kvm_gmem_unbind(new);
>  out:
>         kfree(new);
>         return r;

I can explore that, for sure, thank you for the review!

Alex
