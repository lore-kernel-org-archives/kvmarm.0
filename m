From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 22/79] KVM: arm/arm64: vgic: Get rid of unnecessary
 save_maint_int_state
Date: Sun, 23 Apr 2017 19:08:32 +0200
Message-ID: <20170423170929.27334-23-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C66849C0C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nuy2UIcvhMOL for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:11 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 75BC549C97
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:08 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id m123so50335039wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:55 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Now when we don't look at the MISR and EISR values anymore, we can get
rid of the logic to save them in the GIC save/restore code.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 40 ----------------------------------------
 virt/kvm/arm/hyp/vgic-v3-sr.c | 29 -----------------------------
 2 files changed, 69 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 34b37ce..a4c3bb0 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -22,45 +22,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
-					    void __iomem *base)
-{
-	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
-	u32 eisr0, eisr1;
-	int i;
-	bool expect_mi;
-
-	expect_mi = !!(cpu_if->vgic_hcr & GICH_HCR_UIE);
-
-	for (i = 0; i < used_lrs && !expect_mi; i++)
-		expect_mi |= (!(cpu_if->vgic_lr[i] & GICH_LR_HW) &&
-			      (cpu_if->vgic_lr[i] & GICH_LR_EOI));
-
-	if (expect_mi) {
-		cpu_if->vgic_misr = readl_relaxed(base + GICH_MISR);
-
-		if (cpu_if->vgic_misr & GICH_MISR_EOI) {
-			eisr0  = readl_relaxed(base + GICH_EISR0);
-			if (unlikely(used_lrs > 32))
-				eisr1  = readl_relaxed(base + GICH_EISR1);
-			else
-				eisr1 = 0;
-		} else {
-			eisr0 = eisr1 = 0;
-		}
-	} else {
-		cpu_if->vgic_misr = 0;
-		eisr0 = eisr1 = 0;
-	}
-
-#ifdef CONFIG_CPU_BIG_ENDIAN
-	cpu_if->vgic_eisr = ((u64)eisr0 << 32) | eisr1;
-#else
-	cpu_if->vgic_eisr = ((u64)eisr1 << 32) | eisr0;
-#endif
-}
-
 static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
@@ -111,7 +72,6 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	if (used_lrs) {
 		cpu_if->vgic_apr = readl_relaxed(base + GICH_APR);
 
-		save_maint_int_state(vcpu, base);
 		save_elrsr(vcpu, base);
 		save_lrs(vcpu, base);
 
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index b3c36b6..41bbbb0 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -118,33 +118,6 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
 	}
 }
 
-static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	int i;
-	bool expect_mi;
-	u64 used_lrs = vcpu->arch.vgic_cpu.used_lrs;
-
-	expect_mi = !!(cpu_if->vgic_hcr & ICH_HCR_UIE);
-
-	for (i = 0; i < used_lrs; i++) {
-		expect_mi |= (!(cpu_if->vgic_lr[i] & ICH_LR_HW) &&
-			      (cpu_if->vgic_lr[i] & ICH_LR_EOI));
-	}
-
-	if (expect_mi) {
-		cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
-
-		if (cpu_if->vgic_misr & ICH_MISR_EOI)
-			cpu_if->vgic_eisr = read_gicreg(ICH_EISR_EL2);
-		else
-			cpu_if->vgic_eisr = 0;
-	} else {
-		cpu_if->vgic_misr = 0;
-		cpu_if->vgic_eisr = 0;
-	}
-}
-
 void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -168,8 +141,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		val = read_gicreg(ICH_VTR_EL2);
 		nr_pri_bits = vtr_to_nr_pri_bits(val);
 
-		save_maint_int_state(vcpu);
-
 		for (i = 0; i <= used_lrs; i++) {
 			if (cpu_if->vgic_elrsr & (1 << i))
 				cpu_if->vgic_lr[i] &= ~ICH_LR_STATE;
-- 
2.9.0
