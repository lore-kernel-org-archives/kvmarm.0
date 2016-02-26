From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC v4 09/14] msi: IOMMU map the doorbell address when needed
Date: Fri, 26 Feb 2016 19:19:45 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1602261907050.3638@nanos>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
 <1456508154-2253-10-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C73C411AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 13:14:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6Qxs5YWEnpVw for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 13:14:20 -0500 (EST)
Received: from Galois.linutronix.de (www.linutronix.de [62.245.132.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25246410D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 13:14:19 -0500 (EST)
In-Reply-To: <1456508154-2253-10-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, jason@lakedaemon.net, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, Manish.Jaggi@caviumnetworks.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 26 Feb 2016, Eric Auger wrote:
> +static int msi_map_doorbell(struct iommu_domain *d, struct msi_msg *msg)
> +{
> +#ifdef CONFIG_IOMMU_DMA_RESERVED
> +	dma_addr_t iova;
> +	phys_addr_t addr;
> +	int ret;
> +
> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
> +	addr = ((phys_addr_t)(msg->address_hi) << 32) | msg->address_lo;
> +#else
> +	addr = msg->address_lo;
> +#endif
> +
> +	ret = iommu_get_single_reserved(d, addr, IOMMU_WRITE, &iova);
> +	if (!ret) {
> +		msg->address_lo = lower_32_bits(iova);
> +		msg->address_hi = upper_32_bits(iova);
> +	}
> +	return ret;
> +#else
> +	return -ENODEV;
> +#endif

This is completely unreadable. Please make this in a way which is parseable.
A few small inline functions do the trick.

> +static void msi_unmap_doorbell(struct iommu_domain *d, struct msi_msg *msg)
> +{
> +#ifdef CONFIG_IOMMU_DMA_RESERVED
> +	dma_addr_t iova;
> +
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> +	iova = ((dma_addr_t)(msg->address_hi) << 32) | msg->address_lo;
> +#else
> +	iova = msg->address_lo;
> +#endif
> +
> +	iommu_put_single_reserved(d, iova);
> +#endif

Ditto.

> +}
> +
> +#ifdef CONFIG_IOMMU_API
> +static struct iommu_domain *
> +	irq_data_to_msi_mapping_domain(struct irq_data *irq_data)

If you split lines, then the function name starts at the beginning of the line
and not at some randome place.

> +{
> +
> +	struct msi_desc *desc;
> +	struct device *dev;
> +	struct iommu_domain *d;
> +	int ret;

Please order variables by descending length

> +	desc = irq_data_get_msi_desc(irq_data);
> +	if (!desc)
> +		return NULL;
> +
> +	dev = msi_desc_to_dev(desc);
> +
> +	d = iommu_get_domain_for_dev(dev);
> +	if (!d)
> +		return NULL;
> +
> +	ret = iommu_domain_get_attr(d, DOMAIN_ATTR_MSI_MAPPING, NULL);
> +	if (!ret)
> +		return d;
> +	else
> +		return NULL;

Does anyone except you understand the purpose of the function? Comments have
been invented for a reason.

> +}
> +#else
> +static inline iommu_domain *
> +		irq_data_to_msi_mapping_domain(struct irq_data *irq_data)
> +{
> +	return NULL;
> +}
> +#endif /* CONFIG_IOMMU_API */
> +
> +static int msi_compose(struct irq_data *irq_data,
> +		       struct msi_msg *msg, bool erase)
> +{
> +	struct msi_msg old_msg;
> +	struct iommu_domain *d;
> +	int ret = 0;
> +
> +	d = irq_data_to_msi_mapping_domain(irq_data);
> +	if (unlikely(d))
> +		get_cached_msi_msg(irq_data->irq, &old_msg);
> +
> +	if (erase)
> +		memset(msg, 0, sizeof(*msg));
> +	else
> +		ret = irq_chip_compose_msi_msg(irq_data, msg);
> +
> +	if (!d)
> +		goto out;
> +
> +	/* handle (re-)mapping of MSI doorbell */
> +	if ((old_msg.address_lo != msg->address_lo) ||
> +	    (old_msg.address_hi != msg->address_hi))
> +		msi_unmap_doorbell(d, &old_msg);
> +
> +	if (!erase)
> +		WARN_ON(msi_map_doorbell(d, msg));
> +
> +out:
> +	return ret;
> +}

No, this is not the way we do this. You replace existing functionality by some
new fangled thing. which behaves differently.

This wants to be seperate patches, which first create a wrapper for
irq_chip_compose_msi_msg() and then adds the new functionality to it including
a proper explanation.

I have no idea how the above is supposed to be the same as the existing code
for the non iommu case.

Thanks,

	tglx
