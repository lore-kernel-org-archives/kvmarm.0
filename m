From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 86/95] KVM: arm/arm64: vgic-v2: Move GICH_ELRSR saving to its
 own function
Date: Wed,  9 Mar 2016 07:31:20 +0000
Message-ID: <1457508689-19672-87-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5129A49BAD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 26LWOZA+z+Tq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D57B49BE1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:50 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
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
