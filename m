From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC v3 11/21] iommu/smmuv3: Implement cache_invalidate
Date: Fri, 11 Jan 2019 16:59:55 +0000
Message-ID: <ee098c32-4c1f-90fe-eba3-b0e16995bacd@arm.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
 <20190108102633.17482-12-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108102633.17482-12-eric.auger@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, peter.maydell@linaro.org, kevin.tian@intel.com, ashok.raj@intel.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On 08/01/2019 10:26, Eric Auger wrote:
> Implement IOMMU_INV_TYPE_TLB invalidations. When
> nr_pages is null we interpret this as a context
> invalidation.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> The user API needs to be refined to discriminate context
> invalidations from NH_VA invalidations. Also the leaf attribute
> is not yet properly handled.
> 
> v2 -> v3:
> - replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync
> 
> v1 -> v2:
> - properly pass the asid
> ---
>  drivers/iommu/arm-smmu-v3.c | 40 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index 0e006babc8a6..ca72e0ce92f6 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -2293,6 +2293,45 @@ static int arm_smmu_set_pasid_table(struct iommu_domain *domain,
>  	return ret;
>  }
>  
> +static int
> +arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
> +			  struct iommu_cache_invalidate_info *inv_info)
> +{
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = smmu_domain->smmu;
> +
> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -EINVAL;
> +
> +	if (!smmu)
> +		return -EINVAL;
> +
> +	switch (inv_info->hdr.type) {
> +	case IOMMU_INV_TYPE_TLB:
> +		/*
> +		 * TODO: On context invalidation, the userspace sets nr_pages
> +		 * to 0. Refine the API to add a dedicated flags and also
> +		 * properly handle the leaf parameter.
> +		 */

That's what inv->granularity is for: if inv->granularity is PASID_SEL,
then the invalidation is for the whole context (and nr_pages, size,
addr, etc. should be ignored). If inv->granularity is PAGE_PASID, then
it's a range. The names could probably be improved but it's already in
the API

Thanks,
Jean

> +		if (!inv_info->nr_pages) {
> +			smmu_domain->s1_cfg.cd.asid = inv_info->arch_id;
> +			arm_smmu_tlb_inv_context(smmu_domain);
> +		} else {
> +			size_t granule = 1 << (inv_info->size + 12);
> +			size_t size = inv_info->nr_pages * granule;
> +
> +			smmu_domain->s1_cfg.cd.asid = inv_info->arch_id;
> +			arm_smmu_tlb_inv_range_nosync(inv_info->addr, size,
> +						      granule, false,
> +						      smmu_domain);
> +			arm_smmu_cmdq_issue_sync(smmu);
> +		}
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static struct iommu_ops arm_smmu_ops = {
>  	.capable		= arm_smmu_capable,
>  	.domain_alloc		= arm_smmu_domain_alloc,
> @@ -2312,6 +2351,7 @@ static struct iommu_ops arm_smmu_ops = {
>  	.get_resv_regions	= arm_smmu_get_resv_regions,
>  	.put_resv_regions	= arm_smmu_put_resv_regions,
>  	.set_pasid_table	= arm_smmu_set_pasid_table,
> +	.cache_invalidate	= arm_smmu_cache_invalidate,
>  	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
>  };
>  
> 
