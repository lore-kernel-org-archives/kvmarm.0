From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 45/55] KVM: arm64: vgic-its: Generalize use of vgic_get_irq_kref
Date: Fri, 22 Jul 2016 18:29:02 +0100
Message-ID: <1469208552-4155-46-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Dan Carpenter <dan.carpenter@oracle.com>, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Instead of sprinkling raw kref_get() calls everytime we cannot
do a normal vgic_get_irq(), use the existing vgic_get_irq_kref(),
which does the same thing and is paired with a vgic_put_irq().

vgic_get_irq_kref is moved to vgic.h in order to be easily shared.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c |  2 +-
 virt/kvm/arm/vgic/vgic.c     | 10 +---------
 virt/kvm/arm/vgic/vgic.h     |  8 ++++++++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d8e8f14..f427fa2 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -80,7 +80,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
 		 * call vgic_put_irq() on the returned pointer once it's
 		 * finished with the IRQ.
 		 */
-		kref_get(&irq->refcount);
+		vgic_get_irq_kref(irq);
 
 		goto out_unlock;
 	}
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 424cb9c..39f3358 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -71,7 +71,7 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 		 * This increases the refcount, the caller is expected to
 		 * call vgic_put_irq() later once it's finished with the IRQ.
 		 */
-		kref_get(&irq->refcount);
+		vgic_get_irq_kref(irq);
 		goto out_unlock;
 	}
 	irq = NULL;
@@ -106,14 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	return NULL;
 }
 
-static void vgic_get_irq_kref(struct vgic_irq *irq)
-{
-	if (irq->intid < VGIC_MIN_LPI)
-		return;
-
-	kref_get(&irq->refcount);
-}
-
 /*
  * We can't do anything in here, because we lack the kvm pointer to
  * lock and remove the item from the lpi_list. So we keep this function
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 9d40d7b..1d8e21d 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -64,6 +64,14 @@ int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
+static inline void vgic_get_irq_kref(struct vgic_irq *irq)
+{
+	if (irq->intid < VGIC_MIN_LPI)
+		return;
+
+	kref_get(&irq->refcount);
+}
+
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
-- 
2.8.1

