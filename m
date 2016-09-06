From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 19/19] arm64: KVM: Inject a vSerror if detecting a bad GICV access at EL2
Date: Tue,  6 Sep 2016 14:02:17 +0100
Message-ID: <1473166937-15271-20-git-send-email-marc.zyngier@arm.com>
References: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1473166937-15271-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If, when proxying a GICV access at EL2, we detect that the guest is
doing something silly, report an EL1 SError instead ofgnoring the
access.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 +-
 arch/arm64/kvm/hyp/switch.c      | 18 +++++++++++++++---
 virt/kvm/arm/hyp/vgic-v2-sr.c    | 21 ++++++++++++++++-----
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 88ec3ac..b18e852 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,7 +123,7 @@ typeof(orig) * __hyp_text fname(void)					\
 
 void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
-bool __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
+int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 1233a55..194184c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -311,9 +311,21 @@ again:
 			!kvm_vcpu_dabt_isextabt(vcpu) &&
 			!kvm_vcpu_dabt_iss1tw(vcpu);
 
-		if (valid && __vgic_v2_perform_cpuif_access(vcpu)) {
-			__skip_instr(vcpu);
-			goto again;
+		if (valid) {
+			int ret = __vgic_v2_perform_cpuif_access(vcpu);
+
+			if (ret == 1) {
+				__skip_instr(vcpu);
+				goto again;
+			}
+
+			if (ret == -1) {
+				/* Promote an illegal access to an SError */
+				__skip_instr(vcpu);
+				exit_code = ARM_EXCEPTION_EL1_SERROR;
+			}
+
+			/* 0 falls through to be handler out of EL2 */
 		}
 	}
 
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a052f20..c8aeb7b 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -170,7 +170,18 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 }
 
 #ifdef CONFIG_ARM64
-bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
+/*
+ * __vgic_v2_perform_cpuif_access -- perform a GICV access on behalf of the
+ *				     guest.
+ *
+ * @vcpu: the offending vcpu
+ *
+ * Returns:
+ *  1: GICV access successfully performed
+ *  0: Not a GICV access
+ * -1: Illegal GICV access
+ */
+int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
@@ -185,15 +196,15 @@ bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	/* If not for GICV, move on */
 	if (fault_ipa <  vgic->vgic_cpu_base ||
 	    fault_ipa >= (vgic->vgic_cpu_base + KVM_VGIC_V2_CPU_SIZE))
-		return false;
+		return 0;
 
 	/* Reject anything but a 32bit access */
 	if (kvm_vcpu_dabt_get_as(vcpu) != sizeof(u32))
-		return false;
+		return -1;
 
 	/* Not aligned? Don't bother */
 	if (fault_ipa & 3)
-		return false;
+		return -1;
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
 	addr  = kern_hyp_va((kern_hyp_va(&kvm_vgic_global_state))->vcpu_base_va);
@@ -210,6 +221,6 @@ bool __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 							       sizeof(u32)));
 	}
 
-	return true;
+	return 1;
 }
 #endif
-- 
2.1.4

