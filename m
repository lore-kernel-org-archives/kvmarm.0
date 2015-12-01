From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 04/21] arm64: KVM: Implement vgic-v3 save/restore
Date: Tue, 01 Dec 2015 11:32:20 +0000
Message-ID: <565D8544.8040400@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com> <1448650215-15218-5-git-send-email-marc.zyngier@arm.com> <20151130195054.GD11704@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151130195054.GD11704@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 30/11/15 19:50, Christoffer Dall wrote:
> On Fri, Nov 27, 2015 at 06:49:58PM +0000, Marc Zyngier wrote:
>> Implement the vgic-v3 save restore as a direct translation of
>> the assembly code version.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp/Makefile     |   1 +
>>  arch/arm64/kvm/hyp/hyp.h        |   3 +
>>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 222 ++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 226 insertions(+)
>>  create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
>>
>> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
>> index d8d5968..d1e38ce 100644
>> --- a/arch/arm64/kvm/hyp/Makefile
>> +++ b/arch/arm64/kvm/hyp/Makefile
>> @@ -3,3 +3,4 @@
>>  #
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
>> +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
>> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
>> index 78f25c4..a31cb6e 100644
>> --- a/arch/arm64/kvm/hyp/hyp.h
>> +++ b/arch/arm64/kvm/hyp/hyp.h
>> @@ -30,5 +30,8 @@
>>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>>  
>> +void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
>> +void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
>> +
>>  #endif /* __ARM64_KVM_HYP_H__ */
>>  
>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> new file mode 100644
>> index 0000000..b490db5
>> --- /dev/null
>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> @@ -0,0 +1,222 @@
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
>> +#include <linux/irqchip/arm-gic-v3.h>
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/kvm_mmu.h>
>> +
>> +#include "hyp.h"
>> +
>> +/*
>> + * We store LRs in reverse order to let the CPU deal with streaming
>> + * access. Use this macro to make it look saner...
>> + */
>> +#define LR_OFFSET(n)	(15 - n)
>> +
>> +#define read_gicreg(r)							\
>> +	({								\
>> +		u64 reg;						\
>> +		asm volatile("mrs_s %0, " __stringify(r) : "=r" (reg));	\
>> +		reg;							\
>> +	})
>> +
>> +#define write_gicreg(v,r)						\
>> +	do {								\
>> +		u64 __val = (v);					\
>> +		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
>> +	} while (0)
> 
> remind me what the msr_s and mrs_s do compared to msr and mrs?

They do the same job, only for the system registers which are not in the
original ARMv8 architecture spec, and most likely not implemented by
old(er) compilers.

> are these the reason why we need separate macros to access the gic
> registers compared to 'normal' sysregs?

Indeed.

>> +
>> +/* vcpu is already in the HYP VA space */
>> +void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>> +	u64 val;
>> +	u32 nr_lr, nr_pri;
>> +
>> +	/*
>> +	 * Make sure stores to the GIC via the memory mapped interface
>> +	 * are now visible to the system register interface.
>> +	 */
>> +	dsb(st);
>> +
>> +	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
>> +	cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
>> +	cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
>> +	cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
>> +
>> +	write_gicreg(0, ICH_HCR_EL2);
>> +	val = read_gicreg(ICH_VTR_EL2);
>> +	nr_lr = val & 0xf;
> 
> this is not technically nr_lr, it's max_lr or max_lr_idx or something
> like that.

Let's go for max_lr_idx  then.

>> +	nr_pri = ((u32)val >> 29) + 1;
> 
> nit: nr_pri_bits
> 
>> +
>> +	switch (nr_lr) {
>> +	case 15:
>> +		cpu_if->vgic_lr[LR_OFFSET(15)] = read_gicreg(ICH_LR15_EL2);
>> +	case 14:
>> +		cpu_if->vgic_lr[LR_OFFSET(14)] = read_gicreg(ICH_LR14_EL2);
>> +	case 13:
>> +		cpu_if->vgic_lr[LR_OFFSET(13)] = read_gicreg(ICH_LR13_EL2);
>> +	case 12:
>> +		cpu_if->vgic_lr[LR_OFFSET(12)] = read_gicreg(ICH_LR12_EL2);
>> +	case 11:
>> +		cpu_if->vgic_lr[LR_OFFSET(11)] = read_gicreg(ICH_LR11_EL2);
>> +	case 10:
>> +		cpu_if->vgic_lr[LR_OFFSET(10)] = read_gicreg(ICH_LR10_EL2);
>> +	case 9:
>> +		cpu_if->vgic_lr[LR_OFFSET(9)] = read_gicreg(ICH_LR9_EL2);
>> +	case 8:
>> +		cpu_if->vgic_lr[LR_OFFSET(8)] = read_gicreg(ICH_LR8_EL2);
>> +	case 7:
>> +		cpu_if->vgic_lr[LR_OFFSET(7)] = read_gicreg(ICH_LR7_EL2);
>> +	case 6:
>> +		cpu_if->vgic_lr[LR_OFFSET(6)] = read_gicreg(ICH_LR6_EL2);
>> +	case 5:
>> +		cpu_if->vgic_lr[LR_OFFSET(5)] = read_gicreg(ICH_LR5_EL2);
>> +	case 4:
>> +		cpu_if->vgic_lr[LR_OFFSET(4)] = read_gicreg(ICH_LR4_EL2);
>> +	case 3:
>> +		cpu_if->vgic_lr[LR_OFFSET(3)] = read_gicreg(ICH_LR3_EL2);
>> +	case 2:
>> +		cpu_if->vgic_lr[LR_OFFSET(2)] = read_gicreg(ICH_LR2_EL2);
>> +	case 1:
>> +		cpu_if->vgic_lr[LR_OFFSET(1)] = read_gicreg(ICH_LR1_EL2);
>> +	case 0:
>> +		cpu_if->vgic_lr[LR_OFFSET(0)] = read_gicreg(ICH_LR0_EL2);
> 
> I don't understand this; LR_OFFSET(0) == (15 - 0) == 15, so
> 
> cpu_if->vgic_lr[15] = read_gicreg(ICH_LR0_EL2) ?

Just like in the assembly version. We store the LRs in the order we read
them so that we don't confuse the CPU by writing backward (believe it or
not, CPUs do get horribly confused if you do that).

>> +	}
>> +
>> +	switch (nr_pri) {
>> +	case 7:
>> +		cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
>> +		cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
>> +	case 6:
>> +		cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
>> +	default:
>> +		cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
>> +	}
>> +
>> +	switch (nr_pri) {
>> +	case 7:
>> +		cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
>> +		cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
>> +	case 6:
>> +		cpu_if->vgic_ap1r[1] = read_gicreg(ICH_AP1R1_EL2);
>> +	default:
>> +		cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
>> +	}
>> +
>> +	write_gicreg(read_gicreg(ICC_SRE_EL2) | ICC_SRE_EL2_ENABLE,
>> +		     ICC_SRE_EL2);
> 
> nit: reading this out in a variable probably looks nicer.
> 
>> +	isb();
> 
> nit: should we comment on why the isb is required?
> 
>> +	write_gicreg(1, ICC_SRE_EL1);
>> +}
>> +
>> +void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
>> +	u64 val;
>> +	u32 nr_lr, nr_pri;
>> +
>> +	/* Make sure SRE is valid before writing the other registers */
> 
> I know that I've reviewed this code before (the asm version) but coming
> back to it I have no idea what the above really means...

The meaning of some of the bits in ICH_VMCR_EL2 are conditioned by the
configuration set in ICC_SRE_EL1. For example, VFIQEn is RES1 if
ICC_SRE_EL1.SRE is 1. This causes a Group0 interrupt (as generated in
GICv2 mode) to be delivered as a FIQ to the guest, with potentially
fatal consequences.

So we must make sure that ICC_SRE_EL1 has been actually programmed with
the value we want before starting to mess with the rest of the GIC.

>> +	write_gicreg(cpu_if->vgic_sre, ICC_SRE_EL1);
>> +	isb();
>> +
>> +	write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
>> +	write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
>> +
>> +	val = read_gicreg(ICH_VTR_EL2);
>> +	nr_lr = val & 0xf;
>> +	nr_pri = ((u32)val >> 29) + 1;
> 
> you could have a define for this shift now that you use it more than
> once.

Sure.

>> +
>> +	switch (nr_pri) {
>> +	case 7:
>> +		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
>> +		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
>> +	case 6:	 	                           
>> +		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
>> +	default: 	       		    
>> +		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
>> +	}	 	                           
>> +		 	                           
>> +	switch (nr_pri) {
>> +	case 7:	 	                           
>> +		 write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
>> +		 write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
>> +	case 6:	 	                           
>> +		 write_gicreg(cpu_if->vgic_ap0r[1], ICH_AP0R1_EL2);
>> +	default: 	       		    
>> +		 write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
>> +	}
>> +
>> +	switch (nr_lr) {
>> +	case 15:
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(15)], ICH_LR15_EL2);
>> +	case 14:	      			      
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(14)], ICH_LR14_EL2);
>> +	case 13:	      			      
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(13)], ICH_LR13_EL2);
>> +	case 12:	      			      
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(12)], ICH_LR12_EL2);
>> +	case 11:	      			      
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(11)], ICH_LR11_EL2);
>> +	case 10:	      			      
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(10)], ICH_LR10_EL2);
>> +	case 9:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(9)], ICH_LR9_EL2);
>> +	case 8:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(8)], ICH_LR8_EL2);
>> +	case 7:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(7)], ICH_LR7_EL2);
>> +	case 6:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(6)], ICH_LR6_EL2);
>> +	case 5:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(5)], ICH_LR5_EL2);
>> +	case 4:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(4)], ICH_LR4_EL2);
>> +	case 3:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(3)], ICH_LR3_EL2);
>> +	case 2:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(2)], ICH_LR2_EL2);
>> +	case 1:		                                    
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(1)], ICH_LR1_EL2);
>> +	case 0:
>> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(0)], ICH_LR0_EL2);
> 
> same question as above.
> 
>> +	}
> 
> loads of trailing whitespace all over above
> 
>> +
>> +	/*
>> +	 * Ensure that the above will have reached the
>> +	 * (re)distributors. This ensure the guest will read the
> 
> s/ensure/ensures/
> 
>> +	 * correct values from the memory-mapped interface.
>> +	 */
>> +	isb();
>> +	dsb(sy);
>> +
>> +	/*
>> +	 * Prevent the guest from touching the GIC system registers if
>> +	 * SRE isn't enabled for GICv3 emulation.
> 
> so can we emulate a GICv3 to the guest without system register access?
> I.e. an MMIO only GICv3 interface?

There is no such thing as a MMIO-based GICv3 CPU interface. The only
purpose of this is to ensure that a guest presented with a GICv2 doesn't
see the system registers as being available, because that both confusing
and borderline illegal.

>> +	 */
>> +	if (!cpu_if->vgic_sre) {
>> +		write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
>> +			     ICC_SRE_EL2);
>> +	}
>> +}
>> +
>> +u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
>> +{
>> +	return read_gicreg(ICH_VTR_EL2);
>> +}
>> -- 
>> 2.1.4
>>
> 
> As for translating the assembly code to C, this patch looks correct.
> 
> Nevertheless, I felt obliged to ask into the details above, now when
> you're touching all this code.

No problem. Thanks for reviewing it.

	M.
-- 
Jazz is not dead. It just smells funny...
