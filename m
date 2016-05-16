From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 13/56] KVM: arm/arm64: move GICv2 emulation defines into arm-gic-v3.h
Date: Mon, 16 May 2016 10:53:01 +0100
Message-ID: <1463392481-26583-14-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

As (some) GICv3 hosts can emulate a GICv2, some GICv2 specific masks
for the list register definition also apply to GICv3 LRs.
At the moment we have those definitions in the KVM VGICv3
implementation, so let's move them into the GICv3 header file to
have them automatically defined.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h | 5 +++++
 virt/kvm/arm/vgic-v3.c             | 8 +-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index d5d798b..ec938d1 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -276,6 +276,11 @@
 #define ICH_LR_PHYS_ID_SHIFT		32
 #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
 
+/* These are for GICv2 emulation only */
+#define GICH_LR_VIRTUALID		(0x3ffUL << 0)
+#define GICH_LR_PHYSID_CPUID_SHIFT	(10)
+#define GICH_LR_PHYSID_CPUID		(7UL << GICH_LR_PHYSID_CPUID_SHIFT)
+
 #define ICH_MISR_EOI			(1 << 0)
 #define ICH_MISR_U			(1 << 1)
 
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index c02a1b1..75b02fa 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -29,12 +29,6 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 
-/* These are for GICv2 emulation only */
-#define GICH_LR_VIRTUALID		(0x3ffUL << 0)
-#define GICH_LR_PHYSID_CPUID_SHIFT	(10)
-#define GICH_LR_PHYSID_CPUID		(7UL << GICH_LR_PHYSID_CPUID_SHIFT)
-#define ICH_LR_VIRTUALID_MASK		(BIT_ULL(32) - 1)
-
 static u32 ich_vtr_el2;
 
 static struct vgic_lr vgic_v3_get_lr(const struct kvm_vcpu *vcpu, int lr)
@@ -43,7 +37,7 @@ static struct vgic_lr vgic_v3_get_lr(const struct kvm_vcpu *vcpu, int lr)
 	u64 val = vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr];
 
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-		lr_desc.irq = val & ICH_LR_VIRTUALID_MASK;
+		lr_desc.irq = val & ICH_LR_VIRTUAL_ID_MASK;
 	else
 		lr_desc.irq = val & GICH_LR_VIRTUALID;
 
-- 
2.8.2

