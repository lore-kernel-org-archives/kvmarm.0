From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 10/12] ACPI / APEI: Add support for the SDEI GHES
 Notification type
Date: Wed, 16 May 2018 17:28:27 +0100
Message-ID: <20180516162829.14348-11-james.morse@arm.com>
References: <20180516162829.14348-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1357400D4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 12:24:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MfsXwl5-au6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 12:23:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 978D84A105
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 12:22:04 -0400 (EDT)
In-Reply-To: <20180516162829.14348-1-james.morse@arm.com>
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
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, inux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Punit Agrawal <punit.agrawal@arm.com>, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

If the GHES notification type is SDEI, register the provided event
number and point the callback at ghes_sdei_callback().

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
---
 drivers/acpi/apei/ghes.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/arm_sdei.h |  3 +++
 2 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 014966bdd0a7..72f7bc8435f7 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -25,6 +25,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/arm_sdei.h>
 #include <linux/kernel.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -58,7 +59,7 @@
 
 #define GHES_PFX	"GHES: "
 
-#if defined(CONFIG_HAVE_ACPI_APEI_NMI) || defined(CONFIG_ACPI_APEI_SEA)
+#if defined(CONFIG_HAVE_ACPI_APEI_NMI) || defined(CONFIG_ACPI_APEI_SEA) || defined(CONFIG_ARM_SDE_INTERFACE)
 #define WANT_NMI_ESTATUS_QUEUE	1
 #endif
 
@@ -750,7 +751,7 @@ static int _in_nmi_notify_one(struct ghes *ghes)
 	return 0;
 }
 
-static int ghes_estatus_queue_notified(struct list_head *rcu_list)
+static int __maybe_unused ghes_estatus_queue_notified(struct list_head *rcu_list)
 {
 	int ret = -ENOENT;
 	struct ghes *ghes;
@@ -1042,6 +1043,49 @@ static inline void ghes_nmi_add(struct ghes *ghes) { }
 static inline void ghes_nmi_remove(struct ghes *ghes) { }
 #endif /* CONFIG_HAVE_ACPI_APEI_NMI */
 
+static int ghes_sdei_callback(u32 event_num, struct pt_regs *regs, void *arg)
+{
+	struct ghes *ghes = arg;
+
+	if (!_in_nmi_notify_one(ghes)) {
+		if (IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG))
+			irq_work_queue(&ghes_proc_irq_work);
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int apei_sdei_register_ghes(struct ghes *ghes)
+{
+	int err = -EINVAL;
+
+	if (IS_ENABLED(CONFIG_ARM_SDE_INTERFACE)) {
+		ghes_estatus_queue_grow_pool(ghes);
+
+		err = sdei_register_ghes(ghes, ghes_sdei_callback);
+		if (err)
+			ghes_estatus_queue_shrink_pool(ghes);
+	}
+
+	return err;
+}
+
+static int apei_sdei_unregister_ghes(struct ghes *ghes)
+{
+	int err = -EINVAL;
+
+	if (IS_ENABLED(CONFIG_ARM_SDE_INTERFACE)) {
+		err = sdei_unregister_ghes(ghes);
+
+		if (!err)
+			ghes_estatus_queue_shrink_pool(ghes);
+	}
+
+	return err;
+}
+
 static int ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
@@ -1076,6 +1120,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1143,6 +1194,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_SOFTWARE_DELEGATED:
+		rc = apei_sdei_register_ghes(ghes);
+		if (rc)
+			goto err_edac_unreg;
+		break;
 	default:
 		BUG();
 	}
@@ -1164,6 +1220,7 @@ err:
 
 static int ghes_remove(struct platform_device *ghes_dev)
 {
+	int rc;
 	struct ghes *ghes;
 	struct acpi_hest_generic *generic;
 
@@ -1196,6 +1253,11 @@ static int ghes_remove(struct platform_device *ghes_dev)
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
index 5fdf799be026..f49063ca206d 100644
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
2.16.2
