From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: Treat FPEXC32_EL2 as a regular guest
 system register
Date: Wed, 12 Sep 2018 12:50:28 +0100
Message-ID: <20180912115027.GG17801@e103592.cambridge.arm.com>
References: <1536153553-28767-1-git-send-email-Dave.Martin@arm.com>
 <20180912101704.GA23874@e113682-lin.lund.arm.com>
 <20180912111624.GF17801@e103592.cambridge.arm.com>
 <20180912112157.GA14516@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B70354A1D2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Sep 2018 07:50:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9SH0uJ2ZNV-G for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Sep 2018 07:50:32 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 735D149F93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Sep 2018 07:50:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180912112157.GA14516@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 12, 2018 at 01:21:57PM +0200, Christoffer Dall wrote:
> On Wed, Sep 12, 2018 at 12:16:26PM +0100, Dave Martin wrote:
> > On Wed, Sep 12, 2018 at 12:17:04PM +0200, Christoffer Dall wrote:

[...]

> > > I think the point was actually to avoid saving/restoring FPEXC32_EL2
> > > when VFP was being trapped to EL2
> > 
> > With what purpose in mind?
> 
> I don't think we thought it through very carefully but just considered
> FPEXC32_EL2 as part of the VFP state, but as you say, that doesn't
> really make sense.
> 
> I was just objecting to the statement that this is a bring-over from the
> 32-bit side, which confused me, and I don't think that's true.

[...]

> > We saved neither the trap (since the VFP registers needed switching
> > anyway) nor the FPEXC32_EL2 switch (since we had to do that at guest
> > entry).
> > 
> > I may have misunderstood something.
> > 
> 
> No, we just didn't look at it that carefully back then.
> 
> > 
> > I was somewhat guessing likely rationale, so if you can suggest a
> > way to reword this that reflects the situation better I'd be happy
> > to change it.
> 
> "Christoffer was being stupid..." ;)  It was just the way
> it was, I don't think there was a good rationale, but I don't think it
> helps to understand the change to provide guesswork either, so just
> remove it.

OK, I'll drop the bogus history lesson from this patch.  It doesn't
really add anything here, especially if it's wrong.

> > Thinking about it, I don't see why FPEXC32_EL2 can't be handled via
> > vcpu_load()/_put().  This register doesn't matter for the host, and
> > I can't see why we would need to switch it when going through hyp.
> > 
> 
> That's another good point, should be able to do that.

[...]

> > I confess to a certain amount of "according to the spirit of the
> > architecture it obviously ought to work this way" reasoning.
> > 
> > Following the trail of documentation isn't trivial, so it would
> > be good if someone could check that they can reach the same conclusion
> > about FPEXC32_EL2 having no effect on the host.
> > 
> 
> That was definitely my conclusion as well.

OK, sounds good.

[...]

> > > We can queue this for the next merge window.
> > > 
> > > Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> > 
> > Thanks, modulo the question of maybe moving this to the vcpu_load()/
> > _put() path.
> > 
> 
> Sure, I'll look at the next version as well if you send a new version.

Will do.  Can't say exactly when.

Cheers
---Dave
