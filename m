Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1007B304BDF
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 01:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783387755; cv=none; b=RbNoH6BWm3VSv81SkZ4igZeXJUclsbfNayn0AUQxIm7ptmFcefdl0XUxu9DUtcGQ2DNJYrdoklDaZmGiqMDWROVrENlyi4JLtVHB5/k0eA9JwqgfLQSsikDDnxnAuEneIkbmh8qq0tg3MWQBHpOCkGDNgJ2oqsET0La3R1nQZGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783387755; c=relaxed/simple;
	bh=t3u0djZufF1SsLgKNoCNQk8yVLK9F2tNnlZ9arQlsIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nk9l1jO20vL/LE9jUSCsEklG0+WlcTQA1ciJSMU76x8ygAkG+kNhmcmmZE1EeLZF/Z46pah8NJSHxP+ujMrjmAkgLeyehUsI2YrxKajo0AZdPwMwbZbG6Oh+o2IGZUsvahnrbKnTinJLqoN2JpJ4eotCcjsmEB54tgfkN+SWjoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vy9PUGLK; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vy9PUGLK"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c8924f4d0a4so5241068a12.2
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 18:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783387752; x=1783992552; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1SuuC485gSBLkrfrkGL1+hrWpooElzJwMrZMY1F1ZXI=;
        b=Vy9PUGLKqrSpD9t7PKtBRHzQPrAKXf8cIJ3njjmEGrfmt+wDwSC3IyV8cdkz8o+1sv
         Zz9Thg10OEfJPR1yfu/YxpiqZn2kKtPlEvtU1WxCdg4S+OQVF554CwjYDi6FpDQeiNak
         fObAWzdonmxrz9x7LVhAknMAsxALGO0RjPw9iF5FWdb9QljHBhgJrZ3Qwyr1zk3Mxb5H
         PquKPZMd+p9SaDhRO/EudQSCIDCo+SB4UGwvMb8Q2+UKEaKvKccAPliXHq0WSa94TXBL
         Jt37iLjNoERKfzdAgVpGpogfFklMSaMoKMGO6HUMCM9dYW+q1R97aXPs25Rw3+Zxp51m
         EzOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783387752; x=1783992552;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1SuuC485gSBLkrfrkGL1+hrWpooElzJwMrZMY1F1ZXI=;
        b=KROOn0HuiteD8NBcYQPT0WVZfp6TxZbAT0djafzLJW3nIvHDHmELbbfMOD6EhS09w0
         vYeYPeB6m8+dZFj79C57SSCJESrk1J+tRL3kZs2Ro62bhkdp6drhxTatsYEguaN7VGi1
         XrNw8Wy/MGdvgbzI7oab8hJ3hVd1QjOsD056+0umIeNhUGx49xF/mrbXhWBgaA8IF+sa
         GYnImxew9mI4JbRJK24HDYYB1tcGWarCxp83RcuYCSOt1cuoXbO+giAspCORQmFeIPuO
         hj2nQYDlmCx9RuDDl3fpXcWz0lwVxNoGym+ltMBrr/z27irmU/+5syTY3Dnkz+WKbkl8
         qMfA==
X-Forwarded-Encrypted: i=1; AHgh+RqOFSCI9G2gL95SQ8K8qIjsRF5l6FnjgE8OElbxpo6WBHhz+gAFjycCaQdDILw0o13isAtogEg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH5SdCzfLk23naRuPWOoVivB0F8POO3ZcCXebVM4ojJcGqNZU1
	vsoqRcgQ4CXzyCAWK3dZ44y1atfatAyOWgdxdd5gW7DLqWmCjF1xeoxVSp8ywrVX2YycujUlSYT
	r7WK61w==
X-Received: from pfst41.prod.google.com ([2002:aa7:8fa9:0:b0:842:3ec1:2810])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4298:b0:845:e7f7:9ce7
 with SMTP id d2e1a72fcca58-84826e86506mr2694680b3a.32.1783387751990; Mon, 06
 Jul 2026 18:29:11 -0700 (PDT)
Date: Mon, 6 Jul 2026 18:29:11 -0700
In-Reply-To: <20260702142912.6395-3-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com> <20260702142912.6395-3-alexandru.elisei@arm.com>
Message-ID: <akxWZ1NTX4DHnUzf@google.com>
Subject: Re: [RFC PATCH 2/3] KVM: Implement dirty page logging for
 guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, david.hildenbrand@arm.com, 
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	fuad.tabba@linux.dev, mark.rutland@arm.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> The entire memory represented by guest_memfd-only memslot is shared and
> accessible by userspace.

...

> +8.48 KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES
> +---------------------------------------------
> +
> +:Architectures: all
> +
> +The presence of this capability indicates that memslots backed by a guest_memfd
> +file descriptor created with the GUEST_MEMFD_FLAG_MMAP flag can have dirty
> +page logging enabled.

What does mmap() have to do with anything?  Supporting mmap() doesn't guarantee
the memory is shared, and I can't think of any dependency on memory actually
being mapped into userspace.

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 43ef8e908aaf..210bdd76f0aa 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -622,6 +622,11 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>  	return true;
>  }
>  
> +bool __weak kvm_arch_supports_gmem_mmap_dirty_logging(struct kvm *kvm)
> +{
> +	return false;
> +}
> +
>  static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  {
>  	static const char *name = "[kvm-gmem]";
> @@ -705,6 +710,66 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	return __kvm_gmem_create(kvm, size, flags);
>  }
>  
> +static int __kvm_gmem_check_no_change(struct kvm *kvm, struct kvm_memory_slot *old,
> +				      struct file *old_file, unsigned int fd,
> +				      loff_t offset)
> +{
> +	struct file *new_file;
> +
> +	new_file = fget(fd);
> +	if (!new_file)
> +		return -EBADF;
> +	if (new_file != old_file) {

There's a TOCTOU issue here, no?  Nothing prevents userspace from deleting and
replacing the old guest_memfd instance between now and when the re-binding
happens.  Ah, no, because the check in kvm_set_memory_region() is only to check
for a "nop" update.  I think we should continue to disallow such "updates", I
can't think of any reasonable use case, and then we can fold this helper into
its sole remaining caller. 

> +		fput(new_file);
> +		return -EBADF;
> +	}
> +	fput(new_file);
> +
> +	if (old->gmem.pgoff != offset >> PAGE_SHIFT)

This can and should be handled in common KVM, not in guest_memfd.  It's a
property of the memslot, not of the gmem instance.

> +		return -EINVAL;
> +
> +	return 0;
> +}
> +int kvm_gmem_change_flags(struct kvm *kvm, struct kvm_memory_slot *old,

Hmm, if we use a separate helper, I think this should be phrased in terms of
commands to guest_memfd, not in terms of why common KVM is making changes.
guest_memfd shouldn't have to care *why* it's being asked to re-bind to a
different memslot.

Alternatively, provide kvm_gmem_commit_memory_region() and pass in a
kvm_mr_change param, but that gets weird since the unbind() case needs to be
handled even without an explicit DELETE.

> @@ -734,6 +799,11 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
>  		goto err;
>  
> +	if (slot->flags & KVM_MEM_LOG_DIRTY_PAGES &&
> +	    (!kvm_gmem_supports_mmap(inode) ||
> +	     !kvm_arch_supports_gmem_mmap_dirty_logging(kvm)))

I think I would rather handle this in kvm_arch_prepare_memory_region().  AFAIK,
arm64 and x86 are the only architectures that support using gmem for private
memory, and so are the only architectures that would need to restrict dirty
logging (TDX needs additional plumbiong).  It'd mean updating x86 at the same
time, but that should be relatively straighforward.

That would mean we couldn't handle the check in check_memory_region_flags(), but
that should be a non-issue, e.g. arm64 and RISC-V already put additional
restrictions on what can regions be dirty-logged.

> @@ -1739,16 +1739,6 @@ static void kvm_commit_memory_region(struct kvm *kvm,
>  		 */
>  		if (old->dirty_bitmap && !new->dirty_bitmap)
>  			kvm_destroy_dirty_bitmap(old);
> -
> -		/*
> -		 * Unbind the guest_memfd instance as needed; the @new slot has
> -		 * already created its own binding.  TODO: Drop the WARN when
> -		 * dirty logging guest_memfd memslots is supported.  Until then,
> -		 * flags-only changes on guest_memfd slots should be impossible.
> -		 */
> -		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
> -			kvm_gmem_unbind(old);
> -
>  		/*
>  		 * The final quirk.  Free the detached, old slot, but only its
>  		 * memory, not any metadata.  Metadata, including arch specific
> @@ -2073,22 +2063,27 @@ static int kvm_set_memory_region(struct kvm *kvm,
>  		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
>  			return -EINVAL;
>  	} else { /* Modify an existing slot. */
> -		/* Private memslots are immutable, they can only be deleted. */
> -		if (mem->flags & KVM_MEM_GUEST_MEMFD)
> -			return -EINVAL;
>  		if ((mem->userspace_addr != old->userspace_addr) ||
>  		    (npages != old->npages) ||
>  		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD)))
>  			return -EINVAL;
>  
> -		if (base_gfn != old->base_gfn)
> +		if (base_gfn != old->base_gfn) {
>  			change = KVM_MR_MOVE;
> -		else if (mem->flags != old->flags)
> +		} else if (mem->flags != (old->flags & MEMSLOT_USER_FLAGS_MASK)) {
>  			change = KVM_MR_FLAGS_ONLY;
> -		else /* Nothing to change. */
> +		} else if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> +			return kvm_gmem_check_no_change(kvm, old, mem->guest_memfd,
> +							mem->guest_memfd_offset);

As above, just return -EINVAL.

> +		} else {
>  			return 0;
> +		}
>  	}
>  
> +	if (mem->flags & KVM_MEM_GUEST_MEMFD &&
> +	    change != KVM_MR_CREATE && change != KVM_MR_FLAGS_ONLY)

This is a *very* convoluted way of disallowing MOVE.  Handle this above.  E.g.o

		if (base_gfn != old->base_gfn) {
			/* KVM doesn't support moving guest_memfd bindings. */
			if (mem->flags & KVM_MEM_GUEST_MEMFD)
				return -EINVAL;

			change = KVM_MR_MOVE;
		} else if (mem->flags != (old->flags & MEMSLOT_USER_FLAGS_MASK)) {
			if (mem->flags & KVM_MEM_GUEST_MEMFD &&
			    old->gmem.pgoff != mem->guest_memfd_offset)
			change = KVM_MR_FLAGS_ONLY;
		} else if (mem->flags & KVM_MEM_GUEST_MEMFD) {
			return -EINVAL;
		} else {
			return 0;
		}

> +		return -EINVAL;
> +
>  	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
>  	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
>  		return -EEXIST;
> @@ -2105,7 +2100,12 @@ static int kvm_set_memory_region(struct kvm *kvm,
>  	new->flags = mem->flags;
>  	new->userspace_addr = mem->userspace_addr;
>  	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
> -		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
> +		if (change == KVM_MR_CREATE) {

Curly braces aren't needed.

> +			r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
> +		} else if (change == KVM_MR_FLAGS_ONLY) {
> +			r = kvm_gmem_change_flags(kvm, old, new, mem->guest_memfd,
> +						  mem->guest_memfd_offset);
> +		}
>  		if (r)
>  			goto out;
>  	}
> @@ -2117,7 +2117,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
>  	return 0;
>  
>  out_unbind:
> -	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> +	if ((mem->flags & KVM_MEM_GUEST_MEMFD) && change == KVM_MR_CREATE)
>  		kvm_gmem_unbind(new);

This is wrong.  If kvm_set_memslot() failed, the old memslot needs to be bound
back to the guest_memfd instance.  Hmm, but KVM can't guarantee success.  So
unless there's reason why the bind() can't happen under slots_arch_lock, I think
the way to handle this is to only bind once success is guaranteed.  It'll require
plumbing the fd+offset into kvm_set_memslot().

Or I guess add the "fd" to kvm_memory_slot.gmem?  I kinda like that, because then
we can require that userspace really is just updating flags, and not switching
the fd (to a the same file).


E.g. something like this?

diff --git include/linux/kvm_host.h include/linux/kvm_host.h
index ab8cfaec82d3..82385eb9a82e 100644
--- include/linux/kvm_host.h
+++ include/linux/kvm_host.h
@@ -610,6 +610,7 @@ struct kvm_memory_slot {
                 * reference via kvm_gmem_get_file() is protected by
                 * either kvm->slots_lock or kvm->srcu.
                 */
+               int fd;
                struct file *file;
                pgoff_t pgoff;
        } gmem;
diff --git virt/kvm/kvm_main.c virt/kvm/kvm_main.c
index e44c20c04961..0729e7c94816 100644
--- virt/kvm/kvm_main.c
+++ virt/kvm/kvm_main.c
@@ -1946,6 +1946,20 @@ static int kvm_set_memslot(struct kvm *kvm,
                return r;
        }
 
+       if (new->flags & KVM_MEM_GUEST_MEMFD) {
+               if (change == KVM_MR_CREATE)
+                       r = kvm_gmem_bind(...);
+               else if (WARN_ON_ONCE(change == KVM_MR_MOVE))
+                       r = -EINVAL;
+               else if (change == KVM_MR_FLAGS_ONLY)
+                       r = kvm_gmem_rebind(...);
+
+               if (r) {
+                       mutex_unlock(&kvm->slots_arch_lock);
+                       return r;
+               }
+       }
+
        /*
         * For DELETE and MOVE, the working slot is now active as the INVALID
         * version of the old slot.  MOVE is particularly special as it reuses
@@ -2104,21 +2118,14 @@ static int kvm_set_memory_region(struct kvm *kvm,
        new->npages = npages;
        new->flags = mem->flags;
        new->userspace_addr = mem->userspace_addr;
-       if (mem->flags & KVM_MEM_GUEST_MEMFD) {
-               r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
-               if (r)
-                       goto out;
-       }
+       new->gmem.fd = mem->guest_memfd;
+       new->gmem.pgoff = mem->guest_memfd_offset >> PAGE_SHIFT;
 
        r = kvm_set_memslot(kvm, old, new, change);
        if (r)
-               goto out_unbind;
+               goto out;
 
        return 0;
-
-out_unbind:
-       if (mem->flags & KVM_MEM_GUEST_MEMFD)
-               kvm_gmem_unbind(new);
 out:
        kfree(new);
        return r;
