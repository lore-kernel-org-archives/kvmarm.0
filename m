From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v3 15/15] irqchip/gicv2m/v3-its-pci-msi: IOMMU map the MSI
 frame when needed
Date: Thu, 18 Feb 2016 11:33:07 +0000
Message-ID: <20160218113307.2b263b10@arm.com>
References: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
 <1455264797-2334-16-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 278DF4993D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2016 06:26:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lTRJmAw52HRk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Feb 2016 06:26:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12F4149936
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Feb 2016 06:26:56 -0500 (EST)
In-Reply-To: <1455264797-2334-16-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>, leo.duran@amd.com
Cc: Thomas.Lendacky@amd.com, eric.auger@st.com, jason@lakedaemon.net, kvm@vger.kernel.org, patches@linaro.org, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, sherry.hurwitz@amd.com, brijesh.singh@amd.com, tglx@linutronix.de, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 12 Feb 2016 08:13:17 +0000
Eric Auger <eric.auger@linaro.org> wrote:

> In case the msi_desc references a device attached to an iommu
> domain, the msi address needs to be mapped in the IOMMU. Else any
> MSI write transaction will cause a fault.
> 
> gic_set_msi_addr detects that case and allocates an iova bound
> to the physical address page comprising the MSI frame. This iova
> then is used as the msi_msg address. Unset operation decrements the
> reference on the binding.
> 
> The functions are called in the irq_write_msi_msg ops implementation.
> At that time we can recognize whether the msi is setup or teared down
> looking at the msi_msg content. Indeed msi_domain_deactivate zeroes all
> the fields.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> v2 -> v3:
> - protect iova/addr manipulation with CONFIG_ARCH_DMA_ADDR_T_64BIT and
>   CONFIG_PHYS_ADDR_T_64BIT
> - only expose gic_pci_msi_domain_write_msg in case CONFIG_IOMMU_API &
>   CONFIG_PCI_MSI_IRQ_DOMAIN are set.
> - gic_set/unset_msi_addr duly become static
> ---
>  drivers/irqchip/irq-gic-common.c         | 69 ++++++++++++++++++++++++++++++++
>  drivers/irqchip/irq-gic-common.h         |  5 +++
>  drivers/irqchip/irq-gic-v2m.c            |  7 +++-
>  drivers/irqchip/irq-gic-v3-its-pci-msi.c |  5 +++
>  4 files changed, 85 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
> index f174ce0..46cd06c 100644
> --- a/drivers/irqchip/irq-gic-common.c
> +++ b/drivers/irqchip/irq-gic-common.c
> @@ -18,6 +18,8 @@
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/irqchip/arm-gic.h>
> +#include <linux/iommu.h>
> +#include <linux/msi.h>
>  
>  #include "irq-gic-common.h"
>  
> @@ -121,3 +123,70 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void))
>  	if (sync_access)
>  		sync_access();
>  }
> +
> +#if defined(CONFIG_IOMMU_API) && defined(CONFIG_PCI_MSI_IRQ_DOMAIN)
> +static int gic_set_msi_addr(struct irq_data *data, struct msi_msg *msg)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +	struct device *dev = msi_desc_to_dev(desc);
> +	struct iommu_domain *d;
> +	phys_addr_t addr;
> +	dma_addr_t iova;
> +	int ret;
> +
> +	d = iommu_get_domain_for_dev(dev);
> +	if (!d)
> +		return 0;
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +	addr = ((phys_addr_t)(msg->address_hi) << 32) | msg->address_lo;
> +#else
> +	addr = msg->address_lo;
> +#endif
> +
> +	ret = iommu_get_single_reserved(d, addr, IOMMU_WRITE, &iova);
> +
> +	if (!ret) {
> +		msg->address_lo = lower_32_bits(iova);
> +		msg->address_hi = upper_32_bits(iova);
> +	}
> +	return ret;
> +}
> +
> +
> +static void gic_unset_msi_addr(struct irq_data *data)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +	struct device *dev;
> +	struct iommu_domain *d;
> +	dma_addr_t iova;
> +
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> +	iova = ((dma_addr_t)(desc->msg.address_hi) << 32) |
> +		desc->msg.address_lo;
> +#else
> +	iova = desc->msg.address_lo;
> +#endif
> +
> +	dev = msi_desc_to_dev(desc);
> +	if (!dev)
> +		return;
> +
> +	d = iommu_get_domain_for_dev(dev);
> +	if (!d)
> +		return;
> +
> +	iommu_put_single_reserved(d, iova);
> +}
> +
> +void gic_pci_msi_domain_write_msg(struct irq_data *irq_data,
> +				  struct msi_msg *msg)
> +{
> +	if (!msg->address_hi && !msg->address_lo && !msg->data)
> +		gic_unset_msi_addr(irq_data); /* deactivate */
> +	else
> +		gic_set_msi_addr(irq_data, msg); /* activate, set_affinity */
> +
> +	pci_msi_domain_write_msg(irq_data, msg);
> +}

So by doing that, you are specializing this infrastructure to PCI.
If you hijacked irq_compose_msi_msg() instead, you'd have both
platform and PCI MSI for the same price.

I can see a potential problem with the teardown of an MSI (I don't
think the compose method is called on teardown), but I think this could
be easily addressed.

> +#endif
> +
> diff --git a/drivers/irqchip/irq-gic-common.h b/drivers/irqchip/irq-gic-common.h
> index fff697d..98681fd 100644
> --- a/drivers/irqchip/irq-gic-common.h
> +++ b/drivers/irqchip/irq-gic-common.h
> @@ -35,4 +35,9 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void));
>  void gic_enable_quirks(u32 iidr, const struct gic_quirk *quirks,
>  		void *data);
>  
> +#if defined(CONFIG_PCI_MSI_IRQ_DOMAIN) && defined(CONFIG_IOMMU_API)
> +void gic_pci_msi_domain_write_msg(struct irq_data *irq_data,
> +				  struct msi_msg *msg);
> +#endif
> +
>  #endif /* _IRQ_GIC_COMMON_H */
> diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
> index c779f83..692d809 100644
> --- a/drivers/irqchip/irq-gic-v2m.c
> +++ b/drivers/irqchip/irq-gic-v2m.c
> @@ -24,6 +24,7 @@
>  #include <linux/of_pci.h>
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
> +#include "irq-gic-common.h"
>  
>  /*
>  * MSI_TYPER:
> @@ -83,7 +84,11 @@ static struct irq_chip gicv2m_msi_irq_chip = {
>  	.irq_mask		= gicv2m_mask_msi_irq,
>  	.irq_unmask		= gicv2m_unmask_msi_irq,
>  	.irq_eoi		= irq_chip_eoi_parent,
> -	.irq_write_msi_msg	= pci_msi_domain_write_msg,
> +#ifdef CONFIG_IOMMU_API
> +	.irq_write_msi_msg	= gic_pci_msi_domain_write_msg,
> +#else
> +	.irq_write_msi_msg      = pci_msi_domain_write_msg,
> +#endif

Irrespective of the way you implement the translation procedure, you
should make this unconditional, and have the #ifdefery in the code that
implements it.

>  };
>  
>  static struct msi_domain_info gicv2m_msi_domain_info = {
> diff --git a/drivers/irqchip/irq-gic-v3-its-pci-msi.c b/drivers/irqchip/irq-gic-v3-its-pci-msi.c
> index 8223765..690504e 100644
> --- a/drivers/irqchip/irq-gic-v3-its-pci-msi.c
> +++ b/drivers/irqchip/irq-gic-v3-its-pci-msi.c
> @@ -19,6 +19,7 @@
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_pci.h>
> +#include "irq-gic-common.h"
>  
>  static void its_mask_msi_irq(struct irq_data *d)
>  {
> @@ -37,7 +38,11 @@ static struct irq_chip its_msi_irq_chip = {
>  	.irq_unmask		= its_unmask_msi_irq,
>  	.irq_mask		= its_mask_msi_irq,
>  	.irq_eoi		= irq_chip_eoi_parent,
> +#ifdef CONFIG_IOMMU_API
> +	.irq_write_msi_msg	= gic_pci_msi_domain_write_msg,
> +#else
>  	.irq_write_msi_msg	= pci_msi_domain_write_msg,
> +#endif
>  };
>  
>  struct its_pci_alias {

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
