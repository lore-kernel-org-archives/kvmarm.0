From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 5/6] arm/arm64: vgic-new: Implement VGICv3 CPU interface
 access
Date: Fri, 16 Sep 2016 15:36:22 +0100
Message-ID: <57DC0366.8060304@arm.com>
References: <1474028453-29132-1-git-send-email-vijay.kilari@gmail.com>
 <1474028453-29132-6-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 158D8499A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 10:27:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eFrzr4KU5Xml for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 10:27:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F11B9412DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 10:27:33 -0400 (EDT)
In-Reply-To: <1474028453-29132-6-git-send-email-vijay.kilari@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Vijaya Kumar K <Vijaya.Kumar@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/09/16 13:20, vijay.kilari@gmail.com wrote:
> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> 
> VGICv3 CPU interface registers are accessed using
> KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> as 64-bit. The cpu MPIDR value is passed along with register id.
> is used to identify the cpu for registers access.
> 
> The version of VGIC v3 specification is define here
> http://lists.infradead.org/pipermail/linux-arm-kernel/2016-July/445611.html
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> ---
>  arch/arm64/include/uapi/asm/kvm.h   |   3 +
>  arch/arm64/kvm/Makefile             |   1 +
>  include/linux/irqchip/arm-gic-v3.h  |  30 ++++
>  virt/kvm/arm/vgic/vgic-kvm-device.c |  27 ++++
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  18 +++
>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 296 ++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h            |  10 ++
>  7 files changed, 385 insertions(+)
> 
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
> index d50a82a..1a14e29 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -32,5 +32,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 88d83d3..d4e9c7d 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -355,6 +355,27 @@
>  #define ICC_CTLR_EL1_EOImode_SHIFT	(1)
>  #define ICC_CTLR_EL1_EOImode_drop_dir	(0U << ICC_CTLR_EL1_EOImode_SHIFT)
>  #define ICC_CTLR_EL1_EOImode_drop	(1U << ICC_CTLR_EL1_EOImode_SHIFT)
> +#define ICC_CTLR_EL1_EOImode_MASK	(1 << ICC_CTLR_EL1_EOImode_SHIFT)
> +#define ICC_CTLR_EL1_CBPR_SHIFT		(0)
> +#define ICC_CTLR_EL1_CBPR_MASK		(1 << ICC_CTLR_EL1_CBPR_SHIFT)
> +#define ICC_CTLR_EL1_PRI_BITS_SHIFT	(8)
> +#define ICC_CTLR_EL1_PRI_BITS_MASK	(0x7 << ICC_CTLR_EL1_PRI_BITS_SHIFT)
> +#define ICC_CTLR_EL1_ID_BITS_SHIFT	(11)
> +#define ICC_CTLR_EL1_ID_BITS_MASK	(0x7 << ICC_CTLR_EL1_ID_BITS_SHIFT)
> +#define ICC_CTLR_EL1_SEIS_SHIFT		(14)
> +#define ICC_CTLR_EL1_SEIS_MASK		(0x1 << ICC_CTLR_EL1_SEIS_SHIFT)
> +#define ICC_CTLR_EL1_A3V_SHIFT		(15)
> +#define ICC_CTLR_EL1_A3V_MASK		(0x1 << ICC_CTLR_EL1_A3V_SHIFT)
> +#define ICC_PMR_EL1_SHIFT		(0)
> +#define ICC_PMR_EL1_MASK		(0xff << ICC_PMR_EL1_SHIFT)
> +#define ICC_BPR0_EL1_SHIFT		(0)
> +#define ICC_BPR0_EL1_MASK		(0x7 << ICC_BPR0_EL1_SHIFT)
> +#define ICC_BPR1_EL1_SHIFT		(0)
> +#define ICC_BPR1_EL1_MASK		(0x7 << ICC_BPR1_EL1_SHIFT)
> +#define ICC_IGRPEN0_EL1_SHIFT		(0)
> +#define ICC_IGRPEN0_EL1_MASK		(1 << ICC_IGRPEN0_EL1_SHIFT)
> +#define ICC_IGRPEN1_EL1_SHIFT		(0)
> +#define ICC_IGRPEN1_EL1_MASK		(1 << ICC_IGRPEN1_EL1_SHIFT)
>  #define ICC_SRE_EL1_SRE			(1U << 0)
>  
>  /*
> @@ -398,6 +419,15 @@
>  #define ICH_VMCR_ENG1_SHIFT		1
>  #define ICH_VMCR_ENG1_MASK		(1 << ICH_VMCR_ENG1_SHIFT)
>  
> +#define ICH_VTR_PRI_BITS_SHIFT		29
> +#define ICH_VTR_PRI_BITS_MASK		(7 << ICH_VTR_PRI_BITS_SHIFT)
> +#define ICH_VTR_ID_BITS_SHIFT		23
> +#define ICH_VTR_ID_BITS_MASK		(7 << ICH_VTR_ID_BITS_SHIFT)
> +#define ICH_VTR_SEIS_SHIFT		22
> +#define ICH_VTR_SEIS_MASK		(1 << ICH_VTR_SEIS_SHIFT)
> +#define ICH_VTR_A3V_SHIFT		21
> +#define ICH_VTR_A3V_MASK		(1 << ICH_VTR_A3V_SHIFT)
> +

Same thing here. Please group all the additions to this file into a
single, independent patch.

>  #define ICC_IAR1_EL1_SPURIOUS		0x3ff
>  
>  #define ICC_SRE_EL2_SRE			(1 << 0)
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index a4656fc..a48101f 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -506,6 +506,14 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
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
> @@ -539,6 +547,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
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
> @@ -565,6 +582,15 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
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
> @@ -583,6 +609,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		break;
>  	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
>  		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index 83dece8..af748d7 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -23,6 +23,7 @@
>  
>  #include "vgic.h"
>  #include "vgic-mmio.h"
> +#include "sys_regs.h"
>  
>  /* extract @num bytes at @offset bytes offset in data */
>  unsigned long extract_bytes(u64 data, unsigned int offset,
> @@ -639,6 +640,23 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  		nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
>  		break;
>  	}
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 reg, id;
> +		unsigned long mpidr;
> +		struct kvm_vcpu *vcpu;
> +
> +		mpidr = (attr->attr & KVM_DEV_ARM_VGIC_V3_MPIDR_MASK) >>
> +			 KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT;
> +
> +		vcpu = kvm_mpidr_to_vcpu(dev->kvm, mpidr);

No. Your "mpidr" variable is not an MPIDR.  It represents the same
thing, but not with the right format.

> +		if (!vcpu)
> +			return -EINVAL;
> +		if (vcpu->vcpu_id >= atomic_read(&dev->kvm->online_vcpus))

How can that happen?

> +			return -EINVAL;
> +
> +		id = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK);
> +		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, id, &reg);
> +	}
>  	default:
>  		return -ENXIO;
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> new file mode 100644
> index 0000000..8e4f403
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> @@ -0,0 +1,296 @@
> +#include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <kvm/iodev.h>
> +#include <kvm/arm_vgic.h>
> +#include <asm/kvm_emulate.h>
> +#include <asm/kvm_arm.h>
> +#include <asm/kvm_mmu.h>
> +
> +#include "vgic.h"
> +#include "vgic-mmio.h"
> +#include "sys_regs.h"
> +
> +static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	struct vgic_vmcr vmcr;
> +	u64 val;
> +	u32 ich_vtr;
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		val = p->regval;
> +		vmcr.ctlr &= ~(ICH_VMCR_CBPR_MASK | ICH_VMCR_EOIM_MASK);
> +		vmcr.ctlr |= ((val & ICC_CTLR_EL1_CBPR_MASK) >>
> +			      ICC_CTLR_EL1_CBPR_SHIFT) << ICH_VMCR_CBPR_SHIFT;
> +		vmcr.ctlr |= ((val & ICC_CTLR_EL1_EOImode_MASK) >>
> +			     ICC_CTLR_EL1_EOImode_SHIFT) << ICH_VMCR_EOIM_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);

You've ignored my comments again: "What if userspace writes something
that is incompatible with the current configuration? Wrong number of ID
bits, or number of priorities?"

> +	} else {
> +		ich_vtr = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
> +
> +		val = 0;
> +		val |= ((ich_vtr & ICH_VTR_PRI_BITS_MASK) >>
> +			ICH_VTR_PRI_BITS_SHIFT) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
> +		val |= ((ich_vtr & ICH_VTR_ID_BITS_MASK) >>
> +			ICH_VTR_ID_BITS_SHIFT) << ICC_CTLR_EL1_ID_BITS_SHIFT;
> +		val |= ((ich_vtr & ICH_VTR_SEIS_MASK) >> ICH_VTR_SEIS_SHIFT)
> +			<< ICC_CTLR_EL1_SEIS_SHIFT;
> +		val |= ((ich_vtr & ICH_VTR_A3V_MASK) >> ICH_VTR_A3V_SHIFT)
> +			<< ICC_CTLR_EL1_A3V_SHIFT;
> +		val |= ((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >>
> +			ICH_VMCR_CBPR_SHIFT) << ICC_CTLR_EL1_CBPR_SHIFT;
> +		val |= ((vmcr.ctlr & ICH_VMCR_EOIM_MASK) >>
> +			ICH_VMCR_EOIM_SHIFT) << ICC_CTLR_EL1_EOImode_SHIFT;
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
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
> +			     ICC_BPR1_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = (vmcr.abpr << ICC_BPR1_EL1_SHIFT) &
> +			     ICC_BPR1_EL1_MASK;
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
> +				      ICC_IGRPEN0_EL1_SHIFT;
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
> +				      ICC_IGRPEN1_EL1_SHIFT;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = (vmcr.grpen1 << ICC_IGRPEN1_EL1_SHIFT) &
> +			     ICC_IGRPEN1_EL1_MASK;

>From the previous review comments: "Shouldn't this account for the
ICC_CTLR_EL1.CBPR setting?"

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
> +static void access_gic_aprn(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r, u8 apr)
> +{
> +	u8 num_pri_bits, idx;
> +	u32 ich_vtr = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);

Maybe you should cache this once and for all? It is fairly unlikely to
change over time...

> +
> +
> +	num_pri_bits = ((ich_vtr & ICH_VTR_PRI_BITS_MASK) >>
> +			ICH_VTR_PRI_BITS_SHIFT) + 1;
> +	idx = r->Op2 & 3;
> +
> +	switch (num_pri_bits) {
> +	case 7:
> +		if (idx > 3)
> +			goto err;
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
> +	return;
> +err:
> +	if (!p->is_write)
> +		p->regval = 0;
> +}
> +
> +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	access_gic_aprn(vcpu, p, r, 0);
> +
> +	return true;
> +}
> +
> +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	access_gic_aprn(vcpu, p, r, 1);
> +
> +	return true;
> +}
> +
> +static bool access_gic_sre(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	/* Read only. Write ignore */
> +	if (!p->is_write)
> +		p->regval = vgicv3->vgic_sre;
> +
> +	return true;
> +}
> +
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
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 9ee54e3..4c0076c 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -30,6 +30,12 @@
>  
>  #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
>  
> +#define   KVM_DEV_ARM_VGIC_SYSREG_MASK (KVM_REG_ARM64_SYSREG_OP0_MASK | \
> +					KVM_REG_ARM64_SYSREG_OP1_MASK | \
> +					KVM_REG_ARM64_SYSREG_CRN_MASK | \
> +					KVM_REG_ARM64_SYSREG_CRM_MASK | \
> +					KVM_REG_ARM64_SYSREG_OP2_MASK)
> +
>  struct vgic_vmcr {
>  	u32	ctlr;
>  	u32	abpr;
> @@ -98,6 +104,10 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
>  int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 u64 id, u64 *val);
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg);
>  #else
>  static inline int vgic_register_its_iodevs(struct kvm *kvm)
>  {
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
