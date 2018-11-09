From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Fri, 09 Nov 2018 12:24:41 +0000
Message-ID: <87lg625th2.fsf@linaro.org>
References: <20181107171031.22573-1-alex.bennee@linaro.org> <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com> <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com> <87r2fv68us.fsf@linaro.org> <20181108135122.llmfsel32dbe2q7o@lakrids.cambridge.arm.com> <87pnvf63u2.fsf@linaro.org> <CAFEAcA9v+XvAJBWpDMvEQPeJ7ALM15Yz5KY+wfGPmLG2a8yPRQ@mail.gmail.com> <20181109115644.f4qjqnv2kogoke42@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20181109115644.f4qjqnv2kogoke42@lakrids.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu


Mark Rutland <mark.rutland@arm.com> writes:

> On Thu, Nov 08, 2018 at 02:38:43PM +0000, Peter Maydell wrote:
>> On 8 November 2018 at 14:28, Alex Benn=C3=A9e <alex.bennee@linaro.org> w=
rote:
>> >
>> > Mark Rutland <mark.rutland@arm.com> writes:
>> >> One problem is that I couldn't spot when we advance the PC for an MMIO
>> >> trap. I presume we do that in the kernel, *after* the MMIO trap, but I
>> >> can't see where that happens.
>> >
>> > Nope it gets done before during decode_hsr in mmio.c:
>> >
>> >         /*
>> >          * The MMIO instruction is emulated and should not be re-execu=
ted
>> >          * in the guest.
>> >          */
>> >         kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
>>
>> I think that this attempt to do the PC-advance early is
>> probably an underlying problem that is not helping the
>> code structure here.
>>
>> An enhancement that's been floated previously is that the
>> MMIO emulation in userspace should be able to report back
>> to KVM "nope, that access should generate a guest synchronous
>> external abort (with ESR_EL1.EA =3D 0/1)".
>> If we have that, then we definitely need to not advance the
>> PC until after userspace has done the emulation and told
>> us whether the memory access succeeded or not...
>
> Yup.
>
> I think that we absolutely want to do all the CPU state advancement (PC,
> SS bit, etc) at the point we apply the effects of the instruction. Not
> before we emulate the instruction, and not higher/lower in the call
> stack.

There is certainly an argument to abstract some of the advancement logic
so we can make debug related decisions in one place. I don't know how
much churn we would need to get there.

Currently most of the guest debug decisions are made in one place as we
head into the guest run. Generally I don't think the emulation code want
to know or care about the SS bit or what debug is currently happening
although I guess the presence of the SS bit could be used to decide on
exactly what exit type you are going to do - back to guest or out to
user space. Currently kvm_arm_handle_step_debug on cares about host
directed debug but we could expand it to raise the appropriate guest
exception if required.

> We have a big problem in that guest-directed singlestep and
> host-directed singlestep don't compose, and given that host-directed
> singlestep doesn't work reliably today I'd be tempted to rip that out
> until we've fixed guest-directed singlestep.

Getting host and guest debug to run at the same time is tricky given we
end up subverting guest state when the host debug is in control. It did
make my head spin when I worked on it originally which led to the
acceptance that guest debug couldn't be expected to work transparently
while host directed debug was in effect. If we can support it without
adding complexity then that would be great but it's a pretty niche use
case.

I'd be loathed to rip out the current single step support as it does
actually work pretty well - it's just corner cases with emulated MMIO
and first step that are failing. Last I looked these were cases x86
didn't even get right and no one has called to remove it's single step
support AFAIK.

> We should have a story for how host-directed debug is handled
> transparently from the PoV of a guest using guest-directed debug.

What's the use case for this apart from having a cleaner abstraction? Do
users really spend time running multiple gdbs at different levels in
the stack?

>
> Thanks,
> Mark.


--
Alex Benn=C3=A9e
