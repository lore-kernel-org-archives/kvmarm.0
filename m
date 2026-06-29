Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C53940D59F;
	Mon, 29 Jun 2026 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782752881; cv=none; b=iNhhn+wDABU/iBqG8NYoS78pqUZs/T2yZKQyMYKJQRiptRPmeqEqbGUBFG425bFcep4EarIBHodzYQV9RxTUMBqXOpjxi1QT4qbmC4SsjfcHB0t4kJYYcHePRye9PqE5UdWFj7PfBjwFw219PMT6kQ2nFj0Fr7dY4Ngj4QNbwMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782752881; c=relaxed/simple;
	bh=2vXj2Z+ySDYf99g0FaN16iYSKJMi15nJTgWcVZ5bAZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=kgnxzjF9XVf4MWfDZwtekBYGZiI5MwpTcp7TaVGLHdYMdinXAv2I/tsoTm4K3h/ph+xlRC3cZT96B6/+N0ysyUKUbJGPVdJo4k1WwLvRQwB44kf7tVfLpHXZV3zNHCd4dJ9iCI0fWb1jYyahMJTkk5beILNYXPTUi53crl6vOc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=t9XyLC1e; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="t9XyLC1e"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2ED2D3565;
	Mon, 29 Jun 2026 10:07:54 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C12123F673;
	Mon, 29 Jun 2026 10:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782752878; bh=2vXj2Z+ySDYf99g0FaN16iYSKJMi15nJTgWcVZ5bAZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9XyLC1eVjfcWPVcU4pC/Z0GAM7INRNX7Ekxn8BTrvtV5Rj1xNu70znSquyOVMJ7H
	 b6E7vFcgy1usg+JkP6NLaXq6coa4DmZJyYI6LEbR8dOjutqRRTsu8KIAs1/3rjC6eK
	 t9M1bY1LK7H4FukSJfvVh1XbDpEJCkk6u9uHDT+8=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 09/13] KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks
Date: Mon, 29 Jun 2026 18:07:55 +0100
Message-ID: <akKma9XqQcurXLa2@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629113938.405FC1F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-10-leo.bras@arm.com> <20260629113938.405FC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:39:37AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [High] Incorrect PMD boundary calculation skips huge page splitting for adjacent PMDs and causes redundant splitting for the last chunk of each PMD.
> - [Low] Variable `split_end` is declared as a Guest Physical Address (`gpa_t`) but assigned and compared as a Guest Frame Number (`gfn_t`).
> - [Low] The local variables `start` and `end` shadow the outer loop bounds.
> --
> 
> commit 8863fe6c6c67ca7006255c8805499ac99f887014
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Dirty-bitmap: avoid splitting previously split blocks
> 
> If previous dirty-clean already split a block, then avoid calling the
> split helper on that block again.
> 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> > @@ -160,6 +160,7 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> >  	u64 ttwl;
> >  	u64 start, end;
> >  	gfn_t base_gfn;
> > +	gpa_t split_end = 0;
> 
> [Severity: Low]
> This isn't a bug, but should split_end be declared as a gfn_t?
> 
> It is declared as a Guest Physical Address (gpa_t) here, but later receives
> a Guest Frame Number (gfn_t) from gpa_to_gfn(). While both compile as u64,
> this mixes address types.
> 
> [ ... ]

Sure, can be changed.

> 
> > @@ -204,10 +205,14 @@ int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> >  
> >  		offset = base_gfn + i * BITS_PER_LONG;
> >  
> > -		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> > -			kvm_mmu_split_huge_pages(kvm,
> > -						 gfn_to_gpa(offset + __ffs(mask)),
> > -						 gfn_to_gpa(offset + __fls(mask) + 1));
> > +		if (kvm_dirty_log_manual_protect_and_init_set(kvm) &&
> > +		    (offset + BITS_PER_LONG > split_end)) {
> 
> [Severity: High]
> Does this comparison check an exclusive GFN against an inclusive GFN?
> 
> The expression offset + BITS_PER_LONG calculates an exclusive boundary,
> while split_end is calculated below as an inclusive boundary:
> 
>     split_end = gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);
> 
> Comparing these might cause a redundant split for the last 64-page batch
> of an already-split PMD.
> 

It can not.
offset+bits_per_long has to be bigger than split_end. Since split_end is 
the last bit of a level-2 block, it starts splitting again only if the 
address > split_end. 

> > +			gpa_t start = gfn_to_gpa(offset + __ffs(mask));
> > +			gpa_t end = gfn_to_gpa(offset + __fls(mask) + 1);
> 
> [Severity: Low]
> This isn't a bug, but do these variables shadow the outer loop bounds?
> 
> The variables start and end declared here share names with the loop bounds:
> 

Yes, they are used as loop bounds.
No they are not re-declared inside a loop, so it should be fine.

>     u64 start, end;
>     ...
>     for (unsigned long i = start; i < end; i++) {
> 
> While scoping rules use the correct variables, shadowing loop control
> variables might make the code prone to subtle bugs during future refactoring.
> 
> > +
> > +			kvm_mmu_split_huge_pages(kvm, start, end);
> > +			split_end = gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);
> 
> [Severity: High]
> Can this alignment skip splitting for the next PMD?
> 
> The variable end is an exclusive physical address:
> 
>     gpa_t end = gfn_to_gpa(offset + __fls(mask) + 1);
> 
> If a block of dirty pages ends exactly at a PMD boundary, ALIGN_DOWN() on
> the exclusive end address aligns it to that boundary. Adding PMD_SIZE - 1
> then advances split_end to the end of the next PMD.

Okay, because this end is non-inclusive in kvm_mmu_split_huge_pages, but 
for split_end it will cause to use the next block of address.

> 
> This would skip huge page splitting for the adjacent PMD, breaking dirty
> logging and potentially causing data corruption during live migration as
> dirty pages would not be tracked at the PTE level.

I need to fix  this in v3.


> 
> > +		}
> >  
> >  		do {
> >  			idx = mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_sz);
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260629111820.1873540-1-leo.bras@arm.com?part=9
