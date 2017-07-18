From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 14/38] KVM: arm64: Synchronize EL1 system registers on
 virtual EL2 entry and exit
Date: Tue, 18 Jul 2017 11:58:40 -0500
Message-ID: <1500397144-16232-15-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 125FC49C44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oeZmZRJvbZTi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:10 -0400 (EDT)
Received: from mail-it0-f42.google.com (mail-it0-f42.google.com
 [209.85.214.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C2EA49BFB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:10 -0400 (EDT)
Received: by mail-it0-f42.google.com with SMTP id v127so6942780itd.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:58 -0700 (PDT)
In-Reply-To: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, david.daney@cavium.com, catalin.marinas@arm.com, will.deacon@arm.com, stefan@hello-penguin.com, corbet@lwn.net, daniel.lezcano@linaro.org, linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, cov@codeaurora.org, wcohen@redhat.com, mchehab@kernel.org, ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

When running in virtual EL2 we use the shadow EL1 systerm register array
for the save/restore process, so that hardware and especially the memory
subsystem behaves as code written for EL2 expects while really running
in EL1.

This works great for EL1 system register accesses that we trap, because
these accesses will be written into the virtual state for the EL1 system
registers used when eventually switching the VCPU mode to EL1.

However, there was a collection of EL1 system registers which we do not
trap, and as a consequence all save/restore operations of these
registers were happening locally in the shadow array, with no benefit to
software actually running in virtual EL1 at all.

To fix this, simply synchronize the shadow and real EL1 state for these
registers on entry/exit to/from virtual EL2 state.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/context.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index e965049..e1bc753 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -86,6 +86,58 @@ static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
 	s_sys_regs[CPACR_EL1] = cptr_to_cpacr(vcpu_sys_reg(vcpu, CPTR_EL2));
 }
 
+
+/*
+ * List of EL0 and EL1 registers which we allow the virtual EL2 mode to access
+ * directly without trapping. This is possible because the impact of
+ * accessing those registers are the same regardless of the exception
+ * levels that are allowed.
+ */
+static const int el1_non_trap_regs[] = {
+	CNTKCTL_EL1,
+	CSSELR_EL1,
+	PAR_EL1,
+	TPIDR_EL0,
+	TPIDR_EL1,
+	TPIDRRO_EL0
+};
+
+/**
+ * copy_shadow_non_trap_el1_state
+ * @vcpu:      The VCPU pointer
+ * @setup:     True, if on the way to the guest (called from setup)
+ *             False, if returning form the guet (calld from restore)
+ *
+ * Some EL1 registers are accessed directly by the virtual EL2 mode because
+ * they in no way affect execution state in virtual EL2.   However, we must
+ * still ensure that virtual EL2 observes the same state of the EL1 registers
+ * as the normal VM's EL1 mode, so copy this state as needed on setup/restore.
+ */
+static void copy_shadow_non_trap_el1_state(struct kvm_vcpu *vcpu, bool setup)
+{
+	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(el1_non_trap_regs); i++) {
+		const int sr = el1_non_trap_regs[i];
+
+		if (setup)
+			s_sys_regs[sr] = vcpu_sys_reg(vcpu, sr);
+		else
+			vcpu_sys_reg(vcpu, sr) = s_sys_regs[sr];
+	}
+}
+
+static void sync_shadow_non_trap_el1_state(struct kvm_vcpu *vcpu)
+{
+	copy_shadow_non_trap_el1_state(vcpu, false);
+}
+
+static void flush_shadow_non_trap_el1_state(struct kvm_vcpu *vcpu)
+{
+	copy_shadow_non_trap_el1_state(vcpu, true);
+}
+
 static void flush_shadow_special_regs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
@@ -162,6 +214,7 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 	if (unlikely(vcpu_mode_el2(vcpu))) {
 		flush_shadow_special_regs(vcpu);
 		flush_shadow_el1_sysregs(vcpu);
+		flush_shadow_non_trap_el1_state(vcpu);
 		ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
 	} else {
 		flush_special_regs(vcpu);
@@ -176,9 +229,10 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
  */
 void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(vcpu_mode_el2(vcpu)))
+	if (unlikely(vcpu_mode_el2(vcpu))) {
 		sync_shadow_special_regs(vcpu);
-	else
+		sync_shadow_non_trap_el1_state(vcpu);
+	} else
 		sync_special_regs(vcpu);
 }
 
-- 
1.9.1
