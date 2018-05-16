From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 07/14] ARM: spectre-v2: add Cortex A8 and A15 validation of
 the IBE bit
Date: Wed, 16 May 2018 12:01:13 +0100
Message-ID: <E1fIuBF-0003q0-3d@rmk-PC.armlinux.org.uk>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9746B49F88
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:52:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 82Lokbbhlme9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:51:58 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D06584A0D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:51:26 -0400 (EDT)
In-Reply-To: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When the branch predictor hardening is enabled, firmware must have set
the IBE bit in the auxiliary control register.  If this bit has not
been set, the Spectre workarounds will not be functional.

Add validation that this bit is set, and print a warning at alert level
if this is not the case.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 arch/arm/mm/Makefile       |  2 +-
 arch/arm/mm/proc-v7-bugs.c | 29 +++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S      |  4 ++--
 3 files changed, 32 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mm/proc-v7-bugs.c

diff --git a/arch/arm/mm/Makefile b/arch/arm/mm/Makefile
index 9dbb84923e12..a0c40610210c 100644
--- a/arch/arm/mm/Makefile
+++ b/arch/arm/mm/Makefile
@@ -97,7 +97,7 @@ obj-$(CONFIG_CPU_MOHAWK)	+= proc-mohawk.o
 obj-$(CONFIG_CPU_FEROCEON)	+= proc-feroceon.o
 obj-$(CONFIG_CPU_V6)		+= proc-v6.o
 obj-$(CONFIG_CPU_V6K)		+= proc-v6.o
-obj-$(CONFIG_CPU_V7)		+= proc-v7.o
+obj-$(CONFIG_CPU_V7)		+= proc-v7.o proc-v7-bugs.o
 obj-$(CONFIG_CPU_V7M)		+= proc-v7m.o
 
 AFLAGS_proc-v6.o	:=-Wa,-march=armv6
diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
new file mode 100644
index 000000000000..a32ce13479d9
--- /dev/null
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/smp.h>
+
+static __maybe_unused void cpu_v7_check_auxcr_set(u32 mask, const char *msg)
+{
+	u32 aux_cr;
+
+	asm("mrc p15, 0, %0, c1, c0, 1" : "=r" (aux_cr));
+
+	if ((aux_cr & mask) != mask)
+		pr_err("CPU%u: %s", smp_processor_id(), msg);
+}
+
+static void check_spectre_auxcr(u32 bit)
+{
+	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
+		cpu_v7_check_auxcr_set(bit, "Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable\n");
+}
+
+void cpu_v7_ca8_ibe(void)
+{
+	check_spectre_auxcr(BIT(6));
+}
+
+void cpu_v7_ca15_ibe(void)
+{
+	check_spectre_auxcr(BIT(0));
+}
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 9c3d4c24f720..5cfed34fd1af 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -570,7 +570,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_ca8_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_ca8_do_resume,	cpu_v7_do_resume
 #endif
-	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca8, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_ca8_ibe
 
 	@ Cortex-A9 - needs more registers preserved across suspend/resume
 	@ and bpiall switch_mm for hardening
@@ -603,7 +603,7 @@ ENDPROC(__v7_setup)
 	globl_equ	cpu_ca15_suspend_size,	cpu_v7_suspend_size
 	globl_equ	cpu_ca15_do_suspend,	cpu_v7_do_suspend
 	globl_equ	cpu_ca15_do_resume,	cpu_v7_do_resume
-	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
+	define_processor_functions ca15, dabort=v7_early_abort, pabort=v7_pabort, suspend=1, bugs=cpu_v7_ca15_ibe
 #ifdef CONFIG_CPU_PJ4B
 	define_processor_functions pj4b, dabort=v7_early_abort, pabort=v7_pabort, suspend=1
 #endif
-- 
2.7.4
