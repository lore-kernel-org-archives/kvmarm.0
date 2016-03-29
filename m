From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v5 06/17] dma-reserved-iommu: iommu_get/put_single_reserved
Date: Tue, 29 Mar 2016 19:07:34 +0200
Message-ID: <56FAB656.7030400@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
	<1456856877-4817-7-git-send-email-eric.auger@linaro.org>
	<20160310115253.GA14609@e106794-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20160310115253.GA14609-lfHAr0XZR/HZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Jean-Philippe Brucker <Jean-Philippe.Brucker-5wv7dgnIgG8@public.gmane.org>
Cc: eric.auger-qxv4g6HH51o@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jean-Philippe,
On 03/10/2016 12:52 PM, Jean-Philippe Brucker wrote:
> Hi Eric,
> 
> On Tue, Mar 01, 2016 at 06:27:46PM +0000, Eric Auger wrote:
>> [...]
>> +
>> +int iommu_get_single_reserved(struct iommu_domain *domain,
>> +			      phys_addr_t addr, int prot,
>> +			      dma_addr_t *iova)
>> +{
>> +	unsigned long order = __ffs(domain->ops->pgsize_bitmap);
>> +	size_t page_size = 1 << order;
>> +	phys_addr_t mask = page_size - 1;
>> +	phys_addr_t aligned_addr = addr & ~mask;
>> +	phys_addr_t offset  = addr - aligned_addr;
>> +	struct iommu_reserved_binding *b;
>> +	struct iova *p_iova;
>> +	struct iova_domain *iovad =
>> +		(struct iova_domain *)domain->reserved_iova_cookie;
>> +	int ret;
>> +
>> +	if (!iovad)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&domain->reserved_mutex);
> 
> I believe this function could get called from the chunk of __setup_irq
> that is executed atomically:
> 
>     * request_threaded_irq
>     * __setup_irq
>     * irq_startup
>     * irq_domain_activate_irq
>     * msi_domain_activate
>     * msi_compose
>     * iommu_get_single_reserved
> 
> If this is the case, we should probably use a spinlock to protect the
> iova_domain...
Please apologize for the delay, I was in vacation.
Thank you for spotting this flow. I will rework the locking.
> 
>> +
>> +	b = find_reserved_binding(domain, aligned_addr, page_size);
>> +	if (b) {
>> +		*iova = b->iova + offset;
>> +		kref_get(&b->kref);
>> +		ret = 0;
>> +		goto unlock;
>> +	}
>> +
>> +	/* there is no existing reserved iova for this pa */
>> +	p_iova = alloc_iova(iovad, 1, iovad->dma_32bit_pfn, true);
>> +	if (!p_iova) {
>> +		ret = -ENOMEM;
>> +		goto unlock;
>> +	}
>> +	*iova = p_iova->pfn_lo << order;
>> +
>> +	b = kzalloc(sizeof(*b), GFP_KERNEL);
> 
> ... and GFP_ATOMIC here.
OK

Thank you for your time!

Best Regards

Eric
> 
> Thanks,
> Jean-Philippe
> 
>> +	if (!b) {
>> +		ret = -ENOMEM;
>> +		goto free_iova_unlock;
>> +	}
>> +
>> +	ret = iommu_map(domain, *iova, aligned_addr, page_size, prot);
>> +	if (ret)
>> +		goto free_binding_iova_unlock;
>> +
>> +	kref_init(&b->kref);
>> +	kref_get(&b->kref);
>> +	b->domain = domain;
>> +	b->addr = aligned_addr;
>> +	b->iova = *iova;
>> +	b->size = page_size;
>> +
>> +	link_reserved_binding(domain, b);
>> +
>> +	*iova += offset;
>> +	goto unlock;
>> +
>> +free_binding_iova_unlock:
>> +	kfree(b);
>> +free_iova_unlock:
>> +	free_iova(iovad, *iova >> order);
>> +unlock:
>> +	mutex_unlock(&domain->reserved_mutex);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_get_single_reserved);
