From: Xie XiuQi <xiexiuqi@huawei.com>
Subject: [PATCH v3 2/8] acpi: apei: handle SEI notification type for ARMv8
Date: Thu, 30 Mar 2017 18:31:02 +0800
Message-ID: <1490869877-118713-3-git-send-email-xiexiuqi@huawei.com>
References: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FB5B40B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qZe43iA2eCLe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 06:32:49 -0400 (EDT)
Received: from dggrg02-dlp.huawei.com (unknown [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0990440C2A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 06:32:46 -0400 (EDT)
In-Reply-To: <1490869877-118713-1-git-send-email-xiexiuqi@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, fu.wei@linaro.org, rostedt@goodmis.org, hanjun.guo@linaro.org, shiju.jose@huawei.com
Cc: wuquanming@huawei.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, gengdongjiu@huawei.com, wangxiongfeng2@huawei.com, linux-acpi@vger.kernel.org, zhengqiang10@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

ARM APEI extension proposal added SEI (asynchronous SError interrupt)
notification type for ARMv8.

Add a new GHES error source handling function for SEI. In firmware
first mode, if an error source's notification type is SEI. Then GHES
could parse and report the detail error information.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 arch/arm64/kernel/traps.c | 10 ++++++++
 drivers/acpi/apei/Kconfig | 14 ++++++++++++
 drivers/acpi/apei/ghes.c  | 58 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/ghes.h       |  1 +
 4 files changed, 83 insertions(+)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index e52be6a..53710a2 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -47,6 +47,8 @@
 #include <asm/system_misc.h>
 #include <asm/sysreg.h>
 
+#include <acpi/ghes.h>
+
 static const char *handler[]= {
 	"Synchronous Abort",
 	"IRQ",
@@ -625,6 +627,14 @@ asmlinkage void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
 		handler[reason], smp_processor_id(), esr,
 		esr_get_class_string(esr));
 
+	/*
+	 * In firmware first mode, we could assume firmware will only generate one
+	 * of cper records at a time. There is no risk for one cpu to parse ghes table.
+	 */
+	if (IS_ENABLED(CONFIG_ACPI_APEI_SEI) && ESR_ELx_EC(esr) == ESR_ELx_EC_SERROR) {
+		ghes_notify_sei();
+	}
+
 	die("Oops - bad mode", regs, 0);
 	local_irq_disable();
 	panic("bad mode");
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index b54bd33..c00c9d34 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -55,6 +55,20 @@ config ACPI_APEI_SEA
 	  option allows the OS to look for such hardware error record, and
 	  take appropriate action.
 
+config ACPI_APEI_SEI
+	bool "APEI Asynchronous SError Interrupt logging/recovering support"
+	depends on ARM64 && ACPI_APEI_GHES
+	help
+	  This option should be enabled if the system supports
+	  firmware first handling of SEI (asynchronous SError interrupt).
+
+	  SEI happens with invalid instruction access or asynchronous exceptions
+	  on ARMv8 systems. If a system supports firmware first handling of SEI,
+	  the platform analyzes and handles hardware error notifications from
+	  SEI, and it may then form a HW error record for the OS to parse and
+	  handle. This option allows the OS to look for such hardware error
+	  record, and take appropriate action.
+
 config ACPI_APEI_MEMORY_FAILURE
 	bool "APEI memory error recovering support"
 	depends on ACPI_APEI && MEMORY_FAILURE
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 6be0333..045d101 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -862,6 +862,51 @@ static inline void ghes_sea_remove(struct ghes *ghes)
 }
 #endif /* CONFIG_ACPI_APEI_SEA */
 
+#ifdef CONFIG_ACPI_APEI_SEI
+static LIST_HEAD(ghes_sei);
+
+int ghes_notify_sei(void)
+{
+	struct ghes *ghes;
+	int ret = -ENOENT;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ghes, &ghes_sei, list) {
+		if(!ghes_proc(ghes))
+			ret = 0;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static void ghes_sei_add(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_add_rcu(&ghes->list, &ghes_sei);
+	mutex_unlock(&ghes_list_mutex);
+}
+
+static void ghes_sei_remove(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	mutex_unlock(&ghes_list_mutex);
+	synchronize_rcu();
+}
+#else /* CONFIG_ACPI_APEI_SEI */
+static inline void ghes_sei_add(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to add SEI notification which is not supported\n",
+	       ghes->generic->header.source_id);
+}
+
+static inline void ghes_sei_remove(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to remove SEI notification which is not supported\n",
+	       ghes->generic->header.source_id);
+}
+#endif /* CONFIG_HAVE_ACPI_APEI_SEI */
+
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
  * printk is not safe in NMI context.  So in NMI handler, we allocate
@@ -1111,6 +1156,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 			goto err;
 		}
 		break;
+	case ACPI_HEST_NOTIFY_SEI:
+		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_SEI)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEI is not supported!\n",
+				generic->header.source_id);
+			goto err;
+		}
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
 			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
@@ -1179,6 +1231,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_SEA:
 		ghes_sea_add(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_SEI:
+		ghes_sei_add(ghes);
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
@@ -1224,6 +1279,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_SEA:
 		ghes_sea_remove(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_SEI:
+		ghes_sei_remove(ghes);
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_remove(ghes);
 		break;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 2a727dc..10d752e 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -100,5 +100,6 @@ static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data
 }
 
 int ghes_notify_sea(void);
+int ghes_notify_sei(void);
 
 #endif /* GHES_H */
-- 
1.8.3.1
