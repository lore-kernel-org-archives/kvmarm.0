From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 10/20] arm64: entry.S: move SError handling into a C
 function for future expansion
Date: Thu,  5 Oct 2017 20:18:02 +0100
Message-ID: <20171005191812.5678-11-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3D140BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gLPNUvnDWWF7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:20:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8686949D18
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:07 -0400 (EDT)
In-Reply-To: <20171005191812.5678-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Wang Xiongfeng <wangxiongfengi2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Xie XiuQi <xiexiuqi@huawei.com>

Today SError is taken using the inv_entry macro that ends up in
bad_mode.

SError can be used by the RAS Extensions to notify either the OS or
firmware of CPU problems, some of which may have been corrected.

To allow this handling to be added, add a do_serror() C function
that just panic()s. Add the entry.S boiler plate to save/restore the
CPU registers and unmask debug exceptions. Future patches may change
do_serror() to return if the SError Interrupt was notification of a
corrected error.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Wang Xiongfeng <wangxiongfengi2@huawei.com>
[Split out of a bigger patch, added compat path, renamed, enabled debug
 exceptions]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig        |  2 +-
 arch/arm64/kernel/entry.S | 36 +++++++++++++++++++++++++++++-------
 arch/arm64/kernel/traps.c | 13 +++++++++++++
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0df64a6a56d4..70dfe4e9ccc5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -98,7 +98,7 @@ config ARM64
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP if NUMA
-	select HAVE_NMI if ACPI_APEI_SEA
+	select HAVE_NMI
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index df085ec003b0..e147c1d00b41 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -375,18 +375,18 @@ ENTRY(vectors)
 	kernel_ventry	el1_sync			// Synchronous EL1h
 	kernel_ventry	el1_irq				// IRQ EL1h
 	kernel_ventry	el1_fiq_invalid			// FIQ EL1h
-	kernel_ventry	el1_error_invalid		// Error EL1h
+	kernel_ventry	el1_error			// Error EL1h
 
 	kernel_ventry	el0_sync			// Synchronous 64-bit EL0
 	kernel_ventry	el0_irq				// IRQ 64-bit EL0
 	kernel_ventry	el0_fiq_invalid			// FIQ 64-bit EL0
-	kernel_ventry	el0_error_invalid		// Error 64-bit EL0
+	kernel_ventry	el0_error			// Error 64-bit EL0
 
 #ifdef CONFIG_COMPAT
 	kernel_ventry	el0_sync_compat			// Synchronous 32-bit EL0
 	kernel_ventry	el0_irq_compat			// IRQ 32-bit EL0
 	kernel_ventry	el0_fiq_invalid_compat		// FIQ 32-bit EL0
-	kernel_ventry	el0_error_invalid_compat	// Error 32-bit EL0
+	kernel_ventry	el0_error_compat		// Error 32-bit EL0
 #else
 	kernel_ventry	el0_sync_invalid		// Synchronous 32-bit EL0
 	kernel_ventry	el0_irq_invalid			// IRQ 32-bit EL0
@@ -455,10 +455,6 @@ ENDPROC(el0_error_invalid)
 el0_fiq_invalid_compat:
 	inv_entry 0, BAD_FIQ, 32
 ENDPROC(el0_fiq_invalid_compat)
-
-el0_error_invalid_compat:
-	inv_entry 0, BAD_ERROR, 32
-ENDPROC(el0_error_invalid_compat)
 #endif
 
 el1_sync_invalid:
@@ -663,6 +659,10 @@ el0_svc_compat:
 el0_irq_compat:
 	kernel_entry 0, 32
 	b	el0_irq_naked
+
+el0_error_compat:
+	kernel_entry 0, 32
+	b	el0_error_naked
 #endif
 
 el0_da:
@@ -780,6 +780,28 @@ el0_irq_naked:
 	b	ret_to_user
 ENDPROC(el0_irq)
 
+el1_error:
+	kernel_entry 1
+	mrs	x1, esr_el1
+	enable_dbg
+	mov	x0, sp
+	bl	do_serror
+	kernel_exit 1
+ENDPROC(el1_error)
+
+el0_error:
+	kernel_entry 0
+el0_error_naked:
+	mrs	x1, esr_el1
+	enable_dbg
+	mov	x0, sp
+	bl	do_serror
+	enable_daif
+	ct_user_exit
+	b	ret_to_user
+ENDPROC(el0_error)
+
+
 /*
  * This is the fast syscall return path.  We do as little as possible here,
  * and this includes saving x0 back into the kernel stack.
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index d046495f67eb..210647d33bea 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -709,6 +709,19 @@ asmlinkage void handle_bad_stack(struct pt_regs *regs)
 }
 #endif
 
+asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
+{
+	nmi_enter();
+
+	console_verbose();
+
+	pr_crit("SError Interrupt on CPU%d, code 0x%08x -- %s\n",
+		smp_processor_id(), esr, esr_get_class_string(esr));
+	__show_regs(regs);
+
+	panic("Asynchronous SError Interrupt");
+}
+
 void __pte_error(const char *file, int line, unsigned long val)
 {
 	pr_err("%s:%d: bad pte %016lx.\n", file, line, val);
-- 
2.13.3
