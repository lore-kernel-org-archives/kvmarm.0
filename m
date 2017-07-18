From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 16/38] KVM: arm64: Support to inject exceptions to the
 virtual EL2
Date: Tue, 18 Jul 2017 11:58:42 -0500
Message-ID: <1500397144-16232-17-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D0DF49C5D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nPdg5doJ-lDi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:14 -0400 (EDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com
 [209.85.223.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4D31F49C20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:14 -0400 (EDT)
Received: by mail-io0-f173.google.com with SMTP id z62so17070375ioi.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:03 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

Support inject synchronous exceptions to the virtual EL2 as
described in ARM ARM AArch64.TakeException().

This can be easily extended to support to inject asynchronous exceptions
to the virtual EL2, but it will be added in a later patch when appropriate.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm/include/asm/kvm_emulate.h   |  7 +++
 arch/arm64/include/asm/kvm_emulate.h |  2 +
 arch/arm64/kvm/Makefile              |  1 +
 arch/arm64/kvm/emulate-nested.c      | 83 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/trace.h               | 20 +++++++++
 5 files changed, 113 insertions(+)
 create mode 100644 arch/arm64/kvm/emulate-nested.c

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 0a03b7d..29a4dec 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -47,6 +47,13 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+static inline int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2)
+{
+	kvm_err("Unexpected call to %s for the non-nesting configuration\n",
+		 __func__);
+	return -EINVAL;
+}
+
 static inline void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu) { };
 static inline void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu) { };
 static inline void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt) { };
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 94f98cc..3017234 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -54,6 +54,8 @@ enum exception_type {
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
+
 void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu);
 void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu);
 void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt);
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 5762337..0263ef0 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -37,3 +37,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += nested.o
+kvm-$(CONFIG_KVM_ARM_HOST) += emulate-nested.o
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
new file mode 100644
index 0000000..48b84cc
--- /dev/null
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2016 - Linaro and Columbia University
+ * Author: Jintack Lim <jintack.lim@linaro.org>
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
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+
+#include "trace.h"
+
+/* This is borrowed from get_except_vector in inject_fault.c */
+static u64 get_el2_except_vector(struct kvm_vcpu *vcpu,
+		enum exception_type type)
+{
+	u64 exc_offset;
+
+	switch (*vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT)) {
+	case PSR_MODE_EL2t:
+		exc_offset = CURRENT_EL_SP_EL0_VECTOR;
+		break;
+	case PSR_MODE_EL2h:
+		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
+		break;
+	case PSR_MODE_EL1t:
+	case PSR_MODE_EL1h:
+	case PSR_MODE_EL0t:
+		exc_offset = LOWER_EL_AArch64_VECTOR;
+		break;
+	default:
+		kvm_err("Unexpected previous exception level: aarch32\n");
+		exc_offset = LOWER_EL_AArch32_VECTOR;
+	}
+
+	return vcpu_sys_reg(vcpu, VBAR_EL2) + exc_offset + type;
+}
+
+/*
+ * Emulate taking an exception to EL2.
+ * See ARM ARM J8.1.2 AArch64.TakeException()
+ */
+static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
+			     enum exception_type type)
+{
+	int ret = 1;
+
+	if (!nested_virt_in_use(vcpu)) {
+		kvm_err("Unexpected call to %s for the non-nesting configuration\n",
+				__func__);
+		return -EINVAL;
+	}
+
+	vcpu_el2_sreg(vcpu, SPSR_EL2) = *vcpu_cpsr(vcpu);
+	vcpu_el2_sreg(vcpu, ELR_EL2) = *vcpu_pc(vcpu);
+	vcpu_sys_reg(vcpu, ESR_EL2) = esr_el2;
+
+	*vcpu_pc(vcpu) = get_el2_except_vector(vcpu, type);
+	/* On an exception, PSTATE.SP becomes 1 */
+	*vcpu_cpsr(vcpu) = PSR_MODE_EL2h;
+	*vcpu_cpsr(vcpu) |=  (PSR_A_BIT | PSR_F_BIT | PSR_I_BIT | PSR_D_BIT);
+
+	trace_kvm_inject_nested_exception(vcpu, esr_el2, *vcpu_pc(vcpu));
+
+	return ret;
+}
+
+int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2)
+{
+	return kvm_inject_nested(vcpu, esr_el2, except_type_sync);
+}
diff --git a/arch/arm64/kvm/trace.h b/arch/arm64/kvm/trace.h
index 7fb0008..7c86cfb 100644
--- a/arch/arm64/kvm/trace.h
+++ b/arch/arm64/kvm/trace.h
@@ -167,6 +167,26 @@
 );
 
 
+TRACE_EVENT(kvm_inject_nested_exception,
+	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long esr_el2,
+		 unsigned long pc),
+	TP_ARGS(vcpu, esr_el2, pc),
+
+	TP_STRUCT__entry(
+		__field(struct kvm_vcpu *,	vcpu)
+		__field(unsigned long,		esr_el2)
+		__field(unsigned long,		pc)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu = vcpu;
+		__entry->esr_el2 = esr_el2;
+		__entry->pc = pc;
+	),
+
+	TP_printk("vcpu: %p, inject exception to vEL2: ESR_EL2 0x%lx, vector: 0x%016lx",
+		  __entry->vcpu, __entry->esr_el2, __entry->pc)
+);
 #endif /* _TRACE_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
