From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm/arm64: move GICv2 emulation defines into arm-gic-v3.h
Date: Wed,  4 May 2016 15:21:29 +0100
Message-ID: <1462371689-26046-1-git-send-email-andre.przywara@arm.com>
References: <5729FF19.3030205@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5729FF19.3030205@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

As (some) GICv3 hosts can emulate a GICv2, some GICv2 specific masks
for the list register definition also apply to GICv3 LRs.
At the moment we have those definitions in the KVM VGICv3
implementation, so let's move them into the GICv3 header file to
have them automatically defined.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
... and then just remove the #include <arm-gic.h> from vgic/vgic-v3.c.

Does that make sense?

Cheers,
Andre.

 include/linux/irqchip/arm-gic-v3.h | 5 +++++
 virt/kvm/arm/vgic-v3.c             | 8 +-------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 56fd2c5..35e93cf 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -277,6 +277,11 @@
 #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
 #define ICH_LR_PRIORITY_SHIFT		48
 
+/* These are for GICv2 emulation only */
+#define GICH_LR_VIRTUALID		(0x3ffUL << 0)
+#define GICH_LR_PHYSID_CPUID_SHIFT	(10)
+#define GICH_LR_PHYSID_CPUID		(7UL << GICH_LR_PHYSID_CPUID_SHIFT)
+
 #define ICH_MISR_EOI			(1 << 0)
 #define ICH_MISR_U			(1 << 1)
 
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 999bdc6..9c5cfc2 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -31,12 +31,6 @@
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
@@ -45,7 +39,7 @@ static struct vgic_lr vgic_v3_get_lr(const struct kvm_vcpu *vcpu, int lr)
 	u64 val = vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[lr];
 
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
-		lr_desc.irq = val & ICH_LR_VIRTUALID_MASK;
+		lr_desc.irq = val & ICH_LR_VIRTUAL_ID_MASK;
 	else
 		lr_desc.irq = val & GICH_LR_VIRTUALID;
 
-- 
2.7.3

