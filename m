From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 05/21] arm64: KVM: Implement timer save/restore
Date: Tue, 01 Dec 2015 11:34:41 +0000
Message-ID: <565D85D1.6060908@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-6-git-send-email-marc.zyngier@arm.com> <20151130195955.GE11704@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151130195955.GE11704@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 30/11/15 19:59, Christoffer Dall wrote:
> On Fri, Nov 27, 2015 at 06:49:59PM +0000, Marc Zyngier wrote:
>> Implement the timer save restore as a direct translation of
>> the assembly code version.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/Makefile          |  1 +
>>  arch/arm64/kvm/hyp/hyp.h             |  3 ++
>>  arch/arm64/kvm/hyp/timer-sr.c        | 71 ++++++++++++++++++++++++++++++++++++
>>  include/clocksource/arm_arch_timer.h |  6 +++
>>  4 files changed, 81 insertions(+)
>>  create mode 100644 arch/arm64/kvm/hyp/timer-sr.c
>>
>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>> index d1e38ce..455dc0a 100644
>> --- a/arch/arm64/kvm/hyp/Makefile
>> +++ b/arch/arm64/kvm/hyp/Makefile
>> @@ -4,3 +4,4 @@
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
>> +obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>> index a31cb6e..86aa5a2 100644
>> --- a/arch/arm64/kvm/hyp/hyp.h
>> +++ b/arch/arm64/kvm/hyp/hyp.h
>> @@ -33,5 +33,8 @@ void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>>  void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>>  void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>>  
>> +void __timer_save_state(struct kvm_vcpu *vcpu);
>> +void __timer_restore_state(struct kvm_vcpu *vcpu);
>> +
>>  #endif /* __ARM64_KVM_HYP_H__ */
>>  
>> diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
>> new file mode 100644
>> index 0000000..8e2209c
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/timer-sr.c
>> @@ -0,0 +1,71 @@
>> +/*
>> + * Copyright (C) 2012-2015 - ARM Ltd
>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <clocksource/arm_arch_timer.h>
>> +#include <linux/compiler.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/kvm_mmu.h>
>> +
>> +#include "hyp.h"
>> +
>> +/* vcpu is already in the HYP VA space */
>> +void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> +
>> +	if (kvm->arch.timer.enabled) {
>> +		timer->cntv_ctl = read_sysreg(cntv_ctl_el0);
>> +		isb();
>> +		timer->cntv_cval = read_sysreg(cntv_cval_el0);
>> +	}
>> +
>> +	/* Disable the virtual timer */
>> +	write_sysreg(0, cntv_ctl_el0);
>> +
>> +	/* Allow physical timer/counter access for the host */
>> +	write_sysreg((read_sysreg(cnthctl_el2) | CNTHCTL_EL1PCTEN |
>> +		      CNTHCTL_EL1PCEN),
>> +		     cnthctl_el2);
> 
> nit: again I probably prefer reading cnthctl_el2 into a variable, modify
> the bits and write it back, but it's no big deal.

Sure.

>> +
>> +	/* Clear cntvoff for the host */
>> +	write_sysreg(0, cntvoff_el2);
> 
> why do we do this when we've just disabled the timer?

Because the host does use CNTVCT_EL0 (see the VDSO code), and you don't
want time to go backward over there...

>> +}
>> +
>> +void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>> +	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>> +	u64 val;
>> +
>> +	/*
>> +	 * Disallow physical timer access for the guest
>> +	 * Physical counter access is allowed
>> +	 */
>> +	val = read_sysreg(cnthctl_el2);
>> +	val &= ~CNTHCTL_EL1PCEN;
>> +	val |= CNTHCTL_EL1PCTEN;
>> +	write_sysreg(val, cnthctl_el2);
>> +
>> +	if (kvm->arch.timer.enabled) {
>> +		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
>> +		write_sysreg(timer->cntv_cval, cntv_cval_el0);
>> +		isb();
>> +		write_sysreg(timer->cntv_ctl, cntv_ctl_el0);
>> +	}
>> +}
>> diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
>> index 9916d0e..25d0914 100644
>> --- a/include/clocksource/arm_arch_timer.h
>> +++ b/include/clocksource/arm_arch_timer.h
>> @@ -23,6 +23,12 @@
>>  #define ARCH_TIMER_CTRL_IT_MASK		(1 << 1)
>>  #define ARCH_TIMER_CTRL_IT_STAT		(1 << 2)
>>  
>> +#define CNTHCTL_EL1PCTEN		(1 << 0)
>> +#define CNTHCTL_EL1PCEN			(1 << 1)
>> +#define CNTHCTL_EVNTEN			(1 << 2)
>> +#define CNTHCTL_EVNTDIR			(1 << 3)
>> +#define CNTHCTL_EVNTI			(0xF << 4)
>> +
>>  enum arch_timer_reg {
>>  	ARCH_TIMER_REG_CTRL,
>>  	ARCH_TIMER_REG_TVAL,
>> -- 
>> 2.1.4
>>
> 
> Otherwise this looks good.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
