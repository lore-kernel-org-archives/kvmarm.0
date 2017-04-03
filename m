From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC 8/9] arm64/kvm: context-switch PAC registers
Date: Mon,  3 Apr 2017 16:19:24 +0100
Message-ID: <1491232765-32501-9-git-send-email-mark.rutland@arm.com>
References: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8DCC40A86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 11:18:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j-sMsuSZ2kGa for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 11:18:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64A6240A69
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 11:18:34 -0400 (EDT)
In-Reply-To: <1491232765-32501-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If we have pointer authentication support, a guest may wish to use it.
This patch adds the infrastructure to allow it to do so.

This is sufficient for basic testing, but not for real-world usage. A
guest will still see pointer authentication support advertised in the ID
registers, and we will need to trap accesses to these to provide
santized values.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org> 
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_emulate.h | 15 +++++++++++++
 arch/arm64/include/asm/kvm_host.h    | 12 ++++++++++
 arch/arm64/kvm/hyp/sysreg-sr.c       | 43 ++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f5ea0ba..0c3cb43 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -28,6 +28,8 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmio.h>
 #include <asm/ptrace.h>
+#include <asm/cpucaps.h>
+#include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/virt.h>
 
@@ -49,6 +51,19 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_E2H;
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
+
+	/*
+	 * Address auth and generic auth share the same enable bits, so we have
+	 * to ensure both are uniform before we can enable support in a guest.
+	 * Until we have the infrastructure to detect uniform absence of a
+	 * feature, only permit the case when both are supported.
+	 *
+	 * Note that a guest will still see the feature in ID_AA64_ISAR1 until
+	 * we introduce code to emulate the ID registers.
+	 */
+	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH) &&
+	    cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH))
+		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
 }
 
 static inline unsigned long vcpu_get_hcr(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e7705e7..b25f710 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -133,6 +133,18 @@ enum vcpu_sysreg {
 	PMSWINC_EL0,	/* Software Increment Register */
 	PMUSERENR_EL0,	/* User Enable Register */
 
+	/* Pointer Authentication Registers */
+	APIAKEYLO_EL1,
+	APIAKEYHI_EL1,
+	APIBKEYLO_EL1,
+	APIBKEYHI_EL1,
+	APDAKEYLO_EL1,
+	APDAKEYHI_EL1,
+	APDBKEYLO_EL1,
+	APDBKEYHI_EL1,
+	APGAKEYLO_EL1,
+	APGAKEYHI_EL1,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 9341376..3440b42 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -18,6 +18,8 @@
 #include <linux/compiler.h>
 #include <linux/kvm_host.h>
 
+#include <asm/cpucaps.h>
+#include <asm/cpufeature.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
 
@@ -31,6 +33,24 @@ static void __hyp_text __sysreg_do_nothing(struct kvm_cpu_context *ctxt) { }
  * pstate, and guest must save everything.
  */
 
+#define __save_ap_key(regs, key) \
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1); \
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1)
+
+static void __hyp_text __sysreg_save_ap_keys(struct kvm_cpu_context *ctxt)
+{
+	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH)) {
+		__save_ap_key(ctxt->sys_regs, APIA);
+		__save_ap_key(ctxt->sys_regs, APIB);
+		__save_ap_key(ctxt->sys_regs, APDA);
+		__save_ap_key(ctxt->sys_regs, APDB);
+	}
+
+	if (cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
+		__save_ap_key(ctxt->sys_regs, APGA);
+	}
+}
+
 static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 {
 	ctxt->sys_regs[ACTLR_EL1]	= read_sysreg(actlr_el1);
@@ -41,6 +61,8 @@ static void __hyp_text __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
 	ctxt->gp_regs.regs.sp		= read_sysreg(sp_el0);
 	ctxt->gp_regs.regs.pc		= read_sysreg_el2(elr);
 	ctxt->gp_regs.regs.pstate	= read_sysreg_el2(spsr);
+
+	__sysreg_save_ap_keys(ctxt);
 }
 
 static void __hyp_text __sysreg_save_state(struct kvm_cpu_context *ctxt)
@@ -84,6 +106,25 @@ void __hyp_text __sysreg_save_guest_state(struct kvm_cpu_context *ctxt)
 	__sysreg_save_common_state(ctxt);
 }
 
+#define __restore_ap_key(regs, key) \
+	write_sysreg_s(regs[key ## KEYLO_EL1], SYS_ ## key ## KEYLO_EL1); \
+	write_sysreg_s(regs[key ## KEYHI_EL1], SYS_ ## key ## KEYHI_EL1)
+
+static void __hyp_text __sysreg_restore_ap_keys(struct kvm_cpu_context *ctxt)
+{
+	if (cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH)) {
+		__restore_ap_key(ctxt->sys_regs, APIA);
+		__restore_ap_key(ctxt->sys_regs, APIB);
+		__restore_ap_key(ctxt->sys_regs, APDA);
+		__restore_ap_key(ctxt->sys_regs, APDB);
+	}
+
+	if (cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH)) {
+		__restore_ap_key(ctxt->sys_regs, APGA);
+	}
+}
+
+
 static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctxt)
 {
 	write_sysreg(ctxt->sys_regs[ACTLR_EL1],	  actlr_el1);
@@ -94,6 +135,8 @@ static void __hyp_text __sysreg_restore_common_state(struct kvm_cpu_context *ctx
 	write_sysreg(ctxt->gp_regs.regs.sp,	  sp_el0);
 	write_sysreg_el2(ctxt->gp_regs.regs.pc,	  elr);
 	write_sysreg_el2(ctxt->gp_regs.regs.pstate, spsr);
+
+	__sysreg_restore_ap_keys(ctxt);
 }
 
 static void __hyp_text __sysreg_restore_state(struct kvm_cpu_context *ctxt)
-- 
1.9.1
