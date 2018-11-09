From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Fri, 9 Nov 2018 11:56:44 +0000
Message-ID: <20181109115644.f4qjqnv2kogoke42@lakrids.cambridge.arm.com>
References: <20181107171031.22573-1-alex.bennee@linaro.org>
 <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com>
 <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com>
 <87r2fv68us.fsf@linaro.org>
 <20181108135122.llmfsel32dbe2q7o@lakrids.cambridge.arm.com>
 <87pnvf63u2.fsf@linaro.org>
 <CAFEAcA9v+XvAJBWpDMvEQPeJ7ALM15Yz5KY+wfGPmLG2a8yPRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA9v+XvAJBWpDMvEQPeJ7ALM15Yz5KY+wfGPmLG2a8yPRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 08, 2018 at 02:38:43PM +0000, Peter Maydell wrote:
> On 8 November 2018 at 14:28, Alex Bennée <alex.bennee@linaro.org> wrote:
> >
> > Mark Rutland <mark.rutland@arm.com> writes:
> >> One problem is that I couldn't spot when we advance the PC for an MMIO
> >> trap. I presume we do that in the kernel, *after* the MMIO trap, but I
> >> can't see where that happens.
> >
> > Nope it gets done before during decode_hsr in mmio.c:
> >
> >         /*
> >          * The MMIO instruction is emulated and should not be re-executed
> >          * in the guest.
> >          */
> >         kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> 
> I think that this attempt to do the PC-advance early is
> probably an underlying problem that is not helping the
> code structure here.
> 
> An enhancement that's been floated previously is that the
> MMIO emulation in userspace should be able to report back
> to KVM "nope, that access should generate a guest synchronous
> external abort (with ESR_EL1.EA = 0/1)".
> If we have that, then we definitely need to not advance the
> PC until after userspace has done the emulation and told
> us whether the memory access succeeded or not...

Yup.

I think that we absolutely want to do all the CPU state advancement (PC,
SS bit, etc) at the point we apply the effects of the instruction. Not
before we emulate the instruction, and not higher/lower in the call
stack.

We have a big problem in that guest-directed singlestep and
host-directed singlestep don't compose, and given that host-directed
singlestep doesn't work reliably today I'd be tempted to rip that out
until we've fixed guest-directed singlestep.

We should have a story for how host-directed debug is handled
transparently from the PoV of a guest using guest-directed debug.

Thanks,
Mark.
