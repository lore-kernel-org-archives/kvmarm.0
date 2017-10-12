From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 35/37] KVM: arm/arm64: Get rid of vgic_elrsr
Date: Thu, 12 Oct 2017 12:41:39 +0200
Message-ID: <20171012104141.26902-36-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33B9749DC0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PQDFkobTmtch for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Oct 2017 06:41:48 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 569B349DBA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 06:41:47 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id m72so11981876wmc.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Oct 2017 03:42:31 -0700 (PDT)
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

There is really no need to store the vgic_elrsr on the VGIC data
structures as the only need we have for the elrsr is to figure out if an
LR is inavtive when we save the VGIC state upon returning from the
guest.  We can might as well store this in a temporary local variable.

This also gets rid of the endianness conversion in the VGIC save
function, which is completely unnecessary and would actually result in
incorrect functionality on big-endian systems, because we are only using
typed values here and not converting pointers and reading different
types here.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h        |  2 --
 virt/kvm/arm/hyp/vgic-v3-sr.c |  6 +++---
 virt/kvm/arm/vgic/vgic-v2.c   | 33 +++++++--------------------------
 virt/kvm/arm/vgic/vgic-v3.c   |  1 -
 4 files changed, 10 insertions(+), 32 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 34dba51..79c9e67 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -237,7 +237,6 @@ struct vgic_dist {
 struct vgic_v2_cpu_if {
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
-	u64		vgic_elrsr;	/* Saved only */
 	u32		vgic_apr;
 	u32		vgic_lr[VGIC_V2_MAX_LRS];
 };
@@ -246,7 +245,6 @@ struct vgic_v3_cpu_if {
 	u32		vgic_hcr;
 	u32		vgic_vmcr;
 	u32		vgic_sre;	/* Restored only, change ignored */
-	u32		vgic_elrsr;	/* Saved only */
 	u32		vgic_ap0r[4];
 	u32		vgic_ap1r[4];
 	u64		vgic_lr[VGIC_V3_MAX_LRS];
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 91728fa..05548b2 100644
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
@@ -261,7 +262,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
 			write_gicreg(0, ICH_HCR_EL2);
 
-		cpu_if->vgic_elrsr = 0xffff;
 		cpu_if->vgic_ap0r[0] = 0;
 		cpu_if->vgic_ap0r[1] = 0;
 		cpu_if->vgic_ap0r[2] = 0;
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 259079b..df7e03b 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -247,7 +247,6 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
 	 * anyway.
 	 */
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = 0;
-	vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr = ~0;
 
 	/* Get the show on the road... */
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr = GICH_HCR_EN;
@@ -404,33 +403,19 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	return ret;
 }
 
-static void save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = kvm_vgic_global_state.nr_lr;
-	u32 elrsr0, elrsr1;
-
-	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
-	if (unlikely(nr_lr > 32))
-		elrsr1 = readl_relaxed(base + GICH_ELRSR1);
-	else
-		elrsr1 = 0;
-
-#ifdef CONFIG_CPU_BIG_ENDIAN
-	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
-#else
-	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
-#endif
-}
-
 static void save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
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
@@ -452,13 +437,9 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 
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
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 863351c..0900649 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -237,7 +237,6 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 	 * anyway.
 	 */
 	vgic_v3->vgic_vmcr = 0;
-	vgic_v3->vgic_elrsr = ~0;
 
 	/*
 	 * If we are emulating a GICv3, we do it in an non-GICv2-compatible
-- 
2.9.0
