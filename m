From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 00/16] KVM: arm64: GICv3 ITS emulation
Date: Tue, 13 Oct 2015 18:46:22 +0300
Message-ID: <017001d105ce$5047a710$f0d6f530$@samsung.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44047411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 11:44:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VW9tgPAdkkrU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Oct 2015 11:44:13 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F0494117E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Oct 2015 11:44:12 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NW6007JP15CAN70@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 13 Oct 2015 16:46:24 +0100 (BST)
In-reply-to: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

 I already suggested one bunch of fixes on top of vITS series, and here is another one. It reconciles it with spurious interrupt
fix, and adds missing check in vgic_retire_disabled_irqs(), which was removed in original v3 series.
---
>From bdbedc35a4dc9bc258b21792cf734aa3b2383dff Mon Sep 17 00:00:00 2001
From: Pavel Fedin <p.fedin@samsung.com>
Date: Tue, 13 Oct 2015 15:24:19 +0300
Subject: [PATCH] KVM: arm/arm64: Fix LPI loss

compute_pending_for_cpu() should return true if there's something pending
on the given vCPU. This is used in order to correctly set
dist->irq_pending_on_cpu flag. However, the function knows nothing about
LPIs, this can contribute to LPI loss.

This patch fixes it by introducing vits_check_lpis() function, which
returns true if there's any pending LPI. Also, some refactoring done,
wrapping some repeated checks into helper functions.

Additionally, vgic_retire_disabled_irqs() is fixed to correctly skip LPIs.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/its-emul.c     | 46 +++++++++++++++++++++++++++++++++++----------
 virt/kvm/arm/its-emul.h     |  1 +
 virt/kvm/arm/vgic-v3-emul.c |  1 +
 virt/kvm/arm/vgic.c         | 19 +++++++++++++++++--
 5 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 39113b9..21c8427 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -148,6 +148,7 @@ struct vgic_vm_ops {
 	int	(*map_resources)(struct kvm *, const struct vgic_params *);
 	bool	(*queue_lpis)(struct kvm_vcpu *);
 	void	(*unqueue_lpi)(struct kvm_vcpu *, int irq);
+	bool	(*check_lpis)(struct kvm_vcpu *);
 	int	(*inject_msi)(struct kvm *, struct kvm_msi *);
 };
 
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
index b1d61df..2fcd844 100644
--- a/virt/kvm/arm/its-emul.c
+++ b/virt/kvm/arm/its-emul.c
@@ -381,6 +381,18 @@ out_unlock:
 	return ret;
 }
 
+static bool its_is_enabled(struct kvm *kvm)
+{
+	return vgic_has_its(kvm) && kvm->arch.vgic.its.enabled &&
+	       kvm->arch.vgic.lpis_enabled;
+}
+
+static bool lpi_is_pending(struct its_itte *itte, u32 vcpu_id)
+{
+	return itte->enabled && test_bit(vcpu_id, itte->pending) &&
+	       itte->collection && (itte->collection->target_addr == vcpu_id);
+}
+
 /*
  * Find all enabled and pending LPIs and queue them into the list
  * registers.
@@ -393,20 +405,12 @@ bool vits_queue_lpis(struct kvm_vcpu *vcpu)
 	struct its_itte *itte;
 	bool ret = true;
 
-	if (!vgic_has_its(vcpu->kvm))
-		return true;
-	if (!its->enabled || !vcpu->kvm->arch.vgic.lpis_enabled)
+	if (!its_is_enabled(vcpu->kvm))
 		return true;
 
 	spin_lock(&its->lock);
 	for_each_lpi(device, itte, vcpu->kvm) {
-		if (!itte->enabled || !test_bit(vcpu->vcpu_id, itte->pending))
-			continue;
-
-		if (!itte->collection)
-			continue;
-
-		if (itte->collection->target_addr != vcpu->vcpu_id)
+		if (!lpi_is_pending(itte, vcpu->vcpu_id))
 			continue;
 
 
@@ -436,6 +440,28 @@ void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int lpi)
 	spin_unlock(&its->lock);
 }
 
+bool vits_check_lpis(struct kvm_vcpu *vcpu)
+{
+	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
+	struct its_device *device;
+	struct its_itte *itte;
+	bool ret = false;
+
+	if (!its_is_enabled(vcpu->kvm))
+		return false;
+
+	spin_lock(&its->lock);
+	for_each_lpi(device, itte, vcpu->kvm) {
+		ret = lpi_is_pending(itte, vcpu->vcpu_id);
+		if (ret)
+			goto out;
+	}
+
+out:
+	spin_unlock(&its->lock);
+	return ret;
+}
+
 static void its_free_itte(struct its_itte *itte)
 {
 	list_del(&itte->itte_list);
diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
index 236f153..f7fa5f8 100644
--- a/virt/kvm/arm/its-emul.h
+++ b/virt/kvm/arm/its-emul.h
@@ -41,6 +41,7 @@ int vits_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 
 bool vits_queue_lpis(struct kvm_vcpu *vcpu);
 void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int irq);
+bool vits_check_lpis(struct kvm_vcpu *vcpu);
 
 #define E_ITS_MOVI_UNMAPPED_INTERRUPT		0x010107
 #define E_ITS_MOVI_UNMAPPED_COLLECTION		0x010109
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 798f256..25463d0 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -966,6 +966,7 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 	dist->vm_ops.inject_msi = vits_inject_msi;
 	dist->vm_ops.queue_lpis = vits_queue_lpis;
 	dist->vm_ops.unqueue_lpi = vits_unqueue_lpi;
+	dist->vm_ops.check_lpis = vits_check_lpis;
 
 	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
 	dist->vgic_redist_base = VGIC_ADDR_UNDEF;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5d0f6ee..796964a 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -111,6 +111,14 @@ static void vgic_unqueue_lpi(struct kvm_vcpu *vcpu, int irq)
 		vcpu->kvm->arch.vgic.vm_ops.unqueue_lpi(vcpu, irq);
 }
 
+static bool vgic_check_lpis(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->kvm->arch.vgic.vm_ops.check_lpis)
+		return vcpu->kvm->arch.vgic.vm_ops.check_lpis(vcpu);
+	else
+		return false;
+}
+
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
 	return kvm->arch.vgic.vm_ops.map_resources(kvm, vgic);
@@ -1036,8 +1044,11 @@ static int compute_pending_for_cpu(struct kvm_vcpu *vcpu)
 
 	pending_private = find_first_bit(pend_percpu, VGIC_NR_PRIVATE_IRQS);
 	pending_shared = find_first_bit(pend_shared, nr_shared);
-	return (pending_private < VGIC_NR_PRIVATE_IRQS ||
-		pending_shared < vgic_nr_shared_irqs(dist));
+	if (pending_private < VGIC_NR_PRIVATE_IRQS ||
+		pending_shared < vgic_nr_shared_irqs(dist))
+		return true;
+
+	return vgic_check_lpis(vcpu);
 }
 
 /*
@@ -1148,6 +1159,10 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
 	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
+		/* We don't care about LPIs here */
+		if (vlr.irq >= 8192)
+			continue;
+
 		if (!vgic_irq_is_enabled(vcpu, vlr.irq)) {
 			vgic_retire_lr(lr, vcpu);
 			if (vgic_irq_is_queued(vcpu, vlr.irq))
-- 
2.4.4


Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
