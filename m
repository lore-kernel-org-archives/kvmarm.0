From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 7/8] arm64: KVM: Remove all traces of the ThumbEE registers
Date: Thu, 17 Sep 2015 15:46:10 +0100
Message-ID: <1442501171-24484-8-git-send-email-marc.zyngier@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Marek Majtyka <marek.majtyka@tieto.com>, Pavel Fedin <p.fedin@samsung.com>, Ming Lei <ming.lei@canonical.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Will Deacon <will.deacon@arm.com>

Although the ThumbEE registers and traps were present in earlier
versions of the v8 architecture, it was retrospectively removed and so
we can do the same.

Whilst this breaks migrating a guest started on a previous version of
the kernel, it is much better to kill these (non existent) registers
as soon as possible.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[maz: added commend about migration]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |  1 -
 arch/arm64/include/asm/kvm_asm.h |  4 +---
 arch/arm64/kvm/hyp.S             | 22 ++++------------------
 arch/arm64/kvm/sys_regs.c        |  7 -------
 4 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index cbc5e1a..9694f26 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -172,7 +172,6 @@
 #define VTTBR_VMID_MASK	  (UL(0xFF) << VTTBR_VMID_SHIFT)
 
 /* Hyp System Trap Register */
-#define HSTR_EL2_TTEE	(1 << 16)
 #define HSTR_EL2_T(x)	(1 << x)
 
 /* Hyp Coproccessor Trap Register Shifts */
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 67fa0de..5e37710 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -53,9 +53,7 @@
 #define	IFSR32_EL2	25	/* Instruction Fault Status Register */
 #define	FPEXC32_EL2	26	/* Floating-Point Exception Control Register */
 #define	DBGVCR32_EL2	27	/* Debug Vector Catch Register */
-#define	TEECR32_EL1	28	/* ThumbEE Configuration Register */
-#define	TEEHBR32_EL1	29	/* ThumbEE Handler Base Register */
-#define	NR_SYS_REGS	30
+#define	NR_SYS_REGS	28
 
 /* 32bit mapping */
 #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 60a83e2..8563477 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -433,20 +433,13 @@
 	mrs	x5, ifsr32_el2
 	stp	x4, x5, [x3]
 
-	skip_fpsimd_state x8, 3f
+	skip_fpsimd_state x8, 2f
 	mrs	x6, fpexc32_el2
 	str	x6, [x3, #16]
-3:
-	skip_debug_state x8, 2f
+2:
+	skip_debug_state x8, 1f
 	mrs	x7, dbgvcr32_el2
 	str	x7, [x3, #24]
-2:
-	skip_tee_state x8, 1f
-
-	add	x3, x2, #CPU_SYSREG_OFFSET(TEECR32_EL1)
-	mrs	x4, teecr32_el1
-	mrs	x5, teehbr32_el1
-	stp	x4, x5, [x3]
 1:
 .endm
 
@@ -466,16 +459,9 @@
 	msr	dacr32_el2, x4
 	msr	ifsr32_el2, x5
 
-	skip_debug_state x8, 2f
+	skip_debug_state x8, 1f
 	ldr	x7, [x3, #24]
 	msr	dbgvcr32_el2, x7
-2:
-	skip_tee_state x8, 1f
-
-	add	x3, x2, #CPU_SYSREG_OFFSET(TEECR32_EL1)
-	ldp	x4, x5, [x3]
-	msr	teecr32_el1, x4
-	msr	teehbr32_el1, x5
 1:
 .endm
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d0463e..d03d3af 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -539,13 +539,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b10), Op1(0b000), CRn(0b0111), CRm(0b1110), Op2(0b110),
 	  trap_dbgauthstatus_el1 },
 
-	/* TEECR32_EL1 */
-	{ Op0(0b10), Op1(0b010), CRn(0b0000), CRm(0b0000), Op2(0b000),
-	  NULL, reset_val, TEECR32_EL1, 0 },
-	/* TEEHBR32_EL1 */
-	{ Op0(0b10), Op1(0b010), CRn(0b0001), CRm(0b0000), Op2(0b000),
-	  NULL, reset_val, TEEHBR32_EL1, 0 },
-
 	/* MDCCSR_EL1 */
 	{ Op0(0b10), Op1(0b011), CRn(0b0000), CRm(0b0001), Op2(0b000),
 	  trap_raz_wi },
-- 
2.1.4

