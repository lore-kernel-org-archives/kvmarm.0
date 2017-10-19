From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 08/21] arm64: entry.S: convert elX_irq
Date: Thu, 19 Oct 2017 15:57:54 +0100
Message-ID: <20171019145807.23251-9-james.morse@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAF8E49D21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FCT5iczVd1Ow for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 10:59:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C56F749D4B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:10 -0400 (EDT)
In-Reply-To: <20171019145807.23251-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Following our 'dai' order, irqs should be processed with debug and
serror exceptions unmasked.

Add a helper to unmask these two, (and fiq for good measure).

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

---
Changes since v3:
* Added comment against enable_da_f

 arch/arm64/include/asm/assembler.h | 5 +++++
 arch/arm64/kernel/entry.S          | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index c2a37e2f733c..e4ac505b7b3d 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -54,6 +54,11 @@
 	msr	daif, \tmp
 	.endm
 
+	/* IRQ is the lowest priority flag, unconditionally unmask the rest. */
+	.macro enable_da_f
+	msr	daifclr, #(8 | 4 | 1)
+	.endm
+
 /*
  * Enable and disable interrupts.
  */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index f7dfe5d2b1fb..df085ec003b0 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -557,7 +557,7 @@ ENDPROC(el1_sync)
 	.align	6
 el1_irq:
 	kernel_entry 1
-	enable_dbg
+	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
@@ -766,7 +766,7 @@ ENDPROC(el0_sync)
 el0_irq:
 	kernel_entry 0
 el0_irq_naked:
-	enable_dbg
+	enable_da_f
 #ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
 #endif
-- 
2.13.3
