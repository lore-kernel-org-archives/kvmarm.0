From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 21/26] KVM: arm/arm64: GICv4: Hook vPE scheduling into vgic
 flush/sync
Date: Fri, 27 Oct 2017 15:28:50 +0100
Message-ID: <20171027142855.21584-22-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00A2B49D37
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sQNA+yz3Mcg8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:28:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B356449D6C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:45 -0400 (EDT)
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The redistributor needs to be told which vPE is about to be run,
and tells us whether there is any pending VLPI on exit.

Let's add the scheduling calls to the vgic flush/sync functions,
allowing the VLPIs to be delivered to the guest.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v4.c | 39 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    |  4 ++++
 virt/kvm/arm/vgic/vgic.h    |  2 ++
 3 files changed, 45 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 1a2f2fcdfa67..d7fe610bb1f5 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -131,6 +131,45 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
+int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	if (!vgic_supports_direct_msis(vcpu->kvm))
+		return 0;
+
+	return its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, false);
+}
+
+int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+	int err;
+
+	if (!vgic_supports_direct_msis(vcpu->kvm))
+		return 0;
+
+	/*
+	 * Before making the VPE resident, make sure the redistributor
+	 * corresponding to our current CPU expects us here. See the
+	 * doc in drivers/irqchip/irq-gic-v4.c to understand how this
+	 * turns into a VMOVP command at the ITS level.
+	 */
+	err = irq_set_affinity(irq, cpumask_of(smp_processor_id()));
+	if (err)
+		return err;
+
+	err = its_schedule_vpe(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe, true);
+	if (err)
+		return err;
+
+	/*
+	 * Now that the VPE is resident, let's get rid of a potential
+	 * doorbell interrupt that would still be pending.
+	 */
+	err = irq_set_irqchip_state(irq, IRQCHIP_STATE_PENDING, false);
+
+	return err;
+}
+
 static struct vgic_its *vgic_get_its(struct kvm *kvm,
 				     struct kvm_kernel_irq_routing_entry *irq_entry)
 {
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 0691a2250949..71ca0ff1b35a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -709,6 +709,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
+	WARN_ON(vgic_v4_sync_hwstate(vcpu));
+
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
@@ -721,6 +723,8 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vgic_v4_flush_hwstate(vcpu));
+
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c4105f613f57..9cafb61b79af 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -243,5 +243,7 @@ struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 bool vgic_supports_direct_msis(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
+int vgic_v4_sync_hwstate(struct kvm_vcpu *vcpu);
+int vgic_v4_flush_hwstate(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.11.0
