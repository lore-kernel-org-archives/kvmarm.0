From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 4/6] KVM: arm/arm64: vgic-v2: Limit ITARGETSR bits to number of VCPUs
Date: Fri,  9 Dec 2016 15:53:29 +0000
Message-ID: <1481298811-30798-5-git-send-email-marc.zyngier@arm.com>
References: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Andre Przywara <andre.przywara@arm.com>, Longpeng <longpeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

The GICv2 spec says in section 4.3.12 that a "CPU targets field bit that
corresponds to an unimplemented CPU interface is RAZ/WI."
Currently we allow the guest to write any value in there and it can
read that back.
Mask the written value with the proper CPU mask to be spec compliant.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index b44b359..78e34bc 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -129,6 +129,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 				   unsigned long val)
 {
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
+	u8 cpu_mask = GENMASK(atomic_read(&vcpu->kvm->online_vcpus) - 1, 0);
 	int i;
 
 	/* GICD_ITARGETSR[0-7] are read-only */
@@ -141,7 +142,7 @@ static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
 
 		spin_lock(&irq->irq_lock);
 
-		irq->targets = (val >> (i * 8)) & 0xff;
+		irq->targets = (val >> (i * 8)) & cpu_mask;
 		target = irq->targets ? __ffs(irq->targets) : 0;
 		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
 
-- 
2.1.4

