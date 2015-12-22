From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 1/2] arm: KVM: Do not update PC if the trap handler has
 updated it
Date: Tue, 22 Dec 2015 15:39:47 +0100
Message-ID: <20151222143947.GA5631@cbox>
References: <1450778118-12715-1-git-send-email-marc.zyngier@arm.com>
 <1450778118-12715-2-git-send-email-marc.zyngier@arm.com>
 <CAFEAcA8F2TJuRR5ELvit0FPa3XFMJ847S8WK25i5aVdGBU=PUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFEAcA8F2TJuRR5ELvit0FPa3XFMJ847S8WK25i5aVdGBU=PUA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Shannon Zhao <shannon.zhao@linaro.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 22, 2015 at 11:08:10AM +0000, Peter Maydell wrote:
> On 22 December 2015 at 09:55, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > Assuming we trap a coprocessor access, and decide that the access
> > is illegal, we will inject an exception in the guest. In this
> > case, we shouldn't increment the PC, or the vcpu will miss the
> > first instruction of the handler, leading to a mildly confused
> > guest.
> >
> > Solve this by snapshoting PC before the access is performed,
> > and checking if it has moved or not before incrementing it.
> >
> > Reported-by: Shannon Zhao <shannon.zhao@linaro.org>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/kvm/coproc.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> > index f3d88dc..f4ad2f2 100644
> > --- a/arch/arm/kvm/coproc.c
> > +++ b/arch/arm/kvm/coproc.c
> > @@ -447,12 +447,22 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
> >                 r = find_reg(params, cp15_regs, ARRAY_SIZE(cp15_regs));
> >
> >         if (likely(r)) {
> > +               unsigned long pc = *vcpu_pc(vcpu);
> > +
> >                 /* If we don't have an accessor, we should never get here! */
> >                 BUG_ON(!r->access);
> >
> >                 if (likely(r->access(vcpu, params, r))) {
> > -                       /* Skip instruction, since it was emulated */
> > -                       kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> > +                       /*
> > +                        * Skip the instruction if it was emulated
> > +                        * without PC having changed. This allows us
> > +                        * to detect a fault being injected
> > +                        * (incrementing the PC here would cause the
> > +                        * vcpu to skip the first instruction of its
> > +                        * fault handler).
> > +                        */
> > +                       if (pc == *vcpu_pc(vcpu))
> > +                               kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
> 
> Won't this result in our incorrectly skipping the first insn
> in the fault handler if the original offending instruction
> was itself the first insn in the fault handler?
> 
Wouldn't that then loop with the exception forever?

-Christoffer
