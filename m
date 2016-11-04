From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/3] KVM: arm/arm64: vgic: Kick VCPUs when queueing already pending IRQs
Date: Fri,  4 Nov 2016 18:36:38 +0000
Message-ID: <20161104183638.28137-4-marc.zyngier@arm.com>
References: <20161104183638.28137-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161104183638.28137-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shih-Wei Li <shihwei@cs.columbia.edu>

In cases like IPI, we could be queueing an interrupt for a VCPU
that is already running and is not about to exit, because the
VCPU has entered the VM with the interrupt pending and would
not trap on EOI'ing that interrupt. This could result to delays
in interrupt deliveries or even loss of interrupts.
To guarantee prompt interrupt injection, here we have to try to
kick the VCPU.

Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 2893d5ba523a..6440b56ec90e 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -273,6 +273,18 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
 		 * no more work for us to do.
 		 */
 		spin_unlock(&irq->irq_lock);
+
+		/*
+		 * We have to kick the VCPU here, because we could be
+		 * queueing an edge-triggered interrupt for which we
+		 * get no EOI maintenance interrupt. In that case,
+		 * while the IRQ is already on the VCPU's AP list, the
+		 * VCPU could have EOI'ed the original interrupt and
+		 * won't see this one until it exits for some other
+		 * reason.
+		 */
+		if (vcpu)
+			kvm_vcpu_kick(vcpu);
 		return false;
 	}
 
-- 
2.10.1

