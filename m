From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 49/56] KVM: arm/arm64: vgic-new: vgic_init: implement
 kvm_vgic_hyp_init
Date: Wed, 18 May 2016 16:08:39 +0200
Message-ID: <20160518140839.GR3827@cbox>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
 <1463392481-26583-50-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1463392481-26583-50-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, May 16, 2016 at 10:53:37AM +0100, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> Implements kvm_vgic_hyp_init and vgic_probe function.
> This uses the new firmware independent VGIC probing to support both ACPI
> and DT based systems (code from Marc Zyngier).
> 
> The vgic_global struct is enriched with new fields populated
> by those functions.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog v1 .. v2:
> - rename vgic_init.c to vgic-init.c
> 
> Changelog v2 .. v3:
> - include kvm/arm_vgic.h instead of kvm/vgic/vgic.h
> - move ich_vtr_el2 variable into probe function
> 
> Changelog v3 .. v4:
> - improve nr_lr determination in GICv2 probe
> - switching to firmware-independent probing
> 
>  include/kvm/vgic/vgic.h       |   1 +
>  virt/kvm/arm/vgic/vgic-init.c | 123 ++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v2.c   |  64 ++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c   |  49 +++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h      |   9 ++++
>  5 files changed, 246 insertions(+)
>  create mode 100644 virt/kvm/arm/vgic/vgic-init.c
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 3689b9b..393489f 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -195,6 +195,7 @@ struct vgic_cpu {
>  };
>  
>  int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
> +int kvm_vgic_hyp_init(void);
>  
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> new file mode 100644
> index 0000000..4523beb
> --- /dev/null
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -0,0 +1,123 @@
> +/*
> + * Copyright (C) 2015, 2016 ARM Ltd.
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
> +#include <linux/uaccess.h>
> +#include <linux/interrupt.h>
> +#include <linux/cpu.h>
> +#include <linux/kvm_host.h>
> +#include <kvm/arm_vgic.h>
> +#include <asm/kvm_mmu.h>
> +#include "vgic.h"
> +
> +/* GENERIC PROBE */
> +
> +static void vgic_init_maintenance_interrupt(void *info)
> +{
> +	enable_percpu_irq(kvm_vgic_global_state.maint_irq, 0);
> +}
> +
> +static int vgic_cpu_notify(struct notifier_block *self,
> +			   unsigned long action, void *cpu)
> +{
> +	switch (action) {
> +	case CPU_STARTING:
> +	case CPU_STARTING_FROZEN:
> +		vgic_init_maintenance_interrupt(NULL);
> +		break;
> +	case CPU_DYING:
> +	case CPU_DYING_FROZEN:
> +		disable_percpu_irq(kvm_vgic_global_state.maint_irq);
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block vgic_cpu_nb = {
> +	.notifier_call = vgic_cpu_notify,
> +};
> +
> +static irqreturn_t vgic_maintenance_handler(int irq, void *data)
> +{
> +	/*
> +	 * We cannot rely on the vgic maintenance interrupt to be
> +	 * delivered synchronously. This means we can only use it to
> +	 * exit the VM, and we perform the handling of EOIed
> +	 * interrupts on the exit path (see vgic_process_maintenance).
> +	 */
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * kvm_vgic_hyp_init: populates the kvm_vgic_global_state variable
> + * according to the host GIC model. Accordingly calls either
> + * vgic_v2/v3_probe which registers the KVM_DEVICE that can be
> + * instantiated by a guest later on .
> + */
> +int kvm_vgic_hyp_init(void)
> +{
> +	const struct gic_kvm_info *gic_kvm_info;
> +	int ret;
> +
> +	gic_kvm_info = gic_get_kvm_info();
> +	if (!gic_kvm_info)
> +		return -ENODEV;
> +
> +	if (!gic_kvm_info->maint_irq) {
> +		kvm_err("No vgic maintenance irq\n");
> +		return -ENXIO;
> +	}
> +
> +	switch (gic_kvm_info->type) {
> +	case GIC_V2:
> +		ret = vgic_v2_probe(gic_kvm_info);
> +		break;
> +	case GIC_V3:
> +		ret = vgic_v3_probe(gic_kvm_info);
> +		break;
> +	default:
> +		ret = -ENODEV;
> +	};
> +
> +	if (ret)
> +		return ret;
> +
> +	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
> +	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
> +				 vgic_maintenance_handler,
> +				 "vgic", kvm_get_running_vcpus());
> +	if (ret) {
> +		kvm_err("Cannot register interrupt %d\n",
> +			kvm_vgic_global_state.maint_irq);
> +		return ret;
> +	}
> +
> +	ret = __register_cpu_notifier(&vgic_cpu_nb);
> +	if (ret) {
> +		kvm_err("Cannot register vgic CPU notifier\n");
> +		goto out_free_irq;
> +	}
> +
> +	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
> +
> +	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
> +	return 0;
> +
> +out_free_irq:
> +	free_percpu_irq(kvm_vgic_global_state.maint_irq,
> +			kvm_get_running_vcpus());
> +	return ret;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index d943059..09777c8 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -17,6 +17,8 @@
>  #include <linux/irqchip/arm-gic.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
> +#include <kvm/arm_vgic.h>
> +#include <asm/kvm_mmu.h>
>  
>  #include "vgic.h"
>  
> @@ -203,3 +205,65 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
>  			GICH_VMCR_PRIMASK_SHIFT;
>  }
> +
> +/**
> + * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
> + * @node:	pointer to the DT node
> + *
> + * Returns 0 if a GICv2 has been found, returns an error code otherwise
> + */
> +int vgic_v2_probe(const struct gic_kvm_info *info)
> +{
> +	int ret;
> +	u32 vtr;
> +
> +	if (!info->vctrl.start) {
> +		kvm_err("GICH not present in the firmware table\n");
> +		return -ENXIO;
> +	}
> +
> +	if (!PAGE_ALIGNED(info->vcpu.start)) {
> +		kvm_err("GICV physical address 0x%llx not page aligned\n",
> +			(unsigned long long)info->vcpu.start);
> +		return -ENXIO;
> +	}
> +
> +	if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
> +		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> +			(unsigned long long)resource_size(&info->vcpu),
> +			PAGE_SIZE);
> +		return -ENXIO;
> +	}
> +
> +	kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
> +						   resource_size(&info->vctrl));
> +	if (!kvm_vgic_global_state.vctrl_base) {
> +		kvm_err("Cannot ioremap GICH\n");
> +		return -ENOMEM;
> +	}
> +
> +	vtr = readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VTR);
> +	kvm_vgic_global_state.nr_lr = (vtr & 0x3f) + 1;
> +
> +	ret = create_hyp_io_mappings(kvm_vgic_global_state.vctrl_base,
> +				     kvm_vgic_global_state.vctrl_base +
> +					 resource_size(&info->vctrl),
> +				     info->vctrl.start);
> +
> +	if (ret) {
> +		kvm_err("Cannot map VCTRL into hyp\n");
> +		iounmap(kvm_vgic_global_state.vctrl_base);
> +		return ret;
> +	}
> +
> +	kvm_vgic_global_state.can_emulate_gicv2 = true;
> +	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
> +
> +	kvm_vgic_global_state.vcpu_base = info->vcpu.start;
> +	kvm_vgic_global_state.type = VGIC_V2;
> +	kvm_vgic_global_state.max_gic_vcpus = VGIC_V2_MAX_CPUS;
> +
> +	kvm_info("vgic-v2@%llx\n", info->vctrl.start);
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 8548297..de0e8e0 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -15,6 +15,9 @@
>  #include <linux/irqchip/arm-gic-v3.h>
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
> +#include <kvm/arm_vgic.h>
> +#include <asm/kvm_mmu.h>
> +#include <asm/kvm_asm.h>
>  
>  #include "vgic.h"
>  
> @@ -182,3 +185,49 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
>  	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
>  	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
>  }
> +
> +/**
> + * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> + * @node:	pointer to the DT node
> + *
> + * Returns 0 if a GICv3 has been found, returns an error code otherwise
> + */
> +int vgic_v3_probe(const struct gic_kvm_info *info)
> +{
> +	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
> +
> +	/*
> +	 * The ListRegs field is 5 bits, but there is a architectural
> +	 * maximum of 16 list registers. Just ignore bit 4...
> +	 */
> +	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
> +	kvm_vgic_global_state.can_emulate_gicv2 = false;
> +
> +	if (!info->vcpu.start) {
> +		kvm_info("GICv3: no GICV resource entry\n");
> +		kvm_vgic_global_state.vcpu_base = 0;
> +	} else if (!PAGE_ALIGNED(info->vcpu.start)) {
> +		pr_warn("GICV physical address 0x%llx not page aligned\n",
> +			(unsigned long long)info->vcpu.start);
> +		kvm_vgic_global_state.vcpu_base = 0;
> +	} else if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
> +		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> +			(unsigned long long)resource_size(&info->vcpu),
> +			PAGE_SIZE);
> +		kvm_vgic_global_state.vcpu_base = 0;
> +	} else {
> +		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
> +		kvm_vgic_global_state.can_emulate_gicv2 = true;
> +		kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
> +		kvm_info("vgic-v2@%llx\n", info->vcpu.start);
> +	}
> +	if (kvm_vgic_global_state.vcpu_base == 0)
> +		kvm_info("disabling GICv2 emulation\n");
> +	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V3);
> +
> +	kvm_vgic_global_state.vctrl_base = NULL;
> +	kvm_vgic_global_state.type = VGIC_V3;
> +	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
> +
> +	return 0;
> +}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index de9dc71..f4244b6 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -16,6 +16,8 @@
>  #ifndef __KVM_ARM_VGIC_NEW_H__
>  #define __KVM_ARM_VGIC_NEW_H__
>  
> +#include <linux/irqchip/arm-gic-common.h>
> +
>  #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
>  #define IMPLEMENTER_ARM		0x43b
>  
> @@ -51,6 +53,7 @@ int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
>  			  int offset, u32 *val);
>  void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> +int vgic_v2_probe(const struct gic_kvm_info *info);
>  int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
>  			     enum vgic_type);
>  
> @@ -62,6 +65,7 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
>  void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
>  void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
> +int vgic_v3_probe(const struct gic_kvm_info *info);
>  int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
>  #else
>  static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
> @@ -95,6 +99,11 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
>  {
>  }
>  
> +static inline int vgic_v3_probe(const struct gic_kvm_info *info)
> +{
> +	return -ENODEV;
> +}
> +
>  static inline int vgic_register_redist_iodevs(struct kvm *kvm,
>  					      gpa_t dist_base_address)
>  {
> -- 
> 2.8.2
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
