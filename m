From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH] KVM: arm64: don't single-step for non-emulated faults
Date: Fri, 9 Nov 2018 13:29:56 +0000
Message-ID: <20181109132955.kqfccmqrugfj5rkl@lakrids.cambridge.arm.com>
References: <20181107180120.urnvkcrkh46ytsdb@lakrids.cambridge.arm.com>
 <20181107180829.sex54bxhd5wyqvan@lakrids.cambridge.arm.com>
 <87r2fv68us.fsf@linaro.org>
 <20181108135122.llmfsel32dbe2q7o@lakrids.cambridge.arm.com>
 <87pnvf63u2.fsf@linaro.org>
 <CAFEAcA9v+XvAJBWpDMvEQPeJ7ALM15Yz5KY+wfGPmLG2a8yPRQ@mail.gmail.com>
 <20181109115644.f4qjqnv2kogoke42@lakrids.cambridge.arm.com>
 <87lg625th2.fsf@linaro.org>
 <20181109124930.axelmyohmrcb63b4@lakrids.cambridge.arm.com>
 <CAFEAcA-xuUPukf9EPeetr_+RSU7FPDMXmyk3zbjY=FcV65CF=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA-xuUPukf9EPeetr_+RSU7FPDMXmyk3zbjY=FcV65CF=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 09, 2018 at 12:56:54PM +0000, Peter Maydell wrote:
> On 9 November 2018 at 12:49, Mark Rutland <mark.rutland@arm.com> wrote:
> > I'm not saying anything about *decisions*. I'm saying that we can make
> > the state consistent by advancing the singlestep state in the same way
> > that HW does, at the instant it advances the PC.
> >
> > i.e. do that in kvm_skip_instr(), as I've done in my local tree.
> >
> > That mirrors the HW, and we don't need to special-case any handling for
> > emulated vs non-emulated instructions.
> 
> You also need to do it in the "set PC because we're making the guest
> take an exception" code path, which doesn't go through kvm_skip_instr().

Sure.

> This corresponds to the two kinds of "step completed" in hardware as
> noted in DDI0487D.a D2.12.3 fig D2-3 footnote b:
>  * executing the instruction to be stepped without taking an exception
>  * taking an exception to an exception level that debug exceptions
>    are enabled from [ie guest EL1 in our case]

Thanks for the pointer!

Mark.
