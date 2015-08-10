From: Zhichao Huang <zhichao.huang@linaro.org>
Subject: [PATCH v4 13/15] KVM: arm: keep track of guest use of the debug registers
Date: Mon, 10 Aug 2015 21:26:05 +0800
Message-ID: <1439213167-8988-14-git-send-email-zhichao.huang@linaro.org>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com
Cc: huangzhichao@huawei.com, Zhichao Huang <zhichao.huang@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We trap debug register accesses from guest all the time, and read the
BCR/WCR to indicate whether the guest has enabled any break/watch points
or not.

Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h |  2 ++
 arch/arm/kvm/coproc.c          | 75 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 5b1c3eb..e9e1f0a 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -65,7 +65,9 @@
 #define NR_CP14_REGS	66	/* Number of regs (incl. invalid) */
 
 #define KVM_ARM_DEBUG_HOST_INUSE_SHIFT	0
+#define KVM_ARM_DEBUG_GUEST_INUSE_SHIFT	1
 #define KVM_ARM_DEBUG_HOST_INUSE	(1 << KVM_ARM_DEBUG_HOST_INUSE_SHIFT)
+#define KVM_ARM_DEBUG_GUEST_INUSE	(1 << KVM_ARM_DEBUG_GUEST_INUSE_SHIFT)
 
 #define ARM_EXCEPTION_RESET	  0
 #define ARM_EXCEPTION_UNDEFINED   1
diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
index b37afd6..d9dcd28b 100644
--- a/arch/arm/kvm/coproc.c
+++ b/arch/arm/kvm/coproc.c
@@ -220,7 +220,22 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool trap_debug32(struct kvm_vcpu *vcpu,
+/* Indicate whether the guest has enabled any break/watch points or not. */
+static bool guest_debug_in_use(struct kvm_vcpu *vcpu)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARM_MAX_BRP; i++)
+		if (vcpu->arch.cp14[cp14_DBGBCR0 + i] & 0x1)
+			return true;
+	for (i = 0; i < ARM_MAX_WRP; i++)
+		if (vcpu->arch.cp14[cp14_DBGWCR0 + i] & 0x1)
+			return true;
+
+	return false;
+}
+
+static bool __trap_debug32(struct kvm_vcpu *vcpu,
 			const struct coproc_params *p,
 			const struct coproc_reg *r)
 {
@@ -232,6 +247,56 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/*
+ * We want to avoid world-switching all the DBG registers all the
+ * time:
+ *
+ * When we are about to run a guest, we have the following cases:
+ *
+ * 1) Neither the host nor the guest has configured any [WB]points
+ * 2) Only the host has configured any [WB]points
+ * 3) Only the guest has configured any [WB]points
+ * 4) Both the host and the guest have configured any [WB]points
+ *
+ * - In case (1), KVM should enable trapping and swtich the register
+ *   state on guest accesses.
+ * - In cases (2), (3), and (4) we must switch the register state on each
+ *   entry/exit.
+ *
+ * For ARMv7, if the CONFIG_HAVE_HW_BREAKPOINT is set, ARM_DSCR_MDBGEN
+ * is always set(ARM64 use it to indicate that debug registers are actively
+ * in use).
+ *
+ * - We add a function reading the break/watch control variables directly to
+ *   indicate whether the host has enabled any break/watch points or not.
+ *   We only call the function upon guest entry, after preempt_disable() and
+ *   local_irq_disable(), so there is no race for it.
+ *
+ * - We trap debug register accesses from guest all the time, and read the
+ *   BCR/WCR to indicate whether the guest has enabled any break/watch points
+ *   or not.
+ *
+ * For this, we can keep track of the host/guest use of debug registers,
+ * and skip the save/restore dance when neither the host nor the guest has
+ * configured any [WB]points.
+ */
+static bool trap_debug32(struct kvm_vcpu *vcpu,
+			const struct coproc_params *p,
+			const struct coproc_reg *r)
+{
+	__trap_debug32(vcpu, p, r);
+
+	if (p->is_write) {
+		if ((vcpu->arch.cp14[r->reg] & 0x1) ||
+		    guest_debug_in_use(vcpu))
+			vcpu->arch.debug_flags |= KVM_ARM_DEBUG_GUEST_INUSE;
+		else
+			vcpu->arch.debug_flags &= ~KVM_ARM_DEBUG_GUEST_INUSE;
+	}
+
+	return true;
+}
+
 /* DBGIDR (RO) Debug ID */
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
 			const struct coproc_params *p,
@@ -419,13 +484,13 @@ static const struct coproc_reg cp15_regs[] = {
 #define DBG_BCR_BVR_WCR_WVR(n)					\
 	/* DBGBVRn */						\
 	{ CRn( 0), CRm((n)), Op1( 0), Op2( 4), is32,		\
-	  trap_debug32,	reset_val, (cp14_DBGBVR0 + (n)), 0 },	\
+	  __trap_debug32, reset_val, (cp14_DBGBVR0 + (n)), 0 },	\
 	/* DBGBCRn */						\
 	{ CRn( 0), CRm((n)), Op1( 0), Op2( 5), is32,		\
 	  trap_debug32,	reset_val, (cp14_DBGBCR0 + (n)), 0 },	\
 	/* DBGWVRn */						\
 	{ CRn( 0), CRm((n)), Op1( 0), Op2( 6), is32,		\
-	  trap_debug32,	reset_val, (cp14_DBGWVR0 + (n)), 0 },	\
+	  __trap_debug32, reset_val, (cp14_DBGWVR0 + (n)), 0 },	\
 	/* DBGWCRn */						\
 	{ CRn( 0), CRm((n)), Op1( 0), Op2( 7), is32,		\
 	  trap_debug32,	reset_val, (cp14_DBGWCR0 + (n)), 0 }
@@ -462,7 +527,7 @@ static const struct coproc_reg cp14_regs[] = {
 	/* DBGDSAR (64bit) */
 	{ CRn( 0), CRm( 2), Op1( 0), Op2( 0), is64, trap_raz_wi },
 	/* DBGDSCRext */
-	{ CRn( 0), CRm( 2), Op1( 0), Op2( 2), is32, trap_debug32,
+	{ CRn( 0), CRm( 2), Op1( 0), Op2( 2), is32, __trap_debug32,
 				reset_val, cp14_DBGDSCRext, 0 },
 	DBG_BCR_BVR_WCR_WVR(2),
 	/* DBGDTRTXext */
@@ -474,7 +539,7 @@ static const struct coproc_reg cp14_regs[] = {
 	DBG_BCR_BVR_WCR_WVR(5),
 	DBG_BCR_BVR_WCR_WVR(6),
 	/* DBGVCR */
-	{ CRn( 0), CRm( 7), Op1( 0), Op2( 0), is32, trap_debug32 },
+	{ CRn( 0), CRm( 7), Op1( 0), Op2( 0), is32, __trap_debug32 },
 	DBG_BCR_BVR_WCR_WVR(7),
 	DBG_BCR_BVR_WCR_WVR(8),
 	DBG_BCR_BVR_WCR_WVR(9),
-- 
1.7.12.4

