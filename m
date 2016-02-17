From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4.1] arm64: perf: Count EL2 events if the kernel is running in HYP
Date: Wed, 17 Feb 2016 17:57:39 +0000
Message-ID: <1455731859-26690-1-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-22-git-send-email-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455216004-19499-22-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When the kernel is running in HYP (with VHE), it is necessary to
include EL2 events if the user requests counting kernel or
hypervisor events.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/perf_event.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index f7ab14c..1b52269 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -20,6 +20,7 @@
  */
 
 #include <asm/irq_regs.h>
+#include <asm/virt.h>
 
 #include <linux/of.h>
 #include <linux/perf/arm_pmu.h>
@@ -691,9 +692,12 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 
 	if (attr->exclude_idle)
 		return -EPERM;
+	if (is_kernel_in_hyp_mode() &&
+	    attr->exclude_kernel != attr->exclude_hv)
+		return -EINVAL;
 	if (attr->exclude_user)
 		config_base |= ARMV8_EXCLUDE_EL0;
-	if (attr->exclude_kernel)
+	if (!is_kernel_in_hyp_mode() && attr->exclude_kernel)
 		config_base |= ARMV8_EXCLUDE_EL1;
 	if (!attr->exclude_hv)
 		config_base |= ARMV8_INCLUDE_EL2;
-- 
2.1.4
