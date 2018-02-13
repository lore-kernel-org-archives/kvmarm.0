From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 26/41] KVM: arm64: Introduce framework for accessing
 deferred sysregs
Date: Tue, 13 Feb 2018 09:55:02 +0100
Message-ID: <20180213085502.GF23189@cbox>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
 <20180112120747.27999-27-christoffer.dall@linaro.org>
 <20180123160431.GA5862@e103592.cambridge.arm.com>
 <20180125195413.GT21802@cbox>
 <20180209161739.GE5862@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180209161739.GE5862@e103592.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 09, 2018 at 04:17:39PM +0000, Dave Martin wrote:
> On Thu, Jan 25, 2018 at 08:54:13PM +0100, Christoffer Dall wrote:
> > On Tue, Jan 23, 2018 at 04:04:40PM +0000, Dave Martin wrote:
> > > On Fri, Jan 12, 2018 at 01:07:32PM +0100, Christoffer Dall wrote:
> > > > We are about to defer saving and restoring some groups of system
> > > > registers to vcpu_put and vcpu_load on supported systems.  This means
> > > > that we need some infrastructure to access system registes which
> > > > supports either accessing the memory backing of the register or directly
> > > > accessing the system registers, depending on the state of the system
> > > > when we access the register.
> > > > 
> > > > We do this by defining a set of read/write accessors for each system
> > > > register, and letting each system register be defined as "immediate" or
> > > > "deferrable".  Immediate registers are always saved/restored in the
> > > > world-switch path, but deferrable registers are only saved/restored in
> > > > vcpu_put/vcpu_load when supported and sysregs_loaded_on_cpu will be set
> > > > in that case.
> > > > 
> > > > Not that we don't use the deferred mechanism yet in this patch, but only
> > > > introduce infrastructure.  This is to improve convenience of review in
> > > > the subsequent patches where it is clear which registers become
> > > > deferred.
> > > 
> > > Might this table-driven approach result in a lot of branch mispredicts,
> > > particularly across load/put boundaries?
> > > 
> > > If we were to move the whole construct to a header, then it could get
> > > constant-folded at the call site down to the individual reg accessed,
> > > say:
> > > 
> > > 	if (sys_regs_loaded)
> > > 		read_sysreg_s(TPIDR_EL0);
> > > 	else
> > > 		__vcpu_sys_reg(v, TPIDR_EL0);
> > > 
> > > Where multiple regs are accessed close to each other, the compiler
> > > may be able to specialise the whole sequence for the loaded and !loaded
> > > cases so that there is only one conditional branch.
> > > 
> > 
> > That's an interesting thing to consider indeed.  I wasn't really sure
> > how to put this in a header file which wouldn't look overly bloated for
> > inclusion elsewhere, so we ended up with this.
> > 
> > I don't think the alternative suggestion that I discused with Julien on
> > this patch changes this much, but since you've had a look at this, I'm
> > curious which one of the two (lookup table vs. giant switch) you prefer?
> 
> The giant switch approach has the advantage that it is likely to be
> folded down to a single case when the switch control expression is
> const-foldable; the flipside is that when that fails the entire
> switch would be inlined.
> 
> > > The individual accessor functions also become unnecessary in this case,
> > > because we wouldn't need to derive function pointers from them any
> > > more.
> > > 
> > > I don't know how performance would compare in practice though.
> > 
> > I don't know either.  But I will say that the whole idea behind put/load
> > is that you do this rarely, and going to userspace from KVM is
> > notriously expensive, also on x86.
> 
> I guess that makes sense.  I'm still a bit hazy on the big picture
> for KVM.
> 
> > > I'm also assuming that all calls to these accessors are const-foldable.
> > > If not, relying on inlining would bloat the generated code a lot.
> > 
> > We have places where this is not the cae, access_vm_reg() for example.
> > But if we really, really, wanted to, we could rewrite that to have a
> > function for each register, but that's pretty horrid on its own.
> 
> That might not be too bad if there is only one giant inline expansion
> and the rest are folded down.
> 
> 
> I guess this is something to revisit _if_ we suspect a performance
> bottleneck later on.
> 
> For now, I was lacking some understanding regarding how this code gets
> run, so I was guessing about potential issues rather then proven
> issues.
> 

This was a very useful discussion.  I think I'll change this to a big
switch statement in the header file using a static inline, because it
makes the code more readable, and if we notice a huge code size
explosion, we can take measures to make sure things are const-foldable.


> As you might guess, I'm still at the "stupid questions" stage for
> this series :)
> 
Not at all.

Thanks,
-Christoffer
