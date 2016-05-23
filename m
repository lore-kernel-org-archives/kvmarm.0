From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/7] KVM: arm/arm64: vgic-v2: Clear all dirty LRs
Date: Mon, 23 May 2016 13:36:57 +0100
Message-ID: <1464007023-11736-2-git-send-email-marc.zyngier@arm.com>
References: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464007023-11736-1-git-send-email-marc.zyngier@arm.com>
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
 virt/kvm/arm/hyp/vgic-v2-sr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a3f12b3..3a3a699 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -100,12 +100,11 @@ static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
 			continue;
 
-		if (cpu_if->vgic_elrsr & (1UL << i)) {
+		if (cpu_if->vgic_elrsr & (1UL << i))
 			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
-			continue;
-		}
+		else
+			cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
 
-		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
 		writel_relaxed(0, base + GICH_LR0 + (i * 4));
 	}
 }
-- 
2.1.4

