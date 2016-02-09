From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 3/5] irqchip/gic-v2: Parse and export virtual GIC
 information
Date: Tue, 9 Feb 2016 21:49:14 +0100
Message-ID: <20160209204914.GE5171@cbox>
References: <1454950049-741-1-git-send-email-julien.grall@arm.com>
 <1454950049-741-4-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0539449A85
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 15:42:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NXVHWWiuntvh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2016 15:42:49 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDD9E49A83
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2016 15:42:48 -0500 (EST)
Received: by mail-wm0-f47.google.com with SMTP id p63so475910wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Feb 2016 12:48:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1454950049-741-4-git-send-email-julien.grall@arm.com>
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
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Feb 08, 2016 at 04:47:27PM +0000, Julien Grall wrote:
> For now, the firmware tables are parsed 2 times: once in the GIC
> drivers, the other timer when initializing the vGIC. It means code
> duplication and make more tedious to add the support for another
> firmware table (like ACPI).
> 
> Introduce a new structure and set of helpers to get/set the virtual GIC
> information. Also fill up the structure for GICv2.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> ---
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> 
>  drivers/irqchip/irq-gic-common.c       | 13 ++++++
>  drivers/irqchip/irq-gic-common.h       |  3 ++
>  drivers/irqchip/irq-gic.c              | 78 +++++++++++++++++++++++++++++++++-
>  include/linux/irqchip/arm-gic-common.h | 34 +++++++++++++++
>  4 files changed, 127 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/irqchip/arm-gic-common.h
> 
> diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
> index f174ce0..704caf4 100644
> --- a/drivers/irqchip/irq-gic-common.c
> +++ b/drivers/irqchip/irq-gic-common.c
> @@ -21,6 +21,19 @@
>  
>  #include "irq-gic-common.h"
>  
> +static const struct gic_kvm_info *gic_kvm_info;
> +
> +const struct gic_kvm_info *gic_get_kvm_info(void)
> +{
> +	return gic_kvm_info;
> +}
> +
> +void gic_set_kvm_info(const struct gic_kvm_info *info)
> +{
> +	WARN(gic_kvm_info != NULL, "gic_kvm_info already set\n");
> +	gic_kvm_info = info;
> +}
> +
>  void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
>  		void *data)
>  {
> diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
> index fff697d..205e5fd 100644
> --- a/drivers/irqchip/irq-gic-common.h
> +++ b/drivers/irqchip/irq-gic-common.h
> @@ -19,6 +19,7 @@
>  
>  #include <linux/of.h>
>  #include <linux/irqdomain.h>
> +#include <linux/irqchip/arm-gic-common.h>
>  
>  struct gic_quirk {
>  	const char *desc;
> @@ -35,4 +36,6 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void));
>  void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
>  		void *data);
>  
> +void gic_set_kvm_info(const struct gic_kvm_info *info);
> +
>  #endif /* _IRQ_GIC_COMMON_H */
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 911758c..d3a09a4 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -102,6 +102,8 @@ static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
>  
>  static struct gic_chip_data gic_data[CONFIG_ARM_GIC_MAX_NR] __read_mostly;
>  
> +static struct gic_kvm_info gic_v2_kvm_info;
> +
>  #ifdef CONFIG_GIC_NON_BANKED
>  static void __iomem *gic_get_percpu_base(union gic_base *base)
>  {
> @@ -1190,6 +1192,44 @@ static bool gic_check_eoimode(struct device_node *node, void __iomem **base)
>  	return true;
>  }
>  
> +static void __init gic_of_setup_kvm_info(struct device_node *node)
> +{
> +	int ret;
> +	struct resource r;
> +	unsigned int irq;
> +
> +	gic_v2_kvm_info.type = GIC_V2;
> +
> +	irq = irq_of_parse_and_map(node, 0);
> +	if (!irq)
> +		gic_v2_kvm_info.maint_irq = -1;
> +	else
> +		gic_v2_kvm_info.maint_irq = irq;
> +
> +	ret = of_address_to_resource(node, 2, &r);
> +	if (!ret) {
> +		gic_v2_kvm_info.vctrl_base = r.start;
> +		gic_v2_kvm_info.vctrl_size = resource_size(&r);
> +	}
> +
> +	ret = of_address_to_resource(node, 3, &r);
> +	if (!ret) {
> +		if (!PAGE_ALIGNED(r.start))
> +			pr_warn("GICV physical address 0x%llx not page aligned\n",
> +				(unsigned long long)r.start);
> +		else if (!PAGE_ALIGNED(resource_size(&r)))
> +			pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
> +				(unsigned long long)resource_size(&r),
> +				PAGE_SIZE);
> +		else {
> +			gic_v2_kvm_info.vcpu_base = r.start;
> +			gic_v2_kvm_info.vcpu_size = resource_size(&r);
> +		}
> +	}
> +
> +	gic_set_kvm_info(&gic_v2_kvm_info);
> +}
> +
>  int __init
>  gic_of_init(struct device_node *node, struct device_node *parent)
>  {
> @@ -1219,8 +1259,10 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  
>  	__gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset,
>  			 &node->fwnode);
> -	if (!gic_cnt)
> +	if (!gic_cnt) {
>  		gic_init_physaddr(node);
> +		gic_of_setup_kvm_info(node);
> +	}
>  
>  	if (parent) {
>  		irq = irq_of_parse_and_map(node, 0);
> @@ -1247,6 +1289,32 @@ IRQCHIP_DECLARE(pl390, "arm,pl390", gic_of_init);
>  
>  #ifdef CONFIG_ACPI
>  static phys_addr_t cpu_phy_base __initdata;
> +static struct
> +{
> +	u32 maint_irq;
> +	int maint_irq_mode;
> +	phys_addr_t vctrl_base;
> +	phys_addr_t vcpu_base;
> +} acpi_data __initdata;
> +
> +static void __init gic_acpi_setup_kvm_info(void)
> +{
> +	gic_v2_kvm_info.type = GIC_V2;
> +
> +	gic_v2_kvm_info.maint_irq = acpi_register_gsi(NULL,
> +						      acpi_data.maint_irq,
> +						      acpi_data.maint_irq_mode,
> +						      ACPI_ACTIVE_HIGH);
> +	gic_v2_kvm_info.vctrl_base = acpi_data.vctrl_base;
> +	if (gic_v2_kvm_info.vctrl_base)
> +		gic_v2_kvm_info.vctrl_size = SZ_8K;
> +
> +	gic_v2_kvm_info.vcpu_base = acpi_data.vcpu_base;
> +	if (gic_v2_kvm_info.vcpu_base)
> +		gic_v2_kvm_info.vcpu_size = SZ_8K;

why are the sizes hard-coded to 8K in this case?

Thanks,
-Christoffer
