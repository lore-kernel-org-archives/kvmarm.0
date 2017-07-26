From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH v2 02/19] arm64: Use the physical counter when
 available for read_cycles
Date: Wed, 26 Jul 2017 18:17:29 +0100
Message-ID: <20170726171728.GB18154@arm.com>
References: <20170717142718.13853-1-cdall@linaro.org>
 <20170717142718.13853-3-cdall@linaro.org>
 <20170725094308.GC23359@arm.com> <20170725143647.GC1588@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B69D40D16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jul 2017 13:16:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0FnUQjqb+73b for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jul 2017 13:16:18 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9781D40CE0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jul 2017 13:16:18 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170725143647.GC1588@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 25, 2017 at 07:36:47AM -0700, Christoffer Dall wrote:
> On Tue, Jul 25, 2017 at 10:43:08AM +0100, Will Deacon wrote:
> > On Mon, Jul 17, 2017 at 04:27:01PM +0200, Christoffer Dall wrote:
> > > Currently get_cycles() is hardwired to arch_counter_get_cntvct() on
> > > arm64, but as we move to using the physical timer for the in-kernel
> > > time-keeping, we need to make that more flexible.
> > > 
> > > First, we need to make sure the physical counter can be read on equal
> > > terms to the virtual counter, which includes adding physical counter
> > > read functions for timers that require errata.
> > > 
> > > Second, we need to make a choice between reading the physical vs virtual
> > > counter, depending on which timer is used for time keeping in the kernel
> > > otherwise.  We can do this using a static key to avoid a performance
> > > penalty during runtime when reading the counter.
> > > 
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will.deacon@arm.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > > ---
> > >  arch/arm64/include/asm/arch_timer.h  | 18 ++++++++++++------
> > >  arch/arm64/include/asm/timex.h       |  2 +-
> > >  drivers/clocksource/arm_arch_timer.c | 32 ++++++++++++++++++++++++++++++--
> > >  3 files changed, 43 insertions(+), 9 deletions(-)
> > 
> > [...]
> > 
> > > @@ -886,10 +912,12 @@ static void __init arch_counter_register(unsigned type)
> > >  
> > >  	/* Register the CP15 based counter if we have one */
> > >  	if (type & ARCH_TIMER_TYPE_CP15) {
> > > -		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> > > +		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
> > >  			arch_timer_read_counter = arch_counter_get_cntvct;
> > > -		else
> > > +		} else {
> > >  			arch_timer_read_counter = arch_counter_get_cntpct;
> > > +			static_branch_enable(&arch_timer_phys_counter_available);
> > > +		}
> > 
> > I'm a bit worried about this change, although I can't put my finger on
> > exactly the problematic scenario. My concern is that if we have a system
> > where the host kernel is entered at NS-EL1 (because, e.g. EL2 is used for
> > something else or the bootloader just didn't load us there) then the booting
> > protocol doesn't mandate a zero-initialised CNTVOFF value. If we can
> > subsequently end up using the physical counter in the kernel and the virtual
> > counter in userspace, the vDSO will get confused because the datapage values
> > will not correspond to the values it actually ends up reading. 
> 
> Just so I'm sure I'm understanding correctly, vDSO always reads the
> virtual counter?

Yes, that's right.

> > There's also
> > the likelihood that existing EL2 init code simply isn't setting up
> > CNTHCTL_EL2 and CNTVOFF correctly, so we probably need a way to force
> > virtual counter on the cmdline.
> 
> My understanding was that we only ever use the physical counter when we
> boot at EL2 and therefore the kernel is in control of CNTVOFF and can
> set that to 0.  Is this not the case, or are you asking for a way to
> mandate this relationship or make it abundantly clear?

AFAICT, arch_timer_ppi_nr could return ARCH_TIMER_PHYS_NONSECURE_PPI
or ARCH_TIMER_PHYS_SECURE_PPI when we're not running at EL2, which would
cause us to use the physical counter with your patch applied.

> Also, are you fine with arch_timer_read_counter changing to using the
> physical counter on arm64, but you're merely worried about
> read_cycles()?

Assuming you mean get_cycles(), then no, I'm not worried about that because
it's just used for things like small delta calculations and entropy. I'm
worried about the timekeeper (which I think uses arch_timer_read_counter)
being based on the physical counter and the vDSO being based on the virtual
counter and CNTVOFF != 0.

> Does it make sense to have read_cycles() still read the virtual counter
> whereas arch timers (timers, not counters) use the physical counter?  I
> somewhat convinced myself that this doesn't work though.

I don't think that solves the problem :(

> > In practice it looks like we always end up with ARCH_TIMER_VIRT_PPI out of
> > arch_timer_select_ppi, but that's not guaranteed and I haven't thought at
> > all about the 32-bit case, which has other quirks/complexities.
> > 
> 
> How does this change affect the 32-bit side?  All this should do is
> enable a static branch which is unused on the 32-bit side; what am I
> missing?

The PPI selection is more complicated for 32-bit, because of the
"arm,cpu-registers-not-fw-configured" quirk.

Will
