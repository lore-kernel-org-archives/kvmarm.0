From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 06/22] arm64: KVM: Implement timer save/restore
Date: Tue, 08 Dec 2015 10:02:59 +0000
Message-ID: <5666AAD3.9000906@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-7-git-send-email-marc.zyngier@arm.com>
 <56663E10.2010108@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFD2640B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 05:01:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ii+ZE5o2dYSu for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 05:01:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D0C740B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 05:01:12 -0500 (EST)
In-Reply-To: <56663E10.2010108@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mario Smarduch <m.smarduch@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/12/15 02:18, Mario Smarduch wrote:
> 
> 
> On 12/7/2015 2:53 AM, Marc Zyngier wrote:
>> Implement the timer save restore as a direct translation of
>> the assembly code version.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/Makefile          |  1 +
>>  arch/arm64/kvm/hyp/hyp.h             |  3 ++
>>  arch/arm64/kvm/hyp/timer-sr.c        | 72 ++++++++++++++++++++++++++++++++++++
>>  include/clocksource/arm_arch_timer.h |  6 +++
>>  4 files changed, 82 insertions(+)
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
>> index 5759f9f..f213e46 100644
>> --- a/arch/arm64/kvm/hyp/hyp.h
>> +++ b/arch/arm64/kvm/hyp/hyp.h
>> @@ -35,5 +35,8 @@ void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
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
>> index 0000000..67292c0
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/timer-sr.c
>> @@ -0,0 +1,72 @@
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
>> +	u64 val;
>> +
>> +	if (kvm->arch.timer.enabled) {
>> +		timer->cntv_ctl = read_sysreg(cntv_ctl_el0);
>> +		isb();
> 
> Can you share the subtle insight why is the isb() needed here?
> B2.7.3 mentions changes to system registers only.

This is actually a leftover of some previous code rework in the assembly
version of this code, which has found its way into the new
implementation. Duh.

Thanks for pointing this out.

	M.
-- 
Jazz is not dead. It just smells funny...
