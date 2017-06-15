From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 6/8] KVM: arm/arm64: vgic: Implement forwarding setting
Date: Thu, 15 Jun 2017 14:52:38 +0200
Message-ID: <1497531160-29162-7-git-send-email-eric.auger@redhat.com>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36BB140D68
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:50:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 88UiYpExnXiY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jun 2017 08:50:45 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EB3D40D58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jun 2017 08:50:45 -0400 (EDT)
In-Reply-To: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implements kvm_vgic_[set|unset]_forwarding.

Handle low-level VGIC programming and consistent irqchip
programming.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- change the parameter names used in the declaration
- use kvm_vgic_map/unmap_phys_irq and handle their returned value
---
 include/kvm/arm_vgic.h   |  5 +++
 virt/kvm/arm/vgic/vgic.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index cceb31d..5064a57 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -343,4 +343,9 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
  */
 int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
 
+int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
+			    unsigned int vintid);
+void kvm_vgic_unset_forwarding(struct kvm *kvm, unsigned int host_irq,
+			       unsigned int vintid);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 2e35ac7..9ee3e77 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -781,3 +781,91 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
 	return map_is_active;
 }
 
+/**
+ * kvm_vgic_set_forwarding - Set IRQ forwarding
+ *
+ * @kvm: kvm handle
+ * @host_irq: the host linux IRQ
+ * @vintid: the virtual INTID
+ *
+ * This function must be called when the IRQ is not active:
+ * ie. not active at GIC level and not currently under injection
+ * into the guest using the unforwarded mode. The physical IRQ must
+ * be disabled and all vCPUs must have been exited and prevented
+ * from being re-entered.
+ */
+int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
+			    unsigned int vintid)
+{
+	struct kvm_vcpu *vcpu;
+	struct vgic_irq *irq;
+	int ret;
+
+	kvm_debug("%s host_irq=%d vintid=%d\n", __func__, host_irq, vintid);
+
+	if (!vgic_valid_spi(kvm, vintid))
+		return -EINVAL;
+
+	irq = vgic_get_irq(kvm, NULL, vintid);
+	spin_lock(&irq->irq_lock);
+
+	if (irq->hw) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+	vcpu = irq->target_vcpu;
+	if (!vcpu) {
+		ret = -EAGAIN;
+		goto unlock;
+	}
+	
+	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
+	if (!ret)
+		irq_set_vcpu_affinity(host_irq, vcpu);
+unlock:
+	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(kvm, irq);
+	return ret;
+}
+
+/**
+ * kvm_vgic_unset_forwarding - Unset IRQ forwarding
+ *
+ * @kvm: KVM handle
+ * @host_irq: the host Linux IRQ number
+ * @vintid: virtual INTID
+ *
+ * This function must be called when the host irq is disabled and
+ * all vCPUs have been exited and prevented from being re-entered.
+ */
+void kvm_vgic_unset_forwarding(struct kvm *kvm,
+			       unsigned int host_irq,
+			       unsigned int vintid)
+{
+	struct vgic_irq *irq;
+	bool active;
+
+	kvm_debug("%s host_irq=%d vintid=%d\n", __func__, host_irq, vintid);
+
+	if (!vgic_valid_spi(kvm, vintid))
+		return;
+
+	irq = vgic_get_irq(kvm, NULL, vintid);
+	spin_lock(&irq->irq_lock);
+
+	if (!irq->hw)
+		goto unlock;
+
+	WARN_ON(irq_get_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, &active));
+
+	if (active)
+		irq_set_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, false);
+
+	kvm_vgic_unmap_irq(irq);
+	irq_set_vcpu_affinity(host_irq, NULL);
+
+unlock:
+	spin_unlock(&irq->irq_lock);
+	vgic_put_irq(kvm, irq);
+}
+
-- 
2.5.5
