From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 07/22] arm64: KVM: Implement system register save/restore
Date: Fri, 11 Dec 2015 18:29:01 +0000
Message-ID: <566B15ED.5030906@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com> <1449485618-9443-8-git-send-email-marc.zyngier@arm.com> <566A420B.2080406@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <566A420B.2080406@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mario,

On 11/12/15 03:24, Mario Smarduch wrote:
> Hi Marc,
> 
> On 12/7/2015 2:53 AM, Marc Zyngier wrote:
>> Implement the system register save/restore as a direct translation of
>> the assembly code version.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>> ---
>>  arch/arm64/kvm/hyp/Makefile    |  1 +
>>  arch/arm64/kvm/hyp/hyp.h       |  3 ++
>>  arch/arm64/kvm/hyp/sysreg-sr.c | 90 ++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 94 insertions(+)
>>  create mode 100644 arch/arm64/kvm/hyp/sysreg-sr.c
>>
>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>> index 455dc0a..ec94200 100644
>> --- a/arch/arm64/kvm/hyp/Makefile
>> +++ b/arch/arm64/kvm/hyp/Makefile
>> @@ -5,3 +5,4 @@
>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
>>  obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
>> +obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>> index f213e46..778d56d 100644
>> --- a/arch/arm64/kvm/hyp/hyp.h
>> +++ b/arch/arm64/kvm/hyp/hyp.h
>> @@ -38,5 +38,8 @@ void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>>  void __timer_save_state(struct kvm_vcpu *vcpu);
>>  void __timer_restore_state(struct kvm_vcpu *vcpu);
>>  
>> +void __sysreg_save_state(struct kvm_cpu_context *ctxt);
>> +void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
>> +
>>  #endif /* __ARM64_KVM_HYP_H__ */
>>  
>> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
>> new file mode 100644
>> index 0000000..add8fcb
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
>> @@ -0,0 +1,90 @@
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
>> +#include <linux/compiler.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/kvm_mmu.h>
>> +
>> +#include "hyp.h"
>> +
> 
> I looked closer on some other ways to get better performance out of
> the compiler. This code sequence performs about 35% faster for 
> __sysreg_save_state(..) for 5000 exits you save about 500mS or 100nS
> per exit. This is on Juno.

35% faster? Really? That's pretty crazy. Was that on the A57 or the A53?

> 
> register int volatile count asm("r2") = 0;

Does this even work on arm64? We don't have an "r2" register...

> 
> do {
> ....
> } while(count);
> 
> I didn't test the restore function (ran out of time) but I suspect it should be
> the same. The assembler pretty much uses all the GPRs, (a little too many, using
> stp to push 4 pairs on the stack and restore) looking at the assembler it all
> should execute out of order.

Are you talking about the original implementation here? or the generated
code out of the compiler? The original implementation didn't push
anything on the stack (apart from the prologue, but we have the same
thing in the C implementation).

Looking at the compiler output, we have a bunch of mrs/str, one after
the other - pretty basic. Maybe that gives the CPU some "breathing"
time, but I have no idea if that's more or less efficient.

But the main thing is that we can now rely on the compiler to generate
something that is more or less optimized for a given platform if there
is such a requirement. We go from something that was cast in stone to
something that has some degree of flexibility.

> 
> FWIW I gave this a try since compilers like to optimize loops. I used
> 'cntpct_el0' counter register to measure the intervals.

It'd be nice to have a measure in terms of cycle, but that's a good
first approximation.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
