Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 345DB3E5A20;
	Mon,  3 Aug 2026 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785770184; cv=none; b=korWvWwEa3q4zhcVpkh6dX2OaQPMkQn8W08r/H0PudGHt65U7SMl+ZUxZuxuh6Akmgu87CaxbQgD6iz0hlcIqb3USjNu+1fMTwlni8HIgN7ZZnKNWDzz6Hdcpc2Xqpj+rDE+b7YIo0+K9usjBFgVlD8fF+rVwP4cxGZE7qlO0Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785770184; c=relaxed/simple;
	bh=QPzeVFZmTcpN5j8r7Op2BujUO3JAuEXqZv9yIZcf7x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=KhhdeC2r5jnfGDzy1CGJAsNyDWQhYzbg5KFpgJWycbJRDEE4CDOHkSIM2oDj8jQvpqh4UceAGFqHOcB/VMveShCQHs30c1NA1QUlhLFTGQix9BSY8ytXfuMa0pJxLYxuxFtNsdzu9IzLRt/jrSRZhzSx/R29vkxAyOanrKug6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gSnhFMU2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gSnhFMU2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92FFE143D;
	Mon,  3 Aug 2026 08:16:17 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A1B7C3F66F;
	Mon,  3 Aug 2026 08:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785770181; bh=QPzeVFZmTcpN5j8r7Op2BujUO3JAuEXqZv9yIZcf7x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSnhFMU2bW9E/8YC5JxHcRwwTKvqrwkP4+wt0wXgEwpY/gcOSSYjXRMRjdwcU+Qaa
	 Xx8LGK89Rf1aD/jUzFYrqziDv575PrwvBcvUsehXWJrtDWLLGO8PPZWAKsYrGuUK0W
	 nSJNhPJQ9JaFb58kGFG8+C/Yn2fH5BHNHquwyPcQ=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v3 05/11] kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning
Date: Mon,  3 Aug 2026 16:16:18 +0100
Message-ID: <anCwwnBpnetj53Dt@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729110015.372101F00A3A@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-6-leo.bras@arm.com> <20260729110015.372101F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:00:14AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [Critical] Successful hardware dirty log extraction completely bypasses the generic software dirty bitmap, dropping internally-dirtied pages.
> - [Critical] Hardware dirty bits are completely ignored when `KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2` is enabled.
> - [High] Fallback software loop clobbers partial hardware dirty log output and leaks garbage data if `kvm_arch_dirty_log_clear()` fails.
> - [Medium] The `kvm_arch_dirty_log_clear` API overloads two distinct behaviors based on an undocumented `NULL` parameter, risking a NULL pointer dereference in arch implementations.
> --
> 
> --- Patch [5]: [PATCH v3 05/11] kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning ---
> commit 4c5b443921b3fcc7c6b76fa46a7c11e8755ad50f
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning
> 
> This patch introduces kvm_arch_dirty_log_clear() to allow architectures
> to implement hardware-accelerated dirty-bitmap clearing. It adds hooks in
> both kvm_get_dirty_log_protect() and kvm_clear_dirty_log_protect() to try
> the hardware implementation first, falling back to the software loop if it
> fails or is unimplemented.
> 
> > diff --git a/include/linux/kvm_dirty_bit.h b/include/linux/kvm_dirty_bit.h
> > new file mode 100644
> > index 0000000000000..fa4f6b67b6235
> > --- /dev/null
> > +++ b/include/linux/kvm_dirty_bit.h
> 
> [ ... ]
> 
> > +static inline int kvm_arch_dirty_log_clear(struct kvm *kvm,
> > +					   struct kvm_memory_slot *memslot,
> > +					   struct kvm_clear_dirty_log *log,
> > +					   unsigned long *bitmap,
> > +					   bool *flush)
> 
> [Severity: Medium]
> The signature here strongly implies the log parameter is a valid clear
> operation struct. However, when this is called from
> kvm_get_dirty_log_protect(), NULL is passed for the log parameter.
> 
> Could this establish an undocumented API contract where new arch
> implementations blindly dereference the log pointer and cause a host
> kernel panic?

Well, there are 2 users of this functions, and one uses a NULL variable, so 
I don't think anyone will implement something that blingly deferences the 
log pointer.

In any case, I am open to fixing this. How should I add that information?
(Just a comment is enough?)

> 
> > +{
> > +	return -ENXIO;
> > +}
> 
> [ ... ]
> 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 45e784462ec6e..7a13ef69b6e3e 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> 
> [ ... ]
> 
> > @@ -2262,6 +2263,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
> >  		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
> >  		memset(dirty_bitmap_buffer, 0, n);
> >  
> > +		if (kvm_arch_dirty_log_clear(kvm, memslot, NULL,
> > +					     dirty_bitmap_buffer, &flush) >= 0)
> 
> [Severity: Critical]
> Since this hardware clear is invoked inside the else block of the
> if (kvm->manual_dirty_log_protect) check, are hardware dirty bits
> completely ignored when manual protection is enabled?
> 
> Modern VMMs often enable manual dirty log protection by default. Will
> skipping the hardware tracking here result in userspace only receiving
> the software dirty bitmap, potentially causing silent memory corruption
> on the destination after a live migration?
> 

To skip it, kvm_arch_dirty_log_clear() should return a positive (or zero) 
value, meaning any error (ret < 0) will cause it to run the software 
cleaning. If the arch-specific routine skips cleaning and return >=0, then 
it's an implementation bug. 

> [Severity: Medium]
> This is the call site passing NULL for the log parameter.
> 
> As mentioned above, does this pose a risk of NULL pointer dereferences
> for architectural implementations expecting a valid
> struct kvm_clear_dirty_log pointer?

See previous discussion above.

> 
> > +			goto out;
> > +
> 
> [Severity: Critical]
> If kvm_arch_dirty_log_clear() succeeds, this goto out bypasses the generic
> software dirty bitmap processing loop completely.
> 

Yeah, that's what the arch-specific version is about.

> Does this mean KVM's internally-dirtied pages, such as those from MMIO
> emulation or virtual timers marked via mark_page_dirty(), are silently
> dropped from the dirty log?

No, as those are also cleaned as long as they hit the dirty-log (bitmap).

> 
> [Severity: High]
> If the arch-specific hardware routine fails partway through and returns
> an error code, could it leave partial hardware bits in dirty_bitmap_buffer?

It could. That's a implementation decision: should it return all bits and 
clean all using software, or continue where arch-specific version stopped?

> 
> If it falls through to the software loop, the software loop might overwrite
> hardware bits with software bits (if the software bit is 1) and preserve
> garbage hardware bits (if the software bit is 0). Should
> dirty_bitmap_buffer be cleared on failure?
> 

Depending on the fallback strategy, it should be restored to initial state, 
not cleared.


> >  		KVM_MMU_LOCK(kvm);
> >  		for (i = 0; i < n / sizeof(long); i++) {
> >  			unsigned long mask;
> 
> [ ... ]
> 
> > @@ -2373,6 +2379,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
> >  	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
> >  		return -EFAULT;
> >  
> > +	if (kvm_arch_dirty_log_clear(kvm, memslot, log, dirty_bitmap_buffer,
> > +				     &flush) >= 0)
> 
> [Severity: High]
> If the arch hook modifies dirty_bitmap_buffer before failing and
> returning an error, does it corrupt the mask used by the fallback
> clear loop?
> 
> The fallback software loop uses dirty_bitmap_buffer to decide which bits
> to clear. If it contains garbage from a failed hardware clear, could this
> cause the wrong pages to be cleared?

That's the arch-version responsibility to not put garbage in the buffer, 
and restore it depending on their strategy.

> 
> > +		goto out;
> > +
> 
> [Severity: Critical]
> Similar to the GET path, this goto out bypasses the loop that clears bits
> in memslot->dirty_bitmap using atomic_long_fetch_andnot().
> 
> If the hardware clear succeeds, will the software bits remain set
> indefinitely since they are bypassed from being cleared from KVM's
> internal tracking?

Again, it will write-protect all the pages pointed by the dirty-log, which 
is exactly what the sw routine does.

Thanks!
Leo
