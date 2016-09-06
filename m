From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 4/5] arm/arm64: vgic-new: Implement VGICv3 CPU
 interface access
Date: Tue, 6 Sep 2016 19:10:31 +0200
Message-ID: <20160906171031.GK23592@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-5-git-send-email-vijay.kilari@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1899F40F9B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 12:59:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cb9M+5afo7Zk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 12:59:38 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC11C407AD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 12:59:37 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id 1so201917719wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 10:08:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1472037609-4164-5-git-send-email-vijay.kilari@gmail.com>
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

On Wed, Aug 24, 2016 at 04:50:08PM +0530, vijay.kilari@gmail.com wrote:
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
>  arch/arm64/include/uapi/asm/kvm.h   |  15 ++-
>  arch/arm64/kvm/Makefile             |   1 +
>  include/linux/irqchip/arm-gic-v3.h  |   4 +
>  virt/kvm/arm/vgic/vgic-kvm-device.c |  29 +++++
>  virt/kvm/arm/vgic/vgic-mmio-v2.c    |   4 +-
>  virt/kvm/arm/vgic/vgic-mmio-v3.c    |   6 +
>  virt/kvm/arm/vgic/vgic-sys-reg-v3.c | 211 ++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h            |   6 +
>  8 files changed, 271 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 94ea676..b13c944 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -182,14 +182,14 @@ struct kvm_arch_memory_slot {
>  	KVM_REG_ARM64_SYSREG_ ## n ## _MASK)
>  
>  #define __ARM64_SYS_REG(op0,op1,crn,crm,op2) \
> -	(KVM_REG_ARM64 | KVM_REG_ARM64_SYSREG | \
> -	ARM64_SYS_REG_SHIFT_MASK(op0, OP0) | \
> +	(ARM64_SYS_REG_SHIFT_MASK(op0, OP0) | \
>  	ARM64_SYS_REG_SHIFT_MASK(op1, OP1) | \
>  	ARM64_SYS_REG_SHIFT_MASK(crn, CRN) | \
>  	ARM64_SYS_REG_SHIFT_MASK(crm, CRM) | \
>  	ARM64_SYS_REG_SHIFT_MASK(op2, OP2))
>  
> -#define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_SIZE_U64)
> +#define ARM64_SYS_REG(...) (__ARM64_SYS_REG(__VA_ARGS__) | KVM_REG_SIZE_U64 | \
> +			    KVM_REG_ARM64 | KVM_REG_ARM64_SYSREG)
>  
>  #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
>  #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
> @@ -208,7 +208,16 @@ struct kvm_arch_memory_slot {
>  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
>  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
>  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> +
>  #define   KVM_DEV_ARM_VGIC_CTRL_INIT	0
> +#define   KVM_DEV_ARM_VGIC_SYSREG_MASK (KVM_REG_ARM64_SYSREG_OP0_MASK | \
> +					KVM_REG_ARM64_SYSREG_OP1_MASK | \
> +					KVM_REG_ARM64_SYSREG_CRN_MASK | \
> +					KVM_REG_ARM64_SYSREG_CRM_MASK | \
> +					KVM_REG_ARM64_SYSREG_OP2_MASK)
> +#define   KVM_DEV_ARM_VGIC_SYSREG(op0, op1, crn, crm, op2) \
> +					__ARM64_SYS_REG(op0, op1, crn, crm, op2)
>  
>  /* Device Control API on vcpu fd */
>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 695eb3c..dafbd0e 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -31,5 +31,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-sys-reg-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 56b0b7e..164463b 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -383,6 +383,10 @@
>  
>  #define ICH_VMCR_CTLR_SHIFT		0
>  #define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
> +#define ICH_VMCR_ENG0_SHIFT		0
> +#define ICH_VMCR_ENG0			(1 << ICH_VMCR_ENG0_SHIFT)
> +#define ICH_VMCR_ENG1_SHIFT		1
> +#define ICH_VMCR_ENG1			(1 << ICH_VMCR_ENG1_SHIFT)
>  #define ICH_VMCR_BPR1_SHIFT		18
>  #define ICH_VMCR_BPR1_MASK		(7 << ICH_VMCR_BPR1_SHIFT)
>  #define ICH_VMCR_BPR0_SHIFT		21
> diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
> index 06f0158..74e5c38 100644
> --- a/virt/kvm/arm/vgic/vgic-kvm-device.c
> +++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
> @@ -500,6 +500,15 @@ static int vgic_attr_regs_access_v3(struct kvm_device *dev,
>  		if (!is_write)
>  			*reg = tmp32;
>  		break;
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 regid;
> +
> +		regid = (attr->attr & KVM_DEV_ARM_VGIC_SYSREG_MASK) |
> +			 KVM_REG_SIZE_U64;
> +		ret = vgic_v3_cpu_sysregs_uaccess(vcpu, is_write,
> +						  regid, reg);
> +		break;
> +	}
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -533,6 +542,15 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
>  		reg = tmp32;
>  		return vgic_attr_regs_access_v3(dev, attr, &reg, true);
>  	}
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		u64 reg;
> +
> +		if (get_user(reg, uaddr))
> +			return -EFAULT;
> +
> +		return vgic_attr_regs_access_v3(dev, attr, &reg, true);
> +	}
>  	}
>  	return -ENXIO;
>  }
> @@ -560,6 +578,16 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
>  		ret = put_user(tmp32, uaddr);
>  		return ret;
>  	}
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 __user *uaddr = (u64 __user *)(long)attr->addr;
> +		u64 reg;
> +
> +		ret = vgic_attr_regs_access_v3(dev, attr, &reg, false);
> +		if (ret)
> +			return ret;
> +		ret = put_user(reg, uaddr);
> +		return ret;
> +	}
>  	}
>  
>  	return -ENXIO;
> @@ -578,6 +606,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
>  		break;
>  	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
>  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS:
>  		return vgic_v3_has_attr_regs(dev, attr);
>  	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
>  		return 0;
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> index cd37159..4a35eb8 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> @@ -212,7 +212,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> -static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> +void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>  {
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_set_vmcr(vcpu, vmcr);
> @@ -220,7 +220,7 @@ static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>  		vgic_v3_set_vmcr(vcpu, vmcr);
>  }
>  
> -static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> +void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>  {
>  	if (kvm_vgic_global_state.type == VGIC_V2)
>  		vgic_v2_get_vmcr(vcpu, vmcr);
> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> index c2df103..61abea0 100644
> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> @@ -23,6 +23,7 @@
>  
>  #include "vgic.h"
>  #include "vgic-mmio.h"
> +#include "sys_regs.h"
>  
>  /* extract @num bytes at @offset bytes offset in data */
>  unsigned long extract_bytes(unsigned long data, unsigned int offset,
> @@ -598,6 +599,11 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
>  		nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
>  		break;
>  	}
> +	case KVM_DEV_ARM_VGIC_CPU_SYSREGS: {
> +		u64 reg;
> +
> +		return vgic_v3_has_cpu_sysregs_attr(vcpu, 0, cpuid, &reg);
> +	}
>  	default:
>  		return -ENXIO;
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-sys-reg-v3.c b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> new file mode 100644
> index 0000000..581d053
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-sys-reg-v3.c
> @@ -0,0 +1,211 @@
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
> +
> +	vgic_get_vmcr(vcpu, &vmcr);
> +	if (p->is_write) {
> +		vmcr.ctlr = (u32)p->regval;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = vmcr.ctlr;
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
> +		vmcr.pmr = (u32)p->regval;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = vmcr.pmr;
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
> +		vmcr.bpr = (u32)p->regval;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = vmcr.bpr;
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
> +		vmcr.abpr = (u32)p->regval;
> +		vgic_set_vmcr(vcpu, &vmcr);
> +	} else {
> +		p->regval = vmcr.abpr;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_grpen0(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (p->is_write) {
> +		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG0;
> +		vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG0_SHIFT) &
> +				      ICH_VMCR_ENG0;
> +	} else {
> +		p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG0) >>
> +			     ICH_VMCR_ENG0_SHIFT;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_grpen1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +
> +	if (p->is_write) {
> +		vgicv3->vgic_vmcr &= ~ICH_VMCR_ENG1;
> +		vgicv3->vgic_vmcr |= (p->regval << ICH_VMCR_ENG1_SHIFT) &
> +				      ICH_VMCR_ENG1;
> +	} else {
> +		p->regval = (vgicv3->vgic_vmcr & ICH_VMCR_ENG1) >>
> +			     ICH_VMCR_ENG1_SHIFT;
> +	}
> +
> +	return true;
> +}
> +
> +static bool access_gic_ap0r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u8 idx = r->Op2 & 3;
> +
> +	if (p->is_write)
> +		vgicv3->vgic_ap0r[idx] = p->regval;
> +	else
> +		p->regval = vgicv3->vgic_ap0r[idx];
> +
> +	return true;
> +}
> +
> +static bool access_gic_ap1r(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	struct vgic_v3_cpu_if *vgicv3 = &vcpu->arch.vgic_cpu.vgic_v3;
> +	u8 idx = r->Op2 & 3;
> +
> +	if (p->is_write)
> +		vgicv3->vgic_ap1r[idx] = p->regval;
> +	else
> +		p->regval = vgicv3->vgic_ap1r[idx];
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
> +
> +	params.regval = le64_to_cpu(*reg);
> +	params.is_write = is_write;
> +	params.is_aarch32 = false;
> +	params.is_32bit = false;
> +
> +	return find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
> +			      ARRAY_SIZE(gic_v3_icc_reg_descs)) ?
> +		0 : -ENXIO;
> +}
> +
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg)
> +{
> +	struct sys_reg_params params;
> +	const struct sys_reg_desc *r;
> +
> +	if (is_write)
> +		params.regval = le64_to_cpu(*reg);
> +	params.is_write = is_write;
> +	params.is_aarch32 = false;
> +	params.is_32bit = false;
> +
> +	r = find_reg_by_id(id, &params, gic_v3_icc_reg_descs,
> +			   ARRAY_SIZE(gic_v3_icc_reg_descs));
> +	if (!r)
> +		return -ENXIO;
> +
> +	if (!r->access(vcpu, &params, r))
> +		return -EINVAL;
> +
> +	if (!is_write)
> +		*reg = cpu_to_le64(params.regval);
> +
> +	return 0;
> +}
> +

Btw. I get a warning about this stray white space line at the end of the
file here when applying these patches.

Thanks,
-Christoffer

> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 14e4ce5..20eab36c 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -96,6 +96,10 @@ int vgic_v3_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
>  int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			 int offset, u32 *val);
> +int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> +			 u64 id, u64 *val);
> +int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
> +				u64 *reg);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
>  {
> @@ -169,6 +173,8 @@ static inline int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
>  #endif
>  
>  int kvm_register_vgic_device(unsigned long type);
> +void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> +void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  int vgic_lazy_init(struct kvm *kvm);
>  int vgic_init(struct kvm *kvm);
>  
> -- 
> 1.9.1
> 
