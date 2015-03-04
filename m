From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS
	condition
Date: Wed, 4 Mar 2015 18:32:58 +0000
Message-ID: <20150304183258.GN17250@arm.com>
References: <1425484266-5449-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1425484266-5449-1-git-send-email-b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
Cc: open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org" <tech-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>, "moderated list:ARM SMMU DRIVER" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 04, 2015 at 03:51:06PM +0000, Baptiste Reynal wrote:
> This patch is a fix to "iommu/arm-smmu: add support for iova_to_phys
> through ATS1PR".
> According to ARM documentation, translation registers are optional even
> in SMMUv1, so ID0_S1TS needs to be checked to verify their presence.
> Also, we check that the domain is a stage-1 domain.
> 
> Signed-off-by: Baptiste Reynal <b.reynal-lrHrjnjw1UfHK3s98zE1ajGjJy/sRE9J@public.gmane.org>
> 
> ---
> v1 -> v2:
> Add domain stage test (Thanks to Will Deacon)
> 
> ---
>  drivers/iommu/arm-smmu.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index fc13dd5..a3adde6 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1288,10 +1288,13 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
>  		return 0;
>  
>  	spin_lock_irqsave(&smmu_domain->pgtbl_lock, flags);
> -	if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS)
> +	if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS &&
> +			smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>  		ret = arm_smmu_iova_to_phys_hard(domain, iova);
> -	else
> +	} else {
>  		ret = ops->iova_to_phys(ops, iova);
> +	}
> +
>  	spin_unlock_irqrestore(&smmu_domain->pgtbl_lock, flags);
>  
>  	return ret;
> @@ -1556,7 +1559,7 @@ static int arm_smmu_device_cfg_probe(struct arm_smmu_device *smmu)
>  		return -ENODEV;
>  	}
>  
> -	if (smmu->version == 1 || (!(id & ID0_ATOSNS) && (id & ID0_S1TS))) {
> +	if ((id & ID0_S1TS) && ((smmu->version == 1) || (id & ID0_ATOSNS))) {
>  		smmu->features |= ARM_SMMU_FEAT_TRANS_OPS;
>  		dev_notice(smmu->dev, "\taddress translation ops\n");

Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>

Sorry Joerg, but this is the latest in the drip of ARM SMMU fixes for
4.0! Please pick it up with the rest.

Will
