From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 04/15] ARM: bugs: add support for per-processor bug checking
Date: Fri, 25 May 2018 15:00:43 +0100
Message-ID: <E1fMDGt-0006yf-8k@rmk-PC.armlinux.org.uk>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180525135938.GE17671@n2100.armlinux.org.uk>
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

Add support for per-processor bug checking - each processor function
descriptor gains a function pointer for this check, which must not be
an __init function.  If non-NULL, this will be called whenever a CPU
enters the kernel via which ever path (boot CPU, secondary CPU startup,
CPU resuming, etc.)

This allows processor specific bug checks to validate that workaround
bits are properly enabled by firmware via all entry paths to the kernel.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/proc-fns.h | 4 ++++
 arch/arm/kernel/bugs.c          | 4 ++++
 arch/arm/mm/proc-macros.S       | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index f2e1af45bd6f..e25f4392e1b2 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -37,6 +37,10 @@ extern struct processor {
 	 */
 	void (*_proc_init)(void);
 	/*
+	 * Check for processor bugs
+	 */
+	void (*check_bugs)(void);
+	/*
 	 * Disable any processor specifics
 	 */
 	void (*_proc_fin)(void);
diff --git a/arch/arm/kernel/bugs.c b/arch/arm/kernel/bugs.c
index 16e7ba2a9cc4..7be511310191 100644
--- a/arch/arm/kernel/bugs.c
+++ b/arch/arm/kernel/bugs.c
@@ -5,6 +5,10 @@
 
 void check_other_bugs(void)
 {
+#ifdef MULTI_CPU
+	if (processor.check_bugs)
+		processor.check_bugs();
+#endif
 }
 
 void __init check_bugs(void)
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index f10e31d0730a..81d0efb055c6 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -273,13 +273,14 @@
 	mcr	p15, 0, ip, c7, c10, 4		@ data write barrier
 	.endm
 
-.macro define_processor_functions name:req, dabort:req, pabort:req, nommu=0, suspend=0
+.macro define_processor_functions name:req, dabort:req, pabort:req, nommu=0, suspend=0, bugs=0
 	.type	\name\()_processor_functions, #object
 	.align 2
 ENTRY(\name\()_processor_functions)
 	.word	\dabort
 	.word	\pabort
 	.word	cpu_\name\()_proc_init
+	.word	\bugs
 	.word	cpu_\name\()_proc_fin
 	.word	cpu_\name\()_reset
 	.word	cpu_\name\()_do_idle
-- 
2.7.4
