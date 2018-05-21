From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 02/14] ARM: bugs: prepare processor bug infrastructure
Date: Mon, 21 May 2018 12:44:30 +0100
Message-ID: <E1fKjEs-00063R-BI@rmk-PC.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180521114238.GN17671@n2100.armlinux.org.uk>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
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
