From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 87/95] KVM: arm/arm64: vgic-v2: Do not save an LR known to be
 empty
Date: Wed,  9 Mar 2016 07:31:21 +0000
Message-ID: <1457508689-19672-88-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EE5249BE4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X7UW1-gyNDc6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FA8349BDB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:53 -0500 (EST)
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

On exit, any empty LR will be signaled in GICH_ELRSR*. Which
means that we do not have to save it, and we can just clear
its state in the in-memory copy.

Take this opportunity to move the LR saving code into its
own function.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index c576228..6d4dd78 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -83,6 +83,25 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 #endif
 }
 
+static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
+{
+	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
+	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
+	int i;
+
+	for (i = 0; i < nr_lr; i++) {
+		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
+			continue;
+
+		if (cpu_if->vgic_elrsr & (1UL << i)) {
+			cpu_if->vgic_lr[i] &= ~GICH_LR_STATE;
+			continue;
+		}
+
+		cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
+	}
+}
+
 /* vcpu is already in the HYP VA space */
 void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 {
@@ -90,12 +109,10 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	int i, nr_lr;
 
 	if (!base)
 		return;
 
-	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
 	cpu_if->vgic_vmcr = readl_relaxed(base + GICH_VMCR);
 
 	if (vcpu->arch.vgic_cpu.live_lrs) {
@@ -103,10 +120,7 @@ void __hyp_text __vgic_v2_save_state(struct kvm_vcpu *vcpu)
 
 		save_maint_int_state(vcpu, base);
 		save_elrsr(vcpu, base);
- 
-		for (i = 0; i < nr_lr; i++)
-			if (vcpu->arch.vgic_cpu.live_lrs & (1UL << i))
-				cpu_if->vgic_lr[i] = readl_relaxed(base + GICH_LR0 + (i * 4));
+		save_lrs(vcpu, base);
 
 		writel_relaxed(0, base + GICH_HCR);
 
-- 
2.1.4
