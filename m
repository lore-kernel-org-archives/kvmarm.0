From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v4 14/26] arm64: kvm: Unmask PMR before entering guest
Date: Fri, 25 May 2018 10:49:20 +0100
Message-ID: <1527241772-48007-15-git-send-email-julien.thierry@arm.com>
References: <1527241772-48007-1-git-send-email-julien.thierry@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527241772-48007-1-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, daniel.thompson@linaro.org, joel@joelfernandes.org, marc.zyngier@arm.com, mark.rutland@arm.com, christoffer.dall@arm.com, james.morse@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Julien Thierry <julien.thierry@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Interrupts masked by ICC_PMR_EL1 will not be signaled to the CPU. This
means that hypervisor will not receive masked interrupts while running a
guest.

Avoid this by making sure ICC_PMR_EL1 is unmasked when we enter a guest.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_host.h | 12 ++++++++++++
 arch/arm64/kvm/hyp/switch.c       | 17 +++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 469de8a..bfd9e5b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -24,6 +24,7 @@
 
 #include <linux/types.h>
 #include <linux/kvm_types.h>
+#include <asm/arch_gicv3.h>
 #include <asm/cpufeature.h>
 #include <asm/daifflags.h>
 #include <asm/fpsimd.h>
@@ -433,6 +434,17 @@ static inline void kvm_fpsimd_flush_cpu_state(void)
 static inline void kvm_arm_vhe_guest_enter(void)
 {
 	local_daif_mask();
+
+	/*
+	 * Having IRQs masked via PMR when entering the guest means the GIC
+	 * will not signal the CPU of interrupts of lower priority, and the
+	 * only way to get out will be via guest exceptions.
+	 * Naturally, we want to avoid this.
+	 */
+	if (gic_prio_masking_enabled()) {
+		gic_write_pmr(ICC_PMR_EL1_UNMASKED);
+		dsb(sy);
+	}
 }
 
 static inline void kvm_arm_vhe_guest_exit(void)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d964523..f00a04c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -21,6 +21,7 @@
 
 #include <kvm/arm_psci.h>
 
+#include <asm/arch_gicv3.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
@@ -442,6 +443,19 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	bool fp_enabled;
 	u64 exit_code;
+	u32 host_pmr = ICC_PMR_EL1_UNMASKED;
+
+	/*
+	 * Having IRQs masked via PMR when entering the guest means the GIC
+	 * will not signal the CPU of interrupts of lower priority, and the
+	 * only way to get out will be via guest exceptions.
+	 * Naturally, we want to avoid this.
+	 */
+	if (gic_prio_masking_enabled()) {
+		host_pmr = gic_read_pmr();
+		gic_write_pmr(ICC_PMR_EL1_UNMASKED);
+		dsb(sy);
+	}
 
 	vcpu = kern_hyp_va(vcpu);
 
@@ -496,6 +510,9 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	 */
 	__debug_switch_to_host(vcpu);
 
+	if (gic_prio_masking_enabled())
+		gic_write_pmr(host_pmr);
+
 	return exit_code;
 }
 
-- 
1.9.1
