From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 02/15] ARM: bugs: prepare processor bug infrastructure
Date: Fri, 25 May 2018 15:00:33 +0100
Message-ID: <E1fMDGj-0006yR-0n@rmk-PC.armlinux.org.uk>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2C1D4A0CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 09:50:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zMB4Fm+k3IPr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 09:50:00 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F03A14A0E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 09:49:59 -0400 (EDT)
In-Reply-To: <20180525135938.GE17671@n2100.armlinux.org.uk>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Prepare the processor bug infrastructure so that it can be expanded to
check for per-processor bugs.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/bugs.h | 4 ++--
 arch/arm/kernel/Makefile    | 1 +
 arch/arm/kernel/bugs.c      | 9 +++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/kernel/bugs.c

diff --git a/arch/arm/include/asm/bugs.h b/arch/arm/include/asm/bugs.h
index a97f1ea708d1..ed122d294f3f 100644
--- a/arch/arm/include/asm/bugs.h
+++ b/arch/arm/include/asm/bugs.h
@@ -10,10 +10,10 @@
 #ifndef __ASM_BUGS_H
 #define __ASM_BUGS_H
 
-#ifdef CONFIG_MMU
 extern void check_writebuffer_bugs(void);
 
-#define check_bugs() check_writebuffer_bugs()
+#ifdef CONFIG_MMU
+extern void check_bugs(void);
 #else
 #define check_bugs() do { } while (0)
 #endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index b59ac4bf82b8..8cad59465af3 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -31,6 +31,7 @@ else
 obj-y		+= entry-armv.o
 endif
 
+obj-$(CONFIG_MMU)		+= bugs.o
 obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_FIQ)		+= fiq.o fiqasm.o
diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
new file mode 100644
index 000000000000..88024028bb70
--- /dev/null
+++ b/arch/arm/kernel/bugs.c
@@ -0,0 +1,9 @@
+// SPDX-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <asm/bugs.h>
+#include <asm/proc-fns.h>
+
+void __init check_bugs(void)
+{
+	check_writebuffer_bugs();
+}
-- 
2.7.4
