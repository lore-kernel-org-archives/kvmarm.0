From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 20/23] arm64: perf: Count EL2 events if the kernel is
 running in HYP
Date: Wed,  3 Feb 2016 18:00:13 +0000
Message-ID: <1454522416-6874-21-git-send-email-marc.zyngier@arm.com>
References: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2DB641AF6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2016 12:55:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ct0uxbNesRYn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2016 12:55:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3334E497BE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2016 12:55:28 -0500 (EST)
In-Reply-To: <1454522416-6874-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When the kernel is running in HYP (with VHE), it is necessary to
include EL2 events if the user requests counting kernel or
hypervisor events.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/perf_event.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index f7ab14c..6013a38 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -20,6 +20,7 @@
  */
 
 #include <asm/irq_regs.h>
+#include <asm/virt.h>
 
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
@@ -693,10 +694,15 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 		return -EPERM;
 	if (attr->exclude_user)
 		config_base |= ARMV8_EXCLUDE_EL0;
-	if (attr->exclude_kernel)
-		config_base |= ARMV8_EXCLUDE_EL1;
-	if (!attr->exclude_hv)
-		config_base |= ARMV8_INCLUDE_EL2;
+	if (is_kernel_in_hyp_mode()) {
+		if (!attr->exclude_kernel || !attr->exclude_hv)
+			config_base |= ARMV8_INCLUDE_EL2;
+	} else {
+		if (attr->exclude_kernel)
+			config_base |= ARMV8_EXCLUDE_EL1;
+		if (!attr->exclude_hv)
+			config_base |= ARMV8_INCLUDE_EL2;
+	}
 
 	/*
 	 * Install the filter into config_base as this is used to
-- 
2.1.4
