From: Tushar Jagad <tushar.jagad@linaro.org>
Subject: [PATCH RFC 1/4] arm64: KVM: add MIDR_EL1 switching
Date: Wed,  9 Sep 2015 14:08:31 +0530
Message-ID: <1441787914-3191-2-git-send-email-tushar.jagad@linaro.org>
References: <1441787914-3191-1-git-send-email-tushar.jagad@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1441787914-3191-1-git-send-email-tushar.jagad@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: peter.maydell@linaro.org, marc.zyngier@arm.com, patches@apm.com, qemu-devel@nongnu.org, tushar.jagad@linaro.org, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Move MIDR_EL1 to be a world-switched register, instead of being
unchanged from the host.

The behaviour is preserved by using the host's MIDR_EL1 as a
reset value for the guest's register.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h |   16 +++++++++-------
 arch/arm64/kvm/hyp.S             |    4 ++++
 arch/arm64/kvm/sys_regs.c        |   18 +++++++++++++-----
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 3c5fe68..c1d5bde 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -55,17 +55,19 @@
 #define DBGWVR0_EL1	71	/* Debug Watchpoint Value Registers (0-15) */
 #define DBGWVR15_EL1	86
 #define MDCCINT_EL1	87	/* Monitor Debug Comms Channel Interrupt Enable Reg */
+#define MIDR_EL1	88	/* Main ID Register */
 
 /* 32bit specific registers. Keep them at the end of the range */
-#define	DACR32_EL2	88	/* Domain Access Control Register */
-#define	IFSR32_EL2	89	/* Instruction Fault Status Register */
-#define	FPEXC32_EL2	90	/* Floating-Point Exception Control Register */
-#define	DBGVCR32_EL2	91	/* Debug Vector Catch Register */
-#define	TEECR32_EL1	92	/* ThumbEE Configuration Register */
-#define	TEEHBR32_EL1	93	/* ThumbEE Handler Base Register */
-#define	NR_SYS_REGS	94
+#define	DACR32_EL2	89	/* Domain Access Control Register */
+#define	IFSR32_EL2	90	/* Instruction Fault Status Register */
+#define	FPEXC32_EL2	91	/* Floating-Point Exception Control Register */
+#define	DBGVCR32_EL2	92	/* Debug Vector Catch Register */
+#define	TEECR32_EL1	93	/* ThumbEE Configuration Register */
+#define	TEEHBR32_EL1	94	/* ThumbEE Handler Base Register */
+#define	NR_SYS_REGS	95
 
 /* 32bit mapping */
+#define c0_MIDR		(MIDR_EL1 * 2)	/* Main ID Register */
 #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
 #define c0_CSSELR	(CSSELR_EL1 * 2)/* Cache Size Selection Register */
 #define c1_SCTLR	(SCTLR_EL1 * 2)	/* System Control Register */
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 17a8fb1..6013347 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -216,6 +216,7 @@
 	mrs	x23, 	cntkctl_el1
 	mrs	x24,	par_el1
 	mrs	x25,	mdscr_el1
+	mrs	x26,	vpidr_el2
 
 	stp	x4, x5, [x3]
 	stp	x6, x7, [x3, #16]
@@ -228,6 +229,7 @@
 	stp	x20, x21, [x3, #128]
 	stp	x22, x23, [x3, #144]
 	stp	x24, x25, [x3, #160]
+	str	x26, [x3, #696]
 .endm
 
 .macro save_debug
@@ -442,6 +444,7 @@
 	ldp	x20, x21, [x3, #128]
 	ldp	x22, x23, [x3, #144]
 	ldp	x24, x25, [x3, #160]
+	ldr	x26, [x3, #696]
 
 	msr	vmpidr_el2,	x4
 	msr	csselr_el1,	x5
@@ -465,6 +468,7 @@
 	msr	cntkctl_el1,	x23
 	msr	par_el1,	x24
 	msr	mdscr_el1,	x25
+	msr	vpidr_el2,	x26
 .endm
 
 .macro restore_debug
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c370b40..7047292 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -170,17 +170,25 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 	}
 }
 
+static void reset_midr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+	/*
+	 * We only export the host's MPIDR_EL1 for now.
+	 */
+	vcpu_sys_reg(vcpu, MIDR_EL1) = read_cpuid_id();
+}
+
 /*
  * We want to avoid world-switching all the DBG registers all the
  * time:
- * 
+ *
  * - If we've touched any debug register, it is likely that we're
  *   going to touch more of them. It then makes sense to disable the
  *   traps and start doing the save/restore dance
  * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
  *   then mandatory to save/restore the registers, as the guest
  *   depends on them.
- * 
+ *
  * For this, we use a DIRTY bit, indicating the guest has modified the
  * debug registers, used as follow:
  *
@@ -350,6 +358,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ Op0(0b10), Op1(0b100), CRn(0b0000), CRm(0b0111), Op2(0b000),
 	  NULL, reset_val, DBGVCR32_EL2, 0 },
 
+	/* MIDR_EL1 */
+	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
+	  NULL, reset_midr, MIDR_EL1 },
 	/* MPIDR_EL1 */
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b101),
 	  NULL, reset_mpidr, MPIDR_EL1 },
@@ -1091,7 +1102,6 @@ static const struct sys_reg_desc *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
 		((struct sys_reg_desc *)r)->val = val;			\
 	}
 
-FUNCTION_INVARIANT(midr_el1)
 FUNCTION_INVARIANT(ctr_el0)
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(id_pfr0_el1)
@@ -1113,8 +1123,6 @@ FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] = {
-	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b000),
-	  NULL, get_midr_el1 },
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0000), Op2(0b110),
 	  NULL, get_revidr_el1 },
 	{ Op0(0b11), Op1(0b000), CRn(0b0000), CRm(0b0001), Op2(0b000),
-- 
1.7.9.5
