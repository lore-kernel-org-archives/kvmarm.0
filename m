From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 10/27] arm64/sve: Low-level CPU setup
Date: Wed,  9 Aug 2017 13:05:16 +0100
Message-ID: <1502280338-23002-11-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 055E349C40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:05:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NcBuS5+7NVYm for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 08:05:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6FF649C3E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:05:25 -0400 (EDT)
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

To enable the kernel to use SVE, all SVE traps from EL1 must be
disabled.  To take maximum advantage of the hardware, the full
available vector length also needs to be enabled for EL1 by
programming ZCR_EL2.LEN.  (The kernel will program ZCR_EL1.LEN as
required, but this cannot override the limit set by ZCR_EL2.)

In advance of full SVE support being implemented for userspace, it
also necessary to ensure that SVE traps from EL0 are enabled.

This patch makes the appropriate changes to the primary and
secondary CPU initialisation code.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/kernel/head.S | 13 ++++++++++++-
 arch/arm64/mm/proc.S     | 14 ++++++++++++--
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 973df7d..0ae1713 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -514,8 +514,19 @@ CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
 	mov	x0, #0x33ff
 	msr	cptr_el2, x0			// Disable copro. traps to EL2
 
+	/* SVE register access */
+	mrs	x1, id_aa64pfr0_el1
+	ubfx	x1, x1, #ID_AA64PFR0_SVE_SHIFT, #4
+	cbz	x1, 7f
+
+	bic	x0, x0, #CPTR_EL2_TZ		// Also disable SVE traps
+	msr	cptr_el2, x0			// Disable copro. traps to EL2
+	isb
+	mov	x1, #ZCR_ELx_LEN_MASK		// SVE: Enable full vector
+	msr_s	SYS_ZCR_EL2, x1			// length for EL1.
+
 	/* Hypervisor stub */
-	adr_l	x0, __hyp_stub_vectors
+7:	adr_l	x0, __hyp_stub_vectors
 	msr	vbar_el2, x0
 
 	/* spsr */
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 877d42f..dd22ef2 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -27,6 +27,7 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/cpufeature.h>
 #include <asm/alternative.h>
+#include <asm/sysreg.h>
 
 #ifdef CONFIG_ARM64_64K_PAGES
 #define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
@@ -186,8 +187,17 @@ ENTRY(__cpu_setup)
 	tlbi	vmalle1				// Invalidate local TLB
 	dsb	nsh
 
-	mov	x0, #3 << 20
-	msr	cpacr_el1, x0			// Enable FP/ASIMD
+	mov	x0, #3 << 20			// FEN
+
+	/* SVE */
+	mrs	x5, id_aa64pfr0_el1
+	ubfx	x5, x5, #ID_AA64PFR0_SVE_SHIFT, #4
+	cbz	x5, 1f
+
+	bic	x0, x0, #CPACR_EL1_ZEN
+	orr	x0, x0, #CPACR_EL1_ZEN_EL1EN	// SVE: trap for EL0, not EL1
+1:	msr	cpacr_el1, x0			// Enable FP/ASIMD
+
 	mov	x0, #1 << 12			// Reset mdscr_el1 and disable
 	msr	mdscr_el1, x0			// access to the DCC from EL0
 	isb					// Unmask debug exceptions now,
-- 
2.1.4
