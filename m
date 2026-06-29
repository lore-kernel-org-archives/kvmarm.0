Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D4F3F1ACE;
	Mon, 29 Jun 2026 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782749269; cv=none; b=LW7AfhxSHjwtRBCPSBcGf/hxS02qRl8pCdjqRJdaXbGGScLyaFFkoZmem1HFRpza3mM/KXRfRY4PSjP4O7Q/LKp788eF/4H3jQyBeu5DjgsVIHNivZl4xgHLZComFN4bM1JgyhloqVzUYiiSsSHj6jeThmrlqqg51XB1cksX9E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782749269; c=relaxed/simple;
	bh=Mjvo52VT9PrvJbf5FmuNElarfWOLVI0IFquOoLh0FW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=oaBV8UvPRCq4bV6c2ZnSSSRlJt4cWm5PBpfD6/KQs1H4/wy8VyDDnsuT5PKIWNVhbtp209AvQx97gsy5zPQMYG2HUmI3S5o6GxJhrJDPwfL7YWwyyjA2GLUeSiHbfTkX5285ZZDDI4bBgYN3/mB1EXol5P6GD+pGfWhgOOTGTys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=axnPYlNy; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="axnPYlNy"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CE262574;
	Mon, 29 Jun 2026 09:07:42 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9F473F905;
	Mon, 29 Jun 2026 09:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782749266; bh=Mjvo52VT9PrvJbf5FmuNElarfWOLVI0IFquOoLh0FW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axnPYlNyVV9sjHYiFuBpLDuteyGxPKuSQonJVUQn0fAl9ZI1e2VgCrhK3sYueDzOx
	 kcBOMg0ucnjdwahL7F9n3RJARBuvqxOGlSmLooaXyCicBTowNFB60LaYQHBmSD6jD4
	 XodHw00jel9/bSFfWXSEaOSTqXj5PdpQdo75YQ9Y=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 07/13] kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning
Date: Mon, 29 Jun 2026 17:07:43 +0100
Message-ID: <akKYT8-MDDjtuauF@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629113819.619D91F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-8-leo.bras@arm.com> <20260629113819.619D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:38:18AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Data loss (lost dirty pages) when kvm_arch_dirty_log_clear fails during KVM_GET_DIRTY_LOG.
> - [High] Out-of-bounds read of userspace buffer in kvm_arch_dirty_log_clear during KVM_CLEAR_DIRTY_LOG.
> --
> 
> commit ea34df3acf2397922e1a2152d707b3b9f6012964
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> kvm: Add arch-generic interface for hw-accelerated dirty-bitmap cleaning
> 
> Introduce kvm_arch_dirty_log_clear() that allow implementation of
> arch-specific hardware-accelerated dirty-log routines.
> 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index e44c20c049610..a25b8902cdfc1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2262,6 +2263,10 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
> >  		dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
> >  		memset(dirty_bitmap_buffer, 0, n);
> >  
> > +		if (kvm_arch_dirty_log_clear(kvm, memslot, NULL,
> > +					     dirty_bitmap_buffer, &flush) >= 0)
> > +			goto out;
> > +
> 
> [Severity: Critical]
> If kvm_arch_dirty_log_clear() successfully clears some pages in hardware but
> subsequently fails and returns an error, will the fallback loop overwrite the
> successfully cleared bits?
> 
> It appears that if the arch hook returns an error, KVM falls back to the
> generic software loop which includes:
> 
>     mask = xchg(&dirty_bitmap[i], 0);
>     dirty_bitmap_buffer[i] = mask;
>     
> Because the generic fallback loop blindly overwrites dirty_bitmap_buffer[i]
> with the remaining uncleared bits, could this result in silently losing the
> dirty pages that the arch hook managed to clear before failing?

Yes, it falls back to software. 
But it will only overwrite the bits IF the entry is not empty.

One thing that could happen, though, is that the error happened in 
the middle of the 64-page slot, and the output buffer would contain bits 
set, while the dirty-bitmap also contains them. That would cause the bits 
to be overwritten. To avoid that, we could ask to make sure to only clear 
the dirty-bitmap word/slot if all bits have been cleaned. 

> 
> [ ... ]
> 
> > @@ -2373,6 +2379,10 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
> >  	if (copy_from_user(dirty_bitmap_buffer, log->dirty_bitmap, n))
> >  		return -EFAULT;
> >  
> > +	if (kvm_arch_dirty_log_clear(kvm, memslot, log, dirty_bitmap_buffer,
> > +				     &flush) >= 0)
> > +		goto out;
> > +
> 
> [Severity: High]
> Could passing dirty_bitmap_buffer directly to the arch-specific routine lead
> to an out-of-bounds read?
> 
> When userspace calls KVM_CLEAR_DIRTY_LOG with a first_page > 0, KVM copies
> exactly num_pages bits into dirty_bitmap_buffer starting at index 0.
> 
> If the arch implementation of kvm_arch_dirty_log_clear() assumes the buffer
> represents the entire memslot and reads from it using an absolute offset like
> log->first_page / BITS_PER_LONG, would it read past the end of this
> partially-sized array?
> 

Dealt with this in the implementation. Maybe it should be clear to whoever 
implements it will have to take that into account as well.

