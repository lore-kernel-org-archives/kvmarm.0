From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 04/21] arm64: KVM: Implement vgic-v3 save/restore
Date: Tue, 01 Dec 2015 12:49:06 +0000
Message-ID: <565D9742.70600@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
 <1448650215-15218-5-git-send-email-marc.zyngier@arm.com>
 <20151130195054.GD11704@cbox> <565D8544.8040400@arm.com>
 <20151201114426.GK11704@cbox> <20151201115034.GM11704@cbox>
 <565D8B1C.3060301@arm.com> <20151201122418.GO11704@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 878D14995C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 07:47:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4+fjC1IicgaB for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 07:47:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCEB249958
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 07:47:45 -0500 (EST)
In-Reply-To: <20151201122418.GO11704@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 01/12/15 12:24, Christoffer Dall wrote:
> On Tue, Dec 01, 2015 at 11:57:16AM +0000, Marc Zyngier wrote:
>> On 01/12/15 11:50, Christoffer Dall wrote:
>>> On Tue, Dec 01, 2015 at 12:44:26PM +0100, Christoffer Dall wrote:
>>>> On Tue, Dec 01, 2015 at 11:32:20AM +0000, Marc Zyngier wrote:
>>>>> On 30/11/15 19:50, Christoffer Dall wrote:
>>>>>> On Fri, Nov 27, 2015 at 06:49:58PM +0000, Marc Zyngier wrote:
>>>>>>> Implement the vgic-v3 save restore as a direct translation of
>>>>>>> the assembly code version.
>>>>>>>
>>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>> ---
>>>>>>>  arch/arm64/kvm/hyp/Makefile     |   1 +
>>>>>>>  arch/arm64/kvm/hyp/hyp.h        |   3 +
>>>>>>>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 222 ++++++++++++++++++++++++++++++++++++++++
>>>>>>>  3 files changed, 226 insertions(+)
>>>>>>>  create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>>>>>
>>>>>>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>>>>>>> index d8d5968..d1e38ce 100644
>>>>>>> --- a/arch/arm64/kvm/hyp/Makefile
>>>>>>> +++ b/arch/arm64/kvm/hyp/Makefile
>>>>>>> @@ -3,3 +3,4 @@
>>>>>>>  #
>>>>>>>  
>>>>>>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>>>>>>> +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
>>>>>>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>>>>>>> index 78f25c4..a31cb6e 100644
>>>>>>> --- a/arch/arm64/kvm/hyp/hyp.h
>>>>>>> +++ b/arch/arm64/kvm/hyp/hyp.h
>>>>>>> @@ -30,5 +30,8 @@
>>>>>>>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>>>>>>>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>>>>>>>  
>>>>>>> +void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>>>>>>> +void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>>>>>>> +
>>>>>>>  #endif /* __ARM64_KVM_HYP_H__ */
>>>>>>>  
>>>>>>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>>>>> new file mode 100644
>>>>>>> index 0000000..b490db5
>>>>>>> --- /dev/null
>>>>>>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>>>>> @@ -0,0 +1,222 @@
>>>>>>> +/*
>>>>>>> + * Copyright (C) 2012-2015 - ARM Ltd
>>>>>>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
>>>>>>> + *
>>>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>>>> + * published by the Free Software Foundation.
>>>>>>> + *
>>>>>>> + * This program is distributed in the hope that it will be useful,
>>>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>>>> + * GNU General Public License for more details.
>>>>>>> + *
>>>>>>> + * You should have received a copy of the GNU General Public License
>>>>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>>>>> + */
>>>>>>> +
>>>>>>> +#include <linux/compiler.h>
>>>>>>> +#include <linux/irqchip/arm-gic-v3.h>
>>>>>>> +#include <linux/kvm_host.h>
>>>>>>> +
>>>>>>> +#include <asm/kvm_mmu.h>
>>>>>>> +
>>>>>>> +#include "hyp.h"
>>>>>>> +
>>>>>>> +/*
>>>>>>> + * We store LRs in reverse order to let the CPU deal with streaming
>>>>>>> + * access. Use this macro to make it look saner...
>>>>>>> + */
>>>>>>> +#define LR_OFFSET(n)	(15 - n)
>>>>>>> +
>>>>>>> +#define read_gicreg(r)							\
>>>>>>> +	({								\
>>>>>>> +		u64 reg;						\
>>>>>>> +		asm volatile("mrs_s %0, " __stringify(r) : "=r" (reg));	\
>>>>>>> +		reg;							\
>>>>>>> +	})
>>>>>>> +
>>>>>>> +#define write_gicreg(v,r)						\
>>>>>>> +	do {								\
>>>>>>> +		u64 __val = (v);					\
>>>>>>> +		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
>>>>>>> +	} while (0)
>>>>>>
>>>>>> remind me what the msr_s and mrs_s do compared to msr and mrs?
>>>>>
>>>>> They do the same job, only for the system registers which are not in the
>>>>> original ARMv8 architecture spec, and most likely not implemented by
>>>>> old(er) compilers.
>>>>>
>>>>>> are these the reason why we need separate macros to access the gic
>>>>>> registers compared to 'normal' sysregs?
>>>>>
>>>>> Indeed.
>>>>>
>>>>>>> +
>>>>>>> +/* vcpu is already in the HYP VA space */
>>>>>>> +void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>>>>>>> +{
>>>>>>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>>>>>>> +	u64 val;
>>>>>>> +	u32 nr_lr, nr_pri;
>>>>>>> +
>>>>>>> +	/*
>>>>>>> +	 * Make sure stores to the GIC via the memory mapped interface
>>>>>>> +	 * are now visible to the system register interface.
>>>>>>> +	 */
>>>>>>> +	dsb(st);
>>>>>>> +
>>>>>>> +	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
>>>>>>> +	cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
>>>>>>> +	cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
>>>>>>> +	cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
>>>>>>> +
>>>>>>> +	write_gicreg(0, ICH_HCR_EL2);
>>>>>>> +	val = read_gicreg(ICH_VTR_EL2);
>>>>>>> +	nr_lr = val & 0xf;
>>>>>>
>>>>>> this is not technically nr_lr, it's max_lr or max_lr_idx or something
>>>>>> like that.
>>>>>
>>>>> Let's go for max_lr_idx  then.
>>>>>
>>>>>>> +	nr_pri = ((u32)val >> 29) + 1;
>>>>>>
>>>>>> nit: nr_pri_bits
>>>>>>
>>>>>>> +
>>>>>>> +	switch (nr_lr) {
>>>>>>> +	case 15:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(15)] = read_gicreg(ICH_LR15_EL2);
>>>>>>> +	case 14:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(14)] = read_gicreg(ICH_LR14_EL2);
>>>>>>> +	case 13:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(13)] = read_gicreg(ICH_LR13_EL2);
>>>>>>> +	case 12:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(12)] = read_gicreg(ICH_LR12_EL2);
>>>>>>> +	case 11:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(11)] = read_gicreg(ICH_LR11_EL2);
>>>>>>> +	case 10:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(10)] = read_gicreg(ICH_LR10_EL2);
>>>>>>> +	case 9:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(9)] = read_gicreg(ICH_LR9_EL2);
>>>>>>> +	case 8:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(8)] = read_gicreg(ICH_LR8_EL2);
>>>>>>> +	case 7:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(7)] = read_gicreg(ICH_LR7_EL2);
>>>>>>> +	case 6:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(6)] = read_gicreg(ICH_LR6_EL2);
>>>>>>> +	case 5:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(5)] = read_gicreg(ICH_LR5_EL2);
>>>>>>> +	case 4:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(4)] = read_gicreg(ICH_LR4_EL2);
>>>>>>> +	case 3:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(3)] = read_gicreg(ICH_LR3_EL2);
>>>>>>> +	case 2:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(2)] = read_gicreg(ICH_LR2_EL2);
>>>>>>> +	case 1:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(1)] = read_gicreg(ICH_LR1_EL2);
>>>>>>> +	case 0:
>>>>>>> +		cpu_if->vgic_lr[LR_OFFSET(0)] = read_gicreg(ICH_LR0_EL2);
>>>>>>
>>>>>> I don't understand this; LR_OFFSET(0) == (15 - 0) == 15, so
>>>>>>
>>>>>> cpu_if->vgic_lr[15] = read_gicreg(ICH_LR0_EL2) ?
>>>>>
>>>>> Just like in the assembly version. We store the LRs in the order we read
>>>>> them so that we don't confuse the CPU by writing backward (believe it or
>>>>> not, CPUs do get horribly confused if you do that).
>>>>
>>>> but aren't we storing the wrong register to the wrong index in the
>>>> array?
>>>>
>>>> Do we really access cpu_if->vgic_lr[15..12] in the C-code if the system
>>>> only has 4 LRs?
>>>>
>>> ok, I looked at the code myself (not sure why I didn't do that in the
>>> first place) and indeed we use a different but with similar results
>>> macro to access the array from the C code.
>>>
>>> This is just insane to me, and we don't have a comment on the data
>>> structure saying "this is not stored the way you'd think it is".
>>>
>>> Why can't we just do:
>>>
>>> cpu_if->vgic_lr[3] = read_gicreg(ICH_LR3_EL2);
>>> cpu_if->vgic_lr[2] = read_gicreg(ICH_LR2_EL2);
>>> cpu_if->vgic_lr[1] = read_gicreg(ICH_LR1_EL2);
>>> cpu_if->vgic_lr[0] = read_gicreg(ICH_LR0_EL2);
>>>
>>> ?
>>
>> Because you're *really* killing performance by doing what are
>> essentially streaming read/writes in the opposite direction. CPU
>> prefetchers only work in one direction (incrementing the address). Doing
>> it backwards breaks it.
>>
> hmm, and what are prefetching with the stores here?

Cache lines. When you increase the address, the core can trigger a
prefetch of the next cache line so that it is ready by the time you get
to start clobbering it.

> Did anyone actually measure this or is it theoretically really slow?

I did some measurements around that in a previous life.

> Anyway, for the purposes of rewriting the world-switch in C, this looks
> fine.  I hope we can come up with something less convoluted some time,
> perhaps at least using the same macro for LR_INDEX and making the
> comments more clear.

Sure.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
