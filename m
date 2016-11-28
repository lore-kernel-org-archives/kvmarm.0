From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v9 06/11] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Mon, 28 Nov 2016 20:39:38 +0100
Message-ID: <20161128193938.GF18170@cbox>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-7-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AADB40666
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 14:38:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w2pOczWyJ1rv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Nov 2016 14:38:56 -0500 (EST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0119140665
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 14:38:55 -0500 (EST)
Received: by mail-lf0-f51.google.com with SMTP id t196so104824925lff.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Nov 2016 11:39:43 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1479906118-15832-7-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 23, 2016 at 06:31:53PM +0530, vijay.kilari@gmail.com wrote:
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
> The CPU system register handling is spitted into two files

spitted?  Did you mean 'split into' ?

> vgic-sys-reg-common.c and vgic-sys-reg-v3.c.
> The vgic-sys-reg-common.c handles read and write of VGIC CPU registers

So this is weird because everything in virt/kvm/arm/ is exactly supposed
to be common between arm and arm64 already.

I would rather that you had a copy of vgic-sys-reg-v3.c in arch/arm/kvm/
and in arch/arm64/kvm/ each taking care of its own architecture.

But note that I didn't actually require that you implemented support for
GICv3 migration on AArch32 hosts for these patches, I just didn't want
thigns to silently break.

If we cannot test the AArch32 implementation, we should potentially just
make sure that is not supported yet, return a proper error to userspace
and get the AArch64 host implementation correct.

I suggest you move your:
  virt/kvm/arm/vgic/vgic-sys-reg-v3.c to
  arch/arm64/kvm/vgic-sys-reg-v3.c
  
and rename
  virt/kvm/arm/vgic/vgic-sys-reg-common.c to
  virt/kvm/arm/vgic/vgic-sys-reg-v3.c

And then wait with the AArch32 host side for now, but just make sure it
compiles and returns an error as opposed to crashing the system if
someone tries to excercise this interface on an AArch32 host.

> for both AArch64 and AArch32 mode. The vgic-sys-reg-v3.c handles AArch64
> mode and is compiled only for AArch64 mode.
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
>  arch/arm/include/uapi/asm/kvm.h         |   2 +
>  arch/arm64/include/uapi/asm/kvm.h       |   3 +
>  arch/arm64/kvm/Makefile                 |   2 +
>  include/kvm/arm_vgic.h                  |   9 ++
>  virt/kvm/arm/vgic/vgic-kvm-device.c     |  28 ++++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c        |  18 +++
>  virt/kvm/arm/vgic/vgic-sys-reg-common.c | 258 ++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c     | 142 ++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c             |   8 +
>  virt/kvm/arm/vgic/vgic.h                |  22 +++
>  10 files changed, 492 insertions(+)
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
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT    0
>  
>  /* KVM_IRQ_LINE irq field index values */
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
> index d50a82a..5c8580e 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -32,5 +32,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-common.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
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
> index 2a7cd62..2f7b4ed 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -641,6 +641,24 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
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
> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-common.c b/virt/kvm/arm/vgic/vgic-sys-reg-common.c
> new file mode 100644
> index 0000000..a1fc370c
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-common.c
> @@ -0,0 +1,258 @@
> +/*
> + * VGIC system registers handling functions
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
> +
> +bool access_gic_ctlr_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 unsigned long *reg)
> +{
> +	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_vmcr vmcr;
> +	u64 val;
> +	u32 valid_bits, seis, a3v;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (is_write) {
> +		val = *reg;
> +
> +		/*
> +		 * Disallow restoring VM state if not supported by this
> +		 * hardware.
> +		 */
> +		valid_bits = ((val & ICC_CTLR_EL1_PRI_BITS_MASK) >>
> +				ICC_CTLR_EL1_PRI_BITS_SHIFT) + 1;
> +		if (valid_bits > vgic_v3_cpu->num_pri_bits)
> +			return false;
> +
> +		vgic_v3_cpu->num_pri_bits = valid_bits;
> +
> +		valid_bits = (val & ICC_CTLR_EL1_ID_BITS_MASK) >>
> +			       ICC_CTLR_EL1_ID_BITS_SHIFT;
> +		if (valid_bits > vgic_v3_cpu->num_id_bits)
> +			return false;
> +
> +		vgic_v3_cpu->num_id_bits = valid_bits;

nit: could you just define the variables your need instead of reusing
this valid_bits thing, that would make the code a lot more readable.


> +
> +		valid_bits = ((kvm_vgic_global_state.ich_vtr_el2 &
> +			ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT);

it's especially confusing that you now use valid_bits for the host's
values...

> +		seis = (val & ICC_CTLR_EL1_SEIS_MASK) >>
> +			ICC_CTLR_EL1_SEIS_SHIFT;
> +		if (valid_bits != seis)
> +			return false;



> +
> +		valid_bits = ((kvm_vgic_global_state.ich_vtr_el2 &
> +			ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT);
> +		a3v = (val & ICC_CTLR_EL1_A3V_MASK) >>
> +			ICC_CTLR_EL1_A3V_SHIFT;
> +		if (valid_bits != a3v)
> +			return false;
> +
> +		vmcr.ctlr = (val & ICC_CTLR_EL1_CBPR_MASK);
> +		vmcr.ctlr |= (val & ICC_CTLR_EL1_EOImode_MASK);
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		val = 0;
> +		val |= (vgic_v3_cpu->num_pri_bits - 1) <<
> +			ICC_CTLR_EL1_PRI_BITS_SHIFT;
> +		val |= vgic_v3_cpu->num_id_bits <<
> +			ICC_CTLR_EL1_ID_BITS_SHIFT;
> +		val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> +			ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT) <<
> +			ICC_CTLR_EL1_SEIS_SHIFT;
> +		val |= ((kvm_vgic_global_state.ich_vtr_el2 &
> +			ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT) <<
> +			ICC_CTLR_EL1_A3V_SHIFT;
> +		val |= (vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK);
> +		val |= (vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK);
> +
> +		*reg = val;
> +	}
> +
> +	return true;
> +}
> +
> +bool access_gic_pmr_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			unsigned long *reg)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (is_write) {
> +		vmcr.pmr = (*reg & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		*reg = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +bool access_gic_bpr0_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 unsigned long *reg)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (is_write) {
> +		vmcr.bpr = (*reg & ICC_BPR0_EL1_MASK) >>
> +			    ICC_BPR0_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		*reg = (vmcr.bpr << ICC_BPR0_EL1_SHIFT) & ICC_BPR0_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +bool access_gic_bpr1_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 unsigned long *reg)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	if (!is_write)
> +		*reg = 0;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (!((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT)) {
> +		if (is_write) {
> +			vmcr.abpr = (*reg & ICC_BPR1_EL1_MASK) >>
> +				     ICC_BPR1_EL1_SHIFT;
> +			vgic_set_vmcr(vcpu, &vmcr);
> +		} else {
> +			*reg = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
> +				ICC_BPR1_EL1_MASK;
> +		}
> +	} else {
> +		if (!is_write)
> +			*reg = min((vmcr.bpr + 1), 7U);
> +	}
> +
> +	return true;
> +}
> +
> +bool access_gic_grpen0_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			   unsigned long *reg)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (is_write) {
> +		vmcr.grpen0 = (*reg & ICC_IGRPEN0_EL1_MASK) >>
> +			       ICC_IGRPEN0_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		*reg = (vmcr.grpen0 << ICC_IGRPEN0_EL1_SHIFT) &
> +			ICC_IGRPEN0_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +bool access_gic_grpen1_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			   unsigned long *reg)
> +{
> +	struct vgic_vmcr vmcr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (is_write) {
> +		vmcr.grpen1 = (*reg & ICC_IGRPEN1_EL1_MASK) >>
> +			       ICC_IGRPEN1_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		*reg = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
> +			ICC_IGRPEN1_EL1_MASK;
> +	}
> +
> +	return true;
> +}
> +
> +static void vgic_v3_access_apr_reg(struct kvm_vcpu *vcpu, bool is_write,
> +				   u8 apr, u8 idx, unsigned long *reg)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +	uint32_t *ap_reg;
> +
> +	if (apr)
> +		ap_reg = &vgicv3->vgic_ap1r[idx];
> +	else
> +		ap_reg = &vgicv3->vgic_ap0r[idx];
> +
> +	if (is_write)
> +		*ap_reg = *reg;
> +	else
> +		*reg = *ap_reg;
> +}
> +
> +static bool access_gic_aprn(struct kvm_vcpu *vcpu, bool is_write, u8 apr,
> +			    u8 idx, unsigned long *reg)
> +{
> +	struct vgic_cpu *vgic_v3_cpu = &vcpu->arch.vgic_cpu;
> +
> +	/* num_pri_bits are initialized with HW supported values.
> +	 * We can rely safely on num_pri_bits even if VM has not
> +	 * restored ICC_CTLR_EL1 before restoring APnR registers.
> +	 */

nit: commenting style

> +	switch (vgic_v3_cpu->num_pri_bits) {
> +	case 7:
> +		vgic_v3_access_apr_reg(vcpu, is_write, apr, idx, reg);
> +		break;
> +	case 6:
> +		if (idx > 1)
> +			goto err;
> +		vgic_v3_access_apr_reg(vcpu, is_write, apr, idx, reg);
> +		break;
> +	default:
> +		if (idx > 0)
> +			goto err;
> +		vgic_v3_access_apr_reg(vcpu, is_write, apr, idx, reg);
> +	}

It looks to me like userspace can then program active priorities with
higher numbers than what it will program num_pri_bits to later.  Is that
not weird, or am I missing something?

> +
> +	return true;
> +err:
> +	if (!is_write)
> +		*reg = 0;
> +
> +	return false;
> +}
> +
> +bool access_gic_ap0r_reg(struct kvm_vcpu *vcpu, bool is_write, u8 idx,
> +			 unsigned long *reg)
> +{
> +	return access_gic_aprn(vcpu, is_write, 0, idx, reg);
> +}
> +
> +bool access_gic_ap1r_reg(struct kvm_vcpu *vcpu, bool is_write, u8 idx,
> +			 unsigned long *reg)
> +{
> +	return access_gic_aprn(vcpu, is_write, 1, idx, reg);
> +}
> +
> +bool access_gic_sre_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			unsigned long *reg)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	/* Validate SRE bit */
> +	if (is_write) {
> +		if (!(*reg & ICC_SRE_EL1_SRE))
> +			return false;
> +	} else {
> +		*reg = vgicv3->vgic_sre;
> +	}
> +
> +	return true;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> new file mode 100644
> index 0000000..82c2f02
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> @@ -0,0 +1,142 @@
> +/*
> + * VGIC system registers handling functions
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
> +#include "sys_regs.h"
> +
> +#define ACCESS_SYS_REG(REG)						\
> +static bool access_gic_##REG##_sys_reg(struct kvm_vcpu *vcpu,		\
> +				    struct sys_reg_params *p,		\
> +				    const struct sys_reg_desc *r)	\
> +{									\
> +	unsigned long tmp;						\
> +	bool ret;							\
> +									\
> +	if (p->is_write)						\
> +		tmp = p->regval;					\
> +	ret = access_gic_##REG##_reg(vcpu, p->is_write, &tmp);		\
> +	if (!p->is_write)						\
> +		p->regval = tmp;					\
> +									\
> +	return ret;							\
> +}
> +
> +ACCESS_SYS_REG(ctlr)
> +ACCESS_SYS_REG(pmr)
> +ACCESS_SYS_REG(bpr0)
> +ACCESS_SYS_REG(bpr1)
> +ACCESS_SYS_REG(sre)
> +ACCESS_SYS_REG(grpen0)
> +ACCESS_SYS_REG(grpen1)
> +
> +#define ACCESS_APNR_SYS_REG(REG)					\
> +static bool access_gic_##REG##_sys_reg(struct kvm_vcpu *vcpu,		\
> +				    struct sys_reg_params *p,		\
> +				    const struct sys_reg_desc *r)	\
> +{									\
> +	unsigned long tmp;						\
> +	u8 idx = p->Op2 & 3;						\
> +	bool ret;							\
> +									\
> +	if (p->is_write)						\
> +		tmp = p->regval;					\
> +	ret = access_gic_##REG##_reg(vcpu, p->is_write, idx, &tmp);	\
> +	if (!p->is_write)						\
> +		p->regval = tmp;					\
> +									\
> +	return ret;							\
> +}
> +
> +ACCESS_APNR_SYS_REG(ap0r)
> +ACCESS_APNR_SYS_REG(ap1r)

I don't get these indirections.  Why can't you call the functions
directly?

> +
> +static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
> +	/* ICC_PMR_EL1 */
> +	{ Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr_sys_reg },
> +	/* ICC_BPR0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0_sys_reg },
> +	/* ICC_AP0R0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r_sys_reg },
> +	/* ICC_AP0R1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r_sys_reg },
> +	/* ICC_AP0R2_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r_sys_reg },
> +	/* ICC_AP0R3_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r_sys_reg },
> +	/* ICC_AP1R0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r_sys_reg },
> +	/* ICC_AP1R1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r_sys_reg },
> +	/* ICC_AP1R2_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r_sys_reg },
> +	/* ICC_AP1R3_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r_sys_reg },
> +	/* ICC_BPR1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1_sys_reg },
> +	/* ICC_CTLR_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr_sys_reg },
> +	/* ICC_SRE_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(5), access_gic_sre_sys_reg },
> +	/* ICC_IGRPEN0_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0_sys_reg },
> +	/* ICC_GRPEN1_EL1 */
> +	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1_sys_reg },
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
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index a3ff04b..6e7400e 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -240,6 +240,13 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
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
> @@ -340,6 +347,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	 */
>  	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
> +	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
>  
>  	if (!info->vcpu.start) {
>  		kvm_info("GICv3: no GICV resource entry\n");
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 9232791..af23399 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -140,6 +140,28 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
>  int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 u64 id, u64 *val);
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg);
> +bool access_gic_ctlr_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 unsigned long *reg);
> +bool access_gic_pmr_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			unsigned long *reg);
> +bool access_gic_bpr0_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 unsigned long *reg);
> +bool access_gic_bpr1_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 unsigned long *reg);
> +bool access_gic_grpen0_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			   unsigned long *reg);
> +bool access_gic_grpen1_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			   unsigned long *reg);
> +bool access_gic_ap0r_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 u8 idx, unsigned long *reg);
> +bool access_gic_ap1r_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			 u8 idx, unsigned long *reg);
> +bool access_gic_sre_reg(struct kvm_vcpu *vcpu, bool is_write,
> +			unsigned long *reg);

nit: since all of this is exported, I would name them vgic_access_ctlr()
and so on. The _reg postfix is probably also unnecessary for all of
these.

>  int kvm_register_vgic_device(unsigned long type);
>  void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> -- 
> 1.9.1
> 

Thanks,
-Christoffer
