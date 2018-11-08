From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Thu, 8 Nov 2018 13:51:22 +0000
Message-ID: <20181108135122.llmfsel32dbe2q7o@lakrids.cambridge.arm.com>
References: <20181107171031.22573-1-alex.bennee@linaro.org>
 <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com>
 <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com>
 <87r2fv68us.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r2fv68us.fsf@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 08, 2018 at 12:40:11PM +0000, Alex Bennée wrote:
> Mark Rutland <mark.rutland@arm.com> writes:
> > On Wed, Nov 07, 2018 at 06:01:20PM +0000, Mark Rutland wrote:
> >> On Wed, Nov 07, 2018 at 05:10:31PM +0000, Alex Bennée wrote:
> >> > Not all faults handled by handle_exit are instruction emulations. For
> >> > example a ESR_ELx_EC_IABT will result in the page tables being updated
> >> > but the instruction that triggered the fault hasn't actually executed
> >> > yet. We use the simple heuristic of checking for a changed PC before
> >> > seeing if kvm_arm_handle_step_debug wants to claim we stepped an
> >> > instruction.
> >> >
> >> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> >> > ---
> >> >  arch/arm64/kvm/handle_exit.c | 4 +++-
> >> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> >> > index e5e741bfffe1..b8252e72f882 100644
> >> > --- a/arch/arm64/kvm/handle_exit.c
> >> > +++ b/arch/arm64/kvm/handle_exit.c
> >> > @@ -214,6 +214,7 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
> >> >  static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >> >  {
> >> >  	int handled;
> >> > +        unsigned long old_pc = *vcpu_pc(vcpu);
> >> >
> >> >  	/*
> >> >  	 * See ARM ARM B1.14.1: "Hyp traps on instructions
> >> > @@ -233,7 +234,8 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >> >  	 * kvm_arm_handle_step_debug() sets the exit_reason on the kvm_run
> >> >  	 * structure if we need to return to userspace.
> >> >  	 */
> >> > -	if (handled > 0 && kvm_arm_handle_step_debug(vcpu, run))
> >> > +	if (handled > 0 && *vcpu_pc(vcpu) != old_pc &&
> >>
> >> This doesn't work if the emulation is equivalent to a branch-to-self, so
> >> I don't think that we want to do this.
> >>
> >> When are we failing to advance the single-step state machine
> >> correctly?
> 
> When the trap is not actually an instruction emulation - e.g. setting up
> the page tables on a fault. Because we are in the act of single-stepping
> an instruction that didn't actually execute we erroneously return to
> userspace pretending we did even though we shouldn't.

I think one problem here is that we're trying to use one bit of state
(the KVM_GUESTDBG_SINGLESTEP) when we actually need two.

I had expected that we'd follow the architectural single-step state
machine, and have three states:

* inactive/disabled: not single stepping

* active-not-pending: the current instruction will be stepped, and we'll
  transition to active-pending before executing the next instruction.

* active-pending: the current instruction will raise a software step
  debug exception, before being executed.

For that to work, all we have to do is advence the state machine when we
emulate/skip an instruction, and the HW will raise the exception for us
when we enter the guest (which is the only place we have to handle the
step exception).

We need two bits of internal state for that, but KVM only gives us a
single KVM_GUESTDBG_SINGLESTEP flag, and we might exit to userspace
mid-emulation (e.g. for MMIO). To avoid that resulting in skipping two
instructions at a time, we currently add explicit
kvm_arm_handle_step_debug() checks everywhere after we've (possibly)
emulated an instruction, but these seem to hit too often.

One problem is that I couldn't spot when we advance the PC for an MMIO
trap. I presume we do that in the kernel, *after* the MMIO trap, but I
can't see where that happens.

Thanks,
Mark.
