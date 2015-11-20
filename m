From: Steve Capper <steve.capper@linaro.org>
Subject: Re: [PATCH 04/21] arm64: KVM: Implement vgic-v3 save/restore
Date: Fri, 20 Nov 2015 16:48:53 +0000
Message-ID: <20151120164851.GB24960@linaro.org>
References: <1447679519-17888-1-git-send-email-marc.zyngier@arm.com>
 <1447679519-17888-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F7D949998
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 11:48:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id weROoyQy6bpQ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Nov 2015 11:48:13 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC4B8498D9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 11:48:12 -0500 (EST)
Received: by wmvv187 with SMTP id v187so80335072wmv.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Nov 2015 08:48:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1447679519-17888-5-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Mark Rutland <marc.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 16, 2015 at 01:11:42PM +0000, Marc Zyngier wrote:
> Implement the vgic-v3 save restore as a direct translation of
> the assembly code version.

I think there's a couple of typos below Marc.

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/Makefile     |   1 +
>  arch/arm64/kvm/hyp/hyp.h        |   3 +
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 222 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 226 insertions(+)
>  create mode 100644 arch/arm64/kvm/hyp/vgic-v3-sr.c
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index d8d5968..d1e38ce 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -3,3 +3,4 @@
>  #
>  
>  obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
> +obj-$(CONFIG_KVM_ARM_HOST) += vgic-v3-sr.o
> diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> index 78f25c4..a31cb6e 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -30,5 +30,8 @@
>  void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
>  void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
>  
> +void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
> +void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
> +
>  #endif /* __ARM64_KVM_HYP_H__ */
>  
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> new file mode 100644
> index 0000000..f2289ab
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -0,0 +1,222 @@
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
> +#include <linux/compiler.h>
> +#include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/kvm_mmu.h>
> +
> +#include "hyp.h"
> +
> +/*
> + * We store LRs in reverse order to let the CPU deal with streaming
> + * access. Use this macro to make it look saner...
> + */
> +#define LR_OFFSET(n)	(15 - n)
> +
> +#define read_gicreg(r)							\
> +	({								\
> +		u64 reg;						\
> +		asm volatile("mrs_s %0, " __stringify(r) : "=r" (reg));	\
> +		reg;							\
> +	})
> +
> +#define write_gicreg(v,r)						\
> +	do {								\
> +		u64 __val = (v);					\
> +		asm volatile("msr_s " __stringify(r) ", %0" : : "r" (__val));\
> +	} while (0)
> +
> +/* vcpu is already in the HYP VA space */
> +void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u64 val;
> +	u32 nr_lr, nr_pri;
> +
> +	/*
> +	 * Make sure stores to the GIC via the memory mapped interface
> +	 * are now visible to the system register interface.
> +	 */
> +	dsb(st);
> +
> +	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
> +	cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
> +	cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
> +	cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
> +
> +	write_gicreg(0, ICH_HCR_EL2);
> +	val = read_gicreg(ICH_VTR_EL2);
> +	nr_lr = val & 0xf;
> +	nr_pri = ((u32)val >> 29) + 1;
> +
> +	switch (nr_lr) {
> +	case 15:
> +		cpu_if->vgic_lr[LR_OFFSET(15)] = read_gicreg(ICH_LR15_EL2);
> +	case 14:
> +		cpu_if->vgic_lr[LR_OFFSET(14)] = read_gicreg(ICH_LR14_EL2);
> +	case 13:
> +		cpu_if->vgic_lr[LR_OFFSET(13)] = read_gicreg(ICH_LR13_EL2);
> +	case 12:
> +		cpu_if->vgic_lr[LR_OFFSET(12)] = read_gicreg(ICH_LR12_EL2);
> +	case 11:
> +		cpu_if->vgic_lr[LR_OFFSET(11)] = read_gicreg(ICH_LR11_EL2);
> +	case 10:
> +		cpu_if->vgic_lr[LR_OFFSET(19)] = read_gicreg(ICH_LR10_EL2);

LR_OFFSET(10) ?

> +	case 9:
> +		cpu_if->vgic_lr[LR_OFFSET(9)] = read_gicreg(ICH_LR9_EL2);
> +	case 8:
> +		cpu_if->vgic_lr[LR_OFFSET(8)] = read_gicreg(ICH_LR8_EL2);
> +	case 7:
> +		cpu_if->vgic_lr[LR_OFFSET(7)] = read_gicreg(ICH_LR7_EL2);
> +	case 6:
> +		cpu_if->vgic_lr[LR_OFFSET(6)] = read_gicreg(ICH_LR6_EL2);
> +	case 5:
> +		cpu_if->vgic_lr[LR_OFFSET(5)] = read_gicreg(ICH_LR5_EL2);
> +	case 4:
> +		cpu_if->vgic_lr[LR_OFFSET(4)] = read_gicreg(ICH_LR4_EL2);
> +	case 3:
> +		cpu_if->vgic_lr[LR_OFFSET(3)] = read_gicreg(ICH_LR3_EL2);
> +	case 2:
> +		cpu_if->vgic_lr[LR_OFFSET(2)] = read_gicreg(ICH_LR2_EL2);
> +	case 1:
> +		cpu_if->vgic_lr[LR_OFFSET(1)] = read_gicreg(ICH_LR1_EL2);
> +	case 0:
> +		cpu_if->vgic_lr[LR_OFFSET(0)] = read_gicreg(ICH_LR0_EL2);
> +	}
> +
> +	switch (nr_pri) {
> +	case 7:
> +		cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
> +		cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
> +	case 6:
> +		cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
> +	default:
> +		cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
> +	}
> +
> +	switch (nr_pri) {
> +	case 7:
> +		cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
> +		cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
> +	case 6:
> +		cpu_if->vgic_ap1r[1] = read_gicreg(ICH_AP1R1_EL2);
> +	default:
> +		cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
> +	}
> +
> +	write_gicreg(read_gicreg(ICC_SRE_EL2) | ICC_SRE_EL2_ENABLE,
> +		     ICC_SRE_EL2);
> +	isb();
> +	write_gicreg(1, ICC_SRE_EL1);
> +}
> +
> +void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u64 val;
> +	u32 nr_lr, nr_pri;
> +
> +	/* Make sure SRE is valid before writing the other registers */
> +	write_gicreg(cpu_if->vgic_sre, ICC_SRE_EL1);
> +	isb();
> +
> +	write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
> +	write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
> +
> +	val = read_gicreg(ICH_VTR_EL2);
> +	nr_lr = val & 0xf;
> +	nr_pri = ((u32)val >> 29) + 1;
> +
> +	switch (nr_pri) {
> +	case 7:
> +		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
> +		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
> +	case 6:	 	                           
> +		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
> +	default: 	       		    
> +		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
> +	}	 	                           
> +		 	                           
> +	switch (nr_pri) {
> +	case 7:	 	                           
> +		 write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
> +		 write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
> +	case 6:	 	                           
> +		 write_gicreg(cpu_if->vgic_ap0r[1], ICH_AP0R1_EL2);
> +	default: 	       		    
> +		 write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
> +	}
> +
> +	switch (nr_lr) {
> +	case 15:
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(15)], ICH_LR15_EL2);
> +	case 14:	      			      
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(14)], ICH_LR14_EL2);
> +	case 13:	      			      
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(13)], ICH_LR13_EL2);
> +	case 12:	      			      
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(12)], ICH_LR12_EL2);
> +	case 11:	      			      
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(11)], ICH_LR11_EL2);
> +	case 10:	      			      
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(19)], ICH_LR10_EL2);

LR_OFFSET(10) here again?

> +	case 9:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(9)], ICH_LR9_EL2);
> +	case 8:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(8)], ICH_LR8_EL2);
> +	case 7:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(7)], ICH_LR7_EL2);
> +	case 6:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(6)], ICH_LR6_EL2);
> +	case 5:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(5)], ICH_LR5_EL2);
> +	case 4:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(4)], ICH_LR4_EL2);
> +	case 3:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(3)], ICH_LR3_EL2);
> +	case 2:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(2)], ICH_LR2_EL2);
> +	case 1:		                                    
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(1)], ICH_LR1_EL2);
> +	case 0:
> +		write_gicreg(cpu_if->vgic_lr[LR_OFFSET(0)], ICH_LR0_EL2);
> +	}
> +
> +	/*
> +	 * Ensure that the above will have reached the
> +	 * (re)distributors. This ensure the guest will read the
> +	 * correct values from the memory-mapped interface.
> +	 */
> +	isb();
> +	dsb(sy);
> +
> +	/*
> +	 * Prevent the guest from touching the GIC system registers if
> +	 * SRE isn't enabled for GICv3 emulation.
> +	 */
> +	if (!cpu_if->vgic_sre) {
> +		write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
> +			     ICC_SRE_EL2);
> +	}
> +}
> +
> +u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
> +{
> +	return read_gicreg(ICH_VTR_EL2);
> +}
> -- 
> 2.1.4
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
