From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 10/13] iommu/smmuv3: Implement bind_guest_stage
Date: Thu, 23 Aug 2018 14:17:33 +0200
Message-ID: <1535026656-8450-11-git-send-email-eric.auger__49679.1281424977$1535038714$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 479A34A21D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X0ofh5DEB2DK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:18:18 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AB024A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:18 -0400 (EDT)
In-Reply-To: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jean-philippe.brucker@arm.com,
 jacob.jun.pan@linux.intel.com, yi.l.liu"@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On bind_guest_stage() we set the minimal information in s1_cfg:
- the asid (allocated by the guest)
- the context descriptor GPA

On unbind, the STE stage 1 fields are reset.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 78 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 3a33979..26afafa 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2025,6 +2025,82 @@ static void arm_smmu_put_resv_regions(struct device *dev,
 		kfree(entry);
 }
 
+static int arm_smmu_bind_guest_stage(struct iommu_domain *domain,
+				     struct device *dev,
+				     struct iommu_guest_stage_config *cfg)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_master_data *entry;
+	unsigned long flags;
+
+	if (cfg->flags != SMMUV3_S1_CFG)
+		return -EINVAL;
+
+	if (!smmu)
+		return -EINVAL;
+
+	if (!((smmu->features & ARM_SMMU_FEAT_TRANS_S1) &&
+	      (smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
+		dev_info(smmu_domain->smmu->dev,
+			 "does not implement two stages\n");
+		return -EINVAL;
+	}
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -EINVAL;
+
+	if (cfg->smmu_s1.asid >= (1 << smmu->asid_bits))
+		return -EINVAL;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(entry, &smmu_domain->devices, list) {
+		struct arm_smmu_s1_cfg *s1_cfg;
+
+		if (dev != entry->dev)
+			continue;
+
+		s1_cfg = entry->ste.s1_cfg = &smmu_domain->s1_cfg;
+		s1_cfg->bypass = cfg->smmu_s1.disabled || cfg->smmu_s1.bypassed;
+		s1_cfg->cd.asid = cfg->smmu_s1.asid;
+
+		if (!s1_cfg->bypass)
+			s1_cfg->cdptr_dma = cfg->smmu_s1.cdptr_dma;
+
+		arm_smmu_install_ste_for_dev(dev->iommu_fwspec);
+		break;
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+	return 0;
+}
+
+static void arm_smmu_unbind_guest_stage(struct iommu_domain *domain,
+					struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_master_data *entry;
+	unsigned long flags;
+
+	if (!smmu)
+		return;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(entry, &smmu_domain->devices, list) {
+		if (dev != entry->dev)
+			continue;
+
+		entry->ste.s1_cfg = NULL;
+		arm_smmu_install_ste_for_dev(dev->iommu_fwspec);
+		break;
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
@@ -2044,6 +2120,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= arm_smmu_put_resv_regions,
+	.bind_guest_stage	= arm_smmu_bind_guest_stage,
+	.unbind_guest_stage	= arm_smmu_unbind_guest_stage,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 };
 
-- 
2.5.5
