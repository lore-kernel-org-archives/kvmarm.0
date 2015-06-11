From: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH V2 2/5] kvm: arm64: Dispatch virt GIC probing to device
 tree and ACPI
Date: Thu, 11 Jun 2015 19:34:23 +0800
Message-ID: <5579723F.2040503@linaro.org>
References: <1433909767-12189-1-git-send-email-wei@redhat.com> <1433909767-12189-3-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433909767-12189-3-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, pbonzini@redhat.com, drjones@redhat.com, a.spyridakis@virtualopensystems.com
List-Id: kvmarm@lists.cs.columbia.edu

On 06/10/2015 12:16 PM, Wei Huang wrote:
> This patch creates a dispatch function to support virt GIC probing
> in both device tree (DT) and ACPI environment. kvm_vgic_hyp_init()
> will probe DT first. If failed, it will try ACPI.
>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>   include/kvm/arm_vgic.h | 18 +++++++++---------
>   virt/kvm/arm/vgic-v2.c |  8 ++++----
>   virt/kvm/arm/vgic-v3.c |  8 ++++----
>   virt/kvm/arm/vgic.c    | 42 +++++++++++++++++++++++++++++++-----------
>   4 files changed, 48 insertions(+), 28 deletions(-)
>
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 133ea00..3ee732a 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -332,17 +332,17 @@ int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
>   #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
>   #define vgic_ready(k)		((k)->arch.vgic.ready)
>
> -int vgic_v2_probe(struct device_node *vgic_node,
> -		  const struct vgic_ops **ops,
> -		  const struct vgic_params **params);
> +int vgic_v2_dt_probe(struct device_node *vgic_node,
> +		     const struct vgic_ops **ops,
> +		     const struct vgic_params **params);
>   #ifdef CONFIG_ARM_GIC_V3
> -int vgic_v3_probe(struct device_node *vgic_node,
> -		  const struct vgic_ops **ops,
> -		  const struct vgic_params **params);
> +int vgic_v3_dt_probe(struct device_node *vgic_node,
> +		     const struct vgic_ops **ops,
> +		     const struct vgic_params **params);
>   #else
> -static inline int vgic_v3_probe(struct device_node *vgic_node,
> -				const struct vgic_ops **ops,
> -				const struct vgic_params **params)
> +static inline int vgic_v3_dt_probe(struct device_node *vgic_node,
> +				   const struct vgic_ops **ops,
> +				   const struct vgic_params **params)
>   {
>   	return -ENODEV;
>   }
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> index f9b9c7c..295996f 100644
> --- a/virt/kvm/arm/vgic-v2.c
> +++ b/virt/kvm/arm/vgic-v2.c
> @@ -167,7 +167,7 @@ static const struct vgic_ops vgic_v2_ops = {
>   static struct vgic_params vgic_v2_params;
>
>   /**
> - * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
> + * vgic_v2_dt_probe - probe for a GICv2 compatible interrupt controller in DT
>    * @node:	pointer to the DT node
>    * @ops: 	address of a pointer to the GICv2 operations
>    * @params:	address of a pointer to HW-specific parameters
> @@ -176,9 +176,9 @@ static struct vgic_params vgic_v2_params;
>    * in *ops and the HW parameters in *params. Returns an error code
>    * otherwise.
>    */
> -int vgic_v2_probe(struct device_node *vgic_node,
> -		  const struct vgic_ops **ops,
> -		  const struct vgic_params **params)
> +int vgic_v2_dt_probe(struct device_node *vgic_node,
> +		     const struct vgic_ops **ops,
> +		     const struct vgic_params **params)
>   {
>   	int ret;
>   	struct resource vctrl_res;
> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
> index dff0602..91814e2 100644
> --- a/virt/kvm/arm/vgic-v3.c
> +++ b/virt/kvm/arm/vgic-v3.c
> @@ -211,7 +211,7 @@ static const struct vgic_ops vgic_v3_ops = {
>   static struct vgic_params vgic_v3_params;
>
>   /**
> - * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> + * vgic_v3_dt_probe - probe for a GICv3 compatible interrupt controller in DT
>    * @node:	pointer to the DT node
>    * @ops: 	address of a pointer to the GICv3 operations
>    * @params:	address of a pointer to HW-specific parameters
> @@ -220,9 +220,9 @@ static struct vgic_params vgic_v3_params;
>    * in *ops and the HW parameters in *params. Returns an error code
>    * otherwise.
>    */
> -int vgic_v3_probe(struct device_node *vgic_node,
> -		  const struct vgic_ops **ops,
> -		  const struct vgic_params **params)
> +int vgic_v3_dt_probe(struct device_node *vgic_node,
> +		     const struct vgic_ops **ops,
> +		     const struct vgic_params **params)
>   {
>   	int ret = 0;
>   	u32 gicv_idx;
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 78fb820..b4010f0 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -25,6 +25,7 @@
>   #include <linux/of_address.h>
>   #include <linux/of_irq.h>
>   #include <linux/uaccess.h>
> +#include <linux/acpi.h>
>
>   #include <linux/irqchip/arm-gic.h>
>
> @@ -2088,32 +2089,51 @@ static struct notifier_block vgic_cpu_nb = {
>   };
>
>   static const struct of_device_id vgic_ids[] = {
> -	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_probe, },
> -	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_probe, },
> -	{ .compatible = "arm,gic-400",		.data = vgic_v2_probe, },
> -	{ .compatible = "arm,gic-v3",		.data = vgic_v3_probe, },
> +	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_dt_probe, },
> +	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_dt_probe, },
> +	{ .compatible = "arm,gic-400",		.data = vgic_v2_dt_probe, },
> +	{ .compatible = "arm,gic-v3",		.data = vgic_v3_dt_probe, },
>   	{},
>   };
>
> -int kvm_vgic_hyp_init(void)
> +static int kvm_vgic_dt_probe(void)
>   {
>   	const struct of_device_id *matched_id;
>   	const int (*vgic_probe)(struct device_node *,const struct vgic_ops **,
>   				const struct vgic_params **);
>   	struct device_node *vgic_node;
> -	int ret;
>
>   	vgic_node = of_find_matching_node_and_match(NULL,
>   						    vgic_ids, &matched_id);
> -	if (!vgic_node) {
> -		kvm_err("error: no compatible GIC node found\n");
> +	if (!vgic_node)
>   		return -ENODEV;
> -	}
>
>   	vgic_probe = matched_id->data;
> -	ret = vgic_probe(vgic_node, &vgic_ops, &vgic);
> -	if (ret)
> +
> +	return vgic_probe(vgic_node, &vgic_ops, &vgic);
> +}
> +
> +#ifdef CONFIG_ACPI
> +static int kvm_vgic_acpi_probe(void)
> +{
> +	return -EINVAL;
> +}
> +#endif /* CONFIG_ACPI */
> +
> +int kvm_vgic_hyp_init(void)
> +{
> +	int ret;
> +
> +	ret = kvm_vgic_dt_probe();
> +#ifdef CONFIG_ACPI
> +	if (ret && !acpi_disabled)
> +		ret = kvm_vgic_acpi_probe();
> +#endif

How about:

#ifdef CONFIG_ACPI
static int kvm_vgic_acpi_probe(void)
{
	return -EINVAL;
}
#else
static inline int kvm_vgic_acpi_probe(void) { }
#endif /* CONFIG_ACPI */

Then no need for #ifdef CONFIG_ACPI ... #endif in the function.

Thanks
Hanjun
