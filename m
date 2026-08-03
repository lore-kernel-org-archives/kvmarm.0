Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265C11F3B8A;
	Mon,  3 Aug 2026 16:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773051; cv=none; b=RSpIKO9BYYEp915m5xuF+Tt/NT4VQGdM0gvwB9fj/Zsnm/zGVk/4pmp910/Fd1tBlmORgh7+UAFtn1LP8705/dEScLNsB0yDd2nVwbBoJJknTzrVdziwl01ZEAWZW+G/gMH3NI9enGJvEoY6RYhIT6Y9cTmdOpOA24cx9trqFbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773051; c=relaxed/simple;
	bh=idH/igK9MkfsauQV8y2KH61treGRPNKoNN47XA5mkis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=s/ZTheKkpqv2ere6k5Dn1Gd72vzL871N2Cran62LitrO0TekWWq3jV7yfNnH3W3nEEEvere+fnRNqfxbgoLEHSd801slY3jGM2NypNLIfy483L3uZsL/EAbQ97NXYFnaA/R7kO2rBGghmjyl71W+hTOJVHqo/Y/BTFnS19bNBl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SrhJlcMQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SrhJlcMQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E406143D;
	Mon,  3 Aug 2026 09:04:05 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B2BD3F66F;
	Mon,  3 Aug 2026 09:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785773049; bh=idH/igK9MkfsauQV8y2KH61treGRPNKoNN47XA5mkis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrhJlcMQl17LDFu5BzExvF5qz5axu2lsZn9CrAm6opRE5GP9+W9jmoqyq+WQKjKKN
	 XO9uEuYJdGucWkKsLB5xXdrQDn6xM9oRsSTd5XBV43xYw9A54mFQd9v5+wOIR8GpZi
	 6ih2qqmB5hgQ3eODh2t+KN/CzXtGOzhUFMDFmuAM=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 09/11] kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cleaning
Date: Mon,  3 Aug 2026 17:04:05 +0100
Message-ID: <anC79Slpmwl0yePC@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729111451.EB5EE1F00A3D@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-10-leo.bras@arm.com> <20260729111451.EB5EE1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 11:14:51AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Low] The monolithic `#ifndef CONFIG_HAVE_KVM_HW_DIRTY_BIT` guard causes a build failure for architectures that implement only one of the hardware-accelerated dirty logging hooks.
> - [Low] The undocumented API contract of `kvm_arch_dirty_ring_clear` silently shifts the responsibility of updating KVM dirty ring state to the architecture hook.
> - [Low] Missing forward declaration for `struct kvm_dirty_ring` in `include/linux/kvm_dirty_bit.h`.
> --
> 
> --- Patch [9]: [PATCH v3 09/11] kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cleaning ---
> commit 54695fde1ebfc7f27e678570e500f9d9eb6ecff5
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> kvm/dirty_ring: Add arch-generic interface for hw-accelerated dirty-ring cleaning
> 
> Introduce kvm_arch_dirty_ring_clear() to allow architecture-specific
> hardware-accelerated dirty-ring routines. The call is added to
> kvm_dirty_ring_reset() and falls back to a software version if not
> implemented or if an error is detected.
> 
> > diff --git a/include/linux/kvm_dirty_bit.h b/include/linux/kvm_dirty_bit.h
> > index fa4f6b67b6235..8492979d694e7 100644
> > --- a/include/linux/kvm_dirty_bit.h
> > +++ b/include/linux/kvm_dirty_bit.h
> > @@ -18,6 +18,13 @@ static inline int kvm_arch_dirty_log_clear(struct kvm *kvm,
> >  	return -ENXIO;
> >  }
> >  
> > +static inline int kvm_arch_dirty_ring_clear(struct kvm *kvm,
> > +					    struct kvm_dirty_ring *ring,
> 
> [Severity: Low]
> Does this struct need a forward declaration?
> 
> If this header is included before include/linux/kvm_dirty_ring.h, might this
> cause a compiler warning for struct kvm_dirty_ring being declared inside a
> parameter list?

It's included in proper order

> 
> > +					    int *nr_entries_reset)
> > +{
> > +	return -ENXIO;
> > +}
> > +
> >  #else /* CONFIG_HAVE_KVM_HW_DIRTY_BIT */
> 
> [Severity: Low]
> Could this monolithic config guard cause a build failure if an architecture
> enables CONFIG_HAVE_KVM_HW_DIRTY_BIT to provide kvm_arch_dirty_log_clear(),
> but does not implement kvm_arch_dirty_ring_clear()?
> 

It's a package, you have to provide both. 
If not, provide a return -ENXIO inlined function such as above.


> Because the fallback for kvm_arch_dirty_ring_clear() is excluded when the
> config is enabled, omitting it in the arch-specific header would leave it
> undeclared.
> 
> >  
> >  #include <asm/kvm_dirty_bit.h>
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index 807c45fb1fc7b..3fa62894f3d24 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> 
> [ ... ]
> 
> > @@ -133,6 +134,9 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring,
> >  	 */
> >  	lockdep_assert_held(&kvm->slots_lock);
> >  
> > +	if (kvm_arch_dirty_ring_clear(kvm, ring, nr_entries_reset) >= 0)
> > +		goto out;
> > +
> 
> [Severity: Low]
> Does this bypass implicitly require the arch-specific hook to manually update
> the internal state of the dirty ring?
> 
> If an architecture implements kvm_arch_dirty_ring_clear() and returns success,
> this goto skips the generic software loop. The arch hook would need to
> manually increment ring->reset_index, update *nr_entries_reset, and call
> kvm_dirty_gfn_set_invalid() for each processed entry to avoid corrupting the
> ring state. Is this API contract expected to be documented here?

Yes, since it skips everything else in the function, it's required to do 
the dirty-ring management as well.

Okay, will keep in mind that this file has the comments about this and log 
being NULL from before.

Leo
