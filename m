From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 7/7] dma-reserved-iommu: iommu_unmap_reserved
Date: Mon,  4 Apr 2016 08:07:02 +0000
Message-ID: <1459757222-2668-8-git-send-email-eric.auger@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C680412C2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rbn1do7Bpqzv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:06:19 -0400 (EDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE34F407A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:18 -0400 (EDT)
Received: by mail-lf0-f54.google.com with SMTP id c62so157250105lfc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:07:34 -0700 (PDT)
In-Reply-To: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
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
v5 -> v6:
- use spin_lock instead of mutex

v3 -> v4:
- previously "iommu/arm-smmu: relinquish reserved resources on
  domain deletion"
---
 drivers/iommu/dma-reserved-iommu.c | 45 ++++++++++++++++++++++++++++++++++----
 include/linux/dma-reserved-iommu.h |  7 ++++++
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
index 3c759d9..c06c39e 100644
--- a/drivers/iommu/dma-reserved-iommu.c
+++ b/drivers/iommu/dma-reserved-iommu.c
@@ -119,20 +119,24 @@ unlock:
 }
 EXPORT_SYMBOL_GPL(iommu_alloc_reserved_iova_domain);
 
-void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+void __iommu_free_reserved_iova_domain(struct iommu_domain *domain)
 {
 	struct iova_domain *iovad =
 		(struct iova_domain *)domain->reserved_iova_cookie;
-	unsigned long flags;
 
 	if (!iovad)
 		return;
 
-	spin_lock_irqsave(&domain->reserved_lock, flags);
-
 	put_iova_domain(iovad);
 	kfree(iovad);
+}
+
+void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+{
+	unsigned long flags;
 
+	spin_lock_irqsave(&domain->reserved_lock, flags);
+	__iommu_free_reserved_iova_domain(domain);
 	spin_unlock_irqrestore(&domain->reserved_lock, flags);
 }
 EXPORT_SYMBOL_GPL(iommu_free_reserved_iova_domain);
@@ -281,4 +285,37 @@ unlock:
 EXPORT_SYMBOL_GPL(iommu_put_reserved_iova);
 
 
+static void reserved_binding_release(struct kref *kref)
+{
+	struct iommu_reserved_binding *b =
+		container_of(kref, struct iommu_reserved_binding, kref);
+	struct iommu_domain *d = b->domain;
+
+	delete_reserved_binding(d, b);
+}
+
+void iommu_unmap_reserved(struct iommu_domain *domain)
+{
+	struct rb_node *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->reserved_lock, flags);
+	while ((node = rb_first(&domain->reserved_binding_list))) {
+		struct iommu_reserved_binding *b =
+			rb_entry(node, struct iommu_reserved_binding, node);
+
+		unlink_reserved_binding(domain, b);
+		spin_unlock_irqrestore(&domain->reserved_lock, flags);
+
+		while (!kref_put(&b->kref, reserved_binding_release))
+			;
+		spin_lock_irqsave(&domain->reserved_lock, flags);
+	}
+	domain->reserved_binding_list = RB_ROOT;
+	__iommu_free_reserved_iova_domain(domain);
+	spin_unlock_irqrestore(&domain->reserved_lock, flags);
+}
+EXPORT_SYMBOL_GPL(iommu_unmap_reserved);
+
+
 
diff --git a/include/linux/dma-reserved-iommu.h b/include/linux/dma-reserved-iommu.h
index dedea56..9fba930 100644
--- a/include/linux/dma-reserved-iommu.h
+++ b/include/linux/dma-reserved-iommu.h
@@ -68,6 +68,13 @@ int iommu_get_reserved_iova(struct iommu_domain *domain,
  */
 void iommu_put_reserved_iova(struct iommu_domain *domain, dma_addr_t iova);
 
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
