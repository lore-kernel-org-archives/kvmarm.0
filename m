From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 03/13] iommu: Introduce bind_guest_msi
Date: Thu, 23 Aug 2018 14:17:26 +0200
Message-ID: <1535026656-8450-4-git-send-email-eric.auger__49887.9237370149$1535038711$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2694A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZC4p7K3UFX9R for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:17:53 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A4CD4A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:53 -0400 (EDT)
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

On ARM, MSI are translated by the SMMU. An IOVA is allocated
for each MSI doorbell. If both the host and the guest are exposed
with SMMUs, we end up with 2 different IOVAs allocated by each.
guest allocates an IOVA (gIOVA) to map onto the guest MSI
doorbell (gDB). The Host allocates another IOVA (hIOVA) to map
onto the physical doorbell (hDB).

So we end up with 2 untied mappings:
         S1            S2
gIOVA    ->    gDB
              hIOVA    ->    gDB

Currently the PCI device is programmed by the host with hIOVA
as MSI doorbell. So this does not work.

This patch introduces an API to pass gIOVA/gDB to the host so
that gIOVA can be reused by the host instead of re-allocating
a new IOVA. So the goal is to create the following nested mapping:

         S1            S2
gIOVA    ->    gDB     ->    hDB

and program the PCI device with gIOVA MSI doorbell.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/iommu/iommu.c      | 10 ++++++++++
 include/linux/iommu.h      | 12 ++++++++++++
 include/uapi/linux/iommu.h |  7 +++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0bc05a7..ab8968f 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1336,6 +1336,16 @@ int iommu_bind_guest_stage(struct iommu_domain *domain, struct device *dev,
 }
 EXPORT_SYMBOL_GPL(iommu_bind_guest_stage);
 
+int iommu_bind_guest_msi(struct iommu_domain *domain,
+			 struct iommu_guest_msi_binding *binding)
+{
+	if (unlikely(!domain->ops->bind_guest_msi))
+		return -ENODEV;
+
+	return domain->ops->bind_guest_msi(domain, binding);
+}
+EXPORT_SYMBOL_GPL(iommu_bind_guest_msi);
+
 void iommu_unbind_guest_stage(struct iommu_domain *domain, struct device *dev)
 {
 	if (unlikely(!domain->ops->unbind_guest_stage))
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b13cf2b..ff8ae5f0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -247,6 +247,9 @@ struct iommu_ops {
 	int (*tlb_invalidate)(struct iommu_domain *domain, struct device *dev,
 			      struct iommu_tlb_invalidate_info *inv_info);
 
+	int (*bind_guest_msi)(struct iommu_domain *domain,
+			      struct iommu_guest_msi_binding *binding);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -315,6 +318,8 @@ extern void iommu_unbind_guest_stage(struct iommu_domain *domain,
 extern int iommu_tlb_invalidate(struct iommu_domain *domain,
 				struct device *dev,
 				struct iommu_tlb_invalidate_info *inv_info);
+extern int iommu_bind_guest_msi(struct iommu_domain *domain,
+				struct iommu_guest_msi_binding *binding);
 
 extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
 extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
@@ -732,6 +737,13 @@ static inline int iommu_tlb_invalidate(struct iommu_domain *domain,
 	return -ENODEV;
 }
 
+static inline
+int iommu_bind_guest_msi(struct iommu_domain *domain,
+			 struct iommu_guest_msi_binding *binding)
+{
+	return -ENODEV;
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
index 7c88d80..7de9ab1 100644
--- a/include/uapi/linux/iommu.h
+++ b/include/uapi/linux/iommu.h
@@ -147,4 +147,11 @@ struct iommu_tlb_invalidate_info {
 	__u32		pasid;
 	__u64		addr;
 };
+
+struct iommu_guest_msi_binding {
+	__u64		iova;
+	__u64		gpa;
+	__u32		granule;
+};
 #endif /* _UAPI_IOMMU_H */
+
-- 
2.5.5
