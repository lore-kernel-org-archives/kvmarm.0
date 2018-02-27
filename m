From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 35/40] KVM: arm/arm64: Get rid of vgic_elrsr
Date: Tue, 27 Feb 2018 12:34:24 +0100
Message-ID: <20180227113429.637-36-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C815A49E98
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:32:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s97LOVYI11py for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Feb 2018 06:31:50 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFF5B49E15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 06:28:28 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id x7so20759996wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Feb 2018 03:35:22 -0800 (PST)
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

There is really no need to store the vgic_elrsr on the VGIC data
structures as the only need we have for the elrsr is to figure out if an
LR is inactive when we save the VGIC state upon returning from the
guest.  We can might as well store this in a temporary local variable.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v4:
     - Removed endianness fix comment from commit text, as this was
       fixed in a separate commit already merged in mainline.
    
    Changes since v1:
     - Moved patch up the queue before we start moving code around to avoid moving
       potentially broken code.

 include/kvm/arm_vgic.h        |  2 --
 virt/kvm/arm/hyp/vgic-v2-sr.c | 28 +++++++---------------------
 virt/kvm/arm/hyp/vgic-v3-sr.c |  6 +++---
 virt/kvm/arm/vgic/vgic-v2.c   |  1 -
 virt/kvm/arm/vgic/vgic-v3.c   |  1 -
 5 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index cdbd142ca7f2..ac98ae46bfb7 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -263,7 +263,6 @@ struct vgic_dist {
 struct vgic_v2_cpu_if {
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
-	u64		vgic_elrsr;	/* Saved only */
 	u32		vgic_apr;
 	u32		vgic_lr[VGIC_V2_MAX_LRS];
 };
@@ -272,7 +271,6 @@ struct vgic_v3_cpu_if {
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
 	u32		vgic_sre;	/* Restored only, change ignored */
-	u32		vgic_elrsr;	/* Saved only */
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
 	u64		vgic_lr[VGIC_V3_MAX_LRS];
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 4fe6e797e8b3..a91b0d2b9249 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -23,29 +23,19 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
-	u32 elrsr0, elrsr1;
-
-	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
-	if (unlikely(nr_lr > 32))
-		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
-	else
-		elrsr1 = 0;
-
-	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
-}
-
 static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int i;
 	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u64 elrsr;
+	int i;
+
+	elrsr = readl_relaxed(base + GICH_ELRSR0);
+	if (unlikely(used_lrs > 32))
+		elrsr |= ((u64)readl_relaxed(base + GICH_ELRSR1)) << 32;
 
 	for (i = 0; i < used_lrs; i++) {
-		if (cpu_if->vgic_elrsr & (1UL << i))
+		if (elrsr & (1UL << i))
 			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
 		else
 			cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
@@ -68,13 +58,9 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 
 	if (used_lrs) {
 		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
-
-		save_elrsr(vcpu, base);
 		save_lrs(vcpu, base);
-
 		writel_relaxed(0, base + GICH_HCR);
 	} else {
-		cpu_if->vgic_elrsr = ~0UL;
 		cpu_if->vgic_apr = 0;
 	}
 }
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index f5c3d6d7019e..9abf2f3c12b5 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -222,15 +222,16 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	if (used_lrs) {
 		int i;
 		u32 nr_pre_bits;
+		u32 elrsr;
 
-		cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
+		elrsr = read_gicreg(ICH_ELSR_EL2);
 
 		write_gicreg(0, ICH_HCR_EL2);
 		val = read_gicreg(ICH_VTR_EL2);
 		nr_pre_bits = vtr_to_nr_pre_bits(val);
 
 		for (i = 0; i < used_lrs; i++) {
-			if (cpu_if->vgic_elrsr & (1 << i))
+			if (elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
 			else
 				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
@@ -262,7 +263,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		    cpu_if->its_vpe.its_vm)
 			write_gicreg(0, ICH_HCR_EL2);
 
-		cpu_if->vgic_elrsr = 0xffff;
 		cpu_if->vgic_ap0r[0] = 0;
 		cpu_if->vgic_ap0r[1] = 0;
 		cpu_if->vgic_ap0r[2] = 0;
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index c32d7b93ffd1..bb305d49cfdd 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -265,7 +265,6 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
 	 * anyway.
 	 */
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = 0;
-	vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr = ~0;
 
 	/* Get the show on the road... */
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 6b329414e57a..b76e21f3e6bd 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -267,7 +267,6 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 	 * anyway.
 	 */
 	vgic_v3->vgic_vmcr = 0;
-	vgic_v3->vgic_elrsr = ~0;
 
 	/*
 	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
-- 
2.14.2
