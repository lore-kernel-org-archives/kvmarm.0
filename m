From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 08/11] firmware: arm_sdei: Add ACPI GHES registration helper
Date: Thu, 22 Mar 2018 18:14:42 +0000
Message-ID: <20180322181445.23298-9-james.morse@arm.com>
References: <20180322181445.23298-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE26B4A083
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Mar 2018 14:11:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HbYEmjP8UdGF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Mar 2018 14:11:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58CFF4A093
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Mar 2018 14:10:13 -0400 (EDT)
In-Reply-To: <20180322181445.23298-1-james.morse@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Punit Agrawal <punit.agrawal@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

APEI's Generic Hardware Error Source structures do not describe
whether the SDEI event is shared or private, as this information is
discoverable via the API.

GHES needs to know whether an event is normal or critical to avoid
sharing locks or fixmap entries.

Add a helper to ask firmware for this information so it can initialise
the struct ghes and register then enable the event.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
---
Changes since v1:
 * ghes->fixmap_idx variable rename
 * Typos

 arch/arm64/include/asm/fixmap.h |  4 +++
 drivers/firmware/arm_sdei.c     | 75 +++++++++++++++++++++++++++++++++++++++++
 include/linux/arm_sdei.h        |  5 +++
 3 files changed, 84 insertions(+)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index c3974517c2cb..e2b423a5feaf 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -58,6 +58,10 @@ enum fixed_addresses {
 #ifdef CONFIG_ACPI_APEI_SEA
 	FIX_APEI_GHES_SEA,
 #endif
+#ifdef CONFIG_ARM_SDE_INTERFACE
+	FIX_APEI_GHES_SDEI_NORMAL,
+	FIX_APEI_GHES_SDEI_CRITICAL,
+#endif
 #endif /* CONFIG_ACPI_APEI_GHES */
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
diff --git a/drivers/firmware/arm_sdei.c b/drivers/firmware/arm_sdei.c
index 1ea71640fdc2..8e37c34ef733 100644
--- a/drivers/firmware/arm_sdei.c
+++ b/drivers/firmware/arm_sdei.c
@@ -2,6 +2,7 @@
 // Copyright (C) 2017 Arm Ltd.
 #define pr_fmt(fmt) "sdei: " fmt
 
+#include <acpi/ghes.h>
 #include <linux/acpi.h>
 #include <linux/arm_sdei.h>
 #include <linux/arm-smccc.h>
@@ -887,6 +888,80 @@ static void sdei_smccc_hvc(unsigned long function_id,
 	arm_smccc_hvc(function_id, arg0, arg1, arg2, arg3, arg4, 0, 0, res);
 }
 
+#ifdef CONFIG_ACPI
+/* These stop private notifications using the fixmap entries simultaneously */
+static DEFINE_RAW_SPINLOCK(sdei_ghes_fixmap_lock_normal);
+static DEFINE_RAW_SPINLOCK(sdei_ghes_fixmap_lock_critical);
+
+int sdei_register_ghes(struct ghes *ghes, sdei_event_callback *cb)
+{
+	int err;
+	u32 event_num;
+	u64 result;
+
+	if (acpi_disabled)
+		return -EOPNOTSUPP;
+
+	event_num = ghes->generic->notify.vector;
+	if (event_num == 0) {
+		/*
+		 * Event 0 is reserved by the specification for
+		 * SDEI_EVENT_SIGNAL.
+		 */
+		return -EINVAL;
+	}
+
+	err = sdei_api_event_get_info(event_num, SDEI_EVENT_INFO_EV_PRIORITY,
+				      &result);
+	if (err)
+		return err;
+
+	if (result == SDEI_EVENT_PRIORITY_CRITICAL) {
+		ghes->nmi_fixmap_lock = &sdei_ghes_fixmap_lock_critical;
+		ghes->nmi_fixmap_idx = FIX_APEI_GHES_SDEI_CRITICAL;
+	} else {
+		ghes->nmi_fixmap_lock = &sdei_ghes_fixmap_lock_normal;
+		ghes->nmi_fixmap_idx = FIX_APEI_GHES_SDEI_NORMAL;
+	}
+
+	err = sdei_event_register(event_num, cb, ghes);
+	if (!err)
+		err = sdei_event_enable(event_num);
+
+	return err;
+}
+
+int sdei_unregister_ghes(struct ghes *ghes)
+{
+	int i;
+	int err;
+	u32 event_num = ghes->generic->notify.vector;
+
+	might_sleep();
+
+	if (acpi_disabled)
+		return -EOPNOTSUPP;
+
+	/*
+	 * The event may be running on another CPU. Disable it
+	 * to stop new events, then try to unregister a few times.
+	 */
+	err = sdei_event_disable(event_num);
+	if (err)
+		return err;
+
+	for (i = 0; i < 3; i++) {
+		err = sdei_event_unregister(event_num);
+		if (err != -EINPROGRESS)
+			break;
+
+		schedule();
+	}
+
+	return err;
+}
+#endif /* CONFIG_ACPI */
+
 static int sdei_get_conduit(struct platform_device *pdev)
 {
 	const char *method;
diff --git a/include/linux/arm_sdei.h b/include/linux/arm_sdei.h
index 942afbd544b7..5fdf799be026 100644
--- a/include/linux/arm_sdei.h
+++ b/include/linux/arm_sdei.h
@@ -11,6 +11,7 @@ enum sdei_conduit_types {
 	CONDUIT_HVC,
 };
 
+#include <acpi/ghes.h>
 #include <asm/sdei.h>
 
 /* Arch code should override this to set the entry point from firmware... */
@@ -39,6 +40,10 @@ int sdei_event_unregister(u32 event_num);
 int sdei_event_enable(u32 event_num);
 int sdei_event_disable(u32 event_num);
 
+/* GHES register/unregister helpers */
+int sdei_register_ghes(struct ghes *ghes, sdei_event_callback *cb);
+int sdei_unregister_ghes(struct ghes *ghes);
+
 #ifdef CONFIG_ARM_SDE_INTERFACE
 /* For use by arch code when CPU hotplug notifiers are not appropriate. */
 int sdei_mask_local_cpu(void);
-- 
2.16.2
