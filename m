From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC] vfio/type1: handle case where IOMMU does not support
 PAGE_SIZE size
Date: Wed, 28 Oct 2015 15:37:51 +0000
Message-ID: <20151028153750.GH18966@arm.com>
References: <1446037965-2341-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E619B41280
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 11:35:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vl42W2Bs2nha for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Oct 2015 11:35:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EB3A410D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Oct 2015 11:35:01 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1446037965-2341-1-git-send-email-eric.auger@linaro.org>
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
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 28, 2015 at 01:12:45PM +0000, Eric Auger wrote:
> Current vfio_pgsize_bitmap code hides the supported IOMMU page
> sizes smaller than PAGE_SIZE. As a result, in case the IOMMU
> does not support PAGE_SIZE page, the alignment check on map/unmap
> is done with larger page sizes, if any. This can fail although
> mapping could be done with pages smaller than PAGE_SIZE.
> 
> vfio_pgsize_bitmap is modified to expose the IOMMU page sizes,
> supported by all domains, even those smaller than PAGE_SIZE. The
> alignment check on map is performed against PAGE_SIZE if the minimum
> IOMMU size is less than PAGE_SIZE or against the min page size greater
> than PAGE_SIZE.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> This was tested on AMD Seattle with 64kB page host. ARM MMU 401
> currently expose 4kB, 2MB and 1GB page support. With a 64kB page host,
> the map/unmap check is done against 2MB. Some alignment check fail
> so VFIO_IOMMU_MAP_DMA fail while we could map using 4kB IOMMU page
> size.
> ---
>  drivers/vfio/vfio_iommu_type1.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 57d8c37..13fb974 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -403,7 +403,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>  {
>  	struct vfio_domain *domain;
> -	unsigned long bitmap = PAGE_MASK;
> +	unsigned long bitmap = ULONG_MAX;
>  
>  	mutex_lock(&iommu->lock);
>  	list_for_each_entry(domain, &iommu->domain_list, next)
> @@ -416,20 +416,18 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>  static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  			     struct vfio_iommu_type1_dma_unmap *unmap)
>  {
> -	uint64_t mask;
>  	struct vfio_dma *dma;
>  	size_t unmapped = 0;
>  	int ret = 0;
> +	unsigned int min_pagesz = __ffs(vfio_pgsize_bitmap(iommu));
> +	unsigned int requested_alignment = (min_pagesz < PAGE_SIZE) ?
> +						PAGE_SIZE : min_pagesz;

max_t ?

>  
> -	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> -
> -	if (unmap->iova & mask)
> +	if (!IS_ALIGNED(unmap->iova, requested_alignment))
>  		return -EINVAL;
> -	if (!unmap->size || unmap->size & mask)
> +	if (!unmap->size || !IS_ALIGNED(unmap->size, requested_alignment))
>  		return -EINVAL;
>  
> -	WARN_ON(mask & PAGE_MASK);
> -
>  	mutex_lock(&iommu->lock);
>  
>  	/*
> @@ -553,25 +551,24 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>  	size_t size = map->size;
>  	long npage;
>  	int ret = 0, prot = 0;
> -	uint64_t mask;
>  	struct vfio_dma *dma;
>  	unsigned long pfn;
> +	unsigned int min_pagesz = __ffs(vfio_pgsize_bitmap(iommu));
> +	unsigned int requested_alignment = (min_pagesz < PAGE_SIZE) ?
> +						PAGE_SIZE : min_pagesz;

Same code here. Perhaps you need another function to get the alignment?

Otherwise, this looks pretty straightforward to me; iommu_map will take
care of splitting up the requests to the IOMMU driver so they are in the
right chunks.

Will
