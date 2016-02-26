From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v4 06/14] dma-reserved-iommu: iommu_unmap_reserved
Date: Fri, 26 Feb 2016 17:35:46 +0000
Message-ID: <1456508154-2253-7-git-send-email-eric.auger@linaro.org>
References: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B41412A6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4EL7k2nCwNr9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 12:29:28 -0500 (EST)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D8E1419D1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 12:29:26 -0500 (EST)
Received: by mail-wm0-f53.google.com with SMTP id b205so80970260wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 09:36:19 -0800 (PST)
In-Reply-To: <1456508154-2253-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce a new function whose role is to unmap all allocated
reserved IOVAs and free the reserved iova domain

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v3 -> v4:
- previously "iommu/arm-smmu: relinquish reserved resources on
  domain deletion"
---
 drivers/iommu/dma-reserved-iommu.c | 27 ++++++++++++++++++++++++---
 include/linux/dma-reserved-iommu.h |  7 +++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
index 537c83e..7217bb7 100644
--- a/drivers/iommu/dma-reserved-iommu.c
+++ b/drivers/iommu/dma-reserved-iommu.c
@@ -116,7 +116,7 @@ unlock:
 }
 EXPORT_SYMBOL_GPL(iommu_alloc_reserved_iova_domain);
 
-void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+void __iommu_free_reserved_iova_domain(struct iommu_domain *domain)
 {
 	struct iova_domain *iovad =
 		(struct iova_domain *)domain->reserved_iova_cookie;
@@ -124,11 +124,14 @@ void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
 	if (!iovad)
 		return;
 
-	mutex_lock(&domain->reserved_mutex);
-
 	put_iova_domain(iovad);
 	kfree(iovad);
+}
 
+void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+{
+	mutex_lock(&domain->reserved_mutex);
+	__iommu_free_reserved_iova_domain(domain);
 	mutex_unlock(&domain->reserved_mutex);
 }
 EXPORT_SYMBOL_GPL(iommu_free_reserved_iova_domain);
@@ -245,5 +248,23 @@ unlock:
 }
 EXPORT_SYMBOL_GPL(iommu_put_single_reserved);
 
+void iommu_unmap_reserved(struct iommu_domain *domain)
+{
+	struct rb_node *node;
+
+	mutex_lock(&domain->reserved_mutex);
+	while ((node = rb_first(&domain->reserved_binding_list))) {
+		struct iommu_reserved_binding *b =
+			rb_entry(node, struct iommu_reserved_binding, node);
+
+		while (!kref_put(&b->kref, reserved_binding_release))
+			;
+	}
+	domain->reserved_binding_list = RB_ROOT;
+	__iommu_free_reserved_iova_domain(domain);
+	mutex_unlock(&domain->reserved_mutex);
+}
+EXPORT_SYMBOL_GPL(iommu_unmap_reserved);
+
 
 
diff --git a/include/linux/dma-reserved-iommu.h b/include/linux/dma-reserved-iommu.h
index 71ec800..766c58c 100644
--- a/include/linux/dma-reserved-iommu.h
+++ b/include/linux/dma-reserved-iommu.h
@@ -66,6 +66,13 @@ int iommu_get_single_reserved(struct iommu_domain *domain,
  */
 void iommu_put_single_reserved(struct iommu_domain *domain, dma_addr_t iova);
 
+/**
+ * iommu_unmap_reserved: unmap & destroy the reserved iova bindings
+ *
+ * @domain: iommu domain handle
+ */
+void iommu_unmap_reserved(struct iommu_domain *domain);
+
 #endif	/* CONFIG_IOMMU_DMA_RESERVED */
 #endif	/* __KERNEL__ */
 #endif	/* __DMA_RESERVED_IOMMU_H */
-- 
1.9.1
