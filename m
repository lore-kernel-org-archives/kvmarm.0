From: Baptiste Reynal <b.reynal@virtualopensystems.com>
Subject: [PATCH v2 1/1] iommu/arm-smmu: fix ARM_SMMU_FEAT_TRANS_OPS condition
Date: Wed,  4 Mar 2015 16:51:06 +0100
Message-ID: <1425484266-5449-1-git-send-email-b.reynal@virtualopensystems.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: iommu@lists.linux-foundation.org, kvmarm@lists.cs.columbia.edu, will.deacon@arm.com
Cc: tech@virtualopensystems.com, Baptiste Reynal <b.reynal@virtualopensystems.com>, Joerg Roedel <joro@8bytes.org>, "moderated list:ARM SMMU DRIVER" <linux-arm-kernel@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

This patch is a fix to "iommu/arm-smmu: add support for iova_to_phys
through ATS1PR".
According to ARM documentation, translation registers are optional even
in SMMUv1, so ID0_S1TS needs to be checked to verify their presence.
Also, we check that the domain is a stage-1 domain.

Signed-off-by: Baptiste Reynal <b.reynal@virtualopensystems.com>

---
v1 -> v2:
Add domain stage test (Thanks to Will Deacon)

---
 drivers/iommu/arm-smmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index fc13dd5..a3adde6 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1288,10 +1288,13 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
 		return 0;
 
 	spin_lock_irqsave(&smmu_domain->pgtbl_lock, flags);
-	if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS)
+	if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS &&
+			smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		ret = arm_smmu_iova_to_phys_hard(domain, iova);
-	else
+	} else {
 		ret = ops->iova_to_phys(ops, iova);
+	}
+
 	spin_unlock_irqrestore(&smmu_domain->pgtbl_lock, flags);
 
 	return ret;
@@ -1556,7 +1559,7 @@ static int arm_smmu_device_cfg_probe(struct arm_smmu_device *smmu)
 		return -ENODEV;
 	}
 
-	if (smmu->version == 1 || (!(id & ID0_ATOSNS) && (id & ID0_S1TS))) {
+	if ((id & ID0_S1TS) && ((smmu->version == 1) || (id & ID0_ATOSNS))) {
 		smmu->features |= ARM_SMMU_FEAT_TRANS_OPS;
 		dev_notice(smmu->dev, "\taddress translation ops\n");
 	}
-- 
2.3.1
