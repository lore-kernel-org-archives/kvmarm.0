From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 06/15] iommu/arm-smmu: add a reserved binding RB tree
Date: Thu, 11 Feb 2016 14:34:13 +0000
Message-ID: <1455201262-5259-7-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39C1449BCF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6r2pzrp0xuzw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 09:29:22 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49F0749B9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 09:29:22 -0500 (EST)
Received: by mail-wm0-f44.google.com with SMTP id c200so76072676wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 06:35:17 -0800 (PST)
In-Reply-To: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, brijesh.singh@amd.com, patches@linaro.org, Manish.Jaggi@caviumnetworks.com, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org, leo.duran@amd.com, sherry.hurwitz@amd.com
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
 drivers/iommu/arm-smmu.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index f42341d..729a4c6 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -349,10 +349,21 @@ struct arm_smmu_domain {
 	struct mutex			init_mutex; /* Protects smmu pointer */
 	struct iommu_domain		domain;
 	struct iova_domain		*reserved_iova_domain;
-	/* protects reserved domain manipulation */
+	/* rb tree indexed by PA, for reserved bindings only */
+	struct rb_root			reserved_binding_list;
+	/* protects reserved domain and rbtree manipulation */
 	struct mutex			reserved_mutex;
 };
 
+struct arm_smmu_reserved_binding {
+	struct kref		kref;
+	struct rb_node		node;
+	struct arm_smmu_domain	*domain;
+	phys_addr_t		addr;
+	dma_addr_t		iova;
+	size_t			size;
+};
+
 static struct iommu_ops arm_smmu_ops;
 
 static DEFINE_SPINLOCK(arm_smmu_devices_lock);
@@ -400,6 +411,57 @@ static struct device_node *dev_get_dev_node(struct device *dev)
 	return dev->of_node;
 }
 
+/* Reserved binding RB-tree manipulation */
+
+static struct arm_smmu_reserved_binding *find_reserved_binding(
+				    struct arm_smmu_domain *d,
+				    phys_addr_t start, size_t size)
+{
+	struct rb_node *node = d->reserved_binding_list.rb_node;
+
+	while (node) {
+		struct arm_smmu_reserved_binding *binding =
+			rb_entry(node, struct arm_smmu_reserved_binding, node);
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
+static void link_reserved_binding(struct arm_smmu_domain *d,
+				  struct arm_smmu_reserved_binding *new)
+{
+	struct rb_node **link = &d->reserved_binding_list.rb_node;
+	struct rb_node *parent = NULL;
+	struct arm_smmu_reserved_binding *binding;
+
+	while (*link) {
+		parent = *link;
+		binding = rb_entry(parent, struct arm_smmu_reserved_binding,
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
+static void unlink_reserved_binding(struct arm_smmu_domain *d,
+				    struct arm_smmu_reserved_binding *old)
+{
+	rb_erase(&old->node, &d->reserved_binding_list);
+}
+
 static struct arm_smmu_master *find_smmu_master(struct arm_smmu_device *smmu,
 						struct device_node *dev_node)
 {
@@ -981,6 +1043,7 @@ static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
 	mutex_init(&smmu_domain->init_mutex);
 	mutex_init(&smmu_domain->reserved_mutex);
 	spin_lock_init(&smmu_domain->pgtbl_lock);
+	smmu_domain->reserved_binding_list = RB_ROOT;
 
 	return &smmu_domain->domain;
 }
-- 
1.9.1
