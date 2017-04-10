From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/2] KVM: arm/arm64: vgic-v3: De-optimize VMCR save/restore
 when emulating a GICv2
Date: Mon, 10 Apr 2017 10:19:43 +0100
Message-ID: <20170410091944.19963-2-marc.zyngier@arm.com>
References: <20170410091944.19963-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D1340D55
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 05:17:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q8LopqYe1oUi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Apr 2017 05:17:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEC7740C55
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 05:17:38 -0400 (EDT)
In-Reply-To: <20170410091944.19963-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
 virt/kvm/arm/hyp/vgic-v3-sr.c |  8 ++++++--
 virt/kvm/arm/vgic/vgic.c      | 26 ++++++++++++++++++++------
 2 files changed, 26 insertions(+), 8 deletions(-)

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
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 3d0979c30721..32205f2ba6ff 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -667,10 +667,20 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 	if (unlikely(!vgic_initialized(vcpu->kvm)))
 		return;
 
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	if (kvm_vgic_global_state.type == VGIC_V2) {
 		vgic_v2_load(vcpu);
-	else
-		vgic_v3_load(vcpu);
+	} else {
+		struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+		/*
+		 * If dealing with a GICv2 emulation on GICv3,
+		 * VMCR_EL2.VFIQen is dependent on ICC_SRE_EL1.SRE,
+		 * and we have to perform the VMCR_EL2 save/restore in
+		 * the world switch.
+		 */
+		if (likely(cpu_if->vgic_sre))
+			vgic_v3_load(vcpu);
+	}
 }
 
 void kvm_vgic_put(struct kvm_vcpu *vcpu)
@@ -678,10 +688,14 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 	if (unlikely(!vgic_initialized(vcpu->kvm)))
 		return;
 
-	if (kvm_vgic_global_state.type == VGIC_V2)
+	if (kvm_vgic_global_state.type == VGIC_V2) {
 		vgic_v2_put(vcpu);
-	else
-		vgic_v3_put(vcpu);
+	} else {
+		struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+
+		if (likely(cpu_if->vgic_sre))
+			vgic_v3_put(vcpu);
+	}
 }
 
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
-- 
2.11.0
