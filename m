From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] vfio/type1: handle case where IOMMU does not support
 PAGE_SIZE size
Date: Thu, 29 Oct 2015 17:36:07 +0000
Message-ID: <20151029173607.GH3440@arm.com>
References: <1446127185-2096-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446127185-2096-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, alex.williamson@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, suravee.suthikulpanit@amd.com, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 29, 2015 at 01:59:45PM +0000, Eric Auger wrote:
> Current vfio_pgsize_bitmap code hides the supported IOMMU page
> sizes smaller than PAGE_SIZE. As a result, in case the IOMMU
> does not support PAGE_SIZE page, the alignment check on map/unmap
> is done with larger page sizes, if any. This can fail although
> mapping could be done with pages smaller than PAGE_SIZE.
> 
> This patch modifies vfio_pgsize_bitmap implementation so that,
> in case the IOMMU supports page sizes smaller than PAGE_HOST
> we pretend PAGE_HOST is supported and hide sub-PAGE_HOST sizes.
> That way the user will be able to map/unmap buffers whose size/
> start address is aligned with PAGE_HOST. Pinning code uses that
> granularity while iommu driver can use the sub-PAGE_HOST size
> to map the buffer.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> 
> ---
> 
> This was tested on AMD Seattle with 64kB page host. ARM MMU 401
> currently expose 4kB, 2MB and 1GB page support. With a 64kB page host,
> the map/unmap check is done against 2MB. Some alignment check fail
> so VFIO_IOMMU_MAP_DMA fail while we could map using 4kB IOMMU page
> size.
> 
> RFC -> PATCH v1:
> - move all modifications in vfio_pgsize_bitmap following Alex'
>   suggestion to expose a fake PAGE_HOST support
> - restore WARN_ON's
> ---
>  drivers/vfio/vfio_iommu_type1.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 57d8c37..cee504a 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -403,13 +403,26 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>  {
>  	struct vfio_domain *domain;
> -	unsigned long bitmap = PAGE_MASK;
> +	unsigned long bitmap = ULONG_MAX;
>  
>  	mutex_lock(&iommu->lock);
>  	list_for_each_entry(domain, &iommu->domain_list, next)
>  		bitmap &= domain->domain->ops->pgsize_bitmap;
>  	mutex_unlock(&iommu->lock);
>  
> +	/*
> +	 * In case the IOMMU supports page sizes smaller than PAGE_HOST
> +	 * we pretend PAGE_HOST is supported and hide sub-PAGE_HOST sizes.
> +	 * That way the user will be able to map/unmap buffers whose size/
> +	 * start address is aligned with PAGE_HOST. Pinning code uses that
> +	 * granularity while iommu driver can use the sub-PAGE_HOST size
> +	 * to map the buffer.
> +	 */
> +	if (bitmap & ~PAGE_MASK) {
> +		bitmap &= PAGE_MASK;
> +		bitmap |= PAGE_SIZE;
> +	}
> +

s/PAGE_HOST/PAGE_SIZE/g (in the cover-letter too) and then I think this
looks good:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
