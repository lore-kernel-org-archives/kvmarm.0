From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v3 12/21] dma-iommu: Implement NESTED_MSI cookie
Date: Tue,  8 Jan 2019 11:26:24 +0100
Message-ID: <20190108102633.17482-13-eric.auger@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20190108102633.17482-1-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yi.l.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org
Cc: marc.zyngier-5wv7dgnIgG8@public.gmane.org, peter.maydell-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christoffer.dall-5wv7dgnIgG8@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Up to now, when the type was UNMANAGED, we used to
allocate IOVA pages within a range provided by the user.
This does not work in nested mode.

If both the host and the guest are exposed with SMMUs, each
would allocate an IOVA. The guest allocates an IOVA (gIOVA)
to map onto the guest MSI doorbell (gDB). The Host allocates
another IOVA (hIOVA) to map onto the physical doorbell (hDB).

So we end up with 2 unrelated mappings, at S1 and S2:
         S1             S2
gIOVA    ->     gDB
               hIOVA    ->    hDB

The PCI device would be programmed with hIOVA.

iommu_dma_bind_doorbell allows to pass gIOVA/gDB to the host
so that gIOVA can be used by the host instead of re-allocating
a new IOVA. The device handle also is passed to garantee
devices belonging to different stage1 domains record
distinguishable stage1 mappings. That way the host can create
the following nested
mapping:

         S1           S2
gIOVA    ->    gDB    ->    hDB

this time, the PCI device will be programmed with the gIOVA MSI
doorbell which is correctly mapped through the 2 stages.

Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---

v2 -> v3:
- also store the device handle on S1 mapping registration.
  This garantees we associate the associated S2 mapping binds
  to the correct physical MSI controller.

v1 -> v2:
- unmap stage2 on put()
---
 drivers/iommu/dma-iommu.c | 112 ++++++++++++++++++++++++++++++++++++--
 include/linux/dma-iommu.h |  11 ++++
 2 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index d19f3d6b43c1..19af8107e959 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -35,12 +35,15 @@
 struct iommu_dma_msi_page {
 	struct list_head	list;
 	dma_addr_t		iova;
+	dma_addr_t		ipa;
 	phys_addr_t		phys;
+	struct device		*dev;
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
+			WARN_ON(iommu_unmap(domain, msi->ipa, size) != size);
+		}
 		list_del(&msi->list);
 		kfree(msi);
 	}
@@ -162,6 +182,52 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 }
 EXPORT_SYMBOL(iommu_put_dma_cookie);
 
+/**
+ * iommu_dma_bind_doorbell - Allows to provide a usable IOVA page
+ * @domain: domain handle
+ * @dev: device handle
+ * @binding: IOVA/IPA binding
+ *
+ * In nested stage use case, the user can provide IOVA/IPA bindings
+ * corresponding to a guest MSI stage 1 mapping. When the host needs
+ * to map its own MSI doorbells, it can use the IPA as stage 2 input
+ * and map it onto the physical MSI doorbell.
+ */
+int iommu_dma_bind_doorbell(struct iommu_domain *domain, struct device *dev,
+			    struct iommu_guest_msi_binding *binding)
+{
+	struct iommu_dma_cookie *cookie = domain->iova_cookie;
+	struct iommu_dma_msi_page *msi;
+	dma_addr_t ipa, iova;
+	size_t size;
+
+	if (!cookie)
+		return -EINVAL;
+
+	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
+		return -EINVAL;
+
+	size = 1 << binding->granule;
+	iova = binding->iova & ~(phys_addr_t)(size - 1);
+	ipa = binding->gpa & ~(phys_addr_t)(size - 1);
+
+	list_for_each_entry(msi, &cookie->msi_page_list, list) {
+		if (msi->iova == iova && msi->dev == dev)
+			return 0; /* this page is already registered */
+	}
+
+	msi = kzalloc(sizeof(*msi), GFP_KERNEL);
+	if (!msi)
+		return -ENOMEM;
+
+	msi->iova = iova;
+	msi->ipa = ipa;
+	msi->dev = dev;
+	list_add(&msi->list, &cookie->msi_page_list);
+	return 0;
+}
+EXPORT_SYMBOL(iommu_dma_bind_doorbell);
+
 /**
  * iommu_dma_get_resv_regions - Reserved region driver helper
  * @dev: Device from iommu_get_resv_regions()
@@ -856,6 +922,16 @@ void iommu_dma_unmap_resource(struct device *dev, dma_addr_t handle,
 	__iommu_dma_unmap(iommu_get_dma_domain(dev), handle, size);
 }
 
+static bool msi_page_match(struct iommu_dma_msi_page *msi_page,
+			   struct device *dev, phys_addr_t msi_addr)
+{
+	bool match = msi_page->phys == msi_addr;
+
+	if (msi_page->dev)
+		match &= (msi_page->dev == dev);
+	return match;
+}
+
 static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 		phys_addr_t msi_addr, struct iommu_domain *domain)
 {
@@ -867,9 +943,37 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
 
 	msi_addr &= ~(phys_addr_t)(size - 1);
 	list_for_each_entry(msi_page, &cookie->msi_page_list, list)
-		if (msi_page->phys == msi_addr)
+		if (msi_page_match(msi_page, dev, msi_addr))
 			return msi_page;
 
+	/*
+	 * In nested stage mode, we do not allocate an MSI page in
+	 * a range provided by the user. Instead, IOVA/IPA bindings are
+	 * individually provided. We reuse thise IOVAs to build the
+	 * IOVA -> IPA -> MSI PA nested stage mapping.
+	 */
+	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE) {
+		list_for_each_entry(msi_page, &cookie->msi_page_list, list)
+			if (!msi_page->phys && msi_page->dev == dev) {
+				dma_addr_t ipa = msi_page->ipa;
+				int ret;
+
+				msi_page->phys = msi_addr;
+
+				/* do the stage 2 mapping */
+				ret = iommu_map(domain, ipa, msi_addr, size,
+						IOMMU_MMIO | IOMMU_WRITE);
+				if (ret) {
+					pr_warn("MSI S2 mapping failed (%d)\n",
+						ret);
+					return NULL;
+				}
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
index e760dc5d1fa8..778243719462 100644
--- a/include/linux/dma-iommu.h
+++ b/include/linux/dma-iommu.h
@@ -24,6 +24,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
 #include <linux/msi.h>
+#include <uapi/linux/iommu.h>
 
 int iommu_dma_init(void);
 
@@ -73,12 +74,15 @@ void iommu_dma_unmap_resource(struct device *dev, dma_addr_t handle,
 /* The DMA API isn't _quite_ the whole story, though... */
 void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg);
 void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
+int iommu_dma_bind_doorbell(struct iommu_domain *domain, struct device *dev,
+			    struct iommu_guest_msi_binding *binding);
 
 #else
 
 struct iommu_domain;
 struct msi_msg;
 struct device;
+struct iommu_guest_msi_binding;
 
 static inline int iommu_dma_init(void)
 {
@@ -103,6 +107,13 @@ static inline void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg)
 {
 }
 
+static inline int
+iommu_dma_bind_doorbell(struct iommu_domain *domain,
+			struct iommu_guest_msi_binding *binding)
+{
+	return -ENODEV;
+}
+
 static inline void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list)
 {
 }
-- 
2.17.2
