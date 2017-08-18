From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v5 3/7] acpi: apei: Add SEI notification type support for ARMv8
Date: Fri, 18 Aug 2017 22:11:53 +0800
Message-ID: <1503065517-7920-4-git-send-email-gengdongjiu@huawei.com>
References: <1503065517-7920-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EB6B49C96
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 09:47:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1j-Ihto5a+y6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Aug 2017 09:47:55 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 08ED849C80
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 09:47:53 -0400 (EDT)
In-Reply-To: <1503065517-7920-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com, mark.rutland@arm.com, james.morse@arm.com, xiexiuqi@huawei.com, cov@codeaurora.org, david.daney@cavium.com, suzuki.poulose@arm.com, stefan@hello-penguin.com, Dave.Martin@arm.com, kristina.martsenko@arm.com, wangkefeng.wang@huawei.com, tbaicar@codeaurora.org, ard.biesheuvel@linaro.org, mingo@kernel.org, bp@suse.de, shiju.jose@huawei.com, zjzhang@codeaurora.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org, mst@redhat.com, john.garry@huawei.com, jonathan.cameron@huawei.com, shameerali.kolot
Cc: zhengqiang10@huawei.com, wuquanming@huawei.com, huangshaoyu@huawei.com, linuxarm@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

ARMV8.2 requires implementation of the RAS extension, in
this extension it adds SEI(SError Interrupt) notification
type, this patch addes a new GHES error source handling
function for SEI. Because this error source parse and handling
method are similar with the SEA. so use one function to handle
them.

In current code logic, The two functions ghes_sea_add() and
ghes_sea_remove() are only called when CONFIG_ACPI_APEI_SEA
and CONFIG_ACPI_APEI_SEI are defined. If not, it will return
errors in the ghes_probe() and do not continue, so remove the
useless code that handling CONFIG_ACPI_APEI_SEA and
CONFIG_ACPI_APEI_SEI do not defined.

Expose one API ghes_notify_sex() to external, external modules
can call this exposed APIs to parse and handling the SEA/SEI.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/mm/fault.c     | 21 +++++++++++++++--
 drivers/acpi/apei/Kconfig | 15 ++++++++++++
 drivers/acpi/apei/ghes.c  | 60 ++++++++++++++++++++++++++++++-----------------
 include/acpi/ghes.h       |  2 +-
 4 files changed, 74 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 2509e4fe6992..0aa92a69c280 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -585,7 +585,7 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 		if (interrupts_enabled(regs))
 			nmi_enter();
 
-		ret = ghes_notify_sea();
+		ret = ghes_notify_sex(ACPI_HEST_NOTIFY_SEA);
 
 		if (interrupts_enabled(regs))
 			nmi_exit();
@@ -682,7 +682,24 @@ int handle_guest_sea(phys_addr_t addr, unsigned int esr)
 	int ret = -ENOENT;
 
 	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA))
-		ret = ghes_notify_sea();
+		ret = ghes_notify_sex(ACPI_HEST_NOTIFY_SEA);
+
+	return ret;
+}
+
+/*
+ * Handle SError interrupt that occur in a guest kernel.
+ *
+ * The return value will be zero if the SEI was successfully handled
+ * and non-zero if there was an error processing the error or there was
+ * no error to process.
+ */
+int handle_guest_sei(phys_addr_t addr, unsigned int esr)
+{
+	int ret = -ENOENT;
+
+	if (IS_ENABLED(CONFIG_ACPI_APEI_SEI))
+		ret = ghes_notify_sex(ACPI_HEST_NOTIFY_SEI);
 
 	return ret;
 }
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index de14d49a5c90..556370c763ec 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -54,6 +54,21 @@ config ACPI_APEI_SEA
 	  option allows the OS to look for such hardware error record, and
 	  take appropriate action.
 
+config ACPI_APEI_SEI
+	bool "APEI Asynchronous SError Interrupt logging/recovering support"
+	depends on ARM64 && ACPI_APEI_GHES
+	default y
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
index d661d452b238..705738aa48b8 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -813,20 +813,21 @@ static struct notifier_block ghes_notifier_hed = {
 	.notifier_call = ghes_notify_hed,
 };
 
-#ifdef CONFIG_ACPI_APEI_SEA
 static LIST_HEAD(ghes_sea);
+static LIST_HEAD(ghes_sei);
 
 /*
  * Return 0 only if one of the SEA error sources successfully reported an error
  * record sent from the firmware.
  */
-int ghes_notify_sea(void)
+
+int ghes_handle_sex(struct list_head *head)
 {
 	struct ghes *ghes;
 	int ret = -ENOENT;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
+	list_for_each_entry_rcu(ghes, head, list) {
 		if (!ghes_proc(ghes))
 			ret = 0;
 	}
@@ -834,33 +835,41 @@ int ghes_notify_sea(void)
 	return ret;
 }
 
-static void ghes_sea_add(struct ghes *ghes)
+int ghes_notify_sex(u8 type)
+{
+	if (type == ACPI_HEST_NOTIFY_SEA)
+		return ghes_handle_sex(&ghes_sea);
+	else if (type == ACPI_HEST_NOTIFY_SEI)
+		return ghes_handle_sex(&ghes_sei);
+
+	return -ENOENT;
+}
+
+/*
+ * This function is only called when the CONFIG_HAVE_ACPI_APEI_SEA or
+ * CONFIG_HAVE_ACPI_APEI_SEA is enabled. when disabled, it will return
+ * error in the ghes_probe
+ */
+static void ghes_sex_add(struct ghes *ghes)
 {
+	u8 notify_type = ghes->generic->notify.type;
+
 	mutex_lock(&ghes_list_mutex);
-	list_add_rcu(&ghes->list, &ghes_sea);
+	if (notify_type == ACPI_HEST_NOTIFY_SEA)
+		list_add_rcu(&ghes->list, &ghes_sea);
+	else if (notify_type == ACPI_HEST_NOTIFY_SEI)
+		list_add_rcu(&ghes->list, &ghes_sei);
+
 	mutex_unlock(&ghes_list_mutex);
 }
 
-static void ghes_sea_remove(struct ghes *ghes)
+static void ghes_sex_remove(struct ghes *ghes)
 {
 	mutex_lock(&ghes_list_mutex);
 	list_del_rcu(&ghes->list);
 	mutex_unlock(&ghes_list_mutex);
 	synchronize_rcu();
 }
-#else /* CONFIG_ACPI_APEI_SEA */
-static inline void ghes_sea_add(struct ghes *ghes)
-{
-	pr_err(GHES_PFX "ID: %d, trying to add SEA notification which is not supported\n",
-	       ghes->generic->header.source_id);
-}
-
-static inline void ghes_sea_remove(struct ghes *ghes)
-{
-	pr_err(GHES_PFX "ID: %d, trying to remove SEA notification which is not supported\n",
-	       ghes->generic->header.source_id);
-}
-#endif /* CONFIG_ACPI_APEI_SEA */
 
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
@@ -1107,6 +1116,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 			goto err;
 		}
 		break;
+	case ACPI_HEST_NOTIFY_SEI:
+		if (!IS_ENABLED(CONFIG_ACPI_APEI_SEI)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via SEI is not supported!\n",
+				generic->header.source_id);
+		goto err;
+	}
+	break;
 	case ACPI_HEST_NOTIFY_NMI:
 		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_NMI)) {
 			pr_warn(GHES_PFX "Generic hardware error source: %d notified via NMI interrupt is not supported!\n",
@@ -1176,7 +1192,8 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		break;
 
 	case ACPI_HEST_NOTIFY_SEA:
-		ghes_sea_add(ghes);
+	case ACPI_HEST_NOTIFY_SEI:
+		ghes_sex_add(ghes);
 		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
@@ -1229,7 +1246,8 @@ static int ghes_remove(struct platform_device *ghes_dev)
 		break;
 
 	case ACPI_HEST_NOTIFY_SEA:
-		ghes_sea_remove(ghes);
+	case ACPI_HEST_NOTIFY_SEI:
+		ghes_sex_remove(ghes);
 		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_remove(ghes);
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 9061c5c743b3..41cbce1bc926 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -118,6 +118,6 @@ static inline void *acpi_hest_get_next(struct acpi_hest_generic_data *gdata)
 	     (void *)section - (void *)(estatus + 1) < estatus->data_length; \
 	     section = acpi_hest_get_next(section))
 
-int ghes_notify_sea(void);
+int ghes_notify_sex(u8 type);
 
 #endif /* GHES_H */
-- 
2.14.0
