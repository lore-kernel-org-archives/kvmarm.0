From: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC v2 04/15] iommu: add alloc/free_reserved_iova_domain
Date: Thu, 11 Feb 2016 14:34:11 +0000
Message-ID: <1455201262-5259-5-git-send-email-eric.auger@linaro.org>
References: <1455201262-5259-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1455201262-5259-1-git-send-email-eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-qxv4g6HH51o@public.gmane.org, eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Thomas.Lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sherry.hurwitz-5C7GfCeVMHo@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

Introduce alloc/free_reserved_iova_domain in the IOMMU API.
alloc_reserved_iova_domain initializes an iova domain at a given
iova base address and with a given size. This iova domain will
be used to allocate iova within that window. Those IOVAs will be reserved
for special purpose, typically MSI frame binding. Allocation function
within the reserved iova domain will be introduced in subsequent patches.

This is the responsability of the API user to make sure any IOVA
belonging to that domain are allocated with those allocation functions.

Signed-off-by: Eric Auger <eric.auger-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

---

v1 -> v2:
- moved from vfio API to IOMMU API
---
 drivers/iommu/iommu.c | 22 ++++++++++++++++++++++
 include/linux/iommu.h | 21 +++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0e3b009..a994f34 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1557,6 +1557,28 @@ int iommu_domain_set_attr(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
 
+int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
+				     dma_addr_t iova, size_t size,
+				     unsigned long order)
+{
+	int ret;
+
+	if (!domain->ops->alloc_reserved_iova_domain)
+		return -EINVAL;
+	ret = domain->ops->alloc_reserved_iova_domain(domain, iova,
+						      size, order);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_alloc_reserved_iova_domain);
+
+void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+{
+	if (!domain->ops->free_reserved_iova_domain)
+		return;
+	domain->ops->free_reserved_iova_domain(domain);
+}
+EXPORT_SYMBOL_GPL(iommu_free_reserved_iova_domain);
+
 void iommu_get_dm_regions(struct device *dev, struct list_head *list)
 {
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a4fe04a..32c1a4e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -195,6 +195,12 @@ struct iommu_ops {
 	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
 	/* Get the number of windows per domain */
 	u32 (*domain_get_windows)(struct iommu_domain *domain);
+	/* allocates the reserved iova domain */
+	int (*alloc_reserved_iova_domain)(struct iommu_domain *domain,
+					  dma_addr_t iova, size_t size,
+					  unsigned long order);
+	/* frees the reserved iova domain */
+	void (*free_reserved_iova_domain)(struct iommu_domain *domain);
 
 #ifdef CONFIG_OF_IOMMU
 	int (*of_xlate)(struct device *dev, struct of_phandle_args *args);
@@ -266,6 +272,10 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
+extern int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
+					    dma_addr_t iova, size_t size,
+					    unsigned long order);
+extern void iommu_free_reserved_iova_domain(struct iommu_domain *domain);
 struct device *iommu_device_create(struct device *parent, void *drvdata,
 				   const struct attribute_group **groups,
 				   const char *fmt, ...) __printf(4, 5);
@@ -541,6 +551,17 @@ static inline void iommu_device_unlink(struct device *dev, struct device *link)
 {
 }
 
+static int iommu_alloc_reserved_iova_domain(struct iommu_domain *domain,
+					    dma_addr_t iova, size_t size,
+					    unsigned long order)
+{
+	return -EINVAL;
+}
+
+static void iommu_free_reserved_iova_domain(struct iommu_domain *domain)
+{
+}
+
 #endif /* CONFIG_IOMMU_API */
 
 #endif /* __LINUX_IOMMU_H */
-- 
1.9.1
