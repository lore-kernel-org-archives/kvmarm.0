From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v7 08/13] KVM: arm/arm64: Remove kvm_vgic_vcpu_early_init
Date: Sun, 20 May 2018 23:22:47 +0200
Message-ID: <1526851372-13009-9-git-send-email-eric.auger@redhat.com>
References: <1526851372-13009-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526851372-13009-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

kvm_vgic_vcpu_early_init gets called after kvm_vgic_cpu_init which
is confusing. The call path is as follows:
kvm_vm_ioctl_create_vcpu
|_ kvm_arch_cpu_create
   |_ kvm_vcpu_init
      |_ kvm_vgic_vcpu_init
|_ kvm_arch_vcpu_postcreate
   |_ kvm_vgic_vcpu_early_init

Static initialization currently done in kvm_vgic_vcpu_early_init()
can be moved to kvm_vgic_vcpu_init(). So let's move the code and
remove kvm_vgic_vcpu_early_init(). kvm_arch_vcpu_postcreate() does
not nothing.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/kvm/arm_vgic.h        |  1 -
 virt/kvm/arm/arm.c            |  1 -
 virt/kvm/arm/vgic/vgic-init.c | 79 ++++++++++++++++++++-----------------------
 3 files changed, 36 insertions(+), 45 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 90e489f..08ccbe3 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -338,7 +338,6 @@ void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
-void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a4c1b76..e90fff2 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -290,7 +290,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
-	kvm_vgic_vcpu_early_init(vcpu);
 }
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 8901b2d..f8750d7 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -44,7 +44,7 @@
  *
  * CPU Interface:
  *
- * - kvm_vgic_vcpu_early_init(): initialization of static data that
+ * - kvm_vgic_vcpu_init(): initialization of static data that
  *   doesn't depend on any sizing information or emulation type. No
  *   allocation is allowed there.
  */
@@ -67,46 +67,6 @@ void kvm_vgic_early_init(struct kvm *kvm)
 	spin_lock_init(&dist->lpi_list_lock);
 }
 
-/**
- * kvm_vgic_vcpu_early_init() - Initialize static VGIC VCPU data structures
- * @vcpu: The VCPU whose VGIC data structures whould be initialized
- *
- * Only do initialization, but do not actually enable the VGIC CPU interface
- * yet.
- */
-void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
-{
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
-	int i;
-
-	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
-	spin_lock_init(&vgic_cpu->ap_list_lock);
-
-	/*
-	 * Enable and configure all SGIs to be edge-triggered and
-	 * configure all PPIs as level-triggered.
-	 */
-	for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
-		struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
-
-		INIT_LIST_HEAD(&irq->ap_list);
-		spin_lock_init(&irq->irq_lock);
-		irq->intid = i;
-		irq->vcpu = NULL;
-		irq->target_vcpu = vcpu;
-		irq->targets = 1U << vcpu->vcpu_id;
-		kref_init(&irq->refcount);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled = 1;
-			irq->config = VGIC_CONFIG_EDGE;
-		} else {
-			/* PPIs */
-			irq->config = VGIC_CONFIG_LEVEL;
-		}
-	}
-}
-
 /* CREATION */
 
 /**
@@ -224,13 +184,46 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
 }
 
 /**
- * kvm_vgic_vcpu_init() - Register VCPU-specific KVM iodevs
+ * kvm_vgic_vcpu_init() - Initialize static VGIC VCPU data
+ * structures and register VCPU-specific KVM iodevs
+ *
  * @vcpu: pointer to the VCPU being created and initialized
+ *
+ * Only do initialization, but do not actually enable the
+ * VGIC CPU interface
  */
 int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	int ret = 0;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	int i, ret;
+
+	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	spin_lock_init(&vgic_cpu->ap_list_lock);
+
+	/*
+	 * Enable and configure all SGIs to be edge-triggered and
+	 * configure all PPIs as level-triggered.
+	 */
+	for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+		struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
+
+		INIT_LIST_HEAD(&irq->ap_list);
+		spin_lock_init(&irq->irq_lock);
+		irq->intid = i;
+		irq->vcpu = NULL;
+		irq->target_vcpu = vcpu;
+		irq->targets = 1U << vcpu->vcpu_id;
+		kref_init(&irq->refcount);
+		if (vgic_irq_is_sgi(i)) {
+			/* SGIs */
+			irq->enabled = 1;
+			irq->config = VGIC_CONFIG_EDGE;
+		} else {
+			/* PPIs */
+			irq->config = VGIC_CONFIG_LEVEL;
+		}
+	}
 
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return 0;
-- 
2.5.5
