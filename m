From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 48/52] KVM: arm/arm64: GICv4: Add doorbell interrupt
 handling
Date: Wed, 28 Jun 2017 16:04:07 +0100
Message-ID: <20170628150411.15846-49-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9828A49C26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wx-XyLZThBUy for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE44F49C3E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:49 -0400 (EDT)
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

When a vPE is not running, the delivery of a VLPI results in a
doorbell interrupt to be delivered. Let's handle this interrupt
and update the pending_last flag that indicates that VLPIs are
pending.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v4.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index a2d1a6db0490..fe0d0a8ed469 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -21,6 +21,14 @@
 
 #include "vgic.h"
 
+static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
+{
+	struct kvm_vcpu *vcpu = info;
+
+	vcpu->arch.vgic_cpu.vgic_v3.its_vpe.pending_last = true;
+	return IRQ_HANDLED;
+}
+
 int vgic_v4_init(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
@@ -47,12 +55,34 @@ int vgic_v4_init(struct kvm *kvm)
 		return ret;
 	}
 
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		int irq = dist->its_vm.vpes[i]->irq;
+
+		ret = request_irq(irq, vgic_v4_doorbell_handler,
+				  0, "vcpu", vcpu);
+		if (ret) {
+			kvm_err("failed to allocate vcpu IRQ%d\n", irq);
+			dist->its_vm.nr_vpes = i;
+			break;
+		}
+	}
+
+	if (ret)
+		vgic_v4_teardown(kvm);
+
 	return ret;
 }
 
 void vgic_v4_teardown(struct kvm *kvm)
 {
 	struct its_vm *its_vm = &kvm->arch.vgic.its_vm;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	for (i = 0; i < its_vm->nr_vpes; i++) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		free_irq(its_vm->vpes[i]->irq, vcpu);
+	}
 
 	its_free_vcpu_irqs(its_vm);
 	kfree(its_vm->vpes);
-- 
2.11.0
