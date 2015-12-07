From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 04/22] KVM: arm/arm64: vgic-v3: Make the LR indexing macro public
Date: Mon,  7 Dec 2015 10:53:20 +0000
Message-ID: <1449485618-9443-5-git-send-email-marc.zyngier@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

We store GICv3 LRs in reverse order so that the CPU can save/restore
them in rever order as well (don't ask why, the design is crazy),
and yet generate memory traffic that doesn't completely suck.

We need this macro to be available to the C version of save/restore.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h |  6 ++++++
 virt/kvm/arm/vgic-v3.c | 10 ++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d2f4147..13a3d53 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -279,6 +279,12 @@ struct vgic_v2_cpu_if {
 	u32		vgic_lr[VGIC_V2_MAX_LRS];
 };
 
+/*
+ * LRs are stored in reverse order in memory. make sure we index them
+ * correctly.
+ */
+#define VGIC_V3_LR_INDEX(lr)		(VGIC_V3_MAX_LRS - 1 - lr)
+
 struct vgic_v3_cpu_if {
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 	u32		vgic_hcr;
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 487d635..3813d23 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -36,18 +36,12 @@
 #define GICH_LR_PHYSID_CPUID		(7UL << GICH_LR_PHYSID_CPUID_SHIFT)
 #define ICH_LR_VIRTUALID_MASK		(BIT_ULL(32) - 1)
 
-/*
- * LRs are stored in reverse order in memory. make sure we index them
- * correctly.
- */
-#define LR_INDEX(lr)			(VGIC_V3_MAX_LRS - 1 - lr)
-
 static u32 ich_vtr_el2;
 
 static struct vgic_lr vgic_v3_get_lr(const struct kvm_vcpu *vcpu, int lr)
 {
 	struct vgic_lr lr_desc;
-	u64 val = vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)];
+	u64 val = vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[VGIC_V3_LR_INDEX(lr)];
 
 	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
 		lr_desc.irq = val & ICH_LR_VIRTUALID_MASK;
@@ -111,7 +105,7 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
 		lr_val |= ((u64)lr_desc.hwirq) << ICH_LR_PHYS_ID_SHIFT;
 	}
 
-	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)] = lr_val;
+	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[VGIC_V3_LR_INDEX(lr)] = lr_val;
 
 	if (!(lr_desc.state & LR_STATE_MASK))
 		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr |= (1U << lr);
-- 
2.1.4

