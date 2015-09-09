From: Julien Grall <julien.grall@citrix.com>
Subject: Re: [PATCH v4 3/4] irqchip: GIC: Convert to EOImode == 1
Date: Wed, 9 Sep 2015 20:23:29 +0100
Message-ID: <55F08731.3050402@citrix.com>
References: <1440604845-28229-1-git-send-email-marc.zyngier@arm.com>
 <1440604845-28229-4-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1440604845-28229-4-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Ian Campbell <ian.campbell@citrix.com>, kvm@vger.kernel.org, Eric Auger <eric.auger@linaro.org>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Jiang Liu <jiang.liu@linux.intel.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I've been trying the latest linus/master (a794b4f), which include this
patch, as baremetal kernel on X-gene. This is failing on early boot
without much log.

After bisecting the tree, I found the error coming from this patch.
While this patch is valid, it made me remembered that X-Gene (at least
the first version) as an odd GICv2.

The GICC is divided in 2 area of 4K, each one aligned at a 64KB address.
This means that, the address of GICC_DIR won't be 0x1000 but 0x10000.

We had the same issue on Xen when we did the first port of X-gene [1].
Although, we choose to add a quirk in Xen for this platform in order to
map contiguously in the virtual memory the 2 part of GICC.

Note that, back then, Ian suggested to extend the bindings to support a
such platform [2]. AFAICT, there was no follow-up on it.

Regards,

[1] http://lists.xen.org/archives/html/xen-devel/2013-11/msg03526.html
[2] http://www.spinics.net/lists/devicetree/msg10478.html

On 26/08/15 17:00, Marc Zyngier wrote:
> So far, GICv2 has been used with EOImode == 0. The effect of this
> mode is to perform the priority drop and the deactivation of the
> interrupt at the same time.
> 
> While this works perfectly for Linux (we only have a single priority),
> it causes issues when an interrupt is forwarded to a guest, and when
> we want the guest to perform the EOI itself.
> 
> For this case, the GIC architecture provides EOImode == 1, where:
> - A write to the EOI register drops the priority of the interrupt
>   and leaves it active. Other interrupts at the same priority level
>   can now be taken, but the active interrupt cannot be taken again
> - A write to the DIR marks the interrupt as inactive, meaning it can
>   now be taken again.
> 
> We only enable this feature when booted in HYP mode and that
> the device-tree reported a suitable CPU interface. Observable behaviour
> should remain unchanged.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic.c       | 69 +++++++++++++++++++++++++++++++++++++++--
>  include/linux/irqchip/arm-gic.h |  4 +++
>  2 files changed, 70 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 4dd8826..9215897 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -46,6 +46,7 @@
>  #include <asm/irq.h>
>  #include <asm/exception.h>
>  #include <asm/smp_plat.h>
> +#include <asm/virt.h>
>  
>  #include "irq-gic-common.h"
>  #include "irqchip.h"
> @@ -82,6 +83,8 @@ static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>  #define NR_GIC_CPU_IF 8
>  static u8 gic_cpu_map[NR_GIC_CPU_IF] __read_mostly;
>  
> +static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
> +
>  #ifndef MAX_GIC_NR
>  #define MAX_GIC_NR	1
>  #endif
> @@ -157,6 +160,11 @@ static void gic_mask_irq(struct irq_data *d)
>  	gic_poke_irq(d, GIC_DIST_ENABLE_CLEAR);
>  }
>  
> +static void gic_eoimode1_mask_irq(struct irq_data *d)
> +{
> +	gic_mask_irq(d);
> +}
> +
>  static void gic_unmask_irq(struct irq_data *d)
>  {
>  	gic_poke_irq(d, GIC_DIST_ENABLE_SET);
> @@ -167,6 +175,11 @@ static void gic_eoi_irq(struct irq_data *d)
>  	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_EOI);
>  }
>  
> +static void gic_eoimode1_eoi_irq(struct irq_data *d)
> +{
> +	writel_relaxed(gic_irq(d), gic_cpu_base(d) + GIC_CPU_DEACTIVATE);
> +}
> +
>  static int gic_irq_set_irqchip_state(struct irq_data *d,
>  				     enum irqchip_irq_state which, bool val)
>  {
> @@ -272,11 +285,15 @@ static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
>  		irqnr = irqstat & GICC_IAR_INT_ID_MASK;
>  
>  		if (likely(irqnr > 15 && irqnr < 1021)) {
> +			if (static_key_true(&supports_deactivate))
> +				writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
>  			handle_domain_irq(gic->domain, irqnr, regs);
>  			continue;
>  		}
>  		if (irqnr < 16) {
>  			writel_relaxed(irqstat, cpu_base + GIC_CPU_EOI);
> +			if (static_key_true(&supports_deactivate))
> +				writel_relaxed(irqstat, cpu_base + GIC_CPU_DEACTIVATE);
>  #ifdef CONFIG_SMP
>  			handle_IPI(irqnr, regs);
>  #endif
> @@ -327,6 +344,20 @@ static struct irq_chip gic_chip = {
>  	.flags			= IRQCHIP_SET_TYPE_MASKED,
>  };
>  
> +static struct irq_chip gic_eoimode1_chip = {
> +	.name			= "GICv2",
> +	.irq_mask		= gic_eoimode1_mask_irq,
> +	.irq_unmask		= gic_unmask_irq,
> +	.irq_eoi		= gic_eoimode1_eoi_irq,
> +	.irq_set_type		= gic_set_type,
> +#ifdef CONFIG_SMP
> +	.irq_set_affinity	= gic_set_affinity,
> +#endif
> +	.irq_get_irqchip_state	= gic_irq_get_irqchip_state,
> +	.irq_set_irqchip_state	= gic_irq_set_irqchip_state,
> +	.flags			= IRQCHIP_SET_TYPE_MASKED,
> +};
> +
>  void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
>  {
>  	if (gic_nr >= MAX_GIC_NR)
> @@ -359,6 +390,10 @@ static void gic_cpu_if_up(void)
>  {
>  	void __iomem *cpu_base = gic_data_cpu_base(&gic_data[0]);
>  	u32 bypass = 0;
> +	u32 mode = 0;
> +
> +	if (static_key_true(&supports_deactivate))
> +		mode = GIC_CPU_CTRL_EOImodeNS;
>  
>  	/*
>  	* Preserve bypass disable bits to be written back later
> @@ -366,7 +401,7 @@ static void gic_cpu_if_up(void)
>  	bypass = readl(cpu_base + GIC_CPU_CTRL);
>  	bypass &= GICC_DIS_BYPASS_MASK;
>  
> -	writel_relaxed(bypass | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
> +	writel_relaxed(bypass | mode | GICC_ENABLE, cpu_base + GIC_CPU_CTRL);
>  }
>  
>  
> @@ -789,13 +824,20 @@ void __init gic_init_physaddr(struct device_node *node)
>  static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>  				irq_hw_number_t hw)
>  {
> +	struct irq_chip *chip = &gic_chip;
> +
> +	if (static_key_true(&supports_deactivate)) {
> +		if (d->host_data == (void *)&gic_data[0])
> +			chip = &gic_eoimode1_chip;
> +	}
> +
>  	if (hw < 32) {
>  		irq_set_percpu_devid(irq);
> -		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +		irq_domain_set_info(d, irq, hw, chip, d->host_data,
>  				    handle_percpu_devid_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>  	} else {
> -		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +		irq_domain_set_info(d, irq, hw, chip, d->host_data,
>  				    handle_fasteoi_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>  	}
> @@ -986,6 +1028,8 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
>  		register_cpu_notifier(&gic_cpu_notifier);
>  #endif
>  		set_handle_irq(gic_handle_irq);
> +		if (static_key_true(&supports_deactivate))
> +			pr_info("GIC: Using split EOI/Deactivate mode\n");
>  	}
>  
>  	gic_dist_init(gic);
> @@ -1001,6 +1045,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  {
>  	void __iomem *cpu_base;
>  	void __iomem *dist_base;
> +	struct resource cpu_res;
>  	u32 percpu_offset;
>  	int irq;
>  
> @@ -1013,6 +1058,16 @@ gic_of_init(struct device_node *node, struct device_node *parent)
>  	cpu_base = of_iomap(node, 1);
>  	WARN(!cpu_base, "unable to map gic cpu registers\n");
>  
> +	of_address_to_resource(node, 1, &cpu_res);
> +
> +	/*
> +	 * Disable split EOI/Deactivate if either HYP is not available
> +	 * or the CPU interface is too small.
> +	 */
> +	if (gic_cnt == 0 && (!is_hyp_mode_available() ||
> +			     resource_size(&cpu_res) < SZ_8K))
> +		static_key_slow_dec(&supports_deactivate);
> +
>  	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
>  		percpu_offset = 0;
>  
> @@ -1132,6 +1187,14 @@ gic_v2_acpi_init(struct acpi_table_header *table)
>  	}
>  
>  	/*
> +	 * Disable split EOI/Deactivate if HYP is not available. ACPI
> +	 * guarantees that we'll always have a GICv2, so the CPU
> +	 * interface will always be the right size.
> +	 */
> +	if (!is_hyp_mode_available())
> +		static_key_slow_dec(&supports_deactivate);
> +
> +	/*
>  	 * Initialize zero GIC instance (no multi-GIC support). Also, set GIC
>  	 * as default IRQ domain to allow for GSI registration and GSI to IRQ
>  	 * number translation (see acpi_register_gsi() and acpi_gsi_to_irq()).
> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> index 9de976b..b1533c0 100644
> --- a/include/linux/irqchip/arm-gic.h
> +++ b/include/linux/irqchip/arm-gic.h
> @@ -20,9 +20,13 @@
>  #define GIC_CPU_ALIAS_BINPOINT		0x1c
>  #define GIC_CPU_ACTIVEPRIO		0xd0
>  #define GIC_CPU_IDENT			0xfc
> +#define GIC_CPU_DEACTIVATE		0x1000
>  
>  #define GICC_ENABLE			0x1
>  #define GICC_INT_PRI_THRESHOLD		0xf0
> +
> +#define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
> +
>  #define GICC_IAR_INT_ID_MASK		0x3ff
>  #define GICC_INT_SPURIOUS		1023
>  #define GICC_DIS_BYPASS_MASK		0x1e0
> 


-- 
Julien Grall
