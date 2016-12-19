From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v10 6/8] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Mon, 19 Dec 2016 18:05:33 +0100
Message-ID: <182d7293-f0f1-e043-4c70-a3d70a41a5a4@redhat.com>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-7-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F02B40430
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 12:04:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PmhkO0L-Sgub for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2016 12:04:25 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 193F3401C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2016 12:04:24 -0500 (EST)
In-Reply-To: <1480576187-5012-7-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vijaya, Christoffer,

On 01/12/2016 08:09, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> VGICv3 CPU interface registers are accessed using
> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> as 64-bit. The cpu MPIDR value is passed along with register id.
> is used to identify the cpu for registers access.
> 
> The VM that supports SEIs expect it on destination machine to handle
> guest aborts and hence checked for ICC_CTLR_EL1.SEIS compatibility.
> Similarly, VM that supports Affinity Level 3 that is required for AArch64
> mode, is required to be supported on destination machine. Hence checked
> for ICC_CTLR_EL1.A3V compatibility.
> 
> The arch/arm64/kvm/vgic-sys-reg-v3.c handles read and write of VGIC
> CPU registers for AArch64.
> 
> For AArch32 mode, arch/arm/kvm/vgic-v3-coproc.c file is created but
> APIs are not implemented.
> 
> Updated arch/arm/include/uapi/asm/kvm.h with new definitions
> required to compile for AArch32.
> 
> The version of VGIC v3 specification is define here
> Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm/include/uapi/asm/kvm.h     |   2 +
>  arch/arm/kvm/Makefile               |   4 +-
>  arch/arm/kvm/vgic-v3-coproc.c       |  35 ++++
>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>  arch/arm64/kvm/Makefile             |   3 +-
>  arch/arm64/kvm/vgic-sys-reg-v3.c    | 338 ++++++++++++++++++++++++++++++++++++
>  include/kvm/arm_vgic.h              |   9 +
>  virt/kvm/arm/vgic/vgic-kvm-device.c |  28 +++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  18 ++
>  virt/kvm/arm/vgic/vgic-v3.c         |   8 +
>  virt/kvm/arm/vgic/vgic.h            |   4 +
>  11 files changed, 449 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 0ae6035..98658d9d 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -186,9 +186,11 @@ struct kvm_arch_memory_slot {
>  			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
nit: arm-vgic-v3.txt spec uses that name. To be homogeneous with other
groups, shouldn't we correct this into KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS?

Thanks

Eric
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
>  
>  /* KVM_IRQ_LINE irq field index values */
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index d571243..68fb023 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -7,7 +7,7 @@ ifeq ($(plus_virt),+virt)
>  	plus_virt_def := -DREQUIRES_VIRT=1
>  endif
>  
> -ccflags-y += -Iarch/arm/kvm
> +ccflags-y += -Iarch/arm/kvm -Ivirt/kvm/arm/vgic
>  CFLAGS_arm.o := -I. $(plus_virt_def)
>  CFLAGS_mmu.o := -I.
>  
> @@ -20,7 +20,7 @@ kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vf
>  obj-$(CONFIG_KVM_ARM_HOST) += hyp/
>  obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
> -obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
> +obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o vgic-v3-coproc.o
>  obj-y += $(KVM)/arm/aarch32.o
>  
>  obj-y += $(KVM)/arm/vgic/vgic.o
> diff --git a/arch/arm/kvm/vgic-v3-coproc.c b/arch/arm/kvm/vgic-v3-coproc.c
> new file mode 100644
> index 0000000..f41abf7
> --- /dev/null
> +++ b/arch/arm/kvm/vgic-v3-coproc.c
> @@ -0,0 +1,35 @@
> +/*
> + * VGIC system registers handling functions for AArch32 mode
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_emulate.h>
> +#include "vgic.h"
> +
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				 u64 *reg)
> +{
> +	/*
> +	 * TODO: Implement for AArch32
> +	 */
> +	return -ENXIO;
> +}
> +
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg)
> +{
> +	/*
> +	 * TODO: Implement for AArch32
> +	 */
> +	return -ENXIO;
> +}
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 56dc08d..91c7137 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -206,9 +206,12 @@ struct kvm_arch_memory_slot {
>  			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
>  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
>  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> +
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
>  
>  /* Device Control API on vcpu fd */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index d50a82a..d89aa50 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -2,7 +2,7 @@
>  # Makefile for Kernel-based Virtual Machine module
>  #
>  
> -ccflags-y += -Iarch/arm64/kvm
> +ccflags-y += -Iarch/arm64/kvm -Ivirt/kvm/arm/vgic
>  CFLAGS_arm.o := -I.
>  CFLAGS_mmu.o := -I.
>  
> @@ -19,6 +19,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += vgic-sys-reg-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
>  
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
> diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> new file mode 100644
> index 0000000..76663f9
> --- /dev/null
> +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> @@ -0,0 +1,338 @@
> +/*
> + * VGIC system registers handling functions for AArch64 mode
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_emulate.h>
> +#include "vgic.h"
> +#include "sys_regs.h"
> +
> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	u32 host_pri_bits, host_id_bits, host_seis, host_a3v, seis, a3v;
> +	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_vmcr vmcr;
> +	u64 val;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		val = p->regval;
> +
> +		/*
> +		 * Disallow restoring VM state if not supported by this
> +		 * hardware.
> +		 */
> +		host_pri_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
> +				 ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
> +		if (host_pri_bits > vgic_v3_cpu->num_pri_bits)
> +			return false;
> +
> +		vgic_v3_cpu->num_pri_bits = host_pri_bits;
> +
> +		host_id_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
> +				ICC_CTLR_EL1_ID_BITS_SHIFT;
> +		if (host_id_bits > vgic_v3_cpu->num_id_bits)
> +			return false;
> +
> +		vgic_v3_cpu->num_id_bits = host_id_bits;
> +
> +		host_seis = ((kvm_vgic_global_state.ich_vtr_el2 &
> +			     ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);
> +		seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
> +			ICC_CTLR_EL1_SEIS_SHIFT;
> +		if (host_seis != seis)
> +			return false;
> +
> +		host_a3v = ((kvm_vgic_global_state.ich_vtr_el2 &
> +			    ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
> +		a3v = (val & ICC_CTLR_EL1_A3V_MASK) >> ICC_CTLR_EL1_A3V_SHIFT;
> +		if (host_a3v != a3v)
> +			return false;
> +
> +		vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
> +		vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		val = 0;
> +		val |= (vgic_v3_cpu->num_pri_bits - 1) <<
> +			ICC_CTLR_EL1_PRI_BITS_SHIFT;
> +		val |= vgic_v3_cpu->num_id_bits << ICC_CTLR_EL1_ID_BITS_SHIFT;
> +		val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> +			ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
> +			ICC_CTLR_EL1_SEIS_SHIFT;
> +		val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> +			ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
> +			ICC_CTLR_EL1_A3V_SHIFT;
> +		val |= vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK;
> +		val |= vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK;
> +
> +		p->regval = val;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		vmcr.pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_bpr0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		vmcr.bpr = (p->regval & ICC_BPR0_EL1_MASK) >>
> +			    ICC_BPR0_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) &
> +			     ICC_BPR0_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	if (!p->is_write)
> +		p->regval = 0;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (!((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT)) {
> +		if (p->is_write) {
> +			vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
> +				     ICC_BPR1_EL1_SHIFT;
> +			vgic_set_vmcr(vcpu, &vmcr);
> +		} else {
> +			p->regval = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
> +				     ICC_BPR1_EL1_MASK;
> +		}
> +	} else {
> +		if (!p->is_write)
> +			p->regval = min((vmcr.bpr + 1), 7U);
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		vmcr.grpen0 = (p->regval & ICC_IGRPEN0_EL1_MASK) >>
> +			       ICC_IGRPEN0_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) &
> +			     ICC_IGRPEN0_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		vmcr.grpen1 = (p->regval & ICC_IGRPEN1_EL1_MASK) >>
> +			       ICC_IGRPEN1_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
> +			     ICC_IGRPEN1_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu,
> +				   struct sys_reg_params *p, u8 apr, u8 idx)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +	uint32_t *ap_reg;
> +
> +	if (apr)
> +		ap_reg = &vgicv3->vgic_ap1r[idx];
> +	else
> +		ap_reg = &vgicv3->vgic_ap0r[idx];
> +
> +	if (p->is_write)
> +		*ap_reg = p->regval;
> +	else
> +		p->regval = *ap_reg;
> +}
> +
> +static bool access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r, u8 apr)
> +{
> +	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> +	u8 idx = r->Op2 & 3;
> +
> +	/*
> +	 * num_pri_bits are initialized with HW supported values.
> +	 * We can rely safely on num_pri_bits even if VM has not
> +	 * restored ICC_CTLR_EL1 before restoring APnR registers.
> +	 */
> +	switch (vgic_v3_cpu->num_pri_bits) {
> +	case 7:
> +		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> +		break;
> +	case 6:
> +		if (idx > 1)
> +			goto err;
> +		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> +		break;
> +	default:
> +		if (idx > 0)
> +			goto err;
> +		vgic_v3_access_apr_reg(vcpu, p, apr, idx);
> +	}
> +
> +	return true;
> +err:
> +	if (!p->is_write)
> +		p->regval = 0;
> +
> +	return false;
> +}
> +
> +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +
> +{
> +	return access_gic_aprn(vcpu, p, r, 0);
> +}
> +
> +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	return access_gic_aprn(vcpu, p, r, 1);
> +}
> +
> +static bool access_gic_sre(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	/* Validate SRE bit */
> +	if (p->is_write) {
> +		if (!(p->regval & ICC_SRE_EL1_SRE))
> +			return false;
> +	} else {
> +		p->regval = vgicv3->vgic_sre;
> +	}
> +
> +	return true;
> +}
> +static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
> +	/* ICC_PMR_EL1 */
> +	{ Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
> +	/* ICC_BPR0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
> +	/* ICC_AP0R0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
> +	/* ICC_AP0R1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
> +	/* ICC_AP0R2_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
> +	/* ICC_AP0R3_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
> +	/* ICC_AP1R0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
> +	/* ICC_AP1R1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
> +	/* ICC_AP1R2_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
> +	/* ICC_AP1R3_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
> +	/* ICC_BPR1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
> +	/* ICC_CTLR_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
> +	/* ICC_SRE_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(5), access_gic_sre },
> +	/* ICC_IGRPEN0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
> +	/* ICC_GRPEN1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
> +};
> +
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg)
> +{
> +	struct sys_reg_params params;
> +	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> +
> +	params.regval = *reg;
> +	params.is_write = is_write;
> +	params.is_aarch32 = false;
> +	params.is_32bit = false;
> +
> +	if (find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> +			      ARRAY_SIZE(gic_v3_icc_reg_descs)))
> +		return 0;
> +
> +	return -ENXIO;
> +}
> +
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg)
> +{
> +	struct sys_reg_params params;
> +	const struct sys_reg_desc *r;
> +	u64 sysreg = (id & KVM_DEV_ARM_VGIC_SYSREG_MASK) | KVM_REG_SIZE_U64;
> +
> +	if (is_write)
> +		params.regval = *reg;
> +	params.is_write = is_write;
> +	params.is_aarch32 = false;
> +	params.is_32bit = false;
> +
> +	r = find_reg_by_id(sysreg, &params, gic_v3_icc_reg_descs,
> +			   ARRAY_SIZE(gic_v3_icc_reg_descs));
> +	if (!r)
> +		return -ENXIO;
> +
> +	if (!r->access(vcpu, &params, r))
> +		return -EINVAL;
> +
> +	if (!is_write)
> +		*reg = params.regval;
> +
> +	return 0;
> +}
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 002f092..730a18a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -71,6 +71,9 @@ struct vgic_global {
>  
>  	/* GIC system register CPU interface */
>  	struct static_key_false gicv3_cpuif;
> +
> +	/* Cache ICH_VTR_EL2 reg value */
> +	u32			ich_vtr_el2;
>  };
>  
>  extern struct vgic_global kvm_vgic_global_state;
> @@ -269,6 +272,12 @@ struct vgic_cpu {
>  	u64 pendbaser;
>  
>  	bool lpis_enabled;
> +
> +	/* Cache guest priority bits */
> +	u32 num_pri_bits;
> +
> +	/* Cache guest interrupt ID bits */
> +	u32 num_id_bits;
>  };
>  
>  extern struct static_key_false vgic_v2_cpuif_trap;
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index bc7de95..b6266fe 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -16,6 +16,7 @@
>  #include <linux/kvm_host.h>
>  #include <kvm/arm_vgic.h>
>  #include <linux/uaccess.h>
> +#include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
>  #include "vgic.h"
>  
> @@ -501,6 +502,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  		if (!is_write)
>  			*reg = tmp32;
>  		break;
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 regid;
> +
> +		regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> +		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
> +						  regid, reg);
> +		break;
> +	}
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -534,6 +543,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  		reg = tmp32;
>  		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
>  	}
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		u64 reg;
> +
> +		if (get_user(reg, uaddr))
> +			return -EFAULT;
> +
> +		return vgic_v3_attr_regs_access(dev, attr, &reg, true);
> +	}
>  	}
>  	return -ENXIO;
>  }
> @@ -560,6 +578,15 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>  		tmp32 = reg;
>  		return put_user(tmp32, uaddr);
>  	}
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		u64 reg;
> +
> +		ret = vgic_v3_attr_regs_access(dev, attr, &reg, false);
> +		if (ret)
> +			return ret;
> +		return put_user(reg, uaddr);
> +	}
>  	}
>  
>  	return -ENXIO;
> @@ -578,6 +605,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		break;
>  	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
>  		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index e4799ae..51439c9 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -642,6 +642,24 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  		nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
>  		break;
>  	}
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 reg, id;
> +		unsigned long vgic_mpidr, mpidr_reg;
> +		struct kvm_vcpu *vcpu;
> +
> +		vgic_mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
> +			      KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
> +
> +		/* Convert plain mpidr value to MPIDR reg format */
> +		mpidr_reg = VGIC_TO_MPIDR(vgic_mpidr);
> +
> +		vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr_reg);
> +		if (!vcpu)
> +			return -EINVAL;
> +
> +		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> +		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
> +	}
>  	default:
>  		return -ENXIO;
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index c21968b..c98a1c5 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -238,6 +238,13 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  		vgic_v3->vgic_sre = 0;
>  	}
>  
> +	vcpu->arch.vgic_cpu.num_id_bits = (kvm_vgic_global_state.ich_vtr_el2 &
> +					   ICH_VTR_ID_BITS_MASK) >>
> +					   ICH_VTR_ID_BITS_SHIFT;
> +	vcpu->arch.vgic_cpu.num_pri_bits = ((kvm_vgic_global_state.ich_vtr_el2 &
> +					    ICH_VTR_PRI_BITS_MASK) >>
> +					    ICH_VTR_PRI_BITS_SHIFT) + 1;
> +
>  	/* Get the show on the road... */
>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
>  }
> @@ -338,6 +345,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	 */
>  	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
> +	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
>  
>  	if (!info->vcpu.start) {
>  		kvm_info("GICv3: no GICV resource entry\n");
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 9232791..eac272c 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -140,6 +140,10 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
>  int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 u64 id, u64 *val);
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg);
>  int kvm_register_vgic_device(unsigned long type);
>  void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> 
