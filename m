From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Thu, 08 Nov 2018 14:28:37 +0000
Message-ID: <87pnvf63u2.fsf@linaro.org>
References: <20181107171031.22573-1-alex.bennee@linaro.org> <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com> <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com> <87r2fv68us.fsf@linaro.org> <20181108135122.llmfsel32dbe2q7o@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20181108135122.llmfsel32dbe2q7o@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu


Mark Rutland <mark.rutland@arm.com> writes:

> On Thu, Nov 08, 2018 at 12:40:11PM +0000, Alex Benn=C3=A9e wrote:
>> Mark Rutland <mark.rutland@arm.com> writes:
>> > On Wed, Nov 07, 2018 at 06:01:20PM +0000, Mark Rutland wrote:
>> >> On Wed, Nov 07, 2018 at 05:10:31PM +0000, Alex Benn=C3=A9e wrote:
>> >> > Not all faults handled by handle_exit are instruction emulations. F=
or
>> >> > example a ESR_ELx_EC_IABT will result in the page tables being upda=
ted
>> >> > but the instruction that triggered the fault hasn't actually execut=
ed
>> >> > yet. We use the simple heuristic of checking for a changed PC before
>> >> > seeing if kvm_arm_handle_step_debug wants to claim we stepped an
>> >> > instruction.
>> >> >
>> >> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
<snip>
>> >> > @@ -233,7 +234,8 @@ static int handle_trap_exceptions(struct kvm_vc=
pu *vcpu, struct kvm_run *run)
>> >> >  	 * kvm_arm_handle_step_debug() sets the exit_reason on the kvm_run
>> >> >  	 * structure if we need to return to userspace.
>> >> >  	 */
>> >> > -	if (handled > 0 && kvm_arm_handle_step_debug(vcpu, run))
>> >> > +	if (handled > 0 && *vcpu_pc(vcpu) !=3D old_pc &&
>> >>
<snip>
>> >> When are we failing to advance the single-step state machine
>> >> correctly?
>>
>> When the trap is not actually an instruction emulation - e.g. setting up
>> the page tables on a fault. Because we are in the act of single-stepping
>> an instruction that didn't actually execute we erroneously return to
>> userspace pretending we did even though we shouldn't.
>
> I think one problem here is that we're trying to use one bit of state
> (the KVM_GUESTDBG_SINGLESTEP) when we actually need two.
>
> I had expected that we'd follow the architectural single-step state
> machine, and have three states:
>
> * inactive/disabled: not single stepping
>
> * active-not-pending: the current instruction will be stepped, and we'll
>   transition to active-pending before executing the next instruction.
>
> * active-pending: the current instruction will raise a software step
>   debug exception, before being executed.
>
> For that to work, all we have to do is advence the state machine when we
> emulate/skip an instruction, and the HW will raise the exception for us
> when we enter the guest (which is the only place we have to handle the
> step exception).

We also elide the fact that single-stepping is happening from the guest
here by piggy backing the step bit onto cpsr() as we enter KVM rather
than just tracking the state of the bit.

The current flow of guest debug is very much "as I enter what do I need
to set" rather than tracking state between VCPU_RUN events.

> We need two bits of internal state for that, but KVM only gives us a
> single KVM_GUESTDBG_SINGLESTEP flag, and we might exit to userspace
> mid-emulation (e.g. for MMIO). To avoid that resulting in skipping two
> instructions at a time, we currently add explicit
> kvm_arm_handle_step_debug() checks everywhere after we've (possibly)
> emulated an instruction, but these seem to hit too often.

Yes - treating all exits as potential emulations is problematic and we
are increasing complexity to track which exits are and aren't
actual *completed* instruction emulations which can also be a
multi-stage thing split between userspace and the kernel.

> One problem is that I couldn't spot when we advance the PC for an MMIO
> trap. I presume we do that in the kernel, *after* the MMIO trap, but I
> can't see where that happens.

Nope it gets done before during decode_hsr in mmio.c:

	/*
	 * The MMIO instruction is emulated and should not be re-executed
	 * in the guest.
	 */
	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));

That is a little non-obvious but before guest debug support was added it
makes sense as the whole trap->kernel->user->kernel->guest cycle is
"atomic" w.r.t the guest. It's also common code for
in-kernel/in-userspace emulation.

For single-step we just built on that and completed the single-step
after mmio was complete.

>
> Thanks,
> Mark.


--
Alex Benn=C3=A9e
