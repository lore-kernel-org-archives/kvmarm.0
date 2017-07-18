From: Jintack Lim <jintack.lim@linaro.org>
Subject: [RFC PATCH v2 13/38] KVM: arm64: Create shadow EL1 registers
Date: Tue, 18 Jul 2017 11:58:39 -0500
Message-ID: <1500397144-16232-14-git-send-email-jintack.lim@linaro.org>
References: <1500397144-16232-1-git-send-email-jintack.lim@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 791C649C10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P79lZJdJS+JG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 12:59:09 -0400 (EDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com
 [209.85.223.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95A8E49C12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 12:59:08 -0400 (EDT)
Received: by mail-io0-f174.google.com with SMTP id k71so16779640iod.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:59:57 -0700 (PDT)
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

From: Christoffer Dall <christoffer.dall@linaro.org>

When entering virtual EL2, we need to reflect virtual EL2 register
states to corresponding shadow EL1 registers. We can simply copy them if
their formats are identical.  Otherwise, we need to convert EL2 register
state to EL1 register state.

When entering EL1/EL0, we need a special care for MPIDR_EL1.  Read of
this register returns the value of VMPIDR_EL2, so when a VM has the
virtual EL2, the value of MPIDR_EL1 should come from the virtual
VMPIDR_EL2.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
---
 arch/arm64/kvm/context.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/arch/arm64/kvm/context.c b/arch/arm64/kvm/context.c
index 2645787..e965049 100644
--- a/arch/arm64/kvm/context.c
+++ b/arch/arm64/kvm/context.c
@@ -17,6 +17,74 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/esr.h>
+
+struct el1_el2_map {
+	enum vcpu_sysreg	el1;
+	enum vcpu_sysreg	el2;
+};
+
+/*
+ * List of EL2 registers which can be directly applied to EL1 registers to
+ * emulate running EL2 in EL1.
+ */
+static const struct el1_el2_map el1_el2_map[] = {
+	{ AMAIR_EL1, AMAIR_EL2 },
+	{ MAIR_EL1, MAIR_EL2 },
+	{ TTBR0_EL1, TTBR0_EL2 },
+	{ ACTLR_EL1, ACTLR_EL2 },
+	{ AFSR0_EL1, AFSR0_EL2 },
+	{ AFSR1_EL1, AFSR1_EL2 },
+	{ SCTLR_EL1, SCTLR_EL2 },
+	{ VBAR_EL1, VBAR_EL2 },
+};
+
+static inline u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
+{
+	return ((tcr_el2 & TCR_EL2_PS_MASK) >> TCR_EL2_PS_SHIFT)
+		<< TCR_IPS_SHIFT;
+}
+
+static inline u64 cptr_to_cpacr(u64 cptr_el2)
+{
+	u64 cpacr_el1 = 0;
+
+	if (!(cptr_el2 & CPTR_EL2_TFP))
+		cpacr_el1 |= CPACR_EL1_FPEN;
+	if (cptr_el2 & CPTR_EL2_TTA)
+		cpacr_el1 |= CPACR_EL1_TTA;
+
+	return cpacr_el1;
+}
+
+static void flush_shadow_el1_sysregs(struct kvm_vcpu *vcpu)
+{
+	u64 *s_sys_regs = vcpu->arch.ctxt.shadow_sys_regs;
+	u64 tcr_el2;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(el1_el2_map); i++) {
+		const struct el1_el2_map *map = &el1_el2_map[i];
+
+		s_sys_regs[map->el1] = vcpu_sys_reg(vcpu, map->el2);
+	}
+
+	tcr_el2 = vcpu_sys_reg(vcpu, TCR_EL2);
+	s_sys_regs[TCR_EL1] =
+		TCR_EPD1 |	/* disable TTBR1_EL1 */
+		((tcr_el2 & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
+		tcr_el2_ips_to_tcr_el1_ps(tcr_el2) |
+		(tcr_el2 & TCR_EL2_TG0_MASK) |
+		(tcr_el2 & TCR_EL2_ORGN0_MASK) |
+		(tcr_el2 & TCR_EL2_IRGN0_MASK) |
+		(tcr_el2 & TCR_EL2_T0SZ_MASK);
+
+	/* Rely on separate VMID for VA context, always use ASID 0 */
+	s_sys_regs[TTBR0_EL1] &= ~GENMASK_ULL(63, 48);
+	s_sys_regs[TTBR1_EL1] = 0;
+
+	s_sys_regs[CPACR_EL1] = cptr_to_cpacr(vcpu_sys_reg(vcpu, CPTR_EL2));
+}
 
 static void flush_shadow_special_regs(struct kvm_vcpu *vcpu)
 {
@@ -72,6 +140,17 @@ static void sync_special_regs(struct kvm_vcpu *vcpu)
 	ctxt->gp_regs.spsr[KVM_SPSR_EL1] = ctxt->hw_spsr_el1;
 }
 
+static void setup_mpidr_el1(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * A non-secure EL0 or EL1 read of MPIDR_EL1 returns
+	 * the value of VMPIDR_EL2. For nested virtualization,
+	 * it comes from the virtual VMPIDR_EL2.
+	 */
+	if (nested_virt_in_use(vcpu))
+		vcpu_sys_reg(vcpu, MPIDR_EL1) = vcpu_sys_reg(vcpu, VMPIDR_EL2);
+}
+
 /**
  * kvm_arm_setup_shadow_state -- prepare shadow state based on emulated mode
  * @vcpu: The VCPU pointer
@@ -82,9 +161,11 @@ void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
 
 	if (unlikely(vcpu_mode_el2(vcpu))) {
 		flush_shadow_special_regs(vcpu);
+		flush_shadow_el1_sysregs(vcpu);
 		ctxt->hw_sys_regs = ctxt->shadow_sys_regs;
 	} else {
 		flush_special_regs(vcpu);
+		setup_mpidr_el1(vcpu);
 		ctxt->hw_sys_regs = ctxt->sys_regs;
 	}
 }
-- 
1.9.1
