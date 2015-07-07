From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 1/2] Fix NULL pointer dereferences if KVM is used without
 in-kernel irqchip
Date: Tue, 07 Jul 2015 13:38:48 +0300
Message-ID: <46c62639f325ef935c4ca24c5fc9d5eb2b4a0979.1436264839.git.p.fedin@samsung.com>
References: <cover.1436264839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D13D257DE1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:27:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yQKRzDvOeV+v for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 06:27:27 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4A75857DDE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:27:27 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR400HAT5KUO180@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 07 Jul 2015 11:38:54 +0100 (BST)
In-reply-to: <cover.1436264839.git.p.fedin@samsung.com>
In-reply-to: <cover.1436264839.git.p.fedin@samsung.com>
References: <cover.1436264839.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: KVM-ARM mailing list <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Makes qemu working again with kernel-irqchip=off option

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 virt/kvm/arm/vgic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 78fb820..3420657 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -100,6 +100,9 @@ static bool queue_sgi(struct kvm_vcpu *vcpu, int irq)
 
 int kvm_vgic_map_resources(struct kvm *kvm)
 {
+	if (!kvm->arch.vgic.vm_ops.map_resources)
+		return 0;
+
 	return kvm->arch.vgic.vm_ops.map_resources(kvm, vgic);
 }
 
@@ -1637,7 +1640,7 @@ static int vgic_vcpu_init_maps(struct kvm_vcpu *vcpu, int nr_irqs)
  */
 int kvm_vgic_get_max_vcpus(void)
 {
-	return vgic->max_gic_vcpus;
+	return vgic ? vgic->max_gic_vcpus : KVM_MAX_VCPUS;
 }
 
 void kvm_vgic_destroy(struct kvm *kvm)
-- 
2.4.4
