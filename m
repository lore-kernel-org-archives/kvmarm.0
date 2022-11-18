Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CDE29A1
	for <kvmarm@lists.linux.dev>; Fri, 18 Nov 2022 12:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD0C433C1;
	Fri, 18 Nov 2022 12:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668773996;
	bh=4JxZQz18/grkc1FqZWiq5Dfac3rhr+RHKptMtajtmCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cmOF3PFW7xBBeFULSHg5Gp+fc3p4MViAOAqdlA/ug0xCIRdSMOJtUoHGsX+QL2mpS
	 bTPOQLjhB86Sys7VFp08puWia/RHlVlLM0wT4B8Z3pbW6tO4Fz3TMvX+G/EVVFOktA
	 /p8qOYNZGe9OhaGAFpw2qLDgDVZBnxxjh/VFwonn2jMINr6L4q9z2m4yxiurj1gV84
	 TN/Sdu7nrtBuQ+iAYXICRRY29b+eTQAyfmYsaA6wKhDK3CVuaU+64QLN3FHpRquzez
	 i4wfrwiA/0x+zSp0NHZWziFGoRsP74OpUmgM2rG6XleEn2/bX78qeeKP5JFaZrL5Yr
	 f4BTl7ZBDC+BQ==
Date: Fri, 18 Nov 2022 12:19:50 +0000
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
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
Message-ID: <20221118121949.GA3697@willie-the-truck>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
 <20221116165655.2649475-3-oliver.upton@linux.dev>
 <20221117174951.GA2916@willie-the-truck>
 <Y3Z8G3aCuRzzoq5e@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Z8G3aCuRzzoq5e@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Message-ID: <20221118121950.b4lXtJqXo6rXy-phIf4oL-UAEVBQCf_aEPu_B11aka4@z>

On Thu, Nov 17, 2022 at 06:23:23PM +0000, Oliver Upton wrote:
> On Thu, Nov 17, 2022 at 05:49:52PM +0000, Will Deacon wrote:
> > On Wed, Nov 16, 2022 at 04:56:55PM +0000, Oliver Upton wrote:
> 
> [...]
> 
> > > -static inline void kvm_pgtable_walk_begin(void) {}
> > > -static inline void kvm_pgtable_walk_end(void) {}
> > > +static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
> > > +{
> > > +	/*
> > > +	 * Due to the lack of RCU (or a similar protection scheme), only
> > > +	 * non-shared table walkers are allowed in the hypervisor.
> > > +	 */
> > > +	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
> > > +}
> > 
> > I think it would be better to propagate the error to the caller rather
> > than WARN here.
> 
> I'd really like to warn somewhere though since we're rather fscked at
> this point. Keeping that WARN close to the exceptional condition would
> help w/ debugging.
> 
> Were you envisioning bubbling the error all the way back up (i.e. early
> return from kvm_pgtable_walk())?

Yes, that's what I had in mind. WARN is fatal at EL2, so I think it's
better to fail the pgtable operation rather than bring down the entire
machine by default. Now, it _might_ be fatal anyway (e.g. if we were
handling a host stage-2 fault w/ pKVM), but the caller is in a better
position to decide the severity.

> I had really only intended these to indirect lock acquisition/release,
> so the error handling on the caller side feels weird:
> 
>   static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
>   {
>   	if (WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED))
> 		return -EPERM;
> 
> 	return 0;
>   }
> 
>   r = kvm_pgtable_walk_begin()
>   if (r)
>   	return r;
> 
>   r = _kvm_pgtable_walk();
>   kvm_pgtable_walk_end();

This doesn't look particularly weird to me (modulo dropping the WARN, or
moving it to _end()), but maybe I've lost my sense of taste.

> > Since you're rejigging things anyway, can you have this
> > function return int?
> 
> If having this is a strong motivator I can do a v4.

It's a really minor point, so I'll leave it up to you guys.

WIll
