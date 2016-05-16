From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 08/56] KVM: arm/arm64: Get rid of vgic_cpu->nr_lr
Date: Mon, 16 May 2016 10:53:53 +0100
Message-ID: <1463392481-26583-66-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0056A49B7A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Aa19t0nKYmvl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:52:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDB9149BCF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:52:43 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

The number of list registers is a property of the underlying system, not
of emulated VGIC CPU interface.

As we are about to move this variable to global state in the new vgic
for clarity, move it from the legacy implementation as well to make the
merge of the new code easier.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h        |  3 ---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 12 +++++++-----
 virt/kvm/arm/vgic-v2.c        |  4 +++-
 virt/kvm/arm/vgic.c           | 12 ++----------
 4 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3e17fb4..67a6637 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -304,9 +304,6 @@ struct vgic_cpu {
 	unsigned long   *active_shared;
 	unsigned long   *pend_act_shared;
 
-	/* Number of list registers on this CPU */
-	int		nr_lr;
-
 	/* CPU vif control registers for world switch */
 	union {
 		struct vgic_v2_cpu_if	vgic_v2;
diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index 674bdf8..caac41f 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -21,11 +21,13 @@
 
 #include <asm/kvm_hyp.h>
 
+extern struct vgic_params vgic_v2_params;
+
 static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
 					    void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
+	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
 	u32 eisr0, eisr1;
 	int i;
 	bool expect_mi;
@@ -67,7 +69,7 @@ static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
 static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
+	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
 	u32 elrsr0, elrsr1;
 
 	elrsr0 = readl_relaxed(base + GICH_ELRSR0);
@@ -86,7 +88,7 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
 {
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
-	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
+	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
 	int i;
 
 	for (i = 0; i < nr_lr; i++) {
@@ -141,13 +143,13 @@ void __hyp_text __vgic_v2_restore_state(struct kvm_vcpu *vcpu)
 	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	void __iomem *base = kern_hyp_va(vgic->vctrl_base);
-	int i, nr_lr;
+	int nr_lr = (kern_hyp_va(&vgic_v2_params))->nr_lr;
+	int i;
 	u64 live_lrs = 0;
 
 	if (!base)
 		return;
 
-	nr_lr = vcpu->arch.vgic_cpu.nr_lr;
 
 	for (i = 0; i < nr_lr; i++)
 		if (cpu_if->vgic_lr[i] & GICH_LR_STATE)
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index 7e826c9..334cd7a 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -171,7 +171,7 @@ static const struct vgic_ops vgic_v2_ops = {
 	.enable			= vgic_v2_enable,
 };
 
-static struct vgic_params vgic_v2_params;
+struct vgic_params __section(.hyp.text) vgic_v2_params;
 
 static void vgic_cpu_init_lrs(void *params)
 {
@@ -201,6 +201,8 @@ int vgic_v2_probe(const struct gic_kvm_info *gic_kvm_info,
 	const struct resource *vctrl_res = &gic_kvm_info->vctrl;
 	const struct resource *vcpu_res = &gic_kvm_info->vcpu;
 
+	memset(vgic, 0, sizeof(*vgic));
+
 	if (!gic_kvm_info->maint_irq) {
 		kvm_err("error getting vgic maintenance irq\n");
 		ret = -ENXIO;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 91d42a8..f76bb64 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -690,12 +690,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
  */
 void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	u64 elrsr = vgic_get_elrsr(vcpu);
 	unsigned long *elrsr_ptr = u64_to_bitmask(&elrsr);
 	int i;
 
-	for_each_clear_bit(i, elrsr_ptr, vgic_cpu->nr_lr) {
+	for_each_clear_bit(i, elrsr_ptr, vgic->nr_lr) {
 		struct vgic_lr lr = vgic_get_lr(vcpu, i);
 
 		/*
@@ -1106,7 +1105,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	int i;
 
-	for (i = 0; i < vcpu->arch.vgic_cpu.nr_lr; i++) {
+	for (i = 0; i < vgic->nr_lr; i++) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, i);
 
 		if (vlr.irq == virt_irq && vlr.state & LR_STATE_ACTIVE)
@@ -1866,13 +1865,6 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
 		return -ENOMEM;
 	}
 
-	/*
-	 * Store the number of LRs per vcpu, so we don't have to go
-	 * all the way to the distributor structure to find out. Only
-	 * assembly code should use this one.
-	 */
-	vgic_cpu->nr_lr = vgic->nr_lr;
-
 	return 0;
 }
 
-- 
2.8.2
