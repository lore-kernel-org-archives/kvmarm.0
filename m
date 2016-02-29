From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v4 09/14] msi: IOMMU map the doorbell address when needed
Date: Mon, 29 Feb 2016 16:27:13 +0100
Message-ID: <56D46351.5060701@linaro.org>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
	<1456508154-2253-10-git-send-email-eric.auger@linaro.org>
	<alpine.DEB.2.11.1602261907050.3638@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1602261907050.3638@nanos>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: eric.auger-qxv4g6HH51o@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Thomas,
On 02/26/2016 07:19 PM, Thomas Gleixner wrote:
> On Fri, 26 Feb 2016, Eric Auger wrote:
>> +static int msi_map_doorbell(struct iommu_domain *d, struct msi_msg *msg)
>> +{
>> +#ifdef CONFIG_IOMMU_DMA_RESERVED
>> +	dma_addr_t iova;
>> +	phys_addr_t addr;
>> +	int ret;
>> +
>> +#ifdef CONFIG_PHYS_ADDR_T_64BIT
>> +	addr = ((phys_addr_t)(msg->address_hi) << 32) | msg->address_lo;
>> +#else
>> +	addr = msg->address_lo;
>> +#endif
>> +
>> +	ret = iommu_get_single_reserved(d, addr, IOMMU_WRITE, &iova);
>> +	if (!ret) {
>> +		msg->address_lo = lower_32_bits(iova);
>> +		msg->address_hi = upper_32_bits(iova);
>> +	}
>> +	return ret;
>> +#else
>> +	return -ENODEV;
>> +#endif
> 
> This is completely unreadable. Please make this in a way which is parseable.
> A few small inline functions do the trick.
OK I will rewrite this.
> 
>> +static void msi_unmap_doorbell(struct iommu_domain *d, struct msi_msg *msg)
>> +{
>> +#ifdef CONFIG_IOMMU_DMA_RESERVED
>> +	dma_addr_t iova;
>> +
>> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>> +	iova = ((dma_addr_t)(msg->address_hi) << 32) | msg->address_lo;
>> +#else
>> +	iova = msg->address_lo;
>> +#endif
>> +
>> +	iommu_put_single_reserved(d, iova);
>> +#endif
> 
> Ditto.
ok
> 
>> +}
>> +
>> +#ifdef CONFIG_IOMMU_API
>> +static struct iommu_domain *
>> +	irq_data_to_msi_mapping_domain(struct irq_data *irq_data)
> 
> If you split lines, then the function name starts at the beginning of the line
> and not at some randome place.
ok
> 
>> +{
>> +
>> +	struct msi_desc *desc;
>> +	struct device *dev;
>> +	struct iommu_domain *d;
>> +	int ret;
> 
> Please order variables by descending length
ok
> 
>> +	desc = irq_data_get_msi_desc(irq_data);
>> +	if (!desc)
>> +		return NULL;
>> +
>> +	dev = msi_desc_to_dev(desc);
>> +
>> +	d = iommu_get_domain_for_dev(dev);
>> +	if (!d)
>> +		return NULL;
>> +
>> +	ret = iommu_domain_get_attr(d, DOMAIN_ATTR_MSI_MAPPING, NULL);
>> +	if (!ret)
>> +		return d;
>> +	else
>> +		return NULL;
> 
> Does anyone except you understand the purpose of the function? Comments have
> been invented for a reason.
ok I will comment on the role of those functions.
> 
>> +}
>> +#else
>> +static inline iommu_domain *
>> +		irq_data_to_msi_mapping_domain(struct irq_data *irq_data)
>> +{
>> +	return NULL;
>> +}
>> +#endif /* CONFIG_IOMMU_API */
>> +
>> +static int msi_compose(struct irq_data *irq_data,
>> +		       struct msi_msg *msg, bool erase)
>> +{
>> +	struct msi_msg old_msg;
>> +	struct iommu_domain *d;
>> +	int ret = 0;
>> +
>> +	d = irq_data_to_msi_mapping_domain(irq_data);
>> +	if (unlikely(d))
>> +		get_cached_msi_msg(irq_data->irq, &old_msg);
>> +
>> +	if (erase)
>> +		memset(msg, 0, sizeof(*msg));
>> +	else
>> +		ret = irq_chip_compose_msi_msg(irq_data, msg);
>> +
>> +	if (!d)
>> +		goto out;
>> +
>> +	/* handle (re-)mapping of MSI doorbell */
>> +	if ((old_msg.address_lo != msg->address_lo) ||
>> +	    (old_msg.address_hi != msg->address_hi))
>> +		msi_unmap_doorbell(d, &old_msg);
>> +
>> +	if (!erase)
>> +		WARN_ON(msi_map_doorbell(d, msg));
>> +
>> +out:
>> +	return ret;
>> +}
> 
> No, this is not the way we do this. You replace existing functionality by some
> new fangled thing. which behaves differently.
> 
> This wants to be seperate patches, which first create a wrapper for
> irq_chip_compose_msi_msg() and then adds the new functionality to it including
> a proper explanation.
> 
> I have no idea how the above is supposed to be the same as the existing code
> for the non iommu case.
Sure I will decompose things and provide more explanation.

Thank you for your time.

Best Regards

Eric
> 
> Thanks,
> 
> 	tglx
> 
