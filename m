From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 94/95] arm64: KVM: vgic-v3: Reset LRs at boot time
Date: Wed,  9 Mar 2016 07:31:28 +0000
Message-ID: <1457508689-19672-95-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A37749BCD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lKIqqVxA+-EJ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:36:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 002AD49BF7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:36:12 -0500 (EST)
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

In order to let the GICv3 code be more lazy in the way it
accesses the LRs, it is necessary to start with a clean slate.

Let's reset the LRs on each CPU when the vgic is probed (which
includes a round trip to EL2...).

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h | 1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c  | 9 +++++++++
 virt/kvm/arm/vgic-v3.c           | 7 +++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1037392..2d02ba6 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -42,6 +42,7 @@ extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
+extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 0db426e..8134947 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -321,6 +321,15 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
 	}
 }
 
+void __hyp_text __vgic_v3_init_lrs(void)
+{
+	int max_lr_idx = vtr_to_max_lr_idx(read_gicreg(ICH_VTR_EL2));
+	int i;
+
+	for (i = 0; i <= max_lr_idx; i++)
+		__gic_v3_set_lr(0, i);
+}
+
 static u64 __hyp_text __vgic_v3_read_ich_vtr_el2(void)
 {
 	return read_gicreg(ICH_VTR_EL2);
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 11b5ff6..999bdc6 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -216,6 +216,11 @@ static const struct vgic_ops vgic_v3_ops = {
 
 static struct vgic_params vgic_v3_params;
 
+static void vgic_cpu_init_lrs(void *params)
+{
+	kvm_call_hyp(__vgic_v3_init_lrs);
+}
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -284,6 +289,8 @@ int vgic_v3_probe(struct device_node *vgic_node,
 	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
 		 vcpu_res.start, vgic->maint_irq);
 
+	on_each_cpu(vgic_cpu_init_lrs, vgic, 1);
+
 	*ops = &vgic_v3_ops;
 	*params = vgic;
 
-- 
2.1.4
