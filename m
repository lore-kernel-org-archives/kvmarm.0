Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4666CC282CE
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 12:21:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 01D532087F
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 12:21:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01D532087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACFEC4A484;
	Mon,  8 Apr 2019 08:21:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Snzd4WdH8lCx; Mon,  8 Apr 2019 08:21:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D3294A3BF;
	Mon,  8 Apr 2019 08:21:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E01DE4A380
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 08:21:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZoU2N281XPR4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 08:21:25 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 647EB4A331
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 08:21:25 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id B67A1C02493B;
 Mon,  8 Apr 2019 12:21:24 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-161.ams2.redhat.com [10.36.117.161])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 2C48363B80;
 Mon,  8 Apr 2019 12:21:12 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v7 15/23] dma-iommu: Implement NESTED_MSI cookie
Date: Mon,  8 Apr 2019 14:19:03 +0200
Message-Id: <20190408121911.24103-16-eric.auger@redhat.com>
In-Reply-To: <20190408121911.24103-1-eric.auger@redhat.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.32]); Mon, 08 Apr 2019 12:21:24 +0000 (UTC)
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408121903.r5fP4PuKMIPQ9GieO9-5tP3eagVsNt-m-PIbHM9bxeA@z>

Up to now, when the type was UNMANAGED, we used to
allocate IOVA pages within a reserved IOVA MSI range.

If both the host and the guest are exposed with SMMUs, each
would allocate an IOVA. The guest allocates an IOVA (gIOVA)
to map onto the guest MSI doorbell (gDB). The Host allocates
another IOVA (hIOVA) to map onto the physical doorbell (hDB).

So we end up with 2 unrelated mappings, at S1 and S2:
         S1             S2
gIOVA    ->     gDB
               hIOVA    ->    hDB

The PCI device would be programmed with hIOVA.
No stage 1 mapping would existing, causing the MSIs to fault.

iommu_dma_bind_guest_msi() allows to pass gIOVA/gDB
to the host so that gIOVA can be used by the host instead of
re-allocating a new hIOVA.

         S1           S2
gIOVA    ->    gDB    ->    hDB

this time, the PCI device can be programmed with the gIOVA MSI
doorbell which is correctly mapped through both stages.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v6 -> v7:
- removed device handle

v3 -> v4:
- change function names; add unregister
- protect with msi_lock

v2 -> v3:
- also store the device handle on S1 mapping registration.
  This garantees we associate the associated S2 mapping binds
  to the correct physical MSI controller.

v1 -> v2:
- unmap stage2 on put()
---
 drivers/iommu/dma-iommu.c | 129 +++++++++++++++++++++++++++++++++++++-
 include/linux/dma-iommu.h |  17 +++++
 2 files changed, 143 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 77aabe637a60..9905260ad342 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -35,12 +35,15 @@
 struct iommu_dma_msi_page {
 	struct list_head	list;
 	dma_addr_t		iova;
+	dma_addr_t		gpa;
 	phys_addr_t		phys;
+	size_t			s1_granule;
 };
 
 enum iommu_dma_cookie_type {
 	IOMMU_DMA_IOVA_COOKIE,
 	IOMMU_DMA_MSI_COOKIE,
+	IOMMU_DMA_NESTED_MSI_COOKIE,
 };
 
 struct iommu_dma_cookie {
@@ -110,14 +113,17 @@ EXPORT_SYMBOL(iommu_get_dma_cookie);
  *
  * Users who manage their own IOVA allocation and do not want DMA API support,
  * but would still like to take advantage of automatic MSI remapping, can use
- * this to initialise their own domain appropriately. Users should reserve a
+ * this to initialise their own domain appropriately. Users may reserve a
  * contiguous IOVA region, starting at @base, large enough to accommodate the
  * number of PAGE_SIZE mappings necessary to cover every MSI doorbell address
- * used by the devices attached to @domain.
+ * used by the devices attached to @domain. The other way round is to provide
+ * usable iova pages through the iommu_dma_bind_doorbell API (nested stages
+ * use case)
  */
 int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 {
 	struct iommu_dma_cookie *cookie;
+	int nesting, ret;
 
 	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
 		return -EINVAL;
@@ -125,7 +131,12 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
 	if (domain->iova_cookie)
 		return -EEXIST;
 
-	cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+	ret =  iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nesting);
+	if (!ret && nesting)
+		cookie = cookie_alloc(IOMMU_DMA_NESTED_MSI_COOKIE);
+	else
+		cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
+
 	if (!cookie)
 		return -ENOMEM;
 
@@ -146,6 +157,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 {
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	struct iommu_dma_msi_page *msi, *tmp;
+	bool s2_unmap = false;
 
 	if (!cookie)
 		return;
@@ -153,7 +165,15 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 	if (cookie->type == IOMMU_DMA_IOVA_COOKIE && cookie->iovad.granule)
 		put_iova_domain(&cookie->iovad);
 
+	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE)
+		s2_unmap = true;
+
 	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
+		if (s2_unmap && msi->phys) {
+			size_t size = cookie_msi_granule(cookie);
+
+			WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
+		}
 		list_del(&msi->list);
 		kfree(msi);
 	}
@@ -162,6 +182,82 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL(iommu_put_dma_cookie);
 
+/**
+ * iommu_dma_bind_guest_msi - Allows to pass the stage 1
+ * binding of a virtual MSI doorbell used by @dev.
+ *
+ * @domain: domain handle
+ * @iova: guest iova
+ * @gpa: gpa of the virtual doorbell
+ * @size: size of the granule used for the stage1 mapping
+ *
+ * In nested stage use case, the user can provide IOVA/IPA bindings
+ * corresponding to a guest MSI stage 1 mapping. When the host needs
+ * to map its own MSI doorbells, it can use @gpa as stage 2 input
+ * and map it onto the physical MSI doorbell.
+ */
+int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			     dma_addr_t iova, phys_addr_t gpa, size_t size)
+{
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iommu_dma_msi_page *msi;
+	int ret = 0;
+
+	if (!cookie)
+		return -EINVAL;
+
+	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
+		return -EINVAL;
+
+	iova = iova & ~(dma_addr_t)(size - 1);
+	gpa = gpa & ~(phys_addr_t)(size - 1);
+
+	spin_lock(&cookie->msi_lock);
+
+	list_for_each_entry(msi, &cookie->msi_page_list, list) {
+		if (msi->iova == iova)
+			goto unlock; /* this page is already registered */
+	}
+
+	msi = kzalloc(sizeof(*msi), GFP_ATOMIC);
+	if (!msi) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	msi->iova = iova;
+	msi->gpa = gpa;
+	msi->s1_granule = size;
+	list_add(&msi->list, &cookie->msi_page_list);
+unlock:
+	spin_unlock(&cookie->msi_lock);
+	return ret;
+}
+EXPORT_SYMBOL(iommu_dma_bind_guest_msi);
+
+void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
+{
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iommu_dma_msi_page *msi, *tmp;
+
+	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
+		dma_addr_t aligned_giova =
+			giova & ~(dma_addr_t)(msi->s1_granule - 1);
+
+		if (msi->iova == aligned_giova) {
+			if (msi->phys) {
+				/* unmap the stage 2 */
+				size_t size = cookie_msi_granule(cookie);
+
+				WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
+			}
+			list_del(&msi->list);
+			kfree(msi);
+		}
+	}
+}
+EXPORT_SYMBOL(iommu_dma_unbind_guest_msi);
+
 /**
  * iommu_dma_get_resv_regions - Reserved region driver helper
  * @dev: Device from iommu_get_resv_regions()
@@ -869,6 +965,33 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 		if (msi_page->phys == msi_addr)
 			return msi_page;
 
+	/*
+	 * In nested stage mode, we do not allocate an MSI page in
+	 * a range provided by the user. Instead, IOVA/IPA bindings are
+	 * individually provided. We reuse thise IOVAs to build the
+	 * GIOVA -> GPA -> MSI HPA nested stage mapping.
+	 */
+	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE) {
+		list_for_each_entry(msi_page, &cookie->msi_page_list, list)
+			if (!msi_page->phys) {
+				int ret;
+
+				/* do the stage 2 mapping */
+				ret = iommu_map(domain,
+						msi_page->gpa, msi_addr, size,
+						IOMMU_MMIO | IOMMU_WRITE);
+				if (ret) {
+					pr_warn("MSI S2 mapping failed (%d)\n",
+						ret);
+					return NULL;
+				}
+				msi_page->phys = msi_addr;
+				return msi_page;
+			}
+		pr_warn("%s no MSI binding found\n", __func__);
+		return NULL;
+	}
+
 	msi_page = kzalloc(sizeof(*msi_page), GFP_ATOMIC);
 	if (!msi_page)
 		return NULL;
diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
index e760dc5d1fa8..fa898d514edb 100644
--- a/include/linux/dma-iommu.h
+++ b/include/linux/dma-iommu.h
@@ -24,6 +24,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
 #include <linux/msi.h>
+#include <uapi/linux/iommu.h>
 
 int iommu_dma_init(void);
 
@@ -73,6 +74,9 @@ void iommu_dma_unmap_resource(struct device *dev, dma_addr_t handle,
 /* The DMA API isn't _quite_ the whole story, though... */
 void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg);
 void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
+int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
+			     dma_addr_t iova, phys_addr_t gpa, size_t size);
+void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova);
 
 #else
 
@@ -103,6 +107,19 @@ static inline void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg)
 {
 }
 
+static inline int
+iommu_dma_bind_guest_msi(struct iommu_domain *domain, struct device *dev,
+			 dma_addr_t iova, phys_addr_t gpa, size_t size)
+{
+	return -ENODEV;
+}
+
+static inline void
+iommu_dma_unbind_guest_msi(struct iommu_domain *domain,
+			   struct device *dev, dma_addr_t giova);
+{
+}
+
 static inline void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list)
 {
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
