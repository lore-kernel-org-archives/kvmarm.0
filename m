From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 05/22] arm64: KVM: Implement vgic-v3 save/restore
Date: Fri, 11 Dec 2015 22:04:07 +0100
Message-ID: <20151211210407.GF27689@cbox>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
 <1449485618-9443-6-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449485618-9443-6-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 07, 2015 at 10:53:21AM +0000, Marc Zyngier wrote:
> Implement the vgic-v3 save restore as a direct translation of
> the assembly code version.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/hyp/Makefile     |   1 +
>  arch/arm64/kvm/hyp/hyp.h        |   3 +
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 226 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 230 insertions(+)
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
> index ac63553..5759f9f 100644
> --- a/arch/arm64/kvm/hyp/hyp.h
> +++ b/arch/arm64/kvm/hyp/hyp.h
> @@ -32,5 +32,8 @@
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
> index 0000000..78d05f3
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -0,0 +1,226 @@
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
> +#define vtr_to_max_lr_idx(v)		((v) & 0xf)
> +#define vtr_to_nr_pri_bits(v)		(((u32)(v) >> 29) + 1)
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
> +	u32 max_lr_idx, nr_pri_bits;
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
> +	max_lr_idx = vtr_to_max_lr_idx(val);
> +	nr_pri_bits = vtr_to_nr_pri_bits(val);
> +
> +	switch (max_lr_idx) {
> +	case 15:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(15)] = read_gicreg(ICH_LR15_EL2);
> +	case 14:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(14)] = read_gicreg(ICH_LR14_EL2);
> +	case 13:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(13)] = read_gicreg(ICH_LR13_EL2);
> +	case 12:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(12)] = read_gicreg(ICH_LR12_EL2);
> +	case 11:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(11)] = read_gicreg(ICH_LR11_EL2);
> +	case 10:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(10)] = read_gicreg(ICH_LR10_EL2);
> +	case 9:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(9)] = read_gicreg(ICH_LR9_EL2);
> +	case 8:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(8)] = read_gicreg(ICH_LR8_EL2);
> +	case 7:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(7)] = read_gicreg(ICH_LR7_EL2);
> +	case 6:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(6)] = read_gicreg(ICH_LR6_EL2);
> +	case 5:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(5)] = read_gicreg(ICH_LR5_EL2);
> +	case 4:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(4)] = read_gicreg(ICH_LR4_EL2);
> +	case 3:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(3)] = read_gicreg(ICH_LR3_EL2);
> +	case 2:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(2)] = read_gicreg(ICH_LR2_EL2);
> +	case 1:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(1)] = read_gicreg(ICH_LR1_EL2);
> +	case 0:
> +		cpu_if->vgic_lr[VGIC_V3_LR_INDEX(0)] = read_gicreg(ICH_LR0_EL2);
> +	}
> +
> +	switch (nr_pri_bits) {
> +	case 7:
> +		cpu_if->vgic_ap0r[3] = read_gicreg(ICH_AP0R3_EL2);
> +		cpu_if->vgic_ap0r[2] = read_gicreg(ICH_AP0R2_EL2);
> +	case 6:
> +		cpu_if->vgic_ap0r[1] = read_gicreg(ICH_AP0R1_EL2);
> +	default:
> +		cpu_if->vgic_ap0r[0] = read_gicreg(ICH_AP0R0_EL2);
> +	}
> +
> +	switch (nr_pri_bits) {
> +	case 7:
> +		cpu_if->vgic_ap1r[3] = read_gicreg(ICH_AP1R3_EL2);
> +		cpu_if->vgic_ap1r[2] = read_gicreg(ICH_AP1R2_EL2);
> +	case 6:
> +		cpu_if->vgic_ap1r[1] = read_gicreg(ICH_AP1R1_EL2);
> +	default:
> +		cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
> +	}
> +
> +	val = read_gicreg(ICC_SRE_EL2);
> +	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
> +	isb(); /* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
> +	write_gicreg(1, ICC_SRE_EL1);
> +}
> +
> +void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u64 val;
> +	u32 max_lr_idx, nr_pri_bits;
> +
> +	/*
> +	 * VFIQEn is RES1 if ICC_SRE_EL1.SRE is 1. This causes a
> +	 * Group0 interrupt (as generated in GICv2 mode) to be
> +	 * delivered as a FIQ to the guest, with potentially fatal
> +	 * consequences. So we must make sure that ICC_SRE_EL1 has
> +	 * been actually programmed with the value we want before
> +	 * starting to mess with the rest of the GIC.
> +	 */
> +	write_gicreg(cpu_if->vgic_sre, ICC_SRE_EL1);
> +	isb();
> +
> +	write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
> +	write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
> +
> +	val = read_gicreg(ICH_VTR_EL2);
> +	max_lr_idx = vtr_to_max_lr_idx(val);
> +	nr_pri_bits = vtr_to_nr_pri_bits(val);
> +
> +	switch (nr_pri_bits) {
> +	case 7:
> +		 write_gicreg(cpu_if->vgic_ap1r[3], ICH_AP1R3_EL2);
> +		 write_gicreg(cpu_if->vgic_ap1r[2], ICH_AP1R2_EL2);
> +	case 6:
> +		 write_gicreg(cpu_if->vgic_ap1r[1], ICH_AP1R1_EL2);
> +	default:
> +		 write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
> +	}	 	                           
> +		 	                           

white space issues

> +	switch (nr_pri_bits) {
> +	case 7:
> +		 write_gicreg(cpu_if->vgic_ap0r[3], ICH_AP0R3_EL2);
> +		 write_gicreg(cpu_if->vgic_ap0r[2], ICH_AP0R2_EL2);
> +	case 6:
> +		 write_gicreg(cpu_if->vgic_ap0r[1], ICH_AP0R1_EL2);
> +	default:
> +		 write_gicreg(cpu_if->vgic_ap0r[0], ICH_AP0R0_EL2);
> +	}
> +
> +	switch (max_lr_idx) {
> +	case 15:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(15)], ICH_LR15_EL2);
> +	case 14:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(14)], ICH_LR14_EL2);
> +	case 13:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(13)], ICH_LR13_EL2);
> +	case 12:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(12)], ICH_LR12_EL2);
> +	case 11:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(11)], ICH_LR11_EL2);
> +	case 10:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(10)], ICH_LR10_EL2);
> +	case 9:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(9)], ICH_LR9_EL2);
> +	case 8:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(8)], ICH_LR8_EL2);
> +	case 7:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(7)], ICH_LR7_EL2);
> +	case 6:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(6)], ICH_LR6_EL2);
> +	case 5:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(5)], ICH_LR5_EL2);
> +	case 4:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(4)], ICH_LR4_EL2);
> +	case 3:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(3)], ICH_LR3_EL2);
> +	case 2:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(2)], ICH_LR2_EL2);
> +	case 1:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(1)], ICH_LR1_EL2);
> +	case 0:
> +		write_gicreg(cpu_if->vgic_lr[VGIC_V3_LR_INDEX(0)], ICH_LR0_EL2);
> +	}
> +
> +	/*
> +	 * Ensures that the above will have reached the
> +	 * (re)distributors. This ensure the guest will read the

You fixed the wrong instance of 'ensure' ;)

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

Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
