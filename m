From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 08/55] KVM: arm/arm64: Get rid of vgic_cpu->nr_lr
Date: Fri,  6 May 2016 11:45:21 +0100
Message-ID: <1462531568-9799-9-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA25A49BB0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RDjSN4wB8887 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:43:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F5449B88
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:11 -0400 (EDT)
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
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
index f842d7d..452bb85 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -303,9 +303,6 @@ struct vgic_cpu {
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
index 67ec334..6aaf5f7 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -174,7 +174,7 @@ static const struct vgic_ops vgic_v2_ops = {
 	.enable			= vgic_v2_enable,
 };
 
-static struct vgic_params vgic_v2_params;
+struct vgic_params __section(.hyp.text) vgic_v2_params;
 
 static void vgic_cpu_init_lrs(void *params)
 {
@@ -204,6 +204,8 @@ int vgic_v2_probe(struct device_node *vgic_node,
 	struct resource vcpu_res;
 	struct vgic_params *vgic = &vgic_v2_params;
 
+	memset(vgic, 0, sizeof(*vgic));
+
 	vgic->maint_irq = irq_of_parse_and_map(vgic_node, 0);
 	if (!vgic->maint_irq) {
 		kvm_err("error getting vgic maintenance irq from DT\n");
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 00386df..5efc298 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -691,12 +691,11 @@ bool vgic_handle_cfg_reg(u32 *reg, struct kvm_exit_mmio *mmio,
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
@@ -1107,7 +1106,7 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 {
 	int i;
 
-	for (i = 0; i < vcpu->arch.vgic_cpu.nr_lr; i++) {
+	for (i = 0; i < vgic->nr_lr; i++) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, i);
 
 		if (vlr.irq == virt_irq && vlr.state & LR_STATE_ACTIVE)
@@ -1867,13 +1866,6 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
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
2.7.3
