From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/95] ARM: KVM: Move GP registers into the CPU context
 structure
Date: Wed,  9 Mar 2016 07:30:00 +0000
Message-ID: <1457508689-19672-7-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD803412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yQjMPZmos-Ki for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:02 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AFA84998D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:02 -0500 (EST)
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

Continuing our rework of the CPU context, we now move the GP
registers into the CPU context structure.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h |  8 ++++----
 arch/arm/include/asm/kvm_host.h    |  3 +--
 arch/arm/kernel/asm-offsets.c      | 18 +++++++++---------
 arch/arm/kvm/emulate.c             | 12 ++++++------
 arch/arm/kvm/guest.c               |  4 ++--
 arch/arm/kvm/interrupts_head.S     | 11 +++++++++++
 arch/arm/kvm/reset.c               |  2 +-
 7 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 32bb52a..f710616 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -68,12 +68,12 @@ static inline bool vcpu_mode_is_32bit(struct kvm_vcpu *vcpu)
 
 static inline unsigned long *vcpu_pc(struct kvm_vcpu *vcpu)
 {
-	return &vcpu->arch.regs.usr_regs.ARM_pc;
+	return &vcpu->arch.ctxt.gp_regs.usr_regs.ARM_pc;
 }
 
 static inline unsigned long *vcpu_cpsr(struct kvm_vcpu *vcpu)
 {
-	return &vcpu->arch.regs.usr_regs.ARM_cpsr;
+	return &vcpu->arch.ctxt.gp_regs.usr_regs.ARM_cpsr;
 }
 
 static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
@@ -83,13 +83,13 @@ static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
 
 static inline bool mode_has_spsr(struct kvm_vcpu *vcpu)
 {
-	unsigned long cpsr_mode = vcpu->arch.regs.usr_regs.ARM_cpsr & MODE_MASK;
+	unsigned long cpsr_mode = vcpu->arch.ctxt.gp_regs.usr_regs.ARM_cpsr & MODE_MASK;
 	return (cpsr_mode > USR_MODE && cpsr_mode < SYSTEM_MODE);
 }
 
 static inline bool vcpu_mode_priv(struct kvm_vcpu *vcpu)
 {
-	unsigned long cpsr_mode = vcpu->arch.regs.usr_regs.ARM_cpsr & MODE_MASK;
+	unsigned long cpsr_mode = vcpu->arch.ctxt.gp_regs.usr_regs.ARM_cpsr & MODE_MASK;
 	return cpsr_mode > USR_MODE;;
 }
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 4203701..02932ba 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -89,6 +89,7 @@ struct kvm_vcpu_fault_info {
 };
 
 struct kvm_cpu_context {
+	struct kvm_regs	gp_regs;
 	struct vfp_hard_struct vfp;
 	u32 cp15[NR_CP15_REGS];
 };
@@ -98,8 +99,6 @@ typedef struct kvm_cpu_context kvm_cpu_context_t;
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	struct kvm_regs regs;
-
 	int target; /* Processor target */
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index 43f8b01..2f3e0b0 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -176,15 +176,15 @@ int main(void)
   DEFINE(VCPU_HOST_CTXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
   DEFINE(CPU_CTXT_VFP,		offsetof(struct kvm_cpu_context, vfp));
   DEFINE(CPU_CTXT_CP15,		offsetof(struct kvm_cpu_context, cp15));
-  DEFINE(VCPU_REGS,		offsetof(struct kvm_vcpu, arch.regs));
-  DEFINE(VCPU_USR_REGS,		offsetof(struct kvm_vcpu, arch.regs.usr_regs));
-  DEFINE(VCPU_SVC_REGS,		offsetof(struct kvm_vcpu, arch.regs.svc_regs));
-  DEFINE(VCPU_ABT_REGS,		offsetof(struct kvm_vcpu, arch.regs.abt_regs));
-  DEFINE(VCPU_UND_REGS,		offsetof(struct kvm_vcpu, arch.regs.und_regs));
-  DEFINE(VCPU_IRQ_REGS,		offsetof(struct kvm_vcpu, arch.regs.irq_regs));
-  DEFINE(VCPU_FIQ_REGS,		offsetof(struct kvm_vcpu, arch.regs.fiq_regs));
-  DEFINE(VCPU_PC,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_pc));
-  DEFINE(VCPU_CPSR,		offsetof(struct kvm_vcpu, arch.regs.usr_regs.ARM_cpsr));
+  DEFINE(CPU_CTXT_GP_REGS,	offsetof(struct kvm_cpu_context, gp_regs));
+  DEFINE(GP_REGS_USR,		offsetof(struct kvm_regs, usr_regs));
+  DEFINE(GP_REGS_SVC,		offsetof(struct kvm_regs, svc_regs));
+  DEFINE(GP_REGS_ABT,		offsetof(struct kvm_regs, abt_regs));
+  DEFINE(GP_REGS_UND,		offsetof(struct kvm_regs, und_regs));
+  DEFINE(GP_REGS_IRQ,		offsetof(struct kvm_regs, irq_regs));
+  DEFINE(GP_REGS_FIQ,		offsetof(struct kvm_regs, fiq_regs));
+  DEFINE(GP_REGS_PC,		offsetof(struct kvm_regs, usr_regs.ARM_pc));
+  DEFINE(GP_REGS_CPSR,		offsetof(struct kvm_regs, usr_regs.ARM_cpsr));
   DEFINE(VCPU_HCR,		offsetof(struct kvm_vcpu, arch.hcr));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
   DEFINE(VCPU_HSR,		offsetof(struct kvm_vcpu, arch.fault.hsr));
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index ee161b1..a494def 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -112,7 +112,7 @@ static const unsigned long vcpu_reg_offsets[VCPU_NR_MODES][15] = {
  */
 unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num)
 {
-	unsigned long *reg_array = (unsigned long *)&vcpu->arch.regs;
+	unsigned long *reg_array = (unsigned long *)&vcpu->arch.ctxt.gp_regs;
 	unsigned long mode = *vcpu_cpsr(vcpu) & MODE_MASK;
 
 	switch (mode) {
@@ -147,15 +147,15 @@ unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu)
 	unsigned long mode = *vcpu_cpsr(vcpu) & MODE_MASK;
 	switch (mode) {
 	case SVC_MODE:
-		return &vcpu->arch.regs.KVM_ARM_SVC_spsr;
+		return &vcpu->arch.ctxt.gp_regs.KVM_ARM_SVC_spsr;
 	case ABT_MODE:
-		return &vcpu->arch.regs.KVM_ARM_ABT_spsr;
+		return &vcpu->arch.ctxt.gp_regs.KVM_ARM_ABT_spsr;
 	case UND_MODE:
-		return &vcpu->arch.regs.KVM_ARM_UND_spsr;
+		return &vcpu->arch.ctxt.gp_regs.KVM_ARM_UND_spsr;
 	case IRQ_MODE:
-		return &vcpu->arch.regs.KVM_ARM_IRQ_spsr;
+		return &vcpu->arch.ctxt.gp_regs.KVM_ARM_IRQ_spsr;
 	case FIQ_MODE:
-		return &vcpu->arch.regs.KVM_ARM_FIQ_spsr;
+		return &vcpu->arch.ctxt.gp_regs.KVM_ARM_FIQ_spsr;
 	default:
 		BUG();
 	}
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 5fa69d7..86e26fb 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -55,7 +55,7 @@ static u64 core_reg_offset_from_id(u64 id)
 static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	u32 __user *uaddr = (u32 __user *)(long)reg->addr;
-	struct kvm_regs *regs = &vcpu->arch.regs;
+	struct kvm_regs *regs = &vcpu->arch.ctxt.gp_regs;
 	u64 off;
 
 	if (KVM_REG_SIZE(reg->id) != 4)
@@ -72,7 +72,7 @@ static int get_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	u32 __user *uaddr = (u32 __user *)(long)reg->addr;
-	struct kvm_regs *regs = &vcpu->arch.regs;
+	struct kvm_regs *regs = &vcpu->arch.ctxt.gp_regs;
 	u64 off, val;
 
 	if (KVM_REG_SIZE(reg->id) != 4)
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index b9d9531..e0943cb 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -1,6 +1,17 @@
 #include <linux/irqchip/arm-gic.h>
 #include <asm/assembler.h>
 
+/* Compat macro, until we get rid of this file entierely */
+#define VCPU_GP_REGS		(VCPU_GUEST_CTXT + CPU_CTXT_GP_REGS)
+#define VCPU_USR_REGS		(VCPU_GP_REGS + GP_REGS_USR)
+#define VCPU_SVC_REGS		(VCPU_GP_REGS + GP_REGS_SVC)
+#define VCPU_ABT_REGS		(VCPU_GP_REGS + GP_REGS_ABT)
+#define VCPU_UND_REGS		(VCPU_GP_REGS + GP_REGS_UND)
+#define VCPU_IRQ_REGS		(VCPU_GP_REGS + GP_REGS_IRQ)
+#define VCPU_FIQ_REGS		(VCPU_GP_REGS + GP_REGS_FIQ)
+#define VCPU_PC			(VCPU_GP_REGS + GP_REGS_PC)
+#define VCPU_CPSR		(VCPU_GP_REGS + GP_REGS_CPSR)
+
 #define VCPU_USR_REG(_reg_nr)	(VCPU_USR_REGS + (_reg_nr * 4))
 #define VCPU_USR_SP		(VCPU_USR_REG(13))
 #define VCPU_USR_LR		(VCPU_USR_REG(14))
diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
index eeb8585..0048b5a 100644
--- a/arch/arm/kvm/reset.c
+++ b/arch/arm/kvm/reset.c
@@ -71,7 +71,7 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	}
 
 	/* Reset core registers */
-	memcpy(&vcpu->arch.regs, reset_regs, sizeof(vcpu->arch.regs));
+	memcpy(&vcpu->arch.ctxt.gp_regs, reset_regs, sizeof(vcpu->arch.ctxt.gp_regs));
 
 	/* Reset CP15 registers */
 	kvm_reset_coprocs(vcpu);
-- 
2.1.4
