From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 10/13] arm64: KVM: enable conditional save/restore full SPE
 profiling buffer controls
Date: Thu, 28 Feb 2019 16:07:32 +0000
Message-ID: <20190228160737.3323-11-sudeep.holla@arm.com>
References: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A63D84A477
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lo7wRla40mqB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8118E4A3A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:17 -0500 (EST)
In-Reply-To: <20190228160737.3323-1-sudeep.holla@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can save/restore the full SPE controls, we can enable it
if SPE is setup and ready to use in KVM. It's supported in KVM only if
all the CPUs in the system supports SPE.

However to support heterogenous systems, we need to move the check if
host supports SPE and do a partial save/restore.

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
---
 arch/arm64/kvm/hyp/debug-sr.c | 33 ++++++++++++++++-----------------
 include/kvm/arm_spe.h         |  3 +++
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index a4e6eaf5934f..cd0a7571abc1 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -67,18 +67,13 @@
 	}
 
 static void __hyp_text
-__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
+__debug_save_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
 {
 	u64 reg;
 
 	/* Clear pmscr in case of early return */
 	ctxt->sys_regs[PMSCR_EL1] = 0;
 
-	/* SPE present on this CPU? */
-	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
-						  ID_AA64DFR0_PMSVER_SHIFT))
-		return;
-
 	/* Yes; is it owned by higher EL? */
 	reg = read_sysreg_s(SYS_PMBIDR_EL1);
 	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
@@ -114,7 +109,7 @@ __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
 }
 
 static void __hyp_text
-__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
+__debug_restore_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
 {
 	if (!ctxt->sys_regs[PMSCR_EL1])
 		return;
@@ -182,11 +177,14 @@ void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
+	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	__debug_restore_spe_context(guest_ctxt, kvm_arm_spe_v1_ready(vcpu));
+
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	guest_ctxt = &vcpu->arch.ctxt;
 	host_dbg = &vcpu->arch.host_debug_state.regs;
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
@@ -204,8 +202,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	if (!has_vhe())
-		__debug_restore_spe_nvhe(host_ctxt, false);
+	__debug_restore_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
 
 	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
 		return;
@@ -221,19 +218,21 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
 
 void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * Non-VHE: Disable and flush SPE data generation
-	 * VHE: The vcpu can run, but it can't hide.
-	 */
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
-	if (!has_vhe())
-		__debug_save_spe_nvhe(host_ctxt, false);
+	if (cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
+						 ID_AA64DFR0_PMSVER_SHIFT))
+		__debug_save_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
 }
 
 void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
 {
+	bool kvm_spe_ready = kvm_arm_spe_v1_ready(vcpu);
+
+	/* SPE present on this vCPU? */
+	if (kvm_spe_ready)
+		__debug_save_spe_context(&vcpu->arch.ctxt, kvm_spe_ready);
 }
 
 u32 __hyp_text __kvm_get_mdcr_el2(void)
diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
index 5678f80e1528..132efd636722 100644
--- a/include/kvm/arm_spe.h
+++ b/include/kvm/arm_spe.h
@@ -18,6 +18,8 @@ struct kvm_spe {
 
 #ifdef CONFIG_KVM_ARM_SPE
 
+#define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
+
 static inline bool kvm_arm_support_spe_v1(void)
 {
 	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
@@ -26,6 +28,7 @@ static inline bool kvm_arm_support_spe_v1(void)
 }
 #else
 
+#define kvm_arm_spe_v1_ready(v)		(false)
 #define kvm_arm_support_spe_v1()	(false)
 #endif /* CONFIG_KVM_ARM_SPE */
 
-- 
2.17.1
