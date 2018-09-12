From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: Treat FPEXC32_EL2 as a regular guest
 system register
Date: Wed, 12 Sep 2018 13:21:57 +0200
Message-ID: <20180912112157.GA14516@e113682-lin.lund.arm.com>
References: <1536153553-28767-1-git-send-email-Dave.Martin@arm.com>
 <20180912101704.GA23874@e113682-lin.lund.arm.com>
 <20180912111624.GF17801@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF394A1D2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Sep 2018 07:22:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SKSgvZsG9LjH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Sep 2018 07:22:00 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A342849F93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Sep 2018 07:22:00 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180912111624.GF17801@e103592.cambridge.arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 12, 2018 at 12:16:26PM +0100, Dave Martin wrote:
> On Wed, Sep 12, 2018 at 12:17:04PM +0200, Christoffer Dall wrote:
> > On Wed, Sep 05, 2018 at 02:19:13PM +0100, Dave Martin wrote:
> > > Currently FPEXC32_EL2 is handled specially when context-switching.
> > > This made sense for arm, where FPEXC affects host execution
> > > (including VFP/SIMD register save/restore at Hyp).
> > 
> > I think the point was actually to avoid saving/restoring FPEXC32_EL2
> > when VFP was being trapped to EL2
> 
> With what purpose in mind?

I don't think we thought it through very carefully but just considered
FPEXC32_EL2 as part of the VFP state, but as you say, that doesn't
really make sense.

I was just objecting to the statement that this is a bring-over from the
32-bit side, which confused me, and I don't think that's true.

> 
> We saved neither the trap (since the VFP registers needed switching
> anyway) nor the FPEXC32_EL2 switch (since we had to do that at guest
> entry).
> 
> I may have misunderstood something.
> 

No, we just didn't look at it that carefully back then.

> 
> I was somewhat guessing likely rationale, so if you can suggest a
> way to reword this that reflects the situation better I'd be happy
> to change it.

"Christoffer was being stupid..." ;)  It was just the way
it was, I don't think there was a good rationale, but I don't think it
helps to understand the change to provide guesswork either, so just
remove it.

> 
> Thinking about it, I don't see why FPEXC32_EL2 can't be handled via
> vcpu_load()/_put().  This register doesn't matter for the host, and
> I can't see why we would need to switch it when going through hyp.
> 

That's another good point, should be able to do that.

> > > 
> > > However, FPEXC has no architectural effect when running in AArch64.
> > > The only case where an arm64 host may execute in AArch32 is when
> > > running compat user code at EL0: the architecture explicitly
> > > documents FPEXC as having no effect in this case either when the
> > > kernel (EL2 in the VHE case; otherwise EL1) is AArch64.
> > > 
> > > So, we can just handle FPEXC32_EL2 (which is the AArch64 alias for
> > > this register) as a regular AArch32-only system register and switch
> > > it without any special handling or synchronisation.
> > > 
> > > This allows some gnarly special-case code to be eliminated from
> > > hyp.  The extra isb() in __activate_traps_fpsimd32() is dropped
> > > too: for the reasons explained above arm64 never required this
> > > anyway.
> > > 
> > > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > > Cc: Alexander Graf <agraf@suse.de>
> > > Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> > > ---
> > > 
> > > I could do with some confirmation from someone that my interpretation of
> > > the architecture is in fact correct here.  The CheckFPAdvSIMDEnabled64()
> > > and CheckAdvSIMDEnabled() pseudocode functions may be a reasonable
> > > starting point (this was my reference where the wordy text is unclear).
> > 
> > Which aspect do you want confirmed here?
> 
> I confess to a certain amount of "according to the spirit of the
> architecture it obviously ought to work this way" reasoning.
> 
> Following the trail of documentation isn't trivial, so it would
> be good if someone could check that they can reach the same conclusion
> about FPEXC32_EL2 having no effect on the host.
> 

That was definitely my conclusion as well.

> 
> > > If Alexander could try this out, that would be good.
> > > 
> > > This cleanup applies on top of the following previously pubished fix:
> > > [PULL 2/4] arm64: KVM: Only force FPEXC32_EL2.EN if trapping FPSIMD
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2018-September/599537.html
> > > 
> > 
> > We can queue this for the next merge window.
> > 
> > Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
> 
> Thanks, modulo the question of maybe moving this to the vcpu_load()/
> _put() path.
> 

Sure, I'll look at the next version as well if you send a new version.


Thanks,

        Christoffer
