Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56F9407576;
	Mon, 29 Jun 2026 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782752988; cv=none; b=n6yKl/lZ+3kZJqKZfa4dbC9/c6krVbVdpNSlo2jd0TRYKIn19/Uk3hZJxyqJgKO2hR6RuyX5EKkb+vMkpcVj16kxwMWDfEgk6f8u16+JadF6KKHbGFgABlwT8yMWonVuuB95p+OuW/KIskfC8V6IrHvyXiz1U2d5YSHD/G+PNH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782752988; c=relaxed/simple;
	bh=HtYs6nHNYRhKihK/pnZLJUTygtL0W6XFav106LI/DNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=iw7SEI7wm+bLfQX0C/GrFQ5hRjsgO8rAoeCxU9IvAEYIAvC4Vc0UJ+uknVNe3gmc2Vm1hSpjBVhbqOLONreFqs7Zz7wn5Z2Y0YuzfR4MogW2I5qBBz1T5zVYE1eB7JFO9rTU3OUh819ZYvaU5gU1aXhCQ7cyIgM1yJv1YGx2hyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gAFadE7n; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gAFadE7n"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BEA563565;
	Mon, 29 Jun 2026 10:09:40 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34B503F673;
	Mon, 29 Jun 2026 10:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782752985; bh=HtYs6nHNYRhKihK/pnZLJUTygtL0W6XFav106LI/DNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAFadE7nqMC4H76sTmKxXTToqWHnS2wXc/WPOMx94NvoDYSjArCIVVVguFtnc5jFG
	 H4oVVwVT5tj66rUoKI8kpi5QEcgNT1hoHW4ON9RxfqNQxXUMPon1JV3JoNnuaNmUxI
	 gH+U9cp7LQOw83SFXKMa76bpHPAjA8leRS9NEHpU=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 11/13] kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cleaning
Date: Mon, 29 Jun 2026 18:09:42 +0100
Message-ID: <akKm1hXLG-oi1HGh@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629114904.701E81F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-12-leo.bras@arm.com> <20260629114904.701E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:49:03AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Hardware-accelerated dirty ring reset completely bypasses the reset tracepoint.
> --
> 
> commit 8d48fca1a0a1a0e2a8d66dd93d79ffc96e524e83
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cleaning
> 
> This commit introduces kvm_arch_dirty_ring_clear() to allow architectures
> to implement hardware-accelerated dirty-ring routines. It adds a call to
> this new function in kvm_dirty_ring_reset(), which will fall back to the
> software version if the hardware version is not implemented or fails.
> 
> [ ... ]
> 
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index 42de1a511037a..fe4e7da6cc4a6 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -133,6 +134,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> >  	 */
> >  	lockdep_assert_held(&kvm->slots_lock);
> >  
> > +	if (kvm_arch_dirty_ring_clear(kvm, ring, nr_entries_reset) >= 0)
> > +		return 0;
> 
> [Severity: Medium]
> Does this early return bypass the trace_kvm_dirty_ring_reset() tracepoint
> at the bottom of the function?
> 
> When hardware-accelerated dirty ring cleaning succeeds, returning early here
> skips the tracepoint entirely. This could break observability tools and
> scripts that rely on this tracepoint to monitor KVM dirty ring resets.

Ok, sure, I can goto-out to before the tracing, then.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260629111820.1873540-1-leo.bras@arm.com?part=11
