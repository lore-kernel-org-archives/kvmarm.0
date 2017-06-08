From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 6/9] KVM: arm/arm64: Introduce an allocator for in-kernel
 irq lines
Date: Thu,  8 Jun 2017 15:34:43 +0200
Message-ID: <20170608133446.3875-7-cdall@linaro.org>
References: <20170608133446.3875-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5C340430
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hdE3PqEQ2z4g for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 09:30:47 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D45E40C92
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:46 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id n195so31271785wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jun 2017 06:34:56 -0700 (PDT)
In-Reply-To: <20170608133446.3875-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Having multiple devices being able to signal the same interrupt line is
very confusing and almost certainly guarantees a configuration error.

Therefore, introduce a very simple allocator which allows a device to
claim an interrupt line from the vgic for a given VM.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_vgic.h   |  5 +++++
 virt/kvm/arm/vgic/vgic.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index dde59fb..5d5b345 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -121,6 +121,9 @@ struct vgic_irq {
 	u8 source;			/* GICv2 SGIs only */
 	u8 priority;
 	enum vgic_irq_config config;	/* Level or edge */
+
+	void *owner;			/* Opaque pointer to reserve an interrupt
+					   for in-kernel devices. */
 };
 
 struct vgic_register_region;
@@ -340,4 +343,6 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
  */
 int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
 
+int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c66feac..9628945 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -435,6 +435,39 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 }
 
 /**
+ * kvm_vgic_set_owner - Set the owner of an interrupt for a VM
+ *
+ * @vcpu:   Pointer to the VCPU (used for PPIs)
+ * @intid:  The virtual INTID identifying the interrupt (PPI or SPI)
+ * @owner:  Opaque pointer to the owner
+ *
+ * Returns 0 if intid is not already used by another in-kernel device and the
+ * owner is set, otherwise returns an error code.
+ */
+int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner)
+{
+	struct vgic_irq *irq;
+	int ret = 0;
+
+	if (!vgic_initialized(vcpu->kvm))
+		return -EAGAIN;
+
+	/* SGIs and LPIs cannot be wired up to any device */
+	if (!irq_is_ppi(intid) && !vgic_valid_spi(vcpu->kvm, intid))
+		return -EINVAL;
+
+	irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
+	spin_lock(&irq->irq_lock);
+	if (irq->owner && irq->owner != owner)
+		ret = -EEXIST;
+	else
+		irq->owner = owner;
+	spin_unlock(&irq->irq_lock);
+
+	return ret;
+}
+
+/**
  * vgic_prune_ap_list - Remove non-relevant interrupts from the list
  *
  * @vcpu: The VCPU pointer
-- 
2.9.0
