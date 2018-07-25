From: Andrew Jones <drjones@redhat.com>
Subject: Re: [RFC PATCH 14/16] KVM: arm64/sve: Add SVE support to register
 access ioctl interface
Date: Wed, 25 Jul 2018 19:20:57 +0200
Message-ID: <20180725172057.tvesmvfjtwe6sxla@kamzik.brq.redhat.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
 <1529593060-542-15-git-send-email-Dave.Martin@arm.com>
 <20180719130433.mfqqnxxlmvhduqri@kamzik.brq.redhat.com>
 <20180725140621.GK4240@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E484A0F9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 13:21:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WwDM2N-FB+wY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jul 2018 13:21:02 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6196404D9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jul 2018 13:21:02 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180725140621.GK4240@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jul 25, 2018 at 03:06:21PM +0100, Dave Martin wrote:
> On Thu, Jul 19, 2018 at 03:04:33PM +0200, Andrew Jones wrote:
> > On Thu, Jun 21, 2018 at 03:57:38PM +0100, Dave Martin wrote:
> > > +
> > > +	if (usize % sizeof(u32))
> > > +		return -EINVAL;
> > 
> 
> Currently we don't enforce the register size to be a multiple of 32 bits,
> but I'm trying to establish a stronger position.  Passing different
> register sizes feels like an abuse of the API and there is no evidence
> that qemu or kvmtool is relying on this so far.  The ability to pass
> a misaligned register ID and/or slurp multiple vcpu registers (or parts
> of registers) is once call really seems like it works by accident today
> and seems not to be intentional design.  Rather, it exposes kernel
> implementation details, which is best avoided.
> 
> It would be better to make this a global check for usize % 32 == 0
> though, rather than burying it in fpsimd_vreg_bounds().
> 
> Opinions?

There's only one reason to not start enforcing it globally on arm/arm64,
and that's that it's not documented that way. Changing it would be an API
change, rather than just an API fix. It's probably a safe change, but...

> 
> > > +
> > > +	usize /= sizeof(u32);
> > > +
> > > +	if ((uoffset <= start && usize <= start - uoffset) ||
> > > +	    uoffset >= limit)
> > > +		return -ENOENT;	/* not a vreg */
> > > +
> > > +	BUILD_BUG_ON(uoffset > limit);
> > 
> > Hmm, a build bug on uoffset can't be right, it's not a constant.
> > 
> > > +	if (uoffset < start || usize > limit - uoffset)
> > > +		return -EINVAL;	/* overlaps vregs[] bounds */
> 
> uoffset is not compile-time constant, but (uoffset > limit) is compile-
> time constant, because the previous if() returns from the function
> otherwise.
> 
> gcc seems to do the right thing here: the code compiles as-is, but
> if the prior if() is commented out then the BUILD_BUG_ON() fires
> because (uoffset > limit) is no longer compile-time constant.

Oh, interesting.

> 
> 
> This is a defensively-coded bounds check, where
> 
> 	if (A + B > C)
> 
> is transformed to
> 
> 	if (C >= B && A > C - B)
> 
> The former is susceptible to overflow in (A + B), whereas the latter is
> not.  We might be able to hide the risk with type casts, but that trades
> one kind of fragility for another IMHO.
> 
> In this patch, the C >= B part is subsumed into the previous if(), but
> because this is non-obvious I dropped the BUILD_BUG_ON() in as a hint
> to maintainers that we really do depend on a property of the previous
> check, so although it may look like the checks could be swapped over
> with no ill effects, really that is not safe.

I'm glad our maintainers can pick up on hints like that :-) Maybe you can
add a comment for mortals like me though.

> 
> 
> Maybe the BUILD_BUG_ON() is superfluous, but I would prefer at least
> to keep a comment here.
> 
> What do you think.
>

Comment plus build-bug or just comment works for me.

> 
> OTOH, if we can show conclusively that we can avoid overflow here
> then the code can be simplified.  But I would want to be confident
> that this is really safe not just now but also under future maintenance.
> 

I agree with thoroughly checking user input. Maybe we can create/use
some helper functions to do it. Those helpers can then get reused
elsewhere, helping to keep ourselves sane the next time we need to
do similar sanity checks.

Thanks,
drew
