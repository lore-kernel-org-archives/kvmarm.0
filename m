From: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v11 05/10] genirq/msi-doorbell: msi_doorbell_pages
Date: Tue, 19 Jul 2016 13:02:42 +0000
Message-ID: <1468933367-23159-6-git-send-email-eric.auger@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1468933367-23159-1-git-send-email-eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

msi_doorbell_pages sum up the number of iommu pages of a given order
requested to map all the registered doorbells. This function will allow
to dimension the intermediate physical address (IPA) aperture requested
to map the MSI doorbells.

Signed-off-by: Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---

v10: creation
---
 include/linux/msi-doorbell.h | 14 ++++++++++++
 kernel/irq/msi-doorbell.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/include/linux/msi-doorbell.h b/include/linux/msi-doorbell.h
index c455e33..146bfbc 100644
--- a/include/linux/msi-doorbell.h
+++ b/include/linux/msi-doorbell.h
@@ -35,6 +35,14 @@ msi_doorbell_register_global(phys_addr_t base, size_t size,
  */
 void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *db);
 
+/**
+ * msi_doorbell_pages: compute the number of iommu pages of size 1 << order
+ * requested to map all the registered doorbells
+ *
+ * @order: iommu page order
+ */
+int msi_doorbell_pages(unsigned int order);
+
 #else
 
 static inline struct irq_chip_msi_doorbell_info *
@@ -47,6 +55,12 @@ msi_doorbell_register_global(phys_addr_t base, size_t size,
 static inline void
 msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *db) {}
 
+static inline int
+msi_doorbell_pages(unsigned int order)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MSI_DOORBELL */
 
 #endif
diff --git a/kernel/irq/msi-doorbell.c b/kernel/irq/msi-doorbell.c
index 0ff541e..a5bde37 100644
--- a/kernel/irq/msi-doorbell.c
+++ b/kernel/irq/msi-doorbell.c
@@ -60,3 +60,55 @@ void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *dbinfo)
 	mutex_unlock(&irqchip_doorbell_mutex);
 }
 EXPORT_SYMBOL_GPL(msi_doorbell_unregister_global);
+
+static int compute_db_mapping_requirements(phys_addr_t addr, size_t size,
+					   unsigned int order)
+{
+	phys_addr_t offset, granule;
+	unsigned int nb_pages;
+
+	granule = (uint64_t)(1 << order);
+	offset = addr & (granule - 1);
+	size = ALIGN(size + offset, granule);
+	nb_pages = size >> order;
+
+	return nb_pages;
+}
+
+static int
+compute_dbinfo_mapping_requirements(struct irq_chip_msi_doorbell_info *dbinfo,
+				    unsigned int order)
+{
+	int ret = 0;
+
+	if (!dbinfo->doorbell_is_percpu) {
+		ret = compute_db_mapping_requirements(dbinfo->global_doorbell,
+						      dbinfo->size, order);
+	} else {
+		phys_addr_t __percpu *pbase;
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			pbase = per_cpu_ptr(dbinfo->percpu_doorbells, cpu);
+			ret += compute_db_mapping_requirements(*pbase,
+							       dbinfo->size,
+							       order);
+		}
+	}
+	return ret;
+}
+
+int msi_doorbell_pages(unsigned int order)
+{
+	struct irqchip_doorbell *db;
+	int ret = 0;
+
+	mutex_lock(&irqchip_doorbell_mutex);
+	list_for_each_entry(db, &irqchip_doorbell_list, next) {
+		ret += compute_dbinfo_mapping_requirements(&db->info, order);
+	}
+	mutex_unlock(&irqchip_doorbell_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(msi_doorbell_pages);
-- 
1.9.1
