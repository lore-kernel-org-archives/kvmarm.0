From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 49/52] KVM: arm/arm64: GICv4: Hook vPE scheduling into vgic
 flush/sync
Date: Wed, 28 Jun 2017 16:04:08 +0100
Message-ID: <20170628150411.15846-50-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F248240D19
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id USXPdJMq-YS1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0FBB49C50
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:51 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

The redistributor needs to be told which vPE is about to be run,
and tells us whether there is any pending VLPI on exit.

Let's add the scheduling calls to the vgic flush/sync functions,
allowing the VLPIs to be delivered to the guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v4.c | 23 +++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    |  4 ++++
 virt/kvm/arm/vgic/vgic.h    |  1 +
 3 files changed, 28 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index fe0d0a8ed469..6ede64be94f1 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -88,6 +88,29 @@ void vgic_v4_teardown(struct kvm *kvm)
 	kfree(its_vm->vpes);
 }
 
+int vgic_v4_schedule(struct kvm_vcpu *vcpu, bool on)
+{
+	if (!(kvm_vgic_global_state.has_gicv4 && vgic_has_its(vcpu->kvm)))
+		return 0;
+
+	/*
+	 * Before making the VPE resident, make sure the redistributor
+	 * expects us here.
+	 */
+	if (on) {
+		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+		int err;
+
+		err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
+		if (err) {
+			kvm_err("failed irq_set_affinity IRQ%d (%d)\n", irq, err);
+			return err;
+		}
+	}
+
+	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, on);
+}
+
 static struct vgic_its *vgic_get_its(struct kvm *kvm,
 				     struct kvm_kernel_irq_routing_entry *irq_entry)
 {
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index a96e566905d2..2106e4c06a12 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -721,6 +721,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
+	WARN_ON(vgic_v4_schedule(vcpu, false));
+
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
@@ -733,6 +735,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vgic_v4_schedule(vcpu, true));
+
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 974e382297f9..3ebb6c4443a7 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -233,5 +233,6 @@ int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
+int vgic_v4_schedule(struct kvm_vcpu *vcpu, bool on);
 
 #endif
-- 
2.11.0
