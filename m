From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 92/95] arm64: KVM: vgic-v3: Save maintenance interrupt state
 only if required
Date: Wed,  9 Mar 2016 07:31:26 +0000
Message-ID: <1457508689-19672-93-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8262649BD5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n5C0TR--e8nK for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:36:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 506B549B77
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:07 -0500 (EST)
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

Next on our list of useless accesses is the maintenance interrupt
status registers (ICH_MISR_EL2, ICH_EISR_EL2).

It is pointless to save them if we haven't asked for a maintenance
interrupt the first place, which can only happen for two reasons:
- Underflow: ICH_HCR_UIE will be set,
- EOI: ICH_LR_EOI will be set.

These conditions can be checked on the in-memory copies of the regs.
Should any of these two condition be valid, we must read GICH_MISR.
We can then check for ICH_MISR_EOI, and only when set read
ICH_EISR_EL2.

This means that in most case, we don't have to save them at all.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index e596945..61a5e46 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -131,6 +131,35 @@ static void __hyp_text __gic_v3_set_lr(u64 val, int lr)
 	}
 }
 
+static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu, int nr_lr)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	int i;
+	bool expect_mi;
+
+	expect_mi = !!(cpu_if->vgic_hcr & ICH_HCR_UIE);
+
+	for (i = 0; i < nr_lr; i++) {
+		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
+				continue;
+
+		expect_mi |= (!(cpu_if->vgic_lr[i] & ICH_LR_HW) &&
+			      (cpu_if->vgic_lr[i] & ICH_LR_EOI));
+	}
+
+	if (expect_mi) {
+		cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
+
+		if (cpu_if->vgic_misr & ICH_MISR_EOI)
+			cpu_if->vgic_eisr = read_gicreg(ICH_EISR_EL2);
+		else
+			cpu_if->vgic_eisr = 0;
+	} else {
+		cpu_if->vgic_misr = 0;
+		cpu_if->vgic_eisr = 0;
+	}
+}
+
 void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -148,8 +177,6 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		int i;
 		u32 max_lr_idx, nr_pri_bits;
 
-		cpu_if->vgic_misr  = read_gicreg(ICH_MISR_EL2);
-		cpu_if->vgic_eisr  = read_gicreg(ICH_EISR_EL2);
 		cpu_if->vgic_elrsr = read_gicreg(ICH_ELSR_EL2);
 
 		write_gicreg(0, ICH_HCR_EL2);
@@ -157,6 +184,8 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
 		max_lr_idx = vtr_to_max_lr_idx(val);
 		nr_pri_bits = vtr_to_nr_pri_bits(val);
 
+		save_maint_int_state(vcpu, max_lr_idx + 1);
+
 		for (i = 0; i <= max_lr_idx; i++) {
 			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
 				cpu_if->vgic_lr[i] = __gic_v3_get_lr(i);
-- 
2.1.4
