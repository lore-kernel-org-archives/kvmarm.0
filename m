From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 03/12] KVM: arm/arm64: vgic-v2: Move GICH_ELRSR saving to
 its own function
Date: Mon,  7 Mar 2016 09:33:25 +0000
Message-ID: <1457343214-19547-4-git-send-email-marc.zyngier@arm.com>
References: <1457343214-19547-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B49949B05
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2016 04:26:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2cgXP3en79HM for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Mar 2016 04:26:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B66549B1A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Mar 2016 04:26:21 -0500 (EST)
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

In order to make the saving path slightly more readable and
prepare for some more optimizations, let's move the GICH_ELRSR
saving to its own function.

No functional change.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 0dd83d5..c576228 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -64,6 +64,25 @@ static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
 #endif
 }
 
+static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
+	u32 elrsr0, elrsr1;
+
+	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
+	if (unlikely(nr_lr > 32))
+		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
+	else
+		elrsr1 = 0;
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
+#else
+	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
+#endif
+}
+
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
@@ -71,7 +90,6 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	u32 elrsr0, elrsr1;
 	int i, nr_lr;
 
 	if (!base)
@@ -81,22 +99,10 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
 
 	if (vcpu->arch.vgic_cpu.live_lrs) {
-		elrsr0 = readl_relaxed(base + GICH_ELRSR0);
-		cpu_if->vgic_apr    = readl_relaxed(base + GICH_APR);
-
-		if (unlikely(nr_lr > 32)) {
-			elrsr1 = readl_relaxed(base + GICH_ELRSR1);
-		} else {
-			elrsr1 = 0;
-		}
-
-#ifdef CONFIG_CPU_BIG_ENDIAN
-		cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
-#else
-		cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
-#endif
+		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
 
 		save_maint_int_state(vcpu, base);
+		save_elrsr(vcpu, base);
  
 		for (i = 0; i < nr_lr; i++)
 			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
-- 
2.1.4
