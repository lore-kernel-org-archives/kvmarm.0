From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v11 06/10] genirq/msi-doorbell: msi_doorbell_safe
Date: Tue, 19 Jul 2016 13:02:43 +0000
Message-ID: <1468933367-23159-7-git-send-email-eric.auger@redhat.com>
References: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468933367-23159-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com, robin.murphy@arm.com, alex.williamson@redhat.com, will.deacon@arm.com, joro@8bytes.org, tglx@linutronix.de, jason@lakedaemon.net, linux-arm-kernel@lists.infradead.org
Cc: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, Bharat.Bhushan@freescale.com, pranav.sawargaonkar@gmail.com, p.fedin@samsung.com, iommu@lists.linux-foundation.org, Jean-Philippe.Brucker@arm.com, yehuday@marvell.com, Manish.Jaggi@caviumnetworks.com, robert.richter@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

msi_doorbell_safe returns whether all the registered doorbells
implement irq_remapping.

When assigning a PCIe device whose host controller is upstream to
an IOMMU, we currently do not know whether the MSI controller is
upstream or downstream to the IOMMU.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/linux/msi-doorbell.h | 12 ++++++++++++
 kernel/irq/msi-doorbell.c    | 15 +++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/msi-doorbell.h b/include/linux/msi-doorbell.h
index 146bfbc..9c30141 100644
--- a/include/linux/msi-doorbell.h
+++ b/include/linux/msi-doorbell.h
@@ -43,6 +43,13 @@ void msi_doorbell_unregister_global(struct irq_chip_msi_doorbell_info *db);
  */
 int msi_doorbell_pages(unsigned int order);
 
+/**
+ * msi_doorbell_safe: return whether all registered doorbells
+ * do implement irq_remapping and are safe to assign (coarse safety
+ * assessment)
+ */
+bool msi_doorbell_safe(void);
+
 #else
 
 static inline struct irq_chip_msi_doorbell_info *
@@ -61,6 +68,11 @@ msi_doorbell_pages(unsigned int order)
 	return 0;
 }
 
+static inline bool
+msi_doorbell_safe(void)
+{
+	return true;
+}
 #endif /* CONFIG_MSI_DOORBELL */
 
 #endif
diff --git a/kernel/irq/msi-doorbell.c b/kernel/irq/msi-doorbell.c
index a5bde37..fa5b429 100644
--- a/kernel/irq/msi-doorbell.c
+++ b/kernel/irq/msi-doorbell.c
@@ -112,3 +112,18 @@ int msi_doorbell_pages(unsigned int order)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(msi_doorbell_pages);
+
+bool msi_doorbell_safe(void)
+{
+	struct irqchip_doorbell *db;
+	bool irq_remapping = true;
+
+	mutex_lock(&irqchip_doorbell_mutex);
+	list_for_each_entry(db, &irqchip_doorbell_list, next) {
+		irq_remapping &= db->info.irq_remapping;
+	}
+	mutex_unlock(&irqchip_doorbell_mutex);
+
+	return irq_remapping;
+}
+EXPORT_SYMBOL_GPL(msi_doorbell_safe);
\ No newline at end of file
-- 
1.9.1
