From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 08/17] arm64: KVM: vgic-v2: Save maintenance interrupt state only if required
Date: Wed, 17 Feb 2016 16:40:40 +0000
Message-ID: <1455727249-24752-9-git-send-email-marc.zyngier@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Next on our list of useless accesses is the maintenance interrupt
status registers (GICH_MISR, GICH_EISR{0,1}).

It is pointless to save them if we haven't asked for a maintenance
interrupt the first place, which can only happen for two reasons:
- Underflow: GICH_HCR_UIE will be set,
- EOI: GICH_LR_EOI will be set.

These conditions can be checked on the in-memory copies of the regs.
Should any of these two condition be valid, we must read GICH_MISR.
We can then check for GICH_MISR_EOI, and only when set read
GICH_EISR*.

This means that in most case, we don't have to save them at all.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v2-sr.c | 54 +++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
index 5ab8d63..1bda5ce 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
@@ -23,6 +23,49 @@
 
 #include "hyp.h"
 
+static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
+					    void __iomem *base)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
+	u32 eisr0, eisr1;
+	int i;
+	bool expect_mi;
+
+	expect_mi = !!(cpu_if->vgic_hcr & GICH_HCR_UIE);
+
+	for (i = 0; i < nr_lr; i++) {
+		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
+				continue;
+
+		expect_mi |= (!(cpu_if->vgic_lr[i] & GICH_LR_HW) &&
+			      (cpu_if->vgic_lr[i] & GICH_LR_EOI));
+	}
+
+	if (expect_mi) {
+		cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
+
+		if (cpu_if->vgic_misr & GICH_MISR_EOI) {
+			eisr0  = readl_relaxed(base + GICH_EISR0);
+			if (unlikely(nr_lr > 32))
+				eisr1  = readl_relaxed(base + GICH_EISR1);
+			else
+				eisr1 = 0;
+		} else {
+			eisr0 = eisr1 = 0;
+		}
+	} else {
+		cpu_if->vgic_misr = 0;
+		eisr0 = eisr1 = 0;
+	}
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	cpu_if->vgic_eisr = ((u64)eisr0 << 32) | eisr1;
+#else
+	cpu_if->vgic_eisr = ((u64)eisr1 << 32) | eisr0;
+#endif
+}
+
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
@@ -30,7 +73,7 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	u32 eisr0, eisr1, elrsr0, elrsr1;
+	u32 elrsr0, elrsr1;
 	int i, nr_lr;
 
 	if (!base)
@@ -40,26 +83,23 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
 
 	if (vcpu->arch.vgic_cpu.live_lrs) {
-		eisr0  = readl_relaxed(base + GICH_EISR0);
 		elrsr0 = readl_relaxed(base + GICH_ELRSR0);
-		cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
 		cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
 
 		if (unlikely(nr_lr > 32)) {
-			eisr1  = readl_relaxed(base + GICH_EISR1);
 			elrsr1 = readl_relaxed(base + GICH_ELRSR1);
 		} else {
-			eisr1 = elrsr1 = 0;
+			elrsr1 = 0;
 		}
 
 #ifdef CONFIG_CPU_BIG_ENDIAN
-		cpu_if->vgic_eisr  = ((u64)eisr0 << 32) | eisr1;
 		cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
 #else
-		cpu_if->vgic_eisr  = ((u64)eisr1 << 32) | eisr0;
 		cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
 #endif
 
+		save_maint_int_state(vcpu, base);
+ 
 		for (i = 0; i < nr_lr; i++)
 			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
 				cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
-- 
2.1.4

