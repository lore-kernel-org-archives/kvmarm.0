From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC] vfio/type1: handle case where IOMMU does not support
 PAGE_SIZE size
Date: Wed, 28 Oct 2015 18:10:56 +0100
Message-ID: <563101A0.7020404@linaro.org>
References: <1446037965-2341-1-git-send-email-eric.auger@linaro.org>
 <1446049648.8018.397.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446049648.8018.397.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will.deacon@arm.com, suravee.suthikulpanit@amd.com, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 10/28/2015 05:27 PM, Alex Williamson wrote:
> On Wed, 2015-10-28 at 13:12 +0000, Eric Auger wrote:
>> Current vfio_pgsize_bitmap code hides the supported IOMMU page
>> sizes smaller than PAGE_SIZE. As a result, in case the IOMMU
>> does not support PAGE_SIZE page, the alignment check on map/unmap
>> is done with larger page sizes, if any. This can fail although
>> mapping could be done with pages smaller than PAGE_SIZE.
>>
>> vfio_pgsize_bitmap is modified to expose the IOMMU page sizes,
>> supported by all domains, even those smaller than PAGE_SIZE. The
>> alignment check on map is performed against PAGE_SIZE if the minimum
>> IOMMU size is less than PAGE_SIZE or against the min page size greater
>> than PAGE_SIZE.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> This was tested on AMD Seattle with 64kB page host. ARM MMU 401
>> currently expose 4kB, 2MB and 1GB page support. With a 64kB page host,
>> the map/unmap check is done against 2MB. Some alignment check fail
>> so VFIO_IOMMU_MAP_DMA fail while we could map using 4kB IOMMU page
>> size.
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 25 +++++++++++--------------
>>  1 file changed, 11 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 57d8c37..13fb974 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -403,7 +403,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>  {
>>  	struct vfio_domain *domain;
>> -	unsigned long bitmap = PAGE_MASK;
>> +	unsigned long bitmap = ULONG_MAX;
> 
> Isn't this and removing the WARN_ON()s the only real change in this
> patch?  The rest looks like conversion to use IS_ALIGNED and the
> following test, that I don't really understand...
Yes basically you're right.
> 
>>  
>>  	mutex_lock(&iommu->lock);
>>  	list_for_each_entry(domain, &iommu->domain_list, next)
>> @@ -416,20 +416,18 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>>  			     struct vfio_iommu_type1_dma_unmap *unmap)
>>  {
>> -	uint64_t mask;
>>  	struct vfio_dma *dma;
>>  	size_t unmapped = 0;
>>  	int ret = 0;
>> +	unsigned int min_pagesz = __ffs(vfio_pgsize_bitmap(iommu));
>> +	unsigned int requested_alignment = (min_pagesz < PAGE_SIZE) ?
>> +						PAGE_SIZE : min_pagesz;
> 
> This one.  If we're going to support sub-PAGE_SIZE mappings, why do we
> care to cap alignment at PAGE_SIZE?
My intent in this patch isn't to allow the user-space to map/unmap
sub-PAGE_SIZE buffers. The new test makes sure the mapped area is bigger
or equal than a host page whatever the supported page sizes.

I noticed that chunk construction, pinning and other many things are
based on PAGE_SIZE and far be it from me to change that code! I want to
keep that minimal granularity for all those computation.

However on iommu side, I would like to rely on the fact the iommu driver
is clever enough to choose the right page size and even to choose a size
that is smaller than PAGE_SIZE if this latter is not supported.
> 
>> -	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
>> -
>> -	if (unmap->iova & mask)
>> +	if (!IS_ALIGNED(unmap->iova, requested_alignment))
>>  		return -EINVAL;
>> -	if (!unmap->size || unmap->size & mask)
>> +	if (!unmap->size || !IS_ALIGNED(unmap->size, requested_alignment))
>>  		return -EINVAL;
>>  
>> -	WARN_ON(mask & PAGE_MASK);
>> -
>>  	mutex_lock(&iommu->lock);
>>  
>>  	/*
>> @@ -553,25 +551,24 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	size_t size = map->size;
>>  	long npage;
>>  	int ret = 0, prot = 0;
>> -	uint64_t mask;
>>  	struct vfio_dma *dma;
>>  	unsigned long pfn;
>> +	unsigned int min_pagesz = __ffs(vfio_pgsize_bitmap(iommu));
>> +	unsigned int requested_alignment = (min_pagesz < PAGE_SIZE) ?
>> +						PAGE_SIZE : min_pagesz;
>>  
>>  	/* Verify that none of our __u64 fields overflow */
>>  	if (map->size != size || map->vaddr != vaddr || map->iova != iova)
>>  		return -EINVAL;
>>  
>> -	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
>> -
>> -	WARN_ON(mask & PAGE_MASK);
>> -
>>  	/* READ/WRITE from device perspective */
>>  	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
>>  		prot |= IOMMU_WRITE;
>>  	if (map->flags & VFIO_DMA_MAP_FLAG_READ)
>>  		prot |= IOMMU_READ;
>>  
>> -	if (!prot || !size || (size | iova | vaddr) & mask)
>> +	if (!prot || !size ||
>> +		!IS_ALIGNED(size | iova | vaddr, requested_alignment))
>>  		return -EINVAL;
>>  
>>  	/* Don't allow IOVA or virtual address wrap */
> 
> This is mostly ignoring the problems with sub-PAGE_SIZE mappings.  For
> instance, we can only pin on PAGE_SIZE and therefore we only do
> accounting on PAGE_SIZE, so if the user does 4K mappings across your 64K
> page, that page gets pinned and accounted 16 times.  Are we going to
> tell users that their locked memory limit needs to be 16x now?  The rest
> of the code would need an audit as well to see what other sub-page bugs
> might be hiding.  Thanks,
So if the user is not allowed to map sub-PAGE_SIZE buffers, accounting
still is based on PAGE_SIZE while iommu mapping can be based on
sub-PAGE_SIZE pages. I am misunderstanding something?

Best Regards

Eric
> 
> Alex
> 
> 
> 
