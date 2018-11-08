From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Thu, 08 Nov 2018 12:40:11 +0000
Message-ID: <87r2fv68us.fsf@linaro.org>
References: <20181107171031.22573-1-alex.bennee@linaro.org> <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com> <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu


Mark Rutland <mark.rutland@arm.com> writes:

> On Wed, Nov 07, 2018 at 06:01:20PM +0000, Mark Rutland wrote:
>> On Wed, Nov 07, 2018 at 05:10:31PM +0000, Alex Benn=C3=A9e wrote:
>> > Not all faults handled by handle_exit are instruction emulations. For
>> > example a ESR_ELx_EC_IABT will result in the page tables being updated
>> > but the instruction that triggered the fault hasn't actually executed
>> > yet. We use the simple heuristic of checking for a changed PC before
>> > seeing if kvm_arm_handle_step_debug wants to claim we stepped an
>> > instruction.
>> >
>> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> > ---
>> >  arch/arm64/kvm/handle_exit.c | 4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit=
.c
>> > index e5e741bfffe1..b8252e72f882 100644
>> > --- a/arch/arm64/kvm/handle_exit.c
>> > +++ b/arch/arm64/kvm/handle_exit.c
>> > @@ -214,6 +214,7 @@ static exit_handle_fn kvm_get_exit_handler(struct =
kvm_vcpu *vcpu)
>> >  static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_r=
un *run)
>> >  {
>> >  	int handled;
>> > +        unsigned long old_pc =3D *vcpu_pc(vcpu);
>> >
>> >  	/*
>> >  	 * See ARM ARM B1.14.1: "Hyp traps on instructions
>> > @@ -233,7 +234,8 @@ static int handle_trap_exceptions(struct kvm_vcpu =
*vcpu, struct kvm_run *run)
>> >  	 * kvm_arm_handle_step_debug() sets the exit_reason on the kvm_run
>> >  	 * structure if we need to return to userspace.
>> >  	 */
>> > -	if (handled > 0 && kvm_arm_handle_step_debug(vcpu, run))
>> > +	if (handled > 0 && *vcpu_pc(vcpu) !=3D old_pc &&
>>
>> This doesn't work if the emulation is equivalent to a branch-to-self, so
>> I don't think that we want to do this.
>>
>> When are we failing to advance the single-step state machine
>> correctly?

When the trap is not actually an instruction emulation - e.g. setting up
the page tables on a fault. Because we are in the act of single-stepping
an instruction that didn't actually execute we erroneously return to
userspace pretending we did even though we shouldn't.

>
> I don't understand how this is intended to work currently.
>
> Surely kvm_skip_instr() should advance the state machine as necessary,
> so that we can rely on the HW to generate any necessary single-step
> exception when we next return to the guest?

It doesn't currently (at least for aarch64, the aarch32 skip code does
more messing about). But the decision isn't really about futzing with
the single-step flags but about returning to userspace so the
single-step is seen. Changing a > 0 to return to the guest to a 0 to
exit to userspace while setting the exit reason.
>
> ... and if userspace decides to emulate something, it's up to it to
> advance the state machine consistently.

Well that's a little more complex. We actually exit to handle the MMIO
stuff and then return so it can complete before exiting again for the
step (see virt/kvm/arm/arm.c):

	if (run->exit_reason =3D=3D KVM_EXIT_MMIO) {
		ret =3D kvm_handle_mmio_return(vcpu, vcpu->run);
		if (ret)
			return ret;
		if (kvm_arm_handle_step_debug(vcpu, vcpu->run))
			return 0;
	}


>
> Thanks,
> Mark.


--
Alex Benn=C3=A9e
