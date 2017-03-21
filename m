From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 10/10] KVM: arm/arm64: vgic: Improve sync_hwstate
 performance
Date: Tue, 21 Mar 2017 22:10:59 +0100
Message-ID: <20170321211059.8719-11-cdall@linaro.org>
References: <20170321211059.8719-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE2FB40D43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hFj8KATyCz+H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 17:09:26 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B981040C54
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 17:09:24 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id 196so4908171wmm.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 14:11:11 -0700 (PDT)
In-Reply-To: <20170321211059.8719-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

There is no need to call any functions to fold LRs when we don't use any
LRs and we don't need to mess with overflow flags, take spinlocks, or
prune the AP list if the AP list is empty.

Note: list_empty is a single atomic read (uses READ_ONCE) and can
therefore check if a list is empty or not without the need to take the
spinlock protecting the list.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
Changes since v1:
 - Moved clearing used_lrs into fold_lr_state
 - Moved hunk that removes check for vgic_initialized into previous
   patch

 virt/kvm/arm/vgic/vgic-v2.c |  7 +++++--
 virt/kvm/arm/vgic/vgic-v3.c |  7 +++++--
 virt/kvm/arm/vgic/vgic.c    | 10 ++++++----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index f9c4329..a1fc07a 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -59,12 +59,13 @@ static bool lr_signals_eoi_mi(u32 lr_val)
  */
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
 	int lr;
 
 	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
 
-	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
+	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u32 val = cpuif->vgic_lr[lr];
 		u32 intid = val & GICH_LR_VIRTUALID;
 		struct vgic_irq *irq;
@@ -106,6 +107,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
+
+	vgic_cpu->used_lrs = 0;
 }
 
 /*
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index c7ac9b1..2bcee2e 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -36,13 +36,14 @@ static bool lr_signals_eoi_mi(u64 lr_val)
 
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	int lr;
 
 	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
 
-	for (lr = 0; lr < vcpu->arch.vgic_cpu.used_lrs; lr++) {
+	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
 		u32 intid;
 		struct vgic_irq *irq;
@@ -92,6 +93,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
+
+	vgic_cpu->used_lrs = 0;
 }
 
 /* Requires the irq to be locked already */
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 04a405a..3d0979c 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -633,11 +633,13 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
-	vgic_fold_lr_state(vcpu);
-	vgic_prune_ap_list(vcpu);
+	/* An empty ap_list_head implies used_lrs == 0 */
+	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
+		return;
 
-	/* Make sure we can fast-path in flush_hwstate */
-	vgic_cpu->used_lrs = 0;
+	if (vgic_cpu->used_lrs)
+		vgic_fold_lr_state(vcpu);
+	vgic_prune_ap_list(vcpu);
 }
 
 /* Flush our emulation state into the GIC hardware before entering the guest. */
-- 
2.9.0
