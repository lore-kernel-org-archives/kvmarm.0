From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 2/7] KVM: arm/arm64: vgic-v3: Clear all dirty LRs
Date: Wed, 25 May 2016 15:26:34 +0100
Message-ID: <1464186399-16604-3-git-send-email-marc.zyngier@arm.com>
References: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464186399-16604-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When saving the state of the list registers, it is critical to
reset them zero, as we could otherwise leave unexpected EOI
interrupts pending for virtual level interrupts.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index fff7cd4..3129df9 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -190,12 +190,11 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 			if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
 				continue;
 
-			if (cpu_if->vgic_elrsr & (1 << i)) {
+			if (cpu_if->vgic_elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
-				continue;
-			}
+			else
+				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 
-			cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
 			__gic_v3_set_lr(0, i);
 		}
 
-- 
2.1.4

