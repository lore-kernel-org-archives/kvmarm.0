From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 28/36] KVM: arm64: Configure FPSIMD traps on vcpu load/put
 for VHE
Date: Thu,  7 Dec 2017 18:06:22 +0100
Message-ID: <20171207170630.592-29-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4602949DE7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xh2DIr4XBzVQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Dec 2017 12:04:11 -0500 (EST)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com [74.125.82.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B42D49D74
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Dec 2017 12:04:10 -0500 (EST)
Received: by mail-wm0-f67.google.com with SMTP id l141so14274162wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Dec 2017 09:07:26 -0800 (PST)
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

There is no need to enable/disable traps to FP registers on every switch
to/from the VM, because the host kernel does not use this resource
without calling vcpu_put.  We can therefore move things around enough
that we still always write FPEXC32_EL2 before programming CPTR_EL2 but
only program these during vcpu load/put.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h |  3 +++
 arch/arm64/kvm/hyp/switch.c      | 34 ++++++++++++++++++++++++----------
 arch/arm64/kvm/hyp/sysreg-sr.c   |  4 ++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 3f54c55f77a1..28d5f3cb4001 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -148,6 +148,9 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 bool __fpsimd_enabled(void);
 
+void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
+void deactivate_traps_vhe_put(void);
+
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c01bcfc3fb52..44aae69a7fec 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -24,22 +24,25 @@
 #include <asm/fpsimd.h>
 #include <asm/debug-monitors.h>
 
-static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
+static void __hyp_text __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * We are about to set CPTR_EL2.TFP to trap all floating point
-	 * register accesses to EL2, however, the ARM ARM clearly states that
-	 * traps are only taken to EL2 if the operation would not otherwise
-	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
-	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
-	 * If FP/ASIMD is not implemented, FPEXC is UNDEFINED and any access to
-	 * it will cause an exception.
+	 * We are about to trap all floating point register accesses to EL2,
+	 * however, traps are only taken to EL2 if the operation would not
+	 * otherwise trap to EL1.  Therefore, always make sure that for 32-bit
+	 * guests, we set FPEXC.EN to prevent traps to EL1, when setting the
+	 * TFP bit.  If FP/ASIMD is not implemented, FPEXC is UNDEFINED and
+	 * any access to it will cause an exception.
 	 */
 	if (vcpu_el1_is_32bit(vcpu) && system_supports_fpsimd() &&
 	    !vcpu->arch.guest_vfp_loaded) {
 		write_sysreg(1 << 30, fpexc32_el2);
 		isb();
 	}
+}
+
+static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
+{
 	write_sysreg(vcpu->arch.hcr_el2, hcr_el2);
 
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
@@ -61,10 +64,12 @@ static void __hyp_text __deactivate_traps_common(void)
 	write_sysreg(0, pmuserenr_el0);
 }
 
-static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
+void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
+	__activate_traps_fpsimd32(vcpu);
+
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
 	val &= ~CPACR_EL1_ZEN;
@@ -73,7 +78,15 @@ static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
 	else
 		val &= ~CPACR_EL1_FPEN;
 	write_sysreg(val, cpacr_el1);
+}
 
+void deactivate_traps_vhe_put(void)
+{
+	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
+}
+
+static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
+{
 	write_sysreg(__kvm_hyp_vector, vbar_el1);
 }
 
@@ -81,6 +94,8 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
+	__activate_traps_fpsimd32(vcpu);
+
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ;
 	if (vcpu->arch.guest_vfp_loaded)
@@ -111,7 +126,6 @@ static void __hyp_text __deactivate_traps_vhe(void)
 
 	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
-	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
 }
 
diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
index 65abf1aeba59..b647fea93fdc 100644
--- a/arch/arm64/kvm/hyp/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/sysreg-sr.c
@@ -254,6 +254,8 @@ void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu)
 	__sysreg_restore_el1_state(guest_ctxt);
 
 	vcpu->arch.sysregs_loaded_on_cpu = true;
+
+	activate_traps_vhe_load(vcpu);
 }
 
 /**
@@ -286,6 +288,8 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
 	if (!has_vhe())
 		return;
 
+	deactivate_traps_vhe_put();
+
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-- 
2.14.2
