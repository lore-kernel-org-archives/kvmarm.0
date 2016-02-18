From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC v3 15/15] irqchip/gicv2m/v3-its-pci-msi: IOMMU map the MSI
 frame when needed
Date: Thu, 18 Feb 2016 15:47:19 +0000
Message-ID: <56C5E787.9070303@arm.com>
References: <1455264797-2334-1-git-send-email-eric.auger@linaro.org>
 <1455264797-2334-16-git-send-email-eric.auger@linaro.org>
 <20160218113307.2b263b10@arm.com> <56C5E450.3010501@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C5E450.3010501@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>, leo.duran@amd.com
Cc: eric.auger@st.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, suravee.suthikulpanit@amd.com, patches@linaro.org, linux-kernel@vger.kernel.org, Manish.Jaggi@caviumnetworks.com, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, sherry.hurwitz@amd.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com
List-Id: kvmarm@lists.cs.columbia.edu

On 18/02/16 15:33, Eric Auger wrote:
> Hi Marc,
> On 02/18/2016 12:33 PM, Marc Zyngier wrote:
>> On Fri, 12 Feb 2016 08:13:17 +0000
>> Eric Auger <eric.auger@linaro.org> wrote:
>>
>>> In case the msi_desc references a device attached to an iommu
>>> domain, the msi address needs to be mapped in the IOMMU. Else any
>>> MSI write transaction will cause a fault.
>>>
>>> gic_set_msi_addr detects that case and allocates an iova bound
>>> to the physical address page comprising the MSI frame. This iova
>>> then is used as the msi_msg address. Unset operation decrements the
>>> reference on the binding.
>>>
>>> The functions are called in the irq_write_msi_msg ops implementation.
>>> At that time we can recognize whether the msi is setup or teared down
>>> looking at the msi_msg content. Indeed msi_domain_deactivate zeroes all
>>> the fields.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>
>>> ---
>>>
>>> v2 -> v3:
>>> - protect iova/addr manipulation with CONFIG_ARCH_DMA_ADDR_T_64BIT and
>>>   CONFIG_PHYS_ADDR_T_64BIT
>>> - only expose gic_pci_msi_domain_write_msg in case CONFIG_IOMMU_API &
>>>   CONFIG_PCI_MSI_IRQ_DOMAIN are set.
>>> - gic_set/unset_msi_addr duly become static
>>> ---
>>>  drivers/irqchip/irq-gic-common.c         | 69 ++++++++++++++++++++++++++++++++
>>>  drivers/irqchip/irq-gic-common.h         |  5 +++
>>>  drivers/irqchip/irq-gic-v2m.c            |  7 +++-
>>>  drivers/irqchip/irq-gic-v3-its-pci-msi.c |  5 +++
>>>  4 files changed, 85 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-common.c b/drivers/irqchip/irq-gic-common.c
>>> index f174ce0..46cd06c 100644
>>> --- a/drivers/irqchip/irq-gic-common.c
>>> +++ b/drivers/irqchip/irq-gic-common.c
>>> @@ -18,6 +18,8 @@
>>>  #include <linux/io.h>
>>>  #include <linux/irq.h>
>>>  #include <linux/irqchip/arm-gic.h>
>>> +#include <linux/iommu.h>
>>> +#include <linux/msi.h>
>>>  
>>>  #include "irq-gic-common.h"
>>>  
>>> @@ -121,3 +123,70 @@ void gic_cpu_config(void __iomem *base, void (*sync_access)(void))
>>>  	if (sync_access)
>>>  		sync_access();
>>>  }
>>> +
>>> +#if defined(CONFIG_IOMMU_API) && defined(CONFIG_PCI_MSI_IRQ_DOMAIN)
>>> +static int gic_set_msi_addr(struct irq_data *data, struct msi_msg *msg)
>>> +{
>>> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
>>> +	struct device *dev = msi_desc_to_dev(desc);
>>> +	struct iommu_domain *d;
>>> +	phys_addr_t addr;
>>> +	dma_addr_t iova;
>>> +	int ret;
>>> +
>>> +	d = iommu_get_domain_for_dev(dev);
>>> +	if (!d)
>>> +		return 0;
>>> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
>>> +	addr = ((phys_addr_t)(msg->address_hi) << 32) | msg->address_lo;
>>> +#else
>>> +	addr = msg->address_lo;
>>> +#endif
>>> +
>>> +	ret = iommu_get_single_reserved(d, addr, IOMMU_WRITE, &iova);
>>> +
>>> +	if (!ret) {
>>> +		msg->address_lo = lower_32_bits(iova);
>>> +		msg->address_hi = upper_32_bits(iova);
>>> +	}
>>> +	return ret;
>>> +}
>>> +
>>> +
>>> +static void gic_unset_msi_addr(struct irq_data *data)
>>> +{
>>> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
>>> +	struct device *dev;
>>> +	struct iommu_domain *d;
>>> +	dma_addr_t iova;
>>> +
>>> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>>> +	iova = ((dma_addr_t)(desc->msg.address_hi) << 32) |
>>> +		desc->msg.address_lo;
>>> +#else
>>> +	iova = desc->msg.address_lo;
>>> +#endif
>>> +
>>> +	dev = msi_desc_to_dev(desc);
>>> +	if (!dev)
>>> +		return;
>>> +
>>> +	d = iommu_get_domain_for_dev(dev);
>>> +	if (!d)
>>> +		return;
>>> +
>>> +	iommu_put_single_reserved(d, iova);
>>> +}
>>> +
>>> +void gic_pci_msi_domain_write_msg(struct irq_data *irq_data,
>>> +				  struct msi_msg *msg)
>>> +{
>>> +	if (!msg->address_hi && !msg->address_lo && !msg->data)
>>> +		gic_unset_msi_addr(irq_data); /* deactivate */
>>> +	else
>>> +		gic_set_msi_addr(irq_data, msg); /* activate, set_affinity */
>>> +
>>> +	pci_msi_domain_write_msg(irq_data, msg);
>>> +}
>>
>> So by doing that, you are specializing this infrastructure to PCI.
>> If you hijacked irq_compose_msi_msg() instead, you'd have both
>> platform and PCI MSI for the same price.
>>
>> I can see a potential problem with the teardown of an MSI (I don't
>> think the compose method is called on teardown), but I think this could
>> be easily addressed.
> Yes effectively this is the reason why I moved it from
> irq_compose_msi_msg (my original implementation) to irq_write_msi_msg. I
> noticed I had no way to detect the teardown whereas the
> msi_domain_deactivate also calls irq_write_msi_msg which is quite
> practical ;-) To be honest I need to further look at the non PCI
> implementation.

Another thing to consider is that MSI controllers may use different
doorbells for different CPU affinities. With your implementation,
repeatedly changing the affinity from one CPU to another would increase
the refcounting, and never actually lower it (you don't necessarily go
via an "unmap"). Of course, none of that applies to GICv2m/GICv3-ITS,
but that's worth considering.

So I think we may need some better tracking of the IOVA we program in
the device, and offer a generic infrastructure for this instead of
hiding it in the MSI controller drivers.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
