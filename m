From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 31/38] KVM: arm64: Manage the shadow states when
 virtual E2H bit enabled
Date: Tue, 18 Jul 2017 11:58:57 -0500
Message-ID: <1500397144-16232-32-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C467E40CE9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a2khrOMOlD-n for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:45 -0400 (EDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
 [209.85.223.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 117E649C79
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:43 -0400 (EDT)
Received: by mail-io0-f181.google.com with SMTP id 5so16511227iow.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 10:00:32 -0700 (PDT)
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

When creating the shadow context for the virtual EL2 execution, we can
directly copy the EL2 register states to the shadow EL1 register states
if the virtual HCR_EL2.E2H bit is set. This is because EL1 and EL2
system register formats compatible with E2H=1.

Now that we allow the virtual EL2 modify its EL2 registers without trap
via the physical EL1 system register accesses, we need to reflect the
changes made to the EL1 system registers to the virtual EL2 register
states. This is not required to the virtual EL2 without VHE, since the
virtual EL2 should always use _EL2 accessors, which traps to EL2.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/context.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index 39bd92d..9947bc8 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -39,6 +39,27 @@ struct el1_el2_map {
 	{ VBAR_EL1, VBAR_EL2 },
 };
 
+/*
+ * List of pair of EL1/EL2 registers which are used to access real EL2
+ * registers in EL2 with E2H bit set.
+ */
+static const struct el1_el2_map vhe_map[] = {
+	{ SCTLR_EL1, SCTLR_EL2 },
+	{ CPACR_EL1, CPTR_EL2 },
+	{ TTBR0_EL1, TTBR0_EL2 },
+	{ TTBR1_EL1, TTBR1_EL2 },
+	{ TCR_EL1, TCR_EL2},
+	{ AFSR0_EL1, AFSR0_EL2 },
+	{ AFSR1_EL1, AFSR1_EL2 },
+	{ ESR_EL1, ESR_EL2},
+	{ FAR_EL1, FAR_EL2},
+	{ MAIR_EL1, MAIR_EL2 },
+	{ AMAIR_EL1, AMAIR_EL2 },
+	{ VBAR_EL1, VBAR_EL2 },
+	{ CONTEXTIDR_EL1, CONTEXTIDR_EL2 },
+	{ CNTKCTL_EL1, CNTHCTL_EL2 },
+};
+
 static inline u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
 {
 	return ((tcr_el2 & TCR_EL2_PS_MASK) >> TCR_EL2_PS_SHIFT)
@@ -57,7 +78,27 @@ static inline u64 cptr_to_cpacr(u64 cptr_el2)
 	return cpacr_el1;
 }
 
-static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
+static void sync_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
+{
+	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
+	int i;
+
+	/*
+	 * In the virtual EL2 without VHE no EL1 system registers can't be
+	 * changed without trap except el1_non_trap_regs[]. So we have nothing
+	 * to sync on exit from a guest.
+	 */
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(vhe_map); i++) {
+		const struct el1_el2_map *map = &vhe_map[i];
+
+		vcpu_sys_reg(vcpu, map->el2) = s_sys_regs[map->el1];
+	}
+}
+
+static void flush_shadow_el1_sysregs_nvhe(struct kvm_vcpu *vcpu)
 {
 	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
 	u64 tcr_el2;
@@ -86,6 +127,29 @@ static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
 	s_sys_regs[CPACR_EL1] = cptr_to_cpacr(vcpu_sys_reg(vcpu, CPTR_EL2));
 }
 
+static void flush_shadow_el1_sysregs_vhe(struct kvm_vcpu *vcpu)
+{
+	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
+	int i;
+
+	/*
+	 * When e2h bit is set, EL2 registers becomes compatible
+	 * with corrensponding EL1 registers. So, no conversion required.
+	 */
+	for (i = 0; i < ARRAY_SIZE(vhe_map); i++) {
+		const struct el1_el2_map *map = &vhe_map[i];
+
+		s_sys_regs[map->el1] = vcpu_sys_reg(vcpu, map->el2);
+	}
+}
+
+static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_el2_e2h_is_set(vcpu))
+		flush_shadow_el1_sysregs_vhe(vcpu);
+	else
+		flush_shadow_el1_sysregs_nvhe(vcpu);
+}
 
 /*
  * List of EL0 and EL1 registers which we allow the virtual EL2 mode to access
@@ -247,6 +311,7 @@ void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
 	if (unlikely(is_hyp_ctxt(vcpu))) {
 		sync_shadow_special_regs(vcpu);
 		sync_shadow_non_trap_el1_state(vcpu);
+		sync_shadow_el1_sysregs(vcpu);
 	} else
 		sync_special_regs(vcpu);
 }
-- 
1.9.1
