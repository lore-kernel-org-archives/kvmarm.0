From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 05/20] arm64: entry.S: Remove disable_dbg
Date: Thu,  5 Oct 2017 20:17:57 +0100
Message-ID: <20171005191812.5678-6-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BAE849D19
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:19:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e3cB3LYoYbe0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:19:40 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E93749D22
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:19:40 -0400 (EDT)
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

enable_step_tsk is the only user of disable_dbg, which doesn't respect
our 'dai' order for exception masking. enable_step_tsk may enable
single-step, so previously needed to mask debug exceptions to prevent us
from single-stepping kernel_exit. enable_step_tsk is called at the end
of the ret_to_user loop, which has already masked all exceptions so this
is no longer needed.

Remove disable_dbg, add a comment that enable_step_tsk's caller should
have masked debug.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/assembler.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 114e741ca873..1b0972046a72 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -68,13 +68,6 @@
 	msr	daif, \flags
 	.endm
 
-/*
- * Enable and disable debug exceptions.
- */
-	.macro	disable_dbg
-	msr	daifset, #8
-	.endm
-
 	.macro	enable_dbg
 	msr	daifclr, #8
 	.endm
@@ -88,9 +81,9 @@
 9990:
 	.endm
 
+	/* call with daif masked */
 	.macro	enable_step_tsk, flgs, tmp
 	tbz	\flgs, #TIF_SINGLESTEP, 9990f
-	disable_dbg
 	mrs	\tmp, mdscr_el1
 	orr	\tmp, \tmp, #1
 	msr	mdscr_el1, \tmp
-- 
2.13.3
