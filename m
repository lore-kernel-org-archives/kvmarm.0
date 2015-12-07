From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 05/22] arm64: KVM: Implement vgic-v3 save/restore
Date: Mon, 07 Dec 2015 17:37:11 +0000
Message-ID: <5665C3C7.9010600@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com> <1449485618-9443-6-git-send-email-marc.zyngier@arm.com> <5665B663.8020705@samsung.com> <5665B940.7000601@arm.com> <5665BF4D.7090103@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5665BF4D.7090103@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/12/15 17:18, Mario Smarduch wrote:
> 
> 
> On 12/7/2015 8:52 AM, Marc Zyngier wrote:
>> Hi Mario,
>>
>> On 07/12/15 16:40, Mario Smarduch wrote:
>>> Hi Marc,
>>>
>>> On 12/7/2015 2:53 AM, Marc Zyngier wrote:
>>>> Implement the vgic-v3 save restore as a direct translation of
>>>> the assembly code version.
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm64/kvm/hyp/Makefile     |   1 +
>>>>  arch/arm64/kvm/hyp/hyp.h        |   3 +
>>>>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 226 ++++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 230 insertions(+)
>>>>  create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>>
>>>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>>>> index d8d5968..d1e38ce 100644
>>>> --- a/arch/arm64/kvm/hyp/Makefile
>>>> +++ b/arch/arm64/kvm/hyp/Makefile
>>>> @@ -3,3 +3,4 @@
>>>>  #
>>>>  
>>>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>>>> +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
>>>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>>>> index ac63553..5759f9f 100644
>>>> --- a/arch/arm64/kvm/hyp/hyp.h
>>>> +++ b/arch/arm64/kvm/hyp/hyp.h
>>>> @@ -32,5 +32,8 @@
>>>>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>>>>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>>>>  
>>>> +void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>>>> +void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>>>> +
>>>>  #endif /* __ARM64_KVM_HYP_H__ */
>>>>  
>>>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>> new file mode 100644
>>>> index 0000000..78d05f3
>>>> --- /dev/null
>>>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>>>> @@ -0,0 +1,226 @@
>>>> +/*
>>>> + * Copyright (C) 2012-2015 - ARM Ltd
>>>> + * Author: Marc Zyngier <marc.zyngier@arm.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public License
>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>> + */
>>>> +
>>>> +#include <linux/compiler.h>
>>>> +#include <linux/irqchip/arm-gic-v3.h>
>>>> +#include <linux/kvm_host.h>
>>>> +
>>>> +#include <asm/kvm_mmu.h>
>>>> +
>>>> +#include "hyp.h"
>>>> +
>>>> +#define vtr_to_max_lr_idx(v)		((v) & 0xf)
>>>> +#define vtr_to_nr_pri_bits(v)		(((u32)(v) >> 29) + 1)
>>>> +
>>>> +#define read_gicreg(r)							\
>>>> +	({								\
>>>> +		u64 reg;						\
>>>> +		asm volatile("mrs_s %0, " __stringify(r) : "=r" (reg));	\
>>>> +		reg;							\
>>>> +	})
>>>> +
>>>> +#define write_gicreg(v,r)						\
>>>> +	do {								\
>>>> +		u64 __val = (v);					\
>>>> +		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
>>>> +	} while (0)
>>>> +
>>>> +/* vcpu is already in the HYP VA space */
>>>> +void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>>>> +	u64 val;
>>>> +	u32 max_lr_idx, nr_pri_bits;
>>>> +
>>>> +	/*
>>>> +	 * Make sure stores to the GIC via the memory mapped interface
>>>> +	 * are now visible to the system register interface.
>>>> +	 */
>>>> +	dsb(st);
>>>> +
>>>> +	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
>>>> +	cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
>>>> +	cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
>>>> +	cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
>>>> +
>>>> +	write_gicreg(0, ICH_HCR_EL2);
>>>> +	val = read_gicreg(ICH_VTR_EL2);
>>>> +	max_lr_idx = vtr_to_max_lr_idx(val);
>>>> +	nr_pri_bits = vtr_to_nr_pri_bits(val);
>>>> +
>>> Can you setup a base pointer to cpu_if->vgic_lr and use an offset?
>>
>> I could, but I fail to see what we'd gain by using this (aside from
>> slightly shorter lines). Or am I completely missing the point?
> 
> Skip adding the offset of vgic_lr to cpu_if pointer.

But if we do that, we also change the layout that EL1 expect. Assume we
do something like this:

u64 *current_lr = cpu_if->vgic_lr;

switch (max_lr_idx) {
	case 15:
		current_lr++ = read_gicreg(ICH_LR15_EL2);
	case 14:
		current_lr++ = read_gicreg(ICH_LR14_EL2);
	[...]
}

with max_lr_idx = 4 (a common case), we end up filling vgic_lr[0..3],
while the rest of the code expects it in vgic_lr[12..15]. This defeats
the point of being able to replace the world switch without changing the
rest of the code. It also means that the position of a given LR in
memory now depends on a runtime constant instead of a compile-time constant.

If you had something different in mind, please give me some sample code,
because I'm a bit lost as to what you really have in mind.

>>
>>> Also is there a way to get rid of the constants, that implicitly hard codes max
>>> number of LRs, doesn't make the code portable.
>>
>> Well, it is a sad fact of life that the maximum number of LRs *is*
>> hardcoded to an architectural limit of 16. These are CPU registers, and
>> there is only so many of them (and probably a lot less in practice -
>> filling 4 of them has proved to be an extremely rare case).
> 
> Yes I'm aware of that it was 64 (or maybe still is) on armv7 but specs have
> changed from time to time.

This doesn't have much to do with ARMv7 vs ARMv8, but with the GIC
architecture (well, ARMv7 doesn't support GICv3, so that's a moot point):

- GICv2: max 64 LRs (in practice, GIC400: 4 LRs)
- GICv3: max 16 LRs (in practice, Cortex-A57: 4 LRs)

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
