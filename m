From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] arm/arm64: KVM: VGIC: limit ITARGETSR bits to number of VCPUs
Date: Tue, 15 Nov 2016 14:27:49 +0000
Message-ID: <20161115142749.19955-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The GICv2 spec says in section 4.3.12 that a "CPU targets field bit that
corresponds to an unimplemented CPU interface is RAZ/WI."
Currently we allow the guest to write any value in there and it can
read that back.
Mask the written value with the proper CPU mask to be spec compliant.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index b44b359..e59d4c7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -129,6 +129,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 				   unsigned long val)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
+	u8 cpu_mask = (1 << atomic_read(&vcpu->kvm->online_vcpus)) - 1;
 	int i;
 
 	/* GICD_ITARGETSR[0-7] are read-only */
@@ -141,7 +142,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 
 		spin_lock(&irq->irq_lock);
 
-		irq->targets = (val >> (i * 8)) & 0xff;
+		irq->targets = ((val >> (i * 8)) & 0xff) & cpu_mask;
 		target = irq->targets ? __ffs(irq->targets) : 0;
 		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
 
-- 
2.9.0

