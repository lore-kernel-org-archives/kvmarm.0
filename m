From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 25/95] ARM: KVM: Turn CP15 defines to an enum
Date: Wed,  9 Mar 2016 07:30:19 +0000
Message-ID: <1457508689-19672-26-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBFAA412D0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ycZSf7SuDYap for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:32:56 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B342149B46
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:32:55 -0500 (EST)
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

Just like on arm64, having the CP15 registers expressed as a set
of #defines has been very conflict-prone. Let's turn it into an
enum, which should make it more manageable.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_asm.h  | 33 ---------------------------------
 arch/arm/include/asm/kvm_host.h | 39 +++++++++++++++++++++++++++++++++++++++
 arch/arm/kvm/guest.c            |  1 -
 3 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 3283a2f..083825f 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -21,39 +21,6 @@
 
 #include <asm/virt.h>
 
-/* 0 is reserved as an invalid value. */
-#define c0_MPIDR	1	/* MultiProcessor ID Register */
-#define c0_CSSELR	2	/* Cache Size Selection Register */
-#define c1_SCTLR	3	/* System Control Register */
-#define c1_ACTLR	4	/* Auxiliary Control Register */
-#define c1_CPACR	5	/* Coprocessor Access Control */
-#define c2_TTBR0	6	/* Translation Table Base Register 0 */
-#define c2_TTBR0_high	7	/* TTBR0 top 32 bits */
-#define c2_TTBR1	8	/* Translation Table Base Register 1 */
-#define c2_TTBR1_high	9	/* TTBR1 top 32 bits */
-#define c2_TTBCR	10	/* Translation Table Base Control R. */
-#define c3_DACR		11	/* Domain Access Control Register */
-#define c5_DFSR		12	/* Data Fault Status Register */
-#define c5_IFSR		13	/* Instruction Fault Status Register */
-#define c5_ADFSR	14	/* Auxilary Data Fault Status R */
-#define c5_AIFSR	15	/* Auxilary Instrunction Fault Status R */
-#define c6_DFAR		16	/* Data Fault Address Register */
-#define c6_IFAR		17	/* Instruction Fault Address Register */
-#define c7_PAR		18	/* Physical Address Register */
-#define c7_PAR_high	19	/* PAR top 32 bits */
-#define c9_L2CTLR	20	/* Cortex A15/A7 L2 Control Register */
-#define c10_PRRR	21	/* Primary Region Remap Register */
-#define c10_NMRR	22	/* Normal Memory Remap Register */
-#define c12_VBAR	23	/* Vector Base Address Register */
-#define c13_CID		24	/* Context ID Register */
-#define c13_TID_URW	25	/* Thread ID, User R/W */
-#define c13_TID_URO	26	/* Thread ID, User R/O */
-#define c13_TID_PRIV	27	/* Thread ID, Privileged */
-#define c14_CNTKCTL	28	/* Timer Control Register (PL1) */
-#define c10_AMAIR0	29	/* Auxilary Memory Attribute Indirection Reg0 */
-#define c10_AMAIR1	30	/* Auxilary Memory Attribute Indirection Reg1 */
-#define NR_CP15_REGS	31	/* Number of regs (incl. invalid) */
-
 #define ARM_EXCEPTION_RESET	  0
 #define ARM_EXCEPTION_UNDEFINED   1
 #define ARM_EXCEPTION_SOFTWARE    2
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 0fe41aa..daf6a71 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -88,6 +88,45 @@ struct kvm_vcpu_fault_info {
 	u32 hyp_pc;		/* PC when exception was taken from Hyp mode */
 };
 
+/*
+ * 0 is reserved as an invalid value.
+ * Order should be kept in sync with the save/restore code.
+ */
+enum vcpu_sysreg {
+	__INVALID_SYSREG__,
+	c0_MPIDR,		/* MultiProcessor ID Register */
+	c0_CSSELR,		/* Cache Size Selection Register */
+	c1_SCTLR,		/* System Control Register */
+	c1_ACTLR,		/* Auxiliary Control Register */
+	c1_CPACR,		/* Coprocessor Access Control */
+	c2_TTBR0,		/* Translation Table Base Register 0 */
+	c2_TTBR0_high,		/* TTBR0 top 32 bits */
+	c2_TTBR1,		/* Translation Table Base Register 1 */
+	c2_TTBR1_high,		/* TTBR1 top 32 bits */
+	c2_TTBCR,		/* Translation Table Base Control R. */
+	c3_DACR,		/* Domain Access Control Register */
+	c5_DFSR,		/* Data Fault Status Register */
+	c5_IFSR,		/* Instruction Fault Status Register */
+	c5_ADFSR,		/* Auxilary Data Fault Status R */
+	c5_AIFSR,		/* Auxilary Instrunction Fault Status R */
+	c6_DFAR,		/* Data Fault Address Register */
+	c6_IFAR,		/* Instruction Fault Address Register */
+	c7_PAR,			/* Physical Address Register */
+	c7_PAR_high,		/* PAR top 32 bits */
+	c9_L2CTLR,		/* Cortex A15/A7 L2 Control Register */
+	c10_PRRR,		/* Primary Region Remap Register */
+	c10_NMRR,		/* Normal Memory Remap Register */
+	c12_VBAR,		/* Vector Base Address Register */
+	c13_CID,		/* Context ID Register */
+	c13_TID_URW,		/* Thread ID, User R/W */
+	c13_TID_URO,		/* Thread ID, User R/O */
+	c13_TID_PRIV,		/* Thread ID, Privileged */
+	c14_CNTKCTL,		/* Timer Control Register (PL1) */
+	c10_AMAIR0,		/* Auxilary Memory Attribute Indirection Reg0 */
+	c10_AMAIR1,		/* Auxilary Memory Attribute Indirection Reg1 */
+	NR_CP15_REGS		/* Number of regs (incl. invalid) */
+};
+
 struct kvm_cpu_context {
 	struct kvm_regs	gp_regs;
 	struct vfp_hard_struct vfp;
diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
index 86e26fb..12cbb68 100644
--- a/arch/arm/kvm/guest.c
+++ b/arch/arm/kvm/guest.c
@@ -25,7 +25,6 @@
 #include <asm/cputype.h>
 #include <asm/uaccess.h>
 #include <asm/kvm.h>
-#include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_coproc.h>
 
-- 
2.1.4
