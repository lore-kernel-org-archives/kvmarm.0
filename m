From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2] KVM: arm/arm64: vgic-v3: De-optimize VMCR save/restore when emulating a GICv2
Date: Wed, 19 Apr 2017 12:15:26 +0100
Message-ID: <20170419111526.21073-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

When emulating a GICv2-on-GICv3, special care must be taken to only
save/restore VMCR_EL2 when ICC_SRE_EL1.SRE is cleared. Otherwise,
all Group-0 interrupts end-up being delivered as FIQ, which is
probably not what the guest expects, as demonstrated here with
an unhappy EFI:

	FIQ Exception at 0x000000013BD21CC4

This means that we cannot perform the load/put trick when dealing
with VMCR_EL2 (because the host has SRE set), and we have to deal
with it in the world-switch.

Fortunately, this is not the most common case (modern guests should
be able to deal with GICv3 directly), and the performance is not worse
than what it was before the VMCR optimization.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
* From v1:
  - Move vgic_sre testing from vgic_{load,put} to vgic_v3_{load,put}

 virt/kvm/arm/hyp/vgic-v3-sr.c |  8 ++++++--
 virt/kvm/arm/vgic/vgic-v3.c   | 11 +++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 3d0b1ddb6929..91922c1eddc8 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -128,8 +128,10 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	 * Make sure stores to the GIC via the memory mapped interface
 	 * are now visible to the system register interface.
 	 */
-	if (!cpu_if->vgic_sre)
+	if (!cpu_if->vgic_sre) {
 		dsb(st);
+		cpu_if->vgic_vmcr = read_gicreg(ICH_VMCR_EL2);
+	}
 
 	if (used_lrs) {
 		int i;
@@ -205,11 +207,13 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	 * delivered as a FIQ to the guest, with potentially fatal
 	 * consequences. So we must make sure that ICC_SRE_EL1 has
 	 * been actually programmed with the value we want before
-	 * starting to mess with the rest of the GIC.
+	 * starting to mess with the rest of the GIC, and VMCR_EL2 in
+	 * particular.
 	 */
 	if (!cpu_if->vgic_sre) {
 		write_gicreg(0, ICC_SRE_EL1);
 		isb();
+		write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
 	}
 
 	val = read_gicreg(ICH_VTR_EL2);
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index bc7010db9f4d..df1503650300 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -373,12 +373,19 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
+	/*
+	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
+	 * is dependent on ICC_SRE_EL1.SRE, and we have to perform the
+	 * VMCR_EL2 save/restore in the world switch.
+	 */
+	if (likely(cpu_if->vgic_sre))
+		kvm_call_hyp(__vgic_v3_write_vmcr, cpu_if->vgic_vmcr);
 }
 
 void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
+	if (likely(cpu_if->vgic_sre))
+		cpu_if->vgic_vmcr = kvm_call_hyp(__vgic_v3_read_vmcr);
 }
-- 
2.11.0
