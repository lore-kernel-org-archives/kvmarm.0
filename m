From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 14/23] arm64: KVM: VHE: Make __fpsimd_enabled VHE aware
Date: Thu, 11 Feb 2016 18:39:55 +0000
Message-ID: <1455216004-19499-15-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B69EA49A5E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BGLtRd95n8sQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:40 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED64849C03
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:35 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

As non-VHE and VHE have different ways to express the trapping of
FPSIMD registers to EL2, make __fpsimd_enabled a patchable predicate
and provide a VHE implementation.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |  3 +++
 arch/arm64/kvm/hyp/hyp.h         |  5 +----
 arch/arm64/kvm/hyp/switch.c      | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index bef6e92..f416714 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -218,4 +218,7 @@
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
 	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
 
+#define CPACR_EL1_FPEN		(3 << 20)
+#define CPACR_EL1_TTA		(1 << 28)
+
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 5dfa883..44eaff7 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -171,10 +171,7 @@ void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
-static inline bool __fpsimd_enabled(void)
-{
-	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
-}
+bool __fpsimd_enabled(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 68f3cba..0d82ae9 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -17,6 +17,25 @@
 
 #include "hyp.h"
 
+static bool __hyp_text __fpsimd_enabled_nvhe(void)
+{
+	return !(read_sysreg(cptr_el2) & CPTR_EL2_TFP);
+}
+
+static bool __hyp_text __fpsimd_enabled_vhe(void)
+{
+	return !!(read_sysreg(cpacr_el1) & CPACR_EL1_FPEN);
+}
+
+static hyp_alternate_select(__fpsimd_is_enabled,
+			    __fpsimd_enabled_nvhe, __fpsimd_enabled_vhe,
+			    ARM64_HAS_VIRT_HOST_EXTN);
+
+bool __hyp_text __fpsimd_enabled(void)
+{
+	return __fpsimd_is_enabled()();
+}
+
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
-- 
2.1.4
