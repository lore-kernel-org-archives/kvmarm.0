From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/21] arm64: KVM: Implement timer save/restore
Date: Wed, 25 Nov 2015 08:23:20 +0000
Message-ID: <20151125082320.35489d99@arm.com>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
	<1447679519-17888-6-git-send-email-marc.zyngier@arm.com>
	<20151123104653.GA21198@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151123104653.GA21198@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Steve Capper <steve.capper@linaro.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 23 Nov 2015 10:47:10 +0000
Steve Capper <steve.capper@linaro.org> wrote:

Hi Steve,

> On Mon, Nov 16, 2015 at 01:11:43PM +0000, Marc Zyngier wrote:
> > Implement the timer save restore as a direct translation of
> > the assembly code version.  
> 
> Hi Marc, some comments below.
> Cheers,
> -- 
> Steve
> 
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/Makefile   |  1 +
> >  arch/arm64/kvm/hyp/hyp.h      |  3 ++
> >  arch/arm64/kvm/hyp/timer-sr.c | 68
> > +++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 72
> > insertions(+) create mode 100644 arch/arm64/kvm/hyp/timer-sr.c
> > 
> > diff --git a/arch/arm64/kvm/hyp/Makefile
> > b/arch/arm64/kvm/hyp/Makefile index d1e38ce..455dc0a 100644
> > --- a/arch/arm64/kvm/hyp/Makefile
> > +++ b/arch/arm64/kvm/hyp/Makefile
> > @@ -4,3 +4,4 @@
> >  
> >  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
> >  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
> > +obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
> > diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> > index a31cb6e..86aa5a2 100644
> > --- a/arch/arm64/kvm/hyp/hyp.h
> > +++ b/arch/arm64/kvm/hyp/hyp.h
> > @@ -33,5 +33,8 @@ void __vgic_v2_restore_state(struct kvm_vcpu
> > *vcpu); void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
> >  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> >  
> > +void __timer_save_state(struct kvm_vcpu *vcpu);
> > +void __timer_restore_state(struct kvm_vcpu *vcpu);
> > +
> >  #endif /* __ARM64_KVM_HYP_H__ */
> >  
> > diff --git a/arch/arm64/kvm/hyp/timer-sr.c
> > b/arch/arm64/kvm/hyp/timer-sr.c new file mode 100644
> > index 0000000..1a1d2ac
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/timer-sr.c
> > @@ -0,0 +1,68 @@
> > +/*
> > + * Copyright (C) 2012-2015 - ARM Ltd
> > + * Author: Marc Zyngier <marc.zyngier@arm.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > modify
> > + * it under the terms of the GNU General Public License version 2
> > as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program.  If not, see
> > <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/kvm_host.h>
> > +
> > +#include <asm/kvm_mmu.h>
> > +
> > +#include "hyp.h"
> > +
> > +/* vcpu is already in the HYP VA space */
> > +void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> > +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> > +
> > +	if (kvm->arch.timer.enabled) {
> > +		timer->cntv_ctl = read_sysreg(cntv_ctl_el0);  
> 
> The old assembler version ands this value with 3 before storing it.
> Are we not worried about the ISTATUS bit?

Not really. It could even be useful to find out about it, to be
honest.

> 
> > +		isb();
> > +		timer->cntv_cval = read_sysreg(cntv_cval_el0);
> > +	}
> > +
> > +	/* Disable the virtual timer */
> > +	write_sysreg(0, cntv_ctl_el0);
> > +
> > +	/* Allow physical timer/counter access for the host */
> > +	write_sysreg(read_sysreg(cnthctl_el2) | 3, cnthctl_el2);  
> 
> nit: EL1PCTEN | EL1PCEN or something similar?

Sure.

> > +
> > +	/* Clear cntvoff for the host */
> > +	write_sysreg(0, cntvoff_el2);
> > +}
> > +
> > +void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> > +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> > +	u64 val;
> > +
> > +	/*
> > +	 * Disallow physical timer access for the guest
> > +	 * Physical counter access is allowed
> > +	 */
> > +	val = read_sysreg(cnthctl_el2);
> > +	val &= ~(1 << 1);
> > +	val |= 1;  
> 
> Similar nit here about constants.
> 
> > +	write_sysreg(val, cnthctl_el2);
> > +
> > +	if (kvm->arch.timer.enabled) {
> > +		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
> > +		write_sysreg(timer->cntv_cval, cntv_cval_el0);
> > +		isb();
> > +		write_sysreg(timer->cntv_ctl, cntv_ctl_el0);  
> 
> In the assembler version we and cntv_ctl with 3 before writing to
> cntv_ctl_el0.

ISTATUS is RO, so masking it was a bit useless.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
