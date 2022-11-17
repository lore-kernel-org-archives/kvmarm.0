Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B328BE0
	for <kvmarm@lists.linux.dev>; Thu, 17 Nov 2022 18:23:31 +0000 (UTC)
Date: Thu, 17 Nov 2022 18:23:23 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668709407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwFVbORM3lkiyGr/+WKBEIKDDUjLVlji+1Do7NRWw78=;
	b=EPyAipG0Y0uPsli1k4NCyXaG1sfwgMAXa1UEGeItlrHceWFfKnGKSK3iyCq3wzRd3DAXf7
	fI3727AVsagQ3/4GUDaNBDmMWcj1o723mEYNDHciLRGE/FuJmJkXW/hDR44vfmraH8cu2c
	n24UNBnI5YYa/xXMwJpR42PArIHvi2Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: Don't acquire RCU read lock for
 exclusive table walks
Message-ID: <Y3Z8G3aCuRzzoq5e@google.com>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
 <20221117174951.GA2916@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117174951.GA2916@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221117182323.si8h2-eVFah9Mt1Jfgd2ovaOaYlhsXz5TEtMR0j1E7I@z>

Hi Will,

Thanks for having a look.

On Thu, Nov 17, 2022 at 05:49:52PM +0000, Will Deacon wrote:
> On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:

[...]

> > -static inline void kvm_pgtable_walk_begin(void) {}
> > -static inline void kvm_pgtable_walk_end(void) {}
> > +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> > +{
> > +	/*
> > +	 * Due to the lack of RCU (or a similar protection scheme), only
> > +	 * non-shared table walkers are allowed in the hypervisor.
> > +	 */
> > +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> > +}
> 
> I think it would be better to propagate the error to the caller rather
> than WARN here.

I'd really like to warn somewhere though since we're rather fscked at
this point. Keeping that WARN close to the exceptional condition would
help w/ debugging.

Were you envisioning bubbling the error all the way back up (i.e. early
return from kvm_pgtable_walk())?

I had really only intended these to indirect lock acquisition/release,
so the error handling on the caller side feels weird:

  static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
  {
  	if (WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED))
		return -EPERM;

	return 0;
  }

  r = kvm_pgtable_walk_begin()
  if (r)
  	return r;

  r = _kvm_pgtable_walk();
  kvm_pgtable_walk_end();

> Since you're rejigging things anyway, can you have this
> function return int?

If having this is a strong motivator I can do a v4.

--
Thanks,
Oliver
