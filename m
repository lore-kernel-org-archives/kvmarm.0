From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 04/16] arm64: entry.S: mask all exceptions during
 kernel_exit
Date: Fri, 28 Jul 2017 15:10:07 +0100
Message-ID: <20170728141019.9084-5-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D74949C2E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eY6QYosM+cS3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:10:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0719940D16
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:10:39 -0400 (EDT)
In-Reply-To: <20170728141019.9084-1-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add a disable_daif call to kernel_exit to mask all exceptions
before restoring registers that are overwritten by an exception.

This should be done before we restore sp_el0, as any exception taken
from EL1 will assume this register is set correctly.

After this patch it is no longer necessary to mask interrupts before
kernel_exit.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index b738880350f9..491182f0abb5 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -207,6 +207,8 @@ alternative_else_nop_endif
 2:
 #endif
 
+	disable_daif
+
 	.if	\el == 0
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	msr	sp_el0, x23
@@ -438,8 +440,6 @@ el1_da:
 	mov	x2, sp				// struct pt_regs
 	bl	do_mem_abort
 
-	// disable interrupts before pulling preserved data off the stack
-	disable_irq
 	kernel_exit 1
 el1_sp_pc:
 	/*
-- 
2.13.2
