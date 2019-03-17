From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 14/22] iommu/smmuv3: Implement cache_invalidate
Date: Sun, 17 Mar 2019 18:22:24 +0100
Message-ID: <20190317172232.1068-15-eric.auger@redhat.com>
References: <20190317172232.1068-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317172232.1068-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Implement domain-selective and page-selective IOTLB invalidations.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- adapt to changes in the uapi
- add support for leaf parameter
- do not use arm_smmu_tlb_inv_range_nosync or arm_smmu_tlb_inv_context
  anymore

v2 -> v3:
- replace __arm_smmu_tlb_sync by arm_smmu_cmdq_issue_sync

v1 -> v2:
- properly pass the asid
---
 drivers/iommu/arm-smmu-v3.c | 57 +++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index e41f61844d78..4a05dd66df74 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2319,6 +2319,62 @@ static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
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
+	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_IOTLB) {
+		if (inv_info->granularity == IOMMU_INV_GRANU_PASID) {
+			struct arm_smmu_cmdq_ent cmd = {
+				.opcode = CMDQ_OP_TLBI_NH_ASID,
+				.tlbi = {
+					.vmid = smmu_domain->s2_cfg.vmid,
+					.asid = inv_info->pasid,
+				},
+			};
+
+			arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+			arm_smmu_cmdq_issue_sync(smmu);
+
+		} else if (inv_info->granularity == IOMMU_INV_GRANU_ADDR) {
+			struct iommu_inv_addr_info *info = &inv_info->addr_info;
+			size_t size = info->nb_granules * info->granule_size;
+			bool leaf = info->flags & IOMMU_INV_ADDR_FLAGS_LEAF;
+			struct arm_smmu_cmdq_ent cmd = {
+				.opcode = CMDQ_OP_TLBI_NH_VA,
+				.tlbi = {
+					.addr = info->addr,
+					.vmid = smmu_domain->s2_cfg.vmid,
+					.asid = info->pasid,
+					.leaf = leaf,
+				},
+			};
+
+			do {
+				arm_smmu_cmdq_issue_cmd(smmu, &cmd);
+				cmd.tlbi.addr += info->granule_size;
+			} while (size -= info->granule_size);
+			arm_smmu_cmdq_issue_sync(smmu);
+		} else {
+			return -EINVAL;
+		}
+	}
+	if (inv_info->cache & IOMMU_CACHE_INV_TYPE_PASID ||
+	    inv_info->cache & IOMMU_CACHE_INV_TYPE_DEV_IOTLB) {
+		return -ENOENT;
+	}
+	return 0;
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
@@ -2339,6 +2395,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.put_resv_regions	= arm_smmu_put_resv_regions,
 	.attach_pasid_table	= arm_smmu_attach_pasid_table,
 	.detach_pasid_table	= arm_smmu_detach_pasid_table,
+	.cache_invalidate	= arm_smmu_cache_invalidate,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 };
 
-- 
2.20.1
