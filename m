From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 16/22] iommu/smmuv3: Implement bind/unbind_guest_msi
Date: Sun, 17 Mar 2019 18:22:26 +0100
Message-ID: <20190317172232.1068-17-eric.auger@redhat.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317172232.1068-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

The bind/unbind_guest_msi() callbacks check the domain
is NESTED and redirect to the dma-iommu implementation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/arm-smmu-v3.c | 44 +++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 4a05dd66df74..a4b82c520647 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2207,6 +2207,48 @@ static void arm_smmu_put_resv_regions(struct device *dev,
 		kfree(entry);
 }
 
+static int
+arm_smmu_bind_guest_msi(struct iommu_domain *domain, struct device *dev,
+			dma_addr_t giova, phys_addr_t gpa, size_t size)
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
+	ret = iommu_dma_bind_guest_msi(domain, dev, giova, gpa, size);
+out:
+	mutex_unlock(&smmu_domain->init_mutex);
+	return ret;
+}
+
+static void
+arm_smmu_unbind_guest_msi(struct iommu_domain *domain,
+			  struct device *dev, dma_addr_t giova)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu;
+
+	mutex_lock(&smmu_domain->init_mutex);
+	smmu = smmu_domain->smmu;
+	if (!smmu)
+		goto unlock;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		goto unlock;
+
+	iommu_dma_unbind_guest_msi(domain, dev, giova);
+unlock:
+	mutex_unlock(&smmu_domain->init_mutex);
+}
+
 static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
 				       struct iommu_pasid_table_config *cfg)
 {
@@ -2396,6 +2438,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.attach_pasid_table	= arm_smmu_attach_pasid_table,
 	.detach_pasid_table	= arm_smmu_detach_pasid_table,
 	.cache_invalidate	= arm_smmu_cache_invalidate,
+	.bind_guest_msi		= arm_smmu_bind_guest_msi,
+	.unbind_guest_msi	= arm_smmu_unbind_guest_msi,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 };
 
-- 
2.20.1
