From: James Morse <james.morse@arm.com>
Subject: [RESEND PATCH v4 6/9] arm64: entry.S: convert el1_sync
Date: Thu,  2 Nov 2017 12:12:39 +0000
Message-ID: <20171102121242.8925-7-james.morse@arm.com>
References: <20171102121242.8925-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7950249D57
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:13:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GVpsPeuu6nds for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 08:13:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9104F49D6B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:13:07 -0400 (EDT)
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

el1_sync unmasks exceptions on a case-by-case basis, debug exceptions
are unmasked, unless this was a debug exception. IRQs are unmasked
for instruction and data aborts only if the interupted context had
irqs unmasked.

Following our 'dai' order, el1_dbg should run with everything masked.
For the other cases we can inherit whatever we interrupted.

Add a macro inherit_daif to set daif based on the interrupted pstate.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/assembler.h |  6 ++++++
 arch/arm64/kernel/entry.S          | 12 ++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 1b0972046a72..abb5abd61ddb 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -48,6 +48,12 @@
 	msr	daif, \flags
 	.endm
 
+	/* Only on aarch64 pstate, PSR_D_BIT is different for aarch32 */
+	.macro	inherit_daif, pstate:req, tmp:req
+	and	\tmp, \pstate, #(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+	msr	daif, \tmp
+	.endm
+
 /*
  * Enable and disable interrupts.
  */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f7d7bf9d76e7..bd54115972a4 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -510,11 +510,7 @@ el1_da:
 	 * Data abort handling
 	 */
 	mrs	x3, far_el1
-	enable_dbg
-	// re-enable interrupts if they were enabled in the aborted context
-	tbnz	x23, #7, 1f			// PSR_I_BIT
-	enable_irq
-1:
+	inherit_daif	pstate=x23, tmp=x2
 	clear_address_tag x0, x3
 	mov	x2, sp				// struct pt_regs
 	bl	do_mem_abort
@@ -525,7 +521,7 @@ el1_sp_pc:
 	 * Stack or PC alignment exception handling
 	 */
 	mrs	x0, far_el1
-	enable_dbg
+	inherit_daif	pstate=x23, tmp=x2
 	mov	x2, sp
 	bl	do_sp_pc_abort
 	ASM_BUG()
@@ -533,7 +529,7 @@ el1_undef:
 	/*
 	 * Undefined instruction
 	 */
-	enable_dbg
+	inherit_daif	pstate=x23, tmp=x2
 	mov	x0, sp
 	bl	do_undefinstr
 	ASM_BUG()
@@ -550,7 +546,7 @@ el1_dbg:
 	kernel_exit 1
 el1_inv:
 	// TODO: add support for undefined instructions in kernel mode
-	enable_dbg
+	inherit_daif	pstate=x23, tmp=x2
 	mov	x0, sp
 	mov	x2, x1
 	mov	x1, #BAD_SYNC
-- 
2.15.0.rc2
