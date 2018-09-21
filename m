From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 05/18] ACPI / APEI: Make estatus queue a Kconfig symbol
Date: Fri, 21 Sep 2018 23:16:52 +0100
Message-ID: <20180921221705.6478-6-james.morse@arm.com>
References: <20180921221705.6478-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6934A263
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 18:18:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fdjZuCcCgRC1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Sep 2018 18:18:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AC7E4A26C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Sep 2018 18:18:05 -0400 (EDT)
In-Reply-To: <20180921221705.6478-1-james.morse@arm.com>
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
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Now that there are two users of the estatus queue, and likely to be more,
make it a Kconfig symbol selected by the appropriate notification. We
can move the ARCH_HAVE_NMI_SAFE_CMPXCHG checks in here too.

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/Kconfig |  6 ++++++
 drivers/acpi/apei/ghes.c  | 12 +++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 52ae5438edeb..2b191e09b647 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -4,6 +4,7 @@ config HAVE_ACPI_APEI
 
 config HAVE_ACPI_APEI_NMI
 	bool
+	select ACPI_APEI_GHES_ESTATUS_QUEUE
 
 config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
@@ -33,6 +34,10 @@ config ACPI_APEI_GHES
 	  by firmware to produce more valuable hardware error
 	  information for Linux.
 
+config ACPI_APEI_GHES_ESTATUS_QUEUE
+	bool
+	depends on ACPI_APEI_GHES && ARCH_HAVE_NMI_SAFE_CMPXCHG
+
 config ACPI_APEI_PCIEAER
 	bool "APEI PCIe AER logging/recovering support"
 	depends on ACPI_APEI && PCIEAER
@@ -43,6 +48,7 @@ config ACPI_APEI_PCIEAER
 config ACPI_APEI_SEA
 	bool "APEI Synchronous External Abort logging/recovering support"
 	depends on ARM64 && ACPI_APEI_GHES
+	select ACPI_APEI_GHES_ESTATUS_QUEUE
 	default y
 	help
 	  This option should be enabled if the system supports
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 150fb184c7cb..2880547e13b8 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -58,10 +58,6 @@
 
 #define GHES_PFX	"GHES: "
 
-#if defined(CONFIG_HAVE_ACPI_APEI_NMI) || defined(CONFIG_ACPI_APEI_SEA)
-#define WANT_NMI_ESTATUS_QUEUE	1
-#endif
-
 #define GHES_ESTATUS_MAX_SIZE		65536
 #define GHES_ESOURCE_PREALLOC_MAX_SIZE	65536
 
@@ -685,7 +681,7 @@ static void ghes_estatus_cache_add(
 	rcu_read_unlock();
 }
 
-#ifdef WANT_NMI_ESTATUS_QUEUE
+#ifdef CONFIG_ACPI_APEI_GHES_ESTATUS_QUEUE
 /*
  * Handlers for CPER records may not be NMI safe. For example,
  * memory_failure_queue() takes spinlocks and calls schedule_work_on().
@@ -727,7 +723,6 @@ static void ghes_print_queued_estatus(void)
 /* Save estatus for further processing in IRQ context */
 static void __process_error(struct ghes *ghes)
 {
-#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
 	u32 len, node_len;
 	struct ghes_estatus_node *estatus_node;
 	struct acpi_hest_generic_status *estatus;
@@ -747,7 +742,6 @@ static void __process_error(struct ghes *ghes)
 	estatus = GHES_ESTATUS_FROM_NODE(estatus_node);
 	memcpy(estatus, ghes->estatus, len);
 	llist_add(&estatus_node->llnode, &ghes_estatus_llist);
-#endif
 }
 
 static int _in_nmi_notify_one(struct ghes *ghes)
@@ -786,7 +780,7 @@ static int ghes_estatus_queue_notified(struct list_head *rcu_list)
 	}
 	rcu_read_unlock();
 
-	if (IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) && !ret)
+	if (!ret)
 		irq_work_queue(&ghes_proc_irq_work);
 
 	return ret;
@@ -865,7 +859,7 @@ static void ghes_nmi_init_cxt(void)
 
 #else
 static inline void ghes_nmi_init_cxt(void) { }
-#endif /* WANT_NMI_ESTATUS_QUEUE */
+#endif /* CONFIG_ACPI_APEI_GHES_ESTATUS_QUEUE */
 
 static int ghes_ack_error(struct acpi_hest_generic_v2 *gv2)
 {
-- 
2.19.0
