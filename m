From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 10/28] ARM: KVM: Add timer save/restore
Date: Tue, 9 Feb 2016 19:42:42 +0100
Message-ID: <20160209184242.GN5171@cbox>
References: <1454583645-10144-1-git-send-email-marc.zyngier@arm.com>
 <1454583645-10144-11-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454583645-10144-11-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 04, 2016 at 11:00:27AM +0000, Marc Zyngier wrote:
> This patch shouldn't exist, as we should be able to reuse the
> arm64 version for free. I'll get there eventually, but in the
> meantime I need a timer ticking.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/hyp/Makefile   |  1 +
>  arch/arm/kvm/hyp/hyp.h      |  8 +++++
>  arch/arm/kvm/hyp/timer-sr.c | 71 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+)
>  create mode 100644 arch/arm/kvm/hyp/timer-sr.c
> 
> diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
> index 9f96fcb..9241ae8 100644
> --- a/arch/arm/kvm/hyp/Makefile
> +++ b/arch/arm/kvm/hyp/Makefile
> @@ -4,3 +4,4 @@
>  
>  obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
>  obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
> +obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
> diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
> index ab2cb82..4924418 100644
> --- a/arch/arm/kvm/hyp/hyp.h
> +++ b/arch/arm/kvm/hyp/hyp.h
> @@ -46,6 +46,9 @@
>  #define TTBR1		__ACCESS_CP15_64(1, c2)
>  #define VTTBR		__ACCESS_CP15_64(6, c2)
>  #define PAR		__ACCESS_CP15_64(0, c7)
> +#define CNTV_CVAL	__ACCESS_CP15_64(3, c14)
> +#define CNTVOFF		__ACCESS_CP15_64(4, c14)
> +
>  #define CSSELR		__ACCESS_CP15(c0, 2, c0, 0)
>  #define VMPIDR		__ACCESS_CP15(c0, 4, c0, 5)
>  #define SCTLR		__ACCESS_CP15(c1, 0, c0, 0)
> @@ -71,6 +74,11 @@
>  #define TID_URO		__ACCESS_CP15(c13, 0, c0, 3)
>  #define TID_PRIV	__ACCESS_CP15(c13, 0, c0, 4)
>  #define CNTKCTL		__ACCESS_CP15(c14, 0, c1, 0)
> +#define CNTV_CTL	__ACCESS_CP15(c14, 0, c3, 1)
> +#define CNTHCTL		__ACCESS_CP15(c14, 4, c1, 0)
> +
> +void __timer_save_state(struct kvm_vcpu *vcpu);
> +void __timer_restore_state(struct kvm_vcpu *vcpu);
>  
>  void __sysreg_save_state(struct kvm_cpu_context *ctxt);
>  void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
> diff --git a/arch/arm/kvm/hyp/timer-sr.c b/arch/arm/kvm/hyp/timer-sr.c
> new file mode 100644
> index 0000000..d7535fd
> --- /dev/null
> +++ b/arch/arm/kvm/hyp/timer-sr.c
> @@ -0,0 +1,71 @@
> +/*
> + * Copyright (C) 2012-2015 - ARM Ltd
> + * Author: Marc Zyngier <marc.zyngier@arm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <clocksource/arm_arch_timer.h>
> +#include <linux/compiler.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_mmu.h>
> +
> +#include "hyp.h"
> +
> +/* vcpu is already in the HYP VA space */
> +void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	u64 val;
> +
> +	if (kvm->arch.timer.enabled) {
> +		timer->cntv_ctl = read_sysreg(CNTV_CTL);
> +		timer->cntv_cval = read_sysreg(CNTV_CVAL);
> +	}
> +
> +	/* Disable the virtual timer */
> +	write_sysreg(0, CNTV_CTL);
> +
> +	/* Allow physical timer/counter access for the host */
> +	val = read_sysreg(CNTHCTL);
> +	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> +	write_sysreg(val, CNTHCTL);
> +
> +	/* Clear cntvoff for the host */
> +	write_sysreg(0, CNTVOFF);

in the asm version we only did this if the timer was enabled, probably
the theory being that only in that case did we mody the offset.  But it
should be safe to just clear the cntvoff in any case, right?

> +}
> +
> +void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> +	u64 val;
> +
> +	/*
> +	 * Disallow physical timer access for the guest
> +	 * Physical counter access is allowed
> +	 */
> +	val = read_sysreg(CNTHCTL);
> +	val &= ~CNTHCTL_EL1PCEN;
> +	val |= CNTHCTL_EL1PCTEN;
> +	write_sysreg(val, CNTHCTL);
> +
> +	if (kvm->arch.timer.enabled) {
> +		write_sysreg(kvm->arch.timer.cntvoff, CNTVOFF);
> +		write_sysreg(timer->cntv_cval, CNTV_CVAL);
> +		isb();
> +		write_sysreg(timer->cntv_ctl, CNTV_CTL);
> +	}
> +}
> -- 
> 2.1.4
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
