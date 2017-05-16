From: wanghaibin <wanghaibin.wang@huawei.com>
Subject: [RFC PATCH] kvm: arm: vgic-v3: add the emulate GICC_CTLR layout
 support for vmcr ctlr field.
Date: Tue, 16 May 2017 09:19:26 +0800
Message-ID: <1494897566-11744-1-git-send-email-wanghaibin.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B266040960
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 21:16:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6qlHfMCKy5K1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 May 2017 21:16:21 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F36CD40190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 May 2017 21:16:20 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: zhaoshenglong@huawei.com, wu.wubin@huawei.com, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Boot a virtual machine with the emulated GICv2 on the GICv3 hardware.
Migrate the virtual machine will be successful, but the virtual machine will
hang at the destination.

The GICC_CTLR and ICC_CTLR_EL1 have the different layout. Currently, the set/get
the VMCR interface just take vmcr ctlr field as the ICC_CTLR_EL1 layout.
Should we consider the GICC_CTLR layout to avoid this problem?

Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
---
 include/linux/irqchip/arm-gic-v3.h |  2 ++
 virt/kvm/arm/vgic/vgic-v3.c        | 48 ++++++++++++++++++++++++--------------
 2 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 97cbca1..e40c711 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -403,6 +403,8 @@
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
 
+#define ICH_VMCR_CTLR_SHIFT		0
+#define ICH_VMCR_CTLR_MASK		(0x21f << ICH_VMCR_CTLR_SHIFT)
 #define ICH_VMCR_CBPR_SHIFT		4
 #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
 #define ICH_VMCR_EOIM_SHIFT		9
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index be0f4c3..66defae 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -174,19 +174,25 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	u32 vmcr;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+
+	if (model == KVM_DEV_TYPE_ARM_VGIC_V2)
+		vmcr  = (vmcrp->ctlr << ICH_VMCR_CTLR_SHIFT) & ICH_VMCR_CTLR_MASK;
+	else {
+		/*
+		 * Ignore the FIQen bit, because GIC emulation always implies
+		 * SRE=1 which means the vFIQEn bit is also RES1.
+		 */
+		vmcr = ((vmcrp->ctlr >> ICC_CTLR_EL1_EOImode_SHIFT) <<
+			 ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
+		vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
+		vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
+		vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
+	}
 
-	/*
-	 * Ignore the FIQen bit, because GIC emulation always implies
-	 * SRE=1 which means the vFIQEn bit is also RES1.
-	 */
-	vmcr = ((vmcrp->ctlr >> ICC_CTLR_EL1_EOImode_SHIFT) <<
-		 ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
 	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
 	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
 	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
-	vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
-	vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
 
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
 }
@@ -194,19 +200,25 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 {
 	u32 vmcr = vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr;
+	u32 model = vcpu->kvm->arch.vgic.vgic_model;
+
+	if (model == KVM_DEV_TYPE_ARM_VGIC_V2)
+		vmcrp->ctlr = (vmcr & ICH_VMCR_CTLR_MASK) >> ICH_VMCR_CTLR_SHIFT;
+	else {
+		/*
+		 * Ignore the FIQen bit, because GIC emulation always implies
+		 * SRE=1 which means the vFIQEn bit is also RES1.
+		 */
+		vmcrp->ctlr = ((vmcr >> ICH_VMCR_EOIM_SHIFT) <<
+				ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
+		vmcrp->ctlr |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+		vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
+		vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
+	}
 
-	/*
-	 * Ignore the FIQen bit, because GIC emulation always implies
-	 * SRE=1 which means the vFIQEn bit is also RES1.
-	 */
-	vmcrp->ctlr = ((vmcr >> ICH_VMCR_EOIM_SHIFT) <<
-			ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
-	vmcrp->ctlr |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
 	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
 	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
-	vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
-	vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
 }
 
 #define INITIAL_PENDBASER_VALUE						  \
-- 
1.8.3.1
