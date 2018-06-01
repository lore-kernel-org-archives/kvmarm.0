From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 28/33] KVM: arm/arm64: Remove kvm_vgic_vcpu_early_init
Date: Fri,  1 Jun 2018 16:27:42 +0100
Message-ID: <20180601152747.23613-29-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01BCD4A12D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:22:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6YQmJOukjG1W for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:22:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7394A178
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:18:12 -0400 (EDT)
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

kvm_vgic_vcpu_early_init gets called after kvm_vgic_cpu_init which
is confusing. The call path is as follows:
kvm_vm_ioctl_create_vcpu
|_ kvm_arch_cpu_create
   |_ kvm_vcpu_init
      |_ kvm_arch_vcpu_init
         |_ kvm_vgic_vcpu_init
|_ kvm_arch_vcpu_postcreate
   |_ kvm_vgic_vcpu_early_init

Static initialization currently done in kvm_vgic_vcpu_early_init()
can be moved to kvm_vgic_vcpu_init(). So let's move the code and
remove kvm_vgic_vcpu_early_init(). kvm_arch_vcpu_postcreate() does
nothing.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h        |  1 -
 virt/kvm/arm/arm.c            |  1 -
 virt/kvm/arm/vgic/vgic-init.c | 80 ++++++++++++++++-------------------
 3 files changed, 37 insertions(+), 45 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 90e489f685ae..08ccbe37dcda 100644
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
index 39e777155e7c..126b98fbf9ba 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -292,7 +292,6 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
-	kvm_vgic_vcpu_early_init(vcpu);
 }
 
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 8901b2d8fca1..272af9704952 100644
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
@@ -224,13 +184,47 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
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
+	int ret = 0;
+	int i;
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
2.17.1
