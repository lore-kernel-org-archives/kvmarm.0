From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 2/7] arm64: KVM: Move the AArch32 conditional execution to
 common code
Date: Tue,  6 Sep 2016 09:28:42 +0100
Message-ID: <1473150527-4729-3-git-send-email-marc.zyngier@arm.com>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C9649B46
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vy3LVRb8HewL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 04:20:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90D7F49B50
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:35 -0400 (EDT)
In-Reply-To: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

It would make some sense to share the conditional execution code
between 32 and 64bit. In order to achieve this, let's move that
code to virt/kvm/arm/aarch32.c. While we're at it, drop a
superfluous BUG_ON() that wasn't that useful.

Following patches will migrate the 32bit port to that code base.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/emulate.c   |   4 +-
 arch/arm64/kvm/Makefile  |   3 +-
 arch/arm64/kvm/emulate.c | 148 -----------------------------------------------
 virt/kvm/arm/aarch32.c   | 146 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 149 insertions(+), 152 deletions(-)
 delete mode 100644 arch/arm64/kvm/emulate.c
 create mode 100644 virt/kvm/arm/aarch32.c

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index af93e3f..eda9ddd 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -221,9 +221,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	bool is_arm = !(cpsr & PSR_T_BIT);
 
-	BUG_ON(is_arm && (cpsr & PSR_IT_MASK));
-
-	if (!(cpsr & PSR_IT_MASK))
+	if (is_arm || !(cpsr & PSR_IT_MASK))
 		return;
 
 	cond = (cpsr & 0xe000) >> 13;
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 695eb3c..d50a82a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -16,9 +16,10 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/e
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
+kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
 kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/aarch32.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-init.o
diff --git a/arch/arm64/kvm/emulate.c b/arch/arm64/kvm/emulate.c
deleted file mode 100644
index 40098ad..0000000
--- a/arch/arm64/kvm/emulate.c
+++ /dev/null
@@ -1,148 +0,0 @@
-/*
- * (not much of an) Emulation layer for 32bit guests.
- *
- * Copyright (C) 2012,2013 - ARM Ltd
- * Author: Marc Zyngier <marc.zyngier@arm.com>
- *
- * based on arch/arm/kvm/emulate.c
- * Copyright (C) 2012 - Virtual Open Systems and Columbia University
- * Author: Christoffer Dall <c.dall@virtualopensystems.com>
- *
- * This program is free software: you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/kvm_host.h>
-#include <asm/kvm_emulate.h>
-
-/*
- * stolen from arch/arm/kernel/opcodes.c
- *
- * condition code lookup table
- * index into the table is test code: EQ, NE, ... LT, GT, AL, NV
- *
- * bit position in short is condition code: NZCV
- */
-static const unsigned short cc_map[16] = {
-	0xF0F0,			/* EQ == Z set            */
-	0x0F0F,			/* NE                     */
-	0xCCCC,			/* CS == C set            */
-	0x3333,			/* CC                     */
-	0xFF00,			/* MI == N set            */
-	0x00FF,			/* PL                     */
-	0xAAAA,			/* VS == V set            */
-	0x5555,			/* VC                     */
-	0x0C0C,			/* HI == C set && Z clear */
-	0xF3F3,			/* LS == C clear || Z set */
-	0xAA55,			/* GE == (N==V)           */
-	0x55AA,			/* LT == (N!=V)           */
-	0x0A05,			/* GT == (!Z && (N==V))   */
-	0xF5FA,			/* LE == (Z || (N!=V))    */
-	0xFFFF,			/* AL always              */
-	0			/* NV                     */
-};
-
-/*
- * Check if a trapped instruction should have been executed or not.
- */
-bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
-{
-	unsigned long cpsr;
-	u32 cpsr_cond;
-	int cond;
-
-	/* Top two bits non-zero?  Unconditional. */
-	if (kvm_vcpu_get_hsr(vcpu) >> 30)
-		return true;
-
-	/* Is condition field valid? */
-	cond = kvm_vcpu_get_condition(vcpu);
-	if (cond == 0xE)
-		return true;
-
-	cpsr = *vcpu_cpsr(vcpu);
-
-	if (cond < 0) {
-		/* This can happen in Thumb mode: examine IT state. */
-		unsigned long it;
-
-		it = ((cpsr >> 8) & 0xFC) | ((cpsr >> 25) & 0x3);
-
-		/* it == 0 => unconditional. */
-		if (it == 0)
-			return true;
-
-		/* The cond for this insn works out as the top 4 bits. */
-		cond = (it >> 4);
-	}
-
-	cpsr_cond = cpsr >> 28;
-
-	if (!((cc_map[cond] >> cpsr_cond) & 1))
-		return false;
-
-	return true;
-}
-
-/**
- * adjust_itstate - adjust ITSTATE when emulating instructions in IT-block
- * @vcpu:	The VCPU pointer
- *
- * When exceptions occur while instructions are executed in Thumb IF-THEN
- * blocks, the ITSTATE field of the CPSR is not advanced (updated), so we have
- * to do this little bit of work manually. The fields map like this:
- *
- * IT[7:0] -> CPSR[26:25],CPSR[15:10]
- */
-static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
-{
-	unsigned long itbits, cond;
-	unsigned long cpsr = *vcpu_cpsr(vcpu);
-	bool is_arm = !(cpsr & COMPAT_PSR_T_BIT);
-
-	BUG_ON(is_arm && (cpsr & COMPAT_PSR_IT_MASK));
-
-	if (!(cpsr & COMPAT_PSR_IT_MASK))
-		return;
-
-	cond = (cpsr & 0xe000) >> 13;
-	itbits = (cpsr & 0x1c00) >> (10 - 2);
-	itbits |= (cpsr & (0x3 << 25)) >> 25;
-
-	/* Perform ITAdvance (see page A2-52 in ARM DDI 0406C) */
-	if ((itbits & 0x7) == 0)
-		itbits = cond = 0;
-	else
-		itbits = (itbits << 1) & 0x1f;
-
-	cpsr &= ~COMPAT_PSR_IT_MASK;
-	cpsr |= cond << 13;
-	cpsr |= (itbits & 0x1c) << (10 - 2);
-	cpsr |= (itbits & 0x3) << 25;
-	*vcpu_cpsr(vcpu) = cpsr;
-}
-
-/**
- * kvm_skip_instr - skip a trapped instruction and proceed to the next
- * @vcpu: The vcpu pointer
- */
-void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
-{
-	bool is_thumb;
-
-	is_thumb = !!(*vcpu_cpsr(vcpu) & COMPAT_PSR_T_BIT);
-	if (is_thumb && !is_wide_instr)
-		*vcpu_pc(vcpu) += 2;
-	else
-		*vcpu_pc(vcpu) += 4;
-	kvm_adjust_itstate(vcpu);
-}
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
new file mode 100644
index 0000000..cb02e56
--- /dev/null
+++ b/virt/kvm/arm/aarch32.c
@@ -0,0 +1,146 @@
+/*
+ * (not much of an) Emulation layer for 32bit guests.
+ *
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * based on arch/arm/kvm/emulate.c
+ * Copyright (C) 2012 - Virtual Open Systems and Columbia University
+ * Author: Christoffer Dall <c.dall@virtualopensystems.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
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
+#include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+
+/*
+ * stolen from arch/arm/kernel/opcodes.c
+ *
+ * condition code lookup table
+ * index into the table is test code: EQ, NE, ... LT, GT, AL, NV
+ *
+ * bit position in short is condition code: NZCV
+ */
+static const unsigned short cc_map[16] = {
+	0xF0F0,			/* EQ == Z set            */
+	0x0F0F,			/* NE                     */
+	0xCCCC,			/* CS == C set            */
+	0x3333,			/* CC                     */
+	0xFF00,			/* MI == N set            */
+	0x00FF,			/* PL                     */
+	0xAAAA,			/* VS == V set            */
+	0x5555,			/* VC                     */
+	0x0C0C,			/* HI == C set && Z clear */
+	0xF3F3,			/* LS == C clear || Z set */
+	0xAA55,			/* GE == (N==V)           */
+	0x55AA,			/* LT == (N!=V)           */
+	0x0A05,			/* GT == (!Z && (N==V))   */
+	0xF5FA,			/* LE == (Z || (N!=V))    */
+	0xFFFF,			/* AL always              */
+	0			/* NV                     */
+};
+
+/*
+ * Check if a trapped instruction should have been executed or not.
+ */
+bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
+{
+	unsigned long cpsr;
+	u32 cpsr_cond;
+	int cond;
+
+	/* Top two bits non-zero?  Unconditional. */
+	if (kvm_vcpu_get_hsr(vcpu) >> 30)
+		return true;
+
+	/* Is condition field valid? */
+	cond = kvm_vcpu_get_condition(vcpu);
+	if (cond == 0xE)
+		return true;
+
+	cpsr = *vcpu_cpsr(vcpu);
+
+	if (cond < 0) {
+		/* This can happen in Thumb mode: examine IT state. */
+		unsigned long it;
+
+		it = ((cpsr >> 8) & 0xFC) | ((cpsr >> 25) & 0x3);
+
+		/* it == 0 => unconditional. */
+		if (it == 0)
+			return true;
+
+		/* The cond for this insn works out as the top 4 bits. */
+		cond = (it >> 4);
+	}
+
+	cpsr_cond = cpsr >> 28;
+
+	if (!((cc_map[cond] >> cpsr_cond) & 1))
+		return false;
+
+	return true;
+}
+
+/**
+ * adjust_itstate - adjust ITSTATE when emulating instructions in IT-block
+ * @vcpu:	The VCPU pointer
+ *
+ * When exceptions occur while instructions are executed in Thumb IF-THEN
+ * blocks, the ITSTATE field of the CPSR is not advanced (updated), so we have
+ * to do this little bit of work manually. The fields map like this:
+ *
+ * IT[7:0] -> CPSR[26:25],CPSR[15:10]
+ */
+static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
+{
+	unsigned long itbits, cond;
+	unsigned long cpsr = *vcpu_cpsr(vcpu);
+	bool is_arm = !(cpsr & COMPAT_PSR_T_BIT);
+
+	if (is_arm || !(cpsr & COMPAT_PSR_IT_MASK))
+		return;
+
+	cond = (cpsr & 0xe000) >> 13;
+	itbits = (cpsr & 0x1c00) >> (10 - 2);
+	itbits |= (cpsr & (0x3 << 25)) >> 25;
+
+	/* Perform ITAdvance (see page A2-52 in ARM DDI 0406C) */
+	if ((itbits & 0x7) == 0)
+		itbits = cond = 0;
+	else
+		itbits = (itbits << 1) & 0x1f;
+
+	cpsr &= ~COMPAT_PSR_IT_MASK;
+	cpsr |= cond << 13;
+	cpsr |= (itbits & 0x1c) << (10 - 2);
+	cpsr |= (itbits & 0x3) << 25;
+	*vcpu_cpsr(vcpu) = cpsr;
+}
+
+/**
+ * kvm_skip_instr - skip a trapped instruction and proceed to the next
+ * @vcpu: The vcpu pointer
+ */
+void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
+{
+	bool is_thumb;
+
+	is_thumb = !!(*vcpu_cpsr(vcpu) & COMPAT_PSR_T_BIT);
+	if (is_thumb && !is_wide_instr)
+		*vcpu_pc(vcpu) += 2;
+	else
+		*vcpu_pc(vcpu) += 4;
+	kvm_adjust_itstate(vcpu);
+}
-- 
2.1.4
