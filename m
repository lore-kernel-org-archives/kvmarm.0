From: James Morse <james.morse@arm.com>
Subject: [RESEND PATCH v4 8/9] arm64: entry.S: convert elX_irq
Date: Thu,  2 Nov 2017 12:12:41 +0000
Message-ID: <20171102121242.8925-9-james.morse@arm.com>
References: <20171102121242.8925-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82EC749D4E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:13:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EmFwqLryjsi8 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 08:13:14 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E137449D53
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:13:11 -0400 (EDT)
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

Following our 'dai' order, irqs should be processed with debug and
serror exceptions unmasked.

Add a helper to unmask these two, (and fiq for good measure).

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

==
Changes since v3:
* Added comment against enable_da_f
---
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
2.15.0.rc2
