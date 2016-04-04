From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 5/7] dma-reserved-iommu: reserved binding rb-tree and
 helpers
Date: Mon,  4 Apr 2016 08:07:00 +0000
Message-ID: <1459757222-2668-6-git-send-email-eric.auger@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 470CC407A5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xB-tTGF6mLYy for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:06:12 -0400 (EDT)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E65D40402
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:12 -0400 (EDT)
Received: by mail-lf0-f52.google.com with SMTP id c62so157245605lfc.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:07:27 -0700 (PDT)
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

we will need to track which host physical addresses are mapped to
reserved IOVA. In that prospect we introduce a new RB tree indexed
by physical address. This RB tree only is used for reserved IOVA
bindings.

It is expected this RB tree will contain very few bindings. Those
generally correspond to single page mapping one MSI frame (GICv2m
frame or ITS GITS_TRANSLATER frame).

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v5 -> v6:
- add comment about @d->reserved_lock to be held

v3 -> v4:
- that code was formerly in "iommu/arm-smmu: add a reserved binding RB tree"
---
 drivers/iommu/dma-reserved-iommu.c | 63 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/iommu/dma-reserved-iommu.c b/drivers/iommu/dma-reserved-iommu.c
index a461482..f592118 100644
--- a/drivers/iommu/dma-reserved-iommu.c
+++ b/drivers/iommu/dma-reserved-iommu.c
@@ -18,6 +18,69 @@
 #include <linux/iommu.h>
 #include <linux/iova.h>
 
+struct iommu_reserved_binding {
+	struct kref		kref;
+	struct rb_node		node;
+	struct iommu_domain	*domain;
+	phys_addr_t		addr;
+	dma_addr_t		iova;
+	size_t			size;
+};
+
+/* Reserved binding RB-tree manipulation */
+
+/* @d->reserved_lock must be held */
+static struct iommu_reserved_binding *find_reserved_binding(
+				    struct iommu_domain *d,
+				    phys_addr_t start, size_t size)
+{
+	struct rb_node *node = d->reserved_binding_list.rb_node;
+
+	while (node) {
+		struct iommu_reserved_binding *binding =
+			rb_entry(node, struct iommu_reserved_binding, node);
+
+		if (start + size <= binding->addr)
+			node = node->rb_left;
+		else if (start >= binding->addr + binding->size)
+			node = node->rb_right;
+		else
+			return binding;
+	}
+
+	return NULL;
+}
+
+/* @d->reserved_lock must be held */
+static void link_reserved_binding(struct iommu_domain *d,
+				  struct iommu_reserved_binding *new)
+{
+	struct rb_node **link = &d->reserved_binding_list.rb_node;
+	struct rb_node *parent = NULL;
+	struct iommu_reserved_binding *binding;
+
+	while (*link) {
+		parent = *link;
+		binding = rb_entry(parent, struct iommu_reserved_binding,
+				   node);
+
+		if (new->addr + new->size <= binding->addr)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+
+	rb_link_node(&new->node, parent, link);
+	rb_insert_color(&new->node, &d->reserved_binding_list);
+}
+
+/* @d->reserved_lock must be held */
+static void unlink_reserved_binding(struct iommu_domain *d,
+				    struct iommu_reserved_binding *old)
+{
+	rb_erase(&old->node, &d->reserved_binding_list);
+}
+
 int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
 				     dma_addr_t iova, size_t size,
 				     unsigned long order)
-- 
1.9.1
