From: James Morse <james.morse@arm.com>
Subject: [RESEND PATCH v4 3/9] arm64: Move the async/fiq helpers to explicitly
 set process context flags
Date: Thu,  2 Nov 2017 12:12:36 +0000
Message-ID: <20171102121242.8925-4-james.morse@arm.com>
References: <20171102121242.8925-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79D2C49D68
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:13:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 09e1pNl5OrOG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 08:13:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30BA349D54
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:13:01 -0400 (EDT)
In-Reply-To: <20171102121242.8925-1-james.morse@arm.com>
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
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Remove the local_{async,fiq}_{en,dis}able macros as they don't respect
our newly defined order and are only used to set the flags for process
context when we bring CPUs online.

Add a helper to do this. The IRQ flag varies as we want it masked on
the boot CPU until we are ready to handle interrupts.
The boot CPU unmasks SError during early boot once it can print an error
message. If we can print an error message about SError, we can do the
same for FIQ. Debug exceptions are already enabled by __cpu_setup(),
which has also configured MDSCR_EL1 to disable MDE and KDE.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

==
Changes since v3:
 * swapped verb/daif word-order.
---
 arch/arm64/include/asm/daifflags.h | 3 +++
 arch/arm64/include/asm/irqflags.h  | 6 ------
 arch/arm64/kernel/setup.c          | 8 +++++---
 arch/arm64/kernel/smp.c            | 3 +--
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 55e2598a8c4c..22e4c83de5a5 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -18,6 +18,9 @@
 
 #include <linux/irqflags.h>
 
+#define DAIF_PROCCTX		0
+#define DAIF_PROCCTX_NOIRQ	PSR_I_BIT
+
 /* mask/save/unmask/restore all exceptions, including interrupts. */
 static inline void local_daif_mask(void)
 {
diff --git a/arch/arm64/include/asm/irqflags.h b/arch/arm64/include/asm/irqflags.h
index 9ecdca7011f0..24692edf1a69 100644
--- a/arch/arm64/include/asm/irqflags.h
+++ b/arch/arm64/include/asm/irqflags.h
@@ -66,12 +66,6 @@ static inline void arch_local_irq_disable(void)
 		: "memory");
 }
 
-#define local_fiq_enable()	asm("msr	daifclr, #1" : : : "memory")
-#define local_fiq_disable()	asm("msr	daifset, #1" : : : "memory")
-
-#define local_async_enable()	asm("msr	daifclr, #4" : : : "memory")
-#define local_async_disable()	asm("msr	daifset, #4" : : : "memory")
-
 /*
  * Save the current interrupt enable state.
  */
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index d4b740538ad5..ad285f024934 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -48,6 +48,7 @@
 #include <asm/fixmap.h>
 #include <asm/cpu.h>
 #include <asm/cputype.h>
+#include <asm/daifflags.h>
 #include <asm/elf.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_ops.h>
@@ -262,10 +263,11 @@ void __init setup_arch(char **cmdline_p)
 	parse_early_param();
 
 	/*
-	 *  Unmask asynchronous aborts after bringing up possible earlycon.
-	 * (Report possible System Errors once we can report this occurred)
+	 * Unmask asynchronous aborts and fiq after bringing up possible
+	 * earlycon. (Report possible System Errors once we can report this
+	 * occurred).
 	 */
-	local_async_enable();
+	local_daif_restore(DAIF_PROCCTX_NOIRQ);
 
 	/*
 	 * TTBR0 is only used for the identity mapping at this stage. Make it
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 5a407eba01f7..d92e03faa51a 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -272,8 +272,7 @@ asmlinkage void secondary_start_kernel(void)
 	set_cpu_online(cpu, true);
 	complete(&cpu_running);
 
-	local_irq_enable();
-	local_async_enable();
+	local_daif_restore(DAIF_PROCCTX);
 
 	/*
 	 * OK, it's off to the idle thread for us
-- 
2.15.0.rc2
