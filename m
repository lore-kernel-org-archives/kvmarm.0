From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 11/13] iommu/smmuv3: Implement tlb_invalidate
Date: Thu, 23 Aug 2018 14:17:34 +0200
Message-ID: <1535026656-8450-12-git-send-email-eric.auger__45416.1825044595$1535038715$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F9414A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OyKtSfBPBtAL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:18:24 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 74ACC4A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:24 -0400 (EDT)
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

Implement IOMMU_INV_TYPE_TLB invalidations. When
nr_pages is null we interpret this as a context
invalidation.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

The user API needs to be refined to discriminate context
invalidations from NH_VA invalidations. Also the leaf attribute
is not yet properly handled.
---
 drivers/iommu/arm-smmu-v3.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index 26afafa..e4c7ae8 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2101,6 +2101,39 @@ static void arm_smmu_unbind_guest_stage(struct iommu_domain *domain,
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static int arm_smmu_tlb_invalidate(struct iommu_domain *domain,
+				   struct device *dev,
+				   struct iommu_tlb_invalidate_info *inv_info)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	size_t granule = 1 << (inv_info->size + 12);
+
+	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
+		return -EINVAL;
+
+	if (!smmu)
+		return -EINVAL;
+
+	if (inv_info->hdr.type != IOMMU_INV_TYPE_TLB)
+		return -EINVAL;
+
+	/*
+	 * TODO: On context invalidation, the userspace sets nr_pages to 0.
+	 * Refine the API to add a dedicated flags and also properly handle
+	 * the leaf parameter.
+	 */
+	if (!inv_info->nr_pages) {
+		arm_smmu_tlb_inv_context(smmu_domain);
+	} else {
+		arm_smmu_tlb_inv_range_nosync(inv_info->addr,
+					      inv_info->nr_pages * granule,
+					      granule, false, smmu_domain);
+		__arm_smmu_tlb_sync(smmu);
+	}
+	return 0;
+}
+
 static struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
 	.domain_alloc		= arm_smmu_domain_alloc,
@@ -2122,6 +2155,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.put_resv_regions	= arm_smmu_put_resv_regions,
 	.bind_guest_stage	= arm_smmu_bind_guest_stage,
 	.unbind_guest_stage	= arm_smmu_unbind_guest_stage,
+	.tlb_invalidate		= arm_smmu_tlb_invalidate,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 };
 
-- 
2.5.5
