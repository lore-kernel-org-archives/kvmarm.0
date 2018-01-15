From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 05/13] arm64: Unconditionally enable IESB on exception
 entry/return for firmware-first
Date: Mon, 15 Jan 2018 19:38:58 +0000
Message-ID: <20180115193906.30053-6-james.morse@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20C9849DFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hhDhJmR+DZz2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 14:36:48 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D373649E1D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:46 -0500 (EST)
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

ARM v8.2 has a feature to add implicit error synchronization barriers
whenever the CPU enters or returns from an exception level. Add this to the
features we always enable. CPUs that don't support this feature will treat
the bit as RES0.

This feature causes RAS errors that are not yet visible to software to
become pending SErrors. We expect to have firmware-first RAS support
so synchronised RAS errors will be take immediately to EL3.
Any system without firmware-first handling of errors will take the SError
either immediatly after exception return, or when we unmask SError after
entry.S's work.

Adding IESB to the ELx flags causes it to be enabled by KVM and kexec
too.

Platform level RAS support may require additional firmware support.

Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Suggested-by: Will Deacon <will.deacon@arm.com>
Link: https://www.spinics.net/lists/kvm-arm/msg28192.html
Signed-off-by: James Morse <james.morse@arm.com>
---
Changes since v4:
 * Unconditionally enabled in SCTLR_ELx, (so a rewrite)
 * Dropped Catalin's Reviewed-by.

Changes since v3:
 * removed IESB Kconfig option

 arch/arm64/include/asm/sysreg.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 321622e9f9c3..1281bc8263c2 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -399,6 +399,7 @@
 
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
+#define SCTLR_ELx_IESB	(1 << 21)
 #define SCTLR_ELx_WXN	(1 << 19)
 #define SCTLR_ELx_I	(1 << 12)
 #define SCTLR_ELx_SA	(1 << 3)
@@ -406,8 +407,8 @@
 #define SCTLR_ELx_A	(1 << 1)
 #define SCTLR_ELx_M	1
 
-#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | \
-			 SCTLR_ELx_SA | SCTLR_ELx_I)
+#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
+			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
 
 /* SCTLR_EL2 specific flags. */
 #define SCTLR_EL2_RES1	((1 << 4)  | (1 << 5)  | (1 << 11) | (1 << 16) | \
@@ -415,8 +416,8 @@
 			 (1 << 29))
 #define SCTLR_EL2_RES0	((1 << 6)  | (1 << 7)  | (1 << 8)  | (1 << 9)  | \
 			 (1 << 10) | (1 << 13) | (1 << 14) | (1 << 15) | \
-			 (1 << 17) | (1 << 20) | (1 << 21) | (1 << 24) | \
-			 (1 << 26) | (1 << 27) | (1 << 30) | (1 << 31))
+			 (1 << 17) | (1 << 20) | (1 << 24) | (1 << 26) | \
+			 (1 << 27) | (1 << 30) | (1 << 31))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL2		SCTLR_ELx_EE
@@ -427,7 +428,7 @@
 #endif
 
 /* SCTLR_EL2 value used for the hyp-stub */
-#define SCTLR_EL2_SET	(ENDIAN_SET_EL2   | SCTLR_EL2_RES1)
+#define SCTLR_EL2_SET	(SCTLR_ELx_IESB   | ENDIAN_SET_EL2   | SCTLR_EL2_RES1)
 #define SCTLR_EL2_CLEAR	(SCTLR_ELx_M      | SCTLR_ELx_A    | SCTLR_ELx_C   | \
 			 SCTLR_ELx_SA     | SCTLR_ELx_I    | SCTLR_ELx_WXN | \
 			 ENDIAN_CLEAR_EL2 | SCTLR_EL2_RES0)
@@ -453,7 +454,7 @@
 #define SCTLR_EL1_RES1	((1 << 11) | (1 << 20) | (1 << 22) | (1 << 28) | \
 			 (1 << 29))
 #define SCTLR_EL1_RES0  ((1 << 6)  | (1 << 10) | (1 << 13) | (1 << 17) | \
-			 (1 << 21) | (1 << 27) | (1 << 30) | (1 << 31))
+			 (1 << 27) | (1 << 30) | (1 << 31))
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
 #define ENDIAN_SET_EL1		(SCTLR_EL1_E0E | SCTLR_ELx_EE)
@@ -466,8 +467,8 @@
 #define SCTLR_EL1_SET	(SCTLR_ELx_M    | SCTLR_ELx_C    | SCTLR_ELx_SA   |\
 			 SCTLR_EL1_SA0  | SCTLR_EL1_SED  | SCTLR_ELx_I    |\
 			 SCTLR_EL1_DZE  | SCTLR_EL1_UCT  | SCTLR_EL1_NTWI |\
-			 SCTLR_EL1_NTWE | SCTLR_EL1_SPAN | ENDIAN_SET_EL1 |\
-			 SCTLR_EL1_UCI  | SCTLR_EL1_RES1)
+			 SCTLR_EL1_NTWE | SCTLR_ELx_IESB | SCTLR_EL1_SPAN |\
+			 ENDIAN_SET_EL1 | SCTLR_EL1_UCI  | SCTLR_EL1_RES1)
 #define SCTLR_EL1_CLEAR	(SCTLR_ELx_A   | SCTLR_EL1_CP15BEN | SCTLR_EL1_ITD    |\
 			 SCTLR_EL1_UMA | SCTLR_ELx_WXN     | ENDIAN_CLEAR_EL1 |\
 			 SCTLR_EL1_RES0)
-- 
2.15.1
