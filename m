From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 02/13] arm64: sysreg: Move to use definitions for all the
 SCTLR bits
Date: Mon, 15 Jan 2018 19:38:55 +0000
Message-ID: <20180115193906.30053-3-james.morse@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70E6A49E19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id itSg7BaT21-8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 14:36:39 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11B2249E2C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:39 -0500 (EST)
In-Reply-To: <20180115193906.30053-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

__cpu_setup() configures SCTLR_EL1 using some hard coded hex masks,
and el2_setup() duplicates some this when setting RES1 bits.

Lets make this the same as KVM's hyp_init, which uses named bits.

First, we add definitions for all the SCTLR_EL{1,2} bits, the RES{1,0}
bits, and those we want to set or clear.

Add a build_bug checks to ensures all bits are either set or clear.
This means we don't need to preserve endian-ness configuration
generated elsewhere.

Finally, move the head.S and proc.S users of these hard-coded masks
over to the macro versions.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 65 +++++++++++++++++++++++++++++++++++++++--
 arch/arm64/kernel/head.S        | 13 ++-------
 arch/arm64/mm/proc.S            | 24 +--------------
 3 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 54e99af043c6..1a8108f84932 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -20,6 +20,7 @@
 #ifndef __ASM_SYSREG_H
 #define __ASM_SYSREG_H
 
+#include <asm/compiler.h>
 #include <linux/stringify.h>
 
 /*
@@ -398,25 +399,81 @@
 
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
+#define SCTLR_ELx_WXN	(1 << 19)
 #define SCTLR_ELx_I	(1 << 12)
 #define SCTLR_ELx_SA	(1 << 3)
 #define SCTLR_ELx_C	(1 << 2)
 #define SCTLR_ELx_A	(1 << 1)
 #define SCTLR_ELx_M	1
 
+#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
+			 SCTLR_ELx_SA | SCTLR_ELx_I)
+
+/* SCTLR_EL2 specific flags. */
 #define SCTLR_EL2_RES1	((1 << 4)  | (1 << 5)  | (1 << 11) | (1 << 16) | \
 			 (1 << 18) | (1 << 22) | (1 << 23) | (1 << 28) | \
 			 (1 << 29))
+#define SCTLR_EL2_RES0	((1 << 6)  | (1 << 7)  | (1 << 8)  | (1 << 9)  | \
+			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
+			 (1 << 17) | (1 << 20) | (1 << 21) | (1 << 24) | \
+			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31))
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define ENDIAN_SET_EL2		SCTLR_ELx_EE
+#define ENDIAN_CLEAR_EL2	0
+#else
+#define ENDIAN_SET_EL2		0
+#define ENDIAN_CLEAR_EL2	SCTLR_ELx_EE
+#endif
+
+/* SCTLR_EL2 value used for the hyp-stub */
+#define SCTLR_EL2_SET	(ENDIAN_SET_EL2   | SCTLR_EL2_RES1)
+#define SCTLR_EL2_CLEAR	(SCTLR_ELx_M      | SCTLR_ELx_A    | SCTLR_ELx_C   | \
+			 SCTLR_ELx_SA     | SCTLR_ELx_I    | SCTLR_ELx_WXN | \
+			 ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
+
+/* Check all the bits are accounted for */
+#define SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL2_SET ^ SCTLR_EL2_CLEAR) != ~0)
 
-#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
-			 SCTLR_ELx_SA | SCTLR_ELx_I)
 
 /* SCTLR_EL1 specific flags. */
 #define SCTLR_EL1_UCI		(1 << 26)
+#define SCTLR_EL1_E0E		(1 << 24)
 #define SCTLR_EL1_SPAN		(1 << 23)
+#define SCTLR_EL1_NTWE		(1 << 18)
+#define SCTLR_EL1_NTWI		(1 << 16)
 #define SCTLR_EL1_UCT		(1 << 15)
+#define SCTLR_EL1_DZE		(1 << 14)
+#define SCTLR_EL1_UMA		(1 << 9)
 #define SCTLR_EL1_SED		(1 << 8)
+#define SCTLR_EL1_ITD		(1 << 7)
 #define SCTLR_EL1_CP15BEN	(1 << 5)
+#define SCTLR_EL1_SA0		(1 << 4)
+
+#define SCTLR_EL1_RES1	((1 << 11) | (1 << 20) | (1 << 22) | (1 << 28) | \
+			 (1 << 29))
+#define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
+			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31))
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
+#define ENDIAN_CLEAR_EL1	0
+#else
+#define ENDIAN_SET_EL1		0
+#define ENDIAN_CLEAR_EL1	(SCTLR_EL1_E0E | SCTLR_ELx_EE)
+#endif
+
+#define SCTLR_EL1_SET	(SCTLR_ELx_M    | SCTLR_ELx_C    | SCTLR_ELx_SA   |\
+			 SCTLR_EL1_SA0  | SCTLR_EL1_SED  | SCTLR_ELx_I    |\
+			 SCTLR_EL1_DZE  | SCTLR_EL1_UCT  | SCTLR_EL1_NTWI |\
+			 SCTLR_EL1_NTWE | SCTLR_EL1_SPAN | ENDIAN_SET_EL1 |\
+			 SCTLR_EL1_UCI  | SCTLR_EL1_RES1)
+#define SCTLR_EL1_CLEAR	(SCTLR_ELx_A   | SCTLR_EL1_CP15BEN | SCTLR_EL1_ITD    |\
+			 SCTLR_EL1_UMA | SCTLR_ELx_WXN     | ENDIAN_CLEAR_EL1 |\
+			 SCTLR_EL1_RES0)
+
+/* Check all the bits are accounted for */
+#define SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS	BUILD_BUG_ON((SCTLR_EL1_SET ^ SCTLR_EL1_CLEAR) != ~0)
 
 /* id_aa64isar0 */
 #define ID_AA64ISAR0_FHM_SHIFT		48
@@ -593,6 +650,7 @@
 
 #else
 
+#include <linux/build_bug.h>
 #include <linux/types.h>
 
 asm(
@@ -649,6 +707,9 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 {
 	u32 val;
 
+	SCTLR_EL2_BUILD_BUG_ON_MISSING_BITS;
+	SCTLR_EL1_BUILD_BUG_ON_MISSING_BITS;
+
 	val = read_sysreg(sctlr_el1);
 	val &= ~clear;
 	val |= set;
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 95748a00eb89..c3b241b8b659 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -492,17 +492,13 @@ ENTRY(el2_setup)
 	mrs	x0, CurrentEL
 	cmp	x0, #CurrentEL_EL2
 	b.eq	1f
-	mrs	x0, sctlr_el1
-CPU_BE(	orr	x0, x0, #(3 << 24)	)	// Set the EE and E0E bits for EL1
-CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clear the EE and E0E bits for EL1
+	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
 	msr	sctlr_el1, x0
 	mov	w0, #BOOT_CPU_MODE_EL1		// This cpu booted in EL1
 	isb
 	ret
 
-1:	mrs	x0, sctlr_el2
-CPU_BE(	orr	x0, x0, #(1 << 25)	)	// Set the EE bit for EL2
-CPU_LE(	bic	x0, x0, #(1 << 25)	)	// Clear the EE bit for EL2
+1:	mov_q	x0, (SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
 	msr	sctlr_el2, x0
 
 #ifdef CONFIG_ARM64_VHE
@@ -618,10 +614,7 @@ install_el2_stub:
 	 * requires no configuration, and all non-hyp-specific EL2 setup
 	 * will be done via the _EL1 system register aliases in __cpu_setup.
 	 */
-	/* sctlr_el1 */
-	mov	x0, #0x0800			// Set/clear RES{1,0} bits
-CPU_BE(	movk	x0, #0x33d0, lsl #16	)	// Set EE and E0E on BE systems
-CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
+	mov_q	x0, (SCTLR_EL1_RES1 | ENDIAN_SET_EL1)
 	msr	sctlr_el1, x0
 
 	/* Coprocessor traps. */
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 5a59eea49395..ec4c3d82b4d6 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -226,11 +226,7 @@ ENTRY(__cpu_setup)
 	/*
 	 * Prepare SCTLR
 	 */
-	adr	x5, crval
-	ldp	w5, w6, [x5]
-	mrs	x0, sctlr_el1
-	bic	x0, x0, x5			// clear bits
-	orr	x0, x0, x6			// set bits
+	mov_q	x0, SCTLR_EL1_SET
 	/*
 	 * Set/prepare TCR and TTBR. We use 512GB (39-bit) address range for
 	 * both user and kernel.
@@ -259,21 +255,3 @@ ENTRY(__cpu_setup)
 	msr	tcr_el1, x10
 	ret					// return to head.S
 ENDPROC(__cpu_setup)
-
-	/*
-	 * We set the desired value explicitly, including those of the
-	 * reserved bits. The values of bits EE & E0E were set early in
-	 * el2_setup, which are left untouched below.
-	 *
-	 *                 n n            T
-	 *       U E      WT T UD     US IHBS
-	 *       CE0      XWHW CZ     ME TEEA S
-	 * .... .IEE .... NEAI TE.I ..AD DEN0 ACAM
-	 * 0011 0... 1101 ..0. ..0. 10.. .0.. .... < hardware reserved
-	 * .... .1.. .... 01.1 11.1 ..01 0.01 1101 < software settings
-	 */
-	.type	crval, #object
-crval:
-	.word	0xfcffffff			// clear
-	.word	0x34d5d91d			// set
-	.popsection
-- 
2.15.1
