Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7FDC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:29:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D2946157F
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:29:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D2946157F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C99F4B85D;
	Mon, 10 May 2021 13:29:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EfEOcOm+8djF; Mon, 10 May 2021 13:29:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A8CC4B889;
	Mon, 10 May 2021 13:29:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C5B84B89D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6OfuwNDSx5ZX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 13:28:56 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60C354B86B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:28:56 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 54002616EA;
 Mon, 10 May 2021 17:28:55 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg9Gn-000Uqg-Ew; Mon, 10 May 2021 18:00:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v4 58/66] KVM: arm64: Map VNCR-capable registers to a separate
 page
Date: Mon, 10 May 2021 17:59:12 +0100
Message-Id: <20210510165920.1913477-59-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

With ARMv8.4-NV, registers that can be directly accessed in memory
by the guest have to live at architected offsets in a special page.

Let's annotate the sysreg enum to reflect the offset at which they
are in this page, whith a little twist:

If running on HW that doesn't have the ARMv8.4-NV feature, or even
a VM that doesn't use NV, we store all the system registers in the
usual sys_regs array. The only difference with the pre-8.4
situation is that VNCR-capable registers are at a "similar" offset
as in the VNCR page (we can compute the actual offset at compile
time), and that the sys_regs array is both bigger and sparse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 97 ++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b382c317ec5a..815ae39f7857 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #include <asm/kvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/thread_info.h>
+#include <asm/vncr_mapping.h>
 
 #define __KVM_HAVE_ARCH_INTC_INITIALIZED
 
@@ -171,31 +172,32 @@ struct kvm_vcpu_fault_info {
 	u64 disr_el1;		/* Deferred [SError] Status Register */
 };
 
+/*
+ * VNCR() just places the VNCR_capable registers in the enum after
+ * __VNCR_START__, and the value (after correction) to be an 8-byte offset
+ * from the VNCR base. As we don't require the enum to be otherwise ordered,
+ * we need the terrible hack below to ensure that we correctly size the
+ * sys_regs array, no matter what.
+ *
+ * The __MAX__ macro has been lifted from Sean Eron Anderson's wonderful
+ * treasure trove of bit hacks:
+ * https://graphics.stanford.edu/~seander/bithacks.html#IntegerMinOrMax
+ */
+#define __MAX__(x,y)	((x) ^ (((x) ^ (y)) & -((x) < (y))))
+#define VNCR(r)						\
+	__before_##r,					\
+	r = __VNCR_START__ + ((VNCR_ ## r) / 8),	\
+	__after_##r = __MAX__(__before_##r - 1, r)
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
 	CSSELR_EL1,	/* Cache Size Selection Register */
-	SCTLR_EL1,	/* System Control Register */
-	ACTLR_EL1,	/* Auxiliary Control Register */
-	CPACR_EL1,	/* Coprocessor Access Control */
-	ZCR_EL1,	/* SVE Control */
-	TTBR0_EL1,	/* Translation Table Base Register 0 */
-	TTBR1_EL1,	/* Translation Table Base Register 1 */
-	TCR_EL1,	/* Translation Control Register */
-	ESR_EL1,	/* Exception Syndrome Register */
-	AFSR0_EL1,	/* Auxiliary Fault Status Register 0 */
-	AFSR1_EL1,	/* Auxiliary Fault Status Register 1 */
-	FAR_EL1,	/* Fault Address Register */
-	MAIR_EL1,	/* Memory Attribute Indirection Register */
-	VBAR_EL1,	/* Vector Base Address Register */
-	CONTEXTIDR_EL1,	/* Context ID Register */
 	TPIDR_EL0,	/* Thread ID, User R/W */
 	TPIDRRO_EL0,	/* Thread ID, User R/O */
 	TPIDR_EL1,	/* Thread ID, Privileged */
-	AMAIR_EL1,	/* Aux Memory Attribute Indirection Register */
 	CNTKCTL_EL1,	/* Timer Control Register (EL1) */
 	PAR_EL1,	/* Physical Address Register */
-	MDSCR_EL1,	/* Monitor Debug System Control Register */
 	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 	DISR_EL1,	/* Deferred Interrupt Status Register */
 
@@ -226,16 +228,6 @@ enum vcpu_sysreg {
 	APGAKEYLO_EL1,
 	APGAKEYHI_EL1,
 
-	ELR_EL1,
-	SP_EL1,
-	SPSR_EL1,
-
-	CNTVOFF_EL2,
-	CNTV_CVAL_EL0,
-	CNTV_CTL_EL0,
-	CNTP_CVAL_EL0,
-	CNTP_CTL_EL0,
-
 	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -243,20 +235,14 @@ enum vcpu_sysreg {
 	DBGVCR32_EL2,	/* Debug Vector Catch Register */
 
 	/* EL2 registers */
-	VPIDR_EL2,	/* Virtualization Processor ID Register */
-	VMPIDR_EL2,	/* Virtualization Multiprocessor ID Register */
 	SCTLR_EL2,	/* System Control Register (EL2) */
 	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
-	HCR_EL2,	/* Hypervisor Configuration Register */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
-	HSTR_EL2,	/* Hypervisor System Trap Register */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
-	VTTBR_EL2,	/* Virtualization Translation Table Base Register */
-	VTCR_EL2,	/* Virtualization Translation Control Register */
 	SPSR_EL2,	/* EL2 saved program status register */
 	ELR_EL2,	/* EL2 exception link register */
 	AFSR0_EL2,	/* Auxiliary Fault Status Register 0 (EL2) */
@@ -269,7 +255,6 @@ enum vcpu_sysreg {
 	VBAR_EL2,	/* Vector Base Address Register (EL2) */
 	RVBAR_EL2,	/* Reset Vector Base Address Register */
 	CONTEXTIDR_EL2,	/* Context ID Register (EL2) */
-	TPIDR_EL2,	/* EL2 Software Thread ID Register */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
 	SP_EL2,		/* EL2 Stack Pointer */
 	CNTHP_CTL_EL2,
@@ -277,6 +262,41 @@ enum vcpu_sysreg {
 	CNTHV_CTL_EL2,
 	CNTHV_CVAL_EL2,
 
+	__VNCR_START__,	/* Any VNCR-capable reg goes after this point */
+
+	VNCR(SCTLR_EL1),/* System Control Register */
+	VNCR(ACTLR_EL1),/* Auxiliary Control Register */
+	VNCR(CPACR_EL1),/* Coprocessor Access Control */
+	VNCR(ZCR_EL1),	/* SVE Control */
+	VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
+	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
+	VNCR(TCR_EL1),	/* Translation Control Register */
+	VNCR(ESR_EL1),	/* Exception Syndrome Register */
+	VNCR(AFSR0_EL1),/* Auxiliary Fault Status Register 0 */
+	VNCR(AFSR1_EL1),/* Auxiliary Fault Status Register 1 */
+	VNCR(FAR_EL1),	/* Fault Address Register */
+	VNCR(MAIR_EL1),	/* Memory Attribute Indirection Register */
+	VNCR(VBAR_EL1),	/* Vector Base Address Register */
+	VNCR(CONTEXTIDR_EL1),	/* Context ID Register */
+	VNCR(AMAIR_EL1),/* Aux Memory Attribute Indirection Register */
+	VNCR(MDSCR_EL1),/* Monitor Debug System Control Register */
+	VNCR(ELR_EL1),
+	VNCR(SP_EL1),
+	VNCR(SPSR_EL1),
+	VNCR(VPIDR_EL2),/* Virtualization Processor ID Register */
+	VNCR(VMPIDR_EL2),/* Virtualization Multiprocessor ID Register */
+	VNCR(HCR_EL2),	/* Hypervisor Configuration Register */
+	VNCR(HSTR_EL2),	/* Hypervisor System Trap Register */
+	VNCR(VTTBR_EL2),/* Virtualization Translation Table Base Register */
+	VNCR(VTCR_EL2),	/* Virtualization Translation Control Register */
+	VNCR(TPIDR_EL2),/* EL2 Software Thread ID Register */
+
+	VNCR(CNTVOFF_EL2),
+	VNCR(CNTV_CVAL_EL0),
+	VNCR(CNTV_CTL_EL0),
+	VNCR(CNTP_CVAL_EL0),
+	VNCR(CNTP_CTL_EL0),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
@@ -293,6 +313,9 @@ struct kvm_cpu_context {
 	u64 sys_regs[NR_SYS_REGS];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
+
+	/* This pointer has to be 4kB aligned. */
+	u64 *vncr_array;
 };
 
 struct kvm_pmu_events {
@@ -520,7 +543,13 @@ struct kvm_vcpu_arch {
  * for system registers that are never context switched, but only
  * emulated.
  */
-#define __ctxt_sys_reg(c,r)	(&(c)->sys_regs[(r)])
+static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
+{
+	if (unlikely(r >= __VNCR_START__ && ctxt->vncr_array))
+		return &ctxt->vncr_array[r - __VNCR_START__];
+
+	return (u64 *)&ctxt->sys_regs[r];
+}
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
