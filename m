From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 2/6] iommu: Add interface to get msi-pages mapping
 attributes
Date: Fri, 02 Oct 2015 16:45:48 -0600
Message-ID: <1443825948.26107.187.camel@redhat.com>
References: <1443624989-24346-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1443624989-24346-2-git-send-email-Bharat.Bhushan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443624989-24346-2-git-send-email-Bharat.Bhushan@freescale.com>
Sender: kvm-owner@vger.kernel.org
To: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, eric.auger@linaro.org, pranavkumar@linaro.org, marc.zyngier@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

[really ought to consider cc'ing the iommu list]

On Wed, 2015-09-30 at 20:26 +0530, Bharat Bhushan wrote:
> This APIs return the capability of automatically mapping msi-pages
> in iommu with some magic iova. Which is what currently most of
> iommu's does and is the default behaviour.
> 
> Further API returns whether iommu allows the user to define different
> iova for mai-page mapping for the domain. This is required when a msi
> capable device is directly assigned to user-space/VM and user-space/VM
> need to define a non-overlapping (from other dma-able address space)
> iova for msi-pages mapping in iommu.
> 
> This patch just define the interface and follow up patches will
> extend this interface.

This is backwards, generally you want to add the infrastructure and only
expose it once all the pieces are in place for it to work.  For
instance, patch 1/6 exposes a new userspace interface for vfio that
doesn't do anything yet.  How does the user know if it's there, *and*
works?

> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
> ---
>  drivers/iommu/arm-smmu.c        |  3 +++
>  drivers/iommu/fsl_pamu_domain.c |  3 +++
>  drivers/iommu/iommu.c           | 14 ++++++++++++++
>  include/linux/iommu.h           |  9 ++++++++-
>  4 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index 66a803b..a3956fb 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1406,6 +1406,9 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>  	case DOMAIN_ATTR_NESTING:
>  		*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
>  		return 0;
> +	case DOMAIN_ATTR_MSI_MAPPING:
> +		/* Dummy handling added */
> +		return 0;
>  	default:
>  		return -ENODEV;
>  	}
> diff --git a/drivers/iommu/fsl_pamu_domain.c b/drivers/iommu/fsl_pamu_domain.c
> index 1d45293..9a94430 100644
> --- a/drivers/iommu/fsl_pamu_domain.c
> +++ b/drivers/iommu/fsl_pamu_domain.c
> @@ -856,6 +856,9 @@ static int fsl_pamu_get_domain_attr(struct iommu_domain *domain,
>  	case DOMAIN_ATTR_FSL_PAMUV1:
>  		*(int *)data = DOMAIN_ATTR_FSL_PAMUV1;
>  		break;
> +	case DOMAIN_ATTR_MSI_MAPPING:
> +		/* Dummy handling added */
> +		break;
>  	default:
>  		pr_debug("Unsupported attribute type\n");
>  		ret = -EINVAL;
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index d4f527e..16c2eab 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1216,6 +1216,7 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
>  	bool *paging;
>  	int ret = 0;
>  	u32 *count;
> +	struct iommu_domain_msi_maps *msi_maps;
>  
>  	switch (attr) {
>  	case DOMAIN_ATTR_GEOMETRY:
> @@ -1236,6 +1237,19 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
>  			ret = -ENODEV;
>  
>  		break;
> +	case DOMAIN_ATTR_MSI_MAPPING:
> +		msi_maps = data;
> +
> +		/* Default MSI-pages are magically mapped with some iova and
> +		 * do now allow to configure with different iova.
> +		 */
> +		msi_maps->automap = true;
> +		msi_maps->override_automap = false;

There's no magic.  I think what you're trying to express is the
difference between platforms that support MSI within the IOMMU IOVA
space and thus need explicit IOMMU mappings vs platforms where MSI
mappings either bypass the IOMMU entirely or are setup implicitly with
interrupt remapping support.

Why does it make sense to impose any sort of defaults?  If the IOMMU
driver doesn't tell us what to do, I don't think we want to assume
anything.

> +
> +		if (domain->ops->domain_get_attr)
> +			ret = domain->ops->domain_get_attr(domain, attr, data);
> +
> +		break;
>  	default:
>  		if (!domain->ops->domain_get_attr)
>  			return -EINVAL;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 0546b87..6d49f3f 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -83,6 +83,13 @@ struct iommu_domain {
>  	struct iommu_domain_geometry geometry;
>  };
>  
> +struct iommu_domain_msi_maps {
> +	dma_addr_t base_address;
> +	dma_addr_t size;

size_t?

> +	bool automap;
> +	bool override_automap;
> +};
> +
>  enum iommu_cap {
>  	IOMMU_CAP_CACHE_COHERENCY,	/* IOMMU can enforce cache coherent DMA
>  					   transactions */
> @@ -111,6 +118,7 @@ enum iommu_attr {
>  	DOMAIN_ATTR_FSL_PAMU_ENABLE,
>  	DOMAIN_ATTR_FSL_PAMUV1,
>  	DOMAIN_ATTR_NESTING,	/* two stages of translation */
> +	DOMAIN_ATTR_MSI_MAPPING, /* Provides MSIs mapping in iommu */
>  	DOMAIN_ATTR_MAX,
>  };
>  
> @@ -167,7 +175,6 @@ struct iommu_ops {
>  	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
>  	/* Get the numer of window per domain */
>  	u32 (*domain_get_windows)(struct iommu_domain *domain);
> -
>  #ifdef CONFIG_OF_IOMMU
>  	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
>  #endif



