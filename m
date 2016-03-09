From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/95] ARM: KVM: Add banked registers save/restore
Date: Wed,  9 Mar 2016 07:30:08 +0000
Message-ID: <1457508689-19672-15-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13227412C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZTm1ANixhbGG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:25 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D11D49B42
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:25 -0500 (EST)
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

Banked registers are one of the many perks of the 32bit architecture,
and the world switch needs to cope with it.

This requires some "special" accessors, as these are not accessed
using a standard coprocessor instruction.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile    |  1 +
 arch/arm/kvm/hyp/banked-sr.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/hyp.h       | 11 +++++++
 3 files changed, 89 insertions(+)
 create mode 100644 arch/arm/kvm/hyp/banked-sr.c

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 5a45f4c..173bd1d 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
+obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
diff --git a/arch/arm/kvm/hyp/banked-sr.c b/arch/arm/kvm/hyp/banked-sr.c
new file mode 100644
index 0000000..d02dc80
--- /dev/null
+++ b/arch/arm/kvm/hyp/banked-sr.c
@@ -0,0 +1,77 @@
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
+__asm__(".arch_extension     virt");
+
+void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt)
+{
+	ctxt->gp_regs.usr_regs.ARM_sp	= read_special(SP_usr);
+	ctxt->gp_regs.usr_regs.ARM_pc	= read_special(ELR_hyp);
+	ctxt->gp_regs.usr_regs.ARM_cpsr	= read_special(SPSR);
+	ctxt->gp_regs.KVM_ARM_SVC_sp	= read_special(SP_svc);
+	ctxt->gp_regs.KVM_ARM_SVC_lr	= read_special(LR_svc);
+	ctxt->gp_regs.KVM_ARM_SVC_spsr	= read_special(SPSR_svc);
+	ctxt->gp_regs.KVM_ARM_ABT_sp	= read_special(SP_abt);
+	ctxt->gp_regs.KVM_ARM_ABT_lr	= read_special(LR_abt);
+	ctxt->gp_regs.KVM_ARM_ABT_spsr	= read_special(SPSR_abt);
+	ctxt->gp_regs.KVM_ARM_UND_sp	= read_special(SP_und);
+	ctxt->gp_regs.KVM_ARM_UND_lr	= read_special(LR_und);
+	ctxt->gp_regs.KVM_ARM_UND_spsr	= read_special(SPSR_und);
+	ctxt->gp_regs.KVM_ARM_IRQ_sp	= read_special(SP_irq);
+	ctxt->gp_regs.KVM_ARM_IRQ_lr	= read_special(LR_irq);
+	ctxt->gp_regs.KVM_ARM_IRQ_spsr	= read_special(SPSR_irq);
+	ctxt->gp_regs.KVM_ARM_FIQ_r8	= read_special(R8_fiq);
+	ctxt->gp_regs.KVM_ARM_FIQ_r9	= read_special(R9_fiq);
+	ctxt->gp_regs.KVM_ARM_FIQ_r10	= read_special(R10_fiq);
+	ctxt->gp_regs.KVM_ARM_FIQ_fp	= read_special(R11_fiq);
+	ctxt->gp_regs.KVM_ARM_FIQ_ip	= read_special(R12_fiq);
+	ctxt->gp_regs.KVM_ARM_FIQ_sp	= read_special(SP_fiq);
+	ctxt->gp_regs.KVM_ARM_FIQ_lr	= read_special(LR_fiq);
+	ctxt->gp_regs.KVM_ARM_FIQ_spsr	= read_special(SPSR_fiq);
+}
+
+void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt)
+{
+	write_special(ctxt->gp_regs.usr_regs.ARM_sp,	SP_usr);
+	write_special(ctxt->gp_regs.usr_regs.ARM_pc,	ELR_hyp);
+	write_special(ctxt->gp_regs.usr_regs.ARM_cpsr,	SPSR_cxsf);
+	write_special(ctxt->gp_regs.KVM_ARM_SVC_sp,	SP_svc);
+	write_special(ctxt->gp_regs.KVM_ARM_SVC_lr,	LR_svc);
+	write_special(ctxt->gp_regs.KVM_ARM_SVC_spsr,	SPSR_svc);
+	write_special(ctxt->gp_regs.KVM_ARM_ABT_sp,	SP_abt);
+	write_special(ctxt->gp_regs.KVM_ARM_ABT_lr,	LR_abt);
+	write_special(ctxt->gp_regs.KVM_ARM_ABT_spsr,	SPSR_abt);
+	write_special(ctxt->gp_regs.KVM_ARM_UND_sp,	SP_und);
+	write_special(ctxt->gp_regs.KVM_ARM_UND_lr,	LR_und);
+	write_special(ctxt->gp_regs.KVM_ARM_UND_spsr,	SPSR_und);
+	write_special(ctxt->gp_regs.KVM_ARM_IRQ_sp,	SP_irq);
+	write_special(ctxt->gp_regs.KVM_ARM_IRQ_lr,	LR_irq);
+	write_special(ctxt->gp_regs.KVM_ARM_IRQ_spsr,	SPSR_irq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_r8,	R8_fiq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_r9,	R9_fiq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_r10,	R10_fiq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_fp,	R11_fiq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_ip,	R12_fiq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_sp,	SP_fiq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_lr,	LR_fiq);
+	write_special(ctxt->gp_regs.KVM_ARM_FIQ_spsr,	SPSR_fiq);
+}
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index dce0f73..278eb1f 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -45,6 +45,14 @@
 })
 #define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
 
+#define write_special(v, r)					\
+	asm volatile("msr " __stringify(r) ", %0" : : "r" (v))
+#define read_special(r) ({					\
+	u32 __val;						\
+	asm volatile("mrs %0, " __stringify(r) : "=r" (__val));	\
+	__val;							\
+})
+
 #define TTBR0		__ACCESS_CP15_64(0, c2)
 #define TTBR1		__ACCESS_CP15_64(1, c2)
 #define VTTBR		__ACCESS_CP15_64(6, c2)
@@ -99,4 +107,7 @@ static inline bool __vfp_enabled(void)
 	return !(read_sysreg(HCPTR) & (HCPTR_TCP(11) | HCPTR_TCP(10)));
 }
 
+void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt);
+void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
+
 #endif /* __ARM_KVM_HYP_H__ */
-- 
2.1.4
