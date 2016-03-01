From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v5 03/17] iommu: introduce a reserved iova cookie
Date: Tue,  1 Mar 2016 18:27:43 +0000
Message-ID: <1456856877-4817-4-git-send-email-eric.auger@linaro.org>
References: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4931A4852E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f1XFgdpM6dc3 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Mar 2016 13:21:14 -0500 (EST)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C9AB412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Mar 2016 13:21:14 -0500 (EST)
Received: by mail-wm0-f45.google.com with SMTP id l68so50608393wml.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Mar 2016 10:28:21 -0800 (PST)
In-Reply-To: <1456856877-4817-1-git-send-email-eric.auger@linaro.org>
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
 drivers/iommu/iommu.c | 1 +
 include/linux/iommu.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0e3b009..7b2bb94 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1072,6 +1072,7 @@ static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
 
 	domain->ops  = bus->iommu_ops;
 	domain->type = type;
+	mutex_init(&domain->reserved_mutex);
 
 	return domain;
 }
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a4fe04a..0189144 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -82,6 +82,11 @@ struct iommu_domain {
 	void *handler_token;
 	struct iommu_domain_geometry geometry;
 	void *iova_cookie;
+	void *reserved_iova_cookie;
+	/* rb tree indexed by PA, for reserved bindings only */
+	struct rb_root reserved_binding_list;
+	/* protects reserved cookie and rbtree manipulation */
+	struct mutex reserved_mutex;
 };
 
 enum iommu_cap {
-- 
1.9.1
