From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4.1] arm64: hw_breakpoint: Allow EL2 breakpoints if running
 in HYP
Date: Wed, 17 Feb 2016 17:58:43 +0000
Message-ID: <1455731923-26768-1-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-23-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C26549936
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 12:52:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oSNGCCyLG3zV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Feb 2016 12:52:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F6644992D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Feb 2016 12:52:32 -0500 (EST)
In-Reply-To: <1455216004-19499-23-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With VHE, we place kernel {watch,break}-points at EL2 to get things
like kgdb and "perf -e mem:..." working.

This requires a bit of repainting in the low-level encore/decode,
but is otherwise pretty simple.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/hw_breakpoint.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index 9732908..115ea2a 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -18,6 +18,7 @@
 
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/virt.h>
 
 #ifdef __KERNEL__
 
@@ -35,10 +36,21 @@ struct arch_hw_breakpoint {
 	struct arch_hw_breakpoint_ctrl ctrl;
 };
 
+/* Privilege Levels */
+#define AARCH64_BREAKPOINT_EL1	1
+#define AARCH64_BREAKPOINT_EL0	2
+
+#define DBG_HMC_HYP		(1 << 13)
+
 static inline u32 encode_ctrl_reg(struct arch_hw_breakpoint_ctrl ctrl)
 {
-	return (ctrl.len << 5) | (ctrl.type << 3) | (ctrl.privilege << 1) |
+	u32 val = (ctrl.len << 5) | (ctrl.type << 3) | (ctrl.privilege << 1) |
 		ctrl.enabled;
+
+	if (is_kernel_in_hyp_mode() && ctrl.privilege == AARCH64_BREAKPOINT_EL1)
+		val |= DBG_HMC_HYP;
+
+	return val;
 }
 
 static inline void decode_ctrl_reg(u32 reg,
@@ -61,10 +73,6 @@ static inline void decode_ctrl_reg(u32 reg,
 #define ARM_BREAKPOINT_STORE	2
 #define AARCH64_ESR_ACCESS_MASK	(1 << 6)
 
-/* Privilege Levels */
-#define AARCH64_BREAKPOINT_EL1	1
-#define AARCH64_BREAKPOINT_EL0	2
-
 /* Lengths */
 #define ARM_BREAKPOINT_LEN_1	0x1
 #define ARM_BREAKPOINT_LEN_2	0x3
-- 
2.1.4
