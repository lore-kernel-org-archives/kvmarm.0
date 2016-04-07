From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v6 6/7] dma-reserved-iommu: iommu_get/put_single_reserved
Date: Thu, 7 Apr 2016 18:44:56 +0200
Message-ID: <57068E88.6040506@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
 <1459757222-2668-7-git-send-email-eric.auger@linaro.org>
 <20160406171207.750f1224@t450s.home> <57062976.8090900@linaro.org>
 <20160407143852.GA26432@e106794-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61EC640FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 12:44:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dfrNM+MOR6qJ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2016 12:44:46 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DE85407A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2016 12:44:45 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id f198so33383814wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2016 09:46:10 -0700 (PDT)
In-Reply-To: <20160407143852.GA26432@e106794-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jean-Philippe Brucker <Jean-Philippe.Brucker@arm.com>
Cc: eric.auger@st.com, jason@lakedaemon.net, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, joro@8bytes.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, Manish.Jaggi@caviumnetworks.com, Alex Williamson <alex.williamson@redhat.com>, linux-arm-kernel@lists.infradead.org, tglx@linutronix.de, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 04/07/2016 04:38 PM, Jean-Philippe Brucker wrote:
> Hi Eric,
> 
> On Thu, Apr 07, 2016 at 11:33:42AM +0200, Eric Auger wrote:
>> Alex,
>> On 04/07/2016 01:12 AM, Alex Williamson wrote:
>>> On Mon,  4 Apr 2016 08:07:01 +0000
>>> Eric Auger <eric.auger@linaro.org> wrote:
>>>
>>>> This patch introduces iommu_get/put_single_reserved.
>>>>
>>>> iommu_get_single_reserved allows to allocate a new reserved iova page
>>>> and map it onto the physical page that contains a given physical address.
>>>> Page size is the IOMMU page one. It is the responsability of the
>>>> system integrator to make sure the in use IOMMU page size corresponds
>>>> to the granularity of the MSI frame.
>>>>
>>>> It returns the iova that is mapped onto the provided physical address.
>>>> Hence the physical address passed in argument does not need to be aligned.
>>>>
>>>> In case a mapping already exists between both pages, the IOVA mapped
>>>> to the PA is directly returned.
>>>>
>>>> Each time an iova is successfully returned a binding ref count is
>>>> incremented.
>>>>
>>>> iommu_put_single_reserved decrements the ref count and when this latter
>>>> is null, the mapping is destroyed and the iova is released.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>> Signed-off-by: Ankit Jindal <ajindal@apm.com>
>>>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
>>>> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
>>>>
>>>> ---
>>>>
>>>> v5 -> v6:
>>>> - revisit locking with spin_lock instead of mutex
>>>> - do not kref_get on 1st get
>>>> - add size parameter to the get function following Marc's request
>>>> - use the iova domain shift instead of using the smallest supported page size
>>>>
>>>> v3 -> v4:
>>>> - formerly in iommu: iommu_get/put_single_reserved &
>>>>   iommu/arm-smmu: implement iommu_get/put_single_reserved
>>>> - Attempted to address Marc's doubts about missing size/alignment
>>>>   at VFIO level (user-space knows the IOMMU page size and the number
>>>>   of IOVA pages to provision)
>>>>
>>>> v2 -> v3:
>>>> - remove static implementation of iommu_get_single_reserved &
>>>>   iommu_put_single_reserved when CONFIG_IOMMU_API is not set
>>>>
>>>> v1 -> v2:
>>>> - previously a VFIO API, named vfio_alloc_map/unmap_free_reserved_iova
>>>> ---
>>>>  drivers/iommu/dma-reserved-iommu.c | 146 +++++++++++++++++++++++++++++++++++++
>>>>  include/linux/dma-reserved-iommu.h |  28 +++++++
>>>>  2 files changed, 174 insertions(+)
>>>>
>>>> diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
>>>> index f592118..3c759d9 100644
>>>> --- a/drivers/iommu/dma-reserved-iommu.c
>>>> +++ b/drivers/iommu/dma-reserved-iommu.c
>>>> @@ -136,3 +136,149 @@ void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
>>>>  	spin_unlock_irqrestore(&domain->reserved_lock, flags);
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(iommu_free_reserved_iova_domain);
>>>> +
>>>> +static void delete_reserved_binding(struct iommu_domain *domain,
>>>> +				    struct iommu_reserved_binding *b)
>>>> +{
>>>> +	struct iova_domain *iovad =
>>>> +		(struct iova_domain *)domain->reserved_iova_cookie;
>>>> +	unsigned long order = iova_shift(iovad);
>>>> +
>>>> +	iommu_unmap(domain, b->iova, b->size);
>>>> +	free_iova(iovad, b->iova >> order);
>>>> +	kfree(b);
>>>> +}
>>>> +
>>>> +int iommu_get_reserved_iova(struct iommu_domain *domain,
>>>> +			      phys_addr_t addr, size_t size, int prot,
>>>> +			      dma_addr_t *iova)
>>>> +{
>>>> +	struct iova_domain *iovad =
>>>> +		(struct iova_domain *)domain->reserved_iova_cookie;
>>>> +	unsigned long order = iova_shift(iovad);
> 
> Another nit: this call should be after the !iovad check belo

Yes definitively
> 
>>>> +	unsigned long  base_pfn, end_pfn, nb_iommu_pages;
>>>> +	size_t iommu_page_size = 1 << order, binding_size;
>>>> +	phys_addr_t aligned_base, offset;
>>>> +	struct iommu_reserved_binding *b, *newb;
>>>> +	unsigned long flags;
>>>> +	struct iova *p_iova;
>>>> +	bool unmap = false;
>>>> +	int ret;
>>>> +
>>>> +	base_pfn = addr >> order;
>>>> +	end_pfn = (addr + size - 1) >> order;
>>>> +	nb_iommu_pages = end_pfn - base_pfn + 1;
>>>> +	aligned_base = base_pfn << order;
>>>> +	offset = addr - aligned_base;
>>>> +	binding_size = nb_iommu_pages * iommu_page_size;
>>>> +
>>>> +	if (!iovad)
>>>> +		return -EINVAL;
>>>> +
>>>> +	spin_lock_irqsave(&domain->reserved_lock, flags);
>>>> +
>>>> +	b = find_reserved_binding(domain, aligned_base, binding_size);
>>>> +	if (b) {
>>>> +		*iova = b->iova + offset;
>>>> +		kref_get(&b->kref);
>>>> +		ret = 0;
>>>> +		goto unlock;
>>>> +	}
>>>> +
>>>> +	spin_unlock_irqrestore(&domain->reserved_lock, flags);
>>>> +
>>>> +	/*
>>>> +	 * no reserved IOVA was found for this PA, start allocating and
>>>> +	 * registering one while the spin-lock is not held. iommu_map/unmap
>>>> +	 * are not supposed to be atomic
>>>> +	 */
>>>> +
>>>> +	p_iova = alloc_iova(iovad, nb_iommu_pages, iovad->dma_32bit_pfn, true);
>>>> +	if (!p_iova)
>>>> +		return -ENOMEM;
>>>
>>> Here we're using iovad, which was the reserved_iova_cookie outside of
>>> the locking, which makes the locking ineffective.  Isn't this lock also
>>> protecting our iova domain, I'm confused.
>> I think I was too when I wrote that :-(
>>>
>>>> +
>>>> +	*iova = iova_dma_addr(iovad, p_iova);
>>>> +
>>>> +	newb = kzalloc(sizeof(*b), GFP_KERNEL);
>> needs to to be GPF_ATOMIC as Jean-Philippe stated before.
>>>> +	if (!newb) {
>>>> +		free_iova(iovad, p_iova->pfn_lo);
>>>> +		return -ENOMEM;
>>>> +	}
>>>> +
>>>> +	ret = iommu_map(domain, *iova, aligned_base, binding_size, prot);
>> one problem I have is I would need iommu_map to be atomic (because of
>> the call sequence reported by Jean-Philippe) and I have no guarantee it
>> is in general I think . It is for arm-smmu(-v3).c which covers the ARM
>> use case. But what about other smmus potentially used in that process?
> 
> Hmm, indeed. How about we move all the heavy mapping work to
> msi_domain_prepare_irqs instead? It is allowed to sleep and, more
> importantly, fail. It is called much earlier, by pci_enable_msi_range.

Indeed this could be an option for setup.

However a substitute to msi_domain_set_affinity should also be found I
think, to handle a change in affinity (which can change the doorbell):

We have this path and irq_migrate_all_off_this_cpu takes the irq_desc
raw_spin_lock.

cpuhotplug.c:irq_migrate_all_off_this_cpu
cpuhotplug.c:migrate_one_irq
irq_do_set_affinity
chip->irq_set_affinity
msi_domain_set_affinity
../..
iommu_map/unmap

> 
> All we are missing is details about doorbells, which we could retrieve
> from the MSI controller's driver, using one or more additional callbacks
> in msi_domain_ops. Currently, we already need one such callbacks for
> querying the number of doorbell pages,
Yes currently I assume a single page per MSI controller which is
arbitrary. I can add such callback in my next version.

Thank you for your time

Eric
 maybe we could also ask the
> driver to provide their addresses? And in msi_domain_activate, simply
> search for the IOVA already associated with the MSI message?
> 
> I only briefly though about it from the host point of view, not sure how
> VFIO would cope with this method.
> 
> Thanks,
> Jean-Philippe
> 
