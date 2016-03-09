From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 49/95] arm64: perf: Count EL2 events if the kernel is running
 in HYP
Date: Wed,  9 Mar 2016 07:30:43 +0000
Message-ID: <1457508689-19672-50-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B00F949B56
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ml6ZgBP7O5nK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:34:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9C434998D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:34:03 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When the kernel is running in HYP (with VHE), it is necessary to
include EL2 events if the user requests counting kernel or
hypervisor events.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
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
