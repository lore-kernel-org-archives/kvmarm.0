From: Mario Smarduch <m.smarduch@samsung.com>
Subject: Re: [PATCH v3 06/22] arm64: KVM: Implement timer save/restore
Date: Mon, 07 Dec 2015 18:18:56 -0800
Message-ID: <56663E10.2010108@samsung.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-7-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1449485618-9443-7-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 12/7/2015 2:53 AM, Marc Zyngier wrote:
> Implement the timer save restore as a direct translation of
> the assembly code version.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/Makefile          |  1 +
>  arch/arm64/kvm/hyp/hyp.h             |  3 ++
>  arch/arm64/kvm/hyp/timer-sr.c        | 72 ++++++++++++++++++++++++++++++++++++
>  include/clocksource/arm_arch_timer.h |  6 +++
>  4 files changed, 82 insertions(+)
>  create mode 100644 arch/arm64/kvm/hyp/timer-sr.c
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index d1e38ce..455dc0a 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -4,3 +4,4 @@
>  
>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
> +obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> index 5759f9f..f213e46 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -35,5 +35,8 @@ void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>  void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>  
> +void __timer_save_state(struct kvm_vcpu *vcpu);
> +void __timer_restore_state(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_HYP_H__ */
>  
> diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
> new file mode 100644
> index 0000000..67292c0
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/timer-sr.c
> @@ -0,0 +1,72 @@
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
> +		timer->cntv_ctl = read_sysreg(cntv_ctl_el0);
> +		isb();

Can you share the subtle insight why is the isb() needed here?
B2.7.3 mentions changes to system registers only.

> +		timer->cntv_cval = read_sysreg(cntv_cval_el0);
> +	}
> +
> +	/* Disable the virtual timer */
> +	write_sysreg(0, cntv_ctl_el0);
> +
> +	/* Allow physical timer/counter access for the host */
> +	val = read_sysreg(cnthctl_el2);
> +	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
> +	write_sysreg(val, cnthctl_el2);
> +
> +	/* Clear cntvoff for the host */
> +	write_sysreg(0, cntvoff_el2);
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
> +	val = read_sysreg(cnthctl_el2);
> +	val &= ~CNTHCTL_EL1PCEN;
> +	val |= CNTHCTL_EL1PCTEN;
> +	write_sysreg(val, cnthctl_el2);
> +
> +	if (kvm->arch.timer.enabled) {
> +		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
> +		write_sysreg(timer->cntv_cval, cntv_cval_el0);
> +		isb();
> +		write_sysreg(timer->cntv_ctl, cntv_ctl_el0);
> +	}
> +}
> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
> index 9916d0e..25d0914 100644
> --- a/include/clocksource/arm_arch_timer.h
> +++ b/include/clocksource/arm_arch_timer.h
> @@ -23,6 +23,12 @@
>  #define ARCH_TIMER_CTRL_IT_MASK		(1 << 1)
>  #define ARCH_TIMER_CTRL_IT_STAT		(1 << 2)
>  
> +#define CNTHCTL_EL1PCTEN		(1 << 0)
> +#define CNTHCTL_EL1PCEN			(1 << 1)
> +#define CNTHCTL_EVNTEN			(1 << 2)
> +#define CNTHCTL_EVNTDIR			(1 << 3)
> +#define CNTHCTL_EVNTI			(0xF << 4)
> +
>  enum arch_timer_reg {
>  	ARCH_TIMER_REG_CTRL,
>  	ARCH_TIMER_REG_TVAL,
> 
