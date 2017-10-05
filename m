From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 08/20] arm64: entry.S: convert elX_irq
Date: Thu,  5 Oct 2017 20:18:00 +0100
Message-ID: <20171005191812.5678-9-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8479949C3C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DLwIEBpMTbwH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:20:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 723A440E91
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:02 -0400 (EDT)
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Following our 'dai' order, irqs should be processed with debug and
serror exceptions unmasked.

Add a helper to unmask these two, (and fiq for good measure).

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/assembler.h | 4 ++++
 arch/arm64/kernel/entry.S          | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index c2a37e2f733c..7ffb2a629dc9 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -54,6 +54,10 @@
 	msr	daif, \tmp
 	.endm
 
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
