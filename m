From: Shiju Jose <shiju.jose@huawei.com>
Subject: [RFC PATCH V1 v4.10-rc3 1/1] acpi: apei: handle GSIV notification type
Date: Mon, 27 Feb 2017 18:19:34 +0000
Message-ID: <86258A5CC0A3704780874CF6004BA8A62DCAB57E@lhreml502-mbs>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB2340C30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 13:20:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 366QalmQY3Sb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Feb 2017 13:20:21 -0500 (EST)
Received: from lhrrgout.huawei.com (lhrrgout.huawei.com [194.213.3.17])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA03F40C28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Feb 2017 13:20:20 -0500 (EST)
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "lenb@kernel.org" <lenb@kernel.org>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "nkaje@codeaurora.org" <nkaje@codeaurora.org>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "james.morse@arm.com" <james.morse@arm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "eun.taik.lee@samsung.com" <eun.taik.lee@samsung.com>, sandeepa.
Cc: Shiju Jose <shiju.jose@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add a new GHES error source handling function for
GSIV(Global System Interrupt Vector).
If an error source's notification type is GSIV,
then this handling function can be registered
into the GSIV handler and it can parse
and report error information when they occur.

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Shiju Jose <shiju.jose@huawei.com>
---
 arch/arm64/Kconfig        |  1 +
 drivers/acpi/apei/Kconfig |  9 +++++++
 drivers/acpi/apei/ghes.c  | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1117421..e41fdcf 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -53,6 +53,7 @@ config ARM64
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_ACPI_APEI if (ACPI && EFI)
+	select HAVE_ACPI_APEI_GSIV if (ACPI && EFI)
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_BITREVERSE
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index b0140c8..f45ddb5 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -1,6 +1,15 @@
 config HAVE_ACPI_APEI
 	bool
 
+config HAVE_ACPI_APEI_GSIV
+        bool "APEI GSIV(Global System Interrupt) logging/recovering support"
+        depends on ACPI_APEI && ACPI_APEI_GHES
+        help
+          This option should be enabled if the system supports
+          firmware first handling of GSIV (Global System Interrupt)
+	  for the hardware errors and allows OS to do error
+          recovery/logging.
+
 config HAVE_ACPI_APEI_NMI
 	bool
 
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index e53bef6..e1611d2 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -721,6 +721,58 @@ static struct notifier_block ghes_notifier_sci = {
 	.notifier_call = ghes_notify_sci,
 };
 
+#ifdef CONFIG_HAVE_ACPI_APEI_GSIV
+static LIST_HEAD(ghes_gsiv);
+
+static int ghes_notify_gsiv(struct notifier_block *this,
+				unsigned long event, void *data)
+{
+	struct ghes *ghes;
+	int ret = NOTIFY_DONE;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ghes, &ghes_gsiv, list) {
+	if (!ghes_proc(ghes))
+		ret = NOTIFY_OK;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+static struct notifier_block ghes_notifier_gsiv = {
+	.notifier_call = ghes_notify_gsiv,
+};
+
+static void ghes_gsiv_add(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	if (list_empty(&ghes_gsiv))
+		register_acpi_hed_notifier(&ghes_notifier_gsiv);
+	list_add_rcu(&ghes->list, &ghes_gsiv);
+	mutex_unlock(&ghes_list_mutex);
+}
+
+static void ghes_gsiv_remove(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	if (list_empty(&ghes_gsiv))
+		unregister_acpi_hed_notifier(&ghes_notifier_gsiv);
+	mutex_unlock(&ghes_list_mutex);
+}
+#else /* CONFIG_HAVE_ACPI_APEI_GSIV */
+static inline void ghes_gsiv_add(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to add GSIV notification which is not supported\n",
+	       ghes->generic->header.source_id);
+}
+
+static inline void ghes_gsiv_remove(struct ghes *ghes)
+{
+	pr_err(GHES_PFX "ID: %d, trying to remove GSIV notification which is not supported\n",
+	       ghes->generic->header.source_id);
+}
+#endif /* CONFIG_HAVE_ACPI_APEI_GSIV */
+
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
  * printk is not safe in NMI context.  So in NMI handler, we allocate
@@ -973,6 +1025,14 @@ static int ghes_probe(struct platform_device *ghes_dev)
 			goto err;
 		}
 		break;
+	case ACPI_HEST_NOTIFY_GSIV:
+		if (!IS_ENABLED(CONFIG_HAVE_ACPI_APEI_GSIV)) {
+			pr_warn(GHES_PFX "Generic hardware error source: %d notified via notification GSIV is not supported\n",
+				generic->header.source_id);
+			rc = -ENOTSUPP;
+			goto err;
+		}
+		break;
 	case ACPI_HEST_NOTIFY_LOCAL:
 		pr_warning(GHES_PFX "Generic hardware error source: %d notified via local interrupt is not supported!\n",
 			   generic->header.source_id);
@@ -1034,6 +1094,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_GSIV:
+		ghes_gsiv_add(ghes);
+		break;
 	default:
 		BUG();
 	}
@@ -1076,6 +1139,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_remove(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_GSIV:
+		ghes_gsiv_remove(ghes);
+		break;
 	default:
 		BUG();
 		break;
-- 
2.1.4
