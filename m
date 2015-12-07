From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 05/22] arm64: KVM: Implement vgic-v3 save/restore
Date: Mon, 07 Dec 2015 18:20:15 +0000
Message-ID: <5665CDDF.3090201@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-6-git-send-email-marc.zyngier@arm.com>
 <5665B663.8020705@samsung.com> <5665B940.7000601@arm.com>
 <5665BF4D.7090103@samsung.com> <5665C3C7.9010600@arm.com>
 <5665CA68.2000401@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20834411BE
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 13:18:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MFDj-ApCbOFe for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2015 13:18:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3C2B400E9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2015 13:18:31 -0500 (EST)
In-Reply-To: <5665CA68.2000401@samsung.com>
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

On 07/12/15 18:05, Mario Smarduch wrote:
> 
> 
> On 12/7/2015 9:37 AM, Marc Zyngier wrote:
>> On 07/12/15 17:18, Mario Smarduch wrote:
>>>
>>>
>>> On 12/7/2015 8:52 AM, Marc Zyngier wrote:
>>>> Hi Mario,
>>>>
>>>> On 07/12/15 16:40, Mario Smarduch wrote:
>>>>> Hi Marc,
>>>>>
>>>>> On 12/7/2015 2:53 AM, Marc Zyngier wrote:
>>>>>> Implement the vgic-v3 save restore as a direct translation of
>>>>>> the assembly code version.
>>>>>>
>>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>>> ---
>>>>>>  arch/arm64/kvm/hyp/Makefile     |   1 +
>>>>>>  arch/arm64/kvm/hyp/hyp.h        |   3 +
>>>>>>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 226 ++++++++++++++++++++++++++++++++++++++++
>>>>>>  3 files changed, 230 insertions(+)
>>>>>>  create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>>>>
>>>>>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>>>>>> index d8d5968..d1e38ce 100644
>>>>>> --- a/arch/arm64/kvm/hyp/Makefile
>>>>>> +++ b/arch/arm64/kvm/hyp/Makefile
>>>>>> @@ -3,3 +3,4 @@
>>>>>>  #
>>>>>>  
>>>>>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>>>>>> +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
>>>>>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>>>>>> index ac63553..5759f9f 100644
>>>>>> --- a/arch/arm64/kvm/hyp/hyp.h
>>>>>> +++ b/arch/arm64/kvm/hyp/hyp.h
>>>>>> @@ -32,5 +32,8 @@
>>>>>>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>>>>>>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>>>>>>  
>>>>>> +void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>>>>>> +void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>>>>>> +
>>>>>>  #endif /* __ARM64_KVM_HYP_H__ */
>>>>>>  
>>>>>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>>>> new file mode 100644
>>>>>> index 0000000..78d05f3
>>>>>> --- /dev/null
>>>>>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>>>> @@ -0,0 +1,226 @@
>>>>>> +/*
>>>>>> + * Copyright (C) 2012-2015 - ARM Ltd
>>>>>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
>>>>>> + *
>>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>>> + * published by the Free Software Foundation.
>>>>>> + *
>>>>>> + * This program is distributed in the hope that it will be useful,
>>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>>> + * GNU General Public License for more details.
>>>>>> + *
>>>>>> + * You should have received a copy of the GNU General Public License
>>>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>>>> + */
>>>>>> +
>>>>>> +#include <linux/compiler.h>
>>>>>> +#include <linux/irqchip/arm-gic-v3.h>
>>>>>> +#include <linux/kvm_host.h>
>>>>>> +
>>>>>> +#include <asm/kvm_mmu.h>
>>>>>> +
>>>>>> +#include "hyp.h"
>>>>>> +
>>>>>> +#define vtr_to_max_lr_idx(v)		((v) & 0xf)
>>>>>> +#define vtr_to_nr_pri_bits(v)		(((u32)(v) >> 29) + 1)
>>>>>> +
>>>>>> +#define read_gicreg(r)							\
>>>>>> +	({								\
>>>>>> +		u64 reg;						\
>>>>>> +		asm volatile("mrs_s %0, " __stringify(r) : "=r" (reg));	\
>>>>>> +		reg;							\
>>>>>> +	})
>>>>>> +
>>>>>> +#define write_gicreg(v,r)						\
>>>>>> +	do {								\
>>>>>> +		u64 __val = (v);					\
>>>>>> +		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
>>>>>> +	} while (0)
>>>>>> +
>>>>>> +/* vcpu is already in the HYP VA space */
>>>>>> +void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>>>>>> +{
>>>>>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>>>>>> +	u64 val;
>>>>>> +	u32 max_lr_idx, nr_pri_bits;
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * Make sure stores to the GIC via the memory mapped interface
>>>>>> +	 * are now visible to the system register interface.
>>>>>> +	 */
>>>>>> +	dsb(st);
>>>>>> +
>>>>>> +	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
>>>>>> +	cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
>>>>>> +	cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
>>>>>> +	cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
>>>>>> +
>>>>>> +	write_gicreg(0, ICH_HCR_EL2);
>>>>>> +	val = read_gicreg(ICH_VTR_EL2);
>>>>>> +	max_lr_idx = vtr_to_max_lr_idx(val);
>>>>>> +	nr_pri_bits = vtr_to_nr_pri_bits(val);
>>>>>> +
>>>>> Can you setup a base pointer to cpu_if->vgic_lr and use an offset?
>>>>
>>>> I could, but I fail to see what we'd gain by using this (aside from
>>>> slightly shorter lines). Or am I completely missing the point?
>>>
>>> Skip adding the offset of vgic_lr to cpu_if pointer.
>>
>> But if we do that, we also change the layout that EL1 expect. Assume we
>> do something like this:
>>
>> u64 *current_lr = cpu_if->vgic_lr;
>>
>> switch (max_lr_idx) {
>> 	case 15:
>> 		current_lr++ = read_gicreg(ICH_LR15_EL2);
>> 	case 14:
>> 		current_lr++ = read_gicreg(ICH_LR14_EL2);
>> 	[...]
>> }
>>
> 
> I was thinking something like 'current_lr[VGIC_V3_LR_INDEX(...)]'.

That doesn't change anything, the compiler is perfectly able to 
optimize something like this:

[...]
ffffffc0007f31ac:       38624862        ldrb    w2, [x3,w2,uxtw]
ffffffc0007f31b0:       10000063        adr     x3, ffffffc0007f31bc <__vgic_v3_save_state+0x64>
ffffffc0007f31b4:       8b228862        add     x2, x3, w2, sxtb #2
ffffffc0007f31b8:       d61f0040        br      x2
ffffffc0007f31bc:       d53ccde2        mrs     x2, s3_4_c12_c13_7
ffffffc0007f31c0:       f9001c02        str     x2, [x0,#56]
ffffffc0007f31c4:       d53ccdc2        mrs     x2, s3_4_c12_c13_6
ffffffc0007f31c8:       f9002002        str     x2, [x0,#64]
ffffffc0007f31cc:       d53ccda2        mrs     x2, s3_4_c12_c13_5
ffffffc0007f31d0:       f9002402        str     x2, [x0,#72]
ffffffc0007f31d4:       d53ccd82        mrs     x2, s3_4_c12_c13_4
ffffffc0007f31d8:       f9002802        str     x2, [x0,#80]
ffffffc0007f31dc:       d53ccd62        mrs     x2, s3_4_c12_c13_3
ffffffc0007f31e0:       f9002c02        str     x2, [x0,#88]
ffffffc0007f31e4:       d53ccd42        mrs     x2, s3_4_c12_c13_2
ffffffc0007f31e8:       f9003002        str     x2, [x0,#96]
ffffffc0007f31ec:       d53ccd22        mrs     x2, s3_4_c12_c13_1
ffffffc0007f31f0:       f9003402        str     x2, [x0,#104]
ffffffc0007f31f4:       d53ccd02        mrs     x2, s3_4_c12_c13_0
ffffffc0007f31f8:       f9003802        str     x2, [x0,#112]
ffffffc0007f31fc:       d53ccce2        mrs     x2, s3_4_c12_c12_7
ffffffc0007f3200:       f9003c02        str     x2, [x0,#120]
ffffffc0007f3204:       d53cccc2        mrs     x2, s3_4_c12_c12_6
ffffffc0007f3208:       f9004002        str     x2, [x0,#128]
ffffffc0007f320c:       d53ccca2        mrs     x2, s3_4_c12_c12_5
ffffffc0007f3210:       f9004402        str     x2, [x0,#136]
ffffffc0007f3214:       d53ccc82        mrs     x2, s3_4_c12_c12_4
ffffffc0007f3218:       f9004802        str     x2, [x0,#144]
ffffffc0007f321c:       d53ccc62        mrs     x2, s3_4_c12_c12_3
ffffffc0007f3220:       f9004c02        str     x2, [x0,#152]
ffffffc0007f3224:       d53ccc42        mrs     x2, s3_4_c12_c12_2
ffffffc0007f3228:       f9005002        str     x2, [x0,#160]
ffffffc0007f322c:       d53ccc22        mrs     x2, s3_4_c12_c12_1
ffffffc0007f3230:       f9005402        str     x2, [x0,#168]
ffffffc0007f3234:       d53ccc02        mrs     x2, s3_4_c12_c12_0
ffffffc0007f3238:       7100183f        cmp     w1, #0x6
ffffffc0007f323c:       f9005802        str     x2, [x0,#176]

As you can see, this is as optimal as it gets, short of being able
to find a nice way to use more than one register...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
