From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v3 13/21] iommu/smmuv3: Implement bind_guest_msi
Date: Tue,  8 Jan 2019 11:26:25 +0100
Message-ID: <20190108102633.17482-14-eric.auger@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190108102633.17482-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

The bind_guest_msi() callback checks the domain
is NESTED and redirect to the dma-iommu implementation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index ca72e0ce92f6..999ee470a2ae 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2226,6 +2226,28 @@ static void arm_smmu_put_resv_regions(struct device *dev,
 		kfree(entry);
 }
 
+static int arm_smmu_bind_guest_msi(struct iommu_domain *domain,
+				   struct device *dev,
+				   struct iommu_guest_msi_binding *binding)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu;
+	int ret = -EINVAL;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	smmu = smmu_domain->smmu;
+	if (!smmu)
+		goto out;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		goto out;
+
+	ret = iommu_dma_bind_doorbell(domain, dev, binding);
+out:
+	mutex_unlock(&smmu_domain->init_mutex);
+	return ret;
+}
+
 static int arm_smmu_set_pasid_table(struct iommu_domain *domain,
 				     struct iommu_pasid_table_config *cfg)
 {
@@ -2352,6 +2374,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.put_resv_regions	= arm_smmu_put_resv_regions,
 	.set_pasid_table	= arm_smmu_set_pasid_table,
 	.cache_invalidate	= arm_smmu_cache_invalidate,
+	.bind_guest_msi		= arm_smmu_bind_guest_msi,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 };
 
-- 
2.17.2
