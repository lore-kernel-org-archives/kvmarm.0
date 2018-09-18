From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 10/20] iommu/smmuv3: Implement bind_pasid_table
Date: Tue, 18 Sep 2018 16:24:47 +0200
Message-ID: <20180918142457.3325-11-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On bind_pasid_table() we program STE S1 related info set
by the guest into the actual physical STEs. At minimum
we need to program the context descriptor GPA and compute
whether the guest wanted to bypass the stage 1 or induce
aborts for this STE.

On unbind, the STE stage 1 fields are reset.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- invalidate the STE before changing them
- hold init_mutex
- handle new fields
---
 drivers/iommu/arm-smmu-v3.c | 85 +++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 9749c36208f3..c7e05c0b93e1 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2168,6 +2168,89 @@ static void arm_smmu_put_resv_regions(struct device *dev,
 		kfree(entry);
 }
 
+static int arm_smmu_bind_pasid_table(struct iommu_domain *domain,
+				     struct iommu_pasid_table_config *cfg)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_data *entry;
+	struct arm_smmu_s1_cfg *s1_cfg;
+	struct arm_smmu_device *smmu;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (cfg->format != IOMMU_PASID_FORMAT_SMMUV3)
+		return -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+
+	smmu = smmu_domain->smmu;
+
+	if (!smmu)
+		goto out;
+
+	if (!((smmu->features & ARM_SMMU_FEAT_TRANS_S1) &&
+	      (smmu->features & ARM_SMMU_FEAT_TRANS_S2))) {
+		dev_info(smmu_domain->smmu->dev,
+			 "does not implement two stages\n");
+		goto out;
+	}
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		goto out;
+
+	/* we currently support a single CD. S1DSS and S1FMT are ignored */
+	if (cfg->smmuv3.s1cdmax)
+		goto out;
+
+	s1_cfg = &smmu_domain->s1_cfg;
+	s1_cfg->nested_bypass = cfg->smmuv3.bypass;
+	s1_cfg->nested_abort = cfg->smmuv3.abort;
+	s1_cfg->cdptr_dma = cfg->smmuv3.s1contextptr;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(entry, &smmu_domain->devices, list) {
+		entry->ste.s1_cfg = &smmu_domain->s1_cfg;
+		entry->ste.nested = true;
+		arm_smmu_install_ste_for_dev(entry->dev->iommu_fwspec);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = 0;
+out:
+	mutex_unlock(&smmu_domain->init_mutex);
+	return ret;
+}
+
+static void arm_smmu_unbind_pasid_table(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	struct arm_smmu_master_data *entry;
+	struct arm_smmu_s1_cfg *s1_cfg;
+	unsigned long flags;
+
+	if (!smmu)
+		return;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return;
+
+	mutex_lock(&smmu_domain->init_mutex);
+
+	s1_cfg = &smmu_domain->s1_cfg;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(entry, &smmu_domain->devices, list) {
+		entry->ste.s1_cfg = NULL;
+		entry->ste.nested = false;
+		arm_smmu_install_ste_for_dev(entry->dev->iommu_fwspec);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+	s1_cfg->nested_abort = false;
+	s1_cfg->nested_bypass = false;
+	mutex_unlock(&smmu_domain->init_mutex);
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
@@ -2186,6 +2269,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.of_xlate		= arm_smmu_of_xlate,
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.put_resv_regions	= arm_smmu_put_resv_regions,
+	.bind_pasid_table	= arm_smmu_bind_pasid_table,
+	.unbind_pasid_table	= arm_smmu_unbind_pasid_table,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 };
 
-- 
2.17.1
