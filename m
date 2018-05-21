From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 04/14] ARM: bugs: add support for per-processor bug checking
Date: Mon, 21 May 2018 12:44:41 +0100
Message-ID: <E1fKjF3-00063g-2e@rmk-PC.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBE74A0F0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 07:34:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nzYA0CDWXkHb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 May 2018 07:34:17 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B1124A0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 07:34:17 -0400 (EDT)
In-Reply-To: <20180521114238.GN17671@n2100.armlinux.org.uk>
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
