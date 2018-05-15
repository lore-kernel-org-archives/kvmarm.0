From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v12 3/4] ACPI / APEI: Add SEI notification type support for ARMv8
Date: Wed, 16 May 2018 04:58:06 +0800
Message-ID: <1526417887-25843-4-git-send-email-gengdongjiu@huawei.com>
References: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526417887-25843-1-git-send-email-gengdongjiu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: gengdongjiu@huawei.com, huangshaoyu@huawei.com, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

ACPI 6.x adds support for NOTIFY_SEI as a GHES notification
mechanism, so add new GHES notification handling functions.
Expose API ghes_notify_sei() to arch code, arch code will call
this API when it gets this NOTIFY_SEI.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>

Note:
Firmware will follow the SError mask rule, if the SError is masked,
the firmware will not deliver NOTIFY_SEI notification.
---
 drivers/acpi/apei/Kconfig | 15 ++++++++++++++
 drivers/acpi/apei/ghes.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/ghes.h       |  1 +
 3 files changed, 69 insertions(+)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 52ae543..ff4afc3 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -55,6 +55,21 @@ config ACPI_APEI_SEA
 	  option allows the OS to look for such hardware error record, and
 	  take appropriate action.
 
+config ACPI_APEI_SEI
+	bool "APEI SError(System Error) Interrupt logging/recovering support"
+	depends on ARM64 && ACPI_APEI_GHES
+	default y
+	help
+	  This option should be enabled if the system supports
+	  firmware first handling of SEI (SError interrupt).
+
+	  SEI happens with asynchronous external abort for errors on device
+	  memory reads on ARMv8 systems. If a system supports firmware first
+	  handling of SEI, the platform analyzes and handles hardware error
+	  notifications from SEI, and it may then form a hardware error record for
+	  the OS to parse and handle. This option allows the OS to look for
+	  such hardware error record, and take appropriate action.
+
 config ACPI_APEI_MEMORY_FAILURE
 	bool "APEI memory error recovering support"
 	depends on ACPI_APEI && MEMORY_FAILURE
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1efefe9..33f77ae 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -827,6 +827,46 @@ static inline void ghes_sea_add(struct ghes *ghes) { }
 static inline void ghes_sea_remove(struct ghes *ghes) { }
 #endif /* CONFIG_ACPI_APEI_SEA */
 
+#ifdef CONFIG_ACPI_APEI_SEI
+static LIST_HEAD(ghes_sei);
+
+/*
+ * Return 0 only if one of the SEI error sources successfully reported an error
+ * record sent from the firmware.
+ */
+int ghes_notify_sei(void)
+{
+	struct ghes *ghes;
+	int ret = -ENOENT;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ghes, &ghes_sei, list) {
+		if (!ghes_proc(ghes))
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
+static inline void ghes_sei_add(struct ghes *ghes) { }
+static inline void ghes_sei_remove(struct ghes *ghes) { }
+#endif /* CONFIG_ACPI_APEI_SEI */
+
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
  * printk is not safe in NMI context.  So in NMI handler, we allocate
@@ -1055,6 +1095,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
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
@@ -1126,6 +1173,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	case ACPI_HEST_NOTIFY_SEA:
 		ghes_sea_add(ghes);
 		break;
+	case ACPI_HEST_NOTIFY_SEI:
+		ghes_sei_add(ghes);
+		break;
 	case ACPI_HEST_NOTIFY_NMI:
 		ghes_nmi_add(ghes);
 		break;
@@ -1179,6 +1229,9 @@ static int ghes_remove(struct platform_device *ghes_dev)
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
index 8feb0c8..9ba59e2 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -120,5 +120,6 @@ static inline void *acpi_hest_get_next(struct acpi_hest_generic_data *gdata)
 	     section = acpi_hest_get_next(section))
 
 int ghes_notify_sea(void);
+int ghes_notify_sei(void);
 
 #endif /* GHES_H */
-- 
1.9.1
