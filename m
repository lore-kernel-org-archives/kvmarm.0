From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/95] ARM: KVM: Add CP15 save/restore code
Date: Wed,  9 Mar 2016 07:30:04 +0000
Message-ID: <1457508689-19672-11-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF48F412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Rb3znQhBwEPE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1BC349B2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:13 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Concert the CP15 save/restore code to C.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile  |  1 +
 arch/arm/kvm/hyp/cp15-sr.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/hyp.h     | 28 ++++++++++++++++
 3 files changed, 113 insertions(+)
 create mode 100644 arch/arm/kvm/hyp/cp15-sr.c

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 36c760d..9f96fcb 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
+obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
diff --git a/arch/arm/kvm/hyp/cp15-sr.c b/arch/arm/kvm/hyp/cp15-sr.c
new file mode 100644
index 0000000..732abbc
--- /dev/null
+++ b/arch/arm/kvm/hyp/cp15-sr.c
@@ -0,0 +1,84 @@
+/*
+ * Original code:
+ * Copyright (C) 2012 - Virtual Open Systems and Columbia University
+ * Author: Christoffer Dall <c.dall@virtualopensystems.com>
+ *
+ * Mostly rewritten in C by Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "hyp.h"
+
+static u64 *cp15_64(struct kvm_cpu_context *ctxt, int idx)
+{
+	return (u64 *)(ctxt->cp15 + idx);
+}
+
+void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt->cp15[c0_MPIDR]		= read_sysreg(VMPIDR);
+	ctxt->cp15[c0_CSSELR]		= read_sysreg(CSSELR);
+	ctxt->cp15[c1_SCTLR]		= read_sysreg(SCTLR);
+	ctxt->cp15[c1_CPACR]		= read_sysreg(CPACR);
+	*cp15_64(ctxt, c2_TTBR0)	= read_sysreg(TTBR0);
+	*cp15_64(ctxt, c2_TTBR1)	= read_sysreg(TTBR1);
+	ctxt->cp15[c2_TTBCR]		= read_sysreg(TTBCR);
+	ctxt->cp15[c3_DACR]		= read_sysreg(DACR);
+	ctxt->cp15[c5_DFSR]		= read_sysreg(DFSR);
+	ctxt->cp15[c5_IFSR]		= read_sysreg(IFSR);
+	ctxt->cp15[c5_ADFSR]		= read_sysreg(ADFSR);
+	ctxt->cp15[c5_AIFSR]		= read_sysreg(AIFSR);
+	ctxt->cp15[c6_DFAR]		= read_sysreg(DFAR);
+	ctxt->cp15[c6_IFAR]		= read_sysreg(IFAR);
+	*cp15_64(ctxt, c7_PAR)		= read_sysreg(PAR);
+	ctxt->cp15[c10_PRRR]		= read_sysreg(PRRR);
+	ctxt->cp15[c10_NMRR]		= read_sysreg(NMRR);
+	ctxt->cp15[c10_AMAIR0]		= read_sysreg(AMAIR0);
+	ctxt->cp15[c10_AMAIR1]		= read_sysreg(AMAIR1);
+	ctxt->cp15[c12_VBAR]		= read_sysreg(VBAR);
+	ctxt->cp15[c13_CID]		= read_sysreg(CID);
+	ctxt->cp15[c13_TID_URW]		= read_sysreg(TID_URW);
+	ctxt->cp15[c13_TID_URO]		= read_sysreg(TID_URO);
+	ctxt->cp15[c13_TID_PRIV]	= read_sysreg(TID_PRIV);
+	ctxt->cp15[c14_CNTKCTL]		= read_sysreg(CNTKCTL);
+}
+
+void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
+{
+	write_sysreg(ctxt->cp15[c0_MPIDR],	VMPIDR);
+	write_sysreg(ctxt->cp15[c0_CSSELR],	CSSELR);
+	write_sysreg(ctxt->cp15[c1_SCTLR],	SCTLR);
+	write_sysreg(ctxt->cp15[c1_CPACR],	CPACR);
+	write_sysreg(*cp15_64(ctxt, c2_TTBR0),	TTBR0);
+	write_sysreg(*cp15_64(ctxt, c2_TTBR1),	TTBR1);
+	write_sysreg(ctxt->cp15[c2_TTBCR],	TTBCR);
+	write_sysreg(ctxt->cp15[c3_DACR],	DACR);
+	write_sysreg(ctxt->cp15[c5_DFSR],	DFSR);
+	write_sysreg(ctxt->cp15[c5_IFSR],	IFSR);
+	write_sysreg(ctxt->cp15[c5_ADFSR],	ADFSR);
+	write_sysreg(ctxt->cp15[c5_AIFSR],	AIFSR);
+	write_sysreg(ctxt->cp15[c6_DFAR],	DFAR);
+	write_sysreg(ctxt->cp15[c6_IFAR],	IFAR);
+	write_sysreg(*cp15_64(ctxt, c7_PAR),	PAR);
+	write_sysreg(ctxt->cp15[c10_PRRR],	PRRR);
+	write_sysreg(ctxt->cp15[c10_NMRR],	NMRR);
+	write_sysreg(ctxt->cp15[c10_AMAIR0],	AMAIR0);
+	write_sysreg(ctxt->cp15[c10_AMAIR1],	AMAIR1);
+	write_sysreg(ctxt->cp15[c12_VBAR],	VBAR);
+	write_sysreg(ctxt->cp15[c13_CID],	CID);
+	write_sysreg(ctxt->cp15[c13_TID_URW],	TID_URW);
+	write_sysreg(ctxt->cp15[c13_TID_URO],	TID_URO);
+	write_sysreg(ctxt->cp15[c13_TID_PRIV],	TID_PRIV);
+	write_sysreg(ctxt->cp15[c14_CNTKCTL],	CNTKCTL);
+}
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index 5808bbd..ab2cb82 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -42,9 +42,37 @@
 })
 #define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
 
+#define TTBR0		__ACCESS_CP15_64(0, c2)
+#define TTBR1		__ACCESS_CP15_64(1, c2)
 #define VTTBR		__ACCESS_CP15_64(6, c2)
+#define PAR		__ACCESS_CP15_64(0, c7)
+#define CSSELR		__ACCESS_CP15(c0, 2, c0, 0)
+#define VMPIDR		__ACCESS_CP15(c0, 4, c0, 5)
+#define SCTLR		__ACCESS_CP15(c1, 0, c0, 0)
+#define CPACR		__ACCESS_CP15(c1, 0, c0, 2)
+#define TTBCR		__ACCESS_CP15(c2, 0, c0, 2)
+#define DACR		__ACCESS_CP15(c3, 0, c0, 0)
+#define DFSR		__ACCESS_CP15(c5, 0, c0, 0)
+#define IFSR		__ACCESS_CP15(c5, 0, c0, 1)
+#define ADFSR		__ACCESS_CP15(c5, 0, c1, 0)
+#define AIFSR		__ACCESS_CP15(c5, 0, c1, 1)
+#define DFAR		__ACCESS_CP15(c6, 0, c0, 0)
+#define IFAR		__ACCESS_CP15(c6, 0, c0, 2)
 #define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
 #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
 #define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
+#define PRRR		__ACCESS_CP15(c10, 0, c2, 0)
+#define NMRR		__ACCESS_CP15(c10, 0, c2, 1)
+#define AMAIR0		__ACCESS_CP15(c10, 0, c3, 0)
+#define AMAIR1		__ACCESS_CP15(c10, 0, c3, 1)
+#define VBAR		__ACCESS_CP15(c12, 0, c0, 0)
+#define CID		__ACCESS_CP15(c13, 0, c0, 1)
+#define TID_URW		__ACCESS_CP15(c13, 0, c0, 2)
+#define TID_URO		__ACCESS_CP15(c13, 0, c0, 3)
+#define TID_PRIV	__ACCESS_CP15(c13, 0, c0, 4)
+#define CNTKCTL		__ACCESS_CP15(c14, 0, c1, 0)
+
+void __sysreg_save_state(struct kvm_cpu_context *ctxt);
+void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 
 #endif /* __ARM_KVM_HYP_H__ */
-- 
2.1.4
