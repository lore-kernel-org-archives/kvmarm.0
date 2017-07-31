From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 53/59] KVM: arm/arm64: GICv4: Hook vPE scheduling into vgic flush/sync
Date: Mon, 31 Jul 2017 18:26:31 +0100
Message-ID: <20170731172637.29355-54-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

The redistributor needs to be told which vPE is about to be run,
and tells us whether there is any pending VLPI on exit.

Let's add the scheduling calls to the vgic flush/sync functions,
allowing the VLPIs to be delivered to the guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v4.c | 24 ++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    |  4 ++++
 virt/kvm/arm/vgic/vgic.h    |  1 +
 3 files changed, 29 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 50721c4e3da5..0a8deefbcf1c 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -119,6 +119,30 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
+int vgic_v4_schedule(struct kvm_vcpu *vcpu, bool on)
+{
+	int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+
+	if (!vgic_is_v4_capable(vcpu->kvm) || !irq)
+		return 0;
+
+	/*
+	 * Before making the VPE resident, make sure the redistributor
+	 * expects us here.
+	 */
+	if (on) {
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
index dfac894f6f03..9ab52108989d 100644
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
index 1210bf4681dc..693b654acf4d 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -234,5 +234,6 @@ int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 bool vgic_is_v4_capable(struct kvm *kvm);
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
+int vgic_v4_schedule(struct kvm_vcpu *vcpu, bool on);
 
 #endif
-- 
2.11.0
