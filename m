From: John Gong <johngong0791@gmail.com>
Subject: [PATCH] KVM: arm64: fix potential bug
Date: Tue, 12 Mar 2019 08:32:41 +0800
Message-ID: <20190312003243.6712-1-johngong0791@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com
Cc: Shengmin Gong <shengmin.gong@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, Julien Thierry <julien.thierry@arm.com>, Jia He <hejianet@gmail.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Since intid always >= VGIC_NR_PRIVATE_IRQS, so then even vcpu == NULL,
it never return -EINVAL.

Signed-off-by: Shengmin Gong <shengmin.gong@gmail.com>
Signed-off-by: John Gong <johngong0791@gmail.com>
---
 virt/kvm/arm/vgic/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index abd9c7352677..d3cb1ce880e2 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -424,7 +424,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 		return ret;
 
 	vcpu = kvm_get_vcpu(kvm, cpuid);
-	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
+	if (!vcpu)
 		return -EINVAL;
 
 	irq = vgic_get_irq(kvm, vcpu, intid);
-- 
2.17.1
