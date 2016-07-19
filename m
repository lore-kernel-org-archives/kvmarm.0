From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 6/8] iommu/msi-iommu: iommu_msi_domain
Date: Tue, 19 Jul 2016 12:55:09 +0000
Message-ID: <1468932911-23062-7-git-send-email-eric.auger@redhat.com>
References: <1468932911-23062-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468932911-23062-1-git-send-email-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, andre.przywara-5wv7dgnIgG8@public.gmane.org, robin.murphy-5wv7dgnIgG8@public.gmane.org, alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: drjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manish.Jaggi-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, p.fedin-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, pranav.sawargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, yehuday-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

This function checks whether
- the device belongs to a non default iommu domain
- this iommu domain requires the MSI address to be mapped.

If those conditions are met, the function returns the iommu domain
to be used for mapping the MSI doorbell; else it returns NULL.

Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
v8 -> v9:
- use iommu_msi_supported

v7 -> v8:
- renamed  iommu_msi_mapping_desc_to_domain to iommu_msi_domain
- the function now takes a struct device *
- use DOMAIN_ATTR_MSI_GEOMETRY attribute
---
 drivers/iommu/msi-iommu.c | 17 +++++++++++++++++
 include/linux/msi-iommu.h | 14 ++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/iommu/msi-iommu.c b/drivers/iommu/msi-iommu.c
index 57017cb..41a5823 100644
--- a/drivers/iommu/msi-iommu.c
+++ b/drivers/iommu/msi-iommu.c
@@ -248,3 +248,20 @@ unlock:
 	}
 }
 EXPORT_SYMBOL_GPL(iommu_msi_put_doorbell_iova);
+
+struct iommu_domain *iommu_msi_domain(struct device *dev)
+{
+	struct iommu_domain *d = iommu_get_domain_for_dev(dev);
+	struct iommu_domain_msi_geometry msi_geometry;
+
+	if (!d || (d->type == IOMMU_DOMAIN_DMA))
+		return NULL;
+
+	iommu_domain_get_attr(d, DOMAIN_ATTR_MSI_GEOMETRY, &msi_geometry);
+	if (!msi_geometry.iommu_msi_supported)
+		return NULL;
+
+	return d;
+}
+EXPORT_SYMBOL_GPL(iommu_msi_domain);
+
diff --git a/include/linux/msi-iommu.h b/include/linux/msi-iommu.h
index 1cd115f..114bd69 100644
--- a/include/linux/msi-iommu.h
+++ b/include/linux/msi-iommu.h
@@ -81,6 +81,15 @@ int iommu_msi_get_doorbell_iova(struct iommu_domain *domain,
  */
 void iommu_msi_put_doorbell_iova(struct iommu_domain *domain, phys_addr_t addr);
 
+/**
+ * iommu_msi_domain: in case the device is upstream to an IOMMU and this IOMMU
+ * translates the MSI transaction, returns the iommu domain the MSI doorbell
+ * address must be mapped in; else returns NULL.
+ *
+ * @dev: device handle
+ */
+struct iommu_domain *iommu_msi_domain(struct device *dev);
+
 #else
 
 static inline int
@@ -100,5 +109,10 @@ static inline int iommu_msi_get_doorbell_iova(struct iommu_domain *domain,
 static inline void iommu_msi_put_doorbell_iova(struct iommu_domain *domain,
 					       phys_addr_t addr) {}
 
+static inline struct iommu_domain *iommu_msi_domain(struct device *dev)
+{
+	return NULL;
+}
+
 #endif	/* CONFIG_IOMMU_MSI */
 #endif	/* __MSI_IOMMU_H */
-- 
1.9.1
