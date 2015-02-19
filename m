From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC/RFT PATCH 1/3] arm64: KVM: handle some sysreg writes in EL2
Date: Thu, 19 Feb 2015 10:54:44 +0000
Message-ID: <1424343286-6792-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1424343286-6792-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: lersek@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, peter.maydell@linaro.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, agraf@suse.de, pbonzini@redhat.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This adds handling to el1_trap() to perform some sysreg writes directly
in EL2, without performing the full world switch to the host and back
again. This is mainly for doing writes that don't need special handling,
but where the register is part of the group that we need to trap for
other reasons.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kvm/hyp.S      | 101 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c |  28 ++++++++-----
 2 files changed, 120 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index c3ca89c27c6b..e3af6840cb3f 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -26,6 +26,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
+#include <asm/sysreg.h>
 
 #define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
 #define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
@@ -887,6 +888,34 @@
 1:
 .endm
 
+/*
+ * Macro to conditionally perform a parametrised system register write. Note
+ * that we currently only support writing x3 to a system register in class
+ * Op0 == 3 and Op1 == 0, which is all we need at the moment.
+ */
+.macro	cond_sysreg_write,op0,op1,crn,crm,op2,sreg,opreg,outlbl
+	.ifnc	\op0,3    ; .err ; .endif
+	.ifnc	\op1,0    ; .err ; .endif
+	.ifnc	\opreg,x3 ; .err ; .endif
+	cmp	\sreg, #((\crm) | ((\crn) << 4) | ((\op2) << 8))
+	bne	9999f
+	// doesn't work: msr_s sys_reg(\op0,\op1,\crn,\crm,\op2), \opreg
+	.inst	0xd5180003|((\crn) << 12)|((\crm) << 8)|((\op2 << 5))
+	b	\outlbl
+9999:
+.endm
+
+/*
+ * Pack CRn, CRm and Op2 into 11 adjacent low bits so we can use a single
+ * cmp instruction to compare it with a 12-bit immediate.
+ */
+.macro	pack_sysreg_idx, outreg, inreg
+	ubfm	\outreg, \inreg, #(17 - 8), #(17 + 2)	// Op2 -> bits 8 - 10
+	bfm	\outreg, \inreg, #(10 - 4), #(10 + 3)	// CRn -> bits 4 - 7
+	bfm	\outreg, \inreg, #(1 - 0), #(1 + 3)	// CRm -> bits 0 - 3
+.endm
+
+
 __save_sysregs:
 	save_sysregs
 	ret
@@ -1178,6 +1207,15 @@ el1_trap:
 	 * x1: ESR
 	 * x2: ESR_EC
 	 */
+
+	/*
+	 * Find out if the exception we are about to pass to the host is a
+	 * write to a system register, which we may prefer to handle in EL2.
+	 */
+	tst	x1, #1				// direction == write (0) ?
+	ccmp	x2, #ESR_EL2_EC_SYS64, #0, eq	// is a sysreg access?
+	b.eq	4f
+
 	cmp	x2, #ESR_EL2_EC_DABT
 	mov	x0, #ESR_EL2_EC_IABT
 	ccmp	x2, x0, #4, ne
@@ -1239,6 +1277,69 @@ el1_trap:
 
 	eret
 
+4:	and	x2, x1, #(3 << 20)		// check for Op0 == 0b11
+	cmp	x2, #(3 << 20)
+	b.ne	1b
+	ands	x2, x1, #(7 << 14)		// check for Op1 == 0b000
+	b.ne	1b
+
+	/*
+	 * If we end up here, we are about to perform a system register write
+	 * with Op0 == 0b11 and Op1 == 0b000. Move the operand to x3 first, we
+	 * will check later if we are actually going to handle this write in EL2
+	 */
+	adr	x0, 5f
+	ubfx	x2, x1, #5, #5		// operand reg# in bits 9 .. 5
+	add	x0, x0, x2, lsl #3
+	br	x0
+5:	ldr	x3, [sp, #16]		// x0 from the stack
+	b	6f
+	ldr	x3, [sp, #24]		// x1 from the stack
+	b	6f
+	ldr	x3, [sp]		// x2 from the stack
+	b	6f
+	ldr	x3, [sp, #8]		// x3 from the stack
+	b	6f
+	.irp	reg,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
+	mov	x3, x\reg
+	b	6f
+	.endr
+	mov	x3, xzr			// x31
+
+	/*
+	 * Ok, so now we have the desired value in x3, let's write it into the
+	 * sysreg if it's a register write we want to handle in EL2. Since these
+	 * are tried in order, it makes sense to put the ones used most often at
+	 * the top.
+	 */
+6:	pack_sysreg_idx		x2, x1
+	cond_sysreg_write	3,0, 2,0,0,x2,x3,7f	// TTBR0_EL1
+	cond_sysreg_write	3,0, 2,0,1,x2,x3,7f	// TTBR1_EL1
+	cond_sysreg_write	3,0, 2,0,2,x2,x3,7f	// TCR_EL1
+	cond_sysreg_write	3,0, 5,2,0,x2,x3,7f	// ESR_EL1
+	cond_sysreg_write	3,0, 6,0,0,x2,x3,7f	// FAR_EL1
+	cond_sysreg_write	3,0, 5,1,0,x2,x3,7f	// AFSR0_EL1
+	cond_sysreg_write	3,0, 5,1,1,x2,x3,7f	// AFSR1_EL1
+	cond_sysreg_write	3,0,10,3,0,x2,x3,7f	// AMAIR_EL1
+	cond_sysreg_write	3,0,13,0,1,x2,x3,7f	// CONTEXTIDR_EL1
+
+	/*
+	 * If we end up here, the write is to a register that we don't handle
+	 * in EL2. Let the host handle it instead ...
+	 */
+	b	1b
+
+	/*
+	 * We have handled the write. Increment the pc and return to the
+	 * guest.
+	 */
+7:	mrs	x0, elr_el2
+	add	x0, x0, #4
+	msr	elr_el2, x0
+	pop	x2, x3
+	pop	x0, x1
+	eret
+
 el1_irq:
 	push	x0, x1
 	push	x2, x3
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f31e8bb2bc5b..1e170eab6603 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -187,6 +187,16 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_handled_at_el2(struct kvm_vcpu *vcpu,
+				  const struct sys_reg_params *params,
+				  const struct sys_reg_desc *r)
+{
+	kvm_debug("sys_reg write at %lx should have been handled in EL2\n",
+		  *vcpu_pc(vcpu));
+	print_sys_reg_instr(params);
+	return false;
+}
+
 static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 amair;
@@ -328,26 +338,26 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  NULL, reset_val, CPACR_EL1, 0 },
 	/* TTBR0_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b000),
-	  access_vm_reg, reset_unknown, TTBR0_EL1 },
+	  access_handled_at_el2, reset_unknown, TTBR0_EL1 },
 	/* TTBR1_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b001),
-	  access_vm_reg, reset_unknown, TTBR1_EL1 },
+	  access_handled_at_el2, reset_unknown, TTBR1_EL1 },
 	/* TCR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0010), CRm(0b0000), Op2(0b010),
-	  access_vm_reg, reset_val, TCR_EL1, 0 },
+	  access_handled_at_el2, reset_val, TCR_EL1, 0 },
 
 	/* AFSR0_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0001), Op2(0b000),
-	  access_vm_reg, reset_unknown, AFSR0_EL1 },
+	  access_handled_at_el2, reset_unknown, AFSR0_EL1 },
 	/* AFSR1_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0001), Op2(0b001),
-	  access_vm_reg, reset_unknown, AFSR1_EL1 },
+	  access_handled_at_el2, reset_unknown, AFSR1_EL1 },
 	/* ESR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0101), CRm(0b0010), Op2(0b000),
-	  access_vm_reg, reset_unknown, ESR_EL1 },
+	  access_handled_at_el2, reset_unknown, ESR_EL1 },
 	/* FAR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0110), CRm(0b0000), Op2(0b000),
-	  access_vm_reg, reset_unknown, FAR_EL1 },
+	  access_handled_at_el2, reset_unknown, FAR_EL1 },
 	/* PAR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0111), CRm(0b0100), Op2(0b000),
 	  NULL, reset_unknown, PAR_EL1 },
@@ -364,7 +374,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_vm_reg, reset_unknown, MAIR_EL1 },
 	/* AMAIR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0011), Op2(0b000),
-	  access_vm_reg, reset_amair_el1, AMAIR_EL1 },
+	  access_handled_at_el2, reset_amair_el1, AMAIR_EL1 },
 
 	/* VBAR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1100), CRm(0b0000), Op2(0b000),
@@ -376,7 +386,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	/* CONTEXTIDR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1101), CRm(0b0000), Op2(0b001),
-	  access_vm_reg, reset_val, CONTEXTIDR_EL1, 0 },
+	  access_handled_at_el2, reset_val, CONTEXTIDR_EL1, 0 },
 	/* TPIDR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b1101), CRm(0b0000), Op2(0b100),
 	  NULL, reset_unknown, TPIDR_EL1 },
-- 
1.8.3.2

