From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 20/26] KVM: arm/arm64: GICv4: Use the doorbell interrupt as
 an unblocking source
Date: Fri,  6 Oct 2017 16:33:55 +0100
Message-ID: <20171006153401.5481-21-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E28549C23
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i9xwFl0O2KSQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Oct 2017 11:34:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4014D49C3C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Oct 2017 11:34:18 -0400 (EDT)
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The doorbell interrupt is only useful if the vcpu is blocked on WFI.
In all other cases, recieving a doorbell interrupt is just a waste
of cycles.

So let's only enable the doorbell if a vcpu is getting blocked,
and disable it when it is unblocked. This is very similar to
what we're doing for the background timer.

Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h      |  3 +++
 virt/kvm/arm/arm.c          |  2 ++
 virt/kvm/arm/vgic/vgic-v4.c | 18 ++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2f750c770bf2..8c896540a72c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -381,4 +381,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
 				 struct kvm_kernel_irq_routing_entry *irq_entry);
 
+void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
+void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 8388c1cc23f6..092a4ec03e57 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -316,11 +316,13 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	kvm_timer_schedule(vcpu);
+	kvm_vgic_v4_enable_doorbell(vcpu);
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	kvm_timer_unschedule(vcpu);
+	kvm_vgic_v4_disable_doorbell(vcpu);
 }
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 2c250ee37878..5ee69aec990a 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -235,3 +235,21 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 	mutex_unlock(&its->its_lock);
 	return ret;
 }
+
+void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vgic_supports_direct_msis(vcpu->kvm)) {
+		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+		if (irq)
+			enable_irq(irq);
+	}
+}
+
+void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vgic_supports_direct_msis(vcpu->kvm)) {
+		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+		if (irq)
+			disable_irq(irq);
+	}
+}
-- 
2.14.1
