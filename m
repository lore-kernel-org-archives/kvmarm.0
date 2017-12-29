From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 26/36] KVM: arm64: Defer saving/restoring system
 registers to vcpu load/put on VHE
Date: Fri, 29 Dec 2017 17:39:32 +0100
Message-ID: <20171229163932.GA15103@cbox>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
 <20171207170630.592-27-christoffer.dall@linaro.org>
 <c45eaebe-57a1-7737-c515-111d497dd06e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c45eaebe-57a1-7737-c515-111d497dd06e@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 11, 2017 at 01:20:03PM +0000, Marc Zyngier wrote:
> On 07/12/17 17:06, Christoffer Dall wrote:
> > Some system registers do not affect the host kernel's execution and can
> > therefore be loaded when we are about to run a VCPU and we don't have to
> > restore the host state to the hardware before the time when we are
> > actually about to return to userspace or schedule out the VCPU thread.
> > 
> > The EL1 system registers and the userspace state registers, which only
> > affect EL0 execution, do not affect the host kernel's execution.
> > 
> > The 32-bit system registers are not used by a VHE host kernel and
> > therefore don't need to be saved/restored on every entry/exit to/from
> > the guest, but can be deferred to vcpu_load and vcpu_put, respectively.
> 
> Note that they are not used by the !VHE host kernel either, and I
> believe they could be deferred too, although that would imply a round
> trip to HYP to save/restore them. We already have such a hook there when
> configuring ICH_VMCR_EL2, so we may not need much of a new infrastructure.
> 
> What do you think?
> 
This turned out to be a bit of a mess.  We can do this, but it conflicts
with the idea of hiding the sysregs_loaded_on_cpu handling based on
classifying a system register as deferrable or immediate.

What we'd need to do is to add a separate flag for the system registers
which are deferred on !VHE as well as VHE, for example
sysregs32_loaded_on_cpu (or something more generic like
nvhe_vhe_sysregs_loaded_on_cpu - in lack of a better name).  We'd then
have to duplicate the DEFERRED macro for this other category of sysregs,
which checks our new flag instead of sysregs_loaded_on_cpu, and we'd
have to map all the accessors in Hyp, and do kvm_call_hyp() around all
the accessors (which could hurt normal performance) or expand the
deferred macros to output two functions, where the non-hyp calls into
the hyp one if the system register is loaded on the cpu.

Of course, it's arguable that all this is not needed because the 32-bit
system registers are not actually used yet for emulation while the state
could be loaded on the cpu, so it doesn't matter, but then we're back to
my original approach where all the code just has to know the state of a
register and when modifying KVM code we have to think carefully about
that.

Basically, I don't think the complexity is worth the effort given that
this only optimizes 32-bit guests, and I think we should just leave this
part out.

Thoughts?

Thanks,
-Christoffer
