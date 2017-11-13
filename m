From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 23/27] KVM: arm/arm64: GICv4: Prevent userspace from changing doorbell affinity
Date: Mon, 13 Nov 2017 10:17:48 +0100
Message-ID: <20171113091752.10663-24-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We so far allocate the doorbell interrupts without taking any
special measure regarding the affinity of these interrupts. We
simply move them around as required when the vcpu gets scheduled
on a different CPU.

But that's counting without userspace (and the evil irqbalance) that
can try and move the VPE interrupt around, causing the ITS code
to emit VMOVP commands and remap the doorbell to another redistributor.
Worse, this can happen while the vcpu is running, causing all kind
of trouble if the VPE is already resident, and we end-up in UNPRED
territory.

So let's take a definitive action and prevent userspace from messing
with us. This is just a matter of adding IRQ_NO_BALANCING to the
set of flags we already have, letting the kernel in sole control
of the affinity.

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v4.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index c9cec01008c2..bf874dd01fc0 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -23,6 +23,8 @@
 
 #include "vgic.h"
 
+#define DB_IRQ_FLAGS	(IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY | IRQ_NO_BALANCING)
+
 static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 {
 	struct kvm_vcpu *vcpu = info;
@@ -83,7 +85,7 @@ int vgic_v4_init(struct kvm *kvm)
 		 * doorbell could kick us out of the guest too
 		 * early...
 		 */
-		irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
+		irq_set_status_flags(irq, DB_IRQ_FLAGS);
 		ret = request_irq(irq, vgic_v4_doorbell_handler,
 				  0, "vcpu", vcpu);
 		if (ret) {
@@ -121,7 +123,7 @@ void vgic_v4_teardown(struct kvm *kvm)
 		struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
 		int irq = its_vm->vpes[i]->irq;
 
-		irq_clear_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
+		irq_clear_status_flags(irq, DB_IRQ_FLAGS);
 		free_irq(irq, vcpu);
 	}
 
-- 
2.14.2
