From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 11/37] KVM: arm64: Improve debug register save/restore flow
Date: Thu, 12 Oct 2017 12:41:15 +0200
Message-ID: <20171012104141.26902-12-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A997349D90
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gVzyTv004-Oh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:14 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A1FAF49D9B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:13 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id m72so23422903wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:41:58 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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

Instead of having multiple calls from the world switch path to the debug
logic, each figuring out if the dirty bit is set and if we should
save/restore the debug registes, let's just provide two hooks to the
debug save/restore functionality, one for switching to the guest
context, and one for switching to the host context, and we get the
benefit of only having to evaluate the dirty flag once on each path,
plus we give the compiler some more room to inline some of this
functionality.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 10 ++-----
 arch/arm64/kvm/hyp/debug-sr.c    | 56 +++++++++++++++++++++++++++-------------
 arch/arm64/kvm/hyp/switch.c      |  6 ++---
 3 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 08d3bb6..a0e5a70 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -139,14 +139,8 @@ void __sysreg_restore_guest_state(struct kvm_cpu_context *ctxt);
 void __sysreg32_save_state(struct kvm_vcpu *vcpu);
 void __sysreg32_restore_state(struct kvm_vcpu *vcpu);
 
-void __debug_save_state(struct kvm_vcpu *vcpu,
-			struct kvm_guest_debug_arch *dbg,
-			struct kvm_cpu_context *ctxt);
-void __debug_restore_state(struct kvm_vcpu *vcpu,
-			   struct kvm_guest_debug_arch *dbg,
-			   struct kvm_cpu_context *ctxt);
-void __debug_cond_save_host_state(struct kvm_vcpu *vcpu);
-void __debug_cond_restore_host_state(struct kvm_vcpu *vcpu);
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
+void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
index a2291b6..b4cd8e0 100644
--- a/arch/arm64/kvm/hyp/debug-sr.c
+++ b/arch/arm64/kvm/hyp/debug-sr.c
@@ -116,16 +116,13 @@ static void __hyp_text __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, PMSCR_EL1);
 }
 
-void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
-				   struct kvm_guest_debug_arch *dbg,
-				   struct kvm_cpu_context *ctxt)
+static void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
+					  struct kvm_guest_debug_arch *dbg,
+					  struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
 
-	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
 	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
 	brps = (aa64dfr0 >> 12) & 0xf;
 	wrps = (aa64dfr0 >> 20) & 0xf;
@@ -138,16 +135,13 @@ void __hyp_text __debug_save_state(struct kvm_vcpu *vcpu,
 	ctxt->sys_regs[MDCCINT_EL1] = read_sysreg(mdccint_el1);
 }
 
-void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
-				      struct kvm_guest_debug_arch *dbg,
-				      struct kvm_cpu_context *ctxt)
+static void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
+					     struct kvm_guest_debug_arch *dbg,
+					     struct kvm_cpu_context *ctxt)
 {
 	u64 aa64dfr0;
 	int brps, wrps;
 
-	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
-		return;
-
 	aa64dfr0 = read_sysreg(id_aa64dfr0_el1);
 
 	brps = (aa64dfr0 >> 12) & 0xf;
@@ -161,24 +155,50 @@ void __hyp_text __debug_restore_state(struct kvm_vcpu *vcpu,
 	write_sysreg(ctxt->sys_regs[MDCCINT_EL1], mdccint_el1);
 }
 
-void __hyp_text __debug_cond_save_host_state(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 {
-	__debug_save_state(vcpu, &vcpu->arch.host_debug_state.regs,
-			   kern_hyp_va(vcpu->arch.host_cpu_context));
+	struct kvm_cpu_context *__host_ctxt;
+	struct kvm_cpu_context *__guest_ctxt;
+	struct kvm_guest_debug_arch *__host_dbg;
+	struct kvm_guest_debug_arch *__guest_dbg;
 
 	/* Non-VHE: Disable and flush SPE data generation
 	 * VHE: The vcpu can run. but it can't hide. */
 	if (!has_vhe())
 		__debug_save_spe_nvhe(&vcpu->arch.host_debug_state.pmscr_el1);
+
+	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
+
+	__host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	__guest_ctxt = &vcpu->arch.ctxt;
+	__host_dbg = &vcpu->arch.host_debug_state.regs;
+	__guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(vcpu, __host_dbg, __host_ctxt);
+	__debug_restore_state(vcpu, __guest_dbg, __guest_ctxt);
 }
 
-void __hyp_text __debug_cond_restore_host_state(struct kvm_vcpu *vcpu)
+void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *__host_ctxt;
+	struct kvm_cpu_context *__guest_ctxt;
+	struct kvm_guest_debug_arch *__host_dbg;
+	struct kvm_guest_debug_arch *__guest_dbg;
+
 	if (!has_vhe())
 		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
 
-	__debug_restore_state(vcpu, &vcpu->arch.host_debug_state.regs,
-			      kern_hyp_va(vcpu->arch.host_cpu_context));
+	if (!(vcpu->arch.debug_flags & KVM_ARM64_DEBUG_DIRTY))
+		return;
+
+	__host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	__guest_ctxt = &vcpu->arch.ctxt;
+	__host_dbg = &vcpu->arch.host_debug_state.regs;
+	__guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
+
+	__debug_save_state(vcpu, __guest_dbg, __guest_ctxt);
+	__debug_restore_state(vcpu, __host_dbg, __host_ctxt);
 
 	vcpu->arch.debug_flags &= ~KVM_ARM64_DEBUG_DIRTY;
 }
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index ef05c59..e270cba 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -271,7 +271,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	__sysreg_save_host_state(host_ctxt);
-	__debug_cond_save_host_state(vcpu);
 
 	__activate_traps(vcpu);
 	__activate_vm(vcpu);
@@ -285,7 +284,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_guest_state(guest_ctxt);
-	__debug_restore_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
+	__debug_switch_to_guest(vcpu);
 
 	/* Jump in the fire! */
 again:
@@ -353,12 +352,11 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_host_state(host_ctxt);
 
-	__debug_save_state(vcpu, kern_hyp_va(vcpu->arch.debug_ptr), guest_ctxt);
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_cond_restore_host_state(vcpu);
+	__debug_switch_to_host(vcpu);
 
 	return exit_code;
 }
-- 
2.9.0
