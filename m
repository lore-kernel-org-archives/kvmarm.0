From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 02/12] KVM: arm/arm64: vgic-v2: Save maintenance interrupt
 state only if required
Date: Mon,  7 Mar 2016 09:33:24 +0000
Message-ID: <1457343214-19547-3-git-send-email-marc.zyngier@arm.com>
References: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A15DE49B0C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2016 04:26:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZoLZvYo5j7Nv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2016 04:26:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3210349AF9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2016 04:26:19 -0500 (EST)
In-Reply-To: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 54 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 47 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index aa0fdb8..0dd83d5 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -21,6 +21,49 @@
 
 #include <asm/kvm_hyp.h>
 
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
@@ -28,7 +71,7 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	u32 eisr0, eisr1, elrsr0, elrsr1;
+	u32 elrsr0, elrsr1;
 	int i, nr_lr;
 
 	if (!base)
@@ -38,26 +81,23 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
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
