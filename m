From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 04/10] genirq/msi-doorbell: allow MSI doorbell (un)registration
Date: Tue, 19 Jul 2016 13:02:41 +0000
Message-ID: <1468933367-23159-5-git-send-email-eric.auger@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

This new API aims at allowing irqchips to allocate & register
the MSI doorbells likely to be iommu mapped.

Later on, other services will be added allowing the VFIO layer
to query information based on all registered doorbells.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v10 -> v11:
- remove void *chip_data argument from register/unregister function
- remove lookup funtions since we restored the struct irq_chip
  msi_doorbell_info ops to realize this function
- reword commit message and title
---
 drivers/iommu/Kconfig        |  1 +
 include/linux/msi-doorbell.h | 52 +++++++++++++++++++++++++++++++++++++
 kernel/irq/Kconfig           |  4 +++
 kernel/irq/Makefile          |  1 +
 kernel/irq/msi-doorbell.c    | 62 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 120 insertions(+)
 create mode 100644 include/linux/msi-doorbell.h
 create mode 100644 kernel/irq/msi-doorbell.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 5ea1610..ba54146 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -78,6 +78,7 @@ config IOMMU_DMA
 config IOMMU_MSI
 	bool
 	select IOMMU_DMA
+	select MSI_DOORBELL
 
 config FSL_PAMU
 	bool "Freescale IOMMU support"
diff --git a/include/linux/msi-doorbell.h b/include/linux/msi-doorbell.h
new file mode 100644
index 0000000..c455e33
--- /dev/null
+++ b/include/linux/msi-doorbell.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2016 Eric Auger
+ *
+ * Eric Auger <eric.auger@linaro.org>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _LINUX_MSI_DOORBELL_H
+#define _LINUX_MSI_DOORBELL_H
+
+#include <linux/irq.h>
+
+#ifdef CONFIG_MSI_DOORBELL
+
+/**
+ * msi_doorbell_register_global: allocate and register a global doorbell
+ *
+ * @base: physical base address of the global doorbell
+ * @size: size of the global doorbell
+ * @prot: protection/memory attributes
+ * @irq_remapping: is irq_remapping implemented for this doorbell
+ * returns the newly allocated doorbell info handle
+ */
+struct irq_chip_msi_doorbell_info *
+msi_doorbell_register_global(phys_addr_t base, size_t size,
+			     int prot, bool irq_remapping);
+
+/**
+ * msi_doorbell_unregister: remove a doorbell from the list of registered
+ * doorbells and deallocates its
+ * @db: doorbell info to unregister
+ */
+void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *db);
+
+#else
+
+static inline struct irq_chip_msi_doorbell_info *
+msi_doorbell_register_global(phys_addr_t base, size_t size,
+			     int prot, bool irq_remapping)
+{
+	return ERR_PTR(-ENOENT);
+}
+
+static inline void
+msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *db) {}
+
+#endif /* CONFIG_MSI_DOORBELL */
+
+#endif
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 3bbfd6a..d4faaaa 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -72,6 +72,10 @@ config GENERIC_IRQ_IPI
 config GENERIC_MSI_IRQ
 	bool
 
+# MSI doorbell support (for doorbell IOMMU mapping)
+config MSI_DOORBELL
+	bool
+
 # Generic MSI hierarchical interrupt domain support
 config GENERIC_MSI_IRQ_DOMAIN
 	bool
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 2ee42e9..be02dfd 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_GENERIC_IRQ_MIGRATION) += cpuhotplug.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
 obj-$(CONFIG_GENERIC_MSI_IRQ) += msi.o
 obj-$(CONFIG_GENERIC_IRQ_IPI) += ipi.o
+obj-$(CONFIG_MSI_DOORBELL) += msi-doorbell.o
diff --git a/kernel/irq/msi-doorbell.c b/kernel/irq/msi-doorbell.c
new file mode 100644
index 0000000..0ff541e
--- /dev/null
+++ b/kernel/irq/msi-doorbell.c
@@ -0,0 +1,62 @@
+/*
+ * linux/kernel/irq/msi-doorbell.c
+ *
+ * Copyright (C) 2016 Linaro
+ * Author: Eric Auger <eric.auger@linaro.org>
+ *
+ * This file is licensed under GPLv2.
+ *
+ * This file contains common code to manage MSI doorbells likely
+ * to be iommu mapped. Typically meaningful on ARM.
+ */
+
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <linux/msi-doorbell.h>
+
+struct irqchip_doorbell {
+	struct irq_chip_msi_doorbell_info info;
+	struct list_head next;
+};
+
+static LIST_HEAD(irqchip_doorbell_list);
+static DEFINE_MUTEX(irqchip_doorbell_mutex);
+
+struct irq_chip_msi_doorbell_info *
+msi_doorbell_register_global(phys_addr_t base, size_t size,
+			     int prot, bool irq_remapping)
+{
+	struct irqchip_doorbell *db;
+
+	db = kmalloc(sizeof(*db), GFP_KERNEL);
+	if (!db)
+		return ERR_PTR(-ENOMEM);
+
+	db->info.doorbell_is_percpu = false;
+	db->info.global_doorbell = base;
+	db->info.size = size;
+	db->info.prot = prot;
+	db->info.irq_remapping = irq_remapping;
+
+	mutex_lock(&irqchip_doorbell_mutex);
+	list_add(&db->next, &irqchip_doorbell_list);
+	mutex_unlock(&irqchip_doorbell_mutex);
+	return &db->info;
+}
+EXPORT_SYMBOL_GPL(msi_doorbell_register_global);
+
+void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *dbinfo)
+{
+	struct irqchip_doorbell *db, *tmp;
+
+	mutex_lock(&irqchip_doorbell_mutex);
+	list_for_each_entry_safe(db, tmp, &irqchip_doorbell_list, next) {
+		if (dbinfo == &db->info) {
+			list_del(&db->next);
+			kfree(db);
+			break;
+		}
+	}
+	mutex_unlock(&irqchip_doorbell_mutex);
+}
+EXPORT_SYMBOL_GPL(msi_doorbell_unregister_global);
-- 
1.9.1
