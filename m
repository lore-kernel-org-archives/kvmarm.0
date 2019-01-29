From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 26/26] ACPI / APEI: Add support for the SDEI GHES
 Notification type
Date: Tue, 29 Jan 2019 18:49:02 +0000
Message-ID: <20190129184902.102850-27-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A33A4A39F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nE+hBu9j7bXl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:55 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3274A399
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:55 -0500 (EST)
In-Reply-To: <20190129184902.102850-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-acpi@vger.kernel.org
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

If the GHES notification type is SDEI, register the provided event
using the SDEI-GHES helper.

SDEI may be one of two types of event, normal and critical. Critical
events can interrupt normal events, so these must have separate
fixmap slots and locks in case both event types are in use.

Signed-off-by: James Morse <james.morse@arm.com>

--
Changes since v7:
 * Use __end_of_fixed_addresses as an arch-agnostic invalid fixmap entry
 * Move the locks definition into the function that uses them to make it
   clear these are NMI only.

Changes since v6:
 * Tinkering due to the absence of #ifdef
 * Added SDEI to the new ghes_is_synchronous() helper.

---
 drivers/acpi/apei/ghes.c | 85 ++++++++++++++++++++++++++++++++++++++++
 include/linux/arm_sdei.h |  3 ++
 2 files changed, 88 insertions(+)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index dfa8f155f964..d0f0a219bf8f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -25,6 +25,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/arm_sdei.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -86,6 +87,15 @@
 	((struct acpi_hest_generic_status *)				\
 	 ((struct ghes_estatus_node *)(estatus_node) + 1))
 
+/*
+ *  NMI-like notifications vary by architecture, before the compiler can prune
+ *  unused static functions it needs a value for these enums.
+ */
+#ifndef CONFIG_ARM_SDE_INTERFACE
+#define FIX_APEI_GHES_SDEI_NORMAL	__end_of_fixed_addresses
+#define FIX_APEI_GHES_SDEI_CRITICAL	__end_of_fixed_addresses
+#endif
+
 static inline bool is_hest_type_generic_v2(struct ghes *ghes)
 {
 	return ghes->generic->header.type == ACPI_HEST_TYPE_GENERIC_ERROR_V2;
@@ -1088,6 +1098,63 @@ static void ghes_nmi_init_cxt(void)
 	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
 }
 
+static int __ghes_sdei_callback(struct ghes *ghes,
+				enum fixed_addresses fixmap_idx)
+{
+	if (!ghes_in_nmi_queue_one_entry(ghes, fixmap_idx)) {
+		irq_work_queue(&ghes_proc_irq_work);
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int ghes_sdei_normal_callback(u32 event_num, struct pt_regs *regs,
+				      void *arg)
+{
+	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sdei_normal);
+	struct ghes *ghes = arg;
+	int err;
+
+	raw_spin_lock(&ghes_notify_lock_sdei_normal);
+	err = __ghes_sdei_callback(ghes, FIX_APEI_GHES_SDEI_NORMAL);
+	raw_spin_unlock(&ghes_notify_lock_sdei_normal);
+
+	return err;
+}
+
+static int ghes_sdei_critical_callback(u32 event_num, struct pt_regs *regs,
+				       void *arg)
+{
+	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sdei_critical);
+	struct ghes *ghes = arg;
+	int err;
+
+	raw_spin_lock(&ghes_notify_lock_sdei_critical);
+	err = __ghes_sdei_callback(ghes, FIX_APEI_GHES_SDEI_CRITICAL);
+	raw_spin_unlock(&ghes_notify_lock_sdei_critical);
+
+	return err;
+}
+
+static int apei_sdei_register_ghes(struct ghes *ghes)
+{
+	if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE))
+		return -EOPNOTSUPP;
+
+	return sdei_register_ghes(ghes, ghes_sdei_normal_callback,
+				 ghes_sdei_critical_callback);
+}
+
+static int apei_sdei_unregister_ghes(struct ghes *ghes)
+{
+	if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE))
+		return -EOPNOTSUPP;
+
+	return sdei_unregister_ghes(ghes);
+}
+
 static int ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
@@ -1123,6 +1190,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 			goto err;
 		}
 		break;
+	case ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED:
+		if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SDE Interface is not supported!\n",
+				generic->header.source_id);
+			goto err;
+		}
+		break;
 	case ACPI_HEST_NOTIFY_LOCAL:
 		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
 			   generic->header.source_id);
@@ -1186,6 +1260,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED:
+		rc = apei_sdei_register_ghes(ghes);
+		if (rc)
+			goto err;
+		break;
 	default:
 		BUG();
 	}
@@ -1211,6 +1290,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
 
 static int ghes_remove(struct platform_device *ghes_dev)
 {
+	int rc;
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
 
@@ -1243,6 +1323,11 @@ static int ghes_remove(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_remove(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED:
+		rc = apei_sdei_unregister_ghes(ghes);
+		if (rc)
+			return rc;
+		break;
 	default:
 		BUG();
 		break;
diff --git a/include/linux/arm_sdei.h b/include/linux/arm_sdei.h
index 393899192906..3305ea7f9dc7 100644
--- a/include/linux/arm_sdei.h
+++ b/include/linux/arm_sdei.h
@@ -12,7 +12,10 @@ enum sdei_conduit_types {
 };
 
 #include <acpi/ghes.h>
+
+#ifdef CONFIG_ARM_SDE_INTERFACE
 #include <asm/sdei.h>
+#endif
 
 /* Arch code should override this to set the entry point from firmware... */
 #ifndef sdei_arch_get_entry_point
-- 
2.20.1
