From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 3/7] arm: KVM: Use common AArch32 conditional execution code
Date: Tue,  6 Sep 2016 09:28:43 +0100
Message-ID: <1473150527-4729-4-git-send-email-marc.zyngier@arm.com>
References: <1473150527-4729-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F24E49B53
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9E7s+aChvEJd for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 04:20:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 52F7449B51
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 04:20:37 -0400 (EDT)
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

Add the bit of glue and const-ification that is required to use
the code inherited from the arm64 port, and move over to it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_emulate.h | 34 ++++++++++---
 arch/arm/kvm/Makefile              |  1 +
 arch/arm/kvm/emulate.c             | 97 --------------------------------------
 virt/kvm/arm/aarch32.c             |  5 ++
 4 files changed, 33 insertions(+), 104 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index ee5328f..448d63c 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -40,18 +40,28 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 	*vcpu_reg(vcpu, reg_num) = val;
 }
 
-bool kvm_condition_valid(struct kvm_vcpu *vcpu);
-void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_instr);
+bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
+void kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr);
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
 void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
 void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
+static inline bool kvm_condition_valid(const struct kvm_vcpu *vcpu)
+{
+	return kvm_condition_valid32(vcpu);
+}
+
+static inline void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_instr)
+{
+	kvm_skip_instr32(vcpu, is_wide_instr);
+}
+
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr = HCR_GUEST_MASK;
 }
 
-static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
+static inline unsigned long vcpu_get_hcr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.hcr;
 }
@@ -61,7 +71,7 @@ static inline void vcpu_set_hcr(struct kvm_vcpu *vcpu, unsigned long hcr)
 	vcpu->arch.hcr = hcr;
 }
 
-static inline bool vcpu_mode_is_32bit(struct kvm_vcpu *vcpu)
+static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 {
 	return 1;
 }
@@ -71,9 +81,9 @@ static inline unsigned long *vcpu_pc(struct kvm_vcpu *vcpu)
 	return &vcpu->arch.ctxt.gp_regs.usr_regs.ARM_pc;
 }
 
-static inline unsigned long *vcpu_cpsr(struct kvm_vcpu *vcpu)
+static inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
-	return &vcpu->arch.ctxt.gp_regs.usr_regs.ARM_cpsr;
+	return (unsigned long *)&vcpu->arch.ctxt.gp_regs.usr_regs.ARM_cpsr;
 }
 
 static inline void vcpu_set_thumb(struct kvm_vcpu *vcpu)
@@ -93,11 +103,21 @@ static inline bool vcpu_mode_priv(struct kvm_vcpu *vcpu)
 	return cpsr_mode > USR_MODE;;
 }
 
-static inline u32 kvm_vcpu_get_hsr(struct kvm_vcpu *vcpu)
+static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.hsr;
 }
 
+static inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
+{
+	u32 hsr = kvm_vcpu_get_hsr(vcpu);
+
+	if (hsr & HSR_CV)
+		return (hsr & HSR_COND) >> HSR_COND_SHIFT;
+
+	return -1;
+}
+
 static inline unsigned long kvm_vcpu_get_hfar(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.hxfar;
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 10d77a6..339ec88 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp/
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
 obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
+obj-y += $(KVM)/arm/aarch32.o
 
 obj-y += $(KVM)/arm/vgic/vgic.o
 obj-y += $(KVM)/arm/vgic/vgic-init.o
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index eda9ddd..ff9acd1 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -161,103 +161,6 @@ unsigned long *vcpu_spsr(struct kvm_vcpu *vcpu)
 	}
 }
 
-/*
- * A conditional instruction is allowed to trap, even though it
- * wouldn't be executed.  So let's re-implement the hardware, in
- * software!
- */
-bool kvm_condition_valid(struct kvm_vcpu *vcpu)
-{
-	unsigned long cpsr, cond, insn;
-
-	/*
-	 * Exception Code 0 can only happen if we set HCR.TGE to 1, to
-	 * catch undefined instructions, and then we won't get past
-	 * the arm_exit_handlers test anyway.
-	 */
-	BUG_ON(!kvm_vcpu_trap_get_class(vcpu));
-
-	/* Top two bits non-zero?  Unconditional. */
-	if (kvm_vcpu_get_hsr(vcpu) >> 30)
-		return true;
-
-	cpsr = *vcpu_cpsr(vcpu);
-
-	/* Is condition field valid? */
-	if ((kvm_vcpu_get_hsr(vcpu) & HSR_CV) >> HSR_CV_SHIFT)
-		cond = (kvm_vcpu_get_hsr(vcpu) & HSR_COND) >> HSR_COND_SHIFT;
-	else {
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
-	/* Shift makes it look like an ARM-mode instruction */
-	insn = cond << 28;
-	return arm_check_condition(insn, cpsr) != ARM_OPCODE_CONDTEST_FAIL;
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
-	bool is_arm = !(cpsr & PSR_T_BIT);
-
-	if (is_arm || !(cpsr & PSR_IT_MASK))
-		return;
-
-	cond = (cpsr & 0xe000) >> 13;
-	itbits = (cpsr & 0x1c00) >> (10 - 2);
-	itbits |= (cpsr & (0x3 << 25)) >> 25;
-
-	/* Perform ITAdvance (see page A-52 in ARM DDI 0406C) */
-	if ((itbits & 0x7) == 0)
-		itbits = cond = 0;
-	else
-		itbits = (itbits << 1) & 0x1f;
-
-	cpsr &= ~PSR_IT_MASK;
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
-void kvm_skip_instr(struct kvm_vcpu *vcpu, bool is_wide_instr)
-{
-	bool is_thumb;
-
-	is_thumb = !!(*vcpu_cpsr(vcpu) & PSR_T_BIT);
-	if (is_thumb && !is_wide_instr)
-		*vcpu_pc(vcpu) += 2;
-	else
-		*vcpu_pc(vcpu) += 4;
-	kvm_adjust_itstate(vcpu);
-}
-
-
 /******************************************************************************
  * Inject exceptions into the guest
  */
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index cb02e56..ba4417b 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -24,6 +24,11 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 
+#ifndef CONFIG_ARM64
+#define COMPAT_PSR_T_BIT	PSR_T_BIT
+#define COMPAT_PSR_IT_MASK	PSR_IT_MASK
+#endif
+
 /*
  * stolen from arch/arm/kernel/opcodes.c
  *
-- 
2.1.4
