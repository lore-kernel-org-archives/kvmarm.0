From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS condition
Date: Mon, 2 Mar 2015 17:24:44 +0000
Message-ID: <20150302172444.GB7919@arm.com>
References: <1425315442-29584-1-git-send-email-b.reynal@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1425315442-29584-1-git-send-email-b.reynal@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baptiste Reynal <b.reynal@virtualopensystems.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "tech@virtualopensystems.com" <tech@virtualopensystems.com>, Joerg Roedel <joro@8bytes.org>, "moderated list:ARM SMMU DRIVER" <linux-arm-kernel@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 02, 2015 at 04:57:22PM +0000, Baptiste Reynal wrote:
> This patch is a fix to "iommu/arm-smmu: add support for iova_to_phys
> through ATS1PR".
> According to ARM documentation, translation registers are optional even
> in SMMUv1, so ID0_S1TS needs to be checked to verify their presence.
> 
> Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>
> ---
>  drivers/iommu/arm-smmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
> index fc13dd5..d4beca4 100644
> --- a/drivers/iommu/arm-smmu.c
> +++ b/drivers/iommu/arm-smmu.c
> @@ -1556,7 +1556,7 @@ static int arm_smmu_device_cfg_probe(struct arm_smmu_device *smmu)
>  		return -ENODEV;
>  	}
>  
> -	if (smmu->version == 1 || (!(id & ID0_ATOSNS) && (id & ID0_S1TS))) {
> +	if ((id & ID0_S1TS) && ((smmu->version == 1) || (id & ID0_ATOSNS))) {
>  		smmu->features |= ARM_SMMU_FEAT_TRANS_OPS;
>  		dev_notice(smmu->dev, "\taddress translation ops\n");

I'm not sure this is a complete fix. Shouldn't we also check that the domain
is a stage-1 domain in arm_smmu_iova_to_phys? (potential fixup below).

Will

--->8

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index fc13dd56953e..107163295cbc 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1288,12 +1288,15 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
                return 0;
 
        spin_lock_irqsave(&smmu_domain->pgtbl_lock, flags);
-       if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS)
+
+       if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS &&
+           smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
                ret = arm_smmu_iova_to_phys_hard(domain, iova);
-       else
+       } else {
                ret = ops->iova_to_phys(ops, iova);
-       spin_unlock_irqrestore(&smmu_domain->pgtbl_lock, flags);
+       }
 
+       spin_unlock_irqrestore(&smmu_domain->pgtbl_lock, flags);
        return ret;
 }
 
