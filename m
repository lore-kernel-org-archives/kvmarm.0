From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 7/7] arm64: KVM: vgic-v3: Relax synchronization when SRE==1
Date: Wed, 25 May 2016 15:26:39 +0100
Message-ID: <1464186399-16604-8-git-send-email-marc.zyngier@arm.com>
References: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The GICv3 backend of the vgic is quite barrier heavy, in order
to ensure synchronization of the system registers and the
memory mapped view for a potential GICv2 guest.

But when the guest is using a GICv3 model, there is absolutely
no need to execute all these heavy barriers, and it is actually
beneficial to avoid them altogether.

This patch makes the synchonization conditional, and ensures
that we do not change the EL1 SRE settings if we do not need to.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 40c3b4c..5f8f80b 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -169,7 +169,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	 * Make sure stores to the GIC via the memory mapped interface
 	 * are now visible to the system register interface.
 	 */
-	dsb(st);
+	if (!cpu_if->vgic_sre)
+		dsb(st);
 
 	cpu_if->vgic_vmcr  = read_gicreg(ICH_VMCR_EL2);
 
@@ -235,8 +236,12 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 
 	val = read_gicreg(ICC_SRE_EL2);
 	write_gicreg(val | ICC_SRE_EL2_ENABLE, ICC_SRE_EL2);
-	isb(); /* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
-	write_gicreg(1, ICC_SRE_EL1);
+
+	if (!cpu_if->vgic_sre) {
+		/* Make sure ENABLE is set at EL2 before setting SRE at EL1 */
+		isb();
+		write_gicreg(1, ICC_SRE_EL1);
+	}
 }
 
 void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
@@ -255,8 +260,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	 * been actually programmed with the value we want before
 	 * starting to mess with the rest of the GIC.
 	 */
-	write_gicreg(cpu_if->vgic_sre, ICC_SRE_EL1);
-	isb();
+	if (!cpu_if->vgic_sre) {
+		write_gicreg(0, ICC_SRE_EL1);
+		isb();
+	}
 
 	val = read_gicreg(ICH_VTR_EL2);
 	max_lr_idx = vtr_to_max_lr_idx(val);
@@ -305,8 +312,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	 * (re)distributors. This ensure the guest will read the
 	 * correct values from the memory-mapped interface.
 	 */
-	isb();
-	dsb(sy);
+	if (!cpu_if->vgic_sre) {
+		isb();
+		dsb(sy);
+	}
 	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
 
 	/*
-- 
2.1.4

