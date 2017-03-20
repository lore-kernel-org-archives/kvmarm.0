From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 3/9] KVM: arm/arm64: vgic: Get rid of live_lrs
Date: Mon, 20 Mar 2017 11:58:12 +0100
Message-ID: <20170320105818.20481-4-cdall@linaro.org>
References: <20170320105818.20481-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FB6340CA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 06:56:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QG3goXc4URks for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 06:56:44 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3344640C41
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 06:56:43 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id u132so60111311wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 03:58:28 -0700 (PDT)
In-Reply-To: <20170320105818.20481-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

There is no need to calculate and maintain live_lrs when we always
populate the lowest numbered LRs first on every entry and clear all LRs
on every exit.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h        |  2 --
 virt/kvm/arm/hyp/vgic-v2-sr.c | 39 ++++++++++-----------------------------
 virt/kvm/arm/hyp/vgic-v3-sr.c | 42 ++++++++++++------------------------------
 3 files changed, 22 insertions(+), 61 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8d7c3a7..fa12d99 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -264,8 +264,6 @@ struct vgic_cpu {
 	 */
 	struct list_head ap_list_head;
 
-	u64 live_lrs;
-
 	/*
 	 * Members below are used with GICv3 emulation only and represent
 	 * parts of the redistributor.
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index d3d3b9b..34b37ce 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -26,27 +26,23 @@ static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
 					    void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 	u32 eisr0, eisr1;
 	int i;
 	bool expect_mi;
 
 	expect_mi = !!(cpu_if->vgic_hcr & GICH_HCR_UIE);
 
-	for (i = 0; i < nr_lr; i++) {
-		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
-				continue;
-
+	for (i = 0; i < used_lrs && !expect_mi; i++)
 		expect_mi |= (!(cpu_if->vgic_lr[i] & GICH_LR_HW) &&
 			      (cpu_if->vgic_lr[i] & GICH_LR_EOI));
-	}
 
 	if (expect_mi) {
 		cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
 
 		if (cpu_if->vgic_misr & GICH_MISR_EOI) {
 			eisr0  = readl_relaxed(base + GICH_EISR0);
-			if (unlikely(nr_lr > 32))
+			if (unlikely(used_lrs > 32))
 				eisr1  = readl_relaxed(base + GICH_EISR1);
 			else
 				eisr1 = 0;
@@ -87,13 +83,10 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
 	int i;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 
-	for (i = 0; i < nr_lr; i++) {
-		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
-			continue;
-
+	for (i = 0; i < used_lrs; i++) {
 		if (cpu_if->vgic_elrsr & (1UL << i))
 			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
 		else
@@ -110,11 +103,12 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 
 	if (!base)
 		return;
 
-	if (vcpu->arch.vgic_cpu.live_lrs) {
+	if (used_lrs) {
 		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
 
 		save_maint_int_state(vcpu, base);
@@ -122,8 +116,6 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 		save_lrs(vcpu, base);
 
 		writel_relaxed(0, base + GICH_HCR);
-
-		vcpu->arch.vgic_cpu.live_lrs = 0;
 	} else {
 		cpu_if->vgic_eisr = 0;
 		cpu_if->vgic_elrsr = ~0UL;
@@ -139,31 +131,20 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	int nr_lr = (kern_hyp_va(&kvm_vgic_global_state))->nr_lr;
 	int i;
-	u64 live_lrs = 0;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 
 	if (!base)
 		return;
 
-
-	for (i = 0; i < nr_lr; i++)
-		if (cpu_if->vgic_lr[i] & GICH_LR_STATE)
-			live_lrs |= 1UL << i;
-
-	if (live_lrs) {
+	if (used_lrs) {
 		writel_relaxed(cpu_if->vgic_hcr, base + GICH_HCR);
 		writel_relaxed(cpu_if->vgic_apr, base + GICH_APR);
-		for (i = 0; i < nr_lr; i++) {
-			if (!(live_lrs & (1UL << i)))
-				continue;
-
+		for (i = 0; i < used_lrs; i++) {
 			writel_relaxed(cpu_if->vgic_lr[i],
 				       base + GICH_LR0 + (i * 4));
 		}
 	}
-
-	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
 }
 
 #ifdef CONFIG_ARM64
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index e51ee7e..b3c36b6 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -118,18 +118,16 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
 	}
 }
 
-static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu, int nr_lr)
+static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 	int i;
 	bool expect_mi;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 
 	expect_mi = !!(cpu_if->vgic_hcr & ICH_HCR_UIE);
 
-	for (i = 0; i < nr_lr; i++) {
-		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
-				continue;
-
+	for (i = 0; i < used_lrs; i++) {
 		expect_mi |= (!(cpu_if->vgic_lr[i] & ICH_LR_HW) &&
 			      (cpu_if->vgic_lr[i] & ICH_LR_EOI));
 	}
@@ -150,6 +148,7 @@ static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu, int nr_lr)
 void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 	u64 val;
 
 	/*
@@ -159,23 +158,19 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 	if (!cpu_if->vgic_sre)
 		dsb(st);
 
-	if (vcpu->arch.vgic_cpu.live_lrs) {
+	if (used_lrs) {
 		int i;
-		u32 max_lr_idx, nr_pri_bits;
+		u32 nr_pri_bits;
 
 		cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
 
 		write_gicreg(0, ICH_HCR_EL2);
 		val = read_gicreg(ICH_VTR_EL2);
-		max_lr_idx = vtr_to_max_lr_idx(val);
 		nr_pri_bits = vtr_to_nr_pri_bits(val);
 
-		save_maint_int_state(vcpu, max_lr_idx + 1);
-
-		for (i = 0; i <= max_lr_idx; i++) {
-			if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
-				continue;
+		save_maint_int_state(vcpu);
 
+		for (i = 0; i <= used_lrs; i++) {
 			if (cpu_if->vgic_elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
 			else
@@ -203,8 +198,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		default:
 			cpu_if->vgic_ap1r[0] = read_gicreg(ICH_AP1R0_EL2);
 		}
-
-		vcpu->arch.vgic_cpu.live_lrs = 0;
 	} else {
 		cpu_if->vgic_misr  = 0;
 		cpu_if->vgic_eisr  = 0;
@@ -232,9 +225,9 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
 	u64 val;
-	u32 max_lr_idx, nr_pri_bits;
-	u16 live_lrs = 0;
+	u32 nr_pri_bits;
 	int i;
 
 	/*
@@ -251,15 +244,9 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	}
 
 	val = read_gicreg(ICH_VTR_EL2);
-	max_lr_idx = vtr_to_max_lr_idx(val);
 	nr_pri_bits = vtr_to_nr_pri_bits(val);
 
-	for (i = 0; i <= max_lr_idx; i++) {
-		if (cpu_if->vgic_lr[i] & ICH_LR_STATE)
-			live_lrs |= (1 << i);
-	}
-
-	if (live_lrs) {
+	if (used_lrs) {
 		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 
 		switch (nr_pri_bits) {
@@ -282,12 +269,8 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 			write_gicreg(cpu_if->vgic_ap1r[0], ICH_AP1R0_EL2);
 		}
 
-		for (i = 0; i <= max_lr_idx; i++) {
-			if (!(live_lrs & (1 << i)))
-				continue;
-
+		for (i = 0; i < used_lrs; i++)
 			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
-		}
 	}
 
 	/*
@@ -299,7 +282,6 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 		isb();
 		dsb(sy);
 	}
-	vcpu->arch.vgic_cpu.live_lrs = live_lrs;
 
 	/*
 	 * Prevent the guest from touching the GIC system registers if
-- 
2.9.0
