From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/95] ARM: KVM: Add guest entry code
Date: Wed,  9 Mar 2016 07:30:09 +0000
Message-ID: <1457508689-19672-16-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1F30412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nlPkK1fWo5KO for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:29 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 014C249B3C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:28 -0500 (EST)
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

Add the very minimal piece of code that is now required to jump
into the guest (and return from it). This code is only concerned
with save/restoring the USR registers (r0-r12+lr for the guest,
r4-r12+lr for the host), as everything else is dealt with in C
(VFP is another matter though).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/Makefile |  1 +
 arch/arm/kvm/hyp/entry.S  | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/hyp/hyp.h    |  2 ++
 3 files changed, 73 insertions(+)
 create mode 100644 arch/arm/kvm/hyp/entry.S

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index 173bd1d..c779690 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_KVM_ARM_HOST) += timer-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += vfp.o
 obj-$(CONFIG_KVM_ARM_HOST) += banked-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += entry.o
diff --git a/arch/arm/kvm/hyp/entry.S b/arch/arm/kvm/hyp/entry.S
new file mode 100644
index 0000000..32f79b0
--- /dev/null
+++ b/arch/arm/kvm/hyp/entry.S
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2016 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
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
+*/
+
+#include <linux/linkage.h>
+#include <asm/asm-offsets.h>
+#include <asm/kvm_arm.h>
+
+	.arch_extension     virt
+
+	.text
+	.pushsection	.hyp.text, "ax"
+
+#define USR_REGS_OFFSET		(CPU_CTXT_GP_REGS + GP_REGS_USR)
+
+/* int __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host) */
+ENTRY(__guest_enter)
+	@ Save host registers
+	add	r1, r1, #(USR_REGS_OFFSET + S_R4)
+	stm	r1!, {r4-r12}
+	str	lr, [r1, #4]	@ Skip SP_usr (already saved)
+
+	@ Restore guest registers
+	add	r0, r0,  #(VCPU_GUEST_CTXT + USR_REGS_OFFSET + S_R0)
+	ldr	lr, [r0, #S_LR]
+	ldm	r0, {r0-r12}
+
+	clrex
+	eret
+ENDPROC(__guest_enter)
+
+ENTRY(__guest_exit)
+	/*
+	 * return convention:
+	 * guest r0, r1, r2 saved on the stack
+	 * r0: vcpu pointer
+	 * r1: exception code
+	 */
+
+	add	r2, r0, #(VCPU_GUEST_CTXT + USR_REGS_OFFSET + S_R3)
+	stm	r2!, {r3-r12}
+	str	lr, [r2, #4]
+	add	r2, r0, #(VCPU_GUEST_CTXT + USR_REGS_OFFSET + S_R0)
+	pop	{r3, r4, r5}		@ r0, r1, r2
+	stm	r2, {r3-r5}
+
+	ldr	r0, [r0, #VCPU_HOST_CTXT]
+	add	r0, r0, #(USR_REGS_OFFSET + S_R4)
+	ldm	r0!, {r4-r12}
+	ldr	lr, [r0, #4]
+
+	mov	r0, r1
+	bx	lr
+ENDPROC(__guest_exit)
+
+	.popsection
+
diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index 278eb1f..b3f6ed2 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -110,4 +110,6 @@ static inline bool __vfp_enabled(void)
 void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt);
 void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
 
+int asmlinkage __guest_enter(struct kvm_vcpu *vcpu,
+			     struct kvm_cpu_context *host);
 #endif /* __ARM_KVM_HYP_H__ */
-- 
2.1.4
