From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic: Don't notify EOI for non-SPIs
Date: Thu,  1 Dec 2016 09:25:41 +0000
Message-ID: <1480584341-32340-2-git-send-email-marc.zyngier@arm.com>
References: <1480584341-32340-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1480584341-32340-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When we inject a level triggerered interrupt (and unless it
is backed by the physical distributor - timer style), we request
a maintenance interrupt. Part of the processing for that interrupt
is to feed to the rest of KVM (and to the eventfd subsystem) the
information that the interrupt has been EOIed.

But that notification only makes sense for SPIs, and not PPIs
(such as the PMU interrupt). Skip over the notification if
the interrupt is not an SPI.

Cc: stable@vger.kernel.org # 4.7+
Fixes: 140b086dd197 ("KVM: arm/arm64: vgic-new: Add GICv2 world switch backend")
Fixes: 59529f69f504 ("KVM: arm/arm64: vgic-new: Add GICv3 world switch backend")
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 6 ++++--
 virt/kvm/arm/vgic/vgic-v3.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 0a063af..9bab867 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -50,8 +50,10 @@ void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu)
 
 			WARN_ON(cpuif->vgic_lr[lr] & GICH_LR_STATE);
 
-			kvm_notify_acked_irq(vcpu->kvm, 0,
-					     intid - VGIC_NR_PRIVATE_IRQS);
+			/* Only SPIs require notification */
+			if (vgic_valid_spi(vcpu->kvm, intid))
+				kvm_notify_acked_irq(vcpu->kvm, 0,
+						     intid - VGIC_NR_PRIVATE_IRQS);
 		}
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9f0dae3..5c9f974 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -41,8 +41,10 @@ void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 
 			WARN_ON(cpuif->vgic_lr[lr] & ICH_LR_STATE);
 
-			kvm_notify_acked_irq(vcpu->kvm, 0,
-					     intid - VGIC_NR_PRIVATE_IRQS);
+			/* Only SPIs require notification */
+			if (vgic_valid_spi(vcpu->kvm, intid))
+				kvm_notify_acked_irq(vcpu->kvm, 0,
+						     intid - VGIC_NR_PRIVATE_IRQS);
 		}
 
 		/*
-- 
2.1.4

