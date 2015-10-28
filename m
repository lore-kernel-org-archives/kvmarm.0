From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC] vfio/type1: handle case where IOMMU does not support
 PAGE_SIZE size
Date: Wed, 28 Oct 2015 18:17:53 +0100
Message-ID: <56310341.7010307@linaro.org>
References: <1446037965-2341-1-git-send-email-eric.auger@linaro.org>
 <1446049648.8018.397.camel@redhat.com> <20151028171410.GK18966@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7ABF41294
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 13:15:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vbvX5UkrOum6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2015 13:15:01 -0400 (EDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
 [209.85.212.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 78935411BE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 13:15:01 -0400 (EDT)
Received: by wicfv8 with SMTP id fv8so21085811wic.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 10:17:55 -0700 (PDT)
In-Reply-To: <20151028171410.GK18966@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Will,
On 10/28/2015 06:14 PM, Will Deacon wrote:
> On Wed, Oct 28, 2015 at 10:27:28AM -0600, Alex Williamson wrote:
>> On Wed, 2015-10-28 at 13:12 +0000, Eric Auger wrote:
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 57d8c37..13fb974 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -403,7 +403,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>>  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>>  {
>>>  	struct vfio_domain *domain;
>>> -	unsigned long bitmap = PAGE_MASK;
>>> +	unsigned long bitmap = ULONG_MAX;
>>
>> Isn't this and removing the WARN_ON()s the only real change in this
>> patch?  The rest looks like conversion to use IS_ALIGNED and the
>> following test, that I don't really understand...
>>
>>>  
>>>  	mutex_lock(&iommu->lock);
>>>  	list_for_each_entry(domain, &iommu->domain_list, next)
>>> @@ -416,20 +416,18 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>>  			     struct vfio_iommu_type1_dma_unmap *unmap)
>>>  {
>>> -	uint64_t mask;
>>>  	struct vfio_dma *dma;
>>>  	size_t unmapped = 0;
>>>  	int ret = 0;
>>> +	unsigned int min_pagesz = __ffs(vfio_pgsize_bitmap(iommu));
>>> +	unsigned int requested_alignment = (min_pagesz < PAGE_SIZE) ?
>>> +						PAGE_SIZE : min_pagesz;
>>
>> This one.  If we're going to support sub-PAGE_SIZE mappings, why do we
>> care to cap alignment at PAGE_SIZE?
> 
> Eric can clarify, but I think the intention here is to have VFIO continue
> doing things in PAGE_SIZE chunks precisely so that we don't have to rework
> all of the pinning code etc.
That's my intention indeed ;-)

Thanks

Eric
 The IOMMU API can then deal with the smaller
> page size.

> 
>>> -	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
>>> -
>>> -	if (unmap->iova & mask)
>>> +	if (!IS_ALIGNED(unmap->iova, requested_alignment))
>>>  		return -EINVAL;
>>> -	if (!unmap->size || unmap->size & mask)
>>> +	if (!unmap->size || !IS_ALIGNED(unmap->size, requested_alignment))
>>>  		return -EINVAL;
>>>  
>>> -	WARN_ON(mask & PAGE_MASK);
>>> -
>>>  	mutex_lock(&iommu->lock);
>>>  
>>>  	/*
>>> @@ -553,25 +551,24 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>  	size_t size = map->size;
>>>  	long npage;
>>>  	int ret = 0, prot = 0;
>>> -	uint64_t mask;
>>>  	struct vfio_dma *dma;
>>>  	unsigned long pfn;
>>> +	unsigned int min_pagesz = __ffs(vfio_pgsize_bitmap(iommu));
>>> +	unsigned int requested_alignment = (min_pagesz < PAGE_SIZE) ?
>>> +						PAGE_SIZE : min_pagesz;
>>>  
>>>  	/* Verify that none of our __u64 fields overflow */
>>>  	if (map->size != size || map->vaddr != vaddr || map->iova != iova)
>>>  		return -EINVAL;
>>>  
>>> -	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
>>> -
>>> -	WARN_ON(mask & PAGE_MASK);
>>> -
>>>  	/* READ/WRITE from device perspective */
>>>  	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
>>>  		prot |= IOMMU_WRITE;
>>>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>>>  		prot |= IOMMU_READ;
>>>  
>>> -	if (!prot || !size || (size | iova | vaddr) & mask)
>>> +	if (!prot || !size ||
>>> +		!IS_ALIGNED(size | iova | vaddr, requested_alignment))
>>>  		return -EINVAL;
>>>  
>>>  	/* Don't allow IOVA or virtual address wrap */
>>
>> This is mostly ignoring the problems with sub-PAGE_SIZE mappings.  For
>> instance, we can only pin on PAGE_SIZE and therefore we only do
>> accounting on PAGE_SIZE, so if the user does 4K mappings across your 64K
>> page, that page gets pinned and accounted 16 times.  Are we going to
>> tell users that their locked memory limit needs to be 16x now?  The rest
>> of the code would need an audit as well to see what other sub-page bugs
>> might be hiding.  Thanks,
> 
> I don't see that. The pinning all happens the same in VFIO, which can
> then happily pass a 64k region to iommu_map. iommu_map will then call
> ->map in 4k chunks on the IOMMU driver ops.
> 
> Will
> 
