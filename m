From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 8/9] KVM: arm/arm64: vgic: Rely on the GIC driver to
 parse the firmware tables
Date: Fri, 1 Apr 2016 12:32:13 +0200
Message-ID: <20160401103213.GC20224@cbox>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
 <1458842023-31853-9-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4621041267
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 06:31:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JX2OA+wwsfOr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 06:31:04 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD7D640F90
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 06:31:04 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id p65so17413801wmp.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2016 03:32:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1458842023-31853-9-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, fu.wei@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 24, 2016 at 05:53:42PM +0000, Julien Grall wrote:
> Currently, the firmware tables are parsed 2 times: once in the GIC
> drivers, the other time when initializing the vGIC. It means code
> duplication and make more tedious to add the support for another
> firmware table (like ACPI).
> 
> Use the recently introduced helper gic_get_kvm_info() to get
> information about the virtual GIC.
> 
> With this change, the virtual GIC becomes agnostic to the firmware
> table and KVM will be able to initialize the vGIC on ACPI.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> 
> ---
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> 
>     Changes in v4:
>         - Remove validation check as they are already done during
>         parsing.
>         - Move the alignement check from the parsing to the vGIC code.
>         - Fix typo in the commit message
> 
>     Changes in v2:
>         - Use 0 rather than a negative value to know when the maintenance IRQ
>         is not present.
>         - Use resource for vcpu and vctrl.
> ---
>  include/kvm/arm_vgic.h |  7 +++---
>  virt/kvm/arm/vgic-v2.c | 61 +++++++++++++++++++++-----------------------------
>  virt/kvm/arm/vgic-v3.c | 47 +++++++++++++-------------------------
>  virt/kvm/arm/vgic.c    | 50 ++++++++++++++++++++++-------------------
>  4 files changed, 73 insertions(+), 92 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 281caf8..be6037a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -25,6 +25,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <kvm/iodev.h>
> +#include <linux/irqchip/arm-gic-common.h>
>  
>  #define VGIC_NR_IRQS_LEGACY	256
>  #define VGIC_NR_SGIS		16
> @@ -353,15 +354,15 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
>  #define vgic_ready(k)		((k)->arch.vgic.ready)
>  
> -int vgic_v2_probe(struct device_node *vgic_node,
> +int vgic_v2_probe(const struct gic_kvm_info *gic_kvm_info,
>  		  const struct vgic_ops **ops,
>  		  const struct vgic_params **params);
>  #ifdef CONFIG_KVM_ARM_VGIC_V3
> -int vgic_v3_probe(struct device_node *vgic_node,
> +int vgic_v3_probe(const struct gic_kvm_info *gic_kvm_info,
>  		  const struct vgic_ops **ops,
>  		  const struct vgic_params **params);
>  #else
> -static inline int vgic_v3_probe(struct device_node *vgic_node,
> +static inline int vgic_v3_probe(const struct gic_kvm_info *gic_kvm_info,
>  				const struct vgic_ops **ops,
>  				const struct vgic_params **params)
>  {
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> index 67ec334..7e826c9 100644
> --- a/virt/kvm/arm/vgic-v2.c
> +++ b/virt/kvm/arm/vgic-v2.c
> @@ -20,9 +20,6 @@
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> -#include <linux/of.h>
> -#include <linux/of_address.h>
> -#include <linux/of_irq.h>
>  
>  #include <linux/irqchip/arm-gic.h>
>  
> @@ -186,38 +183,39 @@ static void vgic_cpu_init_lrs(void *params)
>  }
>  
>  /**
> - * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> - * @ops: 	address of a pointer to the GICv2 operations
> - * @params:	address of a pointer to HW-specific parameters
> + * vgic_v2_probe - probe for a GICv2 compatible interrupt controller
> + * @gic_kvm_info:	pointer to the GIC description
> + * @ops:		address of a pointer to the GICv2 operations
> + * @params:		address of a pointer to HW-specific parameters
>   *
>   * Returns 0 if a GICv2 has been found, with the low level operations
>   * in *ops and the HW parameters in *params. Returns an error code
>   * otherwise.
>   */
> -int vgic_v2_probe(struct device_node *vgic_node,
> -		  const struct vgic_ops **ops,
> -		  const struct vgic_params **params)
> +int vgic_v2_probe(const struct gic_kvm_info *gic_kvm_info,
> +		   const struct vgic_ops **ops,
> +		   const struct vgic_params **params)
>  {
>  	int ret;
> -	struct resource vctrl_res;
> -	struct resource vcpu_res;
>  	struct vgic_params *vgic = &vgic_v2_params;
> +	const struct resource *vctrl_res = &gic_kvm_info->vctrl;
> +	const struct resource *vcpu_res = &gic_kvm_info->vcpu;
>  
> -	vgic->maint_irq = irq_of_parse_and_map(vgic_node, 0);
> -	if (!vgic->maint_irq) {
> -		kvm_err("error getting vgic maintenance irq from DT\n");
> +	if (!gic_kvm_info->maint_irq) {
> +		kvm_err("error getting vgic maintenance irq\n");
>  		ret = -ENXIO;
>  		goto out;
>  	}
> +	vgic->maint_irq = gic_kvm_info->maint_irq;
>  
> -	ret = of_address_to_resource(vgic_node, 2, &vctrl_res);
> -	if (ret) {
> -		kvm_err("Cannot obtain GICH resource\n");
> +	if (!gic_kvm_info->vctrl.start) {
> +		kvm_err("GICH not present in the firmware table\n");
> +		ret = -ENXIO;
>  		goto out;
>  	}
>  
> -	vgic->vctrl_base = of_iomap(vgic_node, 2);
> +	vgic->vctrl_base = ioremap(gic_kvm_info->vctrl.start,
> +				   resource_size(&gic_kvm_info->vctrl));
>  	if (!vgic->vctrl_base) {
>  		kvm_err("Cannot ioremap GICH\n");
>  		ret = -ENOMEM;
> @@ -228,29 +226,23 @@ int vgic_v2_probe(struct device_node *vgic_node,
>  	vgic->nr_lr = (vgic->nr_lr & 0x3f) + 1;
>  
>  	ret = create_hyp_io_mappings(vgic->vctrl_base,
> -				     vgic->vctrl_base + resource_size(&vctrl_res),
> -				     vctrl_res.start);
> +				     vgic->vctrl_base + resource_size(vctrl_res),
> +				     vctrl_res->start);
>  	if (ret) {
>  		kvm_err("Cannot map VCTRL into hyp\n");
>  		goto out_unmap;
>  	}
>  
> -	if (of_address_to_resource(vgic_node, 3, &vcpu_res)) {
> -		kvm_err("Cannot obtain GICV resource\n");
> -		ret = -ENXIO;
> -		goto out_unmap;
> -	}
> -
> -	if (!PAGE_ALIGNED(vcpu_res.start)) {
> +	if (!PAGE_ALIGNED(vcpu_res->start)) {
>  		kvm_err("GICV physical address 0x%llx not page aligned\n",
> -			(unsigned long long)vcpu_res.start);
> +			(unsigned long long)vcpu_res->start);
>  		ret = -ENXIO;
>  		goto out_unmap;
>  	}
>  
> -	if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
> +	if (!PAGE_ALIGNED(resource_size(vcpu_res))) {
>  		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> -			(unsigned long long)resource_size(&vcpu_res),
> +			(unsigned long long)resource_size(vcpu_res),
>  			PAGE_SIZE);
>  		ret = -ENXIO;
>  		goto out_unmap;
> @@ -259,10 +251,10 @@ int vgic_v2_probe(struct device_node *vgic_node,
>  	vgic->can_emulate_gicv2 = true;
>  	kvm_register_device_ops(&kvm_arm_vgic_v2_ops, KVM_DEV_TYPE_ARM_VGIC_V2);
>  
> -	vgic->vcpu_base = vcpu_res.start;
> +	vgic->vcpu_base = vcpu_res->start;
>  
> -	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
> -		 vctrl_res.start, vgic->maint_irq);
> +	kvm_info("GICH base=0x%llx, GICV base=0x%llx, IRQ=%d\n",
> +		 gic_kvm_info->vctrl.start, vgic->vcpu_base, vgic->maint_irq);
>  
>  	vgic->type = VGIC_V2;
>  	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;
> @@ -276,6 +268,5 @@ int vgic_v2_probe(struct device_node *vgic_node,
>  out_unmap:
>  	iounmap(vgic->vctrl_base);
>  out:
> -	of_node_put(vgic_node);
>  	return ret;
>  }
> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
> index 999bdc6..c02a1b1 100644
> --- a/virt/kvm/arm/vgic-v3.c
> +++ b/virt/kvm/arm/vgic-v3.c
> @@ -20,11 +20,9 @@
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> -#include <linux/of.h>
> -#include <linux/of_address.h>
> -#include <linux/of_irq.h>
>  
>  #include <linux/irqchip/arm-gic-v3.h>
> +#include <linux/irqchip/arm-gic-common.h>
>  
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_arm.h>
> @@ -222,30 +220,24 @@ static void vgic_cpu_init_lrs(void *params)
>  }
>  
>  /**
> - * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> - * @ops: 	address of a pointer to the GICv3 operations
> - * @params:	address of a pointer to HW-specific parameters
> + * vgic_v3_probe - probe for a GICv3 compatible interrupt controller
> + * @gic_kvm_info:	pointer to the GIC description
> + * @ops:		address of a pointer to the GICv3 operations
> + * @params:		address of a pointer to HW-specific parameters
>   *
>   * Returns 0 if a GICv3 has been found, with the low level operations
>   * in *ops and the HW parameters in *params. Returns an error code
>   * otherwise.
>   */
> -int vgic_v3_probe(struct device_node *vgic_node,
> +int vgic_v3_probe(const struct gic_kvm_info *gic_kvm_info,
>  		  const struct vgic_ops **ops,
>  		  const struct vgic_params **params)
>  {
>  	int ret = 0;
> -	u32 gicv_idx;
> -	struct resource vcpu_res;
>  	struct vgic_params *vgic = &vgic_v3_params;
> +	const struct resource *vcpu_res = &gic_kvm_info->vcpu;
>  
> -	vgic->maint_irq = irq_of_parse_and_map(vgic_node, 0);
> -	if (!vgic->maint_irq) {
> -		kvm_err("error getting vgic maintenance irq from DT\n");
> -		ret = -ENXIO;
> -		goto out;
> -	}
> +	vgic->maint_irq = gic_kvm_info->maint_irq;
>  
>  	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
>  
> @@ -256,24 +248,19 @@ int vgic_v3_probe(struct device_node *vgic_node,
>  	vgic->nr_lr = (ich_vtr_el2 & 0xf) + 1;
>  	vgic->can_emulate_gicv2 = false;
>  
> -	if (of_property_read_u32(vgic_node, "#redistributor-regions", &gicv_idx))
> -		gicv_idx = 1;
> -
> -	gicv_idx += 3; /* Also skip GICD, GICC, GICH */
> -	if (of_address_to_resource(vgic_node, gicv_idx, &vcpu_res)) {
> +	if (!vcpu_res->start) {
>  		kvm_info("GICv3: no GICV resource entry\n");
>  		vgic->vcpu_base = 0;
> -	} else if (!PAGE_ALIGNED(vcpu_res.start)) {
> +	} else if (!PAGE_ALIGNED(vcpu_res->start)) {
>  		pr_warn("GICV physical address 0x%llx not page aligned\n",
> -			(unsigned long long)vcpu_res.start);
> +			(unsigned long long)vcpu_res->start);
>  		vgic->vcpu_base = 0;
> -	} else if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
> +	} else if (!PAGE_ALIGNED(resource_size(vcpu_res))) {
>  		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> -			(unsigned long long)resource_size(&vcpu_res),
> +			(unsigned long long)resource_size(vcpu_res),
>  			PAGE_SIZE);
> -		vgic->vcpu_base = 0;

See my comments in patch 6.  Perhaps I'm missing something, but I still
don't see a clear split between KVM vs. GIC error checking.

>  	} else {
> -		vgic->vcpu_base = vcpu_res.start;
> +		vgic->vcpu_base = vcpu_res->start;
>  		vgic->can_emulate_gicv2 = true;
>  		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
>  					KVM_DEV_TYPE_ARM_VGIC_V2);
> @@ -286,15 +273,13 @@ int vgic_v3_probe(struct device_node *vgic_node,
>  	vgic->type = VGIC_V3;
>  	vgic->max_gic_vcpus = VGIC_V3_MAX_CPUS;
>  
> -	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
> -		 vcpu_res.start, vgic->maint_irq);
> +	kvm_info("GICV base=0x%llx, IRQ=%d\n",
> +		 vgic->vcpu_base, vgic->maint_irq);
>  
>  	on_each_cpu(vgic_cpu_init_lrs, vgic, 1);
>  
>  	*ops = &vgic_v3_ops;
>  	*params = vgic;
>  
> -out:
> -	of_node_put(vgic_node);
>  	return ret;
>  }
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 00429b3..60668a7 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -21,9 +21,7 @@
>  #include <linux/kvm_host.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> -#include <linux/of.h>
> -#include <linux/of_address.h>
> -#include <linux/of_irq.h>
> +#include <linux/irq.h>
>  #include <linux/rculist.h>
>  #include <linux/uaccess.h>
>  
> @@ -33,6 +31,7 @@
>  #include <trace/events/kvm.h>
>  #include <asm/kvm.h>
>  #include <kvm/iodev.h>
> +#include <linux/irqchip/arm-gic-common.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
> @@ -2389,33 +2388,38 @@ static struct notifier_block vgic_cpu_nb = {
>  	.notifier_call = vgic_cpu_notify,
>  };
>  
> -static const struct of_device_id vgic_ids[] = {
> -	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_probe, },
> -	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_probe, },
> -	{ .compatible = "arm,gic-400",		.data = vgic_v2_probe, },
> -	{ .compatible = "arm,gic-v3",		.data = vgic_v3_probe, },
> -	{},
> -};
> -
> -int kvm_vgic_hyp_init(void)
> +static int kvm_vgic_probe(void)
>  {
> -	const struct of_device_id *matched_id;
> -	const int (*vgic_probe)(struct device_node *,const struct vgic_ops **,
> -				const struct vgic_params **);
> -	struct device_node *vgic_node;
> +	const struct gic_kvm_info *gic_kvm_info;
>  	int ret;
>  
> -	vgic_node = of_find_matching_node_and_match(NULL,
> -						    vgic_ids, &matched_id);
> -	if (!vgic_node) {
> -		kvm_err("error: no compatible GIC node found\n");
> +	gic_kvm_info = gic_get_kvm_info();
> +	if (!gic_kvm_info)
>  		return -ENODEV;
> +
> +	switch (gic_kvm_info->type) {
> +	case GIC_V2:
> +		ret = vgic_v2_probe(gic_kvm_info, &vgic_ops, &vgic);
> +		break;
> +	case GIC_V3:
> +		ret = vgic_v3_probe(gic_kvm_info, &vgic_ops, &vgic);
> +		break;
> +	default:
> +		ret = -ENODEV;
>  	}
>  
> -	vgic_probe = matched_id->data;
> -	ret = vgic_probe(vgic_node, &vgic_ops, &vgic);
> -	if (ret)
> +	return ret;
> +}
> +
> +int kvm_vgic_hyp_init(void)
> +{
> +	int ret;
> +
> +	ret = kvm_vgic_probe();
> +	if (ret) {
> +		kvm_err("error: KVM vGIC probing failed\n");
>  		return ret;
> +	}
>  
>  	ret = request_percpu_irq(vgic->maint_irq, vgic_maintenance_handler,
>  				 "vgic", kvm_get_running_vcpus());
> -- 
> 1.9.1
> 
