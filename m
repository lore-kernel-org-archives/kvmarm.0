From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 11/20] iommu/smmuv3: Implement cache_invalidate
Date: Tue, 18 Sep 2018 16:24:48 +0200
Message-ID: <20180918142457.3325-12-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement IOMMU_INV_TYPE_TLB invalidations. When
nr_pages is null we interpret this as a context
invalidation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

The user API needs to be refined to discriminate context
invalidations from NH_VA invalidations. Also the leaf attribute
is not yet properly handled.

v1 -> v2:
- properly pass the asid
---
 drivers/iommu/arm-smmu-v3.c | 40 +++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index c7e05c0b93e1..4054da756a41 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2251,6 +2251,45 @@ static void arm_smmu_unbind_pasid_table(struct iommu_domain *domain)
 	mutex_unlock(&smmu_domain->init_mutex);
 }
 
+static int
+arm_smmu_cache_invalidate(struct iommu_domain *domain, struct device *dev,
+			  struct iommu_cache_invalidate_info *inv_info)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -EINVAL;
+
+	if (!smmu)
+		return -EINVAL;
+
+	switch (inv_info->hdr.type) {
+	case IOMMU_INV_TYPE_TLB:
+		/*
+		 * TODO: On context invalidation, the userspace sets nr_pages
+		 * to 0. Refine the API to add a dedicated flags and also
+		 * properly handle the leaf parameter.
+		 */
+		if (!inv_info->nr_pages) {
+			smmu_domain->s1_cfg.cd.asid = inv_info->arch_id;
+			arm_smmu_tlb_inv_context(smmu_domain);
+		} else {
+			size_t granule = 1 << (inv_info->size + 12);
+			size_t size = inv_info->nr_pages * granule;
+
+			smmu_domain->s1_cfg.cd.asid = inv_info->arch_id;
+			arm_smmu_tlb_inv_range_nosync(inv_info->addr, size,
+						      granule, false,
+						      smmu_domain);
+			__arm_smmu_tlb_sync(smmu);
+		}
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
@@ -2271,6 +2310,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.put_resv_regions	= arm_smmu_put_resv_regions,
 	.bind_pasid_table	= arm_smmu_bind_pasid_table,
 	.unbind_pasid_table	= arm_smmu_unbind_pasid_table,
+	.cache_invalidate	= arm_smmu_cache_invalidate,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 };
 
-- 
2.17.1
