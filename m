From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 3/7] iommu: introduce a reserved iova cookie
Date: Mon,  4 Apr 2016 08:06:58 +0000
Message-ID: <1459757222-2668-4-git-send-email-eric.auger@linaro.org>
References: <1459757222-2668-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8713F40FA2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n98alfuI8fIY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2016 04:06:05 -0400 (EDT)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A568840F77
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2016 04:06:05 -0400 (EDT)
Received: by mail-lf0-f53.google.com with SMTP id c126so38328429lfb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2016 01:07:20 -0700 (PDT)
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

This patch introduces some new fields in the iommu_domain struct,
dedicated to reserved iova management.

In a similar way as DMA mapping IOVA window, we need to store
information related to a reserved IOVA window.

The reserved_iova_cookie will store the reserved iova_domain
handle. An RB tree indexed by physical address is introduced to
store the host physical addresses bound to reserved IOVAs.

Those physical addresses will correspond to MSI frame base
addresses, also referred to as doorbells. Their number should be
quite limited per domain.

Also a mutex is introduced to protect accesses to the iova_domain
and RB tree.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v5 -> v6:
- initialize reserved_binding_list
- use a spinlock instead of a mutex
---
 drivers/iommu/iommu.c | 2 ++
 include/linux/iommu.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index bfd4f7c..cdb7845 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1072,6 +1072,8 @@ static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
 
 	domain->ops  = bus->iommu_ops;
 	domain->type = type;
+	spin_lock_init(&domain->reserved_lock);
+	domain->reserved_binding_list = RB_ROOT;
 
 	return domain;
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a4fe04a..630a207 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -24,6 +24,7 @@
 #include <linux/of.h>
 #include <linux/types.h>
 #include <linux/scatterlist.h>
+#include <linux/spinlock.h>
 #include <trace/events/iommu.h>
 
 #define IOMMU_READ	(1 << 0)
@@ -82,6 +83,11 @@ struct iommu_domain {
 	void *handler_token;
 	struct iommu_domain_geometry geometry;
 	void *iova_cookie;
+	void *reserved_iova_cookie;
+	/* rb tree indexed by PA, for reserved bindings only */
+	struct rb_root reserved_binding_list;
+	/* protects reserved cookie and rbtree manipulation */
+	spinlock_t reserved_lock;
 };
 
 enum iommu_cap {
-- 
1.9.1
